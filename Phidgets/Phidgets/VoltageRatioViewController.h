//
//  VoltageRatioViewController.h
//  Phidgets
//
//  Created by Phidgets on 2016-01-15.
//  Copyright © 2016 Phidgets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "phidget22.h"
#import "PhidgetInfoBoxViewController.h"
#import "TableViewController.h"

@interface VoltageRatioViewController : UIViewController{
    PhidgetVoltageRatioInputHandle ch;
    PhidgetInfoBoxViewController *phidgetInfoBox;
    //Labels
    __weak IBOutlet UILabel *voltageRatioLabel;
    __weak IBOutlet UILabel *sensorValueLabel;
    IBOutlet UILabel *sensorValueLabelTitle;
    //Data Interval Settings
    __weak IBOutlet UISlider *dataIntervalSlider;
    __weak IBOutlet UILabel *dataIntervalLabel;
    //Change Trigger Settings
    __weak IBOutlet UISlider *changeTriggerSlider;
    __weak IBOutlet UILabel *changeTriggerLabel;
    //bridge gain
    IBOutlet UIView *bridgeGainTitle;
    IBOutlet UISwitch *bridgeGainEnabled;
    //buttons
    IBOutlet UIButton *bridgeGainButton;
    IBOutlet UIButton *sensorTypeButton;
    //stack view
    IBOutlet UIStackView *stackView;
}
@property(nonatomic) int serialNumber;
@property(nonatomic) int hubPort;
@property(nonatomic) int channel;
@property(nonatomic) int isHubPort;
@property PhidgetTreeNode *treeNode;
@end
