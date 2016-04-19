//
//  DataEngine.m
//  hs
//
//  Created by RGZ on 15/5/18.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "DataEngine.h"
#import "NetRequest.h"
#import "NSString+MD5.h"
#import "TradeConfigerModel.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>


@implementation DataEngine
DEF_SINGLETON(DataEngine)

#pragma mark 存储用户信息

+(void)saveUserInfo:(NSDictionary *)data{
    UserInfo    *userInfo = [[UserInfo alloc]init];
    
    userInfo.userNickStatus = [[DataEngine sharedInstance] trimString:[NSString stringWithFormat:@"%@",data[@"data"][@"nickStatus"]]];
    userInfo.userNickUpdateDate = [[DataEngine sharedInstance] trimString:[NSString stringWithFormat:@"%@",data[@"data"][@"nickUpdateDate"]]];
    
    
    userInfo.userTokenUserSecret = [[DataEngine sharedInstance] trimString:[NSString stringWithFormat:@"%@",data[@"data"][@"tokenInfo"][@"userSecret"]]];
    userInfo.userTokenToken = [[DataEngine sharedInstance] trimString:[NSString stringWithFormat:@"%@",data[@"data"][@"tokenInfo"][@"token"]]];
    userInfo.userTokenIsDeline = [[DataEngine sharedInstance] trimString:[NSString stringWithFormat:@"%@",data[@"data"][@"tokenInfo"][@"isdeline"]]];
    userInfo.userTokenUserID = [[DataEngine sharedInstance] trimString:[NSString stringWithFormat:@"%@",data[@"data"][@"tokenInfo"][@"userId"]]];
    
    userInfo.userUserInfoSex = [[DataEngine sharedInstance] trimString:[NSString stringWithFormat:@"%@",data[@"data"][@"userInfo"][@"sex"]]];
    userInfo.userUserInfoNick = [[DataEngine sharedInstance] trimString:[NSString stringWithFormat:@"%@",data[@"data"][@"userInfo"][@"nick"]]];
    userInfo.userUserInfoCLS = [[DataEngine sharedInstance] trimString:[NSString stringWithFormat:@"%@",data[@"data"][@"userInfo"][@"user_cls"]]];
    userInfo.userUserInfoHeadPic = [[DataEngine sharedInstance] trimString:[NSString stringWithFormat:@"%@",data[@"data"][@"userInfo"][@"head_pic"]]];
    userInfo.userUserInfoSign = [[DataEngine sharedInstance] trimString:[NSString stringWithFormat:@"%@",data[@"data"][@"userInfo"][@"person_sign"]]];
    userInfo.userGestureIsSetPWD = [[DataEngine sharedInstance] trimString:[NSString stringWithFormat:@"%@",data[@"data"][@"userInfo"][@"is_set_gesture_pwd"]]];
    userInfo.userUserInfoBirth = [[DataEngine sharedInstance] trimString:[NSString stringWithFormat:@"%@",data[@"data"][@"userInfo"][@"birth"]]];
    userInfo.userGestureIsOpenidLogin = [[DataEngine sharedInstance] trimString:[NSString stringWithFormat:@"%@",data[@"data"][@"userInfo"][@"is_openid_login"]]];
    userInfo.userGestureIsStart = [[DataEngine sharedInstance] trimString:[NSString stringWithFormat:@"%@",data[@"data"][@"userInfo"][@"is_start_gesture"]]];
    userInfo.userUserInfoName = [[DataEngine sharedInstance] trimString:[NSString stringWithFormat:@"%@",data[@"data"][@"userInfo"][@"name"]]];
    userInfo.userUserInfoTele = [[DataEngine sharedInstance] trimString:[NSString stringWithFormat:@"%@",data[@"data"][@"userInfo"][@"tele"]]];
    userInfo.userUserInfoCity = [[DataEngine sharedInstance] trimString:[NSString stringWithFormat:@"%@",data[@"data"][@"userInfo"][@"city"]]];
    userInfo.userUserInfoRegDate = [[DataEngine sharedInstance] trimString:[NSString stringWithFormat:@"%@",data[@"data"][@"userInfo"][@"reg_date"]]];
    userInfo.userUserInfoAddress = [[DataEngine sharedInstance] trimString:[NSString stringWithFormat:@"%@",data[@"data"][@"userInfo"][@"address"]]];
    userInfo.userUserInfoRegion = [[DataEngine sharedInstance] trimString:[NSString stringWithFormat:@"%@",data[@"data"][@"userInfo"][@"region"]]];
    userInfo.userUserInfoProvice = [[DataEngine sharedInstance] trimString:[NSString stringWithFormat:@"%@",data[@"data"][@"userInfo"][@"provice"]]];
    
    setUser_Info(userInfo);
}

