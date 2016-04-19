//
//  DataEngine+SpotGoods.m
//  hs
//
//  Created by RGZ on 15/11/30.
//  Copyright © 2015年 luckin. All rights reserved.
//
#import "DataEngine+SpotGoods.h"
#import "NetRequest.h"
#import "NSString+MD5.h"
#import "SpotgoodsModel.h"
#import "NSString+Base64.h"
@implementation DataEngine(SpotGoods)

+(void)requestSpotgoodsLoginWithUsername:(NSString *)aUsername Password:(NSString *)aPassword{
    NSDictionary *dic = @{
                          @"cainiuToken":[[CMStoreManager sharedInstance] getUserToken],
                          @"traderId":aUsername,//交易商编号
//                          @"tradePass":[NSString encodeBase64String:@"111111"],//交易密码
                          @"tradePass":aPassword,
                          @"ipAddress":HTTP_IP,
                          };
    NSString    *url = [NSString stringWithFormat:@"http://%@/cots/cots/tradeLogin",HTTP_IP];
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if (dictionary != nil && [dictionary[@"code"] intValue] == 200) {
            SpotgoodsModel *spotgoodsModel = [[SpotgoodsModel alloc]init];
            if (dictionary[@"data"] != nil && dictionary[@"data"][@"DATAS"] != nil) {
                spotgoodsModel.member           = dictionary[@"data"][@"DATAS"][0][@"MEMBER"];
                spotgoodsModel.cjstradeate      = dictionary[@"data"][@"DATAS"][0][@"CJSTRADEATE"];
                spotgoodsModel.cjstradesta      = dictionary[@"data"][@"DATAS"][0][@"CJSTRADESTA"];
                spotgoodsModel.countdate        = dictionary[@"data"][@"DATAS"][0][@"COUNTDATE"];
                spotgoodsModel.sysDate          = dictionary[@"data"][@"DATAS"][0][@"SYSDATE"];
                spotgoodsModel.scursysdate      = dictionary[@"data"][@"DATAS"][0][@"SCURSYSDATE"];
                spotgoodsModel.csetprotocol     = dictionary[@"data"][@"DATAS"][0][@"CSETPROTOCOL"];
                spotgoodsModel.sysTime          = dictionary[@"data"][@"DATAS"][0][@"SYSTIME"];
            }
            spotgoodsModel.adapter          = dictionary[@"data"][@"ADAPTER"];
            spotgoodsModel.spotgoodsToken   = dictionary[@"data"][@"TOKEN"];
            spotgoodsModel.httpToken        = dictionary[@"data"][@"HTTPTOKEN"];
            spotgoodsModel.msg              = dictionary[@"data"][@"MSG"];
            spotgoodsModel.state            = dictionary[@"data"][@"STATE"];
            spotgoodsModel.password         = aPassword;
            [SpotgoodsAccount sharedInstance].spotgoodsModel = spotgoodsModel;
            NSLog(@"南交所登录成功");
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"南交所登录失败");
    }];
    
}

+(void)requestDeCodeTest{
//    MTExMTEx
    NSDictionary *dic = @{
                          @"serect":@"MTExMTEx",
                          };
    NSString    *url = [NSString stringWithFormat:@"http://%@/cots/serect/decryptSerect",HTTP_IP];
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
    } failureBlock:^(NSError *error) {
        
    }];
}

@end
