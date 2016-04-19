//
//  OrderDetailModel.h
//  hs
//
//  Created by hzl on 15/5/8.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject

/* 订单ID */
@property (nonatomic,strong) NSString * orderId;
/* 订单详情ID */
@property (nonatomic,strong) NSString * orderdetailId;
/* 用户ID */
@property (nonatomic,strong) NSString * userId;
/* 用户名 */
@property (nonatomic,strong) NSString * nickName;
/* 股票代码 */
@property (nonatomic,strong) NSString * stockCode;
/* 股票市场代码 */
@property (nonatomic,strong) NSString * stockCodeType;
/* 股票名称 */
@property (nonatomic,strong) NSString * stockName;
/* 公司证券账户 */
@property (nonatomic,strong) NSString * stockAcc;
/* 公司证券账户所属市场 */
@property (nonatomic,strong) NSString * exchangeType;
/* 产品类型 T+0/T+1 */
@property (nonatomic,strong) NSString * proType;
/* 行业板块 */
@property (nonatomic,strong) NSString * plateName;
/* 板块代码 */
@property (nonatomic,strong) NSString * plateCode;
/* 开盘价 */
@property (nonatomic,strong) NSString * openPrice;
/* 买入价 */
@property (nonatomic,strong) NSString * buyPrice;
/* 卖出价 */
@property (nonatomic,strong) NSString * salePrice;
/* 当前价 */
@property (nonatomic,strong) NSString * curPrice;
/* 买入类型 0现金 1积分 */
@property (nonatomic,strong) NSString * buyType;
/* 实际买入数量 */
@property (nonatomic,strong) NSString * buyCount;
/* 期望买入数量 */
@property (nonatomic,strong) NSString * quantity;
/* 手续费 */
@property (nonatomic,strong) NSString * counterFee;
/* 实际保证金：不包括手续费 */
@property (nonatomic,strong) NSString * cashFund;
/* 展示保证金：包括手续费 */
@property (nonatomic,strong) NSString * lossFund;
/* 操盘额度 */
@property (nonatomic,strong) NSString * operateAmt;
/* 当前积分收益 */
@property (nonatomic,strong) NSString * curScoreProfit;
/* 当前现金收益 */
@property (nonatomic,strong) NSString * curCashProfit;
/* 当前收益率 */
@property (nonatomic,strong) NSString * incomeRate;
/* 当前市值 */
@property (nonatomic,strong) NSString * marketValue;
/* 下单时间 */
@property (nonatomic,strong) NSString * createDate;
/* 订单完成时间 */
@property (nonatomic,strong) NSString * finishDate;
/* 权重 */
@property (nonatomic,assign) double rankScore;
/*
 * 订单状态：
 * -1:买入失败（至少收到一次证券公司处理失败的结果，但是证券公司最终处理失败）
 * 0: 待处理(还未提交到证券公司)
 * 1：买入处理中(已经提交到证券公司，证券公司还未处理)
 * 2：持仓中(证券公司已经处理)
 * 3：卖入处理中(已经通知证券公司卖出，但还未卖出)
 * 4：已完成(证券公司已经卖出)
 * 5：已放弃
 * */
@property (nonatomic,assign) int status;

@end
