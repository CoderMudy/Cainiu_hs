

#import "CMStoreManager.h"



#define KeyFoyerPageStatus          @"FoyerPageStatus"
#define KeyUmengCode                @"UmengCode"
#define KeyEnvironment              @"Environment"
#define KeychainSerivceName         @"com.caimoo.app_servicename"
#define KeychainKeyUserName         @"KeychainKeyUserName"
#define KeychainKeyPassWord         @"KeychainKeyPassWord"
#define KeychainKeyUserSession      @"KeychainKeyUserSession"
#define KeychainKeyDeviceToken      @"KeychainKeyDeviceToken"
#define KeychainKeyReadedNoticeID        @"KeychainKeyReadedNoticeID"
#define KeychainKeyReadedPersonID        @"KeychainKeyReadedPersonID"


#define AutoLoginKey                @"AutoLoginKey"
#define UUID                        @"UUIDStr"

#define AccountBalance              @"AccountBalance"
#define AccountPresent              @"AccountPresent"
#define AccountScore                @"AccountScore"
#define UserToken                   @"UserToken"
#define UserTokenSecret             @"UserTokenSecret"

#define UserHeader                  @"UserHeader"
#define UserNick                    @"UserNick"
#define UserSign                    @"UserSign"
#define userIsStaff                 @"UserIsStaff"

#define userAccountScore            @"UserAccountScore"
#define userAccountCainiu           @"UserAccountCainiu"
#define userAccountNanJS            @"UserAccountNanJS"

#define userAccountScoreDetail            @"ScoreAccountDetail"
#define userAccountCainiuDetail           @"CainiuAccountDetail"
#define userAccountNanJSDetail            @"NanJSAccountDetail"



@implementation CMStoreManager
{
    NSUserDefaults      *_userDefaults;
}
DEF_SINGLETON(CMStoreManager)

- (id)init {
    self = [super init];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}
//设置大厅股票期货的可售状态
- (void)setFoyerPageStatus:(id)sender
{
    [_userDefaults removeObjectForKey:KeyFoyerPageStatus];
    [_userDefaults synchronize];
    
    [_userDefaults setValue:sender forKey:KeyFoyerPageStatus];
    [_userDefaults synchronize];

}
//获取大厅股票期货的可售状态
- (id)getFoyerPageStatus
{

    return  [_userDefaults objectForKey:KeyFoyerPageStatus];

}







//获取友盟设备号
- (NSString * )getUmCode
{
    return [_userDefaults objectForKey:KeyUmengCode];
}
//设置友盟设备号
- (void)setUmengCode:(NSString*)UmengCode;
{

    [_userDefaults removeObjectForKey:KeyUmengCode];
    [_userDefaults synchronize];
    
    [_userDefaults setValue:UmengCode forKey:KeyUmengCode];
    [_userDefaults synchronize];

}


//获取环境
- (NSString *)getEnvironment
{
    return [_userDefaults objectForKey:KeyEnvironment];
    
}

//设置环境
- (void)setEnvironment:(NSString*)environmentURL
{
    [_userDefaults removeObjectForKey:KeyEnvironment];
    [_userDefaults synchronize];

    [_userDefaults setValue:environmentURL forKey:KeyEnvironment];
    [_userDefaults synchronize];

}

// 是否已经登录
- (BOOL)isLogin {
    NSString *userSession = [self getUserToken];
    if ([userSession length] > 0) {
        return YES;
    }
    
    return NO;
}
// 是否自动登录
- (BOOL)isAutoLogin {
    NSNumber *number = [_userDefaults objectForKey:AutoLoginKey];
    if (number == nil) {
        return NO;
    }
    
    return [number boolValue];
}

// 设置是否自动登录
- (void)setIsAutoLogin:(BOOL)isAutoLogin {
    [_userDefaults setValue:[NSNumber numberWithBool:isAutoLogin] forKey:AutoLoginKey];
}

