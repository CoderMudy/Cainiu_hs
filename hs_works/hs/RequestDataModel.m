//
//  RequestDataModel.m
//  hs
//
//  Created by PXJ on 15/9/11.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "RequestDataModel.h"
#import "NetRequest.h"
#import "AccountModel.h"
#import "News.h"

@implementation RequestDataModel

+(NSString *)cainiuToken
{
    NSString * cainiuToken = [[CMStoreManager sharedInstance]getUserToken];
    
    return cainiuToken;
}

+(NSString *)cashToken
{

    NSString * cashToken = [[SpotgoodsAccount sharedInstance] getSpotgoodsToken];
    if(cashToken.length<=1){
        cashToken= @" ";
    }
    return cashToken;
}
+(NSString *)traderId
{

    NSString * traderId =  [[SpotgoodsAccount sharedInstance] getTradeID];
    if (traderId.length<=1) {
        traderId = @" ";
    }
    return traderId;
}
//～～～～～～～～～～方法～～～～～～～～～～～～～～
//现货————————入金结果————通知服务端
+ (void)feedbackServiceWithDic:(NSDictionary *)dic successBlock:(void(^)(BOOL success))successBlock;
{
    NSString * urlStr = K_Cash_CyberPayBlock;
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"]intValue]==200)
        {
            successBlock(YES);
        }else{
            successBlock(NO);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO);
    }];
}

#pragma mark查询单个品种信息
+ (void)requestCashSingleInfoWithWareId:(NSString*)wareId successBlock:(void(^)(BOOL success,NSDictionary *dictionary))successBlock;
{
    NSDictionary * dic = @{@"token":[RequestDataModel cashToken],@"traderId":[RequestDataModel traderId],@"wareId":wareId};
    NSString * urlStr = K_Cash_SingelInfo;
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"]intValue]==200)
        {
            NSArray * array = [NSArray arrayWithObject:dictionary[@"data"][@"DATAS"]];
            if (array.count>0) {
                NSArray * subArray = array[0];
                if (subArray.count>0) {
                    successBlock(YES,array[0][0]);
                }
            }
        }else
        {
            successBlock(NO,nil);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO,nil);
    }];
    
}
#pragma mark用户风险率查询
+ (void)requestCashUserRistTraderSuccessBlock:(void(^)(BOOL success,NSDictionary *dictionary))successBlock;
{
    NSDictionary * dic = @{@"token":[RequestDataModel cashToken],@"traderId":[RequestDataModel traderId]};
    NSString * urlStr =  K_Cash_RiskTrader;
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] intValue]==200)
        {
            successBlock(YES,dictionary[@"data"]);
        }else
        {
            successBlock(NO,dictionary);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO,nil);
    }];
    
}
#pragma mark 委托订单详情
+ (void)requestCashEntrustDetailOrderId:(NSString*)orderId successBlock:(void(^)(BOOL success,NSDictionary *dictionary))successBlock;
{
    NSDictionary * dic = @{@"token":[RequestDataModel cashToken], @"id":orderId};
    NSString * urlStr =  K_Cash_EntrustDetail;
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] intValue]==200)
        {
            successBlock(YES,dictionary[@"data"]);
        }else
        {
            successBlock(NO,dictionary);
        }
    } failureBlock:^(NSError *error)
     {
        successBlock(NO,nil);
    }];
}

#pragma mark 订单列表
+ (void)requestCashOrderListWithWareId:(NSString *)wareId url:(NSString *)urlStr pageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize successBlock:(void(^)(BOOL success, NSArray * dataArray))successBlock;
{
    NSDictionary* dic = @{@"token":[RequestDataModel cashToken],
                          @"traderId":[RequestDataModel traderId],
                          @"wareId":wareId,
                          @"pageNo":[NSNumber numberWithInteger:pageNo],
                          @"pageSize":[NSNumber numberWithInteger:pageSize]};
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary)
     {
        if ([dictionary[@"code"] intValue]==200)
        {
            successBlock(YES,dictionary[@"data"]);
        }else
        {
            successBlock(NO,nil);
        }
                                
    } failureBlock:^(NSError *error)
     {
        successBlock(NO,nil);
    }];

}

