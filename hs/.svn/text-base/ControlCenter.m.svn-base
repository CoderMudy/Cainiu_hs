//
//  ControlCenter.m
//  hs
//
//  Created by RGZ on 16/1/6.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "ControlCenter.h"

@implementation ControlCenter
DEF_SINGLETON(ControlCenter)


//是否清仓
-(BOOL)isClear{
    if ([self.clear isEqualToString:@"1"]) {
        return YES;
    }
    else{
        return NO;
    }
}

//是否显示支付宝
-(BOOL)isShowAlipay{
    if ([self.alipay isEqualToString:@"1"]) {
        return YES;
    }
    else{
        return NO;
    }
}

//是否显示现货开户
-(BOOL)isShowCots{
    if ([self.cots isEqualToString:@"1"]) {
        return YES;
    }
    else{
        return NO;
    }
}

//是否显示K线
-(BOOL)isShowKline{
    if ([self.kline isEqualToString:@"1"]) {
        return YES;
    }
    else{
        return NO;
    }
}

@end