// 设置UUID
- (void)setUUID
{
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        
        //去除 “-”
    result =[result stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [SFHFKeychainUtils storeUsername:UUID andPassword:result forServiceName:KeychainSerivceName updateExisting:YES error:nil];
}

- (NSString *)getUUID {
     NSString *uuid = [SFHFKeychainUtils getPasswordForUsername:UUID andServiceName:KeychainSerivceName error:nil];
    return uuid;
}

// 登录成功，保存用户名及密码
- (void)storeUserName:(NSString*)userName {
    if (userName == nil) {
        userName = @"";
    }
    [SFHFKeychainUtils storeUsername:KeychainKeyUserName andPassword:userName forServiceName:KeychainSerivceName updateExisting:YES error:nil];
}

// 清除用户名及密码
- (void)deleteUserName {
    [SFHFKeychainUtils deleteItemForUsername:KeychainKeyUserName andServiceName:KeychainSerivceName error:nil];
}

// 保存userSession
- (void)storeUserSession:(NSString*)userSession {
    if (userSession == nil) {
        userSession = @"";
    }
    //userSession = @"269626_b130672003a10c3c64d430d3b57c7569";
    [SFHFKeychainUtils storeUsername:KeychainKeyUserSession andPassword:userSession forServiceName:KeychainSerivceName updateExisting:YES error:nil];
}

// 保存devicetoken
- (void)storeDeviceToken:(NSString *)deviceToken
{
    if (deviceToken == nil) {
        deviceToken = @"";
    }
    [SFHFKeychainUtils storeUsername:KeychainKeyDeviceToken andPassword:deviceToken forServiceName:KeychainSerivceName updateExisting:YES error:nil];
}

// 获取devicetoken
- (NSString *)getDeviceToken
{
    NSString *deviceToken = [SFHFKeychainUtils getPasswordForUsername:KeychainKeyDeviceToken andServiceName:KeychainSerivceName error:nil];
    return deviceToken;
}

// 获取用户名
- (NSString*)getUserName
{
    NSString *username = [SFHFKeychainUtils getPasswordForUsername:KeychainKeyUserName andServiceName:KeychainSerivceName error:nil];
    return username;
}

// 获取登录密码
- (NSString*)getPassWord {
    NSString *pwd = [SFHFKeychainUtils getPasswordForUsername:KeychainKeyPassWord andServiceName:KeychainSerivceName error:nil];
    return pwd;
}

// 获取userSession
- (NSString*)getUserSession {
    NSString *userSession = [SFHFKeychainUtils getPasswordForUsername:KeychainKeyUserSession andServiceName:KeychainSerivceName error:nil];

    return userSession;
}

// 获取账户余额
- (NSString *)getAccountBalance {
    NSString *number = [_userDefaults objectForKey:AccountBalance];
    if (number == nil) {
        return 0;
    }
    
    return number;
}

// 设置账户余额
- (void)setAccountBalance:(NSString *)balance {
    //NSString *balanceStr = [NSString stringWithFormat:@"%lf",balance];
    NSArray *balanceArray = [balance componentsSeparatedByString:@"."];
    NSString *str1 = nil;
    NSString *str2 = nil;
    NSString *str3 = nil;
    if ([balanceArray count]>0) {
        str1 = [balanceArray objectAtIndex:0];
    }

    NSString *resault = nil;
    if ([balanceArray count]>1) {
        NSString *tempstr2 = [balanceArray objectAtIndex:1];
        str2 = [tempstr2 substringToIndex:1];
        str3 = [tempstr2 substringToIndex:2];
        
        if ([str3 intValue]==0) {
            resault = [NSString stringWithFormat:@"%@",str1];
        }else if ([str3 intValue]!=0) {
            if([str3 intValue]==[str2 intValue]*10)
            {
            resault = [NSString stringWithFormat:@"%@.%@",str1,str2];
            }else{
                resault = [NSString stringWithFormat:@"%@.%@",str1,str3];
            }
        }
    }
   // balance = [resault floatValue];
    
    [_userDefaults setValue:resault forKey:AccountBalance];
    [_userDefaults synchronize];
}

// 获取账户冻结金额
- (NSString *)getAccountFreeze {
    NSString *number = [_userDefaults objectForKey:AccountPresent];
    if (number == nil) {
        return 0;
    }
    return number;
}

// 设置账户冻结金额
- (void)setAccountFreeze:(NSString *)freeze {
    [_userDefaults setValue:freeze forKey:AccountPresent];
    [_userDefaults synchronize];
}

// 获取账户积分
- (int)getAccountScore {
    NSNumber *number = [_userDefaults objectForKey:AccountScore];
    if (number == nil) {
        return 0;
    }
    
    return [number intValue];
}

// 设置账户积分
- (void)setAccountScore:(int)score {
    [_userDefaults setValue:[NSNumber numberWithInt:score] forKey:AccountScore];
    [_userDefaults synchronize];
}


// 保存userToken
- (void)storeUserToken:(NSString *)userToken
{
    [_userDefaults setValue:userToken forKey:UserToken];
    [_userDefaults synchronize];
}

// 获取userToken
- (NSString*)getUserToken
{
    NSString *str= [_userDefaults objectForKey:UserToken];
    if (str == nil) {
        return @"";
    }
    
    return str;
}

// 保存userTokenSecret
- (void)storeUserTokenSecret:(NSString *)userTokenSecret
{
    [_userDefaults setValue:userTokenSecret forKey:UserTokenSecret];
    [_userDefaults synchronize];
}

// 获取userTokenSecret
- (NSString*)getUserTokenSecret
{
    NSString *str= [_userDefaults objectForKey:UserTokenSecret];
    if (str == nil) {
        return @"";
    }
    
    return str;
}

#pragma mark - plist文件路径
-(NSString *)get_filename:(NSString *)name
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
            stringByAppendingPathComponent:name];
}

