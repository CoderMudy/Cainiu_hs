//
//  DataEngine+Table.m
//  hs
//
//  Created by RGZ on 15/11/30.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "DataEngine+Table.h"
#import "News.h"

@implementation DataEngine(Table)
#pragma mark 行情ip、port

+(void)requestToGetIPAndPortWithBlock:(void(^)(BOOL,NSString *,NSString *))successBlock{
    
    NSDictionary *dic = [NSDictionary dictionary];
    
    NSString * urlStr = [NSString stringWithFormat:@"http://%@/futuresquota/getQuotaUrl",HTTP_IP];
    
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if (dictionary!=nil&& dictionary[@"ip"]!=nil&&dictionary[@"port"]!=nil) {
            successBlock(YES,dictionary[@"ip"],dictionary[@"port"]);
        }else{
            successBlock(NO,@"120.26.109.180",@"33333");
        }
    } failureBlock:^(NSError *error) {
        
        successBlock(NO,@"120.26.109.180",@"33333");
    }];
}

#pragma mark 获取实时策略/持仓直播
+(void)requestToGetTacticsDataWithType:(NSString *)aType successBlock:(void(^)(BOOL,NSDictionary *))successBlock{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         aType,@"futuresType"//instrumentCode
                         ,nil];
    
    NSString * urlStr = [NSString stringWithFormat:@"http://%@/order/position/getPosition",HTTP_IP];
    
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] floatValue] == 200) {
            if(dictionary[@"data"] != nil){
                successBlock(YES,dictionary[@"data"]);
            }
            else{
                successBlock(NO,dictionary);
            }
        }
        else{
            successBlock(NO,dictionary);
        }
        
    } failureBlock:^(NSError *error) {
        
        successBlock(NO,nil);
    }];
}


+(NSString *)bundleSeedID{
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)(kSecClassGenericPassword),kSecClass,
                           @"bundleSeedID",kSecAttrAccount,
                           @"",kSecAttrService,
                           (id)kCFBooleanTrue,kSecReturnAttributes,
                           nil];
    CFDictionaryRef result = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status == errSecItemNotFound) {
        status = SecItemAdd((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    }
    if (status != errSecSuccess) {
        return nil;
    }
    NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey:(__bridge id)(kSecAttrAccessGroup)];
    NSArray *components = [accessGroup componentsSeparatedByString:@"."];
    NSString    *bundleSeedID = [[components objectEnumerator] nextObject];
    CFRelease(result);
    
    
    return bundleSeedID;
}

#pragma mark K线图数据获取
+(void)requestToGetKLineDataWithType:(NSString *)aType AndTime:(NSString *)aTime successBlock:(void(^)(BOOL,NSMutableArray *))successBlock{
    NSDictionary * dic;
    
    if (aTime != nil && aTime.length > 0) {
        dic = @{
                @"type":aType,
                @"time":aTime,
                };
    }
    else{
        dic = @{
                @"type":aType,
                };
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/futuresquota/list",HTTP_IP];
    
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if (dictionary != nil) {
            NSArray *dataArray = (NSArray *)dictionary;
            
            NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
            
            for (int i = 0; i < dataArray.count; i++) {
                KLineDataModel *klineDataModel  = [[KLineDataModel alloc]init];
                if (dataArray[i][@"closePrice"] != nil && ![dataArray[i][@"closePrice"] isKindOfClass:[NSNull class]]) {
                    klineDataModel.closePrice       = [dataArray[i][@"closePrice"] doubleValue];
                }
                
                if (dataArray[i][@"instrumentID"] != nil && ![dataArray[i][@"instrumentID"] isKindOfClass:[NSNull class]]) {
                    klineDataModel.instrumentID     = dataArray[i][@"instrumentID"];
                }
                
                if (dataArray[i][@"maxPrice"] != nil && ![dataArray[i][@"maxPrice"] isKindOfClass:[NSNull class]]) {
                    klineDataModel.maxPrice         = [dataArray[i][@"maxPrice"] doubleValue];
                }
                
                if (dataArray[i][@"minPrice"] != nil && ![dataArray[i][@"minPrice"] isKindOfClass:[NSNull class]]) {
                    klineDataModel.minPrice         = [dataArray[i][@"minPrice"] doubleValue];
                }
                
                if (dataArray[i][@"openPrice"] != nil && ![dataArray[i][@"openPrice"] isKindOfClass:[NSNull class]]) {
                    klineDataModel.openPrice        = [dataArray[i][@"openPrice"] doubleValue];
                }
                
                if (dataArray[i][@"time"] != nil && ![dataArray[i][@"time"] isKindOfClass:[NSNull class]]) {
                    klineDataModel.time             = dataArray[i][@"time"];
                }
                
                if (dataArray[i][@"volume"] != nil && ![dataArray[i][@"volume"] isKindOfClass:[NSNull class]]) {
                    klineDataModel.volume           = [dataArray[i][@"volume"] integerValue];
                }
                
                [resultArray addObject:klineDataModel];
            }
            
            NSMutableArray *sortArray = [NSMutableArray arrayWithCapacity:0];
            
            for (int i = 0; i < resultArray.count ; i++) {
                [sortArray addObject:resultArray[resultArray.count - 1 - i]];
            }
            
            successBlock(YES,sortArray);
        }
        else{
            successBlock(NO,nil);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO,nil);
    }];
    
}

