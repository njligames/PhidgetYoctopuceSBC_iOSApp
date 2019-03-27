//
//  PhidgetInfoBoxViewController.m
//  Phidgets
//
//  Created by Phidgets on 2016-01-14.
//  Copyright © 2016 Phidgets. All rights reserved.
//

#import "PhidgetInfoBoxViewController.h"

@interface PhidgetInfoBoxViewController ()

@end

@implementation PhidgetInfoBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)fillPhidgetInfo:(PhidgetHandle)device
{
    int serialNum,hubPortNum,channelNum,versionNum;
    const char *deviceNameText;
    Phidget_DeviceClass deviceClass;
    
    //Clearing box
    if(device == nil)
    {
        [deviceTxt setText:@"Nothing"];
        [versionTxt setText:@"Version:"];
        [channelTxt setText:@"Channel:"];
        [serialNumTxt setText:@"Serial Number:"];
        [hubPortTxt setText:@"Hub Port:"];
        return;
    }
    
    //Get some basic information about the device
    Phidget_getChannel((PhidgetHandle)device, &channelNum);
    [channelTxt setText:[NSString stringWithFormat:@"Channel: %d",channelNum]];
    Phidget_getDeviceVersion((PhidgetHandle)device, &versionNum);
    [versionTxt setText:[NSString stringWithFormat:@"Version: %d",versionNum]];
    
    //Change settings based on whether device is VINT or USB
    Phidget_getDeviceClass((PhidgetHandle)device, &deviceClass);
    if(deviceClass == PHIDCLASS_VINT)
    {
        [hubPortTxt setHidden:NO];
        //Phidget_isHubPortDevice((PhidgetHandle)device, &isHubPort);
        Phidget_getDeviceName((PhidgetHandle)device, &deviceNameText);
        
        [deviceTxt setText:[NSString stringWithFormat:@"%s",deviceNameText]];
        Phidget_getDeviceSerialNumber((PhidgetHandle)device, &serialNum);
        [serialNumTxt setText:[NSString stringWithFormat:@"Hub Serial Number: %d",serialNum]];
        Phidget_getHubPort((PhidgetHandle)device, &hubPortNum);
        [hubPortTxt setText:[NSString stringWithFormat:@"Hub Port: %d",hubPortNum]];
    }
    else
    {
        [hubPortTxt setHidden:YES];
        Phidget_getDeviceName((PhidgetHandle)device, &deviceNameText);
        [deviceTxt setText:[NSString stringWithFormat:@"%s",deviceNameText]];
        Phidget_getDeviceSerialNumber((PhidgetHandle)device, &serialNum);
        [serialNumTxt setText:[NSString stringWithFormat:@"Serial Number: %d",serialNum]];
    }
}

@end
