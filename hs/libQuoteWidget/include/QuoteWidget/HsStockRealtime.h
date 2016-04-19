//
//  StockRealtime.h
//  HsH5Message
//
//  Created by lihao on 14-9-24.
//  Copyright (c) 2014年 hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HsRealtime.h"
#import "HsFinancialItem.h"
/*!
 *  @brief  个股快照数据模型
 */
@interface HsStockRealtime : HsRealtime
/*!
 *  @brief  涨停价
 */
@property(nonatomic, assign)double highLimitPrice;//涨停价
/*!
 *  @brief  跌停价
 */
@property(nonatomic, assign)double lowLimitPrice;//跌停价
/*!
 *  @brief  外盘
 */
@property(nonatomic, assign)int64_t outside;//外盘
/*!
 *  @brief  内盘
 */
@property(nonatomic, assign)int64_t inside;//内盘
/*!
 *  @brief  财务数据
 */
@property(nonatomic, retain)HsFinancialItem *financial;//财务数据
//买卖盘口
/*!
 *  @brief  买档，PriceVolumeItem类型的数组
 */
@property(nonatomic, retain)NSMutableArray *buyPriceList;
/*!
 *  @brief  卖档，PriceVolumeItem类型的数组
 */
@property(nonatomic, retain)NSMutableArray *sellPriceList;

@end

/*!
 *  @brief  买卖档位数据模型
 */
@interface PriceVolumeItem : NSObject
/*!
 *  @brief  委托价格
 */
@property(nonatomic, assign)double price;
/*!
 *  @brief  委托量
 */
@property(nonatomic, assign)int volume;

@end