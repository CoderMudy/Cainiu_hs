//
//  SpotgoodsAccount.m
//  hs
//
//  Created by RGZ on 15/11/30.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "SpotgoodsAccount.h"

@implementation SpotgoodsAccount
DEF_SINGLETON(SpotgoodsAccount)

-(NSString *)getSpotgoodsToken{
    
    return self.spotgoodsModel.spotgoodsToken;
}

-(NSString *)getHttpToken{
    return self.spotgoodsModel.httpToken;
}

-(NSString *)getTradeID{
    return self.spotgoodsModel.member;
}

-(BOOL)isNeedLogin{
    if ((self.spotgoodsModel.spotgoodsToken == nil || [self.spotgoodsModel.spotgoodsToken isEqualToString:@""])) {
        return YES;
    }
    else{
        return NO;
    }
}

-(void)clearInfo{
    self.spotgoodsModel.spotgoodsToken = @"";
    self.spotgoodsModel.httpToken      = @"";
    self.spotgoodsModel.password       = @"";
    
    [CacheEngine setSpotgoodsInfoTradeID:@"" Token:@"" HTTPToken:@"" PassWord:@""];
}

-(NSString  *)getUsername{
    return self.spotgoodsModel.member;
}

-(NSString  *)getPassword{
    return self.spotgoodsModel.password;
}

-(BOOL)isNeedRegist{
    if (self.spotgoodsModel.member == nil || [self.spotgoodsModel.member isEqualToString:@""]) {
        return YES;
    }
    else{
        return NO;
    }
}

@end
