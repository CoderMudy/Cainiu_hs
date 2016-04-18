//
//  CacheEngine.m
//  hs
//
//  Created by RGZ on 15/6/23.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "CacheEngine.h"
#import "News.h"

#define uCacheModel     [NSString stringWithFormat:@"Cache%@",[[CMStoreManager sharedInstance] getUserTokenSecret]]
#define FilePath        [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Cache/CacheInfo.plist"]]
#define FirstInfoPath  [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Cache/FirstInfos.plist"]]
#define GestureInfoPath    [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Cache/GestureInfo.plist"]]
#define MarkStatusPath   [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Cache/MarkStatus.plist"]]
#define LoginFilePath   [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Cache/loginFilePath.plist"]]
#define EnvironmentFilePath   [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Cache/environmentFilePath.plist"]]
#define NewsInfoFilePath   [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Cache/newsInfoFilePath.plist"]]



#define OpenGesKey    [NSString stringWithFormat:@"ISOPENGESKEY%@",[[CMStoreManager sharedInstance] getUserTokenSecret]]
#define SetGesKey     [NSString stringWithFormat:@"ISSETGESKEY%@",[[CMStoreManager sharedInstance] getUserTokenSecret]]

#define HttpToken       @"http_token"
#define SpotToken       @"spot_token"
#define SpotTradeID     @"spot_tradeID"
#define Password        @"pass_word"

@implementation CacheEngine

#pragma mark 获取缓存信息

+(CacheModel *)getCacheInfo{
    
    
    
    NSFileManager   *fileManager = [[NSFileManager alloc]init];
    
    if ([fileManager fileExistsAtPath:FilePath]) {
        
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithContentsOfFile:FilePath];
        
        CacheModel *cacheModel = [NSKeyedUnarchiver unarchiveObjectWithData:infoDic[uCacheModel]];
        
        if (cacheModel == nil) {
            cacheModel = [[CacheModel alloc]init];
            
            NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithContentsOfFile:FilePath];
            
            [infoDic setObject:[NSKeyedArchiver archivedDataWithRootObject:cacheModel] forKey:uCacheModel];
            
        }
        
        return cacheModel;
    }
    else{
        CacheModel *cacheModel = [[CacheModel alloc]init];
        
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithContentsOfFile:FilePath];
        
        [infoDic setObject:[NSKeyedArchiver archivedDataWithRootObject:cacheModel] forKey:uCacheModel];
        
        return cacheModel;
    }
    
}

#pragma mark 存储缓存信息

+(void)setCacheInfo:(CacheModel *)aCacheModel{
    if (aCacheModel != nil) {
        
        NSFileManager   *fileManager = [[NSFileManager alloc]init];
        
        if ([fileManager fileExistsAtPath:FilePath]) {
            
            NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithContentsOfFile:FilePath];
            
            NSData *infoData = [NSKeyedArchiver archivedDataWithRootObject:aCacheModel];
            
            [infoDic setObject:infoData forKey:uCacheModel];
            
            [infoDic writeToFile:FilePath atomically:YES];
            
        }else{
            NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithCapacity:0];
            
            NSData *infoData = [NSKeyedArchiver archivedDataWithRootObject:aCacheModel];
            
            [newDic setValue:infoData forKey:uCacheModel];
            
            [newDic writeToFile:FilePath atomically:YES];
        }
    }else{
        //        NSLog(@"放入缓存失败");
    }
}

+(void)setCacheInfo:(CacheModel *)aCacheModel Key:(NSString *)aKeyName{
    
    if (aCacheModel != nil) {
        
        NSFileManager   *fileManager = [[NSFileManager alloc]init];
        
        if ([fileManager fileExistsAtPath:FilePath]) {
            
            NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithContentsOfFile:FilePath];
            
            NSData *infoData = [NSKeyedArchiver archivedDataWithRootObject:aCacheModel];
            
            [infoDic setValue:infoData forKey:[NSString stringWithFormat:@"Cache%@",aKeyName]];
            
            [infoDic writeToFile:FilePath atomically:YES];
            
        }else{
            NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithCapacity:0];
            
            NSData *infoData = [NSKeyedArchiver archivedDataWithRootObject:aCacheModel];
            
            [newDic setValue:infoData forKey:[NSString stringWithFormat:@"Cache%@",aKeyName]];
            
            [newDic writeToFile:FilePath atomically:YES];
        }
    }else{
        //        NSLog(@"放入缓存失败");
    }
}

