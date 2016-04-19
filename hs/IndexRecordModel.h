//
//  IndexRecordBaseClass.h
//
//  Created by   on 15/7/31
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface IndexRecordModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double theoryCounterFee;//应扣手续费
@property (nonatomic, assign) double lossProfit;//结算收益
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, assign) double status;/*订单状态  
                                             *结算单：（-1：支付失败-2：买入失败0：买入待处理1：买入处理中2：买委托成功3：持仓中4：卖出处理中5：卖委托   成功6卖出成功）
                                             *条件单：（-1：已撤单，1：委托中（可撤单），2：已触发）
                                             */
@property (nonatomic, assign) double couponId;//抵用券ID
@property (nonatomic, assign) double tradeType;//交易类型  0 看多  1 看空
@property (nonatomic, assign) double count;//数量
@property (nonatomic, assign) double futuresId;//期货标示
@property (nonatomic, assign) double futuresType;//期货类型
@property (nonatomic, strong) NSString *displayId;//订单展示ID
@property (nonatomic, strong) NSString *buyDate;//买入日期
@property (nonatomic, assign) double stopProfit;//触发止盈额度
@property (nonatomic, assign) double cashFund;//保证金
@property (nonatomic, assign) double stopLossPrice;//触发止损价格
@property (nonatomic, assign) double buyPrice;//买入价
@property (nonatomic, strong) NSString *sysSetSaleDate;//合约到期日期
@property (nonatomic, assign) double internalBaseClassIdentifier;//订单ID
@property (nonatomic, assign) double financyAllocation;//配资额度
@property (nonatomic, assign) double fundType;//货币类型  0 现金  1 积分
@property (nonatomic, assign) double counterFee;//手续费
@property (nonatomic, assign) double stopLoss;//触发止损额度
@property (nonatomic, strong) NSString *saleDate;//卖出日期
@property (nonatomic, assign) double salePrice;//卖出价
@property (nonatomic, strong) NSString *createDate;//订单创建日期
@property (nonatomic, assign) double stopProfitPrice;//触发止盈价格
@property (nonatomic, strong) NSString *futuresCode;//合约代码
@property (nonatomic, strong) NSString * saleOpSource;
@property (nonatomic, strong) NSString * rate;
@property (nonatomic, assign) double conditionId; //（0：市价单，非0：条件单）
@property (nonatomic, assign) double conditionPrice;//委托价
@property (nonatomic, assign) double sizeSymbol;//委托条件（1：小于等于，2：大于等于）

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
