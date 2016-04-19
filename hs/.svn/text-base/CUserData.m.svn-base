//
//  CUserData.m
//  hs
//
//  Created by hzl on 15-4-23.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import "CUserData.h"

@implementation CUserData

+ (instancetype)sharedInstance
{
    static id sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CUserData alloc] init];
    });
    
    return sharedInstance;
}

-(NSMutableDictionary *)userdata
{
    if(_userdata == nil)
    {
        _userdata = [[NSMutableDictionary alloc] init];
    }
    
    return  _userdata;
}

-(NSString *) userSecret
{
    return  self.userdata[@"userSecret"];
}
-(NSString *) userToken
{
     return  self.userdata[@"userToken"];
}
-(BOOL)       isdeline
{
    return  ([self.userdata[@"isdeline"]  isEqual: @1] ? TRUE : FALSE);
}

@end
