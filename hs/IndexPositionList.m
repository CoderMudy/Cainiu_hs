//
//  IndexPositionList.m
//
//  Created by   on 15/8/3
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "IndexPositionList.h"


NSString *const kIndexPositionListTheoryCounterFee = @"theoryCounterFee";
NSString *const kIndexPositionListLossProfit = @"lossProfit";
NSString *const kIndexPositionListNickName = @"nickName";
NSString *const kIndexPositionListStatus = @"status";
NSString *const kIndexPositionListCouponId = @"couponId";
NSString *const kIndexPositionListTradeType = @"tradeType";
NSString *const kIndexPositionListCount = @"count";
NSString *const kIndexPositionListFuturesId = @"futuresId";
NSString *const kIndexPositionListFuturesType = @"futuresType";
NSString *const kIndexPositionListDisplayId = @"displayId";
NSString *const kIndexPositionListBuyDate = @"buyDate";
NSString *const kIndexPositionListStopProfit = @"stopProfit";
NSString *const kIndexPositionListCashFund = @"cashFund";
NSString *const kIndexPositionListStopLossPrice = @"stopLossPrice";
NSString *const kIndexPositionListBuyPrice = @"buyPrice";
NSString *const kIndexPositionListSysSetSaleDate = @"sysSetSaleDate";
NSString *const kIndexPositionListId = @"id";
NSString *const kIndexPositionListFinancyAllocation = @"financyAllocation";
NSString *const kIndexPositionListFundType = @"fundType";
NSString *const kIndexPositionListCounterFee = @"counterFee";
NSString *const kIndexPositionListStopLoss = @"stopLoss";
NSString *const kIndexPositionListSaleDate = @"saleDate";
NSString *const kIndexPositionListSalePrice = @"salePrice";
NSString *const kIndexPositionListCreateDate = @"createDate";
NSString *const kIndexPositionListStopProfitPrice = @"stopProfitPrice";
NSString *const kIndexPositionListFuturesCode = @"futuresCode";
NSString *const kIndexPositionListIsNeedCheck = @"isNeedCheck";

@interface IndexPositionList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation IndexPositionList