#pragma mark 闪电平仓
+ (void)requestCashKeySaleWareId:(NSString *)wareId successBlock:(void(^)(BOOL success,NSDictionary *dictionary))successBlock;
{
    NSDictionary * dic = @{@"token":[RequestDataModel cashToken],
                           @"traderId":[RequestDataModel traderId],
                           @"wareId":wareId
                           };
    NSString * urlStr =  K_Cash_KeySale;
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary)
    {
        if ([dictionary[@"code"] intValue]==200)
        {
            successBlock(YES,dictionary);
        }else
        {
            successBlock (NO,dictionary);
        }
    } failureBlock:^(NSError *error)
    {
        successBlock(NO,[NSDictionary dictionary]);
    }];
}
#pragma mark 部分平仓
+ (void)requestCashPartSaleWareId:(NSString *)wareId buyOrSal:(NSString *)buyOrSal price:(NSString *)price saleNum:(NSString*)saleNum successBlock:(void(^)(BOOL success,NSDictionary *dictionary))successBlock
{
    NSDictionary * dic = @{@"token":[RequestDataModel cashToken],
                           @"traderId":[RequestDataModel traderId],
                           @"wareId":wareId,
                           @"buyOrSal":buyOrSal,
                           @"price":price,
                           @"num":saleNum
                           };
    NSString * urlStr =  K_Cash_MarketOrder;
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary)
     {
         if ([dictionary[@"code"] intValue]==200)
         {
             successBlock(YES,dictionary);
         }else
         {
             successBlock (NO,dictionary);
         }
     } failureBlock:^(NSError *error)
     {
         successBlock(NO,[NSDictionary dictionary]);
     }];
}

#pragma mark 撤销订单
+ (void)requestCashRevokeOrderUrl:(NSString *)urlStr seriaNo:(NSString *)seriaNo wareId:(NSString*)wareId orderId:(NSString*)orderId fDate:(NSString*   )fDate successBlock:(void(^)(BOOL success,NSDictionary *dictionary))successBlock;
{
    NSDictionary * dic= @{@"token":[RequestDataModel cashToken],
           @"traderId":[RequestDataModel traderId],
           @"serialNo":seriaNo,
           @"wareId":wareId,
           @"orderId":orderId,
//           @"fDate":fDate
           };
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary)
    {
        if ([dictionary[@"code"] intValue]==200)
        {
            successBlock(YES,dictionary);
        }else{
            successBlock(NO,dictionary);
        }
    } failureBlock:^(NSError *error)
    {
        successBlock(NO,nil);
    }];

}
#pragma mark 获取现货持仓数据
+ (void)requestCashPositionDataWareId:(NSString*)wareId successBlock:(void(^)(BOOL success,NSDictionary *dictionary))successBlock;
{
    NSString * urlStr = K_Cash_queryPosition;
    NSString * token = [RequestDataModel cashToken];
    NSString * traderId = [RequestDataModel traderId];
     NSDictionary * dic = @{@"token":token,@"traderId":traderId,@"wareId":wareId};
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary)
    {
        if ([dictionary[@"code"]intValue]==200)
        {
            NSDictionary * dic = [NSDictionary dictionaryWithDictionary:dictionary[@"data"]];
            successBlock(YES,dic);
        }else
        {
            successBlock(NO,nil);
        }
    } failureBlock:^(NSError *error)
     {
        successBlock(NO,nil);
    }];
}

#pragma mark 获取现货持仓列表（未成交委托单）
+ (void)requestCashUnSuccessSignList:(NSString*)wareId successBlock:(void(^)(BOOL success,NSArray *array))successBlock;
{
    NSString * urlStr = K_Cash_queryNewEntrustList;
    NSString * token = [RequestDataModel cashToken];
    NSString * traderId = [RequestDataModel traderId];
    NSDictionary * dic = @{@"token":token,
                           @"traderId":traderId,
                           @"wareId":wareId};
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary)
    {
        if ([dictionary[@"code"]intValue]==200)
        {
            NSArray * array = [NSArray arrayWithObject:dictionary[@"data"]];
            successBlock(YES,array);
        }else
        {
            successBlock(NO,nil);
        }
    } failureBlock:^(NSError *error)
    {
        successBlock(NO,nil);
    }];
}
#pragma mark 获取现货用户资金

+ (void)requestCashUserFundSuccessBlock:(void(^)(BOOL success,NSDictionary *dictionary))successBlock;
{
    NSString * urlStr =k_Cash_QueryFund;
    NSString * token =[RequestDataModel cashToken];
    NSString * traderId = [RequestDataModel traderId];
    NSDictionary * dic = @{@"token":token,@"traderId":traderId};
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary)
    {
        if ([dictionary[@"code"]intValue]==200)
        {
            NSArray * array = [NSArray arrayWithObject:dictionary[@"data"][@"DATAS"]];
            if (array.count>0) {
                NSArray * subArray = array[0];
                if (subArray.count>0) {
                    successBlock(YES,array[0][0]);
                }
            }
        }else
        {
            successBlock(NO,nil);
        }
    } failureBlock:^(NSError *error)
     {
        successBlock(NO,nil);
    }];

}
#pragma mark 获取大厅是否清仓
+(void)requestMarkerIsClearSuccessBlock:(void(^)(BOOL success,NSString * data))successBlock;
{

    NSString * urlStr =K_Foyerpage_isClear;
    [NetRequest postRequestWithNSDictionary:nil url:urlStr successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"]intValue]==200)
        {
            successBlock(YES,dictionary[@"data"]);
            
        }else
        {
            successBlock(NO,@"0");
        }
    } failureBlock:^(NSError *error)
     {
        successBlock(NO,@"0");
    }];


}

