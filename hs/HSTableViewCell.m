//
//  HSTableViewCell.m
//  EGOTableViewPullRefreshDemo
//
//  Created by gg on 15/5/8.
//
//

#import "HSTableViewCell.h"

@implementation HSTableViewCell

- (CGPoint)locationInView:(UIView *)parent
{
    UIView *view = self.contentView;
    CGPoint pt = self.contentView.frame.origin;
    
    while (true) {
        view = view.superview;
        if (!view)
            break;
        
        pt.x += view.frame.origin.x;
        pt.y += view.frame.origin.y;
        if (view == parent)
            break;
    }
    return pt;
}

- (UITableView *)getCellTableView
{
    UIView *view = self.superview;
    NSInteger count = 0;
    while (view && count < 5) {
        if ([view isKindOfClass:[UITableView class]])
            return (UITableView *)view;
        view = view.superview;
        count++;
    }
    return nil;
}

- (NSIndexPath *)getIndexPath
{
    UITableView *tableView = [self getCellTableView];
    if (!tableView || !tableView.dataSource)
        return nil;
    if ([tableView numberOfSections] < 1)
        return nil;
    CGPoint currentTouchPosition = [self locationInView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:currentTouchPosition];
    return indexPath;
}

- (void)updateCell
{
    UITableView *table = [self getCellTableView];
    NSIndexPath *path = [self getIndexPath];
    if (!table || !path)
        return;
    if ([table numberOfSections] <= path.section ||
        [table numberOfRowsInSection:path.section] <= path.row)
        return;
    [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:path]
                 withRowAnimation:UITableViewRowAnimationNone];
}


@end
