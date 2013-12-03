//
//  HRSectionHeaderView.m
//  HRThreadedTableView
//
//  Created by Harry Richardson on 28/11/2013.
//  Copyright (c) 2013 Harry Richardson. All rights reserved.
//

#import "HRSectionHeaderView.h"

@interface HRSectionHeaderView()

@property (nonatomic) BOOL expanded;

@end

@implementation HRSectionHeaderView

- (id)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    // The header would start in an expanded state - if you want them to start in a collapsed state,
    // sort your views out, and then set this to NO.
    self.expanded = YES;
    
    // Set up the tap gesture recognizer.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(toggleOpen:)];
    [self addGestureRecognizer:tapGesture];
}

-(void)toggleOpen:(id)sender
{
    [self toggleOpenWithUserAction:YES];
}

-(void)toggleOpenWithUserAction:(BOOL)userAction
{
    self.expanded = !self.expanded;
    
    // If this was a user action, send the delegate the appropriate message.
    if (userAction) {
        if (self.expanded) {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [self.delegate sectionHeaderView:self sectionOpened:self.section];
            }
        }
        else {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
            }
        }
    }
}


@end
