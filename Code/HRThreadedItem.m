//
//  HRThreadedItem.m
//  HRThreadedTableView
//
//  Created by Harry Richardson on 28/11/2013.
//  Copyright (c) 2013 Harry Richardson. All rights reserved.
//

#import "HRThreadedItem.h"

@implementation HRThreadedItem

#pragma mark - Public

-(id)init
{
    if (self = [super init]) {
        _children = [NSMutableArray array];
    }
    return self;
}

-(BOOL)visible
{
    // Root comment, always has a visible header
    if (self.parent == nil) {
        return YES;
    }
    // If parent is collapsed, this one shouldn't be visible at all
    if (self.parent.collapsed) {
        return NO;
    }
    
    // Otherwise this is visible (but could also be collapsed, of course, meaning
    // the post text isn't visible)
    return YES;
}

- (NSArray*)flattenedChildren
{
    NSMutableArray *children = [NSMutableArray array];
    
    [children addObjectsFromArray:[self childrenUnderComment:self]];
    
    return children;
}

#pragma mark - Private

- (NSArray*)childrenUnderComment:(HRThreadedItem*)tc
{
    NSMutableArray *children = [NSMutableArray array];
    
    for (HRThreadedItem *child in tc.children) {
        [children addObject:child];
        [children addObjectsFromArray:[self childrenUnderComment:child]];
    }
    return children;
}

@end
