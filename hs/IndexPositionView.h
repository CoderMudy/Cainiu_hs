//
//  IndexPositionView.h
//  hs
//
//  Created by RGZ on 15/7/24.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IndexPositionBaseClass;
@class IndexPositionTopView;
@class IndexViewController;
@class FoyerProductModel;
typedef void(^IndexPositionBlock)();
typedef void(^FundLoadBlock)(BOOL isPosition,NSString * userFund,NSString *userProfit);
@interface IndexPositionView : UIView<UITableViewDelegate,UITableViewDataSource>
{

    NSTimer * _timer;
    BOOL _enable;
    int _num;
}
@property (copy)FundLoadBlock fundLoadBlock;
@property (nonatomic,strong)UITableView * tableView;
@property (copy)IndexPositionBlock block;

@property (nonatomic,assign)int futuresTypes;
@property (nonatomic,strong)IndexPositionBaseClass * indexPositionBaseModel;
@property (nonatomic,strong)IndexPositionTopView * headerView;
@property (nonatomic,strong)IndexViewController * superVC;
@property (nonatomic,strong)NSMutableArray* positionListArray;
@property (nonatomic,strong)NSString * indexName;
@property (nonatomic,strong)NSString * indexCode;

@property (nonatomic,strong)NSString * askPrice;
@property (nonatomic,strong)NSString * bidPrice;
@property (nonatomic,assign)BOOL isPosi;


-(instancetype)initWithFrame:(CGRect)frame withProductModel:(FoyerProductModel*)futuresTypes;

- (void)pageAppearRequestListData;
- (void)pageDisAppear;
- (void)loadPositionData;
- (void)requestListData;
/**
 *闪电平仓
 */
- (void)keySaleOrder;
@end
