//
//  PersonPositionPosiBoList.m
//
//  Created by   on 15/5/10
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "PersonPositionPosiBoList.h"


NSString *const kPersonPositionPosiBoListStockCodeType = @"stockCodeType";
NSString *const kPersonPositionPosiBoListIncomeRate = @"incomeRate";
NSString *const kPersonPositionPosiBoListNickName = @"nickName";
NSString *const kPersonPositionPosiBoListRankScore = @"rankScore";
NSString *const kPersonPositionPosiBoListMarketValue = @"marketValue";
NSString *const kPersonPositionPosiBoListBuyCount = @"buyCount";
NSString *const kPersonPositionPosiBoListStockCode = @"stockCode";
NSString *const kPersonPositionPosiBoListBuyPrice = @"buyPrice";
NSString *const kPersonPositionPosiBoListBuyType = @"buyType";
NSString *const kPersonPositionPosiBoListStockName = @"stockName";
NSString *const kPersonPositionPosiBoListCurCashProfit = @"curCashProfit";
NSString *const kPersonPositionPosiBoListOperateAmt = @"operateAmt";
NSString *const kPersonPositionPosiBoListQuantity = @"quantity";
NSString *const kPersonPositionPosiBoListOpenPrice = @"openPrice";
NSString *const kPersonPositionPosiBoListCounterFee = @"counterFee";
NSString *const kPersonPositionPosiBoListCurScoreProfit = @"curScoreProfit";
NSString *const kPersonPositionPosiBoListOrderdetailId = @"orderdetailId";
NSString *const kPersonPositionPosiBoListCreateDate = @"createDate";
NSString *const kPersonPositionPosiBoListCurPrice = @"curPrice";
NSString *const kPersonPositionPosiBoListProType = @"proType";
NSString *const kPersonPositionPosiBoListLossFund = @"lossFund";
NSString *const kPersonPositionPosiBoListOrderId = @"orderId";
NSString *const kPersonPositionPosiBoListUserId = @"userId";


@interface PersonPositionPosiBoList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PersonPositionPosiBoList

