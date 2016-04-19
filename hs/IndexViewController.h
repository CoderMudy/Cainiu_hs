//
//  IndexViewController.h
//  hs
//
//  Created by RGZ on 15/7/24.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexOptionButton.h"
#import "IndexSwitchView.h"

@class FoyerProductModel;
@class IndexBuyView;
@interface IndexViewController : UIViewController<UIScrollViewDelegate>
{
    UIView              *_topSubView;//bg
    UILabel             *_topSubLabel;
    UITableView         *_tableView;
    IndexOptionButton   *_optionButton;//激活模块
    IndexSwitchView     *_switchView;//资金模块
    NSMutableArray  *_imgArray;//logo数组
    NSMutableArray  *_titleArray;//标题数组
    NSMutableArray  *_statusArray;//状态数组
    UIView          *_coverView;//遮挡层
    BOOL            indexIsPosition;//是否有持仓
    UIView          *_incomeView;//收益View
    UILabel         *_incomeMoneyLabel;
    UIButton        *_saleButton;//闪电平仓按钮
    
    NSString        *_userFund;//可用余额
    NSString        *_userProfit;//持仓收益
}

typedef NS_ENUM(int,IndexView) {
    All         = 0,
    Income      = 1,
    Capital     = 2,
    Activate    = 4
};

@property (nonatomic,strong)UISegmentedControl  *seg;

//1:沪金  2:期指    3:沪银
@property (nonatomic,assign)int     indexState;
@property (nonatomic,strong)NSString * name;
@property (nonatomic,strong)NSString * code;
//是否有持仓数据（如果有直接跳转持仓）
@property (nonatomic,assign)BOOL     isPosition;


@property (nonatomic,strong)NSString    *ip;
@property (nonatomic,strong)NSString    *port;

@property (nonatomic,strong)FoyerProductModel * productModel;
@property (nonatomic,strong)IndexBuyView        *indexBuyV;

@property (nonatomic,assign)BOOL        isSecondJump;//是否二次跳转，即持仓页和行情页相互跳转

/**
 *  0:不包含   1：包含，但未激活   2：包含，且激活
 */
@property (nonatomic,assign)int     cainiuStatus;
@property (nonatomic,assign)int     scoreStatus;
@property (nonatomic,assign)int     nanjsStatus;

-(void)requestPositionData;//刷新持仓收益

@end


@interface IndexViewController (Login)<UITableViewDataSource,UITableViewDelegate>

-(void)loadLoginUI;

-(void)reloadUIAndData;
//可用资金
-(void)setUsedMoney:(NSString *)aMoney;
//收益
-(void)setIncomeMoney:(NSString *)aMoney;
//提示激活账户
-(void)proActivitionAccount;
@end
