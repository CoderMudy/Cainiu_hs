//
//  SaveStockDetail.m
//  hs
//
//  Created by PXJ on 15/7/2.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "SaveStock.h"

@implementation SaveStock

+ (void)saveSingleData:(HsRealtime *)realtime
{
        //获取缓存信息
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    if (cacheModel==nil) {
        return;
    }
    
    RealTimeStockModel * model = [[RealTimeStockModel alloc] init];

    
    model.name               =realtime.name==nil?@"":realtime.name;
    model.code               =realtime.code==nil?@"":realtime.code;
    model.codeType           =realtime.codeType==nil?@"":realtime.codeType;
    model.price              =realtime.newPrice;
    model.openPrice          =realtime.openPrice;
    model.hightPrice         =realtime.highPrice;
    model.lowPrice           =realtime.lowPrice;
    model.closePrice         =realtime.closePrice;
    model.preClosePrice      =realtime.preClosePrice;
    model.priceChange        =realtime.priceChange;
    model.priceChangePerCent =realtime.priceChangePercent;
    model.tradeStatus        =realtime.tradeStatus;
    model.timestamp          =(int)realtime.timestamp;
    
    
    int i = 0;
    
    //判断数组中是否含有该行情
    for (RealTimeStockModel * realtimeModel in cacheModel.stockDetailArray) {
        if (model.code ==realtimeModel.code) {
            [cacheModel.stockDetailArray removeObject:realtimeModel];
            [cacheModel.stockDetailArray addObject:model];
            break;
        }

        i++;

    }
    
    //如果没有
    if (i<cacheModel.stockDetailArray.count) {
        
        
        if (cacheModel.stockDetailArray.count>=50) {
            
            [cacheModel.stockDetailArray removeObjectAtIndex:0];
            [cacheModel.stockDetailArray addObject:model];
        }else{
        
            [cacheModel.stockDetailArray addObject:model];
        }

        
    }
        // 存入缓存
    [CacheEngine setCacheInfo:cacheModel];

}
+(void)saveMulData:(NSMutableArray *)array
{
    for (int i=0;i<array.count; i++) {
        HsRealtime * realTime = array[i];
        [SaveStock saveSingleData:realTime];
    }  
}

+ (RealTimeStockModel*)getdata:(HsStock*)stock
{

    //获取缓存信息
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    //设置属性
    for (RealTimeStockModel * model in cacheModel.stockDetailArray) {
        if ([stock.stockCode isEqualToString:model.code]) {
            return model;
        }
    }
    return nil;
}
+(NSMutableArray *)getAllStockDetail
{
    CacheModel *cacheModel = [CacheEngine getCacheInfo];

    NSMutableArray * mutableArray = [NSMutableArray array];
    if (cacheModel.stockDetailArray) {
        mutableArray = cacheModel.stockDetailArray;

    }
    return mutableArray;


}

@end
