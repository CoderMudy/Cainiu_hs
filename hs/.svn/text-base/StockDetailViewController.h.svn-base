//
//  StockDetailViewController.h
//  hs
//
//  Created by PXJ on 15/4/29.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "H5DataCenter.h"
#import "H5DataCenter.h"
#import "HsRealtime.h"
#import "PositionModels.h"
#import "ELDataModels.h"

typedef enum {
    stockShowStyleDefault,//默认显示
    stockShowStyleSwitch//页面切换后
}StockShowStyle;

typedef enum {
    
    stockDetailStyleDefault,//默认单只股票详情
    stockDetailStylePosition,//个人持仓内页
    stockDetailStyleOtherPosition,//他人持仓内页
    stockDetailStyleNum//指数详情
}StockDetailStyle;


@interface StockDetailViewController : HSBaseViewController

@property (nonatomic,assign)StockShowStyle stockShowStyle;
@property (nonatomic,assign)StockDetailStyle stockDetailStyle;
@property (nonatomic,strong)HsStock * stock;
@property (nonatomic,assign)BOOL isbuy;
@property (nonatomic,assign)BOOL isbuyBuy;
@property (nonatomic,assign)BOOL isExponent;

@property (nonatomic,strong)PositionDModel * personPositionListModel;
@property (nonatomic,strong)NSString * odid;
@property (nonatomic,strong)PositionOrderList *userOrderList;
@property (nonatomic,strong)ELOrderList * otherOrderList;
@property (nonatomic,assign)NSInteger stockIndex;
@property (nonatomic,assign)BOOL isPosition;
@property (nonatomic,strong)NSString * source;
@property (nonatomic,strong)HsRealtime *realtime;
@property (nonatomic,strong)UITableView * tableView;




@end
