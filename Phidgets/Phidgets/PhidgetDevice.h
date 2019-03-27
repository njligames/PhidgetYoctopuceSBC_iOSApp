//
//  PhidgetDevice.h
//  Phidget Control Panel
//
//  Created by Patrick McNeil on 2015-12-07.
//  Copyright © 2015 Phidgets Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhidgetTreeNode.h"
#import "PhidgetChannel.h"

@interface PhidgetDevice : PhidgetTreeNode

@property int devSerial;
@property Phidget_DeviceClass devClass;
@property int hubPort;
@property BOOL hubPortDevice;
@property BOOL isRemote;
@property NSString *serverName;
@property Phidget_DeviceID devId;

-(id)initWithHandle:(PhidgetHandle)phid;
-(bool)canExpand;
-(NSNumber *)channelForTable;

@end
