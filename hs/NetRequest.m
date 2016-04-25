//
//  NetRequest.m
//  hs
//
//  Created by PXJ on 15/4/24.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import "NetRequest.h"
#import "AFNetworking.h"
#import "LoginViewController.h"

#define HTTP_CONTENT_BOUNDARY @"WANPUSH"
#define TokenChangeTime @"TokenChangeTime"

@implementation NetRequest

+ (void)postRequestWithNSDictionary:(NSDictionary *)dic url:(NSString*)url successBlock:(void(^)(NSDictionary *dictionary))successBlock failureBlock:(void(^)(NSError *error))failureBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        //token过期
        if ([responseObject isKindOfClass:[NSMutableDictionary class]]) {
            
            if ([responseObject[@"code"] floatValue] == 41022) {
                [[UIEngine sharedInstance] hideProgress];
                
                BOOL  isAgain = NO;
                //存入token过期时间
                NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];
                if ([userDefaults objectForKey:TokenChangeTime] == nil) {
                    [userDefaults setObject:[NSNumber numberWithLongLong:[SystemSingleton sharedInstance].timeInterval] forKey:TokenChangeTime];
                    [userDefaults synchronize];
                    isAgain = YES;
                }
                //比对跑秒是否需要提示去登录
                if ([[userDefaults objectForKey:TokenChangeTime] longLongValue] +20*1000 <= [SystemSingleton sharedInstance].timeInterval) {
                    [userDefaults setObject:[NSNumber numberWithLongLong:[SystemSingleton sharedInstance].timeInterval] forKey:TokenChangeTime];
                    [userDefaults synchronize];
                    isAgain = YES;
                }
                
                if (!isAgain) {
                    return ;
                }
                if (![[CMStoreManager sharedInstance] isLogin]) {
                    return;
                }
                NSString    *firstLoginStr = getUserDefaults(@"FirstLogin");
                [[CMStoreManager sharedInstance] exitLoginClearUserData];
                [[CMStoreManager sharedInstance] setbackgroundimage];
                saveUserDefaults(firstLoginStr, @"FirstLogin");
                
                [[UIEngine sharedInstance] showAlertWithTitle:@"您已在其他设备登录，请确认" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
                [UIEngine sharedInstance].alertClick = ^ (int aIndex){
                    [[NSNotificationCenter defaultCenter] postNotificationName:uFirstOpenClearLoginInfo object:nil];
                };
                return ;
            }
            else if ([responseObject[@"code"] floatValue] == 412){
                //                [[UIEngine sharedInstance] showAlertWithTitle:SpotLoginMessage ButtonNumber:2 FirstButtonTitle:@"取消" SecondButtonTitle:@"去开户"];
                //                [UIEngine sharedInstance].alertClick = ^ (int aIndex){
                //                    if (aIndex == 10087) {
                //                        [[NSNotificationCenter defaultCenter] postNotificationName:uSpotgoodsLogin object:nil];
                //                    }
                //                };
                //                return;
            }
        }
        
        successBlock(responseObject);
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",url);
        failureBlock(error);
        //        [UIEngine showShadowPrompt:@"！您当前网络不佳，请稍后再试"];
        [[UIEngine sharedInstance] hideProgress];
    }];
}

/**上传用户头像*/
+(void)postUpdateDataWithDictionary:(NSDictionary*)dic dataDetailDic:(NSDictionary*)detailDic url:(NSString * )url  imageData:(NSData*)data successBlock:(void(^)(NSDictionary *dictionary))successBlock failureBlock:(void(^)(NSError *error))failureBlock
{
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        BOOL datayes = [formData appendPartWithFileURL:[NSURL fileURLWithPath:detailDic[@"fileName"]] name:detailDic[@"name"] fileName:detailDic[@"fileName"] mimeType:@"image/jpeg" error:nil];
        if (datayes == YES) {
            NSLog(@"上传中");
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error);
    }];
    
}
@end
