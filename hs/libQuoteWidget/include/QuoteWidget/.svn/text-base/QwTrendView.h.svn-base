//
//  QwTrendView.h
//  QuoteWidget
//
//  Created by Gu Jianglai on 14/10/30.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HsTrendViewModel.h"
/*!
 *  @brief  分时线视图
 */
@interface QwTrendView : UIView{
    HsTrendViewModel  *_trendDataPack;
    UIColor *_boundColor;
    NSArray *_lineColors;
    UIColor *_calBGColor;
    UIColor *_fontColor;
    
    double _upLimit;
    double _downLimit;
    double _preClosePrice;
    int    _timeCount;
}
/*!
 *  @brief  分时视图模型
 */
@property (nonatomic, retain) HsTrendViewModel *trendDataPack;
/*!
 *  @brief  边框颜色
 */
@property (nonatomic, retain) UIColor *boundColor;
//
///*!
// *  @brief  绘制边框
// *
// *  @param rect    绘图区域
// *  @param lineNum 横向分割线数量
// *  @param context 绘图上下文
// */
//- (void)drawBoundsInRect:(CGRect) rect innerLine:(NSInteger)lineNum context: (CGContextRef) context;
///*!
// *  @brief  绘制价格标签
// *
// *  @param rect    绘图区域
// *  @param row     额外的价格标签行数
// *  @param context 绘图上下文
// */
//- (void)drawPriceCalInRect:(CGRect)rect withRowNumber: (NSInteger)row context: (CGContextRef)context;
///*!
// *  @brief  绘制涨跌幅百分比标签
// *
// *  @param rect    绘图区域
// *  @param row     额外的涨跌幅百分比标签行数
// *  @param context 绘图上下文
// */
//- (void)drawPercentCalInRect:(CGRect)rect withRowNumber: (NSInteger)row context: (CGContextRef)context;
///*!
// *  @brief  绘制价格和均价曲线
// *
// *  @param rect    绘图区域
// *  @param context 绘图上下文
// */
//- (void) drawPriceCurvesInRect: (CGRect)rect context: (CGContextRef)context;
///*!
// *  @brief  绘制分时成交量图表
// *
// *  @param rect    绘图区域
// *  @param context 绘图上下文
// */
//- (void) drawVolumeChartInRect:(CGRect)rect context: (CGContextRef)context;
///*!
// *  @brief  绘制时间分割线
// *
// *  @param rect    绘图区域
// *  @param context 绘图上下文
// */
//- (void) drawTimeLineInRect:(CGRect)rect context: (CGContextRef)context;


@end
