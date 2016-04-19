//
//  IndexOrderChooseModel.m
//  hs
//
//  Created by RGZ on 16/4/13.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "IndexOrderChooseModel.h"

@implementation IndexOrderChooseModel

+(IndexOrderChooseModel *)getOrderChooseDataModelWithInstrumentCode:(NSString *)aCode WithIndexBuyModel:(IndexBuyModel *)aIndexBuyModel;{
    IndexOrderChooseModel *model = [[IndexOrderChooseModel alloc]init];
    NSLog(@"%@",aCode);//MHI  小恒指;SR 白糖 ;pp PP;ru 橡胶； au 金；ag 银；rb 螺纹钢；cu 铜；ni 镍；CL 原油；HSI 恒指
    if ([aCode isEqualToString:@"au"]) {
        model.typeStr = @"黄金";
        model.jump = @"50";
        model.minJump = @"9";
        model.minStopMoney = @"450";
        model.cashFund = @"50";
    }
    else if ([aCode isEqualToString:@"ag"]){
        model.typeStr = @"白银";
        model.jump = @"15";
        model.minJump = @"5";
        model.minStopMoney = @"75";
        model.cashFund = @"15";
    }
    else if ([aCode isEqualToString:@"rb"]){
        model.typeStr = @"螺纹钢";
        model.jump = @"10";
        model.minJump = @"5";
        model.minStopMoney = @"50";
        model.cashFund = @"10";
    }
    else if ([aCode isEqualToString:@"cu"]){
        model.typeStr = @"铜";
        model.jump = @"50";
        model.minJump = @"9";
        model.minStopMoney = @"450";
        model.cashFund = @"50";
    }
    else if ([aCode isEqualToString:@"ni"]){
        model.typeStr = @"镍";
        model.jump = @"10";
        model.minJump = @"8";
        model.minStopMoney = @"80";
        model.cashFund = @"10";
    }
    else if ([aCode isEqualToString:@"ru"]){
        model.typeStr = @"天然橡胶";
        model.jump = @"50";
        model.minJump = @"8";
        model.minStopMoney = @"400";
        model.cashFund = @"50";
    }
    else if ([aCode isEqualToString:@"SR"]){
        model.typeStr = @"白糖";
        model.jump = @"10";
        model.minJump = @"11";
        model.minStopMoney = @"110";
        model.cashFund = @"10";
    }
    else if ([aCode isEqualToString:@"pp"]){
        model.typeStr = @"PP";
        model.jump = @"5";
        model.minJump = @"9";
        model.minStopMoney = @"45";
        model.cashFund = @"5";
    }
    else if ([aCode isEqualToString:@"CL"]){
        model.typeStr = @"美原油";
        model.jump = @"10";
        model.minJump = @"9";
        model.minStopMoney = @"90";
        model.cashFund = @"30";
    }
    else if ([aCode isEqualToString:@"HSI"]){
        model.typeStr = @"恒指";
        model.jump = @"50";
        model.minJump = @"32";
        model.minStopMoney = @"1600";
        model.cashFund = @"400";
    }
    else if ([aCode isEqualToString:@"MHI"]){
        model.typeStr = @"小恒指";
        model.jump = @"10";
        model.minJump = @"32";
        model.minStopMoney = @"320";
        model.cashFund = @"80";
    }
    else if ([aCode isEqualToString:@"GC"]){
        model.typeStr = @"美黄金";
        model.jump = @"10";
        model.minJump = @"12";
        model.minStopMoney = @"120";
        model.cashFund = @"30";
    }
    
    model.highestPrice = aIndexBuyModel.upperLimitPrice;
    model.lowestPrice = aIndexBuyModel.lowerLimitPrice;
    
    return model;
}

@end
