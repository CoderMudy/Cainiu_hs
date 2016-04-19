//
//  IndexBuyModel.h
//  hs
//
//  Created by RGZ on 15/7/28.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexBuyModel : NSString
//名称
@property (nonatomic,strong)NSString    *name;
//代码
@property (nonatomic,strong)NSString    *code;

//当前价
@property (nonatomic,strong)NSString    *currentPrice;
//最高价
@property (nonatomic,strong)NSString    *upperPrice;
//最低价
@property (nonatomic,strong)NSString    *lowerPrice;

//涨跌额
@property (nonatomic,strong)NSString    *changePrice;
//涨跌幅
@property (nonatomic,strong)NSString    *changePercent;
//看多价
@property (nonatomic,strong)NSString    *bullishBuyPrice;
//看多买量
@property (nonatomic,strong)NSString    *bullishBuyNum;
//看空价
@property (nonatomic,strong)NSString    *bearishAveragePrice;
//看空卖量
@property (nonatomic,strong)NSString    *bearishAverageNum;
//昨收价
@property (nonatomic,strong)NSString    *preClosePrice;

//最高价
@property (nonatomic,strong)NSString    *highestPrice;
//最低价
@property (nonatomic,strong)NSString    *lowestPrice;
//涨停价
@property (nonatomic,strong)NSString    *upperLimitPrice;
//跌停价
@property (nonatomic,strong)NSString    *lowerLimitPrice;

@property (nonatomic,strong)NSString    *openInterest;


-(instancetype)initWithName:(NSString *)aName Code:(NSString *)aCode;

/**
 *  Cache Data Configer
 *
 *  @param aIndexBuyModel _indexBuyModel
 *  @param aDataArray     Data Array
 *  @param aFloatNum      小数位
 *  @param aRangSection   波动区间
 *
 *  @return infoDic
 */
+(NSMutableDictionary *)indexBuyModelCacheDataConfiger:(IndexBuyModel *)aIndexBuyModel
                                        DataArray:(NSArray *)aDataArray
                                         FloatNum:(int)aFloatNum
                                     RangeSection:(float)aRangSection;

/**
 *  Aging Data Configer
 *
 *  @param aIndexBuyModel  _indexBuyModel
 *  @param aDataDic        DataDic
 *  @param aInstrumentCode code
 */
+(void)indexBuyModelAgingDataConfiger:(IndexBuyModel *)aIndexBuyModel
                                               DataDic:(NSMutableDictionary *)aDataDic
                                        InstrumentCode:(NSString *)aInstrumentCode;

@end
