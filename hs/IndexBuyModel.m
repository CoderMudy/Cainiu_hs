//
//  IndexBuyModel.m
//  hs
//
//  Created by RGZ on 15/7/28.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "IndexBuyModel.h"

@implementation IndexBuyModel

-(instancetype)initWithName:(NSString *)aName Code:(NSString *)aCode{
    self = [super init];
    
    if (self) {
        self.name = aName;
        self.code = aCode;
        self.currentPrice         = @"0.00";
        self.upperPrice           = @"0.15";
        self.lowerPrice           = @"-0.15";
        self.changePrice          = @"0.00";
        self.changePercent        = @"0.00%";
        self.bullishBuyPrice      = @"0.00";
        self.bullishBuyNum        = @"0";
        self.bearishAverageNum    = @"0";
        self.bearishAveragePrice  = @"0.00";
        self.lowestPrice          = @"0.00";
        self.highestPrice         = @"0.00";
    }
    
    return self;
}



+(NSMutableDictionary *)indexBuyModelCacheDataConfiger:(IndexBuyModel *)aIndexBuyModel
                                             DataArray:(NSArray *)aDataArray
                                              FloatNum:(int)aFloatNum
                                          RangeSection:(float)aRangSection{
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:aDataArray.lastObject];
    infoDic[@"instrumentID"]     = [NSString stringWithFormat:@"%@",infoDic[@"instrumentID"]];
    infoDic[@"lastPrice"]        = [NSString stringWithFormat:@"%@",infoDic[@"lastPrice"]];
    infoDic[@"preClosePrice"]    = [NSString stringWithFormat:@"%@",infoDic[@"preClosePrice"]];
    infoDic[@"bidPrice1"]        = [NSString stringWithFormat:@"%@",infoDic[@"bidPrice1"]];
    infoDic[@"bidVolume1"]       = [NSString stringWithFormat:@"%@",infoDic[@"bidVolume1"]];
    infoDic[@"askPrice1"]        = [NSString stringWithFormat:@"%@",infoDic[@"askPrice1"]];
    infoDic[@"askVolume1"]       = [NSString stringWithFormat:@"%@",infoDic[@"askVolume1"]];
    infoDic[@"highestPrice"]     = [NSString stringWithFormat:@"%@",infoDic[@"highestPrice"]];
    infoDic[@"lowestPrice"]      = [NSString stringWithFormat:@"%@",infoDic[@"lowestPrice"]];
    infoDic[@"lowerLimitPrice"]  = [NSString stringWithFormat:@"%@",infoDic[@"lowerLimitPrice"]];
    infoDic[@"upperLimitPrice"]  = [NSString stringWithFormat:@"%@",infoDic[@"upperLimitPrice"]];
    infoDic[@"openInterest"]     = [NSString stringWithFormat:@"%@",infoDic[@"openInterest"]];
    
    aIndexBuyModel.currentPrice = [DataUsedEngine conversionFloatNum:[[aDataArray lastObject][@"lastPrice"] floatValue] ExpectFloatNum:aFloatNum];
    aIndexBuyModel.upperPrice   = [DataUsedEngine conversionFloatNum:[aIndexBuyModel.currentPrice floatValue] + aRangSection ExpectFloatNum:aFloatNum];
    aIndexBuyModel.lowerPrice   = [DataUsedEngine conversionFloatNum:[aIndexBuyModel.currentPrice floatValue] - aRangSection ExpectFloatNum:aFloatNum];
    //看多价
    if (infoDic[@"askPrice1"] != nil && ![infoDic[@"askPrice1"] isKindOfClass:[NSNull class]]) {
        aIndexBuyModel.bullishBuyPrice = [DataUsedEngine conversionFloatNum:[infoDic[@"askPrice1"] floatValue] ExpectFloatNum:aFloatNum];
    }
    else{
        aIndexBuyModel.bullishBuyPrice = [DataUsedEngine conversionFloatNum:0.0 ExpectFloatNum:aFloatNum];
    }
    //看多量
    if (infoDic[@"askVolume1"] != nil && ![infoDic[@"askVolume1"] isKindOfClass:[NSNull class]]) {
        aIndexBuyModel.bullishBuyNum        = infoDic[@"askVolume1"];
        if ([aIndexBuyModel.bullishBuyNum isEqualToString:@"(null)"]) {
            aIndexBuyModel.bullishBuyNum    = @"0";
        }
    }
    else{
        aIndexBuyModel.bullishBuyNum        = @"0";
    }
    //看空价
    if (infoDic[@"bidPrice1"] != nil && ![infoDic[@"bidPrice1"] isKindOfClass:[NSNull class]]) {
        aIndexBuyModel.bearishAveragePrice  = [DataUsedEngine conversionFloatNum:[infoDic[@"bidPrice1"] floatValue] ExpectFloatNum:aFloatNum];
    }
    else{
        aIndexBuyModel.bearishAveragePrice  = [DataUsedEngine conversionFloatNum:0.00 ExpectFloatNum:aFloatNum];
    }
    //看空量
    if (infoDic[@"bidVolume1"] != nil && ![infoDic[@"bidVolume1"] isKindOfClass:[NSNull class]]) {
        aIndexBuyModel.bearishAverageNum    = infoDic[@"bidVolume1"];
        if ([aIndexBuyModel.bearishAverageNum isEqualToString:@"(null)"]) {
            aIndexBuyModel.bearishAverageNum = @"0";
        }
    }
    else{
        aIndexBuyModel.bearishAverageNum     = @"0";
    }
    //涨跌额
    if (infoDic[@"preClosePrice"] != nil && ![infoDic[@"preClosePrice"] isKindOfClass:[NSNull class]]) {
        aIndexBuyModel.preClosePrice    = [DataUsedEngine conversionFloatNum:[infoDic[@"preClosePrice"] floatValue] ExpectFloatNum:aFloatNum];
        aIndexBuyModel.changePrice      = [DataUsedEngine conversionFloatNum:[infoDic[@"lastPrice"] floatValue] - [infoDic[@"preClosePrice"] floatValue] ExpectFloatNum:aFloatNum];
    }
    else{
        aIndexBuyModel.preClosePrice = @"0.00";
        aIndexBuyModel.changePrice = @"0.00";
    }
    //涨跌幅
    if (infoDic[@"preClosePrice"] != nil && ![infoDic[@"preClosePrice"] isKindOfClass:[NSNull class]]) {
        aIndexBuyModel.changePercent = [NSString stringWithFormat:@"%.2f",([infoDic[@"lastPrice"] floatValue] - [infoDic[@"preClosePrice"] floatValue])/[infoDic[@"preClosePrice"] floatValue]*100];
        
        if ([aIndexBuyModel.changePercent rangeOfString:@"+"].location != NSNotFound) {
            [aIndexBuyModel.changePercent stringByReplacingOccurrencesOfString:@"+" withString:@""];
        }
        
        aIndexBuyModel.changePercent = [[NSString stringWithFormat:@"%@",aIndexBuyModel.changePercent] stringByAppendingString:@"%"];
        
        if ([aIndexBuyModel.changePercent isEqualToString:@"nan"]) {
            aIndexBuyModel.changePercent    = @"0.00%";
        }
    }
    else{
        aIndexBuyModel.changePercent      = @"0.00%";
    }
    //最低价
    if (infoDic[@"lowestPrice"] != nil && ![infoDic[@"lowestPrice"] isKindOfClass:[NSNull class]]) {
        aIndexBuyModel.lowestPrice = infoDic[@"lowestPrice"];
    }
    else {
        aIndexBuyModel.lowestPrice = @"0.00";
    }
    //最高价
    if (infoDic[@"highestPrice"] != nil && ![infoDic[@"highestPrice"] isKindOfClass:[NSNull class]]) {
        aIndexBuyModel.highestPrice = infoDic[@"highestPrice"];
    }
    else {
        aIndexBuyModel.highestPrice = @"0.00";
    }
    
    //跌停价
    if (infoDic[@"lowerLimitPrice"] != nil && ![infoDic[@"lowerLimitPrice"] isKindOfClass:[NSNull class]]) {
        aIndexBuyModel.lowestPrice = infoDic[@"lowerLimitPrice"];
    }
    else {
        aIndexBuyModel.lowestPrice = @"0.00";
    }
    //涨停价
    if (infoDic[@"upperLimitPrice"] != nil && ![infoDic[@"upperLimitPrice"] isKindOfClass:[NSNull class]]) {
        aIndexBuyModel.highestPrice = infoDic[@"upperLimitPrice"];
    }
    else {
        aIndexBuyModel.highestPrice = @"0.00";
    }

    return infoDic;
    
}


