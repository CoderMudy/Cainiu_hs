//
//  HSBaseTableViewController.h
//  EGOTableViewPullRefreshDemo
//
//  Created by gg on 15/5/8.
//
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"
@interface HSBaseTableViewController : UITableViewController <UITableViewDataSource, PullTableViewDelegate,UITableViewDelegate>
{
}
@property (nonatomic,strong)PullTableView *pullTableView;

@property (nonatomic, assign) BOOL pullDownRefresh;
@property (nonatomic, assign) BOOL pullUpRefresh;
@property (nonatomic, strong) NSArray *headerArray;

@property (nonatomic, assign) BOOL isExistSectionHead;

@property (nonatomic, assign) NSInteger cellHeigth;

- (void)setCellClassString:(NSString *)className;
- (void)setCellDisplayData:(id )cellDataArray;
- (void)setHeaderArray:(NSArray *)headerArray;

- (void)loadMoreData;
- (void)refreshData;

- (void)refreshFinish;
- (void)loadMoreFinish;

- (void)setNavLeftBut;
- (void)setNavTitle:(NSString *)title;
- (void)setNavRigthBut:(NSString *)titleStr butImage:(UIImage *)butImage butHeigthImage:(UIImage *)heigtLigthImage select:(SEL)selector;

- (void)tableView:(UITableView *)tableView clickTableViewCell:(NSIndexPath *)indexPath;

@end
