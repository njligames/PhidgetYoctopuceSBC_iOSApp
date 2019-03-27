//
//  ComputerNode.m
//  Phidget Control Panel
//
//  Created by Patrick McNeil on 2015-12-08.
//  Copyright © 2015 Phidgets Inc. All rights reserved.
//

#import "ComputerNode.h"

@implementation ComputerNode

-(id)initWithHandle:(PhidgetHandle)phid {
	if(self = [super init])
	{
		int remote;
		Phidget_getIsRemote(phid, &remote);
		self.isRemote = remote;
		
		if(!remote) {
			self.name = @"Local Phidgets";
		} else {
			const char *serverName;
			Phidget_getServerName(phid, &serverName);
			self.name = [NSString stringWithFormat:@"Remote Server: %@",
						 [NSString stringWithCString:serverName encoding:NSUTF8StringEncoding]];
		}
	}
	return self;
}

- (BOOL)isEqual:(id)other {
	if (other == self)
		return YES;
	if (!other || ![other isKindOfClass:[self class]])
		return NO;
	return [self isEqualToComputerNode:other];
}

- (BOOL)isEqualToComputerNode:(ComputerNode *)computer {
	if (self == computer)
		return YES;
	if(![self.name isEqualToString:computer.name])
		return NO;
	return YES;
}

-(BOOL)shouldExpand {
	if(self.isRemote)
		return NO;
	return YES;
}

@end
