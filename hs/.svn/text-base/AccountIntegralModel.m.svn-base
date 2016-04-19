//
//  AccountIntegralModel.m
//  hs
//
//  Created by RGZ on 15/6/23.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "AccountIntegralModel.h"

@implementation AccountIntegralModel

@synthesize drawIntegralMoney,freezeIntegralMoney,integralDetailArray,integralOrderArray,integralSettleArray,integralOrderPointArray,integralSettlePointArray;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:drawIntegralMoney forKey:@"drawIntegralMoney"];
    [aCoder encodeObject:freezeIntegralMoney forKey:@"freezeIntegralMoney"];
    [aCoder encodeObject:integralDetailArray forKey:@"integralDetailArray"];
    [aCoder encodeObject:integralOrderArray forKey:@"integralOrderArray"];
    [aCoder encodeObject:integralSettleArray forKey:@"integralSettleArray"];
    [aCoder encodeObject:integralOrderPointArray forKey:@"integralOrderPointArray"];
    [aCoder encodeObject:integralSettlePointArray forKey:@"integralSettlePointArray"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.drawIntegralMoney=[aDecoder decodeObjectForKey:@"drawIntegralMoney"];
        self.freezeIntegralMoney=[aDecoder decodeObjectForKey:@"freezeIntegralMoney"];
        self.integralDetailArray=[aDecoder decodeObjectForKey:@"integralDetailArray"];
        self.integralOrderArray=[aDecoder decodeObjectForKey:@"integralOrderArray"];
        self.integralSettleArray=[aDecoder decodeObjectForKey:@"integralSettleArray"];
        self.integralOrderPointArray=[aDecoder decodeObjectForKey:@"integralOrderPointArray"];
        self.integralSettlePointArray=[aDecoder decodeObjectForKey:@"integralSettlePointArray"];
    }
    
    return self;
}

@end
