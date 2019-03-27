 //
//  PhidgetManagerController.m
//  Phidgets
//
//  Created by Phidgets on 2016-01-13.
//  Copyright © 2016 Phidgets. All rights reserved.
//

#import "PhidgetManagerController.h"

#pragma mark Attach/Detach
void manGotAttach(PhidgetManagerHandle phidm, void *context, PhidgetHandle phid) {
    [(__bridge id)context performSelectorOnMainThread:@selector(phidgetManAdded:)
                                           withObject:[NSValue valueWithPointer:phid]
                                        waitUntilDone:YES];
}

void manGotDetach(PhidgetManagerHandle phidm, void *context, PhidgetHandle phid) {
    [(__bridge id)context performSelectorOnMainThread:@selector(phidgetManRemoved:)
                                           withObject:[NSValue valueWithPointer:phid]
                                        waitUntilDone:YES];
}

@implementation PhidgetManagerController

NSArray *tableData;
BOOL serverDetailsSet = NO;
NSString *serverName;

-(void)awakeFromNib{
    [super awakeFromNib];
    phidgets = [[PhidgetTreeNode alloc] initWithName:@"Phidgets"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showServerButton)
                                                 name:@"ShowServerButton"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideServerButton)
                                                 name:@"HideServerButton"
                                               object:nil];
    
    PhidgetManager_create(&phidMan);
    PhidgetManager_setOnAttachHandler(phidMan, manGotAttach, (__bridge void*)self);
    PhidgetManager_setOnDetachHandler(phidMan, manGotDetach, (__bridge void*)self);
    
    serverName = [[NSUserDefaults standardUserDefaults] objectForKey:@"ServerName"];
    NSString *serverPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"ServerPassword"];
    NSString *hostName = [[NSUserDefaults standardUserDefaults] objectForKey:@"ServerHostname"];
    NSString *port = [[NSUserDefaults standardUserDefaults] objectForKey:@"ServerPort"];
    
    if(serverDetailsSet){
        PhidgetNet_disableServerDiscovery(PHIDGETSERVER_DEVICEREMOTE);
        PhidgetNet_addServer([serverName UTF8String], [hostName UTF8String], [port intValue], [serverPassword UTF8String],0);
    }
    else{
        PhidgetNet_enableServerDiscovery(PHIDGETSERVER_DEVICEREMOTE);
    }
    
    PhidgetManager_open(phidMan);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark adding/removing phidget manager
- (void)phidgetManAdded:(NSValue *)ch{
    PhidgetHandle child;
    PhidgetHandle parent;
    PhidgetTreeNode *childNode;
    PhidgetTreeNode *parentNode;
    
    child = (PhidgetHandle)[ch pointerValue];
    childNode = [[PhidgetChannel alloc] initWithHandle:child];
    
    if(((PhidgetChannel *)childNode).chClass == PHIDCHCLASS_MESHDONGLE || ((PhidgetChannel *)childNode).chClass == PHIDCHCLASS_HUB)
        return;
    
    //Find or add the computer node
    PhidgetTreeNode *rootNode = [[ComputerNode alloc] initWithHandle:child];
    PhidgetTreeNode *foundComputerNode = [PhidgetTreeNode FindNode:rootNode inTree:phidgets];
    if(foundComputerNode == nil) {
        [phidgets.children addObject:rootNode];
        rootNode.parent = phidgets;
        [phidgets sort];
        //[self.phidgetTreeView reloadData];
    }
    else
        rootNode = foundComputerNode;
    
    Phidget_getParent(child, &parent);
    do {
        // Create or find parent node and add child
        parentNode = [[PhidgetDevice alloc] initWithHandle:parent];
        PhidgetTreeNode *foundNode = [PhidgetTreeNode FindNode:parentNode inTree:rootNode];
        parentNode = (foundNode == nil ? parentNode : foundNode);
        [parentNode.children addObject:childNode];
        [parentNode sort];
        childNode.parent = parentNode;
        
        // Parent was already in the tree, done
        if(foundNode != nil)
            break;
        
        // VINT Device? Add/find the hub port node
        if(((PhidgetDevice *)parentNode).devClass == PHIDCLASS_VINT) {
            PhidgetTreeNode *portNode = [[HubPortNode alloc]
                                         initWithPortNumber:((PhidgetDevice *)parentNode).hubPort
                                         andSerial:((PhidgetDevice *)parentNode).devSerial];
            foundNode = [PhidgetTreeNode FindNode:portNode inTree:rootNode];
            portNode = (foundNode == nil ? portNode : foundNode);
            [portNode.children addObject:parentNode];
            [portNode sort];
            parentNode.parent = portNode;
            parentNode = portNode;
            
            // Parent was already in the tree, done
            if(foundNode != nil)
                break;
        }
        
        child = parent;
        childNode = parentNode;
        Phidget_getParent(child, &parent);
        
    } while(parent);
    
    // Reached the top level, add to root
    if(!parent) {
        [rootNode.children addObject:parentNode];
        [rootNode sort];
        parentNode.parent = rootNode;
        //[self.phidgetTreeView reloadItem:rootNode reloadChildren:true];
    } else {
        //[self.phidgetTreeView reloadItem:parentNode reloadChildren:true];
    }

    [self updateTableViews];
}

