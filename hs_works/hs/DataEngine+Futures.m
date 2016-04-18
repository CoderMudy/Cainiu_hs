//
//  DataEngine+Futures.m
//  hs
//
//  Created by RGZ on 15/11/30.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "DataEngine+Futures.h"
#import "NetRequest.h"
#import "NSString+MD5.h"
#import "TradeConfigerModel.h"

@implementation DataEngine(Futures)

#pragma mark 期货状态查询

+(void)requestToGetFuturesState:(NSString *)aCode completeBlock:(void(^)(BOOL , NSString *))successBlock{
    
    
    NSDictionary * dic = @{@"futureCode":aCode};
    
    NSString * urlStr = [NSString stringWithFormat:@"http://%@/market/market/futuresStatus",HTTP_IP];
    
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            successBlock(YES,[NSString stringWithFormat:@"%d",[dictionary[@"data"][@"status"] intValue]]);
        }
        else{
            successBlock(NO,dictionary[@"msg"]);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO,nil);
    }];
}


#pragma mark 获取操盘配置信息

+(void)requestToGetTraderConfiger:(NSString *)aState completeBlock:(void(^)(BOOL , NSMutableArray *,NSMutableArray *))successBlock{
    
    if (aState == nil) {
        aState = @"";
    }
    
    NSDictionary * dic = @{@"traderType":[aState uppercaseString],
                           @"version":@"0.0.2"
                           };
    
    
    
    NSString * urlStr = [NSString stringWithFormat:@"http://%@/financy/financy/getStockTraderList",HTTP_IP];
    
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            NSMutableArray *moneyArray = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *integralArray = [NSMutableArray arrayWithCapacity:0];
            
            if (dictionary[@"data"] != nil && ![dictionary[@"data"] isKindOfClass:[NSNull class]]) {
                for (int i = 0; i < [dictionary[@"data"] count]; i++) {
                    TradeConfigerModel *tradeModel = [[TradeConfigerModel alloc]init];
                    
                    if (dictionary[@"data"][i][@"financyAllocation"] != nil && ![dictionary[@"data"][i][@"financyAllocation"] isKindOfClass:[NSNull class]]) {
                        tradeModel.financyAllocation = [NSString stringWithFormat:@"%@",dictionary[@"data"][i][@"financyAllocation"]];
                    }
                    else{
                        tradeModel.financyAllocation = @"";
                    }
                    
                    if (dictionary[@"data"][i][@"isEnabled"] != nil && ![dictionary[@"data"][i][@"isEnabled"] isKindOfClass:[NSNull class]]) {
                        tradeModel.isEnabled = [NSString stringWithFormat:@"%@",dictionary[@"data"][i][@"isEnabled"]];
                    }
                    else{
                        tradeModel.isEnabled = @"";
                    }
                    
                    if (dictionary[@"data"][i][@"cashFund"] != nil && ![dictionary[@"data"][i][@"cashFund"] isKindOfClass:[NSNull class]]) {
                        tradeModel.cashFund = [NSString stringWithFormat:@"%@",dictionary[@"data"][i][@"cashFund"]];
                    }
                    else{
                        tradeModel.cashFund = @"";
                    }
                    
                    if (dictionary[@"data"][i][@"fundType"] != nil && ![dictionary[@"data"][i][@"fundType"] isKindOfClass:[NSNull class]]) {
                        tradeModel.fundType = [NSString stringWithFormat:@"%@",dictionary[@"data"][i][@"fundType"]];
                    }
                    else{
                        tradeModel.fundType = @"";
                    }
                    
                    if (dictionary[@"data"][i][@"theoryCounterFee"] != nil && ![dictionary[@"data"][i][@"theoryCounterFee"] isKindOfClass:[NSNull class]]) {
                        tradeModel.theoryCounterFee = [NSString stringWithFormat:@"%@",dictionary[@"data"][i][@"theoryCounterFee"]];
                    }
                    else{
                        tradeModel.theoryCounterFee = @"";
                    }
                    
                    if (dictionary[@"data"][i][@"counterFee"] != nil && ![dictionary[@"data"][i][@"counterFee"] isKindOfClass:[NSNull class]]) {
                        tradeModel.counterFee = [NSString stringWithFormat:@"%@",dictionary[@"data"][i][@"counterFee"]];
                    }
                    else{
                        tradeModel.counterFee = @"";
                    }
                    
                    if (dictionary[@"data"][i][@"maxProfit"] != nil && ![dictionary[@"data"][i][@"maxProfit"] isKindOfClass:[NSNull class]]) {
                        tradeModel.maxProfit = [NSString stringWithFormat:@"%@",dictionary[@"data"][i][@"maxProfit"]];
                    }
                    else{
                        tradeModel.maxProfit = @"";
                    }
                    
                    if (dictionary[@"data"][i][@"maxLoss"] != nil && ![dictionary[@"data"][i][@"maxLoss"] isKindOfClass:[NSNull class]]) {
                        tradeModel.maxLoss = [NSString stringWithFormat:@"%@",dictionary[@"data"][i][@"maxLoss"]];
                    }
                    else{
                        tradeModel.maxLoss = @"";
                    }
                    
                    if (dictionary[@"data"][i][@"multiple"] != nil && ![dictionary[@"data"][i][@"multiple"] isKindOfClass:[NSNull class]]) {
                        tradeModel.multiple = [NSString stringWithFormat:@"%@",dictionary[@"data"][i][@"multiple"]];
                    }
                    else{
                        tradeModel.multiple = @"";
                    }
                    
                    if (dictionary[@"data"][i][@"id"] != nil && ![dictionary[@"data"][i][@"id"] isKindOfClass:[NSNull class]]) {
                        tradeModel.tradeID = [NSString stringWithFormat:@"%@",dictionary[@"data"][i][@"id"]];
                    }
                    else{
                        tradeModel.tradeID = @"";
                    }
                    
                    if (dictionary[@"data"][i][@"rate"] != nil && ![dictionary[@"data"][i][@"rate"] isKindOfClass:[NSNull class]]) {
                        tradeModel.rate = [NSString stringWithFormat:@"%.4f",[dictionary[@"data"][i][@"rate"] doubleValue]];
                    }
                    else{
                        tradeModel.rate = @"";
                    }
                    
                    if (dictionary[@"data"][i][@"isDefault"] != nil && ![dictionary[@"data"][i][@"isDefault"] isKindOfClass:[NSNull class]]) {
                        tradeModel.isDefault = [NSString stringWithFormat:@"%@",dictionary[@"data"][i][@"isDefault"]];
                    }
                    else{
                        tradeModel.isDefault = @"";
                    }
                    
                    if (dictionary[@"data"][i][@"defaultProfit"] != nil && ![dictionary[@"data"][i][@"defaultProfit"] isKindOfClass:[NSNull class]]) {
                        tradeModel.defaultProfit = [NSString stringWithFormat:@"%@",dictionary[@"data"][i][@"defaultProfit"]];
                    }
                    else{
                        tradeModel.defaultProfit = @"";
                    }
                    
                    if([tradeModel.fundType isEqualToString:@"0"]){
                        [moneyArray addObject:tradeModel];
                    }
                    else{
                        [integralArray addObject:tradeModel];
                    }
                }
            }
            
            //排序
            NSMutableArray *temArray = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0 ; i<moneyArray.count; i++) {
                TradeConfigerModel *model = moneyArray[i];
                [temArray addObject:[NSNumber numberWithFloat:[model.maxLoss floatValue]]];
            }
            NSArray *comperArray = [temArray sortedArrayUsingSelector:@selector(compare:)];
            NSMutableArray  *moneyTemArray = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i<comperArray.count; i++) {
                
                for (int j = 0; j<moneyArray.count; j++) {
                    TradeConfigerModel *currentModel = moneyArray[j];
                    if ([comperArray[i] floatValue]  == [currentModel.maxLoss floatValue]) {
                        [moneyTemArray addObject:currentModel];
                    }
                }
                
            }
            
            
            NSMutableArray *temIArray = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0 ; i<integralArray.count; i++) {
                TradeConfigerModel *model = integralArray[i];
                [temIArray addObject:[NSNumber numberWithInt:[model.maxLoss floatValue]]];
            }
            NSArray *comperIArray = [temIArray sortedArrayUsingSelector:@selector(compare:)];
            NSMutableArray  *integralTemArray = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i<comperIArray.count; i++) {
                
                for (int j = 0; j<integralArray.count; j++) {
                    TradeConfigerModel *currentModel = integralArray[j];
                    if ([comperIArray[i] floatValue]  == [currentModel.maxLoss intValue]) {
                        [integralTemArray addObject:currentModel];
                    }
                }
                
            }
            
            
            successBlock(YES,moneyTemArray,integralTemArray);
        }
        else{
            successBlock(NO,dictionary[@"msg"],nil);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO,nil,nil);
    }];
}

