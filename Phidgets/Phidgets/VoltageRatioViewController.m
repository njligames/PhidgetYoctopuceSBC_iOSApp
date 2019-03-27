//
//  VoltageRatioViewController.m
//  Phidgets
//
//  Created by Phidgets on 2016-01-15.
//  Copyright © 2016 Phidgets. All rights reserved.
//

#import "VoltageRatioViewController.h"

@interface VoltageRatioViewController ()

@end

@implementation VoltageRatioViewController

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

static void gotSensorChange(PhidgetVoltageRatioInputHandle phid, void *context , double sensorValue, Phidget_UnitInfo *sensorUnit){
    [(__bridge id)context performSelectorOnMainThread:@selector(onSensorChangeHandler:)
                                           withObject:[NSArray arrayWithObjects:[NSNumber numberWithDouble:sensorValue], [NSString stringWithUTF8String:sensorUnit->symbol], nil]
                                        waitUntilDone:NO];
}

static void gotVoltageRatioChange(PhidgetVoltageRatioInputHandle phid, void *context,double voltageRatio) {
        [(__bridge id)context performSelectorOnMainThread:@selector(onVoltageRatioChangeHandler:)
                                               withObject:[NSNumber numberWithDouble:voltageRatio]
                                            waitUntilDone:NO];
}

static void gotError(PhidgetHandle phid, void *context, Phidget_ErrorEventCode errorCode, const char *errorString){
    NSString *errorTitle = [NSString stringWithFormat:@"Error Code:%d", errorCode];
    NSString *errorMessage = [NSString stringWithUTF8String:errorString];
    [(__bridge id)context performSelectorOnMainThread:@selector(errorHandler:)
                                           withObject:[NSArray arrayWithObjects:errorTitle,errorMessage, nil]
                                        waitUntilDone:NO];
}

#pragma mark view load/disappear
NSMutableArray *bridgeGainArray, *sensorArray;
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
    
    bridgeGainArray = [[NSMutableArray alloc] init];
    sensorArray = [[NSMutableArray alloc] init];
    result = PhidgetVoltageRatioInput_create(&ch);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to create channel" message:[NSString stringWithUTF8String:errorMessage]];
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
        [self outputError:@"Failed to assign error handler" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = PhidgetVoltageRatioInput_setOnVoltageRatioChangeHandler(ch, gotVoltageRatioChange, (__bridge void*)self);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to assign voltage ch change handler" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = PhidgetVoltageRatioInput_setOnSensorChangeHandler(ch, gotSensorChange, (__bridge void*)self);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to assign sensor change handler" message:[NSString stringWithUTF8String:errorMessage]];
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
        [self outputError:@"Failed to set device serial number" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_setIsHubPortDevice((PhidgetHandle)ch, self.isHubPort);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to set is hub port device" message:[NSString stringWithUTF8String:errorMessage]];
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
        [self outputError:@"Failed to assign error handler" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = PhidgetVoltageRatioInput_setOnVoltageRatioChangeHandler(ch, nil, nil);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to assign voltage ratio change handler" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_close((PhidgetHandle)ch);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to close channel" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = PhidgetVoltageRatioInput_delete(&ch);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to delete channel" message:[NSString stringWithUTF8String:errorMessage]];
    }
    //re-enable swipe back
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}