#pragma mark 去除空数据
-(NSString *)trimString:(NSString *)aStr
{
    if (aStr==nil||[aStr isKindOfClass:[NSNull class]]||[aStr isEqualToString:@"null"]||[aStr isEqualToString:@"<null>"]||[aStr isEqualToString:@"(null)"]||aStr == NULL||aStr.length == 0) {
        return @"";
    }
    else
    {
        return aStr;
    }
}

#pragma mark 金额加‘，’
//传入整数类型的数值
+(NSString *)countNumAndChangeformat:(NSString *)num
{
    if (num == nil || [num isEqualToString:@"(null)"] || [num isKindOfClass:[NSNull class]] || (num != nil && num.length > 15)) {
        return @"";
    }
    
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3)
    {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}
//传入小数位为两位的数值
+(NSString *)addSign:(NSString *)aStr
{
    if (aStr == nil || [aStr isEqualToString:@"(null)"] || [aStr isKindOfClass:[NSNull class]] || (aStr != nil && aStr.length > 15)) {
        return @"";
    }
    
    NSString *point=[aStr substringFromIndex:aStr.length-3];
    
    NSString *money=[aStr substringToIndex:aStr.length-3];
    
    return [[DataEngine countNumAndChangeformat:money] stringByAppendingString:point];
}
//随便传,保证小数位对就行
+(NSString *)addSign:(NSString *)aStr pointNum:(int)aNum
{
    if (aStr == nil || [aStr isEqualToString:@"(null)"] || [aStr isKindOfClass:[NSNull class]] || (aStr != nil && aStr.length > 15)) {
        return @"";
    }
    
    if (aNum > 0) {
        NSString *point=[aStr substringFromIndex:aStr.length-(aNum+1)];
        NSString *money=[aStr substringToIndex:aStr.length-(aNum+1)];
        return [[DataEngine countNumAndChangeformat:money] stringByAppendingString:point];
    }
    else{
        return [DataEngine countNumAndChangeformat:aStr];
    }
}

#pragma mark 获取运营商

+(NSString*)getCellularProviderName
{
    
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc]init];
    
    CTCarrier*carrier = [netInfo subscriberCellularProvider];
    NSLog(@"carrier:%@",carrier);
    NSString * imsi=@"";
    if (carrier!=NULL) {
//        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
//        [dic setObject:[carrier carrierName] forKey:@"Carriername"];
//        [dic setObject:[carrier mobileCountryCode] forKey:@"MobileCountryCode"];
//        [dic setObject:[carrier mobileNetworkCode]forKey:@"MobileNetworkCode"];
//        [dic setObject:[carrier isoCountryCode] forKey:@"ISOCountryCode"];
//        [dic setObject:[carrier allowsVOIP]?@"YES":@"NO" forKey:@"AllowsVOIP"];
        
        //        NSData   *jsonData=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        
        if ([carrier carrierName] != nil && ![[carrier carrierName] isKindOfClass:[NSNull class]]) {
            imsi=[carrier carrierName];
        }
    }
    
    return imsi;//cellularProviderName;
    
}
#pragma mark 冻结金额

+(void)requestToGetFreezeMoneyWithComplete:(void(^)(BOOL , NSString *))block
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       VERSION,@"version",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"http://%@/order/order/frozenAmt",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            NSString *money;
            if ([dictionary[@"data"] isKindOfClass:[NSNull class]]||[[NSString stringWithFormat:@"%@",dictionary[@"data"]] isEqualToString:@""]||dictionary[@"data"] ==nil) {
                money=@"0.00";
            }
            else
            {
                money=dictionary[@"data"];
            }
            block(YES,money);
        }
        else
        {
            block(NO,dictionary[@"msg"]);
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO,@"");
    }];
}

