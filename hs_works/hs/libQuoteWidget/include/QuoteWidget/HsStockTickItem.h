//
//  StockTickItem.h
//  HsH5Message
//
//  Created by lihao on 14-9-24.
//  Copyright (c) 2014年 hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 * 成交明细信息数据模型
 */
@interface HsStockTickItem : NSObject
/*!
 *  @brief  成交时间
 */
@property(nonatomic, assign)int32_t time;//当前时间
/*!
 *  @brief  是按买价成交还是按卖价成交(1按买价 0按卖价)
 */
@property(nonatomic, assign)Byte    tradeFlag;//是按买价成交还是按卖价成交(1按买价 0按卖价)
/*!
 *  @brief  成交价
 */
@property(nonatomic, assign)double   price;//成交价
/*!
 *  @brief  成交量
 */
@property(nonatomic, assign)int64_t   volume;//成交量

@end
