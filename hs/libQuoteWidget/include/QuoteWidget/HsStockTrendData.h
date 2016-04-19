//
//  StockTrendData.h
//  HsH5Message
//
//  Created by lihao on 14-9-24.
//  Copyright (c) 2014年 hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 *  @brief  分时线数据模型
 */
@interface HsStockTrendData : NSObject

/*!
 *  @brief  分时线明细数据，HsStockTrendItem类型组成的数据
 */
@property(nonatomic, retain)NSMutableArray* items;
/*!
 *  @brief  分时线日期
 */
@property(nonatomic, assign)int date;

@end
