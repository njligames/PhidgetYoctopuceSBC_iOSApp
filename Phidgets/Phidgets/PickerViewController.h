//
//  PickerViewController.h
//  Phidgets
//
//  Created by Phidgets on 2016-10-12.
//  Copyright © 2016 Phidgets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "phidget22.h"
@interface PickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    
    IBOutlet UIPickerView *pickerView;
    IBOutlet UILabel *pickerTitle;
    IBOutlet UIView *pickerBox;
}
@property NSString *titleName;
@property NSArray *pickerArray;
@property PhidgetDigitalOutputHandle digitalOutput;
@property PhidgetVoltageInputHandle voltageInput;
@property PhidgetVoltageRatioInputHandle voltageRatioInput;
@end
