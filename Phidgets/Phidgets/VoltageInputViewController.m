//
//  VoltageInputViewController.m
//  Phidgets
//
//  Created by Phidgets on 2016-01-15.
//  Copyright © 2016 Phidgets. All rights reserved.
//

#import "VoltageInputViewController.h"

@interface VoltageInputViewController ()

@end

@implementation VoltageInputViewController

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
static void gotVoltageChange(PhidgetVoltageInputHandle phid, void *context,double voltage) {
    [(__bridge id)context performSelectorOnMainThread:@selector(onVoltageChangeHandler:)
                                           withObject:[NSNumber numberWithDouble:voltage]
                                        waitUntilDone:NO];
}

static void gotSensorChange(PhidgetVoltageInputHandle phid, void *context , double sensorValue, Phidget_UnitInfo *sensorUnit){
    [(__bridge id)context performSelectorOnMainThread:@selector(onSensorChangeHandler:)
                                           withObject:[NSArray arrayWithObjects:[NSNumber numberWithDouble:sensorValue], [NSString stringWithUTF8String:sensorUnit->symbol], nil]
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
NSMutableArray *voltageRangeArray, *sensorTypeArray;
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
    
    voltageRangeArray = [[NSMutableArray alloc] init];
    sensorTypeArray = [[NSMutableArray alloc] init];
    result = PhidgetVoltageInput_create(&ch);
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
    result = PhidgetVoltageInput_setOnVoltageChangeHandler(ch, gotVoltageChange, (__bridge void*)self);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to assign voltage change handler" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = PhidgetVoltageInput_setOnSensorChangeHandler(ch, gotSensorChange, (__bridge void*)self);
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
    result = Phidget_setDeviceSerialNumber((PhidgetHandle)ch, self.serialNumber);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to set serial number" message:[NSString stringWithUTF8String:errorMessage]];
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
        [self outputError:@"Failed assign attach handler" message:[NSString stringWithUTF8String:errorMessage]];
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
    result = PhidgetVoltageInput_setOnVoltageChangeHandler(ch, nil, nil);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to assign voltage change handler" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_close((PhidgetHandle)ch);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to close channel" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = PhidgetVoltageInput_delete(&ch);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to delete channel" message:[NSString stringWithUTF8String:errorMessage]];
    }
    //re-enable swipe back because of uisliders
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}

- (void)onAttachHandler{
    int selectedRow = 0;
    uint32_t minDataInterval, maxDataInterval, dataInterval;
    double minVoltageChangeTrigger, maxVoltageChangeTrigger, voltageChangeTrigger;
    Phidget_DeviceID deviceID;
    PhidgetReturnCode result;
    Phidget_ChannelSubclass channelSubclass;
    
    //Get information from device
    result = PhidgetVoltageInput_getMinDataInterval(ch, &minDataInterval);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to get minimum data interval" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = PhidgetVoltageInput_getMaxDataInterval(ch, &maxDataInterval);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to get maximum data interval" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = PhidgetVoltageInput_getDataInterval(ch, &dataInterval);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to get data interval" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = PhidgetVoltageInput_getMinVoltageChangeTrigger(ch, &minVoltageChangeTrigger);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to get minimum voltage change trigger" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = PhidgetVoltageInput_getMaxVoltageChangeTrigger(ch, &maxVoltageChangeTrigger);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to get maximum voltage change trigger" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = PhidgetVoltageInput_getVoltageChangeTrigger(ch, &voltageChangeTrigger);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to get voltage change trigger" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_getDeviceID((PhidgetHandle)ch, &deviceID);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to get device ID" message:[NSString stringWithUTF8String:errorMessage]];
    }
    result = Phidget_getChannelSubclass((PhidgetHandle)ch, &channelSubclass);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to get channel subclass" message:[NSString stringWithUTF8String:errorMessage]];
    }
    
    //Manage views
    [phidgetInfoBox fillPhidgetInfo:(PhidgetHandle)ch];
    [stackView setHidden:NO];
    [sensorValueTitleLabel setHidden:YES];
    [sensorValueLabel setHidden:YES];
    [sensorTypeButton setHidden:YES];
    
    
    //Set values for sliders
    [dataIntervalLabel setEnabled:YES];
    [dataIntervalSlider setEnabled:YES];
    [dataIntervalSlider setMinimumValue:minDataInterval];
    [dataIntervalSlider setMaximumValue:maxDataInterval];
    [dataIntervalSlider setValue:dataInterval];
    [dataIntervalLabel setText:[NSString stringWithFormat:@"%d ms",dataInterval]];
    
    if(minVoltageChangeTrigger == maxVoltageChangeTrigger){
        [changeTriggerSlider setEnabled:NO];
        [changeTriggerLabel setEnabled:NO];
    }
    else{
        [changeTriggerSlider setEnabled:YES];
        [changeTriggerLabel setEnabled:YES];
        [changeTriggerSlider setMinimumValue:minVoltageChangeTrigger];
        [changeTriggerSlider setMaximumValue:maxVoltageChangeTrigger];
        [changeTriggerSlider setValue:voltageChangeTrigger];
        [changeTriggerLabel setText:[NSString stringWithFormat:@"%.2f V",voltageChangeTrigger]];
        [changeTriggerLabel setEnabled:YES];
    }
    
    switch(deviceID){
        case PHIDID_VCP1000:
            [voltageRangeArray removeAllObjects];
            [voltageRangeArray addObjectsFromArray:[NSArray arrayWithObjects:@"312.5 mV",@"40 V", nil]];
            PhidgetVoltageInput_setVoltageRange(ch, VOLTAGE_RANGE_40V);
            selectedRow = 0;
            break;
        case PHIDID_VCP1001:
            [voltageRangeArray removeAllObjects];
            [voltageRangeArray addObjectsFromArray:[NSArray arrayWithObjects:@"5 V",@"15 V",@"40 V",@"Automatic", nil]];
            PhidgetVoltageInput_setVoltageRange(ch, VOLTAGE_RANGE_AUTO);
            selectedRow = 3;
            break;
        case PHIDID_VCP1002:
            [voltageRangeArray removeAllObjects];
            [voltageRangeArray addObjectsFromArray:[NSArray arrayWithObjects:@"10 mV",@"40 mV",@"200 mV",@"1000 mV",@"Automatic", nil]];
            PhidgetVoltageInput_setVoltageRange(ch, VOLTAGE_RANGE_AUTO);
            selectedRow = 4;
            break;
        default:
            break;
    }
    
    if(channelSubclass == PHIDCHSUBCLASS_VOLTAGEINPUT_SENSOR_PORT){
        [sensorTypeArray removeAllObjects];
        [sensorTypeArray addObjectsFromArray:[NSArray arrayWithObjects:@"Generic Voltage Sensor",@"1114 - Temperature Sensor",@"1117 - Voltage Sensor",@"1123 - Precision Voltage Sensor",@"1127 - Precision Light Sensor",@"1130 - pH Adapter",@"1130 - ORP Adapter",@"1132 - 4-20mA Adapter",@"1133 - Sound Sensor",@"1135 - Precision Voltage Sensor",@"1142 - Light Sensor 1000 lux",@"1143 - Light Sensor 70000 lux",@"3500 - AC Current Sensor 10Amp lux",@"3501 - AC Current Sensor 25Amp",@"3502 - AC Current Sensor 50Amp",@"3503 - AC Current Sensor 100Amp",@"3507 - AC Voltage Sensor 0-250V (50 Hz)",@"3508 - AC Voltage Sensor 0-250V (60 Hz)",@"3509 - DC Voltage Sensor 0-200V",@"3510 - DC Voltage Sensor 0-75V",@"3511 - DC Current Sensor 0-10mA",@"3512 - DC Current Sensor 0-100mA",@"3513 - DC Current Sensor 0-1A",@"3514 - AC Active Power Sensor 0-250V*0-30A (50Hz)",@"3515 - AC Active Power Sensor 0-250V*0-30A (60Hz)",@"3516 - AC Active Power Sensor 0-250V*0-5A (50Hz)",@"3517 - AC Active Power Sensor 0-250V*0-5A (60Hz)",@"3518 - AC Active Power Sensor 0-110V*0-5A (60Hz)",@"3519 - AC Active Power Sensor 0-110V*0-15A (60Hz)",@"3584 - 0-50A DC Current Transducer",@"3585 - 0-100A DC Current Transducer",@"3586 - 0-250A DC Current Transducer",@"3587 - +-50A DC Current Transducer",@"3588 - +-100A DC Current Transducer",@"3589 - +-250A DC Current Transducer",nil]];
        [sensorValueTitleLabel setHidden:NO];
        [sensorValueLabel setHidden:NO];
        [sensorTypeButton setHidden:NO];
    }
    
    if(voltageRangeArray.count == 0){
        [voltageRangeButton setHidden:YES];
    }
    else{
        [voltageRangeButton setHidden:NO];
    }
    [self.view setNeedsDisplay];
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

