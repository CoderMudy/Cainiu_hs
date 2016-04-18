//
//  HsViewModel.h
//  QuoteWidget
//
//  Created by lihao on 14-9-30.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HsStock.h"
#import "HsRealtime.h"

/*!
 *  @brief  视图模型基类
 */
@interface HsViewModel : NSObject
{
    HsStock             *_stock;
    HsRealtime          *_realtime;
    NSMutableArray      *_stockCategorys;//当前股票所属板块信息
}
/*!
 *  @brief  关联的个股信息
 */
@property (nonatomic, retain) HsStock *stock;
/*!
 *  @brief  关联的个股快照数据模型
 */
@property (nonatomic, retain) HsRealtime *realtime;

/*!
 * 涨跌额
 */
-(NSString*)getPriceChange;

/*!
 * 涨跌幅
 */
-(NSString*)getPriceChangePercent;

//-(NSMutableArray*)getCategorys;



@end
