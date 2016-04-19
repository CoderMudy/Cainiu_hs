//
//  AccountIndexModel.m
//  hs
//
//  Created by RGZ on 15/6/23.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "AccountIndexModel.h"

@implementation AccountIndexModel

@synthesize privateUserInfo,accountIntegral,accountMoney,nickName,sign;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:privateUserInfo forKey:@"privateUserInfoprivateUserInfo"];
    [aCoder encodeObject:accountIntegral forKey:@"accountIntegral"];
    [aCoder encodeObject:accountMoney forKey:@"accountMoney"];
    [aCoder encodeObject:nickName forKey:@"nickName"];
    [aCoder encodeObject:sign forKey:@"sign"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.privateUserInfo=[aDecoder decodeObjectForKey:@"privateUserInfoprivateUserInfo"];
        self.accountIntegral=[aDecoder decodeObjectForKey:@"accountIntegral"];
        self.accountMoney=[aDecoder decodeObjectForKey:@"accountMoney"];
        self.nickName=[aDecoder decodeObjectForKey:@"nickName"];
        self.sign=[aDecoder decodeObjectForKey:@"sign"];
    }
    
    return self;
}

@end
