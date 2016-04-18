//
//  HsKlineKDJ.h
//  QuoteWidget
//
//  Created by lihao on 14-10-8.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>
static int KDJ_PARAM_VALUE[] = {9, 3, 3};

@interface HsKlineKDJ : NSObject
{
    NSMutableArray *_klineData;
    NSMutableArray *_Klist;
    NSMutableArray *_Dlist;
    NSMutableArray *_Jlist;
}
/*!
 *  @brief  设置指标参数
 *
 *  @param paramValue 指标参数
 */
+(void)setParam:(int[])paramValue;
/*!
 *  @brief  设置k线数据
 *
 *  @param klineData 数据类型HsStockKlineItem组成的数组可以通过HsKlineViewModel或HsKlineModel获取
 */
-(void)setKlineData:(NSMutableArray*)klineData;
/*!
 *  @brief  以k线数据初始化
 *
 *  @param klineData 数据类型HsStockKlineItem组成的数组可以通过HsKlineViewModel或HsKlineModel获取
 *
 *  @return 实例
 */
-(id)initWithKlineData:(NSMutableArray*)klineData;
/*!
 *  @brief  获取索引位置的K指标数据
 *
 *  @param index 索引
 *
 *  @return 返回索引位置的K指标数据
 */
-(float)getKData:(int)index;
/*!
 *  @brief  获取索引位置的D指标数据
 *
 *  @param index 索引
 *
 *  @return 返回索引位置的D指标数据
 */
-(float)getDData:(int)index;
/*!
 *  @brief  获取索引位置的J指标数据
 *
 *  @param index 索引
 *
 *  @return 返回索引位置的J指标数据
 */
-(float)getJData:(int)index;
/*!
 *  @brief  获取指定区间KDJ的最大值
 *
 *  @param begin 起始索引
 *  @param end   结束索引
 *
 *  @return 返回指定区间KDJ的最大值
 */
-(float)getKDJTopValueFrom:(int)begin To:(int)end;
/*!
 *  @brief  获取KDJ最大值
 *
 *  @return 返回KDJ最大值
 */
-(float)getKDJTopValue;
/*!
 *  @brief  获取指定区间KDJ的最小值
 *
 *  @param begin 起始索引
 *  @param end   结束索引
 *
 *  @return 返回指定区间KDJ的最小值
 */
-(float)getKDJBottomValueFrom:(int)begin To:(int)end;
/*!
 *  @brief  获取KDJ最小值
 *
 *  @return 返回KDJ最小值
 */
-(float)getKDJBottomValue;

@end
