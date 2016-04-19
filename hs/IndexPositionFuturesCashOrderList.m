//
//  IndexPositionFuturesCashOrderList.m
//
//  Created by   on 15/7/29
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "IndexPositionFuturesCashOrderList.h"


NSString *const kIndexPositionFuturesCashOrderListTheoryCounterFee = @"theoryCounterFee";
NSString *const kIndexPositionFuturesCashOrderListLossProfit = @"lossProfit";
NSString *const kIndexPositionFuturesCashOrderListStatus = @"status";
NSString *const kIndexPositionFuturesCashOrderListCouponId = @"couponId";
NSString *const kIndexPositionFuturesCashOrderListTradeType = @"tradeType";
NSString *const kIndexPositionFuturesCashOrderListCount = @"count";
NSString *const kIndexPositionFuturesCashOrderListFuturesId = @"futuresId";
NSString *const kIndexPositionFuturesCashOrderListCashFund = @"cashFund";
NSString *const kIndexPositionFuturesCashOrderListDisplayId = @"displayId";
NSString *const kIndexPositionFuturesCashOrderListBuyDate = @"buyDate";
NSString *const kIndexPositionFuturesCashOrderListStopProfit = @"stopProfit";
NSString *const kIndexPositionFuturesCashOrderListFuturesType = @"futuresType";
NSString *const kIndexPositionFuturesCashOrderListStopLossPrice = @"stopLossPrice";
NSString *const kIndexPositionFuturesCashOrderListBuyPrice = @"buyPrice";
NSString *const kIndexPositionFuturesCashOrderListSysSetSaleDate = @"sysSetSaleDate";
NSString *const kIndexPositionFuturesCashOrderListId = @"id";
NSString *const kIndexPositionFuturesCashOrderListFundType = @"fundType";
NSString *const kIndexPositionFuturesCashOrderListCounterFee = @"counterFee";
NSString *const kIndexPositionFuturesCashOrderListStopLoss = @"stopLoss";
NSString *const kIndexPositionFuturesCashOrderListSaleDate = @"saleDate";
NSString *const kIndexPositionFuturesCashOrderListSalePrice = @"salePrice";
NSString *const kIndexPositionFuturesCashOrderListCreateDate = @"createDate";
NSString *const kIndexPositionFuturesCashOrderListStopProfitPrice = @"stopProfitPrice";
NSString *const kIndexPositionFuturesCashOrderListFuturesCode = @"futuresCode";
NSString *const kIndexPositionFuturesCashOrderListIsNeedCheck = @"isNeedCheck";