#pragma mark 清空缓存(删除所有缓存)

+(void)clearCache{
    NSFileManager   *fileManager = [[NSFileManager alloc]init];
    
    if ([fileManager fileExistsAtPath:FilePath]) {
        
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [infoDic writeToFile:FilePath atomically:YES];
    }
}

//欢迎页专用
+(void)firstInfo{
    if ([CacheEngine isFirstInfo]) {
        NSFileManager   *fileManager = [[NSFileManager alloc]init];
        if ([fileManager fileExistsAtPath:FirstInfoPath]) {
            NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithContentsOfFile:FirstInfoPath];
            [infoDic setObject:@"FirstInfo" forKey:@"FirstInfos"];
            [infoDic writeToFile:FirstInfoPath atomically:YES];
            
        }
        else{
            NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithCapacity:0];
            [infoDic setObject:@"FirstInfo" forKey:@"FirstInfos"];
            [infoDic writeToFile:FirstInfoPath atomically:YES];
        }
    }
}

+(BOOL)isFirstInfo{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:FirstInfoPath];
    
    if (dic[@"FirstInfos"] !=nil && ![dic[@"FirstInfos"] isEqualToString:@""]) {
        return NO;
    }
    else{
        return YES;
    }
}

//////////////

//交易规则"？"闪动处理
+(void)tradeRulsShow{
    if ([CacheEngine isShowTradeRules]) {
        NSFileManager   *fileManager = [[NSFileManager alloc]init];
        if ([fileManager fileExistsAtPath:FirstInfoPath]) {
            NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithContentsOfFile:FirstInfoPath];
            [infoDic setObject:@"ShowTradeRules" forKey:@"ShowTradeRules"];
            [infoDic writeToFile:FirstInfoPath atomically:YES];
            
        }
        else{
            NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithCapacity:0];
            [infoDic setObject:@"ShowTradeRules" forKey:@"ShowTradeRules"];
            [infoDic writeToFile:FirstInfoPath atomically:YES];
        }
    }
}

+(BOOL)isShowTradeRules{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:FirstInfoPath];
    
    if (dic[@"ShowTradeRules"] !=nil && ![dic[@"ShowTradeRules"] isEqualToString:@""]) {
        return NO;
    }
    else{
        return YES;
    }
}

//手势密码专用
//手势密码是否打开
//0：未打开 1：已打开
+(void)setOpenGes:(BOOL)isOpenGes{
    NSFileManager   *fileManager = [[NSFileManager alloc]init];
    
    NSString *state = @"";
    
    if (isOpenGes) {
        state = @"1";
    }
    else{
        state = @"0";
    }
    
    if ([fileManager fileExistsAtPath:GestureInfoPath]) {
        
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithContentsOfFile:GestureInfoPath];
        
        [infoDic setObject:state forKey:OpenGesKey];
        
        [infoDic writeToFile:GestureInfoPath atomically:YES];
        
    }
    else{
        
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [infoDic setObject:state forKey:OpenGesKey];
        
        [infoDic writeToFile:GestureInfoPath atomically:YES];
        
        
    }
    
}

+(BOOL)isOpenGes{
    
    NSFileManager   *fileManager = [[NSFileManager alloc]init];
    
    if ([fileManager fileExistsAtPath:GestureInfoPath]) {
        
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithContentsOfFile:GestureInfoPath];
        
        NSString *state = infoDic[OpenGesKey];
        
        if ([state isEqualToString:@"1"]) {
            return YES;
        }
        else if([state isEqualToString:@"0"]){
            return NO;
        }
        
        return NO;
    }
    else{
        return NO;
    }
}

//手势密码是否设置
//0:未设置  1:已设置
+(void)setGesPwd:(NSString *)aPwd{
    NSFileManager   *fileManager = [[NSFileManager alloc]init];
    
    if ([fileManager fileExistsAtPath:GestureInfoPath]) {
        
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithContentsOfFile:GestureInfoPath];
        
        [infoDic setObject:aPwd forKey:SetGesKey];
        
        [infoDic writeToFile:GestureInfoPath atomically:YES];
        
    }
    else{
        
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [infoDic setObject:aPwd forKey:SetGesKey];
        
        [infoDic writeToFile:GestureInfoPath atomically:YES];
        
        
    }
}

