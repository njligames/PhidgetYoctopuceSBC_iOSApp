//
//  DigitalOutputViewController.m
//  Phidgets
//
//  Created by Phidgets on 2016-01-14.
//  Copyright © 2016 Phidgets. All rights reserved.
//

#import "DigitalOutputViewController.h"

NSArray *pickerArray;
@implementation DigitalOutputViewController

#pragma mark Event callbacks
static void gotAttach(PhidgetHandle phid, void *context) {
        [(__bridge id)context performSelectorOnMainThread:@selector(onAttachHandler)
                                               withObject:nil
                                            waitUntilDone:NO];
}

static void gotDetach(PhidgetHandle phid, void *context) {
        [(__bridge id)context performSelectorOnMainThread:@selector(onDetachHandler)
                                               withObject:nil
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
-(void)viewDidLoad{
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
    
    
    // Do any additional setup after loading the view.
    result = PhidgetDigitalOutput_create(&ch);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to create digital output" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_setOnAttachHandler((PhidgetHandle)ch,gotAttach,(__bridge void*)self);
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
        [self outputError:@"Failed to assign attach handler" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_setChannel((PhidgetHandle)ch, self.channel);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to set channel" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_setDeviceSerialNumber((PhidgetHandle)ch, self.serialNumber);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to set device serial number" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_setHubPort((PhidgetHandle)ch, self.hubPort);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to set hub port" message:[NSString stringWithUTF8String:errorMessage]];
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
        [self outputError:@"Failed to set on attach handler" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_setOnDetachHandler((PhidgetHandle)ch, nil, nil);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to set on detach handler" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_close((PhidgetHandle)ch);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to close channel" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = PhidgetDigitalOutput_delete(&(ch));
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to delete channel" message:[NSString stringWithUTF8String:errorMessage]];
    }
    //re-enable swipe back
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
    else{
        NSLog(@"Error, object not recognized.");
    }
}

-(void)popToRoot:(NSNotification *) notification{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark Attach, detach, and error event
- (void)onAttachHandler{
    BOOL state;
    PhidgetReturnCode result;
    Phidget_DeviceID deviceID;
    Phidget_ChannelSubclass channelSubClass;
    [phidgetInfoBox fillPhidgetInfo:(PhidgetHandle)ch];
    result = Phidget_getChannelSubclass((PhidgetHandle)ch, &channelSubClass);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to get channel sub class" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_getDeviceID((PhidgetHandle)ch, &deviceID);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to get device id" message:[NSString stringWithUTF8String:errorMessage]];
    }
    
    [stackView setHidden:NO];
    
    if(deviceID == PHIDID_1031 || deviceID == PHIDID_1032 || deviceID == PHIDID_LED1000){
        double maxLEDCurrent, minLEDCurrent, LEDCurrentLimit;
        result = PhidgetDigitalOutput_getMaxLEDCurrentLimit(ch, &maxLEDCurrent);
        if(result != EPHIDGET_OK){
            const char* errorMessage;
            Phidget_getErrorDescription(result, &errorMessage);
            [self outputError:@"Failed to get max LED current" message:[NSString stringWithUTF8String:errorMessage]];
        }
        result = PhidgetDigitalOutput_getMinLEDCurrentLimit(ch, &minLEDCurrent);
        if(result != EPHIDGET_OK){
            const char* errorMessage;
            Phidget_getErrorDescription(result, &errorMessage);
            [self outputError:@"Failed to get min LED current" message:[NSString stringWithUTF8String:errorMessage]];
        }
        result = PhidgetDigitalOutput_getLEDCurrentLimit(ch, &LEDCurrentLimit);
        if(result != EPHIDGET_OK){
            const char* errorMessage;
            Phidget_getErrorDescription(result, &errorMessage);
            [self outputError:@"Failed to get LED current limit" message:[NSString stringWithUTF8String:errorMessage]];
        }
        [currentLimitSlider setMinimumValue:minLEDCurrent*1000];
        [currentLimitSlider setMaximumValue:maxLEDCurrent*1000];
        [currentLimitSlider setValue:LEDCurrentLimit*1000];
        [currentLimitLabel setText:[NSString stringWithFormat:@"%.0f mA", LEDCurrentLimit*1000]];
        [currentLimitLabel setHidden:NO];
        [currentLimitTitleLabel setHidden:NO];
        [currentLimitSlider setHidden:NO];
        [forwardVoltageButton setHidden:NO];
        if(deviceID == PHIDID_LED1000){
            pickerArray = [[NSArray alloc]initWithObjects:@"3.2V",@"4.0V",@"4.8V",@"5.6V", nil];
        }
        else{
            pickerArray = [[NSArray alloc]initWithObjects:@"1.7V",@"2.75V",@"3.9V",@"5.0V", nil];
        }
    }
    else{
        [currentLimitLabel setHidden:YES];
        [currentLimitTitleLabel setHidden:YES];
        [currentLimitSlider setHidden:YES];
        [forwardVoltageButton setHidden:YES];
    }
    
    
    if(channelSubClass == PHIDCHSUBCLASS_DIGITALOUTPUT_DUTY_CYCLE || channelSubClass == PHIDCHSUBCLASS_DIGITALOUTPUT_LED_DRIVER){
        double dutyCycle;
        state = YES;
        result = PhidgetDigitalOutput_getDutyCycle(ch, &dutyCycle);
        if(result != EPHIDGET_OK){
            const char* errorMessage;
            Phidget_getErrorDescription(result, &errorMessage);
            [self outputError:@"Failed to get duty cycle" message:[NSString stringWithUTF8String:errorMessage]];
        }
        [dutyCycleLabel setText:[NSString stringWithFormat:@"%.2f",dutyCycle]];
        [dutyCycleSlider setValue:dutyCycle];
    }
    else{
        int currentState;
        result = PhidgetDigitalOutput_getState(ch, &currentState);
        if(result != EPHIDGET_OK){
            const char* errorMessage;
            Phidget_getErrorDescription(result, &errorMessage);
            [self outputError:@"Failed to get state" message:[NSString stringWithUTF8String:errorMessage]];
        }
        [dutyCycleSlider setValue:currentState ? 1.0 : 0.0];
        [dutyCycleLabel setText: currentState ? @"1.00" : @"0.00"];
        [dutyCycleButton setTitle:currentState ? @"Off" : @"On" forState:UIControlStateNormal];
        state = NO;
    }
    
    [dutyCycleSlider setEnabled:state];
}

- (void)onDetachHandler{
    [phidgetInfoBox fillPhidgetInfo:nil];
    [stackView setHidden:YES];
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

#pragma mark GUI controls
- (IBAction)dutyCycleChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    PhidgetReturnCode result;
    [dutyCycleLabel setText:[NSString stringWithFormat:@"%0.2f", slider.value]];
    result = PhidgetDigitalOutput_setDutyCycle(ch, slider.value);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to set duty cycle" message:[NSString stringWithUTF8String:errorMessage]];
    }
}
- (IBAction)dutyCycleOn:(id)sender {
    UIButton *button = (UIButton *)sender;
    int state;
    PhidgetReturnCode result = PhidgetDigitalOutput_getState(ch, &state);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to get digital output state" message:[NSString stringWithUTF8String:errorMessage]];
    }
    state = state ? 0 : 1;
    result = PhidgetDigitalOutput_setState(ch, state);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to set digital output state" message:[NSString stringWithUTF8String:errorMessage]];
    }
    [dutyCycleSlider setValue:state ? 1.0 : 0.0];
    [dutyCycleLabel setText: state ? @"1.00" : @"0.00"];
    [button setTitle:state ? @"Off" : @"On" forState:UIControlStateNormal];
}
- (IBAction)currentLimitChange:(id)sender {
    UISlider *slider = (UISlider *)sender;
    PhidgetReturnCode result;
    [currentLimitLabel setText:[NSString stringWithFormat:@"%d mA",(int)slider.value]];
    result = PhidgetDigitalOutput_setLEDCurrentLimit(ch, slider.value/1000);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to set LED current limit" message:[NSString stringWithUTF8String:errorMessage]];
    }
}
- (IBAction)currentLimitDragged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [currentLimitLabel setText:[NSString stringWithFormat:@"%d mA",(int)slider.value]];
}
-(void)dimBackground{
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.5;
    backgroundView.tag = 99;
    [self.navigationController.view addSubview:backgroundView];
}

#pragma mark navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"phidgetInfoBoxSegue"]) {
        // can't assign the view controller from an embed segue via the storyboard, so capture here
        phidgetInfoBox = (PhidgetInfoBoxViewController *)segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:@"forwardVoltageSegue"]) {
        PickerViewController *vc = (PickerViewController *)segue.destinationViewController;
        [self dimBackground];
        vc.pickerArray = pickerArray;
        vc.titleName = @"Forward Voltage";
        vc.digitalOutput = ch;
    }
}

- (IBAction)digitalOutputDone:(UIStoryboardSegue *)segue{
    [[self.navigationController.view viewWithTag:99] removeFromSuperview];
}

@end