#pragma mark 用户资金账户--获取可用余额、积分
//可提现金额|积分|可用金额|持仓冻结资金|持仓冻结积分|用户提现冻结资金|
+(void)requestToGetAllMoneyWithComplete:(void(^)(BOOL , NSMutableArray *))block
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       /* VERSION,@"version",*/
                       nil];
    NSString     *url=[NSString stringWithFormat:@"http://%@/financy/financy/apiFinancyMain",HTTP_IP];
    
    NSMutableArray *infoArray = [NSMutableArray arrayWithCapacity:0];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            //可提现金额
            NSString *money;
            //积分
            NSString *score;
            //可用金额
            NSString *useMoney;
            //持仓冻结资金
            NSString *positonFreezeMoney;
            //持仓冻结积分
            NSString *positonfreezeScore;
            //用户提现冻结资金
            NSString *freezeMoney;
            
            if ([dictionary[@"data"][@"curDrawAmt"] isKindOfClass:[NSNull class]]||
                [[NSString stringWithFormat:@"%@",dictionary[@"data"][@"curDrawAmt"]] isEqualToString:@""]||
                dictionary[@"data"][@"curDrawAmt"] ==nil) {
                money=@"0.00";
            }
            else
            {
                money=dictionary[@"data"][@"curDrawAmt"];
            }
            if ([dictionary[@"data"][@"score"] isKindOfClass:[NSNull class]]||
                [[NSString stringWithFormat:@"%@",dictionary[@"data"][@"score"]] isEqualToString:@""]||
                dictionary[@"data"][@"score"] ==nil) {
                score=@"0";
            }
            else
            {
                score=dictionary[@"data"][@"score"];
            }
            
            if ([dictionary[@"data"][@"usedAmt"] isKindOfClass:[NSNull class]]||
                [[NSString stringWithFormat:@"%@",dictionary[@"data"][@"usedAmt"]] isEqualToString:@""]||
                dictionary[@"data"][@"usedAmt"] ==nil) {
                useMoney=@"0";
            }
            else
            {
                useMoney=dictionary[@"data"][@"usedAmt"];
            }
            
            if ([dictionary[@"data"][@"freezeAmt"] isKindOfClass:[NSNull class]]||
                [[NSString stringWithFormat:@"%@",dictionary[@"data"][@"freezeAmt"]] isEqualToString:@""]||
                dictionary[@"data"][@"freezeAmt"] ==nil) {
                freezeMoney=@"0";
            }
            else
            {
                freezeMoney=dictionary[@"data"][@"freezeAmt"];
            }
            
            if ([dictionary[@"data"][@"curCashFund"] isKindOfClass:[NSNull class]]||
                [[NSString stringWithFormat:@"%@",dictionary[@"data"][@"curCashFund"]] isEqualToString:@""]||
                dictionary[@"data"][@"curCashFund"] ==nil) {
                positonFreezeMoney=@"0";
            }
            else
            {
                positonFreezeMoney=dictionary[@"data"][@"curCashFund"];
            }
            
            if ([dictionary[@"data"][@"curCashScore"] isKindOfClass:[NSNull class]]||
                [[NSString stringWithFormat:@"%@",dictionary[@"data"][@"curCashScore"]] isEqualToString:@""]||
                dictionary[@"data"][@"curCashScore"] ==nil) {
                positonfreezeScore=@"0";
            }
            else
            {
                positonfreezeScore=dictionary[@"data"][@"curCashScore"];
            }
            
            [infoArray addObject:money];
            [infoArray addObject:score];
            [infoArray addObject:useMoney];
            [infoArray addObject:positonFreezeMoney];
            [infoArray addObject:positonfreezeScore];
            [infoArray addObject:freezeMoney];
            
            block(YES,infoArray);
        }
        else
        {
            block(NO,[[NSMutableArray alloc]initWithObjects:dictionary[@"msg"], nil]);
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO,nil);
    }];
}

