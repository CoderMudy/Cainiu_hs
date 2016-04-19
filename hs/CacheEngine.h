//
//  CacheEngine.h
//  hs
//
//  Created by RGZ on 15/6/23.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheEngine : NSObject

#pragma mark 获取缓存信息

+(CacheModel *)getCacheInfo;

#pragma mark 存储缓存信息

+(void)setCacheInfo:(CacheModel *)aCacheModel;
//key:手机号
+(void)setCacheInfo:(CacheModel *)aCacheModel Key:(NSString *)aKeyName;

#pragma mark 清空缓存(清空所有存储信息)

+(void)clearCache;


//欢迎页专用*****
+(void)firstInfo;
+(BOOL)isFirstInfo;
//end************

//交易规则"？"闪动处理
+(void)tradeRulsShow;
+(BOOL)isShowTradeRules;

//手势密码专用
//手势密码是否打开
//NO：未打开 YES：已打开
+(void)setOpenGes:(BOOL)isOpenGes;
+(BOOL)isOpenGes;

//手势密码是否设置
//0:未设置  1:已设置
+(void)setGesPwd:(NSString *)aPwd;
+(NSString *)getGesPwd;
+(BOOL)isSetPwd;
//end************


//市场状态专用
+(void)setMarketStatus:(NSMutableDictionary *)aDic;
+(NSMutableDictionary *)getMarketStatus;

//系统判断（QQ、微信登录）
+(void)setLoginStatus:(NSString *)aStr;
+(NSString *)getLoginStatus;

//环境存储
+(void)setEnvironmentHTTP_IP;
+(NSString *)getEnvironmentHTTP_IP_ONLINE;
+(NSString *)getEnvironmentHTTP_IP_TEST;
+(NSString *)getEnvironmentHTTP_IP_SIMULATE;

#pragma mark 南交所信息

+(NSString *)getSpotgoodsInfoToken;

+(NSString *)getSpotgoodsInfoUsername;

+(NSString *)getSpotgoodsInfoPassword;

+(NSString *)getSpotgoodsHttpToken;

+(void)setSpotgoodsInfoTradeID:(NSString *)aTradeID Token:(NSString *)aToken HTTPToken:(NSString *)aHttpToken PassWord:(NSString *)aPassword;

+(void)clearSpotgoodsInfo;

#pragma mark 资讯首页缓存

+(NSMutableArray *)getInfoWithNews;//老版资讯方法更新时要删除

+(NSMutableArray *)getNewsInfoWithNews;

+(void)setNewsInfoWithCache:(NSMutableArray *)aNewsArray;

+(NSMutableSet *)getNewsReadedID;

+(void)setNewsReadedID:(NSMutableSet *)newsIDArray;

+(NSMutableArray *)getTacticInfoWithTactic;

+(void)setTacticInfoWithCache:(NSMutableArray *)aTacticArray;


+(NSMutableDictionary *)getNewsDetailImage;
    
+(void)setNewInfoDetailImageDetail:(NSMutableDictionary *)detailDic;

@end