@interface IndexPositionFuturesCashOrderList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation IndexPositionFuturesCashOrderList

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
            self.theoryCounterFee = [[self objectOrNilForKey:kIndexPositionFuturesCashOrderListTheoryCounterFee fromDictionary:dict] doubleValue];
            self.lossProfit = [[self objectOrNilForKey:kIndexPositionFuturesCashOrderListLossProfit fromDictionary:dict] doubleValue];
            self.status = [[self objectOrNilForKey:kIndexPositionFuturesCashOrderListStatus fromDictionary:dict] doubleValue];
            self.couponId = [[self objectOrNilForKey:kIndexPositionFuturesCashOrderListCouponId fromDictionary:dict] doubleValue];
            self.tradeType = [[self objectOrNilForKey:kIndexPositionFuturesCashOrderListTradeType fromDictionary:dict] doubleValue];
            self.count = [[self objectOrNilForKey:kIndexPositionFuturesCashOrderListCount fromDictionary:dict] doubleValue];
            self.futuresId = [[self objectOrNilForKey:kIndexPositionFuturesCashOrderListFuturesId fromDictionary:dict] doubleValue];
            self.cashFund = [[self objectOrNilForKey:kIndexPositionFuturesCashOrderListCashFund fromDictionary:dict] doubleValue];
            self.displayId = [self objectOrNilForKey:kIndexPositionFuturesCashOrderListDisplayId fromDictionary:dict];
            self.buyDate = [self objectOrNilForKey:kIndexPositionFuturesCashOrderListBuyDate fromDictionary:dict];
            self.stopProfit = [[self objectOrNilForKey:kIndexPositionFuturesCashOrderListStopProfit fromDictionary:dict] doubleValue];
            self.futuresType = [[self objectOrNilForKey:kIndexPositionFuturesCashOrderListFuturesType fromDictionary:dict] doubleValue];
            self.stopLossPrice = [[self objectOrNilForKey:kIndexPositionFuturesCashOrderListStopLossPrice fromDictionary:dict] doubleValue];
            self.buyPrice = [[self objectOrNilForKey:kIndexPositionFuturesCashOrderListBuyPrice fromDictionary:dict] doubleValue];
            self.sysSetSaleDate = [self objectOrNilForKey:kIndexPositionFuturesCashOrderListSysSetSaleDate fromDictionary:dict];
            self.listIdentifier = [[self objectOrNilForKey:kIndexPositionFuturesCashOrderListId fromDictionary:dict] doubleValue];
            self.fundType = [[self objectOrNilForKey:kIndexPositionFuturesCashOrderListFundType fromDictionary:dict] doubleValue];
            self.counterFee = [[self objectOrNilForKey:kIndexPositionFuturesCashOrderListCounterFee fromDictionary:dict] doubleValue];
            self.stopLoss = [[self objectOrNilForKey:kIndexPositionFuturesCashOrderListStopLoss fromDictionary:dict] doubleValue];
            self.saleDate = [self objectOrNilForKey:kIndexPositionFuturesCashOrderListSaleDate fromDictionary:dict];
            self.salePrice = [[self objectOrNilForKey:kIndexPositionFuturesCashOrderListSalePrice fromDictionary:dict] doubleValue];
            self.createDate = [self objectOrNilForKey:kIndexPositionFuturesCashOrderListCreateDate fromDictionary:dict];
            self.stopProfitPrice = [[self objectOrNilForKey:kIndexPositionFuturesCashOrderListStopProfitPrice fromDictionary:dict] doubleValue];
            self.futuresCode = [self objectOrNilForKey:kIndexPositionFuturesCashOrderListFuturesCode fromDictionary:dict];
        self.isNeedCheck = YES;

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.theoryCounterFee] forKey:kIndexPositionFuturesCashOrderListTheoryCounterFee];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lossProfit] forKey:kIndexPositionFuturesCashOrderListLossProfit];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kIndexPositionFuturesCashOrderListStatus];
    [mutableDict setValue:[NSNumber numberWithDouble:self.couponId] forKey:kIndexPositionFuturesCashOrderListCouponId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.tradeType] forKey:kIndexPositionFuturesCashOrderListTradeType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.count] forKey:kIndexPositionFuturesCashOrderListCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.futuresId] forKey:kIndexPositionFuturesCashOrderListFuturesId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cashFund] forKey:kIndexPositionFuturesCashOrderListCashFund];
    [mutableDict setValue:self.displayId forKey:kIndexPositionFuturesCashOrderListDisplayId];
    [mutableDict setValue:self.buyDate forKey:kIndexPositionFuturesCashOrderListBuyDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.stopProfit] forKey:kIndexPositionFuturesCashOrderListStopProfit];
    [mutableDict setValue:[NSNumber numberWithDouble:self.futuresType] forKey:kIndexPositionFuturesCashOrderListFuturesType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.stopLossPrice] forKey:kIndexPositionFuturesCashOrderListStopLossPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buyPrice] forKey:kIndexPositionFuturesCashOrderListBuyPrice];
    [mutableDict setValue:self.sysSetSaleDate forKey:kIndexPositionFuturesCashOrderListSysSetSaleDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.listIdentifier] forKey:kIndexPositionFuturesCashOrderListId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.fundType] forKey:kIndexPositionFuturesCashOrderListFundType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.counterFee] forKey:kIndexPositionFuturesCashOrderListCounterFee];
    [mutableDict setValue:[NSNumber numberWithDouble:self.stopLoss] forKey:kIndexPositionFuturesCashOrderListStopLoss];
    [mutableDict setValue:self.saleDate forKey:kIndexPositionFuturesCashOrderListSaleDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.salePrice] forKey:kIndexPositionFuturesCashOrderListSalePrice];
    [mutableDict setValue:self.createDate forKey:kIndexPositionFuturesCashOrderListCreateDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.stopProfitPrice] forKey:kIndexPositionFuturesCashOrderListStopProfitPrice];
    [mutableDict setValue:self.futuresCode forKey:kIndexPositionFuturesCashOrderListFuturesCode];
    [mutableDict setValue:[NSNumber numberWithBool:self.isNeedCheck] forKey:kIndexPositionFuturesCashOrderListIsNeedCheck];
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

    self.theoryCounterFee = [aDecoder decodeDoubleForKey:kIndexPositionFuturesCashOrderListTheoryCounterFee];
    self.lossProfit = [aDecoder decodeDoubleForKey:kIndexPositionFuturesCashOrderListLossProfit];
    self.status = [aDecoder decodeDoubleForKey:kIndexPositionFuturesCashOrderListStatus];
    self.couponId = [aDecoder decodeDoubleForKey:kIndexPositionFuturesCashOrderListCouponId];
    self.tradeType = [aDecoder decodeDoubleForKey:kIndexPositionFuturesCashOrderListTradeType];
    self.count = [aDecoder decodeDoubleForKey:kIndexPositionFuturesCashOrderListCount];
    self.futuresId = [aDecoder decodeDoubleForKey:kIndexPositionFuturesCashOrderListFuturesId];
    self.cashFund = [aDecoder decodeDoubleForKey:kIndexPositionFuturesCashOrderListCashFund];
    self.displayId = [aDecoder decodeObjectForKey:kIndexPositionFuturesCashOrderListDisplayId];
    self.buyDate = [aDecoder decodeObjectForKey:kIndexPositionFuturesCashOrderListBuyDate];
    self.stopProfit = [aDecoder decodeDoubleForKey:kIndexPositionFuturesCashOrderListStopProfit];
    self.futuresType = [aDecoder decodeDoubleForKey:kIndexPositionFuturesCashOrderListFuturesType];
    self.stopLossPrice = [aDecoder decodeDoubleForKey:kIndexPositionFuturesCashOrderListStopLossPrice];
    self.buyPrice = [aDecoder decodeDoubleForKey:kIndexPositionFuturesCashOrderListBuyPrice];
    self.sysSetSaleDate = [aDecoder decodeObjectForKey:kIndexPositionFuturesCashOrderListSysSetSaleDate];
    self.listIdentifier = [aDecoder decodeDoubleForKey:kIndexPositionFuturesCashOrderListId];
    self.fundType = [aDecoder decodeDoubleForKey:kIndexPositionFuturesCashOrderListFundType];
    self.counterFee = [aDecoder decodeDoubleForKey:kIndexPositionFuturesCashOrderListCounterFee];
    self.stopLoss = [aDecoder decodeDoubleForKey:kIndexPositionFuturesCashOrderListStopLoss];
    self.saleDate = [aDecoder decodeObjectForKey:kIndexPositionFuturesCashOrderListSaleDate];
    self.salePrice = [aDecoder decodeDoubleForKey:kIndexPositionFuturesCashOrderListSalePrice];
    self.createDate = [aDecoder decodeObjectForKey:kIndexPositionFuturesCashOrderListCreateDate];
    self.stopProfitPrice = [aDecoder decodeDoubleForKey:kIndexPositionFuturesCashOrderListStopProfitPrice];
    self.futuresCode = [aDecoder decodeObjectForKey:kIndexPositionFuturesCashOrderListFuturesCode];
    self.isNeedCheck = [aDecoder decodeBoolForKey:kIndexPositionFuturesCashOrderListIsNeedCheck];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_theoryCounterFee forKey:kIndexPositionFuturesCashOrderListTheoryCounterFee];
    [aCoder encodeDouble:_lossProfit forKey:kIndexPositionFuturesCashOrderListLossProfit];
    [aCoder encodeDouble:_status forKey:kIndexPositionFuturesCashOrderListStatus];
    [aCoder encodeDouble:_couponId forKey:kIndexPositionFuturesCashOrderListCouponId];
    [aCoder encodeDouble:_tradeType forKey:kIndexPositionFuturesCashOrderListTradeType];
    [aCoder encodeDouble:_count forKey:kIndexPositionFuturesCashOrderListCount];
    [aCoder encodeDouble:_futuresId forKey:kIndexPositionFuturesCashOrderListFuturesId];
    [aCoder encodeDouble:_cashFund forKey:kIndexPositionFuturesCashOrderListCashFund];
    [aCoder encodeObject:_displayId forKey:kIndexPositionFuturesCashOrderListDisplayId];
    [aCoder encodeObject:_buyDate forKey:kIndexPositionFuturesCashOrderListBuyDate];
    [aCoder encodeDouble:_stopProfit forKey:kIndexPositionFuturesCashOrderListStopProfit];
    [aCoder encodeDouble:_futuresType forKey:kIndexPositionFuturesCashOrderListFuturesType];
    [aCoder encodeDouble:_stopLossPrice forKey:kIndexPositionFuturesCashOrderListStopLossPrice];
    [aCoder encodeDouble:_buyPrice forKey:kIndexPositionFuturesCashOrderListBuyPrice];
    [aCoder encodeObject:_sysSetSaleDate forKey:kIndexPositionFuturesCashOrderListSysSetSaleDate];
    [aCoder encodeDouble:_listIdentifier forKey:kIndexPositionFuturesCashOrderListId];
    [aCoder encodeDouble:_fundType forKey:kIndexPositionFuturesCashOrderListFundType];
    [aCoder encodeDouble:_counterFee forKey:kIndexPositionFuturesCashOrderListCounterFee];
    [aCoder encodeDouble:_stopLoss forKey:kIndexPositionFuturesCashOrderListStopLoss];
    [aCoder encodeObject:_saleDate forKey:kIndexPositionFuturesCashOrderListSaleDate];
    [aCoder encodeDouble:_salePrice forKey:kIndexPositionFuturesCashOrderListSalePrice];
    [aCoder encodeObject:_createDate forKey:kIndexPositionFuturesCashOrderListCreateDate];
    [aCoder encodeDouble:_stopProfitPrice forKey:kIndexPositionFuturesCashOrderListStopProfitPrice];
    [aCoder encodeObject:_futuresCode forKey:kIndexPositionFuturesCashOrderListFuturesCode];
    [aCoder encodeBool:_isNeedCheck forKey:kIndexPositionFuturesCashOrderListIsNeedCheck];

}

- (id)copyWithZone:(NSZone *)zone
{
    IndexPositionFuturesCashOrderList *copy = [[IndexPositionFuturesCashOrderList alloc] init];
    
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
