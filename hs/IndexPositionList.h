//
//  IndexPositionList.h
//
//  Created by   on 15/8/3
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface IndexPositionList : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double theoryCounterFee;//应扣手续费
@property (nonatomic, assign) double lossProfit;//结算收益
@property (nonatomic, strong) NSString * nickName;//
@property (nonatomic, assign) double status;//订单状态（-1：支付失败-2：买入失败 0：买入待处理 1：买入处理中 2：买委托成功 3：持仓中 4：卖出处理中 5：卖委托成功 6：卖出成功）
@property (nonatomic, assign) double couponId;//抵用券ID
@property (nonatomic, assign) double tradeType;//交易类型0看多1看空
@property (nonatomic, assign) double count;//买入数量（单位：手）
@property (nonatomic, assign) double futuresId;//
@property (nonatomic, assign) double futuresType;//期货类型1黄金2白银3股指
@property (nonatomic, strong) NSString *displayId;//订单展示ID
@property (nonatomic, strong) NSString *buyDate;//买入日期
@property (nonatomic, assign) double stopProfit;//触发止盈金额
@property (nonatomic, assign) double cashFund;//保证金
@property (nonatomic, assign) double stopLossPrice;//止损价
@property (nonatomic, strong) NSString * buyPrice;//买入价
@property (nonatomic, strong) NSString *sysSetSaleDate;//合约期
@property (nonatomic, assign) double listIdentifier;//订单Id
@property (nonatomic, assign) double financyAllocation;//
@property (nonatomic, assign) double fundType;//订单类型0现金1积分123456
@property (nonatomic, assign) double counterFee;//手续费
@property (nonatomic, assign) double stopLoss;//触发止损金额
@property (nonatomic, strong) NSString * saleDate;//saleDate
@property (nonatomic, assign) double salePrice;//卖出价格
@property (nonatomic, strong) NSString *createDate;//订单创建日期
@property (nonatomic, assign) double stopProfitPrice;//止盈价
@property (nonatomic, strong) NSString * futuresCode;//合约编号
@property (nonatomic, assign) BOOL isNeedCheck;//是否需要验证
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
