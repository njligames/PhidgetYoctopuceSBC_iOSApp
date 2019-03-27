//
//  TableViewController.h
//  Phidgets
//
//  Created by Phidgets on 2016-03-09.
//  Copyright © 2016 Phidgets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhidgetTreeNode.h"
#import "ComputerNode.h"
#import "PhidgetDevice.h"
#import "HubPortNode.h"
#import "PhidgetChannel.h"
#import "DigitalOutputViewController.h"
#import "DigitalInputViewController.h"
#import "VoltageInputViewController.h"
#import "VoltageRatioViewController.h"
#import "PhidgetManagerController.h"
@interface TableViewController : UITableViewController<UINavigationControllerDelegate>{
}
@property PhidgetTreeNode *treeNode;
@end
