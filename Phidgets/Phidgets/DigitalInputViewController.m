//
//  DigitalInputViewController.m
//  Phidgets
//
//  Created by Phidgets on 2016-01-15.
//  Copyright © 2016 Phidgets. All rights reserved.
//

#import "DigitalInputViewController.h"

@interface DigitalInputViewController ()

@end

@implementation DigitalInputViewController

#pragma mark Event callbacks
static void gotAttach(PhidgetHandle phid, void *context) {
    [(__bridge id)context performSelectorOnMainThread:@selector(onAttachHandler:)
                                           withObject:nil
                                        waitUntilDone:NO];
}

static void gotDetach(PhidgetHandle phid, void *context) {
    [(__bridge id)context performSelectorOnMainThread:@selector(onDetachHandler)
                                           withObject:nil
                                        waitUntilDone:NO];
}

static void gotStateChange(PhidgetDigitalInputHandle phid, void *context,int state) {
    [(__bridge id)context performSelectorOnMainThread:@selector(onStateChangeHandler:)
                                           withObject:[NSNumber numberWithInt:state]
                                        waitUntilDone:NO];
}

static void gotError(PhidgetHandle phid, void *context, Phidget_ErrorEventCode errorCode, const char *errorString){
    NSString *errorTitle = [NSString stringWithFormat:@"Error Code:%d", errorCode];
    NSString *errorMessage = [NSString stringWithUTF8String:errorString];
    [(__bridge id)context performSelectorOnMainThread:@selector(errorHandler:)
                                           withObject:[NSArray arrayWithObjects:errorTitle,errorMessage, nil]
                                        waitUntilDone:NO];
}


#pragma mark view management
- (void)viewDidLoad {
    PhidgetReturnCode result;
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(phidgetsUpdate:)
                                                 name:@"PhidgetsUpdate"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(popToRoot:)
                                                 name:@"PopToRoot"
                                               object:nil];
    
    result = PhidgetDigitalInput_create(&ch);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to create digital input" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_setOnAttachHandler((PhidgetHandle)ch, gotAttach, (__bridge void*)self);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to assign attach handler" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_setOnDetachHandler((PhidgetHandle)ch, gotDetach, (__bridge void*)self);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to assign detach handler" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_setOnErrorHandler((PhidgetHandle)ch, gotError, (__bridge void*)self);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to assign detach handler" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = PhidgetDigitalInput_setOnStateChangeHandler(ch, gotStateChange, (__bridge void*)self);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to assign state change handler" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_setChannel((PhidgetHandle)ch, self.channel);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to set channel" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_setHubPort((PhidgetHandle)ch, self.hubPort);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to set hub port" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_setDeviceSerialNumber((PhidgetHandle)ch, self.serialNumber);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to set serial number" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_setIsHubPortDevice((PhidgetHandle)ch, self.isHubPort);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to set is hub port" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = PhidgetNet_enableServerDiscovery(PHIDGETSERVER_DEVICEREMOTE);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to enable server discovery" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_open((PhidgetHandle)ch);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to open channel" message:[NSString stringWithUTF8String:errorMessage]];
    }
    //disable swipe back because of uisliders
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    PhidgetReturnCode result;
    result = Phidget_setOnAttachHandler((PhidgetHandle)ch, nil, nil);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to assign attach handler" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_setOnDetachHandler((PhidgetHandle)ch, nil, nil);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to assign detach handler" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_setOnErrorHandler((PhidgetHandle)ch, nil, nil);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to set on error handler" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = PhidgetDigitalInput_setOnStateChangeHandler(ch, nil, nil);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to set on state change handler" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_close((PhidgetHandle)ch);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to close channel" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = PhidgetDigitalInput_delete(&ch);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to delete channel" message:[NSString stringWithUTF8String:errorMessage]];
    }
    //re-enable swipe back because of uisliders
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}

-(void)phidgetsUpdate:(NSNotification *) notification{
    if ([notification.object isKindOfClass:[PhidgetTreeNode class]])
    {
        PhidgetTreeNode *tempNode = [PhidgetTreeNode FindNode:self.treeNode.parent inTree:(PhidgetTreeNode *)[notification object]];
        if(tempNode == nil){
            if(self.navigationController.visibleViewController == self){
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }
    else
    {
        NSLog(@"Error, object not recognized.");
    }
}

-(void)popToRoot:(NSNotification *) notification{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark Attach, detach, error, and event handlers
- (void)onAttachHandler:(id)nothing{
    [phidgetInfoBox fillPhidgetInfo:(PhidgetHandle)ch];
    [stateLabel setHidden:NO];
}

- (void)onDetachHandler{
    [phidgetInfoBox fillPhidgetInfo:nil];
    
    //Hide view
    [stateLabel setHidden:YES];
}

-(void)errorHandler:(NSArray *)array{
    [self outputError:[array objectAtIndex:0] message:[array objectAtIndex:1]];
}

-(void)outputError:(NSString *)errorTitle
           message:(NSString *)errorMessage{
    static NSTimeInterval timeStamp = 0, lastTimeStamp = 0;
    timeStamp = [NSDate timeIntervalSinceReferenceDate];
    if(timeStamp - lastTimeStamp > 5){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:errorTitle
                                                                                 message:errorMessage
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        lastTimeStamp = timeStamp;
    }
}

-(void)onStateChangeHandler:(NSNumber*) state{
    if(state.intValue)
        [stateLabel setText:@"True"];
    else
        [stateLabel setText:@"False"];
    
}

#pragma mark Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"phidgetInfoBoxSegue"]) {
        // can't assign the view controller from an embed segue via the storyboard, so capture here
        phidgetInfoBox = (PhidgetInfoBoxViewController *)segue.destinationViewController;
    }
}


@end