#pragma mark 盘口数据

+(void)requestToGetMarketInfoDataWithType:(NSString *)aType successBlock:(void(^)(BOOL,IndexMarketInfoModel *))successBlock{
    NSDictionary * dic = @{
                @"futuresType":aType,
                };
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/futuresquota//getQuotaData",HTTP_IP];
    
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if (dictionary != nil && [dictionary[@"code"] floatValue] == 200) {
            if ([DataUsedEngine nullTrim:dictionary[@"data"]]) {
                IndexMarketInfoModel *marketModel = [[IndexMarketInfoModel alloc]init];
                marketModel.upDropPrice     = [DataUsedEngine nullTrimString:dictionary[@"data"][@"upDropPrice"] expectString:@"--"];
                marketModel.rateOfPriceSpread = [DataUsedEngine nullTrimString:dictionary[@"data"][@"rateOfPriceSpread"] expectString:@"--"];
                marketModel.instrumentID    = [DataUsedEngine nullTrimString:dictionary[@"data"][@"instrumentID"] expectString:@"--"];
                marketModel.lastPrice       = [DataUsedEngine nullTrimString:dictionary[@"data"][@"lastPrice"] expectString:@"--"];
                marketModel.preSettlementPrice = [DataUsedEngine nullTrimString:dictionary[@"data"][@"preSettlementPrice"] expectString:@"--"];
                marketModel.preClosePrice   = [DataUsedEngine nullTrimString:dictionary[@"data"][@"preClosePrice"] expectString:@"--"];
                marketModel.preOpenInterest = [DataUsedEngine nullTrimString:dictionary[@"data"][@"preOpenInterest"] expectString:@"--"];
                marketModel.openPrice       = [DataUsedEngine nullTrimString:dictionary[@"data"][@"openPrice"] expectString:@"--"];
                marketModel.highestPrice    = [DataUsedEngine nullTrimString:dictionary[@"data"][@"highestPrice"] expectString:@"--"];
                marketModel.lowestPrice     = [DataUsedEngine nullTrimString:dictionary[@"data"][@"lowestPrice"] expectString:@"--"];
                marketModel.volume          = [DataUsedEngine nullTrimString:dictionary[@"data"][@"volume"] expectString:@"--"];
                marketModel.turnover        = [DataUsedEngine nullTrimString:dictionary[@"data"][@"turnover"] expectString:@"--"];
                marketModel.openInterest    = [DataUsedEngine nullTrimString:dictionary[@"data"][@"openInterest"] expectString:@"--"];
                marketModel.settlementPrice = [DataUsedEngine nullTrimString:dictionary[@"data"][@"settlementPrice"] expectString:@"--"];
                marketModel.upperLimitPrice = [DataUsedEngine nullTrimString:dictionary[@"data"][@"upperLimitPrice"] expectString:@"--"];
                marketModel.lowerLimitPrice = [DataUsedEngine nullTrimString:dictionary[@"data"][@"lowerLimitPrice"] expectString:@"--"];
                                
                successBlock(YES,marketModel);
            }
            else{
                successBlock(NO,nil);
            }
        }
        else{
            successBlock(NO,nil);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO,nil);
    }];
}

#pragma mark K线数据优化
/**
 *  K线数据获取
 *
 *  @param aType        期货类型
 *  @param aTime        最后一条记录时间
 *  @param aKLineMinute K线类型
 *  @param successBlock 回调
 */
