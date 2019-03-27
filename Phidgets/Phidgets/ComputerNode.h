//
//  ComputerNode.h
//  Phidget Control Panel
//
//  Created by Patrick McNeil on 2015-12-08.
//  Copyright © 2015 Phidgets Inc. All rights reserved.
//

#import "PhidgetTreeNode.h"
#import "phidget22.h"
@interface ComputerNode : PhidgetTreeNode

@property BOOL isRemote;

-(id)initWithHandle:(PhidgetHandle)phid;

@end
