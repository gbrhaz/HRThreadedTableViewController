//
//  HRThreadedTableViewController.h
//  HRThreadedTableView
//
//  Created by Harry Richardson on 28/11/2013.
//  Copyright (c) 2013 Harry Richardson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRSectionHeaderView.h"

@class HRThreadedItemDataModel;

static NSString *HRSectionHeaderIdentifier = @"HRSectionHeaderIdentifier";

@interface HRThreadedTableViewController : UITableViewController <HRSectionHeaderViewDelegate>

@property (nonatomic, strong) HRThreadedItemDataModel *dataModel;

@end
