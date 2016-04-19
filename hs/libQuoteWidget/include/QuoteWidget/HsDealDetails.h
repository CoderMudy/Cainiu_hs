//
//  DealDetails.h
//  QuoteWidget
//
//  Created by lihao on 14-10-21.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HsStockTickItem.h"
/*!
 *  @brief  成交明细数据模型
 */
@interface HsDealDetails : NSObject
/*!
 *  @brief  成交明细列表，HsStockTickItem类型构成的数组
 */
@property(nonatomic, retain)NSMutableArray *dealItems;//成交明细列表

@end
