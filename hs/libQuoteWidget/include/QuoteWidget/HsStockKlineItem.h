//
//  StockKlineItem.h
//  HsH5Message
//
//  Created by lihao on 14-9-24.
//  Copyright (c) 2014年 hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 *  @brief  K线明细数据模型
 */
@interface HsStockKlineItem : NSObject
/*!
 *  @brief  K线截止日期
 */
@property(nonatomic, assign)int32_t date;
/*!
 *  @brief  K线截止时间，一天及以上周期的K线该字段应为0
 */
@property(nonatomic, assign)int32_t time;
/*!
 *  @brief  开盘价
 */
@property(nonatomic, assign)double openPrice;
/*!
 *  @brief  最高价
 */
@property(nonatomic, assign)double highPrice;
/*!
 *  @brief  最低价
 */
@property(nonatomic, assign)double lowPrice;
/*!
 *  @brief  收盘价
 */
@property(nonatomic, assign)double closePrice;
/*!
 *  @brief  成交额
 */
@property(nonatomic, assign)int64_t money;
/*!
 *  @brief  成交量
 */
@property(nonatomic, assign)int64_t volume;

@end
