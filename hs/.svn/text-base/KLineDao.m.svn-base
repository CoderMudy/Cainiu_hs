//
//  KLineDao.m
//  CurveTest
//
//  Created by RGZ on 15/11/10.
//  Copyright © 2015年 cainiu. All rights reserved.
//

#import "KLineDao.h"

@implementation KLineDao

+(void)createKLineTable{
//    FMDatabase *db = [DataBaseManager getDataBase];
    FMDatabaseQueue *queue = [DataBaseManager getSharedDatabaseQueue];
    
    [queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            if (![db tableExists:@"klineNewTB"]) {
                [db executeUpdate:@"create table klineNewTB (kid integer primary key autoincrement , instrumentID text , openPrice double , closePrice double , maxPrice double , minPrice double , volume integer , kLineMinute integer , time text)"];
            }
        }
        [db close];
    }];
}

+(NSMutableArray *)getAllKLineDataWithInstrumentID:(NSString *)aInstrumentID AndKLineMinute:(NSInteger)aKLineTime{
    
    NSMutableArray *infoArray = [NSMutableArray arrayWithCapacity:0];
//    FMDatabase *db = [DataBaseManager getDataBase];
    FMDatabaseQueue *queue = [DataBaseManager getSharedDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            FMResultSet *set = [db executeQuery:@"select * from klineNewTB where instrumentID = ? and kLineMinute = ? ORDER BY kid",aInstrumentID,[NSNumber numberWithInteger:aKLineTime]];
            while ([set next]) {
                NSInteger   kid           = [set intForColumn:@"kid"];
                NSString    *instrumentID = [set stringForColumn:@"instrumentID"];
                double      openPrice     = [set doubleForColumn:@"openPrice"];
                double      closePrice    = [set doubleForColumn:@"closePrice"];
                double      maxPrice      = [set doubleForColumn:@"maxPrice"];
                double      minPrice      = [set doubleForColumn:@"minPrice"];
                NSString    *time         = [set stringForColumn:@"time"];
                NSInteger   volume        = [set intForColumn:@"volume"];
                NSInteger   klineMinute   = [set intForColumn:@"kLineMinute"];
                
                @autoreleasepool {
                    KLineDataModel *klineData = [[KLineDataModel alloc]init];
                    klineData.kid           = kid;
                    klineData.instrumentID  = instrumentID;
                    klineData.openPrice     = openPrice;
                    klineData.closePrice    = closePrice;
                    klineData.maxPrice      = maxPrice;
                    klineData.minPrice      = minPrice;
                    klineData.time          = time;
                    klineData.volume        = volume;
                    klineData.kLineMinute   = klineMinute;
                    [infoArray addObject:klineData];
                }
            }
            [set close];
        }
        
        [db close];
    }];
    
    return infoArray;

}

+(void)getAllKLineDataAndDeleteOtherWithInstrumentID:(NSString *)aInstrumentID{
    
    NSMutableArray *otherIDArray = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableArray *infoArray = [NSMutableArray arrayWithCapacity:0];
    FMDatabaseQueue *queue = [DataBaseManager getSharedDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            FMResultSet *set;
            if (aInstrumentID.length > 2) {
                set = [db executeQuery:@"select * from klineNewTB where instrumentID like '%?%' ORDER BY kid",[aInstrumentID substringToIndex:2]];
            }
            while ([set next]) {
                NSInteger   kid           = [set intForColumn:@"kid"];
                NSString    *instrumentID = [set stringForColumn:@"instrumentID"];
                double      openPrice     = [set doubleForColumn:@"openPrice"];
                double      closePrice    = [set doubleForColumn:@"closePrice"];
                double      maxPrice      = [set doubleForColumn:@"maxPrice"];
                double      minPrice      = [set doubleForColumn:@"minPrice"];
                NSString    *time         = [set stringForColumn:@"time"];
                NSInteger   volume        = [set intForColumn:@"volume"];
                
                KLineDataModel *klineData = [[KLineDataModel alloc]init];
                klineData.kid           = kid;
                klineData.instrumentID  = instrumentID;
                klineData.openPrice     = openPrice;
                klineData.closePrice    = closePrice;
                klineData.maxPrice      = maxPrice;
                klineData.minPrice      = minPrice;
                klineData.time          = time;
                klineData.volume        = volume;
                [infoArray addObject:klineData];
                if (klineData.instrumentID != nil && ![klineData.instrumentID isEqualToString:aInstrumentID]) {
                    [otherIDArray addObject:klineData.instrumentID];
                }
            }
            [set close];
        }
        
        [db close];
    }];
    
    for (int i = 0; i < otherIDArray.count ; i++) {
        [KLineDao deleteKLineDataWithInstrumentID:otherIDArray[i]];
    }
}

+(void)deleteKLineDataWithInstrumentID:(NSString *)aID{
//    FMDatabase *db = [DataBaseManager getDataBase];
    FMDatabaseQueue *queue = [DataBaseManager getSharedDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            [db executeUpdate:@"delete from klineNewTB where instrumentID = ?",aID];
        }
        [db close];
    }];
}

+(void)deleteKLineDataWithID:(NSInteger)aID{
    //    FMDatabase *db = [DataBaseManager getDataBase];
    FMDatabaseQueue *queue = [DataBaseManager getSharedDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            [db executeUpdate:@"delete from klineNewTB where kid = ?",[NSNumber numberWithInteger:aID]];
        }
        [db close];
    }];
}

+(void)insertKLineDataTable:(NSMutableArray *)aKLineArray AndKLineMinute:(NSInteger)aKlineTime{
//    FMDatabase *db = [DataBaseManager getDataBase];
    FMDatabaseQueue *queue = [DataBaseManager getSharedDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            for (int i = 0; i < aKLineArray.count; i++) {
                KLineDataModel *aKLineModel = aKLineArray[i];
                NSString    *instrumentID = aKLineModel.instrumentID;
                double      openPrice     = aKLineModel.openPrice;
                double      closePrice    = aKLineModel.closePrice;
                double      maxPrice      = aKLineModel.maxPrice;
                double      minPrice      = aKLineModel.minPrice;
                NSString    *time         = aKLineModel.time;
                NSInteger   volume        = aKLineModel.volume;
                NSInteger   kLineMinute   = aKlineTime;
                [db executeUpdate:@"insert into klineNewTB (instrumentID,openPrice,closePrice,maxPrice,minPrice,time,volume,kLineMinute) values(?,?,?,?,?,?,?,?)"
                 ,instrumentID,[NSNumber numberWithDouble:openPrice],[NSNumber numberWithDouble:closePrice],[NSNumber numberWithDouble:maxPrice],[NSNumber numberWithDouble:minPrice],time,[NSNumber numberWithInteger:volume],[NSNumber numberWithInteger:kLineMinute]];
            }
            
        }
        [db close];
    }];
}

+(void)deleteAllInfo{
//    FMDatabase *db = [DataBaseManager getDataBase];
    FMDatabaseQueue *queue = [DataBaseManager getSharedDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            [db executeUpdate:@"delete from klineNewTB"];
        }
        [db close];
    }];
}


@end
