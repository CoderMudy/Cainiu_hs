//
//  CacheModel.m
//  hs
//
//  Created by RGZ on 15/6/23.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "CacheModel.h"
#import "HsRealtime.h"
@implementation CacheModel

@synthesize accountModel,stockDetailArray,positionPrivateIndex,positionPublic,positionPublicIndex,financeIndex,tradeHot,orderIndex,isAgree,payModel,userAmt,searchArray,isAgreeOfAu,socketInfoDic,tradeDic,productSectionArray,reportArray,bannerArray,isOrLogin,imageRenzhengArray,isOrderOrLogin,isQuickOrderOrLogin,isClickLJCN,holidayCacheModel,isFirstSpotIndex,spotgoodsInfo,cashSaleDic;


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:accountModel forKey:@"accountModel"];
    [aCoder encodeObject:positionPrivateIndex forKey:@"positionPrivateIndex"];
    [aCoder encodeObject:stockDetailArray forKey:@"stockDetailArray"];
    [aCoder encodeObject:financeIndex forKey:@"financeIndex"];
    [aCoder encodeObject:tradeHot forKey:@"tradeHot"];
    [aCoder encodeObject:positionPublicIndex forKey:@"positionPublicIndex"];
    [aCoder encodeObject:positionPublic forKey:@"positionPublic"];
    [aCoder encodeObject:orderIndex forKey:@"orderIndex"];
    [aCoder encodeObject:isAgree forKey:@"isAgree"];
    [aCoder encodeObject:isAgreeOfAu forKey:@"isAgreeOfAu"];
    [aCoder encodeObject:payModel forKey:@"payModel"];
    [aCoder encodeInt:userAmt forKey:@"userAmt"];
    [aCoder encodeObject:searchArray forKey:@"searchArray"];
    [aCoder encodeObject:socketInfoDic forKey:@"socketInfoDic"];
    [aCoder encodeObject:tradeDic forKey:@"tradeDic"];
    [aCoder encodeObject:productSectionArray forKey:@"productSectionArray"];
    [aCoder encodeObject:reportArray forKey:@"reportArray"];
    [aCoder encodeObject:bannerArray forKey:@"bannerArray"];
    [aCoder encodeObject:isOrLogin forKey:@"isOrLogin"];
    [aCoder encodeObject:isOrderOrLogin forKey:@"isOrderOrLogin"];
    [aCoder encodeObject:isQuickOrderOrLogin forKey:@"isQuickOrderOrLogin"];
    [aCoder encodeObject:isClickLJCN forKey:@"isClickLJCN"];
    [aCoder encodeObject:holidayCacheModel forKey:@"holidayCacheModel"];
    [aCoder encodeObject:imageRenzhengArray forKey:@"shenFenRenZheng"];
    [aCoder encodeObject:isFirstSpotIndex forKey:@"isFirstSpotIndex"];
    [aCoder encodeObject:spotgoodsInfo forKey:@"spotgoodsInfo"];
    [aCoder encodeObject:cashSaleDic forKey:@"cashSaleDic"];


}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.accountModel           =[aDecoder decodeObjectForKey:@"accountModel"];
        self.positionPrivateIndex   =[aDecoder decodeObjectForKey:@"positionPrivateIndex"];
        self.stockDetailArray       =[aDecoder decodeObjectForKey:@"stockDetailArray"];
        self.financeIndex           =[aDecoder decodeObjectForKey:@"financeIndex"];
        self.tradeHot               =[aDecoder decodeObjectForKey:@"tradeHot"];
        self.positionPublicIndex    =[aDecoder decodeObjectForKey:@"positionPublicIndex"];
        self.positionPublic         =[aDecoder decodeObjectForKey:@"positionPublic"];
        self.orderIndex             =[aDecoder decodeObjectForKey:@"orderIndex"];
        self.isAgree                = [aDecoder decodeObjectForKey:@"isAgree"];
        self.isAgreeOfAu            = [aDecoder decodeObjectForKey:@"isAgreeOfAu"];
        self.payModel               = [aDecoder decodeObjectForKey:@"payModel"];
        self.userAmt                = [aDecoder decodeIntForKey:@"userAmt"];
        self.searchArray            = [aDecoder decodeObjectForKey:@"searchArray"];
        self.productSectionArray    = [aDecoder decodeObjectForKey:@"productSectionArray"];
        self.reportArray            = [aDecoder decodeObjectForKey:@"reportArray"];
        self.bannerArray            = [aDecoder decodeObjectForKey:@"bannerArray"];
        self.isOrLogin              = [aDecoder decodeObjectForKey:@"isOrLogin"];
        self.isOrderOrLogin         = [aDecoder decodeObjectForKey:@"isOrderOrLogin"];
        self.isQuickOrderOrLogin    = [aDecoder decodeObjectForKey:@"isQuickOrderOrLogin"];
        self.isClickLJCN            = [aDecoder decodeObjectForKey:@"isClickLJCN"];
        self.holidayCacheModel      = [aDecoder decodeObjectForKey:@"holidayCacheModel"];
        self.imageRenzhengArray     = [aDecoder decodeObjectForKey:@"shenFenRenZheng"];
        self.isFirstSpotIndex       = [aDecoder decodeObjectForKey:@"isFirstSpotIndex"];
        self.spotgoodsInfo          = [aDecoder decodeObjectForKey:@"spotgoodsInfo"];
        self.cashSaleDic            = [aDecoder decodeObjectForKey:@"cashSaleDic"];
        self.socketInfoDic          = [aDecoder decodeObjectForKey:@"socketInfoDic"];
        self.tradeDic               = [aDecoder decodeObjectForKey:@"tradeDic"];

    }
    
    return self;
}



@end
