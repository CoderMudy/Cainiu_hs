//
//  IndexRealtime.h
//  HsH5Message
//
//  Created by lihao on 14-9-24.
//  Copyright (c) 2014年 hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HsRealtime.h"
/*!
 *  @brief  指数快照数据模型
 */
@interface HsIndexRealtime : HsRealtime
/*!
 *  @brief  证券总数
 */
@property(nonatomic, assign)int totalStocks;//证券总数
/*!
 *  @brief  涨家数
 */
@property(nonatomic, assign)int riseCount;//涨家数
/*!
 *  @brief  跌家数
 */
@property(nonatomic, assign)int fallCount;//跌家数
/*!
 *  @brief  上涨趋势
 */
@property(nonatomic, assign)int riseTrend;//上涨趋势
/*!
 *  @brief  下跌趋势
 */
@property(nonatomic, assign)int fallTrend;//下跌趋势
/*!
 *  @brief  ADL指标
 */
@property(nonatomic, assign)int ADL;//ADL指标
/*!
 *  @brief  领先指标
 */
@property(nonatomic, assign)int lead;//领先指标

/*!
 *  @brief  领涨股快照数据模型列表
 */
@property(nonatomic, retain)NSMutableArray *riseLeading;//领涨股
/*!
 *  @brief  5分钟领涨股快照数据模型列表
 */
@property(nonatomic, retain)NSMutableArray *FiveMinuteRiseLeading;//5分钟领涨股
/*!
 *  @brief  领跌股快照数据模型列表
 */
@property(nonatomic, retain)NSMutableArray *fallLeading;//领跌股
/*!
 *  @brief  5分钟领跌股快照数据模型列表
 */
@property(nonatomic, retain)NSMutableArray *FiveMinuteFallLeading;//5分钟领跌股

@end
