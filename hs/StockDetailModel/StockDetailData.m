//
//  StockDetailData.m
//
//  Created by   on 15/5/18
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "StockDetailData.h"


NSString *const kStockDetailDataIncomeRate = @"incomeRate";
NSString *const kStockDetailDataNickName = @"nickName";
NSString *const kStockDetailDataRankScore = @"rankScore";
NSString *const kStockDetailDataMarketValue = @"marketValue";
NSString *const kStockDetailDataBuyCount = @"buyCount";
NSString *const kStockDetailDataStockCode = @"stockCode";
NSString *const kStockDetailDataBuyPrice = @"buyPrice";
NSString *const kStockDetailDataBuyType = @"buyType";
NSString *const kStockDetailDataStockName = @"stockName";
NSString *const kStockDetailDataCurCashProfit = @"curCashProfit";
NSString *const kStockDetailDataOperateAmt = @"operateAmt";
NSString *const kStockDetailDataQuantity = @"quantity";
NSString *const kStockDetailDataOpenPrice = @"openPrice";
NSString *const kStockDetailDataCurScoreProfit = @"curScoreProfit";
NSString *const kStockDetailDataOrderdetailId = @"orderdetailId";
NSString *const kStockDetailDataCreateDate = @"createDate";
NSString *const kStockDetailDataProType = @"proType";
NSString *const kStockDetailDataCurPrice = @"curPrice";
NSString *const kStockDetailDataStockCodeType = @"stockCodeType";
NSString *const kStockDetailDataOrderId = @"orderId";
NSString *const kStockDetailDataUserId = @"userId";


@interface StockDetailData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation StockDetailData