+(NSString *)getGesPwd{
    NSFileManager   *fileManager = [[NSFileManager alloc]init];
    
    if ([fileManager fileExistsAtPath:GestureInfoPath]) {
        
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithContentsOfFile:GestureInfoPath];
        
        NSString *state = infoDic[SetGesKey];
        
        return state;
    }
    else{
        return @"";
    }
}

+(BOOL)isSetPwd{
    NSString * pwd = [CacheEngine getGesPwd];
    
    if (pwd == nil) {
        pwd = @"";
    }
    
    if (pwd.length>0) {
        return YES;
    }
    else{
        return NO;
    }
}

//end************


#pragma mark 市场状态专用

+(void)setMarketStatus:(NSMutableDictionary *)aDic{
    
    NSMutableDictionary * infoDic = [NSMutableDictionary dictionaryWithDictionary:aDic];
    
    [infoDic writeToFile:MarkStatusPath atomically:YES];
}

+(NSMutableDictionary *)getMarketStatus{
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    
    NSMutableDictionary *infoDic = nil;
    
    if ([fileManager fileExistsAtPath:MarkStatusPath]) {
        
        infoDic = [NSMutableDictionary dictionaryWithContentsOfFile:MarkStatusPath];
        
    }
    
    return infoDic;
}


#pragma mark 系统判断（QQ、微信登录）


#define LoginKey @"LoginKey"
+(void)setLoginStatus:(NSString *)aStr{
    
    NSMutableDictionary * infoDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [infoDic setObject:aStr forKey:LoginKey];
    [infoDic writeToFile:LoginFilePath atomically:YES];
}

+(NSString *)getLoginStatus{
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    
    NSMutableDictionary *infoDic = nil;
    
    if ([fileManager fileExistsAtPath:LoginFilePath]) {
        
        infoDic = [NSMutableDictionary dictionaryWithContentsOfFile:LoginFilePath];
        
    }
    
    NSString *result = infoDic[LoginKey];
    
    if (result == nil || result.length == 0) {
        result = @"1";
    }
    return result;
}

#pragma mark 环境存储
//环境存储
#define EnvironmentHTTP_IP_ONLINE @"EnvironmentHTTP_IP_ONLINE"
#define EnvironmentHTTP_IP_TEST @"EnvironmentHTTP_IP_TEST"
#define EnvironmentHTTP_IP_SIMULATE @"EnvironmentHTTP_IP_SIMULATE"
+(void)setEnvironmentHTTP_IP{
    NSMutableDictionary * infoDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [infoDic setObject:[EnvironmentConfiger sharedInstance].HTTP_IP_ONLINE forKey:EnvironmentHTTP_IP_ONLINE];
    [infoDic setObject:[EnvironmentConfiger sharedInstance].HTTP_IP_TEST forKey:EnvironmentHTTP_IP_TEST];
    [infoDic setObject:[EnvironmentConfiger sharedInstance].HTTP_IP_SIMULATE forKey:EnvironmentHTTP_IP_SIMULATE];
    [infoDic writeToFile:EnvironmentFilePath atomically:YES];
}

+(NSString *)getEnvironmentHTTP_IP_ONLINE{
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSMutableDictionary *infoDic = nil;
    if ([fileManager fileExistsAtPath:EnvironmentFilePath]) {
        infoDic = [NSMutableDictionary dictionaryWithContentsOfFile:EnvironmentFilePath];
    }
    else{
        return nil;
    }
    
    NSString *result = infoDic[EnvironmentHTTP_IP_ONLINE];
    
    return result;
}
+(NSString *)getEnvironmentHTTP_IP_TEST{
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSMutableDictionary *infoDic = nil;
    if ([fileManager fileExistsAtPath:EnvironmentFilePath]) {
        infoDic = [NSMutableDictionary dictionaryWithContentsOfFile:EnvironmentFilePath];
    }
    else{
        return nil;
    }
    
    NSString *result = infoDic[EnvironmentHTTP_IP_TEST];
    
    return result;
}

