//
//  PhidgetDevice.m
//  Phidget Control Panel
//
//  Created by Patrick McNeil on 2015-12-07.
//  Copyright © 2015 Phidgets Inc. All rights reserved.
//

#import "PhidgetDevice.h"

@implementation PhidgetDevice

-(id)initWithHandle:(PhidgetHandle)phid {
	if(self = [super init])
	{
		Phidget_DeviceClass cls;
		const char *name;
		const char *serverName;
		int version;
		int serial;
		int hubPort;
		int hubPortDevice;
		int remote;
		Phidget_DeviceID devId;
		
		Phidget_getDeviceName(phid, &name);
		Phidget_getDeviceSerialNumber(phid, &serial);
		Phidget_getDeviceVersion(phid, &version);
		Phidget_getDeviceClass(phid, &cls);
		Phidget_getIsHubPortDevice(phid, &hubPortDevice);
		Phidget_getIsRemote(phid, &remote);
		Phidget_getDeviceID(phid, &devId);
		
		self.devId = devId;
		self.isRemote = remote;
		self.devSerial = serial;
		self.devClass = cls;
		self.hubPortDevice = hubPortDevice;
		
		if(remote) {
			Phidget_getServerName(phid, &serverName);
			self.serverName = [NSString stringWithCString:serverName encoding:NSUTF8StringEncoding];
		} else
			self.serverName = nil;
		
		self.name = [[NSString alloc] initWithCString:name encoding:NSUTF8StringEncoding];
		if(cls != PHIDCLASS_VINT) {
			self.serialNumber = [NSNumber numberWithInt:serial];
			self.hubPort = 0;
		}
		else {
			Phidget_getHubPort(phid, &hubPort);
			self.hubPort = hubPort;
		}
		self.version = [NSNumber numberWithInt:version];
	}
	return self;
}

// Don't show child if it's just a single channel
- (bool)canExpand {
	if(self.children.count == 0)
		return NO;
	if(self.children.count > 1)
		return YES;
	if([self.children[0] isKindOfClass:[PhidgetChannel class]])
		return NO;
	return YES;
}

-(BOOL)shouldExpand {
	if(self.devClass == PHIDCLASS_HUB)
		return YES;
	if(self.devClass == PHIDCLASS_MESHDONGLE)
		return YES;
	return NO;
}

-(NSNumber *)channelForTable {
	if(self.children.count == 1 && self.canExpand == NO)
		return ((PhidgetTreeNode *)self.children[0]).channelForTable;
	return self.channel;
}

- (BOOL)isEqual:(id)other {
	if (other == self)
		return YES;
	if (!other || ![other isKindOfClass:[self class]])
		return NO;
	return [self isEqualToPhidgetDevice:other];
}

- (BOOL)isEqualToPhidgetDevice:(PhidgetDevice *)device {
	if (self == device)
		return YES;
	if(self.devSerial != device.devSerial)
		return NO;
	if(self.devClass != device.devClass)
		return NO;
	if(self.hubPort != device.hubPort)
		return NO;
	if(![self.name isEqualToString:device.name])
		return NO;
	return YES;
}

@end
