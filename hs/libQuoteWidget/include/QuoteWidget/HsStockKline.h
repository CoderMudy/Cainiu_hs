//
//  HsStockKline.h
//  QuoteWidget
//
//  Created by lihao on 14-10-16.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @brief  K线数据模型
 */
@interface HsStockKline : NSObject
/*!
 *  @brief  K线数据，HsStockKlineItem类型组成的数组
 */
@property(nonatomic, retain)NSMutableArray *klineDatas;
/*!
 *  @brief  K线周期
 */
@property(nonatomic, assign)int period;


@end
