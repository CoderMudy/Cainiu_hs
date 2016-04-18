//
//  DataEngine+Futures.h
//  hs
//
//  Created by RGZ on 15/11/30.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "DataEngine.h"

@interface DataEngine(Futures)

//期货

#pragma mark 期货状态查询

+(void)requestToGetFuturesState:(NSString *)aCode completeBlock:(void(^)(BOOL , NSString *))successBlock;

#pragma mark 获取操盘配置信息

+(void)requestToGetTraderConfiger:(NSString *)aState completeBlock:(void(^)(BOOL , NSMutableArray *,NSMutableArray *))successBlock;

#pragma mark 购买期货

+(void)requestToBuy:(NSDictionary *)aDic completeBlock:(void(^)(BOOL , NSDictionary *))successBlock;

#pragma mark 更新友盟设备号

+(void)requestUpdateUMDevicesWithBlock:(void(^)(BOOL))successBlock;

#pragma mark 用户出售期货订单

+(void)requestToSaleWithID:(NSString*)aID type:(int)aType price:(NSString *)aPrice date:(NSString  *)aTime isCheck:(NSString*)isCheck successBlock:(void(^)(BOOL,NSString *,NSDictionary *))successBlock;


#pragma mark 获取个人配资额度

+(void)requestToGetCapitalMoney:(NSString *)aMoney Complete:(void(^)(BOOL,NSMutableArray *,NSMutableArray *))block;

#pragma mark 获取市场状态

+(void)requestToGetMarketStatus:(void(^)(BOOL,NSMutableDictionary *))block;

#pragma mark 交易记录

+(void)requestToGetRecordIsMoney:(BOOL)isMoney pageNo:(int)aNo completeBlock:(void(^)(NSMutableArray *))successBlock failBlock:(void(^)(NSString *))failBlock;

#pragma mark 系统控制

+(void)requestCompleteBlock:(void(^)(NSString *))successBlock failBlock:(void(^)(NSString *))failBlock;

#pragma mark 期货是否开户

+(void)requestToGetFutureRegist:(void(^)(BOOL))successBlock ;
@end
