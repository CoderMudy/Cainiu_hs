//
//  DataEngine+Table.h
//  hs
//
//  Created by RGZ on 15/11/30.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "DataEngine.h"
#import "NetRequest.h"
#import "NSString+MD5.h"
#import "IndexMarketInfoModel.h"
@interface DataEngine(Table)

#pragma mark 行情ip、port

+(void)requestToGetIPAndPortWithBlock:(void(^)(BOOL,NSString *,NSString *))successBlock;

#pragma mark 获取实时策略/持仓直播
+(void)requestToGetTacticsDataWithType:(NSString *)aType successBlock:(void(^)(BOOL,NSDictionary *))successBlock;

+(NSString *)bundleSeedID;

#pragma mark K线图数据获取
+(void)requestToGetKLineDataWithType:(NSString *)aType AndTime:(NSString *)aTime successBlock:(void(^)(BOOL,NSMutableArray *))successBlock;


#pragma mark 盘口数据

+(void)requestToGetMarketInfoDataWithType:(NSString *)aType successBlock:(void(^)(BOOL,IndexMarketInfoModel *))successBlock;

#pragma mark K线数据优化
/**
 *  K线数据获取
 *
 *  @param aType        期货类型
 *  @param aTime        最后一条记录时间
 *  @param aKLineMinute K线类型
 *  @param successBlock 回调
 */
+(void)requestToGetKLineWithType:(NSString *)aType Time:(NSString *)aTime KLineMinute:(NSInteger)aKLineMinute successBlock:(void(^)(BOOL,NSMutableArray *))successBlock;

@end

@interface DataEngine(News)

#pragma mark 新闻列表

+(void)requestTogetNewsListWithPageNo:(int)aPageNo PageSize:(int)aPageSize completeBlock:(void(^)(BOOL,NSMutableArray *))completeBlock;

#pragma mark 策略列表
+(void)requestTogetTacticListWithPageNo:(int)aPageNo PageSize:(int)aPageSize completeBlock:(void(^)(BOOL,NSMutableArray *))completeBlock;

@end