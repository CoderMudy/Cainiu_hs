//
//  SystemDataMgr.m
//  hs
//
//  Created by PXJ on 15/11/17.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "SystemDataMgr.h"

#define KeySystem_appDetail @"appDetail"
#define KeySystem_appStyle @"appStyle"

#define KeySystem_appName @"appName"
#define KeySystem_appShortName @"appShortName"
#define KeySystem_showUrl @"showUrl"
#define KeySystem_OfficialWeb @"officialWeb"
#define KeySystem_OfficialDownLoadAdress @"officialDownLoadAddress"
#define KeySystem_domainName @"domainName"
#define KeySystem_umengAppkey @"umengAppkey"
#define KeySystem_shareSDKAppkey @"shareSDKAppkey"
#define KeySystem_qZoneAppkey @"qZoneAppkey"
#define KeySystem_qZoneSecret @"qZoneSecret"
#define KeySystem_weChatAppkey @"weChatAppkey"
#define KeySystem_weChatSecret @"weChatSecret"
#define KeySystem_sinaWeiboAppkey @"sinaWeiboAppkey"
#define KeySystem_sinaWeiboSecret @"sinaWeiboSecret"
#define KeySystem_sinaWeiboRedirectUri @"sinaWeiboRedirectUri"
#define KeySystem_shareIconName @"shareIconName"
#define KeySystem_appleStoreID @"appleStoreID"
#define KeySystem_kefuTel @"kefuTel"
#define KeySystem_kefuQQ @"kefuQQ"
#define KeySystem_weChatName @"weChatName"
#define KeySystem_weboName @"weboName"
#define KeySystem_zfbAccount @"zfbAccount"
#define KeySystem_zfbName @"zfbName"
#define KeySystem_pkgtype @"pkgtype"
#define KeySystem_regSource @"regSource"
#define KeySystem_payBankName @"payBankName"
#define KeySystem_payCompanyName @"payCompanyName"
#define KeySystem_payBankShowNumber @"payBankShowNumber"
#define KeySystem_payBankNumber @"payBankNumber"
#define KeySystem_aliyunDomainAddress @"aliyunDomainAddress"
#define KeySystem_HTTP_IP_ONLINE    @"HTTP_IP_ONLINE"
#define KeySystem_HTTP_IP_TEST      @"HTTP_IP_TEST"
#define KeySystem_HTTP_IP_SIMULATE  @"HTTP_IP_SIMULATE"



@implementation SystemDataMgr



DEF_SINGLETON(SystemDataMgr)


+(NSString *)getPath//获取json文件
{
    
    NSString * jsonName;
#if defined (CAINIUYYB)
    jsonName = @"CainiuYYBJsonClass";
#elif defined(SELF)
    jsonName = @"CainiuJsonClass";
#elif defined(YQB)
    jsonName = @"SaleJsonClass";
#else
    jsonName = @"SaleJsonClass";
#endif
    
    NSString * filepath = [[NSBundle mainBundle] pathForResource:jsonName ofType:@"json"];
    return filepath;
}
+(NSDictionary *)changeJsonData
{
    NSData * jsonData = [[NSData alloc] initWithContentsOfFile:[SystemDataMgr getPath]];
    NSError * error;
    id jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    return jsonDic;
}


#pragma mark 获取appDetail
+ (NSDictionary *)getAppDetail
{
   return  [[SystemDataMgr changeJsonData] objectForKey:KeySystem_appDetail];
}

#pragma  mark 获取app系统类型
+ (NSString *)getAppStyle
{
    return  [[SystemDataMgr changeJsonData] objectForKey:KeySystem_appStyle];
}





+ (NSString *)appName;//应用名（财牛投资）
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_appName];
}
+ (NSString *)appShortName;//财牛
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_appShortName];
}
+ (NSString *)showUrl;//www.cainiu.com
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_showUrl];
}
+ (NSString *)OfficialWeb;//http://www.cainiu.com
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_OfficialWeb];
}
+ (NSString *)officialDownLoadAddress;//http://www.cainiu.com 下载地址
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_OfficialDownLoadAdress];
}

+ (NSString *)domainName;//stock.cainiu.com域名
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_domainName];
}
+ (NSString *)umengAppkey;
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_umengAppkey];
}
+ (NSString *)shareSDKAppkey;
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_shareSDKAppkey];
}
+ (NSString *)qZoneAppkey;
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_qZoneAppkey];
}
+ (NSString *)qZoneSecret;
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_qZoneSecret];
}
+ (NSString *)weChatAppkey;
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_weChatAppkey];
}
+ (NSString *)weChatSecret;
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_weChatSecret];
}
+ (NSString *)sinaWeiboAppkey;
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_sinaWeiboAppkey];
}
+ (NSString *)sinaWeiboSecret;
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_sinaWeiboSecret];
}
+ (NSString *)sinaWeiboRedirectUri;
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_sinaWeiboRedirectUri];
}
+ (NSString *)shareIconName
{
    return [[SystemDataMgr getAppDetail]objectForKey:KeySystem_shareIconName];
}
+ (NSString *)zfbAccount;
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_zfbAccount];
}
+ (NSString *)zfbName;
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_zfbName];
}

+ (NSString *)regSource;//渠道号
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_regSource];
}
+ (NSString *)payBankName;//银行名称
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_payBankName];
}
+ (NSString *)payCompanyName;//公司名称
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_payCompanyName];
}
+ (NSString *)payBankShowNumber;//公司银行帐号显示
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_payBankShowNumber];
}
+ (NSString *)payBankNumber;//公司银行帐号
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_payBankNumber];
}
+ (NSString *)aliyunDomainAddress;//公司银行帐号
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_aliyunDomainAddress];
}

+ (NSString *)HTTP_IP_ONLINE
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_HTTP_IP_ONLINE];
}
+ (NSString *)HTTP_IP_TEST
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_HTTP_IP_TEST];
}
+ (NSString *)HTTP_IP_SIMULATE
{
    return [[SystemDataMgr getAppDetail] objectForKey:KeySystem_HTTP_IP_SIMULATE];
}
@end
