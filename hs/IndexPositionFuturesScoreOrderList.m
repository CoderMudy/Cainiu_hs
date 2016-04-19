//
//  IndexPositionFuturesScoreOrderList.m
//
//  Created by   on 15/7/29
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "IndexPositionFuturesScoreOrderList.h"


NSString *const kIndexPositionFuturesScoreOrderListTheoryCounterFee = @"theoryCounterFee";
NSString *const kIndexPositionFuturesScoreOrderListLossProfit = @"lossProfit";
NSString *const kIndexPositionFuturesScoreOrderListStatus = @"status";
NSString *const kIndexPositionFuturesScoreOrderListCouponId = @"couponId";
NSString *const kIndexPositionFuturesScoreOrderListTradeType = @"tradeType";
NSString *const kIndexPositionFuturesScoreOrderListCount = @"count";
NSString *const kIndexPositionFuturesScoreOrderListFuturesId = @"futuresId";
NSString *const kIndexPositionFuturesScoreOrderListCashFund = @"cashFund";
NSString *const kIndexPositionFuturesScoreOrderListDisplayId = @"displayId";
NSString *const kIndexPositionFuturesScoreOrderListBuyDate = @"buyDate";
NSString *const kIndexPositionFuturesScoreOrderListStopProfit = @"stopProfit";
NSString *const kIndexPositionFuturesScoreOrderListFuturesType = @"futuresType";
NSString *const kIndexPositionFuturesScoreOrderListStopLossPrice = @"stopLossPrice";
NSString *const kIndexPositionFuturesScoreOrderListBuyPrice = @"buyPrice";
NSString *const kIndexPositionFuturesScoreOrderListSysSetSaleDate = @"sysSetSaleDate";
NSString *const kIndexPositionFuturesScoreOrderListId = @"id";
NSString *const kIndexPositionFuturesScoreOrderListFundType = @"fundType";
NSString *const kIndexPositionFuturesScoreOrderListCounterFee = @"counterFee";
NSString *const kIndexPositionFuturesScoreOrderListStopLoss = @"stopLoss";
NSString *const kIndexPositionFuturesScoreOrderListSaleDate = @"saleDate";
NSString *const kIndexPositionFuturesScoreOrderListSalePrice = @"salePrice";
NSString *const kIndexPositionFuturesScoreOrderListCreateDate = @"createDate";
NSString *const kIndexPositionFuturesScoreOrderListStopProfitPrice = @"stopProfitPrice";
NSString *const kIndexPositionFuturesScoreOrderListFuturesCode = @"futuresCode";
NSString *const kIndexPositionFuturesScoreOrderListIsNeedCheck = @"isNeedCheck";


@interface IndexPositionFuturesScoreOrderList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation IndexPositionFuturesScoreOrderList

