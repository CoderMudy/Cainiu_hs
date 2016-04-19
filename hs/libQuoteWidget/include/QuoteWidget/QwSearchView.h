//
//  QwSearchView.h
//  QuoteWidget
//
//  Created by Gu Jianglai on 14-9-29.
//  Copyright (c) 2014年 lihao. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QwKeyboardView.h"

/*!
 *  @brief  键盘精灵视图回调
 */
@protocol QwSearchViewDelegate <NSObject>
@required
/*!
 *  @brief  搜索栏文字变化时的通知
 *
 *  @param text 搜索栏改变后的文字
 */
- (void)searchTextDidChange: (NSString *)text;
@optional
/*!
 *  @brief  选中后的回调
 *
 *  @param searchView 触发的QwSearchView
 *  @param indexPath  触发的NSIndexPath
 */
- (void)searchView: (id)searchView userSelectedRowAtindexPath: (NSIndexPath *)indexPath;
@end

/*!
 *  @brief  键盘精灵视图
 */
@interface QwSearchView : UIView<UITableViewDelegate, UISearchBarDelegate,QwKeyboardDelegate,UIScrollViewDelegate>
{
    UISearchBar *_searchBar;
    UITableView *_tableView;
    int         _requestType;
    BOOL        _bflag;
    id          _delegate;
    id          _dataSource;
}
/*!
 *  @brief  键盘精灵回调
 */
@property (nonatomic, assign) id    <QwSearchViewDelegate> delegate;
/*!
 *  @brief  列表数据源
 */
@property (nonatomic, assign) id    <UITableViewDataSource> dataSource;
/*!
 *  @brief  清空搜索栏
 */
-(void)clearSearchField;
/*!
 *  @brief  刷新列表
 */
-(void)reloadData;

@end
