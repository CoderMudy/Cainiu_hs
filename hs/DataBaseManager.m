//
//  DataBaseManager.m
//  DBTest
//
//  Created by RGZ on 15/11/3.
//  Copyright © 2015年 cainiu. All rights reserved.
//

#import "DataBaseManager.h"

static FMDatabase *_db = nil;

@implementation DataBaseManager

+(FMDatabase *)getDataBase{
//    NSString    *fileName = [NSString stringWithFormat:@"Documents/DataBase%@.sqlite",[[CMStoreManager sharedInstance] getEnvironment]];
    NSString    *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DataBase.sqlite"];
    
    if (_db == nil) {
        _db = [[FMDatabase alloc] initWithPath:filePath];
    }
    
    return _db;
}

 +(FMDatabaseQueue *)getSharedDatabaseQueue
 {
    static FMDatabaseQueue *my_FMDatabaseQueue=nil;

    if (!my_FMDatabaseQueue) {
//        NSString    *fileName = [NSString stringWithFormat:@"Documents/DataBase%@.sqlite",[[CMStoreManager sharedInstance] getEnvironment]];
        NSString    *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DataBase.sqlite"];
        my_FMDatabaseQueue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    }
    return my_FMDatabaseQueue;
}

@end
