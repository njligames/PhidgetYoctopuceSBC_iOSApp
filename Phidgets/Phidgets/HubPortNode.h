//
//  HubPortNode.h
//  Phidget Control Panel
//
//  Created by Patrick McNeil on 2015-12-07.
//  Copyright © 2015 Phidgets Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhidgetTreeNode.h"
#import "PhidgetDevice.h"

@interface HubPortNode : PhidgetTreeNode

@property int devSerial;

-(id)initWithPortNumber:(int)num andSerial:(int)serial;

@end
