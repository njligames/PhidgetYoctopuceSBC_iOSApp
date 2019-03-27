//
//  HubPortNode.m
//  Phidget Control Panel
//
//  Created by Patrick McNeil on 2015-12-07.
//  Copyright © 2015 Phidgets Inc. All rights reserved.
//

#import "HubPortNode.h"

@implementation HubPortNode

-(id)initWithPortNumber:(int)num andSerial:(int)serial {
	if(self = [super init])
	{
		self.name = [NSString stringWithFormat:@"Port %d", num];
		self.devSerial = serial;
	}
	return self;
}

// This hides hub port devices when a VINT device is plugged in
- (BOOL)vintDeviceAttached {
	if(self.children.count < 5)
		return NO;
	return YES;
}

-(NSUInteger)childCountForTable {
	if(self.vintDeviceAttached)
		return 1;
	
	return self.children.count;
}

// This hides hub port devices when a VINT device is plugged in
-(PhidgetTreeNode *)childForTable:(NSInteger)index {
	if(!self.vintDeviceAttached)
		return self.children[index];
	
	for (PhidgetDevice *ch in self.children) {
		if(!ch.hubPortDevice)
			return ch;
	}
	return nil; // error case, shouldn't happen
}

-(BOOL)shouldExpand {
	if(self.vintDeviceAttached)
		return YES;
	return NO;
}

- (BOOL)isEqual:(id)other {
	if (other == self)
		return YES;
	if (!other || ![other isKindOfClass:[self class]])
		return NO;
	return [self isEqualToHubPortNode:other];
}

- (BOOL)isEqualToHubPortNode:(HubPortNode *)hubPort {
	if (self == hubPort)
		return YES;
	if(self.devSerial != hubPort.devSerial)
		return NO;
	if(![self.name isEqualToString:hubPort.name])
		return NO;
	return YES;
}

@end
