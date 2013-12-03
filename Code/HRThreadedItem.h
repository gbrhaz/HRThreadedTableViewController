//
//  HRThreadedItem.h
//  HRThreadedTableView
//
//  Created by Harry Richardson on 28/11/2013.
//  Copyright (c) 2013 Harry Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRThreadedItem : NSObject

@property (nonatomic) BOOL collapsed;
@property (nonatomic, strong) NSMutableArray *children;
@property (nonatomic) HRThreadedItem *parent;
@property (nonatomic) NSInteger indentation;

- (NSArray*)flattenedChildren;
- (BOOL)visible;

@end