- (void)onAttachHandler{
    Phidget_ChannelSubclass channelSubClass;
    uint32_t minDataInterval, maxDataInterval, dataInterval;
    double minVoltageRatioChangeTrigger, maxVoltageRatioChangeTrigger, voltageRatioChangeTrigger;
    int bridgeEnabled;
    
    Phidget_DeviceID deviceID;
    PhidgetReturnCode result;

    
    //Manage views
    [phidgetInfoBox fillPhidgetInfo:(PhidgetHandle)ch];
    [stackView setHidden:NO];
    [sensorValueLabelTitle setHidden:YES];
    [sensorValueLabel setHidden:YES];
    [sensorTypeButton setHidden:YES];
    
    //Get information from device
    result = PhidgetVoltageRatioInput_getMinDataInterval(ch, &minDataInterval);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to get min data interval" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = PhidgetVoltageRatioInput_getMaxDataInterval(ch, &maxDataInterval);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to get max data interval" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = PhidgetVoltageRatioInput_getDataInterval(ch, &dataInterval);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to get data interval" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = PhidgetVoltageRatioInput_getMinVoltageRatioChangeTrigger(ch, &minVoltageRatioChangeTrigger);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to get min voltage ratio change trigger" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = PhidgetVoltageRatioInput_getMaxVoltageRatioChangeTrigger(ch, &maxVoltageRatioChangeTrigger);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to get max voltage ratio change trigger" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = PhidgetVoltageRatioInput_getVoltageRatioChangeTrigger(ch, &voltageRatioChangeTrigger);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to get voltage ratio change trigger" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_getDeviceID((PhidgetHandle)ch, &deviceID);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to get device ID" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_getChannelSubclass((PhidgetHandle)ch, &channelSubClass);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to get channel subclass" message:[NSString stringWithUTF8String:errorMessage]];
    }
   
    if(channelSubClass == PHIDCHSUBCLASS_VOLTAGERATIOINPUT_BRIDGE){
        result = PhidgetVoltageRatioInput_getBridgeEnabled(ch, &bridgeEnabled);
        if(result != EPHIDGET_OK){
            const char* errorMessage;
            Phidget_getErrorDescription(result, &errorMessage);
            [self outputError:@"Failed to get bridge enabled state" message:[NSString stringWithUTF8String:errorMessage]];
        }
        [bridgeGainTitle setHidden:NO];
        [bridgeGainEnabled setHidden:NO];
        [bridgeGainButton setHidden:NO];
        [sensorValueLabelTitle setHidden:YES];
        [sensorValueLabel setHidden:YES];
        [sensorTypeButton setHidden:YES];
        [bridgeGainArray removeAllObjects];
        [bridgeGainArray addObjectsFromArray:[NSArray arrayWithObjects:@"1x",@"8x",@"16x",@"32x",@"64x",@"128x", nil]];
        [bridgeGainEnabled setOn:bridgeEnabled];
    }
    else{
        [bridgeGainTitle setHidden:YES];
        [bridgeGainEnabled setHidden:YES];
        [bridgeGainButton setHidden:YES];
    }
    
    if(channelSubClass == PHIDCHSUBCLASS_VOLTAGERATIOINPUT_SENSOR_PORT){
        [sensorValueLabelTitle setHidden:NO];
        [sensorValueLabel setHidden:NO];
        [sensorTypeButton setHidden:NO];
        [sensorArray removeAllObjects];
        [sensorArray addObjectsFromArray:[NSArray arrayWithObjects:@"Generic ratiometric sensor",@"1101 - IR Distance Adapter, with Sharp Distance Sensor 2D120X (4-30cm)",@"1101 - IR Distance Adapter, with Sharp Distance Sensor 2Y0A21 (10-80cm)",@"1101 - IR Distance Adapter, with Sharp Distance Sensor 2Y0A02 (20-150cm)",@"1102 - IR Reflective Sensor 5mm",@"1103 - IR Reflective Sensor 10cm",@"1104 - Vibration Sensor",@"1105 - Light Sensor",@"1106 - Force Sensor",@"1107 - Humidity Sensor",@"1108 - Magnetic Sensor",@"1109 - Rotation Sensor",@"1110 - Touch Sensor",@"1111 - Motion Sensor",@"1112 - Slider 60",@"1113 - Mini Joy Stick Sensor",@"1115 - Pressure Sensor",@"1116 - Multi-turn Rotation Sensor",@"1118 - 50Amp Current Sensor AC",@"1118 - 50Amp Current Sensor DC",@"1119 - 20Amp Current Sensor DC",@"1120 - FlexiForce Adapter",@"1121 - Voltage Divider",@"1122 - 30 Amp Current Sensor AC",@"1122 - 30 Amp Current Sensor DC",@"1124 - Precision Temperature Sensor",@"1125 - Humidity Sensor",@"1125 - Temperature Sensor",@"1126 - Differential Air Pressure Sensor +- 25kPa",@"1128 - MaxBotix EZ-1 Sonar Sensor",@"1129 - Touch Sensor",@"1131 - Thin Force Sensor",@"1134 - Switchable Voltage Divider",@"1136 - Differential Air Pressure Sensor +-2 kPa",@"1137 - Differential Air Pressure Sensor +-7 kPa",@"1138 - Differential Air Pressure Sensor 50 kPa",@"1139 - Differential Air Pressure Sensor 100 kPa",@"1140 - Absolute Air Pressure Sensor 20-400 kPa",@"1141 - Absolute Air Pressure Sensor 15-115 kPa",@"1146 - IR Reflective Sensor 1-4mm",@"3120 - Compression Load Cell (0-4.5 kg)",@"3121 - Compression Load Cell (0-11.3 kg)",@"3122 - Compression Load Cell (0-22.7 kg)",@"3123 - Compression Load Cell (0-45.3 kg)",@"3130 - Relative Humidity Sensor",@"3520 - Sharp Distance Sensor (4-30cm)",@"3521 - Sharp Distance Sensor (10-80cm)",@"3522 - Sharp Distance Sensor (20-150cm)",nil]];
    }
    
    //Set values for sliders
    [dataIntervalSlider setEnabled:YES];
    [dataIntervalLabel setEnabled:YES];
    [dataIntervalSlider setMinimumValue:minDataInterval];
    [dataIntervalSlider setMaximumValue:maxDataInterval];
    [dataIntervalSlider setValue:dataInterval];
    [dataIntervalLabel setText:[NSString stringWithFormat:@"%d ms",dataInterval]];
    if(minVoltageRatioChangeTrigger == maxVoltageRatioChangeTrigger)
        [changeTriggerSlider setEnabled:NO];
    else{
        [changeTriggerSlider setMinimumValue:minVoltageRatioChangeTrigger];
        [changeTriggerSlider setMaximumValue:maxVoltageRatioChangeTrigger];
        [changeTriggerSlider setValue:0.0];
        [changeTriggerLabel setText:[NSString stringWithFormat:@"%.2f V",voltageRatioChangeTrigger]];
    }
}

