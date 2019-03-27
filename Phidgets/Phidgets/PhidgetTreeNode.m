//
//  PhidgetTreeNode.m
//  Phidget Control Panel
//
//  Created by Patrick McNeil on 2015-12-04.
//  Copyright © 2015 Phidgets Inc. All rights reserved.
//

#import "PhidgetTreeNode.h"

@implementation PhidgetTreeNode

-(id)init {
	if(self = [super init]) {
		self.parent = nil;
		self.children = [[NSMutableArray alloc] init];
		return self;
	}
	return nil;
}

-(id)initWithName:(NSString *)name {
	if(self = [self init]) {
		self.name = name;
		return self;
	} 
	return nil;
}

- (BOOL)isEqual:(id)other {
	if (other == self)
		return YES;
	return NO;
}

- (void)sort {
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nameForTable" ascending:YES];
	NSSortDescriptor *serialDescriptor = [[NSSortDescriptor alloc] initWithKey:@"serialNumberForTable" ascending:YES];
	NSSortDescriptor *channelDescriptor = [[NSSortDescriptor alloc] initWithKey:@"channelForTable" ascending:YES];
	NSArray *sortDescriptors = @[nameDescriptor, serialDescriptor, channelDescriptor];
	[self.children sortUsingDescriptors:sortDescriptors];
}

- (BOOL)canExpand {
	if(self.children.count == 0)
		return NO;
	return YES;
}

-(BOOL)shouldExpand {
	return NO;
}

-(NSString *)nameForTable{
	return self.name;
}

-(NSNumber *)serialNumberForTable {
	return self.serialNumber;
}

-(NSNumber *)channelForTable {
	return self.channel;
}

-(NSNumber *)versionForTable {
	return self.version;
}

-(NSUInteger)childCountForTable {
	return self.children.count;
}

-(PhidgetTreeNode *)childForTable:(NSInteger)index {
	return self.children[index];
}

+(PhidgetTreeNode *)FindNode:(PhidgetTreeNode *)node inTree:(PhidgetTreeNode *)tree {
	for(PhidgetTreeNode *child in tree.children) {
		if([child isEqual:node])
			return child;
		
		PhidgetTreeNode *rNode = [PhidgetTreeNode FindNode:node inTree:child];
		if(rNode != nil)
			return rNode;
	}
	return nil;
}



@end
