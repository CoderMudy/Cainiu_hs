//
//  PagePayModel.m
//  hs
//
//  Created by RGZ on 15/7/15.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "PagePayModel.h"

@implementation PagePayModel

@synthesize moneyStockArray,integralStockArray;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:moneyStockArray forKey:@"moneyStockArray"];
    [aCoder encodeObject:integralStockArray forKey:@"integralStockArray"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.moneyStockArray=[aDecoder decodeObjectForKey:@"moneyStockArray"];
        self.integralStockArray=[aDecoder decodeObjectForKey:@"integralStockArray"];
    }
    
    return self;
}

@end
