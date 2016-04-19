//
//  UserFinancyInfo.m
//
//  Created by   on 15/5/19
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "UserFinancyInfo.h"


NSString *const kUserFinancyInfoRedbag = @"redbag";
NSString *const kUserFinancyInfoScore = @"score";
NSString *const kUserFinancyInfoProfit = @"profit";
NSString *const kUserFinancyInfoUsedAmt = @"used_amt";
NSString *const kUserFinancyInfoCashFund = @"cash_fund";
NSString *const kUserFinancyInfoFreezeAmt = @"freeze_amt";
NSString *const kUserFinancyInfoUsedDraw = @"used_draw";
NSString *const kUserFinancyInfoCounterFee = @"counter_fee";
NSString *const kUserFinancyInfoStockMarketValue = @"stock_market_value";


@interface UserFinancyInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation UserFinancyInfo

@synthesize redbag = _redbag;
@synthesize score = _score;
@synthesize profit = _profit;
@synthesize usedAmt = _usedAmt;
@synthesize cashFund = _cashFund;
@synthesize freezeAmt = _freezeAmt;
@synthesize usedDraw = _usedDraw;
@synthesize counterFee = _counterFee;
@synthesize stockMarketValue = _stockMarketValue;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.redbag = [self objectOrNilForKey:kUserFinancyInfoRedbag fromDictionary:dict];
            self.score = [self objectOrNilForKey:kUserFinancyInfoScore fromDictionary:dict];
            self.profit = [self objectOrNilForKey:kUserFinancyInfoProfit fromDictionary:dict];
            self.usedAmt = [self objectOrNilForKey:kUserFinancyInfoUsedAmt fromDictionary:dict];
            self.cashFund = [self objectOrNilForKey:kUserFinancyInfoCashFund fromDictionary:dict];
            self.freezeAmt = [self objectOrNilForKey:kUserFinancyInfoFreezeAmt fromDictionary:dict];
            self.usedDraw = [self objectOrNilForKey:kUserFinancyInfoUsedDraw fromDictionary:dict];
            self.counterFee = [self objectOrNilForKey:kUserFinancyInfoCounterFee fromDictionary:dict];
            self.stockMarketValue = [self objectOrNilForKey:kUserFinancyInfoStockMarketValue fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.redbag forKey:kUserFinancyInfoRedbag];
    [mutableDict setValue:self.score forKey:kUserFinancyInfoScore];
    [mutableDict setValue:self.profit forKey:kUserFinancyInfoProfit];
    [mutableDict setValue:self.usedAmt forKey:kUserFinancyInfoUsedAmt];
    [mutableDict setValue:self.cashFund forKey:kUserFinancyInfoCashFund];
    [mutableDict setValue:self.freezeAmt forKey:kUserFinancyInfoFreezeAmt];
    [mutableDict setValue:self.usedDraw forKey:kUserFinancyInfoUsedDraw];
    [mutableDict setValue:self.counterFee forKey:kUserFinancyInfoCounterFee];
    [mutableDict setValue:self.stockMarketValue forKey:kUserFinancyInfoStockMarketValue];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.redbag = [aDecoder decodeObjectForKey:kUserFinancyInfoRedbag];
    self.score = [aDecoder decodeObjectForKey:kUserFinancyInfoScore];
    self.profit = [aDecoder decodeObjectForKey:kUserFinancyInfoProfit];
    self.usedAmt = [aDecoder decodeObjectForKey:kUserFinancyInfoUsedAmt];
    self.cashFund = [aDecoder decodeObjectForKey:kUserFinancyInfoCashFund];
    self.freezeAmt = [aDecoder decodeObjectForKey:kUserFinancyInfoFreezeAmt];
    self.usedDraw = [aDecoder decodeObjectForKey:kUserFinancyInfoUsedDraw];
    self.counterFee = [aDecoder decodeObjectForKey:kUserFinancyInfoCounterFee];
    self.stockMarketValue = [aDecoder decodeObjectForKey:kUserFinancyInfoStockMarketValue];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_redbag forKey:kUserFinancyInfoRedbag];
    [aCoder encodeObject:_score forKey:kUserFinancyInfoScore];
    [aCoder encodeObject:_profit forKey:kUserFinancyInfoProfit];
    [aCoder encodeObject:_usedAmt forKey:kUserFinancyInfoUsedAmt];
    [aCoder encodeObject:_cashFund forKey:kUserFinancyInfoCashFund];
    [aCoder encodeObject:_freezeAmt forKey:kUserFinancyInfoFreezeAmt];
    [aCoder encodeObject:_usedDraw forKey:kUserFinancyInfoUsedDraw];
    [aCoder encodeObject:_counterFee forKey:kUserFinancyInfoCounterFee];
    [aCoder encodeObject:_stockMarketValue forKey:kUserFinancyInfoStockMarketValue];
}

- (id)copyWithZone:(NSZone *)zone
{
    UserFinancyInfo *copy = [[UserFinancyInfo alloc] init];
    
    if (copy) {

        copy.redbag = [self.redbag copyWithZone:zone];
        copy.score = [self.score copyWithZone:zone];
        copy.profit = [self.profit copyWithZone:zone];
        copy.usedAmt = [self.usedAmt copyWithZone:zone];
        copy.cashFund = [self.cashFund copyWithZone:zone];
        copy.freezeAmt = [self.freezeAmt copyWithZone:zone];
        copy.usedDraw = [self.usedDraw copyWithZone:zone];
        copy.counterFee = [self.counterFee copyWithZone:zone];
        copy.stockMarketValue = [self.stockMarketValue copyWithZone:zone];
    }
    
    return copy;
}


@end
