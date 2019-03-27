//
//  DigitalInputViewController.h
//  Phidgets
//
//  Created by Phidgets on 2016-01-15.
//  Copyright © 2016 Phidgets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhidgetInfoBoxViewController.h"
#import "phidget22.h"
#import "TableViewController.h"
@interface DigitalInputViewController : UIViewController{
    PhidgetDigitalInputHandle ch;
    PhidgetInfoBoxViewController *phidgetInfoBox;
    DigitalInputViewController *diginBox;
    __weak IBOutlet UILabel *stateLabel;
}
@property(nonatomic) int serialNumber;
@property(nonatomic) int hubPort;
@property(nonatomic) int channel;
@property(nonatomic) int isHubPort;
@property PhidgetTreeNode *treeNode;

@end
