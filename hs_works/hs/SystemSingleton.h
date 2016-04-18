//
//  SystemSingleton.h
//  hs
//
//  Created by RGZ on 15/7/8.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MarketType) {
    //未开市
    MarketNotOpening = 20,
    //集合竞价
    MarketBidding    = 21,
    //确认买入
    MarketOpening    = 22,
    //午休市
    MarketMiddayRest = 23,
    //已闭市
    MarketClosing    = 24,
    //其他
    MarketOther      = 100
};

@interface SystemSingleton : NSObject

AS_SINGLETON(SystemSingleton)

//系统时间戳
@property (nonatomic,assign)long long  timeInterval;
//慎用（请求服务器时的时间）
@property (nonatomic,strong)NSString        *timeString;

//市场状态
@property (nonatomic,assign)int             marketStates;

-(NSInteger)getMarketStatus;

@end
