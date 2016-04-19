//
//  IndexOrderChooseModel.h
//  hs
//
//  Created by RGZ on 16/4/13.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  条件单数据
 */
@interface IndexOrderChooseModel : NSObject


@property (nonatomic,strong)NSString    *typeStr;//品种 黄金
/**
 *  每次跳动金额
 */
@property (nonatomic,strong)NSString    *jump;//每次跳动金额  :￥50
/**
 *  最小跳动点数
 */
@property (nonatomic,strong)NSString    *minJump;//最小跳动点数   :9个点
/**
 *  最低止损金额
 */
@property (nonatomic,strong)NSString    *minStopMoney;//最低止损金额  : ￥450/手
/**
 *  保证金
 */
@property (nonatomic,strong)NSString    *cashFund;//保证金     :止损金额+￥50/手    ------ 50
/**
 *  涨停价
 */
@property (nonatomic,strong)NSString    *highestPrice;//涨停价
/**
 *  跌停价
 */
@property (nonatomic,strong)NSString    *lowestPrice;//跌停价


+(IndexOrderChooseModel *)getOrderChooseDataModelWithInstrumentCode:(NSString *)aCode WithIndexBuyModel:(IndexBuyModel *)aIndexBuyModel;
@end