#pragma mark 期货购买

+(void)requestToBuy:(NSDictionary *)aDic completeBlock:(void(^)(BOOL , NSDictionary *))successBlock{
    
    NSString * urlStr = [NSString stringWithFormat:@"http://%@/order/futures/buy",HTTP_IP];
    
    [NetRequest postRequestWithNSDictionary:aDic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            successBlock(YES,dictionary);
        }
        else{
            successBlock(NO,dictionary);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO,nil);
    }];
}

#pragma mark 更新友盟设备号

+(void)requestUpdateUMDevicesWithBlock:(void(^)(BOOL))successBlock{
    
    NSString    *type = @"";
#if defined (CAINIUA)
    type =@"niuacom";//牛a
#elif defined (CAINIUAPPSTORE)
    type =@"cainiu";// 财牛app store
#elif defined (NIUAAPPSTORE)
    type =@"niua";   //牛a app store
#else
    type =@"cainiucom";// 财牛
#endif
    
    NSString * string = [[CMStoreManager sharedInstance] getUmCode];
    
    if (string == nil) {
        string = @"没有设备号(iOS模拟器运行)";
    }
    
    
    
    NSDictionary *dic = @{
                          @"token":[[CMStoreManager sharedInstance] getUserToken],
                          @"umCode":string,
                          @"pkgtype":type,
                          @"environment":[NSNumber numberWithInt:1],
                          @"platform":@"ios",
                          };
    
    NSString * urlStr = [NSString stringWithFormat:@"http://%@/user/user/updateUmCode",HTTP_IP];
    
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            successBlock(YES);
        }
        else{
            successBlock(NO);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO);
    }];
}