+(NSString *)getEnvironmentHTTP_IP_SIMULATE{
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSMutableDictionary *infoDic = nil;
    if ([fileManager fileExistsAtPath:EnvironmentFilePath]) {
        infoDic = [NSMutableDictionary dictionaryWithContentsOfFile:EnvironmentFilePath];
    }
    else{
        return nil;
    }
    
    NSString *result = infoDic[EnvironmentHTTP_IP_SIMULATE];
    
    return result;
}

#pragma mark 南交所信息

+(NSString *)getSpotgoodsInfoToken{
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    return cacheModel.spotgoodsInfo[SpotToken];
}

+(NSString *)getSpotgoodsHttpToken{
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    return cacheModel.spotgoodsInfo[HttpToken];
}

+(NSString *)getSpotgoodsInfoUsername{
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    return cacheModel.spotgoodsInfo[SpotTradeID];
}

+(NSString *)getSpotgoodsInfoPassword{
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    return cacheModel.spotgoodsInfo[Password];
}

+(void)setSpotgoodsInfoTradeID:(NSString *)aTradeID Token:(NSString *)aToken HTTPToken:(NSString *)aHttpToken PassWord:(NSString *)aPassword{
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    if (cacheModel.spotgoodsInfo == nil) {
        cacheModel.spotgoodsInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    if (aTradeID != nil && ![aTradeID isEqualToString:@""]) {
        [cacheModel.spotgoodsInfo setValue:aTradeID forKey:SpotTradeID];
    }
    if (aToken != nil) {
        [cacheModel.spotgoodsInfo setValue:aToken forKey:SpotToken];
    }
    if (aHttpToken != nil) {
        [cacheModel.spotgoodsInfo setValue:aHttpToken forKey:HttpToken];
    }
    if (aPassword != nil && ![aPassword isEqualToString:@""]) {
        [cacheModel.spotgoodsInfo setValue:aPassword forKey:Password];
    }
    [CacheEngine setCacheInfo:cacheModel];
}

+(void)clearSpotgoodsInfo{
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    if (cacheModel.spotgoodsInfo == nil) {
        cacheModel.spotgoodsInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [cacheModel.spotgoodsInfo setValue:@"" forKey:SpotTradeID];
        [cacheModel.spotgoodsInfo setValue:@"" forKey:SpotToken];
        [cacheModel.spotgoodsInfo setValue:@"" forKey:HttpToken];
        [cacheModel.spotgoodsInfo setValue:@"" forKey:Password];
    }
    [CacheEngine setCacheInfo:cacheModel];
}
#pragma mark 资讯首页缓存 老版方法更新时要删除
#define NewsInfoKey @"NewsInfoKey"
+(NSMutableArray *)getInfoWithNews{
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSMutableArray *infoArray = [NSMutableArray arrayWithCapacity:0];
    if ([fileManager fileExistsAtPath:NewsInfoFilePath]) {
        NSMutableArray *tmpArray = [NSMutableArray arrayWithContentsOfFile:NewsInfoFilePath];
        for (int i = 0; i < tmpArray.count; i++) {
            News *news = [NSKeyedUnarchiver unarchiveObjectWithData:tmpArray[i]];
            [infoArray addObject:news];
        }
    }
    return infoArray;
}

#pragma mark 资讯首页新闻缓存
+(NSMutableArray *)getNewsInfoWithNews{
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSMutableArray *infoArray = [NSMutableArray arrayWithCapacity:0];
    if ([fileManager fileExistsAtPath:NewsInfoFilePath]) {
        NSMutableArray *tmpArray = [NSMutableArray arrayWithContentsOfFile:NewsInfoFilePath];
        for (int i = 0; i < tmpArray.count; i++) {
            News *news = [NSKeyedUnarchiver unarchiveObjectWithData:tmpArray[i]];
            [infoArray addObject:news];
        }
    }
    return infoArray;
}

+(void)setNewsInfoWithCache:(NSMutableArray *)aNewsArray{
    if (aNewsArray != nil) {
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < aNewsArray.count; i++) {
            News *news = aNewsArray[i];
            [tmpArray addObject:[NSKeyedArchiver archivedDataWithRootObject:news]];
        }
        
        NSFileManager *fileManager = [[NSFileManager alloc]init];
        if ([fileManager fileExistsAtPath:NewsInfoFilePath]) {
            
            [tmpArray writeToFile:NewsInfoFilePath atomically:YES];
        }
        else{
            
            [fileManager createFileAtPath:NewsInfoFilePath contents:nil attributes:nil];
            
            [tmpArray writeToFile:NewsInfoFilePath atomically:YES];
        }
    }
}
#pragma mark 纪录读过的新闻
#define NewsReadIDFilePath   [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Cache/newsReadIDFilePath.plist"]]
+(void)setNewsReadedID:(NSMutableArray *)newsIDArray;
{
    NSMutableArray * readIDArray = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<newsIDArray.count; i++)
    {
        NSString * readId = newsIDArray[i];
        [readIDArray addObject:[NSKeyedArchiver archivedDataWithRootObject:readId]];
    }
    NSFileManager * fileManager = [NSFileManager  defaultManager];
    if (![fileManager fileExistsAtPath:NewsReadIDFilePath])
    {
        [fileManager createFileAtPath:NewsReadIDFilePath contents:nil attributes:nil];
    }
    [readIDArray writeToFile:NewsReadIDFilePath atomically:YES];

}
+ (NSMutableArray *)getNewsReadedID
{

    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSMutableArray * infoArray = [NSMutableArray arrayWithCapacity:0];
    if ([fileManager fileExistsAtPath:NewsReadIDFilePath]) {
        NSMutableArray * readNewsIdArray = [NSMutableArray arrayWithContentsOfFile:NewsReadIDFilePath];
        for (int i=0; i<readNewsIdArray.count; i++) {
            NSString * newId = [NSKeyedUnarchiver unarchiveObjectWithData:readNewsIdArray[i]];
            [infoArray addObject:newId];
        }
    }
    return infoArray;
}