@synthesize theoryCounterFee = _theoryCounterFee;
@synthesize lossProfit = _lossProfit;
@synthesize status = _status;
@synthesize couponId = _couponId;
@synthesize tradeType = _tradeType;
@synthesize count = _count;
@synthesize futuresId = _futuresId;
@synthesize cashFund = _cashFund;
@synthesize displayId = _displayId;
@synthesize buyDate = _buyDate;
@synthesize stopProfit = _stopProfit;
@synthesize futuresType = _futuresType;
@synthesize stopLossPrice = _stopLossPrice;
@synthesize buyPrice = _buyPrice;
@synthesize sysSetSaleDate = _sysSetSaleDate;
@synthesize listIdentifier = _listIdentifier;
@synthesize fundType = _fundType;
@synthesize counterFee = _counterFee;
@synthesize stopLoss = _stopLoss;
@synthesize saleDate = _saleDate;
@synthesize salePrice = _salePrice;
@synthesize createDate = _createDate;
@synthesize stopProfitPrice = _stopProfitPrice;
@synthesize futuresCode = _futuresCode;
@synthesize isNeedCheck = _isNeedCheck;


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
            self.theoryCounterFee = [[self objectOrNilForKey:kIndexPositionFuturesScoreOrderListTheoryCounterFee fromDictionary:dict] doubleValue];
            self.lossProfit = [[self objectOrNilForKey:kIndexPositionFuturesScoreOrderListLossProfit fromDictionary:dict] doubleValue];
            self.status = [[self objectOrNilForKey:kIndexPositionFuturesScoreOrderListStatus fromDictionary:dict] doubleValue];
            self.couponId = [[self objectOrNilForKey:kIndexPositionFuturesScoreOrderListCouponId fromDictionary:dict] doubleValue];
            self.tradeType = [[self objectOrNilForKey:kIndexPositionFuturesScoreOrderListTradeType fromDictionary:dict] doubleValue];
            self.count = [[self objectOrNilForKey:kIndexPositionFuturesScoreOrderListCount fromDictionary:dict] doubleValue];
            self.futuresId = [[self objectOrNilForKey:kIndexPositionFuturesScoreOrderListFuturesId fromDictionary:dict] doubleValue];
            self.cashFund = [[self objectOrNilForKey:kIndexPositionFuturesScoreOrderListCashFund fromDictionary:dict] doubleValue];
            self.displayId = [self objectOrNilForKey:kIndexPositionFuturesScoreOrderListDisplayId fromDictionary:dict];
            self.buyDate = [self objectOrNilForKey:kIndexPositionFuturesScoreOrderListBuyDate fromDictionary:dict];
            self.stopProfit = [[self objectOrNilForKey:kIndexPositionFuturesScoreOrderListStopProfit fromDictionary:dict] doubleValue];
            self.futuresType = [[self objectOrNilForKey:kIndexPositionFuturesScoreOrderListFuturesType fromDictionary:dict] doubleValue];
            self.stopLossPrice = [[self objectOrNilForKey:kIndexPositionFuturesScoreOrderListStopLossPrice fromDictionary:dict] doubleValue];
            self.buyPrice = [[self objectOrNilForKey:kIndexPositionFuturesScoreOrderListBuyPrice fromDictionary:dict] doubleValue];
            self.sysSetSaleDate = [self objectOrNilForKey:kIndexPositionFuturesScoreOrderListSysSetSaleDate fromDictionary:dict];
            self.listIdentifier = [[self objectOrNilForKey:kIndexPositionFuturesScoreOrderListId fromDictionary:dict] doubleValue];
            self.fundType = [[self objectOrNilForKey:kIndexPositionFuturesScoreOrderListFundType fromDictionary:dict] doubleValue];
            self.counterFee = [[self objectOrNilForKey:kIndexPositionFuturesScoreOrderListCounterFee fromDictionary:dict] doubleValue];
            self.stopLoss = [[self objectOrNilForKey:kIndexPositionFuturesScoreOrderListStopLoss fromDictionary:dict] doubleValue];
            self.saleDate = [self objectOrNilForKey:kIndexPositionFuturesScoreOrderListSaleDate fromDictionary:dict];
            self.salePrice = [[self objectOrNilForKey:kIndexPositionFuturesScoreOrderListSalePrice fromDictionary:dict] doubleValue];
            self.createDate = [self objectOrNilForKey:kIndexPositionFuturesScoreOrderListCreateDate fromDictionary:dict];
            self.stopProfitPrice = [[self objectOrNilForKey:kIndexPositionFuturesScoreOrderListStopProfitPrice fromDictionary:dict] doubleValue];
            self.futuresCode = [self objectOrNilForKey:kIndexPositionFuturesScoreOrderListFuturesCode fromDictionary:dict];
        self.isNeedCheck = YES;

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.theoryCounterFee] forKey:kIndexPositionFuturesScoreOrderListTheoryCounterFee];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lossProfit] forKey:kIndexPositionFuturesScoreOrderListLossProfit];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kIndexPositionFuturesScoreOrderListStatus];
    [mutableDict setValue:[NSNumber numberWithDouble:self.couponId] forKey:kIndexPositionFuturesScoreOrderListCouponId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.tradeType] forKey:kIndexPositionFuturesScoreOrderListTradeType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.count] forKey:kIndexPositionFuturesScoreOrderListCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.futuresId] forKey:kIndexPositionFuturesScoreOrderListFuturesId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cashFund] forKey:kIndexPositionFuturesScoreOrderListCashFund];
    [mutableDict setValue:self.displayId forKey:kIndexPositionFuturesScoreOrderListDisplayId];
    [mutableDict setValue:self.buyDate forKey:kIndexPositionFuturesScoreOrderListBuyDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.stopProfit] forKey:kIndexPositionFuturesScoreOrderListStopProfit];
    [mutableDict setValue:[NSNumber numberWithDouble:self.futuresType] forKey:kIndexPositionFuturesScoreOrderListFuturesType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.stopLossPrice] forKey:kIndexPositionFuturesScoreOrderListStopLossPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buyPrice] forKey:kIndexPositionFuturesScoreOrderListBuyPrice];
    [mutableDict setValue:self.sysSetSaleDate forKey:kIndexPositionFuturesScoreOrderListSysSetSaleDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.listIdentifier] forKey:kIndexPositionFuturesScoreOrderListId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.fundType] forKey:kIndexPositionFuturesScoreOrderListFundType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.counterFee] forKey:kIndexPositionFuturesScoreOrderListCounterFee];
    [mutableDict setValue:[NSNumber numberWithDouble:self.stopLoss] forKey:kIndexPositionFuturesScoreOrderListStopLoss];
    [mutableDict setValue:self.saleDate forKey:kIndexPositionFuturesScoreOrderListSaleDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.salePrice] forKey:kIndexPositionFuturesScoreOrderListSalePrice];
    [mutableDict setValue:self.createDate forKey:kIndexPositionFuturesScoreOrderListCreateDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.stopProfitPrice] forKey:kIndexPositionFuturesScoreOrderListStopProfitPrice];
    [mutableDict setValue:self.futuresCode forKey:kIndexPositionFuturesScoreOrderListFuturesCode];
    [mutableDict setValue:[NSNumber numberWithBool:self.isNeedCheck] forKey:kIndexPositionFuturesScoreOrderListIsNeedCheck];
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

    self.theoryCounterFee = [aDecoder decodeDoubleForKey:kIndexPositionFuturesScoreOrderListTheoryCounterFee];
    self.lossProfit = [aDecoder decodeDoubleForKey:kIndexPositionFuturesScoreOrderListLossProfit];
    self.status = [aDecoder decodeDoubleForKey:kIndexPositionFuturesScoreOrderListStatus];
    self.couponId = [aDecoder decodeDoubleForKey:kIndexPositionFuturesScoreOrderListCouponId];
    self.tradeType = [aDecoder decodeDoubleForKey:kIndexPositionFuturesScoreOrderListTradeType];
    self.count = [aDecoder decodeDoubleForKey:kIndexPositionFuturesScoreOrderListCount];
    self.futuresId = [aDecoder decodeDoubleForKey:kIndexPositionFuturesScoreOrderListFuturesId];
    self.cashFund = [aDecoder decodeDoubleForKey:kIndexPositionFuturesScoreOrderListCashFund];
    self.displayId = [aDecoder decodeObjectForKey:kIndexPositionFuturesScoreOrderListDisplayId];
    self.buyDate = [aDecoder decodeObjectForKey:kIndexPositionFuturesScoreOrderListBuyDate];
    self.stopProfit = [aDecoder decodeDoubleForKey:kIndexPositionFuturesScoreOrderListStopProfit];
    self.futuresType = [aDecoder decodeDoubleForKey:kIndexPositionFuturesScoreOrderListFuturesType];
    self.stopLossPrice = [aDecoder decodeDoubleForKey:kIndexPositionFuturesScoreOrderListStopLossPrice];
    self.buyPrice = [aDecoder decodeDoubleForKey:kIndexPositionFuturesScoreOrderListBuyPrice];
    self.sysSetSaleDate = [aDecoder decodeObjectForKey:kIndexPositionFuturesScoreOrderListSysSetSaleDate];
    self.listIdentifier = [aDecoder decodeDoubleForKey:kIndexPositionFuturesScoreOrderListId];
    self.fundType = [aDecoder decodeDoubleForKey:kIndexPositionFuturesScoreOrderListFundType];
    self.counterFee = [aDecoder decodeDoubleForKey:kIndexPositionFuturesScoreOrderListCounterFee];
    self.stopLoss = [aDecoder decodeDoubleForKey:kIndexPositionFuturesScoreOrderListStopLoss];
    self.saleDate = [aDecoder decodeObjectForKey:kIndexPositionFuturesScoreOrderListSaleDate];
    self.salePrice = [aDecoder decodeDoubleForKey:kIndexPositionFuturesScoreOrderListSalePrice];
    self.createDate = [aDecoder decodeObjectForKey:kIndexPositionFuturesScoreOrderListCreateDate];
    self.stopProfitPrice = [aDecoder decodeDoubleForKey:kIndexPositionFuturesScoreOrderListStopProfitPrice];
    self.futuresCode = [aDecoder decodeObjectForKey:kIndexPositionFuturesScoreOrderListFuturesCode];
    self.isNeedCheck = [aDecoder decodeBoolForKey:kIndexPositionFuturesScoreOrderListIsNeedCheck];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_theoryCounterFee forKey:kIndexPositionFuturesScoreOrderListTheoryCounterFee];
    [aCoder encodeDouble:_lossProfit forKey:kIndexPositionFuturesScoreOrderListLossProfit];
    [aCoder encodeDouble:_status forKey:kIndexPositionFuturesScoreOrderListStatus];
    [aCoder encodeDouble:_couponId forKey:kIndexPositionFuturesScoreOrderListCouponId];
    [aCoder encodeDouble:_tradeType forKey:kIndexPositionFuturesScoreOrderListTradeType];
    [aCoder encodeDouble:_count forKey:kIndexPositionFuturesScoreOrderListCount];
    [aCoder encodeDouble:_futuresId forKey:kIndexPositionFuturesScoreOrderListFuturesId];
    [aCoder encodeDouble:_cashFund forKey:kIndexPositionFuturesScoreOrderListCashFund];
    [aCoder encodeObject:_displayId forKey:kIndexPositionFuturesScoreOrderListDisplayId];
    [aCoder encodeObject:_buyDate forKey:kIndexPositionFuturesScoreOrderListBuyDate];
    [aCoder encodeDouble:_stopProfit forKey:kIndexPositionFuturesScoreOrderListStopProfit];
    [aCoder encodeDouble:_futuresType forKey:kIndexPositionFuturesScoreOrderListFuturesType];
    [aCoder encodeDouble:_stopLossPrice forKey:kIndexPositionFuturesScoreOrderListStopLossPrice];
    [aCoder encodeDouble:_buyPrice forKey:kIndexPositionFuturesScoreOrderListBuyPrice];
    [aCoder encodeObject:_sysSetSaleDate forKey:kIndexPositionFuturesScoreOrderListSysSetSaleDate];
    [aCoder encodeDouble:_listIdentifier forKey:kIndexPositionFuturesScoreOrderListId];
    [aCoder encodeDouble:_fundType forKey:kIndexPositionFuturesScoreOrderListFundType];
    [aCoder encodeDouble:_counterFee forKey:kIndexPositionFuturesScoreOrderListCounterFee];
    [aCoder encodeDouble:_stopLoss forKey:kIndexPositionFuturesScoreOrderListStopLoss];
    [aCoder encodeObject:_saleDate forKey:kIndexPositionFuturesScoreOrderListSaleDate];
    [aCoder encodeDouble:_salePrice forKey:kIndexPositionFuturesScoreOrderListSalePrice];
    [aCoder encodeObject:_createDate forKey:kIndexPositionFuturesScoreOrderListCreateDate];
    [aCoder encodeDouble:_stopProfitPrice forKey:kIndexPositionFuturesScoreOrderListStopProfitPrice];
    [aCoder encodeObject:_futuresCode forKey:kIndexPositionFuturesScoreOrderListFuturesCode];
    [aCoder encodeBool:_isNeedCheck forKey:kIndexPositionFuturesScoreOrderListIsNeedCheck];

}

