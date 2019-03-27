//
//  PhidgetChannel.m
//  Phidget Control Panel
//
//  Created by Patrick McNeil on 2015-12-03.
//  Copyright © 2015 Phidgets Inc. All rights reserved.
//

#import "PhidgetChannel.h"

@implementation PhidgetChannel

-(id)initWithHandle:(PhidgetHandle)phid {
	if(self = [super init])
	{
		const char *name;
		const char *chClsName;
		int channel;
		Phidget_ChannelClass chClass;
		Phidget_ChannelSubclass chSubClass;
		
		Phidget_getChannelName(phid, &name);
		Phidget_getChannel(phid, &channel);
		Phidget_getChannelClass(phid, &chClass);
		Phidget_getChannelClassName(phid, &chClsName);
		Phidget_getChannelSubclass(phid, &chSubClass);
		
		self.chSubClass = chSubClass;
		self.chClass = chClass;
		self.name = [[NSString alloc] initWithCString:name encoding:NSUTF8StringEncoding];
		self.channel = [NSNumber numberWithInt:channel];
		self.chClsName = [NSString stringWithCString:chClsName encoding:NSUTF8StringEncoding];
	}
	return self;
}

- (BOOL)isEqual:(id)other {
	if (other == self)
		return YES;
	if (!other || ![other isKindOfClass:[self class]])
		return NO;
	return [self isEqualToPhidgetChannel:other];
}

- (BOOL)isEqualToPhidgetChannel:(PhidgetChannel *)channel {
	if (self == channel)
		return YES;
	if (self.channel != channel.channel)
		return NO;
	if (self.chClass != channel.chClass)
		return NO;
	if (self.parent != nil) {
		if(![self.parent isEqual:channel.parent])
			return NO;
	} else if(channel.parent != nil)
		return NO;
	return YES;
}

@end