#pragma mark 资讯首页策略缓存
#define TacticFilePath   [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Cache/tacticFilePath.plist"]]

+(NSMutableArray *)getTacticInfoWithTactic{
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSMutableArray *infoArray = [NSMutableArray arrayWithCapacity:0];
    if ([fileManager fileExistsAtPath:TacticFilePath]) {
        NSMutableArray *tmpArray = [NSMutableArray arrayWithContentsOfFile:TacticFilePath];
        for (int i = 0; i < tmpArray.count; i++) {
            News *news = [NSKeyedUnarchiver unarchiveObjectWithData:tmpArray[i]];
            [infoArray addObject:news];
        }
    }
    return infoArray;
}

+(void)setTacticInfoWithCache:(NSMutableArray *)aTacticArray{
    if (aTacticArray != nil) {
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < aTacticArray.count; i++) {
            News *news = aTacticArray[i];
            [tmpArray addObject:[NSKeyedArchiver archivedDataWithRootObject:news]];
        }
        
        NSFileManager *fileManager = [[NSFileManager alloc]init];
        if ([fileManager fileExistsAtPath:TacticFilePath]) {
            [tmpArray writeToFile:TacticFilePath atomically:YES];
        }
        else{
            
            [fileManager createFileAtPath:TacticFilePath contents:nil attributes:nil];
            [tmpArray writeToFile:TacticFilePath atomically:YES];
        }
    }
}
#pragma mark 资讯详情图片缓存
#define NewsInfoDetailImagePath   [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Cache/NewInfoDetailImage.plist"]]

+(NSMutableDictionary *)getNewsDetailImage{
    NSFileManager * fileManager = [[NSFileManager alloc] init];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    if ([fileManager fileExistsAtPath:NewsInfoDetailImagePath]) {
        NSMutableDictionary * detailDic = [NSMutableDictionary dictionaryWithContentsOfFile:NewsInfoDetailImagePath];
        dic = detailDic;
    }
    return dic;
}
+(void)setNewInfoDetailImageDetail:(NSMutableDictionary *)detailDic
{
    if (detailDic != nil) {
//        
//        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
//        for (int i = 0; i < imageArray.count; i++) {
//            NSDictionary * imageDic = imageArray[i];
//            [tmpArray addObject:[NSKeyedArchiver archivedDataWithRootObject:imageDic]];
//        }
        
        NSFileManager *fileManager = [[NSFileManager alloc]init];
        if ([fileManager fileExistsAtPath:NewsInfoDetailImagePath])
        {
            [detailDic writeToFile:NewsInfoDetailImagePath atomically:YES];
        }
        else
        {
            [fileManager createFileAtPath:NewsInfoDetailImagePath contents:nil attributes:nil];
            [detailDic writeToFile:NewsInfoDetailImagePath atomically:YES];
        }
    }
}

@end