- (void)onDetachHandler{
    [phidgetInfoBox fillPhidgetInfo:nil];
    
    //Hide views
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

-(void)onSensorChangeHandler:(NSArray *)array{
    double sensorVal = [[array objectAtIndex:0] doubleValue];
    NSString *symbol = [array objectAtIndex:1];
    [sensorValueLabel setText:[NSString stringWithFormat:@"%.4f %@",sensorVal, symbol]];
}


-(void)onVoltageRatioChangeHandler:(NSNumber*) voltageRatio{
    [voltageRatioLabel setText:[NSString stringWithFormat:@"%.3f V/V",voltageRatio.doubleValue]];
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

#pragma mark GUI controls
- (IBAction)dataIntervalChanged:(id)sender {
    PhidgetReturnCode result;
    UISlider *slider = (UISlider *)sender;
    [dataIntervalLabel setText:[NSString stringWithFormat:@"%d ms",(int)slider.value]];
    result = PhidgetVoltageRatioInput_setDataInterval(ch, (int)slider.value);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to set data interval" message:[NSString stringWithUTF8String:errorMessage]];
    }
}
- (IBAction)dataIntervalDragged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [dataIntervalLabel setText:[NSString stringWithFormat:@"%d ms",(int)slider.value]];
}

- (IBAction)changeTriggerChanged:(id)sender {
    PhidgetReturnCode result;
    UISlider *slider = (UISlider *)sender;
    [changeTriggerLabel setText:[NSString stringWithFormat:@"%0.2f V/V",slider.value]];
    result = PhidgetVoltageRatioInput_setVoltageRatioChangeTrigger(ch, slider.value);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to set voltage ratio change trigger" message:[NSString stringWithUTF8String:errorMessage]];
    }
}

- (IBAction)changeTriggerDragged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [changeTriggerLabel setText:[NSString stringWithFormat:@"%0.2f V/V",slider.value]];
}

- (IBAction)bridgeGainEnabled:(id)sender {
    UISwitch *enabledSwitch = (UISwitch *)sender;
    PhidgetReturnCode result;
    if(enabledSwitch.on)
        result = PhidgetVoltageRatioInput_setBridgeEnabled(ch, 0);
    else
        result = PhidgetVoltageRatioInput_setBridgeEnabled(ch, 1);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to set bridge enabled state" message:[NSString stringWithUTF8String:errorMessage]];
    }
}

#pragma mark Navigation
-(void)dimBackground{
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.5;
    backgroundView.tag = 99;
    [self.navigationController.view addSubview:backgroundView];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"phidgetInfoBoxSegue"]) {
        // can't assign the view controller from an embed segue via the storyboard, so capture here
        phidgetInfoBox = (PhidgetInfoBoxViewController *)segue.destinationViewController;
    }
    else if([segue.identifier isEqualToString:@"bridgeGainSegue"]){
        PickerViewController *vc = (PickerViewController *)segue.destinationViewController;
        [self dimBackground];
        vc.pickerArray = bridgeGainArray;
        vc.titleName = @"Bridge Gain";
        vc.voltageRatioInput = ch;
    }
    else if([segue.identifier isEqualToString:@"voltageRatioSensorTypeSegue"]){
        PickerViewController *vc = (PickerViewController *)segue.destinationViewController;
        [self dimBackground];
        vc.pickerArray = sensorArray;
        vc.titleName = @"Sensor Type";
        vc.voltageRatioInput = ch;
    }
}

- (IBAction)voltageRatioInputDone:(UIStoryboardSegue *)segue{
    [[self.navigationController.view viewWithTag:99] removeFromSuperview];
}

@end
