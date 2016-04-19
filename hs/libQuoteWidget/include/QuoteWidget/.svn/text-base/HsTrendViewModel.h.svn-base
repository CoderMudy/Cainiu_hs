//
//  HsTrendViewModel.h
//  QuoteWidget
//
//  Created by lihao on 14-10-8.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HsViewModel.h"
#import "HsStockTrendData.h"
#import "HsStockTrendItem.h"

/*!
 *  @brief  分时线视图模型类
 */
@interface HsTrendViewModel :HsViewModel
{
    HsStockTrendData *_trendData;
}
/*!
 *  @brief  分时数据模型
 */
@property (nonatomic, retain) HsStockTrendData *trendData;
/*!
 *  @brief  获取指定位置的分时数据
 *
 *  @param index 位置索引
 *
 *  @return 指定位置的分时数据
 */
-(HsStockTrendItem*)getTrendItem:(int)index;
/*!
 *  @brief  获取开闭市时间
 *
 *  @return 返回包含HsTradeTime类型的开闭市时间数组
 */
-(NSArray*)getOpenCloseTime;
/*!
 *  @brief  获取昨收价
 */
-(double)getPrevClosePrice;
/*!
 *  @brief  获取当前分时数据的最高价
 */
-(double)getHighestPrice;
/*!
 *  @brief  获取当前分时数据的最低价
 */
-(double)getLowestPrice;
/*!
 *  @brief  获取当前分时数据的最高成交额
 */
-(float)getMaxVolume;
/*!
 *  @brief  获取当前分时数据数量
 */
-(int)getTrendsCount;

@end
