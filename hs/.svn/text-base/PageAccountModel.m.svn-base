//
//  PageAccountModel.m
//  hs
//
//  Created by RGZ on 15/6/23.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "PageAccountModel.h"

@implementation PageAccountModel

@synthesize accountIndexModel,accountDetailModel,accountIntegralModel,accountRecordModel;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    @autoreleasepool {
        [aCoder encodeObject:accountIndexModel forKey:@"accountIndexModel"];
        [aCoder encodeObject:accountDetailModel forKey:@"accountDetailModel"];
        [aCoder encodeObject:accountIntegralModel forKey:@"accountIntegralModel"];
        [aCoder encodeObject:accountRecordModel forKey:@"accountRecordModel"];
    }
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.accountIndexModel=[aDecoder decodeObjectForKey:@"accountIndexModel"];
        self.accountDetailModel=[aDecoder decodeObjectForKey:@"accountDetailModel"];
        self.accountIntegralModel=[aDecoder decodeObjectForKey:@"accountIntegralModel"];
        self.accountRecordModel=[aDecoder decodeObjectForKey:@"accountRecordModel"];
        
    }
    
    return self;
}

@end
