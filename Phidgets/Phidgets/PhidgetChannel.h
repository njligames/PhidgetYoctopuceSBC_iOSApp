//
//  PhidgetChannel.h
//  Phidget Control Panel
//
//  Created by Patrick McNeil on 2015-12-03.
//  Copyright © 2015 Phidgets Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "phidget22.h"
#import "PhidgetTreeNode.h"

@interface PhidgetChannel : PhidgetTreeNode

@property Phidget_ChannelClass chClass;
@property Phidget_ChannelSubclass chSubClass;
@property NSString *chClsName;

-(id)initWithHandle:(PhidgetHandle)phid;

@end
