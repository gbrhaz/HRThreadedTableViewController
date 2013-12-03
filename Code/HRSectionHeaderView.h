//
//  HRSectionHeaderView.h
//  HRThreadedTableView
//
//  Created by Harry Richardson on 28/11/2013.
//  Copyright (c) 2013 Harry Richardson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HRSectionHeaderView;

@protocol HRSectionHeaderViewDelegate <NSObject>

@optional
-(void)sectionHeaderView:(HRSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section;
-(void)sectionHeaderView:(HRSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section;

@end

@interface HRSectionHeaderView : UITableViewHeaderFooterView

@property (weak) id<HRSectionHeaderViewDelegate> delegate;
@property (nonatomic) NSInteger section;
@property (nonatomic) NSInteger indentation;

-(void)toggleOpenWithUserAction:(BOOL)userAction;

@end