#pragma mark 用户出售期货订单

+(void)requestToSaleWithID:(NSString*)aID type:(int)aType price:(NSString *)aPrice date:(NSString  *)aTime isCheck:(NSString*)isCheck successBlock:(void(^)(BOOL,NSString *,NSDictionary *))successBlock{
    
    if (aPrice == nil) {
        aPrice = @"0";
    }
    
    if (aTime == nil) {
        aTime = @"0";
    }
    
    NSDictionary *dic = @{
                          @"token":[[CMStoreManager sharedInstance] getUserToken],
                          @"orderId":aID,
                          @"version":@"0.0.3",
                          @"userSalePrice":[NSNumber numberWithDouble:[aPrice doubleValue]],
                          @"shouldCheckPrice":isCheck,
                          @"userSaleDate":aTime,
                          };
    
    NSString * urlStr = [NSString stringWithFormat:@"http://%@/order/futures/sale",HTTP_IP];
    
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if (dictionary[@"code"] != nil && ![dictionary[@"code"] isKindOfClass:[NSNull class]]) {
            successBlock(YES,dictionary[@"code"],dictionary);
        }
        else{
            successBlock(NO,nil,nil);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO,nil,nil);
    }];
}


#pragma mark 获取个人配资额度
//传入配资额度
+(void)requestToGetCapitalMoney:(NSString *)aMoney Complete:(void(^)(BOOL,NSMutableArray *,NSMutableArray *))block{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       aMoney,@"financyAllocation",
                       
                       nil];
    
    
    
    NSString     *url=[NSString stringWithFormat:@"http://%@/financy/financy/getUserStockTraderList",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            
            NSMutableArray *moneyArray = [NSMutableArray arrayWithCapacity:0];
            
            NSMutableArray *integralArray = [NSMutableArray arrayWithCapacity:0];
            
            for (int i = 0; i<[dictionary[@"data"] count]; i++) {
                StockOrderModel *model = [[StockOrderModel alloc]init];
                
                
                if (dictionary[@"data"][i][@"id"] != nil && ![dictionary[@"data"][i][@"id"] isKindOfClass:[NSNull class]]) {
                    model.stockID = [dictionary[@"data"][i][@"id"] intValue];
                }
                
                if (dictionary[@"data"][i][@"fundType"] != nil && ![dictionary[@"data"][i][@"fundType"] isKindOfClass:[NSNull class]]) {
                    model.stockFundType = [dictionary[@"data"][i][@"fundType"] intValue];
                }else{
                    model.stockFundType = 0;
                }
                
                if (dictionary[@"data"][i][@"financyAllocation"] != nil && ![dictionary[@"data"][i][@"financyAllocation"] isKindOfClass:[NSNull class]]) {
                    model.stockFinancyAllocation = [dictionary[@"data"][i][@"financyAllocation"] floatValue];
                }
                else{
                    model.stockFinancyAllocation = 2000.00;
                }
                
                if (dictionary[@"data"][i][@"multiple"] != nil && ![dictionary[@"data"][i][@"multiple"] isKindOfClass:[NSNull class]]) {
                    model.stockMultiple = [dictionary[@"data"][i][@"multiple"] floatValue];
                }
                else{
                    model.stockMultiple = 2.00;
                }
                
                if (dictionary[@"data"][i][@"cashFund"] != nil && ![dictionary[@"data"][i][@"cashFund"] isKindOfClass:[NSNull class]]) {
                    model.stockCashFund = [dictionary[@"data"][i][@"cashFund"] floatValue];
                }
                else{
                    model.stockCashFund = 0.00;
                }
                
                if (dictionary[@"data"][i][@"counterFee"] != nil && ![dictionary[@"data"][i][@"counterFee"] isKindOfClass:[NSNull class]]) {
                    model.stockCounterFee = [dictionary[@"data"][i][@"counterFee"] floatValue];
                }
                else{
                    model.stockCounterFee = 0.00;
                }
                
                if (dictionary[@"data"][i][@"theoryInterest"] != nil && ![dictionary[@"data"][i][@"theoryInterest"] isKindOfClass:[NSNull class]]) {
                    model.stockDeductCounterFee = [dictionary[@"data"][i][@"theoryInterest"] floatValue];
                }
                else{
                    model.stockDeductCounterFee = 0.00;
                }
                
                if (dictionary[@"data"][i][@"interest"] != nil && ![dictionary[@"data"][i][@"interest"] isKindOfClass:[NSNull class]]) {
                    model.stockInterest = [dictionary[@"data"][i][@"interest"] floatValue];
                }
                else{
                    model.stockInterest = 0.00;
                }
                
                if (dictionary[@"data"][i][@"maxLoss"] != nil && ![dictionary[@"data"][i][@"maxLoss"] isKindOfClass:[NSNull class]]) {
                    model.stockMaxLoss = [dictionary[@"data"][i][@"maxLoss"] floatValue];
                }
                else {
                    model.stockMaxLoss = 0.00;
                }
                
                if (dictionary[@"data"][i][@"warnAmt"] != nil && ![dictionary[@"data"][i][@"warnAmt"] isKindOfClass:[NSNull class]]) {
                    model.stockWarnAmt = [dictionary[@"data"][i][@"warnAmt"] floatValue];
                }
                else{
                    model.stockWarnAmt = 0.00;
                }
                
                if (dictionary[@"data"][i][@"status"] != nil && ![dictionary[@"data"][i][@"status"] isKindOfClass:[NSNull class]]) {
                    model.stockStatus = [dictionary[@"data"][i][@"status"] intValue];
                }
                else{
                    model.stockStatus = 0;
                }
                
                if (model.stockFundType == 0) {
                    [moneyArray addObject:model];
                }
                else if (model.stockFundType == 1){
                    [integralArray addObject:model];
                }
            }
            
            
            block(YES,moneyArray,integralArray);
        }
        else
        {
            block(NO,nil,nil);
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO,nil,nil);
    }];
}

