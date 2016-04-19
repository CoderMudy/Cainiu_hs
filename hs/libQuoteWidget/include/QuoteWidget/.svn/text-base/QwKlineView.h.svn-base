//
//  QwKlineView.h
//  QuoteWidget
//
//  Created by Gu Jianglai on 14/10/21.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HsKlineViewModel.h"
/*!
 *  @brief  k线视图
 */
@interface QwKlineView : UIView{//默认竖屏
    HsKlineViewModel *_klineDataPack;
    UIColor *_boundColor;
    UIColor *_calBGColor;
    UIColor *_fontColor;
    UIColor *_infoBGColor;
    
    CGFloat _stickWidth;
    CGFloat _offsetX;
    NSArray *_lineColors;
    
    QwKlineIdxType _idxType;
    
    int _nStartIDX;
    int _nEndIDX;
    int _nSticks;
    int _focusIndex;
}
/*!
 *  @brief  边框颜色
 */
@property (nonatomic, retain) UIColor *boundColor;
/*!
 *  @brief  k线视图模型
 */
@property (nonatomic, retain) HsKlineViewModel *klineDataPack;
/*!
 *  @brief  k线指标类型
 */
@property (nonatomic, assign) QwKlineIdxType idxType;
/*!
 *  @brief  绘制结束（最右侧）的K线索引
 */
@property (nonatomic, assign) int nEndIDX;
/*!
 *  @brief  K线阳线线宽
 */
@property (nonatomic, assign) CGFloat stickWidth;

/*!
 *  @brief  绘制边框
 *
 *  @param rect    绘制区域
 *  @param lineNum 横向分割线数量
 *  @param context 绘图上下文
 */
- (void)drawBoundsInRect:(CGRect) rect innerLine:(NSInteger)lineNum context: (CGContextRef) context;
/*!
 *  @brief  绘制价格标签
 *
 *  @param rect    绘制区域
 *  @param row     绘制的额外行数
 *  @param context 绘图上下文
 */
- (void)drawPriceCalInRect:(CGRect)rect withRowNumber: (NSInteger)row  context: (CGContextRef)context;
/*!
 *  @brief  绘制时间标签
 *
 *  @param rect    绘图区域
 *  @param context 绘图上下文
 */
- (void) drawTimeCalInRect: (CGRect)rect context: (CGContextRef)context;
/*!
 *  @brief  绘制K线
 *z
 *  @param rect    绘图区域
 *  @param context 绘图上下文
 */
- (void) drawDayDatasInRect:(CGRect)rect context: (CGContextRef)context;
/*!
 *  @brief  绘制MA曲线
 *
 *  @param rect    绘图区域
 *  @param context 绘图上下文
 */
- (void) drawMACurvesInRect:(CGRect)rect context: (CGContextRef)context;
/*!
 *  @brief  绘制成交量图表及标签
 *
 *  @param rect    绘图区域
 *  @param calRect 标签绘图区域
 *  @param context 绘图上下文
 */
- (void) drawVolumeDataInRect:(CGRect)rect withCalInRect:(CGRect)calRect context: (CGContextRef)context;
/*!
 *  @brief  绘制MACD图表及标签
 *
 *  @param rect    绘图区域
 *  @param calRect 标签绘图区域
 *  @param context 绘图上下文
 */
- (void) drawMACDDataInRect: (CGRect)rect withCalInRect:(CGRect)calRect context: (CGContextRef)context;
/*!
 *  @brief  绘制ASI图表及标签
 *
 *  @param rect    绘图区域
 *  @param calRect 标签绘图区域
 *  @param context 绘图上下文
 */
- (void) drawASIDataInRect: (CGRect)rect withCalInRect:(CGRect)calRect context: (CGContextRef)context;
/*!
 *  @brief  绘制BIAS图表及标签
 *
 *  @param rect    绘图区域
 *  @param calRect 标签绘图区域
 *  @param context 绘图上下文
 */
- (void) drawBIASDataInRect: (CGRect)rect withCalInRect:(CGRect)calRect context: (CGContextRef)context;
/*!
 *  @brief  绘制BOLL图表及标签
 *
 *  @param rect    绘图区域
 *  @param calRect 标签绘图区域
 *  @param context 绘图上下文
 */
- (void) drawBOLLDataInRect: (CGRect)rect withCalInRect:(CGRect)calRect context: (CGContextRef)context;
/*!
 *  @brief  绘制CCI图表及标签
 *
 *  @param rect    绘图区域
 *  @param calRect 标签绘图区域
 *  @param context 绘图上下文
 */
- (void) drawCCIDataInRect: (CGRect)rect withCalInRect:(CGRect)calRect context: (CGContextRef)context;
/*!
 *  @brief 绘制DMA图表及标签
 *
 *  @param rect    绘图区域
 *  @param calRect 标签绘图区域
 *  @param context 绘图上下文
 */
- (void) drawDMADataInRect: (CGRect)rect withCalInRect:(CGRect)calRect context: (CGContextRef)context;
/*!
 *  @brief  绘制KDJ图表及标签
 *
 *  @param rect    绘图区域
 *  @param calRect 标签绘图区域
 *  @param context 绘图上下文
 */
