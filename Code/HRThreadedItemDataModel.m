//
//  HRThreadedItemDataModel.m
//  HRThreadedTableView
//
//  Created by Harry Richardson on 28/11/2013.
//  Copyright (c) 2013 Harry Richardson. All rights reserved.
//

#import "HRThreadedItemDataModel.h"
#import "HRThreadedItem.h"

@interface HRThreadedItemDataModel()
@end

@implementation HRThreadedItemDataModel

#pragma mark - Public

- (NSInteger)totalNumberOfVisibleItems
{
    NSInteger count = self.rootItems.count;
    for (HRThreadedItem *item in self.rootItems) {
        count += [self _numberOfVisibleCommentsUnderItem:item];
    }
    return count;
}

- (HRThreadedItem*)itemAtSection:(NSInteger)section
{
    NSInteger current = 0;
    HRThreadedItem *currentComment = nil;
    
    for (HRThreadedItem *root in self.rootItems)
    {
        if (current == section) {
            return root;
        }
        current++;
        
        NSArray *children = [self _visibleChildrenUnderItem:root];
        
        //TODO: Potential optimisation:
        // if section is greater than visible children,
        // it won't be in this section, so move on, incrementing 'current'
        
        for (HRThreadedItem *child in children)
        {
            if (current == section) {
                return child;
            }
            current++;
        }
    }
    
    
    return currentComment;
}

#pragma mark - Private

- (NSInteger)_numberOfVisibleCommentsUnderItem:(HRThreadedItem*)item
{
    NSInteger count = 0;
    for (HRThreadedItem *child in item.children)
    {
        if (child.visible) {
            count++;
            count += [self _numberOfVisibleCommentsUnderItem:child];
        }
    }
    return count;
}

- (NSArray*)_visibleChildrenUnderItem:(HRThreadedItem*)item
{
    NSMutableArray *children = [NSMutableArray array];
    
    for (HRThreadedItem *child in item.children)
    {
        if (!child.visible) {
            continue;
        }
        [children addObject:child];
        [children addObjectsFromArray:[self _visibleChildrenUnderItem:child]];
    }
    return children;
}



@end