+(void)requestToGetKLineWithType:(NSString *)aType Time:(NSString *)aTime KLineMinute:(NSInteger)aKLineMinute successBlock:(void(^)(BOOL , NSMutableArray *))successBlock{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                aType,@"type",
                                aTime,@"time",
                                [NSNumber numberWithInteger:aKLineMinute],@"num",
                                nil];
    
    if (aKLineMinute == 1 || aKLineMinute == 0) {
        [dic removeObjectForKey:@"num"];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/futuresquota/list",HTTP_IP];
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        
        if (dictionary == nil || [dictionary isKindOfClass:[NSNull class]]) {
            successBlock(NO,nil);
        }
        
        NSArray *dataArray = (NSArray *)dictionary;
        
        NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
        
        for (int i = 0; i < dataArray.count; i++) {
            KLineDataModel *klineDataModel  = [[KLineDataModel alloc]init];
            if (dataArray[i][@"closePrice"] != nil && ![dataArray[i][@"closePrice"] isKindOfClass:[NSNull class]]) {
                klineDataModel.closePrice       = [dataArray[i][@"closePrice"] doubleValue];
            }
            
            if (dataArray[i][@"instrumentID"] != nil && ![dataArray[i][@"instrumentID"] isKindOfClass:[NSNull class]]) {
                klineDataModel.instrumentID     = dataArray[i][@"instrumentID"];
            }
            
            if (dataArray[i][@"maxPrice"] != nil && ![dataArray[i][@"maxPrice"] isKindOfClass:[NSNull class]]) {
                klineDataModel.maxPrice         = [dataArray[i][@"maxPrice"] doubleValue];
            }
            
            if (dataArray[i][@"minPrice"] != nil && ![dataArray[i][@"minPrice"] isKindOfClass:[NSNull class]]) {
                klineDataModel.minPrice         = [dataArray[i][@"minPrice"] doubleValue];
            }
            
            if (dataArray[i][@"openPrice"] != nil && ![dataArray[i][@"openPrice"] isKindOfClass:[NSNull class]]) {
                klineDataModel.openPrice        = [dataArray[i][@"openPrice"] doubleValue];
            }
            
            if (dataArray[i][@"time"] != nil && ![dataArray[i][@"time"] isKindOfClass:[NSNull class]]) {
                klineDataModel.time             = dataArray[i][@"time"];
            }
            
            if (dataArray[i][@"volume"] != nil && ![dataArray[i][@"volume"] isKindOfClass:[NSNull class]]) {
                klineDataModel.volume           = [dataArray[i][@"volume"] integerValue];
            }
            
            klineDataModel.kLineMinute  = [IndexSingleControl sharedInstance].klineTime;
            
            [resultArray addObject:klineDataModel];
        }
        
        NSMutableArray *sortArray = [NSMutableArray arrayWithCapacity:0];
        
        for (int i = 0; i < resultArray.count ; i++) {
            [sortArray addObject:resultArray[resultArray.count - 1 - i]];
        }
        
        successBlock(YES,sortArray);
    } failureBlock:^(NSError *error) {
        successBlock(NO,nil);
    }];
}

@end

@implementation DataEngine(News)

#pragma mark 新闻列表

+(void)requestTogetNewsListWithPageNo:(int)aPageNo PageSize:(int)aPageSize completeBlock:(void(^)(BOOL,NSMutableArray *))completeBlock{
    NSDictionary *parameterDic;
    if ([CMStoreManager sharedInstance].isLogin && [DataUsedEngine nullTrim:[[CMStoreManager sharedInstance] getUserToken]]) {
        parameterDic = @{
                                       @"pageNo":[NSNumber numberWithInt:aPageNo],
                                       @"pageSize":[NSNumber numberWithInt:aPageSize],
                                       @"token":[[CMStoreManager sharedInstance] getUserToken],
                                       };
    }
    else{
        parameterDic = @{
                                       @"pageNo":[NSNumber numberWithInt:aPageNo],
                                       @"pageSize":[NSNumber numberWithInt:aPageSize],
                                       };
    }
    
    NSString    *urlStr = [NSString stringWithFormat:@"http://%@/user/newsArticle/newsList",HTTP_IP];
    [NetRequest postRequestWithNSDictionary:parameterDic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([DataUsedEngine nullTrim:dictionary[@"code"]]) {
            if ([dictionary[@"code"] intValue] == 200) {
                if ([DataUsedEngine nullTrim:dictionary[@"data"]]) {
                    NSMutableArray  *dataArray = [NSMutableArray arrayWithCapacity:0];
                    for (int i = 0; i < [dictionary[@"data"] count]; i++) {
                        News    *news = [[News alloc]init];
                        news.title          = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"title"]];
                        news.sectionName    = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"sectionName"]];
                        news.summary        = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"summary"]];
                        news.permitComment  = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"permitComment"]];
                        news.bannerUrl      = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"bannerUrl"]];
                        news.readCount      = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"readCount"]];
                        news.plateName      = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"plateName"]];
                        news.createDate     = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"createDate"]];
                        news.newsID         = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"id"]];
                        
                        news.content        = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"content"]];
                        news.subTitle       = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"subTitle"]];
                        news.modifyDate     = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"modifyDate"]];
                        news.status         = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"status"]];
                        news.keyword        = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"keyword"]];
                        news.createStaffName     = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"createStaffName"]];
                        news.cmtCount       = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"cmtCount"]];
                        news.orderWeight    = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"orderWeight"]];
                        news.sourceType     = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"sourceType"]];
                        news.newsPlateIdList     = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"newsPlateIdList"]];
                        news.targetType     = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"targetType"]];
                        news.outSourceName  = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"outSourceName"]];
                        news.section        = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"section"]];
                        news.outSourceUrl   = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"outSourceUrl"]];
                        news.picFlag        = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"picFlag"]];
                        news.hotEndTime     = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"hotEndTime"]];
                        news.hot            = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"hot"]];
                        news.top            = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"top"]];
                        [dataArray addObject:news];
                    }
                    
                    completeBlock(YES,dataArray);
                }else{
                    completeBlock(NO,nil);
                }
            }else{
                completeBlock(NO,nil);
            }
        }else{
            completeBlock(NO,nil);
        }
    } failureBlock:^(NSError *error) {
        completeBlock(NO,nil);
    }];
}