- (void)phidgetManRemoved:(NSValue *)ch{
    PhidgetHandle child;
    PhidgetHandle parent;
    
    child = (PhidgetHandle)[ch pointerValue];
    Phidget_getParent(child, &parent);
    
    // Find and remove the parent node
    
    PhidgetTreeNode *parentNode = [[PhidgetDevice alloc] initWithHandle:parent];
    PhidgetTreeNode *node = [PhidgetTreeNode FindNode:parentNode inTree:phidgets];
    
    if(node != nil) {
        PhidgetTreeNode *parentNodeParent = node.parent;
        [node.parent.children removeObject:node];
        //[self.phidgetTreeView reloadItem:node.parent reloadChildren:YES];
        
        if(parentNodeParent.children.count == 0) {
            // Remove parent if it no longer has any children
            [parentNodeParent.parent.children removeObject:parentNodeParent];
            //[self.phidgetTreeView reloadData];
        } else if (!parentNodeParent.shouldExpand) {
            // Collapse the parent if it shouldn't be expanded
            //[self.phidgetTreeView collapseItem:parentNodeParent];
        }

        [self updateTableViews];
    }
}

-(void)updateTableViews{
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"PhidgetsUpdate" object:phidgets userInfo:nil];
}

#pragma mark Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"selectDevice"]) {
        TableViewController *vc = (TableViewController *)segue.destinationViewController;
        if(phidgets.children.count != 0)
            vc.treeNode = [phidgets.children objectAtIndex:selectedRow];
    }
    else if([segue.identifier isEqualToString:@"serverSegue"]){
        self.view.alpha = 0.5;
    }
}

#pragma mark unwind segues
- (IBAction)serverCancel:(UIStoryboardSegue *)segue
{
    self.view.alpha = 1.0;
}

- (IBAction)serverOK:(UIStoryboardSegue *)segue
{
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    ServerViewController *vc = (ServerViewController *)segue.sourceViewController;
    self.view.alpha = 1.0;
    [nc postNotificationName:@"PopToRoot" object:nil userInfo:nil];
    

    [[NSUserDefaults standardUserDefaults] setObject:vc.serverName.text forKey:@"ServerName"];
    [[NSUserDefaults standardUserDefaults] setObject:vc.serverPassword.text forKey:@"ServerPassword"];
    [[NSUserDefaults standardUserDefaults] setObject:vc.hostName.text forKey:@"ServerHostname"];
    [[NSUserDefaults standardUserDefaults] setObject:vc.port.text forKey:@"ServerPort"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"serverDetailsSet" object:nil userInfo:nil];
    PhidgetNet_disableServerDiscovery(PHIDGETSERVER_DEVICEREMOTE);
    PhidgetNet_addServer([serverName UTF8String], [vc.hostName.text UTF8String], [vc.port.text intValue], [vc.serverPassword.text UTF8String],0);
}
- (IBAction)removeServer:(UIStoryboardSegue *)segue
{
    self.view.alpha = 1.0;
    ServerViewController *vc = (ServerViewController *)segue.sourceViewController;
    PhidgetNet_removeServer([serverName UTF8String]);
    [vc.serverName setText:@""];
    [vc.serverPassword setText:@""];
    [vc.hostName setText:@""];
    [vc.port setText:@""];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ServerName"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ServerPassword"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ServerHostname"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ServerPort"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    PhidgetNet_enableServerDiscovery(PHIDGETSERVER_DEVICEREMOTE);
}

-(void)showServerButton{
    [serverButton setHidden:NO];
}
-(void)hideServerButton{
    [serverButton setHidden:YES];
}

@end