#pragma mark 获取市场状态

+(void)requestToGetMarketStatus:(void(^)(BOOL,NSMutableDictionary *))block{
    NSDictionary *dic=[NSDictionary dictionary];
    NSString     *url=[NSString stringWithFormat:@"http://%@/market/market/marketStatus",HTTP_IP];
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            block(YES,[NSMutableDictionary dictionaryWithDictionary:dictionary]);
        }
        else{
            block(NO,nil);
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        block(NO,nil);
    }];
}

#pragma mark 交易记录

+(void)requestToGetRecordIsMoney:(BOOL)isMoney pageNo:(int)aNo completeBlock:(void(^)(NSMutableArray *))successBlock failBlock:(void(^)(NSString *))failBlock{
    
    
    NSDictionary * dic = @{@"version":VERSION,
                           @"pageNo":[NSString stringWithFormat:@"%d",aNo],
                           @"pageSize":@"15",
                           @"token":[[CMStoreManager sharedInstance] getUserToken]
                           };
    NSString * urlStr;
    if (!isMoney) {
        urlStr = [NSString stringWithFormat:@"http://%@/order/order/finishScoreOrderList",HTTP_IP];
        
    }else{
        urlStr = [NSString stringWithFormat:@"http://%@/order/order/finishCashOrderList",HTTP_IP];
    }
    
    __block NSError *errorPro=nil;
    
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            successBlock(dictionary[@"data"]);
        }
        else{
            failBlock(dictionary[@"msg"]);
        }
    } failureBlock:^(NSError *error) {
        errorPro=error;
        failBlock(@"");
    }];
}

