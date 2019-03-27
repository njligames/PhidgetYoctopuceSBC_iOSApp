//
//  VoltageInputViewController.h
//  Phidgets
//
//  Created by Phidgets on 2016-01-15.
//  Copyright © 2016 Phidgets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "phidget22.h"
#import "PhidgetInfoBoxViewController.h"
#import "TableViewController.h"

@interface VoltageInputViewController : UIViewController{
    PhidgetVoltageInputHandle ch;
    PhidgetInfoBoxViewController *phidgetInfoBox;
    //Labels
    __weak IBOutlet UILabel *voltageLabel;
    IBOutlet UILabel *sensorValueTitleLabel;
    __weak IBOutlet UILabel *sensorValueLabel;
    //Data Interval Settings
    __weak IBOutlet UISlider *dataIntervalSlider;
    __weak IBOutlet UILabel *dataIntervalLabel;
    //Change Trigger Settings
    __weak IBOutlet UISlider *changeTriggerSlider;
    __weak IBOutlet UILabel *changeTriggerLabel;
    //stack view
    IBOutlet UIStackView *stackView;
    //buttons
    IBOutlet UIButton *voltageRangeButton;
    IBOutlet UIButton *sensorTypeButton;
}
@property(nonatomic) int serialNumber;
@property(nonatomic) int hubPort;
@property(nonatomic) int channel;
@property(nonatomic) int isHubPort;
@property PhidgetTreeNode *treeNode;

@end
