//
//  TableViewController.m
//  Phidgets
//
//  Created by Phidgets on 2016-03-09.
//  Copyright © 2016 Phidgets. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end


@implementation TableViewController

@synthesize treeNode = treeNode;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Add children to display
    for(int i = 0; i < treeNode.children.count; i++){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
    
    //set up refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refreshTable)
                  forControlEvents:UIControlEventValueChanged];
    
    //Add observers 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(phidgetsUpdate:)
                                                 name:@"PhidgetsUpdate"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(popToRoot:)
                                                 name:@"PopToRoot"
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    if(self.navigationController.topViewController == self.navigationController.viewControllers.firstObject){
        [nc postNotificationName:@"ShowServerButton" object:nil userInfo:nil];
    }
    else {
        [nc postNotificationName:@"HideServerButton" object:nil userInfo:nil];
    }
}

-(void)refreshTable{
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

-(void)phidgetsUpdate:(NSNotification *) notification{
    if ([notification.object isKindOfClass:[PhidgetTreeNode class]])
    {
        PhidgetTreeNode *tempNode = [PhidgetTreeNode FindNode:treeNode inTree:(PhidgetTreeNode *)[notification object]];
        if(tempNode == nil){
            treeNode = [notification object];
            if(self.navigationController.visibleViewController == self){
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }
    else{
        NSLog(@"Error, object not recognized.");
    }
    [self.tableView reloadData];
}

-(void)popToRoot:(NSNotification *) notification{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewController *tableController = [[TableViewController alloc] initWithStyle:UITableViewStylePlain];
    NSInteger rowNum = indexPath.row;
    if([treeNode isKindOfClass:[HubPortNode class]]){
        HubPortNode *hubPortNode = (HubPortNode *)treeNode;
        if([hubPortNode childCountForTable] == 1){//vint device
            int i = 0;
            for (PhidgetDevice *ch in treeNode.children) {
                if(!ch.hubPortDevice)
                    break;
                i++;
            }
            rowNum = i;
        }
    }
    PhidgetTreeNode *node = [treeNode.children objectAtIndex:rowNum];
    if(node.canExpand){
        tableController.treeNode = node;
        tableController.title = node.name;
        self.navigationItem.backBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@""
                                         style:UIBarButtonItemStylePlain
                                        target:nil
                                        action:nil];
        [self.navigationController pushViewController:tableController animated:YES]; 
    }
    else{
        PhidgetChannel *channel;
        PhidgetDevice *device;
        if ([node isKindOfClass:[PhidgetChannel class]]) {
            channel = (PhidgetChannel *)node;
            device = (PhidgetDevice *)channel.parent;
        } else if ([node isKindOfClass:[PhidgetDevice class]]) {
            device = (PhidgetDevice *)node;
            channel = device.children[0];
        } else {
            return;
        }
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        if(channel.chClass == PHIDCHCLASS_DIGITALOUTPUT){
            DigitalOutputViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"DigitalOutput"];
            vc.channel = channel.channel.intValue;
            vc.serialNumber = device.devSerial;
            vc.hubPort = device.hubPort;
            vc.isHubPort = device.hubPortDevice;
            vc.title = node.name;
            vc.treeNode = node;
            self.navigationItem.backBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                            target:nil
                                            action:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(channel.chClass == PHIDCHCLASS_DIGITALINPUT){
            DigitalInputViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"DigitalInput"];
            vc.channel = channel.channel.intValue;
            vc.serialNumber = device.devSerial;
            vc.hubPort = device.hubPort;
            vc.isHubPort = device.hubPortDevice;
            vc.title = node.name;
            vc.treeNode = node;
            self.navigationItem.backBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                            target:nil
                                            action:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(channel.chClass == PHIDCHCLASS_VOLTAGEINPUT){
            VoltageInputViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"VoltageInput"];
            vc.channel = channel.channel.intValue;
            vc.serialNumber = device.devSerial;
            vc.hubPort = device.hubPort;
            vc.isHubPort = device.hubPortDevice;
            vc.title = node.name;
            vc.treeNode = node;
            self.navigationItem.backBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                            target:nil
                                            action:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(channel.chClass == PHIDCHCLASS_VOLTAGERATIOINPUT){
            VoltageRatioViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"VoltageRatio"];
            vc.channel = channel.channel.intValue;
            vc.serialNumber = device.devSerial;
            vc.hubPort = device.hubPort;
            vc.isHubPort = device.hubPortDevice;
            vc.title = node.name;
            vc.treeNode = node;
            self.navigationItem.backBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                            target:nil
                                            action:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"noExamples"];
            vc.title = @"Sorry...";
            self.navigationItem.backBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                            target:nil
                                            action:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = ![treeNode isKindOfClass:[HubPortNode class]] ? treeNode.children.count : treeNode.children.count > 4 ? 1 : treeNode.children.count;
    if (count == 0)
        return 1;
    
    return count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *DiscoveredCellIdentifier = @"DiscoveredPhidget";
    static NSString *SearchingCellIdentifier = @"Searching";
    NSInteger rowNum = indexPath.row;
    if([treeNode isKindOfClass:[HubPortNode class]]){
        HubPortNode *hubPortNode = (HubPortNode *)treeNode;
        if([hubPortNode childCountForTable] == 1){//vint device
            int i = 0;
            for (PhidgetDevice *ch in treeNode.children) {
                if(!ch.hubPortDevice)
                    break;
                i++;
            }
            rowNum = i;
        }
    }
    NSUInteger count = treeNode.children.count;
    if (count == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchingCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SearchingCellIdentifier];
        }
        // If there are no services and searchingForServicesString is set, show one row explaining that to the user.
        cell.textLabel.text = @"Searching for Phidgets...";
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.text = @"";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11.0];
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.textColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        CGRect frame = CGRectMake(0.0, 0.0, 20.0, 20.0);
        UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithFrame:frame];
        [spinner startAnimating];
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [spinner sizeToFit];
        spinner.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                    UIViewAutoresizingFlexibleRightMargin |
                                    UIViewAutoresizingFlexibleTopMargin |
                                    UIViewAutoresizingFlexibleBottomMargin);
        cell.accessoryView = spinner;
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DiscoveredCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SearchingCellIdentifier];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14.5];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11.0];
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        
    }
    
    NSString *serialNumberForTable, *channelForTable, *versionForTable;
    if(((PhidgetChannel*)[treeNode.children objectAtIndex:rowNum]).serialNumberForTable != nil)
        serialNumberForTable = [NSString stringWithFormat:@"Serial: %@",((PhidgetChannel*)[treeNode.children objectAtIndex:rowNum]).serialNumberForTable];
    else
        serialNumberForTable = @"";
    if(((PhidgetChannel*)[treeNode.children objectAtIndex:rowNum]).channelForTable != nil)
        channelForTable = [NSString stringWithFormat:@"Channel: %@",((PhidgetChannel*)[treeNode.children objectAtIndex:rowNum]).channelForTable];
    else
        channelForTable = @"";
    if(((PhidgetChannel*)[treeNode.children objectAtIndex:rowNum]).versionForTable != nil)
        versionForTable = [NSString stringWithFormat:@"Version: %@",((PhidgetChannel*)[treeNode.children objectAtIndex:rowNum]).versionForTable];
    else
        versionForTable = @"";

    // Configure the cell.
    cell.textLabel.text = ((PhidgetTreeNode *)[treeNode.children objectAtIndex:rowNum]).name;
    if(serialNumberForTable.length || channelForTable.length || versionForTable.length){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ %@", serialNumberForTable, channelForTable, versionForTable];
    }
    
    return cell;
}

@end