-(BOOL)is_file_exist:(NSString *)name
{
    NSFileManager *file_manager = [NSFileManager defaultManager];
    return [file_manager fileExistsAtPath:[self get_filename:name]];
}

//保存用户昵称
-(void)setUserNick:(NSString *)aNick
{
    if (aNick==nil||[aNick isKindOfClass:[NSNull class]]) {
        aNick=@" ";
    }
    
    [_userDefaults setObject:aNick forKey:UserNick];
    [_userDefaults synchronize];
}
//获取昵称
-(NSString *)getUserNick
{
    return [_userDefaults objectForKey:UserNick];
}
//保存用户头像地址
-(void)setUSerHeaderAddress:(NSString*)headerAddress
{
    if (headerAddress==nil||[headerAddress isKindOfClass:[NSNull class]]) {
        headerAddress=@" ";
    }
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:headerAddress]];
    
    
    [_userDefaults setObject:data forKey:UserHeader];
    [_userDefaults synchronize];
}
//获取头像
-(UIImage*)getUserHeader
{
    UIImage * headerImage = [UIImage imageWithData:[_userDefaults objectForKey:UserHeader]];
    
    if (!headerImage) {
        headerImage = [UIImage imageNamed:@"head_01"];
    }
    return headerImage;
}
//保存用户个性签名
-(void)setUserSign:(NSString *)aSign
{
    if (aSign==nil||[aSign isKindOfClass:[NSNull class]]) {
        aSign=@" ";
    }
    
    [_userDefaults setObject:aSign forKey:UserSign];
    [_userDefaults synchronize];
}
//获取用户个性签名
-(NSString *)getUserSign
{
    NSString * userSign = [_userDefaults objectForKey:UserSign];
    userSign = [userSign stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return userSign;
}

/**存储用户积分账户状态*/
-(void)setAccountScoreStatus:(NSString*)status
{
    if (status==nil||[status isKindOfClass:[NSNull class]]) {
        status = @"0";
    }
    [_userDefaults setObject:status forKey:userAccountScore];
    [_userDefaults synchronize];
}
/**获取用户积分账户状态*/
-(BOOL)getAccountScoreStatus
{
    NSString * scoreStatus = [_userDefaults objectForKey:userAccountScore];
    return scoreStatus.boolValue;
}

/**存储用户财牛账户状态*/
-(void)setAccountCainiuStatus:(NSString*)status
{
    if (status==nil||[status isKindOfClass:[NSNull class]]) {
        status = @"0";
    }
    [_userDefaults setObject:status forKey:userAccountCainiu];
    [_userDefaults synchronize];
}
/**获取用户财牛账户状态*/
-(BOOL)getAccountCainiuStatus
{
    NSString * cainiuStatus = [_userDefaults objectForKey:userAccountCainiu];
    return cainiuStatus.boolValue;
}
/**存储用户南交所账户状态*/
-(void)setAccountNanJSStatus:(NSString*)status
{
    if (status==nil||[status isKindOfClass:[NSNull class]]) {
        status = @"0";
    }
    [_userDefaults setObject:status forKey:userAccountNanJS];
    [_userDefaults synchronize];
}
/**获取用户南交所账户状态*/
-(BOOL)getAccountNanJSStatus
{
    NSString * nanJSStatus = [_userDefaults objectForKey:userAccountNanJS];
    return nanJSStatus.boolValue;
}

/**存储用户积分账户detailDic*/
-(void)setAccountScoreDetailDic:(NSDictionary*)detailDic
{
    if (detailDic==nil||[detailDic isKindOfClass:[NSNull class]]) {
        detailDic = [[NSDictionary alloc] init];
    }

    [_userDefaults setObject:[Helper toJSON:detailDic] forKey:userAccountScoreDetail];
    [_userDefaults synchronize];
}
/**获取用户积分账户detailDic*/
-(NSDictionary *)getAccountScoreDetailDic
{
    NSString * detailStr = [_userDefaults objectForKey:userAccountScoreDetail];
    NSDictionary * detailDic = [Helper dicWithJSonStr:detailStr];
     return detailDic;
}

/**存储用户财牛账户detailDic*/
-(void)setAccountCainiuDetailDic:(NSDictionary*)detailDic
{
    if (detailDic==nil||[detailDic isKindOfClass:[NSNull class]]) {
        detailDic = [[NSDictionary alloc] init];
    }
    [_userDefaults setObject:[Helper toJSON:detailDic] forKey:userAccountCainiuDetail];
    [_userDefaults synchronize];
}
/**获取用户财牛账户detailDic*/
-(NSDictionary *)getAccountCainiuDetailDic
{
   NSString * detailStr= [_userDefaults objectForKey:userAccountCainiuDetail];
    NSDictionary * detailDic = [Helper dicWithJSonStr:detailStr];

    return detailDic;
}
/**存储用户南交所账户detailDic*/
-(void)setAccountNanJSDetailDic:(NSDictionary*)detailDic
{
    if (detailDic==nil||[detailDic isKindOfClass:[NSNull class]]) {
        detailDic = [[NSDictionary alloc] init];
    }
    [_userDefaults setObject:[Helper toJSON:detailDic] forKey:userAccountNanJSDetail];
    [_userDefaults synchronize];
}
/**获取用户南交所账户detailDic*/
-(NSDictionary *)getAccountNanJSDetailDic
{
    NSString * detailStr = [_userDefaults objectForKey:userAccountNanJSDetail];
    NSDictionary * detailDic = [Helper dicWithJSonStr:detailStr];

    return detailDic;
}
//保存用户管理权限
-(void)setuseIsStaff:(int)isStaff
{
    NSString * staff = [NSString stringWithFormat:@"%d",isStaff];
    if (staff==nil||[staff isKindOfClass:[NSNull class]]) {
        staff=@"0";
    }
    
    [_userDefaults setObject:staff forKey:userIsStaff];
    [_userDefaults synchronize];
}
//获取用户管理权限
-(NSString *)getUserIsStaff
{
    NSString * isStaff =  [_userDefaults objectForKey:userIsStaff];
    return isStaff;

}
//获取背景图片
-(NSData*)getbackgroundImage:(NSString*)imageName
{
    return [_userDefaults objectForKey:imageName];

}



//设置背景图片
-(void)setbackgroundimage
{
    
    NSData * backNav5 = UIImagePNGRepresentation([UIImage imageNamed:@"background_nav_05"]);
    NSData * backNav6 = UIImagePNGRepresentation([UIImage imageNamed:@"background_nav_06"]);
    NSData * backNav7 = UIImagePNGRepresentation([UIImage imageNamed:@"background_nav_07"]);
    NSData * backHeader5 = UIImagePNGRepresentation([UIImage imageNamed:@"background_header_05"]);
    NSData * backHeader6 = UIImagePNGRepresentation([UIImage imageNamed:@"background_header_06"]);
    NSData * backHeader7 = UIImagePNGRepresentation([UIImage imageNamed:@"background_header_07"]);
    

    [_userDefaults setObject:backNav5 forKey:@"background_nav_05"];
    [_userDefaults synchronize];

    [_userDefaults setObject:backNav6 forKey:@"background_nav_06"];
    [_userDefaults synchronize];

    [_userDefaults setObject:backNav7 forKey:@"background_nav_07"];
    [_userDefaults synchronize];

    [_userDefaults setObject:backHeader5 forKey:@"background_header_05"];
    [_userDefaults synchronize];

    [_userDefaults setObject:backHeader6 forKey:@"background_header_06"];
    [_userDefaults synchronize];

    [_userDefaults setObject:backHeader7 forKey:@"background_header_07"];
    [_userDefaults synchronize];




}

- (void)exitLoginClearUserData
{
    [_userDefaults removeObjectForKey:userIsStaff];
    [_userDefaults removeObjectForKey:KeychainKeyUserName];
    [_userDefaults removeObjectForKey:KeychainKeyPassWord];
    [_userDefaults removeObjectForKey:KeychainKeyUserSession];
    [_userDefaults removeObjectForKey:AccountBalance];
    [_userDefaults removeObjectForKey:AccountPresent];
    [_userDefaults removeObjectForKey:AccountScore];
    [_userDefaults removeObjectForKey:UserToken];
    [_userDefaults removeObjectForKey:UserTokenSecret];
    [_userDefaults removeObjectForKey:UserSign];

    [_userDefaults synchronize];

}

@end
