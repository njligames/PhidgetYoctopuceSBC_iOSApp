//
//  PhidgetManagerController.h
//  Phidgets
//
//  Created by Phidgets on 2016-01-13.
//  Copyright © 2016 Phidgets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "phidget22.h"
#import "PhidgetDevice.h"
#import "DigitalOutputViewController.h"
#import "DigitalInputViewController.h"
#import "VoltageInputViewController.h"
#import "VoltageRatioViewController.h"
#import "PhidgetTreeNode.h"
#import "ComputerNode.h"
#import "HubPortNode.h"
#import "PhidgetChannel.h"
#import "TableViewController.h"
#import "ServerViewController.h"

@interface PhidgetManagerController : UIViewController{
    PhidgetManagerHandle phidMan;
    PhidgetTreeNode *phidgets;
    int selectedRow;
    IBOutlet UIButton *serverButton;
}
- (void)phidgetManAdded:(PhidgetDevice *)phidget;
- (void)phidgetManRemoved:(PhidgetDevice *)phidget;

@end