#pragma mark 策略列表

+(void)requestTogetTacticListWithPageNo:(int)aPageNo PageSize:(int)aPageSize completeBlock:(void(^)(BOOL,NSMutableArray *))completeBlock{
    NSDictionary *parameterDic;
    if ([CMStoreManager sharedInstance].isLogin && [DataUsedEngine nullTrim:[[CMStoreManager sharedInstance] getUserToken]]) {
        parameterDic = @{
                         @"pageNo":[NSNumber numberWithInt:aPageNo],
                         @"pageSize":[NSNumber numberWithInt:aPageSize],
                         @"token":[[CMStoreManager sharedInstance] getUserToken],
                         };
    }
    else{
        parameterDic = @{
                         @"pageNo":[NSNumber numberWithInt:aPageNo],
                         @"pageSize":[NSNumber numberWithInt:aPageSize],
                         };
    }
    
    NSString    *urlStr = [NSString stringWithFormat:@"http://%@/user/newsArticle/strategyList",HTTP_IP];
    [NetRequest postRequestWithNSDictionary:parameterDic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([DataUsedEngine nullTrim:dictionary[@"code"]]) {
            if ([dictionary[@"code"] intValue] == 200) {
                if ([DataUsedEngine nullTrim:dictionary[@"data"]]) {
                    NSMutableArray  *dataArray = [NSMutableArray arrayWithCapacity:0];
                    for (int i = 0; i < [dictionary[@"data"] count]; i++) {
                        News    *news = [[News alloc]init];
                        news.title          = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"title"]];
                        news.sectionName    = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"sectionName"]];
                        news.summary        = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"summary"]];
                        news.permitComment  = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"permitComment"]];
                        news.bannerUrl      = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"bannerUrl"]];
                        news.readCount      = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"readCount"]];
                        news.plateName      = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"plateName"]];
                        news.createDate     = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"createDate"]];
                        news.newsID         = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"id"]];
                        
                        news.content        = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"content"]];
                        news.subTitle       = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"subTitle"]];
                        news.modifyDate     = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"modifyDate"]];
                        news.status         = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"status"]];
                        news.keyword        = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"keyword"]];
                        news.createStaffName     = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"createStaffName"]];
                        news.cmtCount       = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"cmtCount"]];
                        news.orderWeight    = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"orderWeight"]];
                        news.sourceType     = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"sourceType"]];
                        news.newsPlateIdList     = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"newsPlateIdList"]];
                        news.targetType     = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"targetType"]];
                        news.outSourceName  = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"outSourceName"]];
                        news.section        = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"section"]];
                        news.outSourceUrl   = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"outSourceUrl"]];
                        news.picFlag        = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"picFlag"]];
                        news.hotEndTime     = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"hotEndTime"]];
                        news.hot            = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"hot"]];
                        news.top            = [DataUsedEngine nullTrimString:dictionary[@"data"][i][@"top"]];
                        [dataArray addObject:news];
                    }
                    
                    completeBlock(YES,dataArray);
                }else{
                    completeBlock(NO,nil);
                }
            }else{
                completeBlock(NO,nil);
            }
        }else{
            completeBlock(NO,nil);
        }
    } failureBlock:^(NSError *error) {
        completeBlock(NO,nil);
    }];
}

@end
