//
//  PickerViewController.m
//  Phidgets
//
//  Created by Phidgets on 2016-10-12.
//  Copyright © 2016 Phidgets. All rights reserved.
//

#import "PickerViewController.h"

@interface PickerViewController ()

@end

@implementation PickerViewController
@synthesize titleName = titleName;
@synthesize digitalOutput = digitalOutput;
@synthesize voltageInput = voltageInput;
@synthesize  pickerArray = pickerArray;
@synthesize voltageRatioInput = voltageRatioInput;

- (void)viewDidLoad {
    [super viewDidLoad];
    pickerBox.layer.cornerRadius = 5.0;
    pickerBox.layer.masksToBounds = YES;
    [pickerTitle setText:titleName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)pickerView:(UIPickerView *)pickerViewLocal viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *text = (UILabel *)view;
    if(text == nil){
        text = [[UILabel alloc] init];
    }
    [text setFont:[UIFont systemFontOfSize:25.0 weight:UIFontWeightLight]];
    [text setTextAlignment:NSTextAlignmentCenter];
    text.adjustsFontSizeToFitWidth = YES;
    text.text = [self pickerView:pickerViewLocal titleForRow:row forComponent:component];
    
    return text;
}

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return  pickerArray.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return pickerArray[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *resultString = pickerArray[row];
    if(digitalOutput != nil){
        if([resultString isEqualToString:@"1.7V"]){
            PhidgetDigitalOutput_setLEDForwardVoltage(digitalOutput, LED_FORWARD_VOLTAGE_1_7V);
        }
        else if([resultString isEqualToString:@"2.75V"]){
            PhidgetDigitalOutput_setLEDForwardVoltage(digitalOutput, LED_FORWARD_VOLTAGE_2_75V);
        }
        else if([resultString isEqualToString:@"3.9V"]){
            PhidgetDigitalOutput_setLEDForwardVoltage(digitalOutput, LED_FORWARD_VOLTAGE_3_9V);
        }
        else if([resultString isEqualToString:@"5.0V"]){
            PhidgetDigitalOutput_setLEDForwardVoltage(digitalOutput, LED_FORWARD_VOLTAGE_5_0V);
        }
    }
    else if(voltageInput != nil){
        if([resultString isEqualToString:@"Generic Voltage Sensor"]){
            PhidgetVoltageInput_setSensorType(voltageInput, SENSOR_TYPE_VOLTAGE);
            return;
        }
        else if([resultString isEqualToString:@"1130 - pH Adapter"]){
            PhidgetVoltageInput_setSensorType(voltageInput, SENSOR_TYPE_1130_PH);
            return;
        }
        else if([resultString isEqualToString:@"1130 - ORP Adapter"]){
            PhidgetVoltageInput_setSensorType(voltageInput, SENSOR_TYPE_1130_ORP);
            return;
        }
        else if([resultString isEqualToString: @"10 mV"]){
            PhidgetVoltageInput_setVoltageRange(voltageInput, VOLTAGE_RANGE_10mV);
            return;
        }
        else if([resultString isEqualToString: @"40 mV"]){
            PhidgetVoltageInput_setVoltageRange(voltageInput, VOLTAGE_RANGE_40mV);
            return;
        }
        else if([resultString isEqualToString: @"200 mV"]){
            PhidgetVoltageInput_setVoltageRange(voltageInput, VOLTAGE_RANGE_200mV);
            return;
        }
        else if([resultString isEqualToString: @"312.5 mV"]){
            PhidgetVoltageInput_setVoltageRange(voltageInput, VOLTAGE_RANGE_312_5mV);
            return;
        }
        else if([resultString isEqualToString: @"400 mV"]){
            PhidgetVoltageInput_setVoltageRange(voltageInput, VOLTAGE_RANGE_400mV);
            return;
        }
        else if([resultString isEqualToString: @"1000 mV"]){
            PhidgetVoltageInput_setVoltageRange(voltageInput, VOLTAGE_RANGE_1000mV);
            return;
        }
        else if([resultString isEqualToString: @"2 V"]){
            PhidgetVoltageInput_setVoltageRange(voltageInput, VOLTAGE_RANGE_2V);
            return;
        }
        else if([resultString isEqualToString: @"5 V"]){
            PhidgetVoltageInput_setVoltageRange(voltageInput, VOLTAGE_RANGE_5V);
            return;
        }
        else if([resultString isEqualToString: @"15 V"]){
            PhidgetVoltageInput_setVoltageRange(voltageInput, VOLTAGE_RANGE_15V);
            return;
        }
        else if([resultString isEqualToString: @"40 V"]){
            PhidgetVoltageInput_setVoltageRange(voltageInput, VOLTAGE_RANGE_40V);
            return;
        }
        else if([resultString isEqualToString: @"Auto"]){
            PhidgetVoltageInput_setVoltageRange(voltageInput, VOLTAGE_RANGE_AUTO);
            return;
        }
        
        //use number to differentiate the rest
        NSString *s1;
        NSString *s2 = resultString;
        NSScanner *scanner = [NSScanner scannerWithString:s2];
        NSCharacterSet *nums = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        [scanner scanUpToCharactersFromSet:nums intoString:NULL];
        [scanner scanCharactersFromSet:nums intoString:&s1];
        int sensorType = [s1 intValue] * 10;
        PhidgetVoltageInput_setSensorType(voltageInput, (PhidgetVoltageInput_SensorType)sensorType);
    }
    else if(voltageRatioInput != nil){
        if([resultString isEqualToString: @"Generic ratiometric sensor"]){
            PhidgetVoltageRatioInput_setSensorType(voltageRatioInput, SENSOR_TYPE_VOLTAGERATIO);
            return;
        }
        else if([resultString isEqualToString: @"1101 - IR Distance Adapter, with Sharp Distance Sensor 2D120X (4-30cm)"]){
            PhidgetVoltageRatioInput_setSensorType(voltageRatioInput, SENSOR_TYPE_1101_SHARP_2D120X);
            return;
        }
        else if([resultString isEqualToString: @"1101 - IR Distance Adapter, with Sharp Distance Sensor 2Y0A21 (10-80cm)"]){
            PhidgetVoltageRatioInput_setSensorType(voltageRatioInput, SENSOR_TYPE_1101_SHARP_2Y0A21);
            return;
        }
        else if([resultString isEqualToString: @"1101 - IR Distance Adapter, with Sharp Distance Sensor 2Y0A02 (20-150cm)"]){
            PhidgetVoltageRatioInput_setSensorType(voltageRatioInput, SENSOR_TYPE_1101_SHARP_2Y0A02);
            return;
        }
        else if([resultString isEqualToString: @"1118 - 50Amp Current Sensor AC"]){
            PhidgetVoltageRatioInput_setSensorType(voltageRatioInput, SENSOR_TYPE_1118_AC);
            return;
        }
        else if([resultString isEqualToString: @"1118 - 50Amp Current Sensor DC"]){
            PhidgetVoltageRatioInput_setSensorType(voltageRatioInput, SENSOR_TYPE_1118_DC);
            return;
        }
        else if([resultString isEqualToString: @"1119 - 20Amp Current Sensor AC"]){
            PhidgetVoltageRatioInput_setSensorType(voltageRatioInput, SENSOR_TYPE_1119_AC);
            return;
        }
        else if([resultString isEqualToString: @"1119 - 20Amp Current Sensor DC"]){
            PhidgetVoltageRatioInput_setSensorType(voltageRatioInput, SENSOR_TYPE_1119_DC);
            return;
        }
        else if([resultString isEqualToString: @"1122 - 30 Amp Current Sensor AC"]){
            PhidgetVoltageRatioInput_setSensorType(voltageRatioInput, SENSOR_TYPE_1122_AC);
            return;
        }
        else if([resultString isEqualToString: @"1122 - 30 Amp Current Sensor DC"]){
            PhidgetVoltageRatioInput_setSensorType(voltageRatioInput, SENSOR_TYPE_1122_DC);
            return;
        }
        else if([resultString isEqualToString: @"1x"]){
            PhidgetVoltageRatioInput_setBridgeGain(voltageRatioInput, BRIDGE_GAIN_1);
            return;
        }
        else if([resultString isEqualToString: @"2x"]){
            PhidgetVoltageRatioInput_setBridgeGain(voltageRatioInput, BRIDGE_GAIN_2);
            return;
        }
        else if([resultString isEqualToString: @"4x"]){
            PhidgetVoltageRatioInput_setBridgeGain(voltageRatioInput, BRIDGE_GAIN_4);
            return;
        }
        else if([resultString isEqualToString: @"8x"]){
            PhidgetVoltageRatioInput_setBridgeGain(voltageRatioInput, BRIDGE_GAIN_8);
            return;
        }
        else if([resultString isEqualToString: @"16x"]){
            PhidgetVoltageRatioInput_setBridgeGain(voltageRatioInput, BRIDGE_GAIN_16);
            return;
        }
        else if([resultString isEqualToString: @"32x"]){
            PhidgetVoltageRatioInput_setBridgeGain(voltageRatioInput, BRIDGE_GAIN_32);
            return;
        }
        else if([resultString isEqualToString: @"64x"]){
            PhidgetVoltageRatioInput_setBridgeGain(voltageRatioInput, BRIDGE_GAIN_64);
            return;
        }
        else if([resultString isEqualToString: @"128x"]){
            PhidgetVoltageRatioInput_setBridgeGain(voltageRatioInput, BRIDGE_GAIN_128);
            return;
        }
        
        //use number to differentiate the rest
        NSString *s1;
        NSString *s2 = resultString;
        NSScanner *scanner = [NSScanner scannerWithString:s2];
        NSCharacterSet *nums = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        [scanner scanUpToCharactersFromSet:nums intoString:NULL];
        [scanner scanCharactersFromSet:nums intoString:&s1];
        int sensorType = [s1 intValue] * 10;
        PhidgetVoltageRatioInput_setSensorType(voltageRatioInput, (PhidgetVoltageRatioInput_SensorType)sensorType);
    }
}

- (IBAction)done:(id)sender {
    if(digitalOutput != nil){
        [self performSegueWithIdentifier:@"digitalOutputDoneSegue" sender:self];
    }
    else if(voltageInput != nil){
        [self performSegueWithIdentifier:@"voltageInputDoneSegue" sender:self];
    }
    else if(voltageRatioInput != nil){
        [self performSegueWithIdentifier:@"voltageRatioInputDoneSegue" sender:self];
    }
}


@end
