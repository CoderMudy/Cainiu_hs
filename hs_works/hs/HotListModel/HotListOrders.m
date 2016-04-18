//
//  HotListOrders.m
//
//  Created by   on 15/5/7
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "HotListOrders.h"


NSString *const kHotListOrdersStockCompany = @"stockCompany";
NSString *const kHotListOrdersNickName = @"nickName";
NSString *const kHotListOrdersStockType = @"stockType";
NSString *const kHotListOrdersRankScore = @"rankScore";
NSString *const kHotListOrdersMarketValue = @"marketValue";
NSString *const kHotListOrdersBuyCount = @"buyCount";
NSString *const kHotListOrdersCurScoreAmt = @"curScoreAmt";
NSString *const kHotListOrdersStockCode = @"stockCode";
NSString *const kHotListOrdersCurCashAmt = @"curCashAmt";
NSString *const kHotListOrdersBuyPrice = @"buyPrice";
NSString *const kHotListOrdersBuyScore = @"buyScore";
NSString *const kHotListOrdersBuyType = @"buyType";
NSString *const kHotListOrdersProductType = @"productType";
NSString *const kHotListOrdersStockPlate = @"stockPlate";
NSString *const kHotListOrdersOpenPrice = @"openPrice";
NSString *const kHotListOrdersQuatity = @"quatity";
NSString *const kHotListOrdersOrderdetailId = @"orderdetailId";
NSString *const kHotListOrdersCreateDate = @"createDate";
NSString *const kHotListOrdersCurPrice = @"curPrice";
NSString *const kHotListOrdersOrderId = @"orderId";
NSString *const kHotListOrdersIncomeRate = @"incomeRate";


@interface HotListOrders ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HotListOrders