#pragma mark 大厅————————获取单个种类的行情信息
+(void)requestFoyerCacheData:(NSString * )futuresType successBlock:(void(^)(BOOL success,NSDictionary * dictionary))successBlock;
{
    NSString * urlStr = K_Foyerpage_getCachedata;
    NSDictionary * dic = @{@"futuresType":futuresType};
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"]intValue]==200)
        {
          successBlock(YES,dictionary[@"data"]);
        
        }else{
        
            successBlock(NO,nil);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO,nil);
    }];

}
#pragma mark 大厅————————假日盘——获取用户盈利
+(void)requestFoyerHolidayProfitSuccessBlock:(void(^)(BOOL success,NSDictionary * dictionary))successBlock;
{
    NSString * urlStr = K_Order_monProfit;
    NSDictionary * dic = @{@"token":[RequestDataModel cainiuToken],
                           @"version":@"0.0.1"
                           };
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if (dictionary[@"code"] != nil && ![dictionary[@"code"] isKindOfClass:[NSNull class]]&&[dictionary[@"code"]intValue]==200){
            successBlock (YES,dictionary);
        }else{
            successBlock (NO,dictionary);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO,nil);
    }];
    
}
#pragma mark 发现————————获取用户任务中心是否有红包可领取
+(void)requestUserIsEnableRedBag:(void(^)(BOOL success,BOOL enable))successBlock;
{
    NSString * urlStr = K_activity_diplay;
    NSString * token = [RequestDataModel cainiuToken];
    NSDictionary * dic = @{@"token":token};
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if (dictionary[@"code"] != nil && ![dictionary[@"code"] isKindOfClass:[NSNull class]]&&[dictionary[@"code"]intValue]==200){
            NSString * str = [NSString stringWithFormat:@"%d",[dictionary[@"data"] intValue]];
            
            BOOL enable = [str isEqualToString:@"1"]?YES:NO;
            
            successBlock(YES,enable);
        }else
        {
            successBlock(YES,NO);
        }
        
    } failureBlock:^(NSError *error) {
        successBlock(NO,NO);
    }];
    
}
#pragma mark 大厅—————————请求产品列表
+(void)requestProductDataWithType:(NSString*)lobby SuccessBlock:(void(^)(BOOL success,NSMutableArray * mutableArray))successBlock
{
    NSDictionary * dic = @{@"lobby":lobby,@"token":[RequestDataModel cainiuToken]};
   
    NSString * urlStr = K_FoyerPage_productDataByType;
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        
        if (dictionary[@"code"] != nil && ![dictionary[@"code"] isKindOfClass:[NSNull class]]&&[dictionary[@"code"]intValue]==200){
            NSMutableArray * array = [NSMutableArray arrayWithArray:dictionary[@"data"]];
            successBlock(YES,array);
        }else
        {
            successBlock(NO,nil);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO,nil);
    }];
}


#pragma mark 大厅—————————请求期货产品列表
+(void)requestFoyerProductDataSuccessBlock:(void(^)(BOOL success,NSMutableArray * mutableArray))successBlock
{
    NSString * url = K_FoyerPage_productData;
    [NetRequest postRequestWithNSDictionary:nil url:url successBlock:^(NSDictionary *dictionary) {
        
        if (dictionary[@"code"] != nil && ![dictionary[@"code"] isKindOfClass:[NSNull class]]&&[dictionary[@"code"]intValue]==200){
            NSMutableArray * array = [NSMutableArray arrayWithArray:dictionary[@"data"]];
            successBlock(YES,array);
        }else
        {
            successBlock(NO,nil);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO,nil);
    }];
}
#pragma mark 大厅—————————假期盘请求是否为假期
+(void)requestMarkerIsHolidaySuccessBlock:(void(^)(BOOL success,BOOL isHoliDay,NSString* holiDay))successBlock;
{
    NSString * url = K_market_isHoliday;
    [NetRequest postRequestWithNSDictionary:nil url:url successBlock:^(NSDictionary *dictionary) {
        if (dictionary[@"code"] != nil && ![dictionary[@"code"] isKindOfClass:[NSNull class]]&&[dictionary[@"code"]intValue]==200){
            NSString *  isHoliday=[NSString stringWithFormat:@"%@",dictionary[@"data"][@"holiday"]];
            NSString * holiday=@"";
            if (isHoliday.boolValue) {
                holiday = dictionary[@"data"][@"day"];
            }
            successBlock(YES,isHoliday.boolValue,holiday);
        }else
        {
            successBlock(NO,NO,nil);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO,NO,nil);
    }];

}