#pragma mark 股票市值
+(void)requestToGetStockMarketWithComplete:(void(^)(BOOL , NSString *))block
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       VERSION,@"version",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"http://%@/order/order/marketValue",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            NSString *money;
            if ([dictionary[@"data"] isKindOfClass:[NSNull class]]||[[NSString stringWithFormat:@"%@",dictionary[@"data"]] isEqualToString:@""]||dictionary[@"data"] ==nil) {
                money=@"0.00";
            }
            else
            {
                money=dictionary[@"data"];
            }
            block(YES,money);
        }
        else
        {
            block(NO,dictionary[@"msg"]);
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO,@"");
    }];
}

#pragma mark 验证手机号

+(void)requestToAuthbindOfMobileWithComplete:(void(^)(BOOL ,NSString *, NSString *))block
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       VERSION,@"version",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"http://%@/user/user/checkTele",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            if ([[NSString stringWithFormat:@"%@",dictionary[@"data"][@"status"]] isEqualToString:@"1"]||[[NSString stringWithFormat:@"%@",dictionary[@"data"][@"status"]] isEqualToString:@"2"]) {
                block(YES,[NSString stringWithFormat:@"%@",dictionary[@"data"][@"status"]],dictionary[@"data"][@"tele"]);
            }
            else
            {
                block(YES,@"0",@"");
            }
            
        }
        else
        {
            block(NO,dictionary[@"msg"],@"");
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO,@"",@"");
    }];
}

#pragma mark 验证是否实名认证

+(void)requestToAuthbindOfRealNameWithComplete:(void(^)(BOOL ,NSString *, NSString *,NSString *))block
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       VERSION,@"version",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"http://%@/user/user/checkUserName",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            if ([[NSString stringWithFormat:@"%@",dictionary[@"data"][@"status"]] isEqualToString:@"1"]||[[NSString stringWithFormat:@"%@",dictionary[@"data"][@"status"]] isEqualToString:@"2"]) {
                block(YES,[NSString stringWithFormat:@"%@",dictionary[@"data"][@"status"]],dictionary[@"data"][@"userName"],dictionary[@"data"][@"idCardNum"]);
            }
            else
            {
                block(YES,@"0",@"",@"");
            }
            
        }
        else
        {
            block(NO,dictionary[@"msg"],@"",@"");
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO,@"",@"",@"");
    }];
}

#pragma mark 验证银行卡绑定

+(void)requestToAuthbindOfBankWithComplete:(void(^)(BOOL ,NSString *, NSString *,NSString *))block
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       VERSION,@"version",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"http://%@/user/user/checkBankCard",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            if ([[NSString stringWithFormat:@"%@",dictionary[@"data"][@"status"]] isEqualToString:@"1"]||[[NSString stringWithFormat:@"%@",dictionary[@"data"][@"status"]] isEqualToString:@"2"]) {
                block(YES,[NSString stringWithFormat:@"%@",dictionary[@"data"][@"status"]],dictionary[@"data"][@"bankName"],dictionary[@"data"][@"bankNum"]);
            }
            else
            {
                block(YES,@"0",@"",@"");
            }
            
        }
        else
        {
            block(NO,dictionary[@"msg"],@"",@"");
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO,@"",@"",@"");
    }];
}
#pragma mark 快钱充值请求

+(void)requestRecharge:(NSString *)amt Complete:(void(^)(BOOL ,NSString *))block
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       amt,@"amt",
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       VERSION,@"version",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"http://%@/financy/topup/top",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            block(YES,dictionary[@"data"]);
        }
        else
        {
            block(NO,dictionary[@"msg"]);
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO,@"");
    }];
}



#pragma mark 昵称修改

+(void)requestToAlterNick:(NSString *)aNick Complete:(void(^)(BOOL ,NSString *))block
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       aNick,@"nick",
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       VERSION,@"version",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"http://%@/user/user/updUserNick",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            block(YES,dictionary[@"msg"]);
        }
        else
        {
            block(NO,dictionary[@"msg"]);
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO,@"");
    }];
}

#pragma mark 修改个性签名

+(void)requestToAlterSign:(NSString *)aSign Complete:(void(^)(BOOL ,NSString *))block
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       aSign,@"personalSign",
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       VERSION,@"version",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"http://%@/user/user/updPersonalSign",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            block(YES,dictionary[@"msg"]);
        }
        else
        {
            block(NO,dictionary[@"msg"]);
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO,@"");
    }];
}

