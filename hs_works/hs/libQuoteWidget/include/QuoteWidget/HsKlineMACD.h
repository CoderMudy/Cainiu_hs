//
//  HsKlineMACD.h
//  QuoteWidget
//
//  Created by lihao on 14-10-8.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 *  @brief  MACD参数
 */
static int MACD_PARAM_VALUE[] = {12, 26, 9};

@interface HsKlineMACD : NSObject
{
    NSMutableArray  *_klineData;
    
    NSMutableArray  *_DIFFList;
    NSMutableArray  *_DEAList;
    NSMutableArray  *_MACDList;
}

/*!
 *  @brief  设置MACD参数
 *
 *  @param paramValue MACD参数
 */
+(void)setParam:(int[])paramValue;
/*!
 *  @brief  以给定k线数据初始化
 *
 *  @param klineData 数据类型HsStockKlineItem组成的数组可以通过HsKlineViewModel或HsKlineModel获取
 *
 *  @return 实例对象
 */
-(id)initWithKlineData:(NSMutableArray*)klineData;
/*!
 *  @brief  设置k线数据
 *
 *  @param klineData 数据类型HsStockKlineItem组成的数组可以通过HsKlineViewModel或HsKlineModel获取
 */
-(void)setKlineData:(NSMutableArray*)klineData;
/*!
 *  @brief  获取索引位置的MACD值
 *
 *  @param index 索引
 *
 *  @return 索引位置的MACD值
 */
-(float)getMACD:(int)index;
/*!
 *  @brief  获取索引位置的DIFF值
 *
 *  @param index 索引
 *
 *  @return 索引位置的DIFF值
 */
-(float)getDIFF:(int)index;
/*!
 *  @brief  获取索引位置的Dea值
 *
 *  @param index 索引
 *
 *  @return 索引位置的Dea值
 */
-(float)getDea:(int)index;

-(float)getMACDBottomValueFrom:(int)begin To:(int)end;
-(float)getMACDBottomValue;

-(float)getMACDTopValueFrom:(int)begin To:(int)end;
-(float)getMACDTopValue;

@end