#pragma mark /**请求期货持仓列表*/
+(void)requestFuturesListWithFuturesTypeWithFuturesType:(NSString *)futuresType fundType:(NSString *)fundType successBlock:(void(^)(BOOL success,NSDictionary * dictionary))successBlock;
{
    NSString * token = [RequestDataModel cainiuToken];
    NSDictionary * dic = @{@"token":token,@"futuresType":futuresType,@"fundType":fundType};
    
    NSString * url = K_Index_posiList;
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        if([dictionary[@"code"]intValue]==200)
        {
            successBlock(YES,dictionary);
        }else{
            successBlock(NO,dictionary);
        }
        
    } failureBlock:^(NSError *error) {
        successBlock (NO,nil);
    }];

}
#pragma mark 甩单请求
+(void)requestSaleOrderWithOrderID:(NSString *)orderId salePrice:(NSString * )salePrice saleDate:(NSString *)saleDate shouldCheckPrice:(NSString*)shouldCheckPrice SuccessBlock:(void(^)(BOOL success,NSMutableArray* mutableArray,NSDictionary * errorDic))successBlock;
{
    
    
    if ( salePrice== nil) {
        salePrice = @"0";
    }
    
    if (saleDate == nil) {
        saleDate = @"0";
    }

    NSDictionary * dic = @{@"token":[RequestDataModel cainiuToken],
                           @"orderId":orderId,
                           @"userSalePrice":[NSNumber numberWithFloat:salePrice.floatValue],
                           @"userSaleDate":saleDate,
                           @"shouldCheckPrice":shouldCheckPrice,
                           @"version":@"0.0.3"};
    NSString * urlstr =K_Index_sale;
    [NetRequest postRequestWithNSDictionary:dic url:urlstr successBlock:^(NSDictionary *dictionary) {
        if (dictionary[@"code"] != nil && ![dictionary[@"code"] isKindOfClass:[NSNull class]] && [dictionary[@"code"]intValue]==200){
            
            NSMutableArray * array = [NSMutableArray arrayWithArray:dictionary[@"data"]];
            successBlock(YES,array,nil);
        }else
        {
            successBlock(NO,nil,dictionary);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO,nil,nil);
    }];
}

