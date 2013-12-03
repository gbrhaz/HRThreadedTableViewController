//
//  HRThreadedTableViewController.m
//  HRThreadedTableView
//
//  Created by Harry Richardson on 28/11/2013.
//  Copyright (c) 2013 Harry Richardson. All rights reserved.
//

#import "HRThreadedTableViewController.h"
#import "HRThreadedItem.h"
#import "HRThreadedItemDataModel.h"



@interface HRThreadedTableViewController ()
@end

@implementation HRThreadedTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Public

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataModel totalNumberOfVisibleItems];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HRThreadedItem *item = [self.dataModel itemAtSection:section];
    
    // The item is visible, but collapsed, so it won't show the "thread", but it shows the section
    if (item.collapsed) {
        return 0;
    }

    return 1;
}

#pragma mark - Settings Header Delegate

-(void)sectionHeaderView:(HRSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section
{
    HRThreadedItem *item = [self.dataModel itemAtSection:section];
    if (!item.collapsed) {
        return;
    }
    
    item.collapsed = NO;
    NSArray *children = [item flattenedChildren];
    for (HRThreadedItem *child in children) {
        child.collapsed = NO;
    }
    
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:0 inSection:section]];
    for (NSInteger i = 0; i < children.count; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:0 inSection:section + i + 1]];
    }
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(section+1, children.count)];
    
    // Change the section integers for each header, so the next time it's pressed, it corresponds to the correct section
    for (NSInteger i = section+1; i < self.tableView.numberOfSections; i++) {
        HRSectionHeaderView *headerView = (HRSectionHeaderView*)[self.tableView headerViewForSection:i];
        headerView.section += children.count;
    }
    
    [self.tableView beginUpdates];
    [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    [self.tableView scrollToRowAtIndexPath:[indexPathsToInsert objectAtIndex:0]
                          atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

-(void)sectionHeaderView:(HRSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section
{
    HRThreadedItem *item = [self.dataModel itemAtSection:section];
    NSInteger collapsedChildren = [self collapseTableCommentsUnderComment:item startDepth:item.indentation];
    
    // Remove rows
    NSMutableArray *rowsToDelete = [[NSMutableArray alloc] init];
    [rowsToDelete addObject:[NSIndexPath indexPathForRow:0 inSection:section]];
    for (NSInteger i = 0; i < collapsedChildren; i++) {
        [rowsToDelete addObject:[NSIndexPath indexPathForRow:0 inSection:section + i + 1]];
    }
    
    //Remove sections
    NSIndexSet *sectionsToDelete = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(section+1, collapsedChildren)];
    
    // Change the section integers for each header, so the next time it's pressed, it corresponds to the correct section
    for (NSInteger i = section+1+collapsedChildren; i < self.tableView.numberOfSections; i++) {
        HRSectionHeaderView *headerView = (HRSectionHeaderView*)[self.tableView headerViewForSection:i];
        headerView.section -= collapsedChildren;
    }
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:rowsToDelete
                          withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView deleteSections:sectionsToDelete withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (NSInteger)collapseTableCommentsUnderComment:(HRThreadedItem*)tc startDepth:(NSInteger)startDepth
{
    // Need to count the number of children that are being collapsed JUST this time - not
    // counting any that were collapsed previously. Do this by looking at any that aren't collapsed,
    // and any that are immediate children and whether they're collapsed (visible but not showing comment)
    NSInteger collapsed = 0;
    
    for (HRThreadedItem *child in tc.children)
    {
        collapsed += [self collapseTableCommentsUnderComment:child startDepth:startDepth];
        
        if (!child.collapsed) {
            child.collapsed = YES;
            collapsed++;
        } else if (child.indentation > startDepth && [child visible]) {
            collapsed++;
        }
    }
    tc.collapsed = YES;
    
    return collapsed;
}


@end
