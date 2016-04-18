//
//  PrivateUserInfo.m
//  hs
//
//  Created by RGZ on 15/5/21.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "PrivateUserInfo.h"

@implementation PrivateUserInfo

@synthesize statusMobile,statusRealName,statusBankCardBind,mobile,realName,idCard,bankCard,bankName;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:statusMobile forKey:@"statusMobile"];
    [aCoder encodeObject:statusRealName forKey:@"statusRealName"];
    [aCoder encodeObject:statusBankCardBind forKey:@"statusBankCardBind"];
    [aCoder encodeObject:mobile forKey:@"mobile"];
    [aCoder encodeObject:realName forKey:@"realName"];
    [aCoder encodeObject:idCard forKey:@"idCard"];
    [aCoder encodeObject:bankCard forKey:@"bankCard"];
    [aCoder encodeObject:bankName forKey:@"bankName"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.statusMobile=[aDecoder decodeObjectForKey:@"statusMobile"];
        self.statusRealName=[aDecoder decodeObjectForKey:@"statusRealName"];
        self.statusBankCardBind=[aDecoder decodeObjectForKey:@"statusBankCardBind"];
        self.mobile=[aDecoder decodeObjectForKey:@"mobile"];
        self.realName=[aDecoder decodeObjectForKey:@"realName"];
        self.idCard=[aDecoder decodeObjectForKey:@"idCard"];
        self.bankCard=[aDecoder decodeObjectForKey:@"bankCard"];
        self.bankName=[aDecoder decodeObjectForKey:@"bankName"];
    }
    
    return self;
}

@end