#pragma mark 甩单轮询结果
+(void)requestSearchSaleOrderStatusWith:(NSString*)orderId SuccessBlock:(void(^)(BOOL success,NSMutableArray* mutableArray,NSString * errorMessage))successBlock;
{

    NSDictionary * dic = @{@"token":[RequestDataModel cainiuToken],
                           @"orderId":orderId,
                           @"version":@"20150915"};
    NSString * url = K_Index_saleSearch;
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        
        if (dictionary[@"code"] != nil && ![dictionary[@"code"] isKindOfClass:[NSNull class]] && [dictionary[@"code"]intValue]==200){
            
            NSMutableArray * array = [NSMutableArray arrayWithArray:dictionary[@"data"]];
            
            successBlock(YES,array,nil);
        }else
        {
            successBlock(NO,nil,dictionary[@"msg"]);
        }
    } failureBlock:^(NSError *error)
    {
        successBlock(NO,nil,error.localizedDescription);
    }];
}
#pragma mark 期货条件单撤单
+ (void)requestFuturesRevokeOrderFundType:(NSString *)fundType conditionId:(NSString*)conditionId successBlock:(void(^)(BOOL success,NSDictionary *dictionary))successBlock;
{
    NSString * urlStr = k_Index_futuresOrderRevoke;
    NSDictionary * dic = @{
                           @"token":[RequestDataModel cainiuToken],
                           @"fundType":fundType,
                           @"conditionId":conditionId,
                           @"version":@"0.0.1"
                           };
    
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary)
     {
        if (dictionary[@"code"] != nil && ![dictionary[@"code"] isKindOfClass:[NSNull class]] && [dictionary[@"code"]intValue]==200){
            successBlock(YES,dictionary[@"msg"]);
        }else
        {
            successBlock(NO,dictionary[@"msg"]);
        }
     } failureBlock:^(NSError *error)
    {
        successBlock(NO,nil);
    }];
}
#pragma mark 查询产品是否可点击
+(void)requestPruductClickEnable:(NSString *)productId successBlock:(void(^)(BOOL success,BOOL enable,NSString * errorMessage))successBlock{

    NSDictionary * dic = @{@"id":productId};
    NSString * urlStr =  K_FoyerPage_productClickEnable;
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        
        if (dictionary[@"code"] != nil && ![dictionary[@"code"] isKindOfClass:[NSNull class]] && [dictionary[@"code"]intValue]==200){
            
            NSString  * data =dictionary[@"data"];
            BOOL enableClick;
            if (data.intValue==0) {
                enableClick = NO;
            }else {
                enableClick = YES;

            
            }
            successBlock(YES,enableClick,nil);
        }else
        {
            successBlock(YES,NO,dictionary[@"msg"]);
        }
  
    } failureBlock:^(NSError *error) {
        
        successBlock(NO,NO,error.localizedDescription);

    }];
}
#pragma mark 获取用户持仓数量
+(void)requestPosiOrderNum:(BOOL)isXH successBlock:(void(^)(BOOL success,NSArray * dataArray))successBlock;
{
    
    NSString * token = [[CMStoreManager sharedInstance] getUserToken];
    
   __block NSString * url ;
    NSDictionary * dic;
    if (isXH)
    {//现货
        url = K_FoyerPage_Cash_posiOrderCount;
        dic = @{@"token":[RequestDataModel cashToken],@"traderId":[RequestDataModel traderId]};

    }else
    {//期货
        url = K_FoyerPage_posiOrderCount;
        dic = @{@"token":token,@"version":@"20150915"};
    }
    if (token.length<=0) {
        return;
    }
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary)
     {
         NSArray * array = [NSArray array];
         if (dictionary[@"code"] != nil && ![dictionary[@"code"] isKindOfClass:[NSNull class]] && [dictionary[@"code"]intValue]==200){
             if ([dictionary[@"data"] isKindOfClass:[NSArray class]]) {
                array = [NSArray arrayWithArray:dictionary[@"data"]];
             }
         }
         successBlock(YES,array);
     } failureBlock:^(NSError *error)
     {
         successBlock(NO,[NSArray array]);
     }];
}
#pragma mark 获取banner信息
+(void)requestBanerDataSuccessBlock:(void(^)(BOOL success,NSArray * dataArray))successBlock;
{
    NSDictionary * dic = @{@"type":@"2"};
    [NetRequest postRequestWithNSDictionary:dic url:K_ImageURL successBlock:^(NSDictionary *dictionary) {
        NSArray * array = [NSArray array];
        if ([dictionary[@"code"] intValue]          == 200) {
            array = dictionary[@"data"][@"news_notice_list"];
        }
        successBlock(YES,array);
    } failureBlock:^(NSError *error) {
        successBlock(NO,[NSArray array]);
    }];
}
#pragma mark 获取播报信息
+(void)requestReportDataSuccessBlock:(void(^)(BOOL success,NSArray * dataArray))successBlock;
{
    NSString * urlStr =K_FINANCY_ROLL;
    [NetRequest postRequestWithNSDictionary:nil url:urlStr successBlock:^(NSDictionary *dictionary) {
        NSArray * array = [NSArray array];
        if ([dictionary[@"code"] intValue]==200) {
            array = [NSArray arrayWithArray:dictionary[@"data"]];
            successBlock(YES,array);
        }else{
            successBlock(NO,array);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO,[NSArray array]);
    }];


}
#pragma mark 查询期货订单状态
+(void)requestOrderStateWithfundType:(NSString *)fundtype orderId:(NSString *)orderID SuccessBlock:(void(^)(BOOL success,NSArray * dataArray))successBlock{
    NSDictionary * reqDic = @{@"token":[RequestDataModel cainiuToken],
                              @"fundType":fundtype,
                              @"futuredOrderIdsStr":orderID,
                              @"version":VERSION
                              };
    NSString * urlStr = K_order_orderState;
    [NetRequest postRequestWithNSDictionary:reqDic url:urlStr successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"]intValue]==200) {
            NSArray * array = dictionary[@"data"];
            successBlock(YES,array);
        }else{
            successBlock(YES,[NSArray array]);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO,[NSArray array]);
    }];
}
#pragma mark 查询用户管理权限
+(void)requestUserPowerSuccessBlock:(void(^)(BOOL success,int userPower))successBlock;
{
    NSString * strUrl = K_user_getIsStaffStatus;
    NSDictionary * dic = @{@"token":[RequestDataModel cainiuToken]};
    [NetRequest postRequestWithNSDictionary:dic url:strUrl successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"]intValue]==200) {
            successBlock(YES,[dictionary[@"data"]intValue]);
        }else{
            successBlock(NO,0);
        }
        
    } failureBlock:^(NSError *error) {
        successBlock(NO,0);

    }];
}
#pragma mark 校验用户环境切换密码
+(void)requestEnviromentPassWord:(NSString *)passWord SuccessBlock:(void(^)(BOOL success,int clickStatus,NSString * msg))successBlock;
{

    NSDictionary * dic = @{@"password":passWord,
                           @"token":[RequestDataModel cainiuToken]};
    NSString * strUrl = K_user_checkEnviroPassWord;
    [NetRequest postRequestWithNSDictionary:dic url:strUrl successBlock:^(NSDictionary *dictionary) {
       
        if ([dictionary[@"code"]intValue]==200) {
            successBlock(YES,[dictionary[@"data"]intValue] ,[NSString  stringWithFormat:@"%@",dictionary[@"msg"]]);
        }else{
            successBlock(YES,0,[NSString  stringWithFormat:@"%@",dictionary[@"msg"]]);
        }
        
    } failureBlock:^(NSError *error) {
        
        successBlock(NO,0,nil);

        
        
    }];
}