#pragma mark 实名认证

+(void)requestToAuthRealName:(NSString *)aName IdCard:(NSString *)aIdCard Complete:(void(^)(BOOL ,NSString *))block
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       aIdCard,@"idCard",
                       aName,@"realName",
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       VERSION,@"version",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"http://%@/user/user/authUser",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            block(YES,dictionary[@"msg"]);
        }
        else
        {
            block(NO,dictionary[@"msg"]);
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO,@"");
    }];
}

#pragma mark 获取银行名称

+(void)requestToGetBankNameWithBankCard:(NSString *)aCard Complete:(void(^)(BOOL ,NSString *))block
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       aCard,@"bankNum",
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       VERSION,@"version",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"http://%@/user/user/findBankName",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            if (dictionary[@"data"]==nil||[dictionary[@"data"] isKindOfClass:[NSNull class]]) {
                block(NO,@"");
            }
            else
            {
                block(YES,dictionary[@"data"]);
            }
            
        }
        else
        {
            block(NO,@"");
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO,@"");
    }];
}

#pragma mark 添加银行卡

+(void)requestToAddBankCard:(NSString *)aBankCard BankName:(NSString *)aBankName Type:(int)aType Complete:(void(^)(BOOL ,NSString *))block
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       aBankName,@"bankName",
                       aBankCard,@"bankNum",
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       VERSION,@"version",
                       nil];
    NSString * urlName = @"";
    if (aType == 1) {
        urlName = @"/updatebank";
    }
    else if (aType == 0)
    {
        urlName = @"/bindBank";
    }
    
    NSString     *url=[NSString stringWithFormat:@"http://%@/user/user%@",HTTP_IP,urlName];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            block(YES,dictionary[@"msg"]);
        }
        else
        {
            block(NO,dictionary[@"msg"]);
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO,@"");
    }];
}

#pragma mark 修改密码

+(void)requestToAlterPwdWithOldPwd:(NSString *)aOldPwd NewPwd:(NSString *)aNewPwd Complete:(void(^)(BOOL ,NSString *))block
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       aNewPwd,@"newPassword",
                       aOldPwd,@"oldPassword",
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       VERSION,@"version",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"http://%@/user/user/updLoginPwd",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            block(YES,dictionary[@"msg"]);
        }
        else
        {
            block(NO,dictionary[@"msg"]);
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO,@"");
    }];
}


#pragma mark 意见反馈

+(void)requestToCommitAdvice:(NSString *)aMessage Complete:(void(^)(BOOL ,NSString *))block
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       aMessage,@"feedback",
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"http://%@/user/feedback/saveFeedbackMessage",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            block(YES,dictionary[@"msg"]);
        }
        else
        {
            block(NO,dictionary[@"msg"]);
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO,@"");
    }];
}

#pragma mark 绑定手机发送验证码

+(void)requestToSendAuthCode:(NSString *)aTel Complete:(void(^)(BOOL ,NSString *,NSString *,NSString *))block
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       aTel,@"tele",
                       VERSION,@"version",[[NSString stringWithFormat:@"%@luckin",aTel] MD5Digest],@"sign",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"http://%@/user/sms/sendBindTele",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            block(YES,dictionary[@"data"],dictionary[@"msg"],dictionary[@"code"]);
        }
        else
        {
            block(NO,@"",dictionary[@"msg"],dictionary[@"code"]);
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO,@"",@"",@"");
    }];
}

#pragma mark 验证注册验证码

+(void)requestToAuthCodeWithTel:(NSString *)aTel Code:(NSString *)aCode Complete:(void(^)(BOOL ,NSDictionary *))block
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       aTel,@"tele",
                       aCode,@"code",
                       VERSION,@"version",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"http://%@/user/sms/authRegCode",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            block(YES,dictionary);
        }
        else
        {
            block(NO,dictionary);
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO,nil);
    }];
}

#pragma mark 获取系统时间

+(void)requestToGetSystemDateWithComplete:(void(^)(BOOL ,NSString *,NSString *))block
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       VERSION,@"version",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"http://%@/user/sysTime",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            block(YES,dictionary[@"data"][@"nowTime"],[NSString stringWithFormat:@"%lld",[dictionary[@"data"][@"timeInMillis"] longLongValue]]);
        }
        else
        {
            block(NO,dictionary[@"msg"],@"");
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO,nil,@"");
    }];
}