@synthesize incomeRate = _incomeRate;
@synthesize nickName = _nickName;
@synthesize rankScore = _rankScore;
@synthesize marketValue = _marketValue;
@synthesize buyCount = _buyCount;
@synthesize stockCode = _stockCode;
@synthesize buyPrice = _buyPrice;
@synthesize buyType = _buyType;
@synthesize stockName = _stockName;
@synthesize curCashProfit = _curCashProfit;
@synthesize operateAmt = _operateAmt;
@synthesize quantity = _quantity;
@synthesize openPrice = _openPrice;
@synthesize curScoreProfit = _curScoreProfit;
@synthesize orderdetailId = _orderdetailId;
@synthesize createDate = _createDate;
@synthesize proType = _proType;
@synthesize curPrice = _curPrice;
@synthesize stockCodeType = _stockCodeType;
@synthesize orderId = _orderId;
@synthesize userId = _userId;


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
            self.incomeRate = [self objectOrNilForKey:kStockDetailDataIncomeRate fromDictionary:dict];
            self.nickName = [self objectOrNilForKey:kStockDetailDataNickName fromDictionary:dict];
            self.rankScore = [[self objectOrNilForKey:kStockDetailDataRankScore fromDictionary:dict] doubleValue];
            self.marketValue = [[self objectOrNilForKey:kStockDetailDataMarketValue fromDictionary:dict] doubleValue];
            self.buyCount = [[self objectOrNilForKey:kStockDetailDataBuyCount fromDictionary:dict] doubleValue];
            self.stockCode = [self objectOrNilForKey:kStockDetailDataStockCode fromDictionary:dict];
            self.buyPrice = [[self objectOrNilForKey:kStockDetailDataBuyPrice fromDictionary:dict] doubleValue];
            self.buyType = [[self objectOrNilForKey:kStockDetailDataBuyType fromDictionary:dict] doubleValue];
            self.stockName = [self objectOrNilForKey:kStockDetailDataStockName fromDictionary:dict];
            self.curCashProfit = [self objectOrNilForKey:kStockDetailDataCurCashProfit fromDictionary:dict];
            self.operateAmt = [[self objectOrNilForKey:kStockDetailDataOperateAmt fromDictionary:dict] doubleValue];
            self.quantity = [[self objectOrNilForKey:kStockDetailDataQuantity fromDictionary:dict] doubleValue];
            self.openPrice = [[self objectOrNilForKey:kStockDetailDataOpenPrice fromDictionary:dict] doubleValue];
            self.curScoreProfit = [self objectOrNilForKey:kStockDetailDataCurScoreProfit fromDictionary:dict];
            self.orderdetailId = [[self objectOrNilForKey:kStockDetailDataOrderdetailId fromDictionary:dict] doubleValue];
            self.createDate = [self objectOrNilForKey:kStockDetailDataCreateDate fromDictionary:dict];
            self.proType = [self objectOrNilForKey:kStockDetailDataProType fromDictionary:dict];
            self.curPrice = [[self objectOrNilForKey:kStockDetailDataCurPrice fromDictionary:dict] doubleValue];
            self.stockCodeType = [self objectOrNilForKey:kStockDetailDataStockCodeType fromDictionary:dict];
            self.orderId = [[self objectOrNilForKey:kStockDetailDataOrderId fromDictionary:dict] doubleValue];
            self.userId = [[self objectOrNilForKey:kStockDetailDataUserId fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.incomeRate forKey:kStockDetailDataIncomeRate];
    [mutableDict setValue:self.nickName forKey:kStockDetailDataNickName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.rankScore] forKey:kStockDetailDataRankScore];
    [mutableDict setValue:[NSNumber numberWithDouble:self.marketValue] forKey:kStockDetailDataMarketValue];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buyCount] forKey:kStockDetailDataBuyCount];
    [mutableDict setValue:self.stockCode forKey:kStockDetailDataStockCode];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buyPrice] forKey:kStockDetailDataBuyPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buyType] forKey:kStockDetailDataBuyType];
    [mutableDict setValue:self.stockName forKey:kStockDetailDataStockName];
    [mutableDict setValue:self.curCashProfit forKey:kStockDetailDataCurCashProfit];
    [mutableDict setValue:[NSNumber numberWithDouble:self.operateAmt] forKey:kStockDetailDataOperateAmt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.quantity] forKey:kStockDetailDataQuantity];
    [mutableDict setValue:[NSNumber numberWithDouble:self.openPrice] forKey:kStockDetailDataOpenPrice];
    [mutableDict setValue:self.curScoreProfit forKey:kStockDetailDataCurScoreProfit];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderdetailId] forKey:kStockDetailDataOrderdetailId];
    [mutableDict setValue:self.createDate forKey:kStockDetailDataCreateDate];
    [mutableDict setValue:self.proType forKey:kStockDetailDataProType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.curPrice] forKey:kStockDetailDataCurPrice];
    [mutableDict setValue:self.stockCodeType forKey:kStockDetailDataStockCodeType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderId] forKey:kStockDetailDataOrderId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kStockDetailDataUserId];

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

    self.incomeRate = [aDecoder decodeObjectForKey:kStockDetailDataIncomeRate];
    self.nickName = [aDecoder decodeObjectForKey:kStockDetailDataNickName];
    self.rankScore = [aDecoder decodeDoubleForKey:kStockDetailDataRankScore];
    self.marketValue = [aDecoder decodeDoubleForKey:kStockDetailDataMarketValue];
    self.buyCount = [aDecoder decodeDoubleForKey:kStockDetailDataBuyCount];
    self.stockCode = [aDecoder decodeObjectForKey:kStockDetailDataStockCode];
    self.buyPrice = [aDecoder decodeDoubleForKey:kStockDetailDataBuyPrice];
    self.buyType = [aDecoder decodeDoubleForKey:kStockDetailDataBuyType];
    self.stockName = [aDecoder decodeObjectForKey:kStockDetailDataStockName];
    self.curCashProfit = [aDecoder decodeObjectForKey:kStockDetailDataCurCashProfit];
    self.operateAmt = [aDecoder decodeDoubleForKey:kStockDetailDataOperateAmt];
    self.quantity = [aDecoder decodeDoubleForKey:kStockDetailDataQuantity];
    self.openPrice = [aDecoder decodeDoubleForKey:kStockDetailDataOpenPrice];
    self.curScoreProfit = [aDecoder decodeObjectForKey:kStockDetailDataCurScoreProfit];
    self.orderdetailId = [aDecoder decodeDoubleForKey:kStockDetailDataOrderdetailId];
    self.createDate = [aDecoder decodeObjectForKey:kStockDetailDataCreateDate];
    self.proType = [aDecoder decodeObjectForKey:kStockDetailDataProType];
    self.curPrice = [aDecoder decodeDoubleForKey:kStockDetailDataCurPrice];
    self.stockCodeType = [aDecoder decodeObjectForKey:kStockDetailDataStockCodeType];
    self.orderId = [aDecoder decodeDoubleForKey:kStockDetailDataOrderId];
    self.userId = [aDecoder decodeDoubleForKey:kStockDetailDataUserId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_incomeRate forKey:kStockDetailDataIncomeRate];
    [aCoder encodeObject:_nickName forKey:kStockDetailDataNickName];
    [aCoder encodeDouble:_rankScore forKey:kStockDetailDataRankScore];
    [aCoder encodeDouble:_marketValue forKey:kStockDetailDataMarketValue];
    [aCoder encodeDouble:_buyCount forKey:kStockDetailDataBuyCount];
    [aCoder encodeObject:_stockCode forKey:kStockDetailDataStockCode];
    [aCoder encodeDouble:_buyPrice forKey:kStockDetailDataBuyPrice];
    [aCoder encodeDouble:_buyType forKey:kStockDetailDataBuyType];
    [aCoder encodeObject:_stockName forKey:kStockDetailDataStockName];
    [aCoder encodeObject:_curCashProfit forKey:kStockDetailDataCurCashProfit];
    [aCoder encodeDouble:_operateAmt forKey:kStockDetailDataOperateAmt];
    [aCoder encodeDouble:_quantity forKey:kStockDetailDataQuantity];
    [aCoder encodeDouble:_openPrice forKey:kStockDetailDataOpenPrice];
    [aCoder encodeObject:_curScoreProfit forKey:kStockDetailDataCurScoreProfit];
    [aCoder encodeDouble:_orderdetailId forKey:kStockDetailDataOrderdetailId];
    [aCoder encodeObject:_createDate forKey:kStockDetailDataCreateDate];
    [aCoder encodeObject:_proType forKey:kStockDetailDataProType];
    [aCoder encodeDouble:_curPrice forKey:kStockDetailDataCurPrice];
    [aCoder encodeObject:_stockCodeType forKey:kStockDetailDataStockCodeType];
    [aCoder encodeDouble:_orderId forKey:kStockDetailDataOrderId];
    [aCoder encodeDouble:_userId forKey:kStockDetailDataUserId];
}