#pragma mark判断用户是否是推广员
+(void)requestUserIsSpreadSuccess:(void(^)(BOOL success,int isSpreadUser))successBlock;
{
    NSString * token = [RequestDataModel cainiuToken];
    NSDictionary * dic = @{@"token":token};
    NSString * urlStr = K_promotion_getPromotionStatus;
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary)
    {
        if ([dictionary[@"code"]intValue]==200) {
            
            int isspreadUser = [dictionary[@"data"][@"isPromote"] intValue];
            NSLog(@"%@",dictionary[@"data"][@"isPromote"]);
            
            successBlock(YES,isspreadUser);
        }else{
            successBlock(NO,0);
        }
        
    }failureBlock:^(NSError *error){
        successBlock(NO,0);
    }];
}



#pragma mark 请求个人分享推广链接
+(void)requestUserQRSuccessBlock:(void(^)(BOOL success,BOOL clickStatus,NSString * msg))successBlock;
{

    NSString * token = [RequestDataModel cainiuToken];
    NSDictionary * dic  = @{@"token":token};
    NSString * urlStr = K_promotion_getPromoteId;
    
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
        
        if ([dictionary[@"code"] intValue]==200) {
            
          NSString * shareUrl = dictionary[@"data"];
            successBlock(YES,NO,shareUrl);
        }else{
        
            successBlock(NO,YES,@"");

        }
        
        
    } failureBlock:^(NSError *error) {
        
        successBlock(NO,YES,@"");
    }];
}

#pragma mark 请求大厅广告图链接
+(void)requestAdvertSuccessBlock:(void(^)(BOOL success,id data))successBlock;
{
    NSString * urlStr = K_FoyerPage_advert;
    
    NSDictionary * dic = @{@"type":@"3"};
    
    
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"]intValue]==200) {
            
            
            successBlock(YES,dictionary[@"data"]);
            
        }else{
            successBlock(NO,dictionary[@"msg"]);
        }
        
    } failureBlock:^(NSError *error) {
        
        successBlock(NO,error.localizedDescription);
    }];
}
#pragma mark 申请成为推广员请求
+(void)requestApplyPromote:(NSString *)applyReason SuccessBlock:(void(^)(BOOL success,NSString * msg))successBlock;
{
    NSString * urlStr = K_promote_apply;
    NSDictionary * dic = @{@"token":[RequestDataModel cainiuToken],@"reason":applyReason,@"version":@"1.0.0.20151022"};
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] intValue]==200) {
            successBlock(YES,dictionary[@"msg"]);

        }else{
        
            successBlock(NO,dictionary[@"msg"]);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO,@"");
    }];
}