@synthesize stockCompany = _stockCompany;
@synthesize nickName = _nickName;
@synthesize stockType = _stockType;
@synthesize rankScore = _rankScore;
@synthesize marketValue = _marketValue;
@synthesize buyCount = _buyCount;
@synthesize curScoreAmt = _curScoreAmt;
@synthesize stockCode = _stockCode;
@synthesize curCashAmt = _curCashAmt;
@synthesize buyPrice = _buyPrice;
@synthesize buyScore = _buyScore;
@synthesize buyType = _buyType;
@synthesize productType = _productType;
@synthesize stockPlate = _stockPlate;
@synthesize openPrice = _openPrice;
@synthesize quatity = _quatity;
@synthesize orderdetailId = _orderdetailId;
@synthesize createDate = _createDate;
@synthesize curPrice = _curPrice;
@synthesize orderId = _orderId;
@synthesize incomeRate = _incomeRate;


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
            self.stockCompany = [self objectOrNilForKey:kHotListOrdersStockCompany fromDictionary:dict];
            self.nickName = [self objectOrNilForKey:kHotListOrdersNickName fromDictionary:dict];
            self.stockType = [self objectOrNilForKey:kHotListOrdersStockType fromDictionary:dict];
            self.rankScore = [[self objectOrNilForKey:kHotListOrdersRankScore fromDictionary:dict] doubleValue];
            self.marketValue = [self objectOrNilForKey:kHotListOrdersMarketValue fromDictionary:dict];
            self.buyCount = [self objectOrNilForKey:kHotListOrdersBuyCount fromDictionary:dict];
            self.curScoreAmt = [self objectOrNilForKey:kHotListOrdersCurScoreAmt fromDictionary:dict];
            self.stockCode = [self objectOrNilForKey:kHotListOrdersStockCode fromDictionary:dict];
            self.curCashAmt = [self objectOrNilForKey:kHotListOrdersCurCashAmt fromDictionary:dict];
            self.buyPrice = [self objectOrNilForKey:kHotListOrdersBuyPrice fromDictionary:dict];
            self.buyScore = [self objectOrNilForKey:kHotListOrdersBuyScore fromDictionary:dict];
            self.buyType = [self objectOrNilForKey:kHotListOrdersBuyType fromDictionary:dict];
            self.productType = [self objectOrNilForKey:kHotListOrdersProductType fromDictionary:dict];
            self.stockPlate = [self objectOrNilForKey:kHotListOrdersStockPlate fromDictionary:dict];
            self.openPrice = [self objectOrNilForKey:kHotListOrdersOpenPrice fromDictionary:dict];
            self.quatity = [self objectOrNilForKey:kHotListOrdersQuatity fromDictionary:dict];
            self.orderdetailId = [self objectOrNilForKey:kHotListOrdersOrderdetailId fromDictionary:dict];
            self.createDate = [self objectOrNilForKey:kHotListOrdersCreateDate fromDictionary:dict];
            self.curPrice = [self objectOrNilForKey:kHotListOrdersCurPrice fromDictionary:dict];
            self.orderId = [self objectOrNilForKey:kHotListOrdersOrderId fromDictionary:dict];
            self.incomeRate = [self objectOrNilForKey:kHotListOrdersIncomeRate fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.stockCompany forKey:kHotListOrdersStockCompany];
    [mutableDict setValue:self.nickName forKey:kHotListOrdersNickName];
    [mutableDict setValue:self.stockType forKey:kHotListOrdersStockType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.rankScore] forKey:kHotListOrdersRankScore];
    [mutableDict setValue:self.marketValue forKey:kHotListOrdersMarketValue];
    [mutableDict setValue:self.buyCount forKey:kHotListOrdersBuyCount];
    [mutableDict setValue:self.curScoreAmt forKey:kHotListOrdersCurScoreAmt];
    [mutableDict setValue:self.stockCode forKey:kHotListOrdersStockCode];
    [mutableDict setValue:self.curCashAmt forKey:kHotListOrdersCurCashAmt];
    [mutableDict setValue:self.buyPrice forKey:kHotListOrdersBuyPrice];
    [mutableDict setValue:self.buyScore forKey:kHotListOrdersBuyScore];
    [mutableDict setValue:self.buyType forKey:kHotListOrdersBuyType];
    [mutableDict setValue:self.productType forKey:kHotListOrdersProductType];
    [mutableDict setValue:self.stockPlate forKey:kHotListOrdersStockPlate];
    [mutableDict setValue:self.openPrice forKey:kHotListOrdersOpenPrice];
    [mutableDict setValue:self.quatity forKey:kHotListOrdersQuatity];
    [mutableDict setValue:self.orderdetailId forKey:kHotListOrdersOrderdetailId];
    [mutableDict setValue:self.createDate forKey:kHotListOrdersCreateDate];
    [mutableDict setValue:self.curPrice forKey:kHotListOrdersCurPrice];
    [mutableDict setValue:self.orderId forKey:kHotListOrdersOrderId];
    [mutableDict setValue:self.incomeRate forKey:kHotListOrdersIncomeRate];

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

    self.stockCompany = [aDecoder decodeObjectForKey:kHotListOrdersStockCompany];
    self.nickName = [aDecoder decodeObjectForKey:kHotListOrdersNickName];
    self.stockType = [aDecoder decodeObjectForKey:kHotListOrdersStockType];
    self.rankScore = [aDecoder decodeDoubleForKey:kHotListOrdersRankScore];
    self.marketValue = [aDecoder decodeObjectForKey:kHotListOrdersMarketValue];
    self.buyCount = [aDecoder decodeObjectForKey:kHotListOrdersBuyCount];
    self.curScoreAmt = [aDecoder decodeObjectForKey:kHotListOrdersCurScoreAmt];
    self.stockCode = [aDecoder decodeObjectForKey:kHotListOrdersStockCode];
    self.curCashAmt = [aDecoder decodeObjectForKey:kHotListOrdersCurCashAmt];
    self.buyPrice = [aDecoder decodeObjectForKey:kHotListOrdersBuyPrice];
    self.buyScore = [aDecoder decodeObjectForKey:kHotListOrdersBuyScore];
    self.buyType = [aDecoder decodeObjectForKey:kHotListOrdersBuyType];
    self.productType = [aDecoder decodeObjectForKey:kHotListOrdersProductType];
    self.stockPlate = [aDecoder decodeObjectForKey:kHotListOrdersStockPlate];
    self.openPrice = [aDecoder decodeObjectForKey:kHotListOrdersOpenPrice];
    self.quatity = [aDecoder decodeObjectForKey:kHotListOrdersQuatity];
    self.orderdetailId = [aDecoder decodeObjectForKey:kHotListOrdersOrderdetailId];
    self.createDate = [aDecoder decodeObjectForKey:kHotListOrdersCreateDate];
    self.curPrice = [aDecoder decodeObjectForKey:kHotListOrdersCurPrice];
    self.orderId = [aDecoder decodeObjectForKey:kHotListOrdersOrderId];
    self.incomeRate = [aDecoder decodeObjectForKey:kHotListOrdersIncomeRate];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_stockCompany forKey:kHotListOrdersStockCompany];
    [aCoder encodeObject:_nickName forKey:kHotListOrdersNickName];
    [aCoder encodeObject:_stockType forKey:kHotListOrdersStockType];
    [aCoder encodeDouble:_rankScore forKey:kHotListOrdersRankScore];
    [aCoder encodeObject:_marketValue forKey:kHotListOrdersMarketValue];
    [aCoder encodeObject:_buyCount forKey:kHotListOrdersBuyCount];
    [aCoder encodeObject:_curScoreAmt forKey:kHotListOrdersCurScoreAmt];
    [aCoder encodeObject:_stockCode forKey:kHotListOrdersStockCode];
    [aCoder encodeObject:_curCashAmt forKey:kHotListOrdersCurCashAmt];
    [aCoder encodeObject:_buyPrice forKey:kHotListOrdersBuyPrice];
    [aCoder encodeObject:_buyScore forKey:kHotListOrdersBuyScore];
    [aCoder encodeObject:_buyType forKey:kHotListOrdersBuyType];
    [aCoder encodeObject:_productType forKey:kHotListOrdersProductType];
    [aCoder encodeObject:_stockPlate forKey:kHotListOrdersStockPlate];
    [aCoder encodeObject:_openPrice forKey:kHotListOrdersOpenPrice];
    [aCoder encodeObject:_quatity forKey:kHotListOrdersQuatity];
    [aCoder encodeObject:_orderdetailId forKey:kHotListOrdersOrderdetailId];
    [aCoder encodeObject:_createDate forKey:kHotListOrdersCreateDate];
    [aCoder encodeObject:_curPrice forKey:kHotListOrdersCurPrice];
    [aCoder encodeObject:_orderId forKey:kHotListOrdersOrderId];
    [aCoder encodeObject:_incomeRate forKey:kHotListOrdersIncomeRate];
}

