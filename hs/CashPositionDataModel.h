//
//  CashPositionDataModel.h
//  hs
//
//  Created by PXJ on 15/12/3.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CashPositionDataModel : NSObject

@property (nonatomic,strong)NSString * account;//持仓数量
@property (nonatomic,strong)NSString * price;//持仓均价
@property (nonatomic,strong)NSString * newprice;// 最新价
@property (nonatomic,strong)NSString * consultCost;//参考成本价（保本价）
@property (nonatomic,strong)NSString * wareId;//商品代码
@property (nonatomic,strong)NSString * buyOrSal;// 买入方式 B：买入开多  S：卖出看空
@property (nonatomic,strong)NSString * bidPrice;//买空价
@property (nonatomic,strong)NSString * askPrice;//买多价
@property (nonatomic,strong)NSString * orderId;//订单ID（闪电平仓时需要）
@property (nonatomic,strong)NSString * enableSaleNum;//可卖数量
- (id)initWithDic:(NSDictionary*)dictionary;

@end