#pragma mark 获取推广用户推广信息
+(void)requestPromoteUserMessageSuccessBlock:(void(^)(BOOL success,NSDictionary * dictionary))successBlock;
{
    NSString * urlStr = K_promotion_gerPromote;
    NSDictionary * dic = @{@"token":[[CMStoreManager sharedInstance] getUserToken]};
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"]intValue]==200) {
            successBlock(YES,dictionary[@"data"]);

            
        }else{
        
            successBlock(NO,nil);
        }
        
    } failureBlock:^(NSError *error) {
        successBlock(NO,nil);
    }];

}
#pragma mark 获取推广员用户下线数据
+(void)requestPromoteSubUserPageNo:(int)pageNo PageSize:(int)pageSize successBlock:(void(^)(BOOL success,id sender))successBlock;
{

    NSDictionary * dic = @{@"token":[[CMStoreManager sharedInstance] getUserToken],
                           @"pageNo":[NSNumber numberWithInt:pageNo],
                           @"pageSize":[NSNumber numberWithInt:pageSize]};
    NSString * urlStr = K_promote_subUsers;

    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"]intValue]==200) {
            successBlock(YES,dictionary[@"data"]);

        }else {
            successBlock(NO,dictionary);
        }
        
    } failureBlock:^(NSError *error) {
        successBlock(NO,nil);
    }];
}
#pragma mark 获取推广员佣金明细
+(void)requestPromoteComissionPageNo:(int)pageNo pageSize:(int)pageSize successBlock:(void(^)(BOOL success,id sender))successBlock
{

    
    NSDictionary * dic = @{@"token":[[CMStoreManager sharedInstance] getUserToken],
                           @"pageNo":[NSNumber numberWithInt:pageNo],
                           @"pageSize":[NSNumber numberWithInt:pageSize]};
    NSString * urlStr = K_promote_commissionDetail;
    
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"]intValue]==200) {
            successBlock(YES,dictionary[@"data"]);
            
        }else {
            successBlock(NO,dictionary);
        }
        
    } failureBlock:^(NSError *error) {
        successBlock(NO,nil);
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark 推广佣金转现
+(void)requestPromoteComissionCashMoney:(CGFloat)cashMoney successBlock:(void(^)(BOOL success,NSString* msg,int errorCode))successBlock;
{
    NSString * urlStr =K_promote_commissionCash;
    NSDictionary * dic = @{@"token":[[CMStoreManager sharedInstance] getUserToken],
                           @"version":@"0.01",
                           @"commissions":[NSNumber numberWithFloat:cashMoney]};
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"]intValue]==200) {
            
            successBlock(YES,dictionary[@"msg"],[dictionary[@"code"] intValue]);
        }else{
            successBlock(NO,dictionary[@"msg"],[dictionary[@"code"] intValue]);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO,@"",404);
    }];

}
#pragma mark 获取用户优惠券数量
+(void)requestCouponsNumSuccessBlock:(void(^)(BOOL success,int couponsNum))successBlock;
{
    NSString * urlStr = K_coupons_couponNum;
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token};
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"]intValue]==200) {
            successBlock(YES,[dictionary[@"data"][@"count"] intValue]);
        }else{
            successBlock(NO,0);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO,0);
    }];

}
#pragma mark 获取市场交易时间是否闭市
+(void)requestMarketIsStatus:(NSString *)futureType futureCode:(NSString *)fcode successBlock:(void(^)(BOOL success,NSInteger status))successBlock
{
    NSDictionary * dic = @{@"futureType":futureType,@"futureCode":fcode};
    [NetRequest postRequestWithNSDictionary:dic url:K_Cash_MarketIsStatus successBlock:^(NSDictionary *dictionary)
    {
        if ([dictionary[@"code"] intValue] == 200)
        {
            successBlock(YES,[dictionary[@"data"][@"status"]intValue]);
        }
    } failureBlock:^(NSError *error){
     
        successBlock(NO,0);
     }];
}
#pragma mark 上传用户头像
+(void)updateUserHeaderImageWithImage:(NSData*)image imageDetail:(NSDictionary*)detailDic successBlock:(void(^)(BOOL success,id Info))successBlock;
{
    NSDictionary * dic = @{@"token":[RequestDataModel cainiuToken],@"version":@"0.0.1"};
    NSString * urlStr = K_user_updateHeader;
  
    
    [NetRequest postUpdateDataWithDictionary:dic dataDetailDic:detailDic url:urlStr imageData:image successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue]==200) {
            successBlock(YES,dictionary);

        }else {
            successBlock(NO,dictionary);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO,nil);

    }];
}
#pragma mark 查询用户账户
+ (void)requestUserAccountsInfoSuccessBlock:(void(^)(BOOL success,id Info))successBlock;
{
    NSDictionary * dic = @{@"token":[RequestDataModel cainiuToken]};
    NSString * urlStr = K_user_accountsInfo;
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"]integerValue]==200) {
            successBlock(YES,dictionary);
            NSArray * detailArray = [NSArray arrayWithArray:dictionary[@"data"]];
            for (int i=0; i<detailArray.count; i++) {
                AccountModel * model = [AccountModel accountModelWithDictionary:detailArray[i]];
                NSDictionary * detailDic = detailArray[i];
                if ([model.code isEqualToString:@"score"]) {
                    [[CMStoreManager sharedInstance] setAccountScoreStatus:model.status];
                    [[CMStoreManager sharedInstance] setAccountScoreDetailDic:detailDic];
                }
                if ([model.code isEqualToString:@"cainiu"]) {
                    [[CMStoreManager sharedInstance] setAccountCainiuStatus:model.status];
                    [[CMStoreManager sharedInstance] setAccountCainiuDetailDic:detailDic];

                }
                if ([model.code isEqualToString:@"nanjs"]) {
                    [[CMStoreManager sharedInstance] setAccountNanJSStatus:model.status];
                    [[CMStoreManager sharedInstance] setAccountNanJSDetailDic:detailDic];
                }
            }
        }else{
            successBlock(NO,nil);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO,nil);
    }];
}
#pragma mark 开启模拟账户