- (id)copyWithZone:(NSZone *)zone
{
    IndexPositionFuturesScoreOrderList *copy = [[IndexPositionFuturesScoreOrderList alloc] init];
    
    if (copy) {

        copy.theoryCounterFee = self.theoryCounterFee;
        copy.lossProfit = self.lossProfit;
        copy.status = self.status;
        copy.couponId = self.couponId;
        copy.tradeType = self.tradeType;
        copy.count = self.count;
        copy.futuresId = self.futuresId;
        copy.cashFund = self.cashFund;
        copy.displayId = [self.displayId copyWithZone:zone];
        copy.buyDate = [self.buyDate copyWithZone:zone];
        copy.stopProfit = self.stopProfit;
        copy.futuresType = self.futuresType;
        copy.stopLossPrice = self.stopLossPrice;
        copy.buyPrice = self.buyPrice;
        copy.sysSetSaleDate = [self.sysSetSaleDate copyWithZone:zone];
        copy.listIdentifier = self.listIdentifier;
        copy.fundType = self.fundType;
        copy.counterFee = self.counterFee;
        copy.stopLoss = self.stopLoss;
        copy.saleDate = [self.saleDate copyWithZone:zone];
        copy.salePrice = self.salePrice;
        copy.createDate = [self.createDate copyWithZone:zone];
        copy.stopProfitPrice = self.stopProfitPrice;
        copy.futuresCode = [self.futuresCode copyWithZone:zone];
        copy.isNeedCheck = self.isNeedCheck;

    }
    
    return copy;
}


@end
