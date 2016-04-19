//
//  KLineDao.h
//  CurveTest
//
//  Created by RGZ on 15/11/10.
//  Copyright © 2015年 cainiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLineDao : NSObject

+(void)createKLineTable;

+(NSMutableArray *)getAllKLineDataWithInstrumentID:(NSString *)aInstrumentID AndKLineMinute:(NSInteger)aKLineTime;

+(void)deleteKLineDataWithID:(NSInteger)aID;

+(void)deleteKLineDataWithInstrumentID:(NSString *)aID;

+(void)insertKLineDataTable:(NSMutableArray *)aKLineArray AndKLineMinute:(NSInteger)aKlineTime;

+(void)deleteAllInfo;

+(void)getAllKLineDataAndDeleteOtherWithInstrumentID:(NSString *)aInstrumentID;

@end