- (void) drawKDJDataInRect: (CGRect)rect withCalInRect:(CGRect)calRect context: (CGContextRef)context;
/*!
 *  @brief  绘制OBV图表及标签
 *
 *  @param rect    绘图区域
 *  @param calRect 标签绘图区域
 *  @param context 绘图上下文
 */
- (void) drawOBVDataInRect: (CGRect)rect withCalInRect:(CGRect)calRect context: (CGContextRef)context;
/*!
 *  @brief  绘制PSY图表及标签
 *
 *  @param rect    绘图区域
 *  @param calRect 标签绘图区域
 *  @param context 绘图上下文
 */
- (void) drawPSYDataInRect: (CGRect)rect withCalInRect:(CGRect)calRect context: (CGContextRef)context;
/*!
 *  @brief  绘制RSI图表及标签
 *
 *  @param rect    绘图区域
 *  @param calRect 标签绘图区域
 *  @param context 绘图上下文
 */
- (void) drawRSIDataInRect: (CGRect)rect withCalInRect:(CGRect)calRect context: (CGContextRef)context;
/*!
 *  @brief  绘制VOL-HS图表及标签
 *
 *  @param rect    绘图区域
 *  @param calRect 标签绘图区域
 *  @param context 绘图上下文
 */
- (void) drawVOLHSDataInRect: (CGRect)rect withCalInRect:(CGRect)calRect context: (CGContextRef)context;
/*!
 *  @brief  绘制VR图表及标签
 *
 *  @param rect    绘图区域
 *  @param calRect 标签绘图区域
 *  @param context 绘图上下文
 */
- (void) drawVRDataInRect: (CGRect)rect withCalInRect:(CGRect)calRect context: (CGContextRef)context;
/*!
 *  @brief  绘制WR图表及标签
 *
 *  @param rect    绘图区域
 *  @param calRect 标签绘图区域
 *  @param context 绘图上下文
 */
- (void) drawWRDataInRect: (CGRect)rect withCalInRect:(CGRect)calRect context: (CGContextRef)context;

/*!
 *  @brief  绘制成交量信息
 *
 *  @param rect    绘图区域
 *  @param context 绘图上下文
 */
- (void) drawVolumeInfoInRect:(CGRect)rect context: (CGContextRef)context;
/*!
 *  @brief  绘制MACD信息
 *
 *  @param rect    绘图区域
 *  @param context 绘图上下文
 */
- (void) drawMACDInfoInRect:(CGRect)rect context: (CGContextRef)context;
/*!
 *  @brief  绘制ASI信息
 *
 *  @param rect    绘图区域
 *  @param context 绘图上下文
 */
- (void) drawASIInfoInRect:(CGRect)rect context: (CGContextRef)context;
/*!
 *  @brief  绘制BIAS信息
 *
 *  @param rect    绘图区域
 *  @param context 绘图上下文
 */
- (void) drawBIASInfoInRect:(CGRect)rect context: (CGContextRef)context;
/*!
 *  @brief  绘制BOLL信息
 *
 *  @param rect    绘图区域
 *  @param context 绘图上下文
 */
- (void) drawBOLLInfoInRect:(CGRect)rect context: (CGContextRef)context;
/*!
 *  @brief  绘制CCI信息
 *
 *  @param rect    绘图区域
 *  @param context 绘图上下文
 */
- (void) drawCCIInfoInRect:(CGRect)rect context: (CGContextRef)context;
/*!
 *  @brief  绘制DMA信息
 *
 *  @param rect    绘图区域
 *  @param context 绘图上下文
 */
- (void) drawDMAInfoInRect:(CGRect)rect context: (CGContextRef)context;
/*!
 *  @brief  绘制KDJ信息
 *
 *  @param rect    绘图区域
 *  @param context 绘图上下文
 */
- (void) drawKDJInfoInRect:(CGRect)rect context: (CGContextRef)context;
/*!
 *  @brief  绘制OBV信息
 *
 *  @param rect    绘图区域
 *  @param context 绘图上下文
 */
- (void) drawOBVInfoInRect:(CGRect)rect context: (CGContextRef)context;
/*!
 *  @brief  绘制PSY信息
 *
 *  @param rect    绘图区域
 *  @param context 绘图上下文
 */
- (void) drawPSYInfoInRect:(CGRect)rect context: (CGContextRef)context;
/*!
 *  @brief  绘制RSI信息
 *
 *  @param rect    绘图区域
 *  @param context 绘图上下文
 */
- (void) drawRSIInfoInRect:(CGRect)rect context: (CGContextRef)context;
/*!
 *  @brief  绘制VOL-HS信息
 *
 *  @param rect    绘图区域
 *  @param context 绘图上下文
 */
- (void) drawVOLHSInfoInRect:(CGRect)rect context: (CGContextRef)context;
/*!
 *  @brief  绘制VR信息
 *
 *  @param rect    绘图区域
 *  @param context 绘图上下文
 */
- (void) drawVRInfoInRect:(CGRect)rect context: (CGContextRef)context;
/*!
 *  @brief  绘制WR信息
 *
 *  @param rect    绘图区域
 *  @param context 绘图上下文
 */
- (void) drawWRInfoInRect:(CGRect)rect context: (CGContextRef)context;

@end
