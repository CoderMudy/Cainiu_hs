//
//  FoyerProductModel.m
//  hs
//
//  Created by PXJ on 15/9/11.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "FoyerProductModel.h"



@implementation FoyerProductModel

@synthesize loddyType,productID,commodityName,vendibility,createDate,creater,weight,advertisement,tag,timeTag,commodityDesc,marketId,imgs,status,instrumentID,instrumentCode,currency,currencyName,currencySign,currencyUnit,multiple,decimalPlaces,marketCode,marketName,marketStatus,timeAndNum,scale,nightTimeAndNum,isDoule,interval,timeline,baseline,tradeDicName,tradeSubDicName,accountCode,minPrice;

+(id)productModelWithDictionary:(NSDictionary*)dictionary;
{
    return [[FoyerProductModel alloc] initWithDictionary:dictionary];
}

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if(self)
    {
        if (dictionary[@"loddyType"] != nil && ![dictionary[@"loddyType"] isKindOfClass:[NSNull class]])
        {
            self.loddyType = [NSString stringWithFormat:@"%@",dictionary[@"loddyType"]];
        }
        else
        {
            self.loddyType = @"";
        }
        if (dictionary[@"id"] != nil && ![dictionary[@"id"] isKindOfClass:[NSNull class]])
        {
            self.productID = [NSString stringWithFormat:@"%@",dictionary[@"id"]];
        }
        else
        {
            self.productID = @"";
        }
        if (dictionary[@"commodityName"] != nil && ![dictionary[@"commodityName"] isKindOfClass:[NSNull class]])
        {
            self.commodityName = [NSString stringWithFormat:@"%@",dictionary[@"commodityName"]];
        }
        else{
            self.commodityName = @"";
        }
        if (dictionary[@"vendibility"] != nil && ![dictionary[@"vendibility"] isKindOfClass:[NSNull class]])
        {
            self.vendibility = [NSString stringWithFormat:@"%@",dictionary[@"vendibility"]];
        }
        else
        {
            self.vendibility = @"";
        }
        if (dictionary[@"createDate"] != nil && ![dictionary[@"createDate"] isKindOfClass:[NSNull class]])
        {
            self.createDate = [NSString stringWithFormat:@"%@",dictionary[@"createDate"]];
        }
        else
        {
            self.createDate = @"";
        }
        if (dictionary[@"creater"] != nil && ![dictionary[@"creater"] isKindOfClass:[NSNull class]])
        {
            self.creater = [NSString stringWithFormat:@"%@",dictionary[@"creater"]];
        }
        else
        {
            self.creater = @"";
        }
        if (dictionary[@"weight"] != nil && ![dictionary[@"weight"] isKindOfClass:[NSNull class]])
        {
            self.weight = [NSString stringWithFormat:@"%@",dictionary[@"weight"]];
        }
        else
        {
            self.weight = @"";
        }
        if (dictionary[@"advertisement"] != nil && ![dictionary[@"advertisement"] isKindOfClass:[NSNull class]])
        {
            self.advertisement = [NSString stringWithFormat:@"%@",dictionary[@"advertisement"]];
        }
        else
        {
            self.advertisement = @"";
        }
        if (dictionary[@"tag"] != nil && ![dictionary[@"tag"] isKindOfClass:[NSNull class]])
        {
            self.tag = [NSString stringWithFormat:@"%@",dictionary[@"tag"]];
        }
        else
        {
            self.tag = @"";
        }
        if (dictionary[@"timeTag"] != nil && ![dictionary[@"timeTag"] isKindOfClass:[NSNull class]])
        {
            self.timeTag = [NSString stringWithFormat:@"%@",dictionary[@"timeTag"]];
        }
        else
        {
            self.timeTag = @"";
        }
        if (dictionary[@"commodityDesc"] != nil && ![dictionary[@"commodityDesc"] isKindOfClass:[NSNull class]])
        {
            self.commodityDesc = [NSString stringWithFormat:@"%@",dictionary[@"commodityDesc"]];
        }
        else
        {
            self.commodityDesc = @"";
        }
        if (dictionary[@"marketId"] != nil && ![dictionary[@"marketId"] isKindOfClass:[NSNull class]])
        {
            self.marketId = [NSString stringWithFormat:@"%@",dictionary[@"marketId"]];
        }
        else
        {
            self.marketId = @"";
        }
        if (dictionary[@"imgs"] != nil && ![dictionary[@"imgs"] isKindOfClass:[NSNull class]])
        {
            self.imgs = [NSString stringWithFormat:@"%@",dictionary[@"imgs"]];
        }
        else
        {
            self.imgs = @"";
        }
        
        if (dictionary[@"status"] != nil && ![dictionary[@"status"] isKindOfClass:[NSNull class]])
        {
            self.status = [NSString stringWithFormat:@"%@",dictionary[@"status"]];
        }
        else
        {
            self.status = @"";
        }
        if (dictionary[@"instrumentID"] != nil && ![dictionary[@"instrumentID"] isKindOfClass:[NSNull class]])
        {
            self.instrumentID = [NSString stringWithFormat:@"%@",dictionary[@"instrumentID"]];
        }
        else
        {
            self.instrumentID = @"";
        }
        if (dictionary[@"instrumentCode"] != nil && ![dictionary[@"instrumentCode"] isKindOfClass:[NSNull class]])
        {
            self.instrumentCode = [NSString stringWithFormat:@"%@",dictionary[@"instrumentCode"]];
        }
        else
        {
            self.instrumentCode = @"";
        }
        if (dictionary[@"currency"] != nil && ![dictionary[@"currency"] isKindOfClass:[NSNull class]])
        {
            self.currency = [NSString stringWithFormat:@"%@",dictionary[@"currency"]];
        }
        else
        {
            self.currency = @"";
        }
        if (dictionary[@"currencyName"] != nil && ![dictionary[@"currencyName"] isKindOfClass:[NSNull class]])
        {
            self.currencyName = [NSString stringWithFormat:@"%@",dictionary[@"currencyName"]];
        }
        else
        {
            self.currencyName = @"";
        }
        if (dictionary[@"currencySign"] != nil && ![dictionary[@"currencySign"] isKindOfClass:[NSNull class]])
        {
            self.currencySign = [NSString stringWithFormat:@"%@",dictionary[@"currencySign"]];
        }
        else
        {
            self.currencySign = @"";
        }
        if (dictionary[@"currencyUnit"] != nil && ![dictionary[@"currencyUnit"] isKindOfClass:[NSNull class]])
        {
            self.currencyUnit = [NSString stringWithFormat:@"%@",dictionary[@"currencyUnit"]];
        }
        else
        {
            self.currencyUnit = @"";
        }
        if (dictionary[@"multiple"] != nil && ![dictionary[@"multiple"] isKindOfClass:[NSNull class]])
        {
            self.multiple = [NSString stringWithFormat:@"%@",dictionary[@"multiple"]];
        }
        else
        {
            self.multiple = @"";
        }
        if (dictionary[@"decimalPlaces"] != nil && ![dictionary[@"decimalPlaces"] isKindOfClass:[NSNull class]])
        {
            self.decimalPlaces = [NSString stringWithFormat:@"%@",dictionary[@"decimalPlaces"]];
        }
        else
        {
            self.decimalPlaces = @"";
        }
        if (dictionary[@"baseline"] != nil && ![dictionary[@"baseline"] isKindOfClass:[NSNull class]])
        {
            self.baseline = [NSString stringWithFormat:@"%@",dictionary[@"baseline"]];
        }
        else
        {
            self.baseline = @"";
        }
        if (dictionary[@"timeline"] != nil && ![dictionary[@"timeline"] isKindOfClass:[NSNull class]])
        {
            self.timeline = [NSString stringWithFormat:@"%@",dictionary[@"timeline"]];
        }
        else
        {
            self.timeline = @"";
        }
        if (dictionary[@"interval"] != nil && ![dictionary[@"interval"] isKindOfClass:[NSNull class]])
        {
            self.interval = [NSString stringWithFormat:@"%@",dictionary[@"interval"]];
        }
        else
        {
            self.interval = @"";
        }
        if (dictionary[@"isDoule"] != nil && ![dictionary[@"isDoule"] isKindOfClass:[NSNull class]])
        {
            self.isDoule = [NSString stringWithFormat:@"%@",dictionary[@"isDoule"]];
        }
        else
        {
            self.isDoule = @"";
        }
        if (dictionary[@"nightTimeAndNum"] != nil && ![dictionary[@"nightTimeAndNum"] isKindOfClass:[NSNull class]])
        {
            self.nightTimeAndNum = [NSString stringWithFormat:@"%@",dictionary[@"nightTimeAndNum"]];
        }
        else
        {
            self.nightTimeAndNum = @"";
        }
        if (dictionary[@"scale"] != nil && ![dictionary[@"scale"] isKindOfClass:[NSNull class]])
        {
            self.scale = [NSString stringWithFormat:@"%@",dictionary[@"scale"]];
        }
        else
        {
            self.scale = @"";
        }
        if (dictionary[@"timeAndNum"] != nil && ![dictionary[@"timeAndNum"] isKindOfClass:[NSNull class]])
        {
            self.timeAndNum = [NSString stringWithFormat:@"%@",dictionary[@"timeAndNum"]];
        }
        else
        {
            self.timeAndNum = @"";
        }
        if (dictionary[@"marketCode"] != nil && ![dictionary[@"marketCode"] isKindOfClass:[NSNull class]])
        {
            self.marketCode = [NSString stringWithFormat:@"%@",dictionary[@"marketCode"]];
        }
        else
        {
            self.marketCode = @"";
        }
        if (dictionary[@"marketStatus"] != nil && ![dictionary[@"marketStatus"] isKindOfClass:[NSNull class]])
        {
            self.marketStatus = [NSString stringWithFormat:@"%@",dictionary[@"marketStatus"]];
        }
        else
        {
            self.marketStatus = @"";
        }
        if (dictionary[@"marketName"] != nil && ![dictionary[@"marketName"] isKindOfClass:[NSNull class]])
        {
            self.marketName = [NSString stringWithFormat:@"%@",dictionary[@"marketName"]];
        }
        else
        {
            self.marketName = @"";
        }
        
        if (dictionary[@"accountCode"] != nil && ![dictionary[@"accountCode"] isKindOfClass:[NSNull class]])
        {
            self.accountCode = [NSString stringWithFormat:@"%@",dictionary[@"accountCode"]];
        }
        else
        {
            self.accountCode = @"";
        }
        if (dictionary[@"minPrice"] != nil && ![dictionary[@"minPrice"] isKindOfClass:[NSNull class]])
        {
            self.minPrice = [NSString stringWithFormat:@"%@",dictionary[@"minPrice"]];
        }
        else
        {
            self.minPrice = @"";
        }
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:productID      forKey:@"id"];
    [aCoder encodeObject:commodityName  forKey:@"commodityName"];
    [aCoder encodeObject:vendibility    forKey:@"vendibility"];
    [aCoder encodeObject:createDate     forKey:@"createDate"];
    [aCoder encodeObject:creater        forKey:@"creater"];
    [aCoder encodeObject:weight         forKey:@"weight"];
    [aCoder encodeObject:advertisement  forKey:@"advertisement"];
    [aCoder encodeObject:tag            forKey:@"tag"];
    [aCoder encodeObject:timeTag        forKey:@"timeTag"];
    [aCoder encodeObject:commodityDesc  forKey:@"commodityDesc"];
    [aCoder encodeObject:marketId       forKey:@"marketId"];
    [aCoder encodeObject:imgs           forKey:@"imgs"];
    [aCoder encodeObject:status         forKey:@"status"];
    [aCoder encodeObject:instrumentID   forKey:@"instrumentID"];
    [aCoder encodeObject:instrumentCode forKey:@"instrumentCode"];
    [aCoder encodeObject:currency       forKey:@"currency"];
    [aCoder encodeObject:currencyName   forKey:@"currencyName"];
    [aCoder encodeObject:currencySign   forKey:@"currencySign"];
    [aCoder encodeObject:currencyUnit   forKey:@"currencyUnit"];
    [aCoder encodeObject:multiple       forKey:@"multiple"];
    [aCoder encodeObject:decimalPlaces  forKey:@"decimalPlaces"];
    [aCoder encodeObject:baseline       forKey:@"baseline"];
    [aCoder encodeObject:timeline       forKey:@"timeline"];
    [aCoder encodeObject:interval       forKey:@"interval"];
    [aCoder encodeObject:isDoule        forKey:@"isDoule"];
    [aCoder encodeObject:nightTimeAndNum forKey:@"nightTimeAndNum"];
    [aCoder encodeObject:scale          forKey:@"scale"];
    [aCoder encodeObject:timeAndNum     forKey:@"timeAndNum"];
    [aCoder encodeObject:marketCode     forKey:@"marketCode"];
    [aCoder encodeObject:marketName     forKey:@"marketName"];
    [aCoder encodeObject:marketStatus   forKey:@"marketStatus"];
    [aCoder encodeObject:loddyType      forKey:@"loddyType"];
    [aCoder encodeObject:tradeDicName   forKey:@"tradeDicName"];
    [aCoder encodeObject:tradeSubDicName forKey:@"tradeSubDicName"];
    [aCoder encodeObject:accountCode    forKey:@"accountCode"];
    [aCoder encodeObject:minPrice       forKey:@"minPrice"];

}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.productID      =[aDecoder decodeObjectForKey:@"id"];
        self.commodityName  =[aDecoder decodeObjectForKey:@"commodityName"];
        self.vendibility    =[aDecoder decodeObjectForKey:@"vendibility"];
        self.createDate     =[aDecoder decodeObjectForKey:@"createdate"];
        self.creater        =[aDecoder decodeObjectForKey:@"creater"];
        self.weight         =[aDecoder decodeObjectForKey:@"weight"];
        self.advertisement  =[aDecoder decodeObjectForKey:@"advertisement"];
        self.tag            =[aDecoder decodeObjectForKey:@"tag"];
        self.timeTag        =[aDecoder decodeObjectForKey:@"timeTag"];
        self.commodityDesc  =[aDecoder decodeObjectForKey:@"commodityDesc"];
        self.marketId       =[aDecoder decodeObjectForKey:@"marketId"];
        self.imgs           =[aDecoder decodeObjectForKey:@"imgs"];
        self.status         =[aDecoder decodeObjectForKey:@"status"];
        self.instrumentID   =[aDecoder decodeObjectForKey:@"instrumentID"];
        self.instrumentCode =[aDecoder decodeObjectForKey:@"instrumentCode"];
        self.currency       =[aDecoder decodeObjectForKey:@"currency"];
        self.currencyName   =[aDecoder decodeObjectForKey:@"currencyName"];
        self.currencySign   =[aDecoder decodeObjectForKey:@"currencySign"];
        self.currencyUnit   =[aDecoder decodeObjectForKey:@"currencyUnit"];
        self.multiple       =[aDecoder decodeObjectForKey:@"multiple"];
        self.decimalPlaces  =[aDecoder decodeObjectForKey:@"decimalPlaces"];
        self.baseline       =[aDecoder decodeObjectForKey:@"baseline"];
        self.timeline       =[aDecoder decodeObjectForKey:@"timeline"];
        self.interval       =[aDecoder decodeObjectForKey:@"interval"];
        self.isDoule        =[aDecoder decodeObjectForKey:@"isDoule"];
        self.nightTimeAndNum=[aDecoder decodeObjectForKey:@"nightTimeAndNum"];
        self.scale          =[aDecoder decodeObjectForKey:@"scale"];
        self.timeAndNum     =[aDecoder decodeObjectForKey:@"timeAndNum"];
        self.marketCode     =[aDecoder decodeObjectForKey:@"marketCode"];
        self.marketName     =[aDecoder decodeObjectForKey:@"marketName"];
        self.marketStatus   =[aDecoder decodeObjectForKey:@"marketStatus"];
        self.loddyType      =[aDecoder decodeObjectForKey:@"loddyType"];
        self.tradeDicName   =[aDecoder decodeObjectForKey:@"tradeDicName"];
        self.tradeSubDicName=[aDecoder decodeObjectForKey:@"tradeSubDicName"];
        self.accountCode    =[aDecoder decodeObjectForKey:@"accountCode"];
        self.minPrice       =[aDecoder decodeObjectForKey:@"minPrice"];

    }
    
    return self;
}



@end