+(void)indexBuyModelAgingDataConfiger:(IndexBuyModel *)aIndexBuyModel
                                               DataDic:(NSMutableDictionary *)aDataDic
                                        InstrumentCode:(NSString *)aInstrumentCode{
    aDataDic[@"instrumentID"]    = [NSString stringWithFormat:@"%@",aDataDic[@"instrumentID"]];
    aDataDic[@"lastPrice"]       = [NSString stringWithFormat:@"%@",aDataDic[@"lastPrice"]];
    aDataDic[@"preClosePrice"]   = [NSString stringWithFormat:@"%@",aDataDic[@"preClosePrice"]];
    aDataDic[@"bidPrice1"]       = [NSString stringWithFormat:@"%@",aDataDic[@"bidPrice1"]];
    aDataDic[@"bidVolume1"]      = [NSString stringWithFormat:@"%@",aDataDic[@"bidVolume1"]];
    aDataDic[@"askPrice1"]       = [NSString stringWithFormat:@"%@",aDataDic[@"askPrice1"]];
    aDataDic[@"askVolume1"]      = [NSString stringWithFormat:@"%@",aDataDic[@"askVolume1"]];
    aDataDic[@"highestPrice"]     = [NSString stringWithFormat:@"%@",aDataDic[@"highestPrice"]];
    aDataDic[@"lowestPrice"]      = [NSString stringWithFormat:@"%@",aDataDic[@"lowestPrice"]];
    aDataDic[@"lowerLimitPrice"]  = [NSString stringWithFormat:@"%@",aDataDic[@"lowerLimitPrice"]];
    aDataDic[@"upperLimitPrice"]  = [NSString stringWithFormat:@"%@",aDataDic[@"upperLimitPrice"]];
    aDataDic[@"openInterest"]     = [NSString stringWithFormat:@"%@",aDataDic[@"openInterest"]];
    if([aDataDic[@"instrumentID"] length] >= 2 && aInstrumentCode.length >= 2){
        if (![[[aDataDic[@"instrumentID"] substringToIndex:2] uppercaseString] isEqualToString:[[aInstrumentCode substringToIndex:2] uppercaseString]]) {
            return;
        }
    }
    else{
        return;
    }
    
    //当前价
    if (aDataDic[@"lastPrice"] != nil && ![aDataDic[@"lastPrice"] isKindOfClass:[NSNull class]]) {
        aIndexBuyModel.currentPrice = [NSString stringWithFormat:@"%.2f",[aDataDic[@"lastPrice"] floatValue]];
    }
    else{
        aIndexBuyModel.currentPrice = @"0.00";
    }
    
    //涨跌额
    if (aDataDic[@"preClosePrice"] != nil && ![aDataDic[@"preClosePrice"] isKindOfClass:[NSNull class]]) {
        aIndexBuyModel.preClosePrice    = [NSString stringWithFormat:@"%.2f",[aDataDic[@"preClosePrice"] floatValue]];
        aIndexBuyModel.changePrice      = [NSString stringWithFormat:@"%.2f",[aDataDic[@"lastPrice"] floatValue] - [aDataDic[@"preClosePrice"] floatValue]];
    }
    else{
        aIndexBuyModel.preClosePrice    = @"0.00";
        aIndexBuyModel.changePrice      = @"0.00";
    }
    
    //涨跌幅
    if (aDataDic[@"preClosePrice"] != nil && ![aDataDic[@"preClosePrice"] isKindOfClass:[NSNull class]]) {
        aIndexBuyModel.changePercent    = [NSString stringWithFormat:@"%.2f",([aDataDic[@"lastPrice"] floatValue] - [aDataDic[@"preClosePrice"] floatValue])/[aDataDic[@"preClosePrice"] floatValue]*100];
        
        if ([aIndexBuyModel.changePercent floatValue] > 0) {
            aIndexBuyModel.changePercent = [[NSString stringWithFormat:@"+%@",aIndexBuyModel.changePercent] stringByAppendingString:@"%"];
        }
        else if([aIndexBuyModel.changePercent floatValue] < 0){
            aIndexBuyModel.changePercent = [[NSString stringWithFormat:@"%@",aIndexBuyModel.changePercent] stringByAppendingString:@"%"];
        }
        else{
            aIndexBuyModel.changePercent = [[NSString stringWithFormat:@"%@",aIndexBuyModel.changePercent] stringByAppendingString:@"%"];
        }
        
    }
    else{
        aIndexBuyModel.changePercent = @"0.00%";
    }
    
    //看多价
    if (aDataDic[@"askPrice1"] != nil && ![aDataDic[@"askPrice1"] isKindOfClass:[NSNull class]]) {
        aIndexBuyModel.bullishBuyPrice = [NSString stringWithFormat:@"%.2f",[aDataDic[@"askPrice1"] floatValue]];
    }
    else{
        aIndexBuyModel.bullishBuyPrice = @"0.00";
    }
    
    //看多量
    if (aDataDic[@"askVolume1"] != nil && ![aDataDic[@"askVolume1"] isKindOfClass:[NSNull class]]) {
        aIndexBuyModel.bullishBuyNum = aDataDic[@"askVolume1"];
    }
    else{
        aIndexBuyModel.bullishBuyNum = @"0";
    }
    
    //看空价
    if (aDataDic[@"bidPrice1"] != nil && ![aDataDic[@"bidPrice1"] isKindOfClass:[NSNull class]]) {
        aIndexBuyModel.bearishAveragePrice = [NSString stringWithFormat:@"%.2f",[aDataDic[@"bidPrice1"] floatValue]];
    }
    else{
        aIndexBuyModel.bearishAveragePrice = @"0.00";
    }
    
    //看空量
    if (aDataDic[@"bidVolume1"] != nil && ![aDataDic[@"bidVolume1"] isKindOfClass:[NSNull class]]) {
        aIndexBuyModel.bearishAverageNum = aDataDic[@"bidVolume1"];
    }
    else{
        aIndexBuyModel.bearishAverageNum = @"0";
    }
    
    //最低价
    if (aDataDic[@"lowestPrice"] != nil && ![aDataDic[@"lowestPrice"] isKindOfClass:[NSNull class]]) {
        aIndexBuyModel.lowestPrice = aDataDic[@"lowestPrice"];
    }
    else {
        aIndexBuyModel.lowestPrice = @"0.00";
    }
    //最高价
    if (aDataDic[@"highestPrice"] != nil && ![aDataDic[@"highestPrice"] isKindOfClass:[NSNull class]]) {
        aIndexBuyModel.highestPrice = aDataDic[@"highestPrice"];
    }
    else {
        aIndexBuyModel.highestPrice = @"0.00";
    }
    
    //跌停价
    if (aDataDic[@"lowerLimitPrice"] != nil && ![aDataDic[@"lowerLimitPrice"] isKindOfClass:[NSNull class]]) {
        aIndexBuyModel.lowestPrice = aDataDic[@"lowerLimitPrice"];
    }
    else {
        aIndexBuyModel.lowestPrice = @"0.00";
    }
    //涨停价
    if (aDataDic[@"upperLimitPrice"] != nil && ![aDataDic[@"upperLimitPrice"] isKindOfClass:[NSNull class]]) {
        aIndexBuyModel.highestPrice = aDataDic[@"upperLimitPrice"];
    }
    else {
        aIndexBuyModel.highestPrice = @"0.00";
    }
}

@end
