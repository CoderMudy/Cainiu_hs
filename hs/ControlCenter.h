//
//  ControlCenter.h
//  hs
//
//  Created by RGZ on 16/1/6.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControlCenter : NSObject
AS_SINGLETON(ControlCenter)

//清仓   1清 其余不清
@property (nonatomic,strong)NSString    *clear;
//支付宝展示 1展示  其余不展示
@property (nonatomic,strong)NSString    *alipay;
// 账户中心的现货开户
@property (nonatomic,strong)NSString    *cots;
// K线是否显示
@property (nonatomic,strong)NSString    *kline;


//是否清仓
-(BOOL)isClear;
//是否显示支付宝
-(BOOL)isShowAlipay;
//是否显示现货开户
-(BOOL)isShowCots;
//是否显示K线
-(BOOL)isShowKline;

@end
