//
//  DigitalOutputViewController.h
//  Phidgets
//
//  Created by Phidgets on 2016-01-14.
//  Copyright © 2016 Phidgets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "phidget22.h"
#import "PhidgetInfoBoxViewController.h"
#import "TableViewController.h"
#import "PickerViewController.h"

@interface DigitalOutputViewController : UIViewController
{
    PhidgetDigitalOutputHandle ch;
    PhidgetInfoBoxViewController *phidgetInfoBox;
    //DutyCycle Settings
    __weak IBOutlet UISlider *dutyCycleSlider;
    __weak IBOutlet UILabel *dutyCycleLabel;
    IBOutlet UIButton *dutyCycleButton;
    
    //Current Limit Settings
    __weak IBOutlet UISlider *currentLimitSlider;
    __weak IBOutlet UILabel *currentLimitLabel;
    IBOutlet UILabel *currentLimitTitleLabel;
    IBOutlet UIButton *forwardVoltageButton;
    
    //Stack view
    IBOutlet UIStackView *stackView;
}
@property(nonatomic) int serialNumber;
@property(nonatomic) int hubPort;
@property(nonatomic) int channel;
@property(nonatomic) int isHubPort;
@property PhidgetTreeNode *treeNode;
@end
