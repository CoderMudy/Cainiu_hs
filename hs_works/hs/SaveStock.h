//
//  SaveStockDetail.h
//  hs
//
//  Created by PXJ on 15/7/2.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HsStock.h"

@interface SaveStock : NSObject

// 存储一支股票
+ (void)saveSingleData:(HsRealtime *)realtime;
//保存一只股票
+ (void)saveMulData:(NSMutableArray *)array;
//获取一只股票行情
+ (RealTimeStockModel *)getdata:(HsStock*)stock;
//获取内存中的所有股票
+(NSMutableArray *)getAllStockDetail;

@end