@synthesize theoryCounterFee = _theoryCounterFee;
@synthesize lossProfit = _lossProfit;
@synthesize nickName = _nickName;
@synthesize status = _status;
@synthesize couponId = _couponId;
@synthesize tradeType = _tradeType;
@synthesize count = _count;
@synthesize futuresId = _futuresId;
@synthesize futuresType = _futuresType;
@synthesize displayId = _displayId;
@synthesize buyDate = _buyDate;
@synthesize stopProfit = _stopProfit;
@synthesize cashFund = _cashFund;
@synthesize stopLossPrice = _stopLossPrice;
@synthesize buyPrice = _buyPrice;
@synthesize sysSetSaleDate = _sysSetSaleDate;
@synthesize listIdentifier = _listIdentifier;
@synthesize financyAllocation = _financyAllocation;
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
            self.theoryCounterFee = [[self objectOrNilForKey:kIndexPositionListTheoryCounterFee fromDictionary:dict] doubleValue];
            self.lossProfit = [[self objectOrNilForKey:kIndexPositionListLossProfit fromDictionary:dict]doubleValue];
            self.nickName = [self objectOrNilForKey:kIndexPositionListNickName fromDictionary:dict];
            self.status = [[self objectOrNilForKey:kIndexPositionListStatus fromDictionary:dict] doubleValue];
            self.couponId = [[self objectOrNilForKey:kIndexPositionListCouponId fromDictionary:dict] doubleValue];
            self.tradeType = [[self objectOrNilForKey:kIndexPositionListTradeType fromDictionary:dict] doubleValue];
            self.count = [[self objectOrNilForKey:kIndexPositionListCount fromDictionary:dict] doubleValue];
            self.futuresId = [[self objectOrNilForKey:kIndexPositionListFuturesId fromDictionary:dict] doubleValue];
            self.futuresType = [[self objectOrNilForKey:kIndexPositionListFuturesType fromDictionary:dict] doubleValue];
            self.displayId = [self objectOrNilForKey:kIndexPositionListDisplayId fromDictionary:dict];
            self.buyDate = [self objectOrNilForKey:kIndexPositionListBuyDate fromDictionary:dict];
            self.stopProfit = [[self objectOrNilForKey:kIndexPositionListStopProfit fromDictionary:dict] doubleValue];
            self.cashFund = [[self objectOrNilForKey:kIndexPositionListCashFund fromDictionary:dict] doubleValue];
            self.stopLossPrice = [[self objectOrNilForKey:kIndexPositionListStopLossPrice fromDictionary:dict] doubleValue];
            self.buyPrice = [self objectOrNilForKey:kIndexPositionListBuyPrice fromDictionary:dict];
            self.sysSetSaleDate = [self objectOrNilForKey:kIndexPositionListSysSetSaleDate fromDictionary:dict];
            self.listIdentifier = [[self objectOrNilForKey:kIndexPositionListId fromDictionary:dict] doubleValue];
            self.financyAllocation = [[self objectOrNilForKey:kIndexPositionListFinancyAllocation fromDictionary:dict] doubleValue];
            self.fundType = [[self objectOrNilForKey:kIndexPositionListFundType fromDictionary:dict] doubleValue];
            self.counterFee = [[self objectOrNilForKey:kIndexPositionListCounterFee fromDictionary:dict] doubleValue];
            self.stopLoss = [[self objectOrNilForKey:kIndexPositionListStopLoss fromDictionary:dict] doubleValue];
            self.saleDate = [self objectOrNilForKey:kIndexPositionListSaleDate fromDictionary:dict];
            self.salePrice = [[self objectOrNilForKey:kIndexPositionListSalePrice fromDictionary:dict] doubleValue];
            self.createDate = [self objectOrNilForKey:kIndexPositionListCreateDate fromDictionary:dict];
            self.stopProfitPrice = [[self objectOrNilForKey:kIndexPositionListStopProfitPrice fromDictionary:dict] doubleValue];
            self.futuresCode = [self objectOrNilForKey:kIndexPositionListFuturesCode fromDictionary:dict];
        self.isNeedCheck = YES;
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.theoryCounterFee] forKey:kIndexPositionListTheoryCounterFee];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lossProfit] forKey:kIndexPositionListLossProfit];
    [mutableDict setValue:self.nickName forKey:kIndexPositionListNickName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kIndexPositionListStatus];
    [mutableDict setValue:[NSNumber numberWithDouble:self.couponId] forKey:kIndexPositionListCouponId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.tradeType] forKey:kIndexPositionListTradeType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.count] forKey:kIndexPositionListCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.futuresId] forKey:kIndexPositionListFuturesId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.futuresType] forKey:kIndexPositionListFuturesType];
    [mutableDict setValue:self.displayId forKey:kIndexPositionListDisplayId];
    [mutableDict setValue:self.buyDate forKey:kIndexPositionListBuyDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.stopProfit] forKey:kIndexPositionListStopProfit];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cashFund] forKey:kIndexPositionListCashFund];
    [mutableDict setValue:[NSNumber numberWithDouble:self.stopLossPrice] forKey:kIndexPositionListStopLossPrice];
    [mutableDict setValue:self.buyPrice forKey:kIndexPositionListBuyPrice];
    [mutableDict setValue:self.sysSetSaleDate forKey:kIndexPositionListSysSetSaleDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.listIdentifier] forKey:kIndexPositionListId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.financyAllocation] forKey:kIndexPositionListFinancyAllocation];
    [mutableDict setValue:[NSNumber numberWithDouble:self.fundType] forKey:kIndexPositionListFundType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.counterFee] forKey:kIndexPositionListCounterFee];
    [mutableDict setValue:[NSNumber numberWithDouble:self.stopLoss] forKey:kIndexPositionListStopLoss];
    [mutableDict setValue:self.saleDate forKey:kIndexPositionListSaleDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.salePrice] forKey:kIndexPositionListSalePrice];
    [mutableDict setValue:self.createDate forKey:kIndexPositionListCreateDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.stopProfitPrice] forKey:kIndexPositionListStopProfitPrice];
    [mutableDict setValue:self.futuresCode forKey:kIndexPositionListFuturesCode];
    [mutableDict setValue:[NSNumber numberWithBool:self.isNeedCheck] forKey:kIndexPositionListIsNeedCheck];
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

    self.theoryCounterFee = [aDecoder decodeDoubleForKey:kIndexPositionListTheoryCounterFee];
    self.lossProfit = [aDecoder decodeDoubleForKey:kIndexPositionListLossProfit];
    self.nickName = [aDecoder decodeObjectForKey:kIndexPositionListNickName];
    self.status = [aDecoder decodeDoubleForKey:kIndexPositionListStatus];
    self.couponId = [aDecoder decodeDoubleForKey:kIndexPositionListCouponId];
    self.tradeType = [aDecoder decodeDoubleForKey:kIndexPositionListTradeType];
    self.count = [aDecoder decodeDoubleForKey:kIndexPositionListCount];
    self.futuresId = [aDecoder decodeDoubleForKey:kIndexPositionListFuturesId];
    self.futuresType = [aDecoder decodeDoubleForKey:kIndexPositionListFuturesType];
    self.displayId = [aDecoder decodeObjectForKey:kIndexPositionListDisplayId];
    self.buyDate = [aDecoder decodeObjectForKey:kIndexPositionListBuyDate];
    self.stopProfit = [aDecoder decodeDoubleForKey:kIndexPositionListStopProfit];
    self.cashFund = [aDecoder decodeDoubleForKey:kIndexPositionListCashFund];
    self.stopLossPrice = [aDecoder decodeDoubleForKey:kIndexPositionListStopLossPrice];
    self.buyPrice = [aDecoder decodeObjectForKey:kIndexPositionListBuyPrice];
    self.sysSetSaleDate = [aDecoder decodeObjectForKey:kIndexPositionListSysSetSaleDate];
    self.listIdentifier = [aDecoder decodeDoubleForKey:kIndexPositionListId];
    self.financyAllocation = [aDecoder decodeDoubleForKey:kIndexPositionListFinancyAllocation];
    self.fundType = [aDecoder decodeDoubleForKey:kIndexPositionListFundType];
    self.counterFee = [aDecoder decodeDoubleForKey:kIndexPositionListCounterFee];
    self.stopLoss = [aDecoder decodeDoubleForKey:kIndexPositionListStopLoss];
    self.saleDate = [aDecoder decodeObjectForKey:kIndexPositionListSaleDate];
    self.salePrice = [aDecoder decodeDoubleForKey:kIndexPositionListSalePrice];
    self.createDate = [aDecoder decodeObjectForKey:kIndexPositionListCreateDate];
    self.stopProfitPrice = [aDecoder decodeDoubleForKey:kIndexPositionListStopProfitPrice];
    self.futuresCode = [aDecoder decodeObjectForKey:kIndexPositionListFuturesCode];
    self.isNeedCheck = [aDecoder decodeBoolForKey:kIndexPositionListIsNeedCheck];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_theoryCounterFee forKey:kIndexPositionListTheoryCounterFee];
    [aCoder encodeDouble:_lossProfit forKey:kIndexPositionListLossProfit];
    [aCoder encodeObject:_nickName forKey:kIndexPositionListNickName];
    [aCoder encodeDouble:_status forKey:kIndexPositionListStatus];
    [aCoder encodeDouble:_couponId forKey:kIndexPositionListCouponId];
    [aCoder encodeDouble:_tradeType forKey:kIndexPositionListTradeType];
    [aCoder encodeDouble:_count forKey:kIndexPositionListCount];
    [aCoder encodeDouble:_futuresId forKey:kIndexPositionListFuturesId];
    [aCoder encodeDouble:_futuresType forKey:kIndexPositionListFuturesType];
    [aCoder encodeObject:_displayId forKey:kIndexPositionListDisplayId];
    [aCoder encodeObject:_buyDate forKey:kIndexPositionListBuyDate];
    [aCoder encodeDouble:_stopProfit forKey:kIndexPositionListStopProfit];
    [aCoder encodeDouble:_cashFund forKey:kIndexPositionListCashFund];
    [aCoder encodeDouble:_stopLossPrice forKey:kIndexPositionListStopLossPrice];
    [aCoder encodeObject:_buyPrice forKey:kIndexPositionListBuyPrice];
    [aCoder encodeObject:_sysSetSaleDate forKey:kIndexPositionListSysSetSaleDate];
    [aCoder encodeDouble:_listIdentifier forKey:kIndexPositionListId];
    [aCoder encodeDouble:_financyAllocation forKey:kIndexPositionListFinancyAllocation];
    [aCoder encodeDouble:_fundType forKey:kIndexPositionListFundType];
    [aCoder encodeDouble:_counterFee forKey:kIndexPositionListCounterFee];
    [aCoder encodeDouble:_stopLoss forKey:kIndexPositionListStopLoss];
    [aCoder encodeObject:_saleDate forKey:kIndexPositionListSaleDate];
    [aCoder encodeDouble:_salePrice forKey:kIndexPositionListSalePrice];
    [aCoder encodeObject:_createDate forKey:kIndexPositionListCreateDate];
    [aCoder encodeDouble:_stopProfitPrice forKey:kIndexPositionListStopProfitPrice];
    [aCoder encodeObject:_futuresCode forKey:kIndexPositionListFuturesCode];
    [aCoder encodeBool:_isNeedCheck forKey:kIndexPositionListIsNeedCheck];
}

- (id)copyWithZone:(NSZone *)zone
{
    IndexPositionList *copy = [[IndexPositionList alloc] init];
    
    if (copy) {

        copy.theoryCounterFee = self.theoryCounterFee;
        copy.lossProfit = self.lossProfit;
        copy.nickName = [self.nickName copyWithZone:zone];
        copy.status = self.status;
        copy.couponId = self.couponId;
        copy.tradeType = self.tradeType;
        copy.count = self.count;
        copy.futuresId = self.futuresId;
        copy.futuresType = self.futuresType;
        copy.displayId = [self.displayId copyWithZone:zone];
        copy.buyDate = [self.buyDate copyWithZone:zone];
        copy.stopProfit = self.stopProfit;
        copy.cashFund = self.cashFund;
        copy.stopLossPrice = self.stopLossPrice;
        copy.buyPrice = [self.buyPrice copyWithZone:zone];
        copy.sysSetSaleDate = [self.sysSetSaleDate copyWithZone:zone];
        copy.listIdentifier = self.listIdentifier;
        copy.financyAllocation = self.financyAllocation;
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
