//
//  IndexMarketInfoModel.h
//  hs
//
//  Created by RGZ on 16/1/20.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexMarketInfoModel : NSObject
///涨跌价格
@property (nonatomic,strong)NSString    *upDropPrice;
///涨跌幅率
@property (nonatomic,strong)NSString    *rateOfPriceSpread;
///合约代码
@property (nonatomic,strong)NSString    *instrumentID;
///最新价
@property (nonatomic,strong)NSString    *lastPrice;
///上次结算价
@property (nonatomic,strong)NSString    *preSettlementPrice;
///昨收盘
@property (nonatomic,strong)NSString    *preClosePrice;
///昨持仓量
@property (nonatomic,strong)NSString    *preOpenInterest;
///今开盘
@property (nonatomic,strong)NSString    *openPrice;
///最高价
@property (nonatomic,strong)NSString    *highestPrice;
///最低价
@property (nonatomic,strong)NSString    *lowestPrice;
///数量
@property (nonatomic,strong)NSString    *volume;
///成交金额
@property (nonatomic,strong)NSString    *turnover;
///持仓量
@property (nonatomic,strong)NSString    *openInterest;
///本次结算价
@property (nonatomic,strong)NSString    *settlementPrice;
///涨停板价
@property (nonatomic,strong)NSString    *upperLimitPrice;
///跌停板价
@property (nonatomic,strong)NSString    *lowerLimitPrice;

@end
