//
//  DataEngine.h
//  hs
//
//  Created by RGZ on 15/5/18.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StockOrderModel.h"

@interface DataEngine : NSObject
AS_SINGLETON(DataEngine)

#pragma mark 存储用户信息

+(void)saveUserInfo:(NSDictionary *)data;

#pragma mark 获取运营商

+(NSString*)getCellularProviderName;

#pragma mark 去除空数据

-(NSString *)trimString:(NSString *)aStr;

#pragma mark 金额加‘，’

+(NSString *)countNumAndChangeformat:(NSString *)num;

+(NSString *)addSign:(NSString *)aStr;

+(NSString *)addSign:(NSString *)aStr pointNum:(int)aNum;

#pragma mark 冻结金额

+(void)requestToGetFreezeMoneyWithComplete:(void(^)(BOOL , NSString *))block;

#pragma mark 用户资金账户--获取可用余额、积分

+(void)requestToGetAllMoneyWithComplete:(void(^)(BOOL , NSMutableArray *))block;

#pragma mark 股票市值

+(void)requestToGetStockMarketWithComplete:(void(^)(BOOL , NSString *))block;

#pragma mark 验证手机号

+(void)requestToAuthbindOfMobileWithComplete:(void(^)(BOOL ,NSString *, NSString *))block;

#pragma mark 验证是否实名认证

+(void)requestToAuthbindOfRealNameWithComplete:(void(^)(BOOL ,NSString *, NSString *,NSString *))block;

#pragma mark 验证银行卡绑定

+(void)requestToAuthbindOfBankWithComplete:(void(^)(BOOL ,NSString *, NSString *,NSString *))block;

#pragma mark 快钱充值请求

+(void)requestRecharge:(NSString *)amt Complete:(void(^)(BOOL ,NSString *))block;

#pragma mark 昵称修改

+(void)requestToAlterNick:(NSString *)aNick Complete:(void(^)(BOOL ,NSString *))block;

#pragma mark 修改个性签名

+(void)requestToAlterSign:(NSString *)aSign Complete:(void(^)(BOOL ,NSString *))block;

#pragma mark 实名认证

+(void)requestToAuthRealName:(NSString *)aName IdCard:(NSString *)aIdCard Complete:(void(^)(BOOL ,NSString *))block;

#pragma mark 获取银行名称

+(void)requestToGetBankNameWithBankCard:(NSString *)aCard Complete:(void(^)(BOOL ,NSString *))block;

#pragma mark 添加银行卡

+(void)requestToAddBankCard:(NSString *)aBankCard BankName:(NSString *)aBankName Type:(int)aType Complete:(void(^)(BOOL ,NSString *))block;

#pragma mark 修改密码

+(void)requestToAlterPwdWithOldPwd:(NSString *)aOldPwd NewPwd:(NSString *)aNewPwd Complete:(void(^)(BOOL ,NSString *))block;

#pragma mark 意见反馈

+(void)requestToCommitAdvice:(NSString *)aMessage Complete:(void(^)(BOOL ,NSString *))block;

#pragma mark 获取消息列表

//+(void)requestToGetMessageListWithPageNo:(NSInteger)aPageNo PageSize:(NSInteger)aPageSize Complete:(void(^)(BOOL ,NSMutableArray *systemArray,NSMutableArray *bargainArray))block;

#pragma mark 绑定手机发送验证码

+(void)requestToSendAuthCode:(NSString *)aTel Complete:(void(^)(BOOL ,NSString *,NSString *,NSString *))block;

#pragma mark 验证注册验证码

+(void)requestToAuthCodeWithTel:(NSString *)aTel Code:(NSString *)aCode Complete:(void(^)(BOOL ,NSDictionary *))block;

#pragma mark 获取系统时间

+(void)requestToGetSystemDateWithComplete:(void(^)(BOOL ,NSString *,NSString *))block;

#pragma mark 设置手势密码

+(void)requestToSetGesturePWDWithPWD:(NSString *)aPwd Complete:(void(^)(BOOL))block;

#pragma mark 修改手势密码

+(void)requestToAlterGesturePWDWithPWD:(NSString *)aPwd LoginPWD:(NSString *)aLoginPWD Complete:(void(^)(BOOL))block;

#pragma mark 验证手势密码

+(void)requestToAuthGesturePWD:(NSString *)aPwd Complete:(void(^)(BOOL,NSDictionary *))block;

#pragma mark 校验登录密码

+(void)requestToAuthLoginPWD:(NSString *)aPwd Complete:(void(^)(BOOL,NSString *,NSString *))block;

#pragma mark 是否开启手势密码

+(void)requestToOpenGesture:(NSString *)aState Complete:(void(^)(BOOL,NSString *))block;

#pragma mark 获取省市对应的开户支行

+(void)requestToGetSubBankName:(NSString *)aBankName Province:(NSString *)aProvince City:(NSString *)aCity Complete:(void(^)(BOOL,NSString *,NSArray *))block;



#pragma mark 验证是否内部人员设备

+(void)requestToGetIsTest:(void(^)(NSString *))successBlock;

#pragma mark 验证后台密码返回IP

+(void)requestToAuthPwd:(NSString *)aPwd Type:(NSString *)aType completeBlock:(void(^)(BOOL , NSString *))successBlock;

#pragma mark 显示控制

+(void)requestToGetShowControlWithCompleteBlock:(void(^)(BOOL,NSDictionary *))successBlock;

#pragma mark 阿里云环境配置文件

+(void)requestToDownloadEnvironmentFile;

#pragma mark 获取银行卡列表

+(void)requestToGetBankCardList:(void(^)(NSMutableArray *,NSMutableArray *))successBlock;

@end