+ (void)requestOpenScoreAccountSuccessBlock:(void(^)(BOOL success,id Info))successBlock;
{
    NSDictionary * dic = @{@"token":[RequestDataModel cainiuToken]};
    NSString * urlStr = K_user_openScoreAccount;
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary)
    {
        if ([dictionary[@"code"]integerValue]==200)
        {
            [[CMStoreManager sharedInstance] setAccountScoreStatus:@"1"];
            successBlock(YES,dictionary);
        }else{
            successBlock(NO,nil);
        }
    } failureBlock:^(NSError *error)
     {
        successBlock(NO,nil);
    }];
}
+ (void)requestInfoDetailWithNewsArticleId:(NSString *)newsArticleId successBlock:(void(^)(BOOL success,id Info))successBlock;
{
    NSDictionary * dic = @{@"token":[RequestDataModel cainiuToken],
                           @"newsArticleId":newsArticleId
                           };
    NSString * urlStr = K_Info_detail;
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary)
    {
        if ([DataUsedEngine nullTrim:dictionary[@"code"]])
        {
            if ([dictionary[@"code"] intValue] == 200)
            {
                if ([DataUsedEngine nullTrim:dictionary[@"data"]])
                {
                    
                    successBlock(YES,dictionary[@"data"]);
                }else
                {
                    successBlock(NO,dictionary[@"msg"]);
                }
            }else
            {
                successBlock(NO,dictionary[@"msg"]);
            }
        }else
        {
            successBlock(NO,nil);
        }
    } failureBlock:^(NSError *error)
    {
        successBlock(NO,nil);
    }];
}
+ (void)requestInfoTotalComentDataNewArticleId:(NSString *)newsArticleId pageNo:(int)pageNo pageSize:(int)pageSize successBlock:(void(^)(BOOL success,id Info))successBlock;
{
    NSDictionary * dic = @{@"token":[RequestDataModel cainiuToken],
                           @"newsArticleId":newsArticleId,
                           @"pageNo":[NSNumber numberWithInt:pageNo],
                           @"pageSize":[NSNumber numberWithInt:pageSize]
                           };
    NSString * urlStr = K_Info_detailComment;
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([DataUsedEngine nullTrim:dictionary[@"code"]]) {
            if ([dictionary[@"code"] intValue]==200) {
                if ([DataUsedEngine nullTrim:dictionary[@"data"]]) {
                    successBlock(YES,dictionary[@"data"]);
                }else{
                    successBlock(NO,nil);
                }
            }else{
                successBlock(NO,nil);
            }
        }else{
            successBlock(NO,nil);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO,nil);
    }];
}
/*
 *资讯————新增评论回复
 */
+ (void)requestInfoAddNewCommentNewsId:(NSString *)newsId
                           contentText:(NSString * )cmtContent
                          replyContent:(NSString *)replyContent
                                 cmtId:(int)cmtId
                               replyId:(int)replyId
                          successBlock:(void(^)(BOOL success,id Info))successBlock;
{
    NSDictionary * dic = @{@"newsId":newsId,
                           @"token":[RequestDataModel cainiuToken],
                           @"cmtContent":[DataUsedEngine nullTrimString:cmtContent],
                           @"replyContent":[DataUsedEngine nullTrimString:replyContent],
                           @"cmtId":[NSNumber numberWithInt:cmtId],
                           @"replyId":[NSNumber numberWithInt:replyId]
                           };
    NSString * urlStr = K_Info_addNewComment;
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"]integerValue]==200)
        {
            successBlock(YES,dictionary);
        }else{
            successBlock(NO,dictionary[@"msg"]);
        }
    } failureBlock:^(NSError *error) {
        successBlock(NO,nil);
    }];

}
@end
