//
//  PhidgetInfoBoxViewController.h
//  Phidgets
//
//  Created by Phidgets on 2016-01-14.
//  Copyright © 2016 Phidgets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "phidget22.h"
@interface PhidgetInfoBoxViewController : UIViewController
{
    IBOutlet UILabel *deviceTxt;
    IBOutlet UILabel *versionTxt;
    IBOutlet UILabel *channelTxt;
    IBOutlet UILabel *serialNumTxt;
    IBOutlet UILabel *hubPortTxt;
}
-(void)fillPhidgetInfo:(PhidgetHandle)device;
@end