@synthesize stockCodeType = _stockCodeType;
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
@synthesize counterFee = _counterFee;
@synthesize curScoreProfit = _curScoreProfit;
@synthesize orderdetailId = _orderdetailId;
@synthesize createDate = _createDate;
@synthesize curPrice = _curPrice;
@synthesize proType = _proType;
@synthesize lossFund = _lossFund;
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
            self.stockCodeType = [self objectOrNilForKey:kPersonPositionPosiBoListStockCodeType fromDictionary:dict];
            self.incomeRate = [self objectOrNilForKey:kPersonPositionPosiBoListIncomeRate fromDictionary:dict];
            self.nickName = [self objectOrNilForKey:kPersonPositionPosiBoListNickName fromDictionary:dict];
            self.rankScore = [[self objectOrNilForKey:kPersonPositionPosiBoListRankScore fromDictionary:dict] doubleValue];
            self.marketValue = [[self objectOrNilForKey:kPersonPositionPosiBoListMarketValue fromDictionary:dict] doubleValue];
            self.buyCount = [[self objectOrNilForKey:kPersonPositionPosiBoListBuyCount fromDictionary:dict] doubleValue];
            self.stockCode = [self objectOrNilForKey:kPersonPositionPosiBoListStockCode fromDictionary:dict];
            self.buyPrice = [[self objectOrNilForKey:kPersonPositionPosiBoListBuyPrice fromDictionary:dict] doubleValue];
            self.buyType = [[self objectOrNilForKey:kPersonPositionPosiBoListBuyType fromDictionary:dict] doubleValue];
            self.stockName = [self objectOrNilForKey:kPersonPositionPosiBoListStockName fromDictionary:dict];
            self.curCashProfit = [self objectOrNilForKey:kPersonPositionPosiBoListCurCashProfit fromDictionary:dict];
            self.operateAmt = [[self objectOrNilForKey:kPersonPositionPosiBoListOperateAmt fromDictionary:dict] doubleValue];
            self.quantity = [[self objectOrNilForKey:kPersonPositionPosiBoListQuantity fromDictionary:dict] doubleValue];
            self.openPrice = [[self objectOrNilForKey:kPersonPositionPosiBoListOpenPrice fromDictionary:dict] doubleValue];
            self.counterFee = [[self objectOrNilForKey:kPersonPositionPosiBoListCounterFee fromDictionary:dict] doubleValue];
            self.curScoreProfit = [self objectOrNilForKey:kPersonPositionPosiBoListCurScoreProfit fromDictionary:dict];
            self.orderdetailId = [[self objectOrNilForKey:kPersonPositionPosiBoListOrderdetailId fromDictionary:dict] doubleValue];
            self.createDate = [self objectOrNilForKey:kPersonPositionPosiBoListCreateDate fromDictionary:dict];
            self.curPrice = [[self objectOrNilForKey:kPersonPositionPosiBoListCurPrice fromDictionary:dict] doubleValue];
            self.proType = [self objectOrNilForKey:kPersonPositionPosiBoListProType fromDictionary:dict];
            self.lossFund = [[self objectOrNilForKey:kPersonPositionPosiBoListLossFund fromDictionary:dict] doubleValue];
            self.orderId = [[self objectOrNilForKey:kPersonPositionPosiBoListOrderId fromDictionary:dict] doubleValue];
            self.userId = [[self objectOrNilForKey:kPersonPositionPosiBoListUserId fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.stockCodeType forKey:kPersonPositionPosiBoListStockCodeType];
    [mutableDict setValue:self.incomeRate forKey:kPersonPositionPosiBoListIncomeRate];
    [mutableDict setValue:self.nickName forKey:kPersonPositionPosiBoListNickName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.rankScore] forKey:kPersonPositionPosiBoListRankScore];
    [mutableDict setValue:[NSNumber numberWithDouble:self.marketValue] forKey:kPersonPositionPosiBoListMarketValue];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buyCount] forKey:kPersonPositionPosiBoListBuyCount];
    [mutableDict setValue:self.stockCode forKey:kPersonPositionPosiBoListStockCode];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buyPrice] forKey:kPersonPositionPosiBoListBuyPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buyType] forKey:kPersonPositionPosiBoListBuyType];
    [mutableDict setValue:self.stockName forKey:kPersonPositionPosiBoListStockName];
    [mutableDict setValue:self.curCashProfit forKey:kPersonPositionPosiBoListCurCashProfit];
    [mutableDict setValue:[NSNumber numberWithDouble:self.operateAmt] forKey:kPersonPositionPosiBoListOperateAmt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.quantity] forKey:kPersonPositionPosiBoListQuantity];
    [mutableDict setValue:[NSNumber numberWithDouble:self.openPrice] forKey:kPersonPositionPosiBoListOpenPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.counterFee] forKey:kPersonPositionPosiBoListCounterFee];
    [mutableDict setValue:self.curScoreProfit forKey:kPersonPositionPosiBoListCurScoreProfit];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderdetailId] forKey:kPersonPositionPosiBoListOrderdetailId];
    [mutableDict setValue:self.createDate forKey:kPersonPositionPosiBoListCreateDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.curPrice] forKey:kPersonPositionPosiBoListCurPrice];
    [mutableDict setValue:self.proType forKey:kPersonPositionPosiBoListProType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lossFund] forKey:kPersonPositionPosiBoListLossFund];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderId] forKey:kPersonPositionPosiBoListOrderId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kPersonPositionPosiBoListUserId];

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

    self.stockCodeType = [aDecoder decodeObjectForKey:kPersonPositionPosiBoListStockCodeType];
    self.incomeRate = [aDecoder decodeObjectForKey:kPersonPositionPosiBoListIncomeRate];
    self.nickName = [aDecoder decodeObjectForKey:kPersonPositionPosiBoListNickName];
    self.rankScore = [aDecoder decodeDoubleForKey:kPersonPositionPosiBoListRankScore];
    self.marketValue = [aDecoder decodeDoubleForKey:kPersonPositionPosiBoListMarketValue];
    self.buyCount = [aDecoder decodeDoubleForKey:kPersonPositionPosiBoListBuyCount];
    self.stockCode = [aDecoder decodeObjectForKey:kPersonPositionPosiBoListStockCode];
    self.buyPrice = [aDecoder decodeDoubleForKey:kPersonPositionPosiBoListBuyPrice];
    self.buyType = [aDecoder decodeDoubleForKey:kPersonPositionPosiBoListBuyType];
    self.stockName = [aDecoder decodeObjectForKey:kPersonPositionPosiBoListStockName];
    self.curCashProfit = [aDecoder decodeObjectForKey:kPersonPositionPosiBoListCurCashProfit];
    self.operateAmt = [aDecoder decodeDoubleForKey:kPersonPositionPosiBoListOperateAmt];
    self.quantity = [aDecoder decodeDoubleForKey:kPersonPositionPosiBoListQuantity];
    self.openPrice = [aDecoder decodeDoubleForKey:kPersonPositionPosiBoListOpenPrice];
    self.counterFee = [aDecoder decodeDoubleForKey:kPersonPositionPosiBoListCounterFee];
    self.curScoreProfit = [aDecoder decodeObjectForKey:kPersonPositionPosiBoListCurScoreProfit];
    self.orderdetailId = [aDecoder decodeDoubleForKey:kPersonPositionPosiBoListOrderdetailId];
    self.createDate = [aDecoder decodeObjectForKey:kPersonPositionPosiBoListCreateDate];
    self.curPrice = [aDecoder decodeDoubleForKey:kPersonPositionPosiBoListCurPrice];
    self.proType = [aDecoder decodeObjectForKey:kPersonPositionPosiBoListProType];
    self.lossFund = [aDecoder decodeDoubleForKey:kPersonPositionPosiBoListLossFund];
    self.orderId = [aDecoder decodeDoubleForKey:kPersonPositionPosiBoListOrderId];
    self.userId = [aDecoder decodeDoubleForKey:kPersonPositionPosiBoListUserId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_stockCodeType forKey:kPersonPositionPosiBoListStockCodeType];
    [aCoder encodeObject:_incomeRate forKey:kPersonPositionPosiBoListIncomeRate];
    [aCoder encodeObject:_nickName forKey:kPersonPositionPosiBoListNickName];
    [aCoder encodeDouble:_rankScore forKey:kPersonPositionPosiBoListRankScore];
    [aCoder encodeDouble:_marketValue forKey:kPersonPositionPosiBoListMarketValue];
    [aCoder encodeDouble:_buyCount forKey:kPersonPositionPosiBoListBuyCount];
    [aCoder encodeObject:_stockCode forKey:kPersonPositionPosiBoListStockCode];
    [aCoder encodeDouble:_buyPrice forKey:kPersonPositionPosiBoListBuyPrice];
    [aCoder encodeDouble:_buyType forKey:kPersonPositionPosiBoListBuyType];
    [aCoder encodeObject:_stockName forKey:kPersonPositionPosiBoListStockName];
    [aCoder encodeObject:_curCashProfit forKey:kPersonPositionPosiBoListCurCashProfit];
    [aCoder encodeDouble:_operateAmt forKey:kPersonPositionPosiBoListOperateAmt];
    [aCoder encodeDouble:_quantity forKey:kPersonPositionPosiBoListQuantity];
    [aCoder encodeDouble:_openPrice forKey:kPersonPositionPosiBoListOpenPrice];
    [aCoder encodeDouble:_counterFee forKey:kPersonPositionPosiBoListCounterFee];
    [aCoder encodeObject:_curScoreProfit forKey:kPersonPositionPosiBoListCurScoreProfit];
    [aCoder encodeDouble:_orderdetailId forKey:kPersonPositionPosiBoListOrderdetailId];
    [aCoder encodeObject:_createDate forKey:kPersonPositionPosiBoListCreateDate];
    [aCoder encodeDouble:_curPrice forKey:kPersonPositionPosiBoListCurPrice];
    [aCoder encodeObject:_proType forKey:kPersonPositionPosiBoListProType];
    [aCoder encodeDouble:_lossFund forKey:kPersonPositionPosiBoListLossFund];
    [aCoder encodeDouble:_orderId forKey:kPersonPositionPosiBoListOrderId];
    [aCoder encodeDouble:_userId forKey:kPersonPositionPosiBoListUserId];
}

- (id)copyWithZone:(NSZone *)zone
{
    PersonPositionPosiBoList *copy = [[PersonPositionPosiBoList alloc] init];
    
    if (copy) {

        copy.stockCodeType = [self.stockCodeType copyWithZone:zone];
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
        copy.counterFee = self.counterFee;
        copy.curScoreProfit = [self.curScoreProfit copyWithZone:zone];
        copy.orderdetailId = self.orderdetailId;
        copy.createDate = [self.createDate copyWithZone:zone];
        copy.curPrice = self.curPrice;
        copy.proType = [self.proType copyWithZone:zone];
        copy.lossFund = self.lossFund;
        copy.orderId = self.orderId;
        copy.userId = self.userId;
    }
    
    return copy;
}


@end
