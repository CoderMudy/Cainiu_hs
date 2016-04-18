//
//  CashPositonHeaderView.h
//  hs
//
//  Created by PXJ on 15/11/25.
//  Copyright © 2015年 luckin. All rights reserved.
//
typedef void(^CashHeaderClickBlock)(UIButton *button);

@class CashPositionDataModel;
#import <UIKit/UIKit.h>

@interface CashPositonHeaderView : UIView
@property (nonatomic,strong)UIView * earnView; //盈亏View
@property (nonatomic,strong)UILabel * signLab;//正负号
@property (nonatomic,strong)UILabel * titleLab; //浮动盈亏
@property (nonatomic,strong)UILabel * earnLab;  // 浮动盈亏值
@property (nonatomic,strong)UILabel * riseLab;  // 涨跌幅

@property (nonatomic,strong)UIView * orderView; //持仓总订单显示View
@property (nonatomic,strong)CashHeaderClickBlock clickBlock;

- (id)initWithFrame:(CGRect)frame model:(FoyerProductModel*)model;


/**
 *  刷新现货持仓头部
 */
- (void)reloadCashPositionData:(id)sender;//接口请求刷新

/** 
 *  刷新现货持仓收益
 *  isPosition 是否持仓
 *  profitStr 收益
 *  riseStr 涨幅
 *  profitColor 收益
 */
- (void)cashViewLoadPushData:(BOOL)isPosition
                   profitStr:(NSString*)profitStr
                     riseStr:(NSString*)riseStr
                        sign:(NSString*)sign
                 profitColor:(UIColor*)profitColor;

@end
