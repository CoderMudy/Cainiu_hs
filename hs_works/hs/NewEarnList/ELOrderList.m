//
//  ELOrderList.m
//
//  Created by   on 15/7/9
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "ELOrderList.h"

NSString *const kELOrderListPreClosePrice = @"preClosePrice";
NSString *const kELOrderListNewPrice = @"newPrice";
NSString *const kELOrderListBuyPrice = @"buyPrice";
NSString *const kELOrderListStockCode = @"stockCode";
NSString *const kELOrderListTradeDayCount = @"tradeDayCount";
NSString *const kELOrderListId = @"id";
NSString *const kELOrderListCashFund = @"cashFund";
NSString *const kELOrderListStockName = @"stockName";
NSString *const kELOrderListFactBuyCount = @"factBuyCount";
NSString *const kELOrderListBuyDate = @"buyDate";
NSString *const kELOrderListFundType = @"fundType";
NSString *const kELOrderListTypeCode = @"typeCode";
NSString *const kELOrderListDisplayId = @"displayId";


@interface ELOrderList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ELOrderList

@synthesize preClosePrice = _preClosePrice;
@synthesize newPrice = _newPrice;
@synthesize buyPrice = _buyPrice;
@synthesize stockCode = _stockCode;
@synthesize tradeDayCount = _tradeDayCount;
@synthesize orderListIdentifier = _orderListIdentifier;
@synthesize cashFund = _cashFund;
@synthesize stockName = _stockName;
@synthesize factBuyCount = _factBuyCount;
@synthesize buyDate = _buyDate;
@synthesize fundType = _fundType;
@synthesize typeCode = _typeCode;
@synthesize displayId = _displayId;


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
        self.preClosePrice = [[self objectOrNilForKey:kELOrderListPreClosePrice fromDictionary:dict] doubleValue];
        self.newPrice = [[self objectOrNilForKey:kELOrderListNewPrice fromDictionary:dict] doubleValue];
            self.buyPrice = [[self objectOrNilForKey:kELOrderListBuyPrice fromDictionary:dict] doubleValue];
            self.stockCode = [self objectOrNilForKey:kELOrderListStockCode fromDictionary:dict];
            self.tradeDayCount = [[self objectOrNilForKey:kELOrderListTradeDayCount fromDictionary:dict] doubleValue];
            self.orderListIdentifier = [[self objectOrNilForKey:kELOrderListId fromDictionary:dict] doubleValue];
            self.cashFund = [[self objectOrNilForKey:kELOrderListCashFund fromDictionary:dict] doubleValue];
            self.stockName = [self objectOrNilForKey:kELOrderListStockName fromDictionary:dict];
            self.factBuyCount = [[self objectOrNilForKey:kELOrderListFactBuyCount fromDictionary:dict] doubleValue];
            self.buyDate = [self objectOrNilForKey:kELOrderListBuyDate fromDictionary:dict];
            self.fundType = [[self objectOrNilForKey:kELOrderListFundType fromDictionary:dict] doubleValue];
            self.typeCode = [self objectOrNilForKey:kELOrderListTypeCode fromDictionary:dict];
            self.displayId = [self objectOrNilForKey:kELOrderListDisplayId fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.preClosePrice] forKey:kELOrderListPreClosePrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.newPrice] forKey:kELOrderListNewPrice];

    [mutableDict setValue:[NSNumber numberWithDouble:self.buyPrice] forKey:kELOrderListBuyPrice];
    [mutableDict setValue:self.stockCode forKey:kELOrderListStockCode];
    [mutableDict setValue:[NSNumber numberWithDouble:self.tradeDayCount] forKey:kELOrderListTradeDayCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderListIdentifier] forKey:kELOrderListId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cashFund] forKey:kELOrderListCashFund];
    [mutableDict setValue:self.stockName forKey:kELOrderListStockName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.factBuyCount] forKey:kELOrderListFactBuyCount];
    [mutableDict setValue:self.buyDate forKey:kELOrderListBuyDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.fundType] forKey:kELOrderListFundType];
    [mutableDict setValue:self.typeCode forKey:kELOrderListTypeCode];
    [mutableDict setValue:self.displayId forKey:kELOrderListDisplayId];

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
    self.preClosePrice = [aDecoder decodeDoubleForKey:kELOrderListPreClosePrice];
    self.newPrice = [aDecoder decodeDoubleForKey:kELOrderListNewPrice];

    self.buyPrice = [aDecoder decodeDoubleForKey:kELOrderListBuyPrice];
    self.stockCode = [aDecoder decodeObjectForKey:kELOrderListStockCode];
    self.tradeDayCount = [aDecoder decodeDoubleForKey:kELOrderListTradeDayCount];
    self.orderListIdentifier = [aDecoder decodeDoubleForKey:kELOrderListId];
    self.cashFund = [aDecoder decodeDoubleForKey:kELOrderListCashFund];
    self.stockName = [aDecoder decodeObjectForKey:kELOrderListStockName];
    self.factBuyCount = [aDecoder decodeDoubleForKey:kELOrderListFactBuyCount];
    self.buyDate = [aDecoder decodeObjectForKey:kELOrderListBuyDate];
    self.fundType = [aDecoder decodeDoubleForKey:kELOrderListFundType];
    self.typeCode = [aDecoder decodeObjectForKey:kELOrderListTypeCode];
    self.displayId = [aDecoder decodeObjectForKey:kELOrderListDisplayId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble:_preClosePrice forKey:kELOrderListPreClosePrice];
    [aCoder encodeDouble:_newPrice forKey:kELOrderListNewPrice];

    [aCoder encodeDouble:_buyPrice forKey:kELOrderListBuyPrice];
    [aCoder encodeObject:_stockCode forKey:kELOrderListStockCode];
    [aCoder encodeDouble:_tradeDayCount forKey:kELOrderListTradeDayCount];
    [aCoder encodeDouble:_orderListIdentifier forKey:kELOrderListId];
    [aCoder encodeDouble:_cashFund forKey:kELOrderListCashFund];
    [aCoder encodeObject:_stockName forKey:kELOrderListStockName];
    [aCoder encodeDouble:_factBuyCount forKey:kELOrderListFactBuyCount];
    [aCoder encodeObject:_buyDate forKey:kELOrderListBuyDate];
    [aCoder encodeDouble:_fundType forKey:kELOrderListFundType];
    [aCoder encodeObject:_typeCode forKey:kELOrderListTypeCode];
    [aCoder encodeObject:_displayId forKey:kELOrderListDisplayId];
}

- (id)copyWithZone:(NSZone *)zone
{
    ELOrderList *copy = [[ELOrderList alloc] init];
    
    if (copy) {
        copy.preClosePrice = self.preClosePrice;
        copy.newPrice = self.newPrice;
        copy.buyPrice = self.buyPrice;
        copy.stockCode = [self.stockCode copyWithZone:zone];
        copy.tradeDayCount = self.tradeDayCount;
        copy.orderListIdentifier = self.orderListIdentifier;
        copy.cashFund = self.cashFund;
        copy.stockName = [self.stockName copyWithZone:zone];
        copy.factBuyCount = self.factBuyCount;
        copy.buyDate = [self.buyDate copyWithZone:zone];
        copy.fundType = self.fundType;
        copy.typeCode = [self.typeCode copyWithZone:zone];
        copy.displayId = [self.displayId copyWithZone:zone];
    }
    
    return copy;
}


@end
