//
//  PhidgetTreeNode.h
//  Phidget Control Panel
//
//  Created by Patrick McNeil on 2015-12-04.
//  Copyright © 2015 Phidgets Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhidgetTreeNode : NSObject

@property PhidgetTreeNode *parent;
@property NSMutableArray *children;

// Properties corresponding to the table columns
@property NSString *name;
@property NSNumber *serialNumber;
@property NSNumber *channel;
@property NSNumber *version;

-(NSString *)nameForTable;
-(NSNumber *)serialNumberForTable;
-(NSNumber *)channelForTable;
-(NSNumber *)versionForTable;
-(NSUInteger)childCountForTable;
-(PhidgetTreeNode *)childForTable:(NSInteger)index;

-(id)initWithName:(NSString *)name;
-(void)sort;
-(BOOL)canExpand;
-(BOOL)shouldExpand;

+(PhidgetTreeNode *)FindNode:(PhidgetTreeNode *)node inTree:(PhidgetTreeNode *)tree;

@end