- (id)copyWithZone:(NSZone *)zone
{
    HotListOrders *copy = [[HotListOrders alloc] init];
    
    if (copy) {

        copy.stockCompany = [self.stockCompany copyWithZone:zone];
        copy.nickName = [self.nickName copyWithZone:zone];
        copy.stockType = [self.stockType copyWithZone:zone];
        copy.rankScore = self.rankScore;
        copy.marketValue = [self.marketValue copyWithZone:zone];
        copy.buyCount = [self.buyCount copyWithZone:zone];
        copy.curScoreAmt = [self.curScoreAmt copyWithZone:zone];
        copy.stockCode = [self.stockCode copyWithZone:zone];
        copy.curCashAmt = [self.curCashAmt copyWithZone:zone];
        copy.buyPrice = [self.buyPrice copyWithZone:zone];
        copy.buyScore = [self.buyScore copyWithZone:zone];
        copy.buyType = [self.buyType copyWithZone:zone];
        copy.productType = [self.productType copyWithZone:zone];
        copy.stockPlate = [self.stockPlate copyWithZone:zone];
        copy.openPrice = [self.openPrice copyWithZone:zone];
        copy.quatity = [self.quatity copyWithZone:zone];
        copy.orderdetailId = [self.orderdetailId copyWithZone:zone];
        copy.createDate = [self.createDate copyWithZone:zone];
        copy.curPrice = [self.curPrice copyWithZone:zone];
        copy.orderId = [self.orderId copyWithZone:zone];
        copy.incomeRate = [self.incomeRate copyWithZone:zone];
    }
    
    return copy;
}


@end
