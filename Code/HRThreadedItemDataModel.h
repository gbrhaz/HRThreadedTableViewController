//
//  HRThreadedItemDataModel.h
//  HRThreadedTableView
//
//  Created by Harry Richardson on 28/11/2013.
//  Copyright (c) 2013 Harry Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HRThreadedItem;

@interface HRThreadedItemDataModel : NSObject

@property (nonatomic, copy) NSArray *rootItems; // of type HRThreadedItem or subclasses thereof

- (NSInteger)totalNumberOfVisibleItems;
- (HRThreadedItem*)itemAtSection:(NSInteger)section;

@end
