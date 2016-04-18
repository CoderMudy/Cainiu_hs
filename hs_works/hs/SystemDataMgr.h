//
//  SystemDataMgr.h
//  hs
//
//  Created by PXJ on 15/11/17.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemDataMgr : NSObject

AS_SINGLETON(SystemDataMgr)

+ (NSString *)getAppStyle;//获取app系统类型

+ (NSString *)appName;//应用名（财牛投资）
+ (NSString *)appShortName;//财牛
+ (NSString *)showUrl;//www.cainiu.com
+ (NSString *)OfficialWeb;//http://www.cainiu.com
+ (NSString *)officialDownLoadAddress;
+ (NSString *)domainName;//stock.cainiu.com域名
+ (NSString *)umengAppkey;//
+ (NSString *)shareSDKAppkey;
+ (NSString *)qZoneAppkey;
+ (NSString *)qZoneSecret;
+ (NSString *)weChatAppkey;
+ (NSString *)weChatSecret;
+ (NSString *)sinaWeiboAppkey;
+ (NSString *)sinaWeiboSecret;
+ (NSString *)sinaWeiboRedirectUri;
+ (NSString *)shareIconName;
+ (NSString *)zfbAccount;//支付宝账号
+ (NSString *)zfbName;//支付宝名字
+ (NSString *)regSource;//渠道号
+ (NSString *)payBankName;//银行名称
+ (NSString *)payCompanyName;//公司名称
+ (NSString *)payBankShowNumber;//公司银行帐号显示
+ (NSString *)payBankNumber;//公司银行帐号
+ (NSString *)aliyunDomainAddress;//域名阿里云地址

+ (NSString *)HTTP_IP_ONLINE;
+ (NSString *)HTTP_IP_TEST;
+ (NSString *)HTTP_IP_SIMULATE;
@end
