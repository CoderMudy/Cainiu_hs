//
//  StockTrendItem.h
//  HsH5Message
//
//  Created by lihao on 14-9-24.
//  Copyright (c) 2014年 hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 *  @brief  分时线明细数据模型
 */
@interface HsStockTrendItem : NSObject
/*!
 *  @brief  价格
 */
@property(nonatomic, assign)double price;
/*!
 *  @brief  均价
 */
@property(nonatomic, assign)double avg;
/*!
 *  @brief  加权均价
 */
@property(nonatomic, assign)double wavg;
/*!
 *  @brief  成交量
 */
@property(nonatomic, assign)int64_t vol;
/*!
 *  @brief  成交额
 */
@property(nonatomic, assign)int64_t money;
/*!
 *  @brief  分时数据时间
 */
@property(nonatomic, assign)int32_t time;

@end
