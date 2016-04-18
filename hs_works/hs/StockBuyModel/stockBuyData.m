//
//  stockBuyData.m
//
//  Created by   on 15/5/7
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "stockBuyData.h"


NSString *const kstockBuyDataBuyType = @"buy_type";
NSString *const kstockBuyDataQuantity = @"quantity";
NSString *const kstockBuyDataStockCode = @"stock_code";
NSString *const kstockBuyDataOpId = @"op_id";
NSString *const kstockBuyDataPlate = @"plate";
NSString *const kstockBuyDataLossAmt = @"loss_amt";
NSString *const kstockBuyDataMarketType = @"market_type";
NSString *const kstockBuyDataStockCom = @"stock_com";
NSString *const kstockBuyDataProType = @"pro_type";


@interface stockBuyData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation stockBuyData

@synthesize buyType = _buyType;
@synthesize quantity = _quantity;
@synthesize stockCode = _stockCode;
@synthesize opId = _opId;
@synthesize plate = _plate;
@synthesize lossAmt = _lossAmt;
@synthesize marketType = _marketType;
@synthesize stockCom = _stockCom;
@synthesize proType = _proType;


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
            self.buyType = [self objectOrNilForKey:kstockBuyDataBuyType fromDictionary:dict];
            self.quantity = [self objectOrNilForKey:kstockBuyDataQuantity fromDictionary:dict];
            self.stockCode = [self objectOrNilForKey:kstockBuyDataStockCode fromDictionary:dict];
            self.opId = [[self objectOrNilForKey:kstockBuyDataOpId fromDictionary:dict] doubleValue];
            self.plate = [self objectOrNilForKey:kstockBuyDataPlate fromDictionary:dict];
            self.lossAmt = [[self objectOrNilForKey:kstockBuyDataLossAmt fromDictionary:dict] doubleValue];
            self.marketType = [self objectOrNilForKey:kstockBuyDataMarketType fromDictionary:dict];
            self.stockCom = [self objectOrNilForKey:kstockBuyDataStockCom fromDictionary:dict];
            self.proType = [self objectOrNilForKey:kstockBuyDataProType fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.buyType forKey:kstockBuyDataBuyType];
    [mutableDict setValue:self.quantity forKey:kstockBuyDataQuantity];
    [mutableDict setValue:self.stockCode forKey:kstockBuyDataStockCode];
    [mutableDict setValue:[NSNumber numberWithDouble:self.opId] forKey:kstockBuyDataOpId];
    [mutableDict setValue:self.plate forKey:kstockBuyDataPlate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lossAmt] forKey:kstockBuyDataLossAmt];
    [mutableDict setValue:self.marketType forKey:kstockBuyDataMarketType];
    [mutableDict setValue:self.stockCom forKey:kstockBuyDataStockCom];
    [mutableDict setValue:self.proType forKey:kstockBuyDataProType];

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

    self.buyType = [aDecoder decodeObjectForKey:kstockBuyDataBuyType];
    self.quantity = [aDecoder decodeObjectForKey:kstockBuyDataQuantity];
    self.stockCode = [aDecoder decodeObjectForKey:kstockBuyDataStockCode];
    self.opId = [aDecoder decodeDoubleForKey:kstockBuyDataOpId];
    self.plate = [aDecoder decodeObjectForKey:kstockBuyDataPlate];
    self.lossAmt = [aDecoder decodeDoubleForKey:kstockBuyDataLossAmt];
    self.marketType = [aDecoder decodeObjectForKey:kstockBuyDataMarketType];
    self.stockCom = [aDecoder decodeObjectForKey:kstockBuyDataStockCom];
    self.proType = [aDecoder decodeObjectForKey:kstockBuyDataProType];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_buyType forKey:kstockBuyDataBuyType];
    [aCoder encodeObject:_quantity forKey:kstockBuyDataQuantity];
    [aCoder encodeObject:_stockCode forKey:kstockBuyDataStockCode];
    [aCoder encodeDouble:_opId forKey:kstockBuyDataOpId];
    [aCoder encodeObject:_plate forKey:kstockBuyDataPlate];
    [aCoder encodeDouble:_lossAmt forKey:kstockBuyDataLossAmt];
    [aCoder encodeObject:_marketType forKey:kstockBuyDataMarketType];
    [aCoder encodeObject:_stockCom forKey:kstockBuyDataStockCom];
    [aCoder encodeObject:_proType forKey:kstockBuyDataProType];
}

- (id)copyWithZone:(NSZone *)zone
{
    stockBuyData *copy = [[stockBuyData alloc] init];
    
    if (copy) {

        copy.buyType = [self.buyType copyWithZone:zone];
        copy.quantity = [self.quantity copyWithZone:zone];
        copy.stockCode = [self.stockCode copyWithZone:zone];
        copy.opId = self.opId;
        copy.plate = [self.plate copyWithZone:zone];
        copy.lossAmt = self.lossAmt;
        copy.marketType = [self.marketType copyWithZone:zone];
        copy.stockCom = [self.stockCom copyWithZone:zone];
        copy.proType = [self.proType copyWithZone:zone];
    }
    
    return copy;
}


@end
