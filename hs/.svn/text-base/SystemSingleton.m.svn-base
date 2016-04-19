//
//  SystemSingleton.m
//  hs
//
//  Created by RGZ on 15/7/8.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "SystemSingleton.h"

@implementation SystemSingleton
DEF_SINGLETON(SystemSingleton)

@synthesize timeInterval,marketStates,timeString;


-(NSInteger)getMarketStatus{
    
    long long nowTimeInterval = [SystemSingleton sharedInstance].timeInterval;
    
    NSString *statusStr = @"";
    
    NSMutableDictionary * infoDic = [CacheEngine getMarketStatus];
    
    for (int i = 0; i<[infoDic[@"data"] count]; i++) {
        NSMutableDictionary * dic = infoDic[@"data"][i];
        
        if (nowTimeInterval > [dic[@"start_time"] longLongValue] && nowTimeInterval < [dic[@"end_time"] longLongValue]) {
            statusStr = dic[@"desc"];
        }
    }
    
    if ([statusStr rangeOfString:@"未开市"].location != NSNotFound) {
        return MarketNotOpening;
    }
    else if ([statusStr rangeOfString:@"集合竞价"].location != NSNotFound){
        return MarketBidding;
    }
    else if ([statusStr rangeOfString:@"开市"].location != NSNotFound || [statusStr rangeOfString:@"可买"].location != NSNotFound || [statusStr rangeOfString:@"可卖"].location != NSNotFound){
        return MarketOpening;
    }
    else if ([statusStr rangeOfString:@"午休"].location != NSNotFound){
        return MarketMiddayRest;
    }
    else if ([statusStr rangeOfString:@"闭市"].location != NSNotFound){
        return MarketClosing;
    }
    else{
        return MarketOther;
    }
}

//-(int)getMarketStates{
//    NSDateFormatter *dateFormatter
//}

@end