#pragma mark 设置手势密码

+(void)requestToSetGesturePWDWithPWD:(NSString *)aPwd Complete:(void(^)(BOOL))block
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       aPwd,@"gesturesPwd",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"http://%@/user/user/setGesturesPwd",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            block(YES);
        }
        else
        {
            block(NO);
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO);
    }];
}

#pragma mark 修改手势密码

+(void)requestToAlterGesturePWDWithPWD:(NSString *)aPwd LoginPWD:(NSString *)aLoginPWD Complete:(void(^)(BOOL))block
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       aPwd,@"newPwd",
                       aLoginPWD,@"password",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"http://%@/user/user/editGesturesPwd",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            block(YES);
        }
        else
        {
            block(NO);
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO);
    }];
}

#pragma mark 验证手势密码

+(void)requestToAuthGesturePWD:(NSString *)aPwd Complete:(void(^)(BOOL,NSDictionary *))block
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       aPwd,@"gesturesPwd",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"http://%@/user/user/verifyGesturesPwd",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            block(YES,dictionary);
        }
        else
        {
            block(NO,dictionary);
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO,nil);
    }];
}

#pragma mark 校验登录密码

+(void)requestToAuthLoginPWD:(NSString *)aPwd Complete:(void(^)(BOOL,NSString *,NSString *))block{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       [aPwd MD5Digest],@"password",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"http://%@/user/user/checkPwd",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            block(YES,dictionary[@"msg"],dictionary[@"data"]);
        }
        else
        {
            block(NO,dictionary[@"msg"],dictionary[@"data"]);
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO,@"",@"");
    }];
}

#pragma mark 设置是否开启手势密码

+(void)requestToOpenGesture:(NSString *)aState Complete:(void(^)(BOOL,NSString *))block
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       aState,@"status",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"http://%@/user/user/setIsGestures",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            block(YES,dictionary[@"msg"]);
        }
        else
        {
            block(NO,dictionary[@"msg"]);
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO,@"");
    }];
}

#pragma mark 获取省市对应的开户支行

+(void)requestToGetSubBankName:(NSString *)aBankName Province:(NSString *)aProvince City:(NSString *)aCity Complete:(void(^)(BOOL,NSString *,NSArray *))block{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       aBankName,@"bankName",
                       aProvince,@"provName",
                       aCity,@"cityName",
                       VERSION,@"version",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"http://%@/user/user/findBranchList",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            block(YES,dictionary[@"msg"],dictionary[@"data"]);
        }
        else
        {
            block(NO,dictionary[@"msg"],nil);
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO,nil,nil);
    }];
}



#pragma mark 验证是否内部人员设备

+(void)requestToGetIsTest:(void(^)(NSString *))successBlock{
    NSDictionary * dic = @{@"deviceImei":UDID};
    
    NSString * urlStr = [NSString stringWithFormat:@"http://%@/user/device/checkStaffDevice",HTTP_IP];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject[@"data"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        successBlock(@"0");
    }];
}

#pragma mark 验证后台密码返回IP

+(void)requestToAuthPwd:(NSString *)aPwd Type:(NSString *)aType completeBlock:(void(^)(BOOL , NSString *))successBlock{

    NSDictionary * dic = @{@"deviceImei":UDID,@"password":aPwd,@"type":aType};
        
    NSString * urlStr = [NSString stringWithFormat:@"http://%@/user/device/checkPwd",HTTP_IP];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"code"] floatValue] == 200) {
            successBlock(YES , responseObject[@"data"]);
        }
        else{
            successBlock(NO , responseObject[@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        successBlock(NO,@"");
    }];
}

#pragma mark 显示控制

