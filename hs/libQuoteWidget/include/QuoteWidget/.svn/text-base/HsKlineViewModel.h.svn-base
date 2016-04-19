//
//  HsUSSKlineViewModel.h
//  QuoteWidget
//
//  Created by lihao on 14-10-10.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HsViewModel.h"
#import "HsKlineKDJ.h"
#import "HsKlineMACD.h"
#import "HsKlinePSY.h"
#import "HsKlineRSI.h"
#import "HsKlineASI.h"
#import "HsKlineVR.h"
#import "HsKlineBOLL.h"
#import "HsKlineOBV.h"
#import "HsKlineDMA.h"
#import "HsKlineVOL.h"
#import "HsKlineWR.h"
#import "HsKlineBIAS.h"
#import "HsKlineCCI.h"
#import "HsStockKlineItem.h"
#import "HsStockKline.h"

/*!
 k线指标类型
 */
typedef enum QwKlineIdxType{
    /*!
     *  @brief  成交量
     */
    IDX_VOL = 0,
    /*!
     *  @brief  KDJ
     */
    IDX_KDJ,
    /*!
     *  @brief  MACD
     */
    IDX_MACD,
    /*!
     *  @brief  PSY
     */
    IDX_PSY,
    /*!
     *  @brief  RSI
     */
    IDX_RSI,
    /*!
     *  @brief  ASI
     */
    IDX_ASI,
    /*!
     *  @brief  VR
     */
    IDX_VR,
    /*!
     *  @brief  BOLL
     */
    IDX_BOLL,
    /*!
     *  @brief  OBV
     */
    IDX_OBV,
    /*!
     *  @brief  DMA
     */
    IDX_DMA,
    /*!
     *  @brief  VOL-HS
     */
    IDX_VOLHS,
    /*!
     *  @brief  WR
     */
    IDX_WR,
    /*!
     *  @brief  BIAS
     */
    IDX_BIAS,
    /*!
     *  @brief  CCI
     */
    IDX_CCI
}QwKlineIdxType;

/*!
 *  @brief  k线MA参数
 */
static int MA_PARAM[] = {5, 10, 30};
#define MA_PARAM_SIZE (sizeof(MA_PARAM)/sizeof(int))
/*!
 *  @brief  k线视图模型类
 */
@interface HsKlineViewModel : HsViewModel
{
    HsStockKline    *_stockKline;
    NSMutableArray  *_stockDatas;
    int             _currentIndex;
    
    HsKlineMACD     *_klineMACD;
    HsKlineKDJ      *_klineKDJ;
    HsKlinePSY      *_klinePSY;
    HsKlineRSI      *_klineRSI;
    HsKlineASI      *_klineASI;
    HsKlineVR       *_klineVR;
    HsKlineBOLL     *_klineBOLL;
    HsKlineOBV      *_klineOBV;
    HsKlineDMA      *_klineDMA;
    HsKlineVOL      *_klineVOL;
    HsKlineWR       *_klineWR;
    HsKlineBIAS     *_klineBIAS;
    HsKlineCCI      *_klineCCI;
    
    NSMutableArray  *_maDataList;
    
    int _count;
    int _period;
}

/*!
 * @brief  K线数据数组，数据类型HsStockKlineItem
 */
@property (nonatomic,readonly)NSMutableArray *stockDatas;
/*!
 *  @brief  K线数据模型
 */
@property (nonatomic,retain)HsStockKline *stockKline;

/*!
 * @brief 获取K线数据数量
 */
-(int)getDataSize;


/*!
 * @brief 获取起止时间内的最高成交量
 * @param begin 开始索引
 * @param end 结束索引
 * @return 起止时间内的最高成交量
 */
-(float)getTopDealAmountDuringDaysFrom:(int)begin To:(int)end;

/*!
 * @brief 获取起止时间内的最低成交量
 * @param begin 开始索引
 * @param end 结束索引
 * @return 起止时间内的最低成交量
 */
-(float)getBottomDealAmountDuringDaysFrom:(int)begin To:(int)end;

/*!
 * @brief 获取指定位置的MA值
 * @param type MA类型
 * @param pos 索引位置
 * @return MA值
 */
-(float)getMA:(int)type At:(int)pos;
/*!
 * @brief 获取起止时间内的MA最大值
 * @param MA MA类型
 * @param begin 开始索引
 * @param end 结束索引
 * @return 起止时间内的MA最大值
 */
-(float)getMATopValue:(int)MA From:(int)begin To:(int)end;
/*!
 * @brief 获取起止时间内的MA最小值
 * @param MA MA类型
 * @param begin 开始索引
 * @param end 结束索引
 * @return 起止时间内的MA最小值
 */
-(float)getMABottomValue:(int)MA From:(int)begin To:(int)end;
/*!
 * @brief 获取起止时间内的最高价
 * @param begin 开始索引
 * @param end 结束索引
 * @return 起止时间内的最高价
 */
-(double)getTopPriceFrom:(int)begin To:(int)end;
/*!
 * @brief 获取起止时间内的最低价
 * @param begin 开始索引
 * @param end 结束索引
 * @return 起止时间内的最低价
 */
-(double)getBottomPriceFrom:(int)begin To:(int)end;
/*!
 * @brief 获取指定位置MA的最大值
 * @param pos 索引位置
 * @return MA的最大值
 */
-(float)getMaxMaValue:(int)pos;
/*!
 * @brief 获取指定位置MA的最小值
 * @param pos 索引位置
 * @return MA的最小值
 */
-(float)getMinMaValue:(int)pos;

/*!
 * @brief 获取当前K线周期类型
 */
-(int)getPeriod;

/*!
 * @brief 获取当前K线ASI指标数据
 */
-(HsKlineASI*)getKlineASI;
/*!
 * @brief 获取当前K线BIAS指标数据
 */
-(HsKlineBIAS*)getKlineBIAS;
/*!
 * @brief 获取当前K线BOLL指标数据
 */
-(HsKlineBOLL*)getKlineBOLL;
/*!
 * @brief 获取当前K线DMA指标数据
 */
-(HsKlineDMA*)getKlineDMA;
/*!
 * @brief 获取当前K线DKJ指标数据
 */
-(HsKlineKDJ*)getKlineKDJ;
/*!
 * @brief 获取当前K线MACD指标数据
 */
-(HsKlineMACD*)getKlineMACD;
/*!
 * @brief 获取当前K线OBV指标数据
 */
-(HsKlineOBV*)getKlineOBV;
/*!
 * @brief 获取当前K线PSY指标数据
 */
-(HsKlinePSY*)getKlinePSY;
/*!
 * @brief 获取当前K线RSI指标数据
 */
-(HsKlineRSI*)getKlineRSI;
/*!
 * @brief 获取当前K线VOL-HS指标数据
 */
-(HsKlineVOL*)getKlineVOL;
/*!
 * @brief 获取当前K线VR指标数据
 */
-(HsKlineVR*)getKlineVR;
/*!
 * @brief 获取当前K线WR指标数据
 */
-(HsKlineWR*)getKlineWR;
/*!
 * @brief 获取当前K线CCI指标数据
 */
-(HsKlineCCI*)getKlineCCI;


@end