-(void)onVoltageChangeHandler:(NSNumber*) voltage{
    [voltageLabel setText:[NSString stringWithFormat:@"%.4f V",voltage.doubleValue]];
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

#pragma mark GUI Controls
- (IBAction)dataIntervalChange:(id)sender {
    PhidgetReturnCode result;
    UISlider *slider = (UISlider *)sender;
    [dataIntervalLabel setText:[NSString stringWithFormat:@"%d ms",(int)slider.value]];
    result = PhidgetVoltageInput_setDataInterval(ch, (int)slider.value);
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
- (IBAction)changeTriggerChange:(id)sender {
    PhidgetReturnCode result;
    UISlider *slider = (UISlider *)sender;
    [changeTriggerLabel setText:[NSString stringWithFormat:@"%0.2f V",slider.value]];
    result = PhidgetVoltageInput_setVoltageChangeTrigger(ch, slider.value);
    if(result != EPHIDGET_OK){
        const char* errorMessage;
        Phidget_getErrorDescription(result, &errorMessage);
        [self outputError:@"Failed to set voltage change trigger" message:[NSString stringWithUTF8String:errorMessage]];
    }
}
- (IBAction)changeTriggerDragged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [changeTriggerLabel setText:[NSString stringWithFormat:@"%0.2f V",slider.value]];
}
-(void)dimBackground{
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.5;
    backgroundView.tag = 99;
    [self.navigationController.view addSubview:backgroundView];
}

#pragma mark Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"phidgetInfoBoxSegue"]) {
        phidgetInfoBox = (PhidgetInfoBoxViewController *)segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:@"voltageRangeSegue"]) {
        PickerViewController *vc = (PickerViewController *)segue.destinationViewController;
        [self dimBackground];
        vc.pickerArray = voltageRangeArray;
        vc.titleName = @"Voltage Range";
        vc.voltageInput = ch;
    }
    else if ([segue.identifier isEqualToString:@"voltageInputSensorTypeSegue"]) {
        PickerViewController *vc = (PickerViewController *)segue.destinationViewController;
        [self dimBackground];
        vc.pickerArray = sensorTypeArray;
        vc.titleName = @"Sensor Type";
        vc.voltageInput = ch;
    }
}
- (IBAction)voltageInputDone:(UIStoryboardSegue *)segue{
    [[self.navigationController.view viewWithTag:99] removeFromSuperview];
}

@end
