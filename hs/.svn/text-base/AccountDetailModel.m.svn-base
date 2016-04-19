//
//  AccountDetailModel.m
//  hs
//
//  Created by RGZ on 15/6/23.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "AccountDetailModel.h"

@implementation AccountDetailModel

@synthesize drawMoney,freezeMoney,accountDetailArray;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:drawMoney forKey:@"drawMoney"];
    [aCoder encodeObject:freezeMoney forKey:@"freezeMoney"];
    [aCoder encodeObject:accountDetailArray forKey:@"accountDetailArray"];
    
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.drawMoney=[aDecoder decodeObjectForKey:@"drawMoney"];
        self.freezeMoney=[aDecoder decodeObjectForKey:@"freezeMoney"];
        self.accountDetailArray=[aDecoder decodeObjectForKey:@"accountDetailArray"];
        
    }
    
    return self;
}

@end
