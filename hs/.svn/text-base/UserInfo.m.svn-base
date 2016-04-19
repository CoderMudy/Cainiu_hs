//
//  UserInfo.m
//  hs
//
//  Created by RGZ on 15/6/15.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
@synthesize userNickStatus,userNickUpdateDate,userGestureIsOpenidLogin,userGestureIsSetPWD,userGestureIsStart,userTokenIsDeline,userTokenToken,userTokenUserID,userTokenUserSecret,userUserInfoBirth,userUserInfoCLS,userUserInfoHeadPic,userUserInfoName,userUserInfoNick,userUserInfoSex,userUserInfoSign,userUserInfoTele,userUserInfoAddress,userUserInfoCity,userUserInfoProvice,userUserInfoRegDate,userUserInfoRegion;


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:userNickStatus forKey:@"userNickStatus"];
    [aCoder encodeObject:userNickUpdateDate forKey:@"userNickUpdateDate"];
    [aCoder encodeObject:userGestureIsOpenidLogin forKey:@"userGestureIsOpenidLogin"];
    [aCoder encodeObject:userGestureIsSetPWD forKey:@"userGestureIsSetPWD"];
    [aCoder encodeObject:userGestureIsStart forKey:@"userGestureIsStart"];
    [aCoder encodeObject:userTokenIsDeline forKey:@"userTokenIsDeline"];
    [aCoder encodeObject:userTokenToken forKey:@"userTokenToken"];
    [aCoder encodeObject:userTokenUserID forKey:@"userTokenUserID"];
    [aCoder encodeObject:userTokenUserSecret forKey:@"userTokenUserSecret"];
    [aCoder encodeObject:userUserInfoBirth forKey:@"userUserInfoBirth"];
    
    [aCoder encodeObject:userUserInfoCLS forKey:@"userUserInfoCLS"];
    [aCoder encodeObject:userUserInfoHeadPic forKey:@"userUserInfoHeadPic"];
    [aCoder encodeObject:userUserInfoName forKey:@"userUserInfoName"];
    [aCoder encodeObject:userUserInfoNick forKey:@"userUserInfoNick"];
    [aCoder encodeObject:userUserInfoSex forKey:@"userUserInfoSex"];
    [aCoder encodeObject:userUserInfoSign forKey:@"userUserInfoSign"];
    [aCoder encodeObject:userUserInfoTele forKey:@"userUserInfoTele"];
    [aCoder encodeObject:userUserInfoAddress forKey:@"userUserInfoAddress"];
    [aCoder encodeObject:userUserInfoCity forKey:@"userUserInfoCity"];
    [aCoder encodeObject:userUserInfoProvice forKey:@"userUserInfoProvice"];
    [aCoder encodeObject:userUserInfoRegDate forKey:@"userUserInfoRegDate"];
    [aCoder encodeObject:userUserInfoRegion forKey:@"userUserInfoRegion"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.userNickStatus=[aDecoder decodeObjectForKey:@"userNickStatus"];
        self.userNickUpdateDate=[aDecoder decodeObjectForKey:@"userNickUpdateDate"];
        self.userGestureIsOpenidLogin=[aDecoder decodeObjectForKey:@"userGestureIsOpenidLogin"];
        self.userGestureIsSetPWD=[aDecoder decodeObjectForKey:@"userGestureIsSetPWD"];
        self.userGestureIsStart=[aDecoder decodeObjectForKey:@"userGestureIsStart"];
        self.userTokenIsDeline=[aDecoder decodeObjectForKey:@"userTokenIsDeline"];
        self.userTokenToken=[aDecoder decodeObjectForKey:@"userTokenToken"];
        self.userTokenUserID=[aDecoder decodeObjectForKey:@"userTokenUserID"];
        self.userTokenUserSecret=[aDecoder decodeObjectForKey:@"userTokenUserSecret"];
        self.userUserInfoBirth=[aDecoder decodeObjectForKey:@"userUserInfoBirth"];
        
        self.userUserInfoCLS=[aDecoder decodeObjectForKey:@"userUserInfoCLS"];
        self.userUserInfoHeadPic=[aDecoder decodeObjectForKey:@"userUserInfoHeadPic"];
        self.userUserInfoName=[aDecoder decodeObjectForKey:@"userUserInfoName"];
        self.userUserInfoNick=[aDecoder decodeObjectForKey:@"userUserInfoNick"];
        self.userUserInfoSex=[aDecoder decodeObjectForKey:@"userUserInfoSex"];
        self.userUserInfoSign=[aDecoder decodeObjectForKey:@"userUserInfoSign"];
        self.userUserInfoTele=[aDecoder decodeObjectForKey:@"userUserInfoTele"];
        self.userUserInfoAddress=[aDecoder decodeObjectForKey:@"userUserInfoAddress"];
        self.userUserInfoCity=[aDecoder decodeObjectForKey:@"userUserInfoCity"];
        self.userUserInfoProvice=[aDecoder decodeObjectForKey:@"userUserInfoProvice"];
        self.userUserInfoRegDate=[aDecoder decodeObjectForKey:@"userUserInfoRegDate"];
        self.userUserInfoRegion=[aDecoder decodeObjectForKey:@"userUserInfoRegion"];
    }
    
    return self;
}

@end