#pragma mark 系统控制

+(void)requestCompleteBlock:(void(^)(NSString *))successBlock failBlock:(void(^)(NSString *))failBlock{
    
    
    NSDictionary * dic = [NSDictionary dictionary];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    
    NSString *arcStr = [NSString stringWithFormat:@"%d%ld%d",arc4random()%10000000,(long)interval,arc4random()%10000000];
    
    NSString * urlStr = [NSString stringWithFormat:@"http://stock.cainiu.com/rule/1.html?id=%@",arcStr];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        successBlock(str);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        successBlock(@"1");
    }];
}

#pragma mark 期货是否开户

+(void)requestToGetFutureRegist:(void(^)(BOOL))successBlock{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[[CMStoreManager sharedInstance] getUserToken],@"token", nil];
    
    NSString    *urlStr = [NSString stringWithFormat:@"http://%@/user/account/getApply",HTTP_IP];
    
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] intValue] == 200) {
            if (dictionary[@"data"] != nil && ![dictionary[@"data"] isKindOfClass:[NSNull class]]) {
                if (dictionary[@"data"][@"status"] != nil && ![dictionary[@"data"][@"status"] isKindOfClass:[NSNull class]]) {
                    if ([[NSString stringWithFormat:@"%@",dictionary[@"data"][@"status"]] isEqualToString:@"1"]) {
                        successBlock(YES);
                    }
                    else{
                        successBlock(NO);
                    }
                }
            }
        }else{
            successBlock(NO);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO);
    }];
}

@end