- (id)copyWithZone:(NSZone *)zone
{
    StockDetailData *copy = [[StockDetailData alloc] init];
    
    if (copy) {

        copy.incomeRate = [self.incomeRate copyWithZone:zone];
        copy.nickName = [self.nickName copyWithZone:zone];
        copy.rankScore = self.rankScore;
        copy.marketValue = self.marketValue;
        copy.buyCount = self.buyCount;
        copy.stockCode = [self.stockCode copyWithZone:zone];
        copy.buyPrice = self.buyPrice;
        copy.buyType = self.buyType;
        copy.stockName = [self.stockName copyWithZone:zone];
        copy.curCashProfit = [self.curCashProfit copyWithZone:zone];
        copy.operateAmt = self.operateAmt;
        copy.quantity = self.quantity;
        copy.openPrice = self.openPrice;
        copy.curScoreProfit = [self.curScoreProfit copyWithZone:zone];
        copy.orderdetailId = self.orderdetailId;
        copy.createDate = [self.createDate copyWithZone:zone];
        copy.proType = [self.proType copyWithZone:zone];
        copy.curPrice = self.curPrice;
        copy.stockCodeType = [self.stockCodeType copyWithZone:zone];
        copy.orderId = self.orderId;
        copy.userId = self.userId;
    }
    
    return copy;
}


@end
