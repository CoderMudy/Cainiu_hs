//
//  DataBaseManager.h
//  DBTest
//
//  Created by RGZ on 15/11/3.
//  Copyright © 2015年 cainiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseManager : NSObject

+(FMDatabase *)getDataBase;

+(FMDatabaseQueue *)getSharedDatabaseQueue;

@end
