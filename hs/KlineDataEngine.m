//
//  KlineDataEngine.m
//  hs
//
//  Created by RGZ on 15/11/11.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "KlineDataEngine.h"

@implementation KlineDataEngine

+(void)klineDataFactory:(NSMutableArray *)klineDataArray WithInstrumentID:(NSString *)instrumentID completeBlock:(void(^)())successBolck{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [KLineDao createKLineTable];
        
        NSMutableArray *tmpArray = [KLineDao getAllKLineDataWithInstrumentID:instrumentID AndKLineMinute:[IndexSingleControl sharedInstance].klineTime];
        KLineDataModel *klineDataModelDB = tmpArray.lastObject;
        KLineDataModel *klineDataModelSV = klineDataArray.firstObject;
        
        if ([klineDataModelDB.time isEqualToString:klineDataModelSV.time]) {
            if (klineDataArray.count > 0) {
                [klineDataArray removeObject:klineDataArray[0]];
            }
        }
        
        //存入数据库
        [KLineDao insertKLineDataTable:klineDataArray AndKLineMinute:[IndexSingleControl sharedInstance].klineTime];
        //判断是否超过
        NSMutableArray *allArray = [KLineDao getAllKLineDataWithInstrumentID:instrumentID AndKLineMinute:[IndexSingleControl sharedInstance].klineTime];
        if (allArray.count > DBSaveNum) {
            //删除多余的数据
            NSMutableArray *deleteArray = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < allArray.count - DBSaveNum; i++) {
                [deleteArray addObject:allArray[i]];
            }
            for (int i = 0; i < deleteArray.count; i++) {
                KLineDataModel *klineData = deleteArray[i];
                [KLineDao deleteKLineDataWithID:klineData.kid];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIEngine sharedInstance] hideProgress];
//            NSLog(@"\nK线图数据加载完成");
            successBolck();
        });
    });
}

+(NSString *)lastKLineTimeWithInstrumentID:(NSString *)instrumentID{
    [KLineDao createKLineTable];
    NSMutableArray *allArray = [KLineDao getAllKLineDataWithInstrumentID:instrumentID AndKLineMinute:[IndexSingleControl sharedInstance].klineTime];
    KLineDataModel *klineDataModel = allArray.lastObject;
    return klineDataModel.time;
}

+(NSMutableArray *)getAllKLineDataWithInstrumentID:(NSString *)instrumentID{
    [KLineDao createKLineTable];
    NSMutableArray *allArray = [KLineDao getAllKLineDataWithInstrumentID:instrumentID AndKLineMinute:[IndexSingleControl sharedInstance].klineTime];
    return allArray;
}

@end