+(void)requestToGetShowControlWithCompleteBlock:(void(^)(BOOL,NSDictionary *))successBlock{
    NSDictionary *dic = [NSDictionary dictionary];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/user/sys/display",HTTP_IP];
    
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([DataUsedEngine nullTrim:dictionary[@"code"]] && [dictionary[@"code"] integerValue] == 200) {
            if ([DataUsedEngine nullTrim:dictionary[@"data"]]) {
                successBlock(YES,dictionary[@"data"]);
            }
            else{
                successBlock(NO,nil);
            }
        }
        else{
            successBlock(NO,nil);
        }
    } failureBlock:^(NSError *error) {
        /**
         *  异常失败，再次获取
         *
         *  @param dictionary
         *
         *  @return
         */
        [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
            if ([DataUsedEngine nullTrim:dictionary[@"code"]] && [dictionary[@"code"] integerValue] == 200) {
                if ([DataUsedEngine nullTrim:dictionary[@"data"]]) {
                    successBlock(YES,dictionary[@"data"]);
                }
                else{
                    successBlock(NO,nil);
                }
            }
            else{
                successBlock(NO,nil);
            }
        } failureBlock:^(NSError *error) {
        }];
    }];
}

+(void)requestToDownloadEnvironmentFile{
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/Documents/cainiudomain.txt",NSHomeDirectory()]]) {
        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/Documents/cainiudomain.txt",NSHomeDirectory()] error:nil];
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager             = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL              = [NSURL URLWithString:[NSString stringWithFormat:@"%@",App_aliyunDomainAddress]];
    
    NSURLRequest *request   = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask  = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *documentsDirectoryURL        = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSString    *str            = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/cainiudomain.txt",NSHomeDirectory()] encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *environmentDic = [DataUsedEngine toJsonObjectWithJsonString:str];
        /**
         *  环境存储
         */
        NSString    *HTTP_IP_ONLINE = environmentDic[@"HTTP_IP_ONLINE"];
        NSString    *HTTP_IP_TEST   = environmentDic[@"HTTP_IP_TEST"];
        NSString    *HTTP_IP_SIMULATE   = environmentDic[@"HTTP_IP_SIMULATE"];
        
        if (HTTP_IP_ONLINE != nil) {
            [[EnvironmentConfiger sharedInstance] setHTTP_IP_ONLINE:HTTP_IP_ONLINE];
        }
        
        if (HTTP_IP_TEST != nil) {
            [[EnvironmentConfiger sharedInstance] setHTTP_IP_TEST:HTTP_IP_TEST];
        }
        
        if (HTTP_IP_SIMULATE != nil) {
            [[EnvironmentConfiger sharedInstance] setHTTP_IP_SIMULATE:HTTP_IP_SIMULATE];
        }
        
        [[EnvironmentConfiger sharedInstance] setCurrentSection];
        /**
         *  3个环境存入缓存
         */
        [CacheEngine setEnvironmentHTTP_IP];
        /**
         *  下载出错
         */
        if (error != nil) {
            
        }
    }];
    [downloadTask resume];
}

+(void)requestToGetBankCardList:(void(^)(NSMutableArray *,NSMutableArray *))successBlock{
    NSDictionary *paramDic = [NSDictionary dictionary];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/user/bank/selectAll",HTTP_IP];
    
    [NetRequest postRequestWithNSDictionary:paramDic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([DataUsedEngine nullTrim:dictionary]) {
            if ([DataUsedEngine nullTrim:dictionary[@"code"]] || [dictionary[@"code"] intValue] == 200) {
                NSMutableArray *bankNameArray = [NSMutableArray arrayWithCapacity:0];
                NSMutableArray *imageAddArray = [NSMutableArray arrayWithCapacity:0];
                
                for (int i = 0; i < [dictionary[@"data"] count]; i++) {
                    if ([DataUsedEngine nullTrim:dictionary[@"data"][i][@"bankName"]]) {
                        [bankNameArray addObject:dictionary[@"data"][i][@"bankName"]];
                    }
                    else{
                        [bankNameArray addObject:@""];
                    }
                    
                    if ([DataUsedEngine nullTrim:dictionary[@"data"][i][@"imgAddr"]]) {
                        [imageAddArray addObject:dictionary[@"data"][i][@"imgAddr"]];
                    }
                    else{
                        [imageAddArray addObject:@""];
                    }
                }
                successBlock(bankNameArray,imageAddArray);
            }
            else{
                successBlock(nil,nil);
            }
        }
        else{
            successBlock(nil,nil);
        }
    } failureBlock:^(NSError *error) {
        successBlock(nil,nil);
    }];
}

@end
