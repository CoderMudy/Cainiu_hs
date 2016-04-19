//
//  IndexRecordBaseClass.m
//
//  Created by   on 15/7/31
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "IndexRecordModel.h"


NSString *const kIndexRecordBaseClassTheoryCounterFee = @"theoryCounterFee";
NSString *const kIndexRecordBaseClassLossProfit = @"lossProfit";
NSString *const kIndexRecordBaseClassNickName = @"nickName";
NSString *const kIndexRecordBaseClassStatus = @"status";
NSString *const kIndexRecordBaseClassCouponId = @"couponId";
NSString *const kIndexRecordBaseClassTradeType = @"tradeType";
NSString *const kIndexRecordBaseClassCount = @"count";
NSString *const kIndexRecordBaseClassFuturesId = @"futuresId";
NSString *const kIndexRecordBaseClassFuturesType = @"futuresType";
NSString *const kIndexRecordBaseClassDisplayId = @"displayId";
NSString *const kIndexRecordBaseClassBuyDate = @"buyDate";
NSString *const kIndexRecordBaseClassStopProfit = @"stopProfit";
NSString *const kIndexRecordBaseClassCashFund = @"cashFund";
NSString *const kIndexRecordBaseClassStopLossPrice = @"stopLossPrice";
NSString *const kIndexRecordBaseClassBuyPrice = @"buyPrice";
NSString *const kIndexRecordBaseClassSysSetSaleDate = @"sysSetSaleDate";
NSString *const kIndexRecordBaseClassId = @"id";
NSString *const kIndexRecordBaseClassFinancyAllocation = @"financyAllocation";
NSString *const kIndexRecordBaseClassFundType = @"fundType";
NSString *const kIndexRecordBaseClassCounterFee = @"counterFee";
NSString *const kIndexRecordBaseClassStopLoss = @"stopLoss";
NSString *const kIndexRecordBaseClassSaleDate = @"saleDate";
NSString *const kIndexRecordBaseClassSalePrice = @"salePrice";
NSString *const kIndexRecordBaseClassCreateDate = @"createDate";
NSString *const kIndexRecordBaseClassStopProfitPrice = @"stopProfitPrice";
NSString *const kIndexRecordBaseClassFuturesCode = @"futuresCode";
NSString *const kIndexRecordBaseClassSaleOpSource = @"saleOpSource";
NSString *const kIndexRecordBaseClassRate = @"rate";
NSString *const kIndexRecordBaseClassConditionId = @"conditionId";
NSString *const kIndexRecordBaseClassConditionPrice = @"conditionPrice";
NSString *const kIndexRecordBaseClassSizeSymbol = @"sizeSymbol";

@interface IndexRecordModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation IndexRecordModel

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
@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize financyAllocation = _financyAllocation;
@synthesize fundType = _fundType;
@synthesize counterFee = _counterFee;
@synthesize stopLoss = _stopLoss;
@synthesize saleDate = _saleDate;
@synthesize salePrice = _salePrice;
@synthesize createDate = _createDate;
@synthesize stopProfitPrice = _stopProfitPrice;
@synthesize futuresCode = _futuresCode;
@synthesize saleOpSource = _saleOpSource;
@synthesize rate = _rate;
@synthesize conditionId = _conditionId;
@synthesize conditionPrice = _conditionPrice;
@synthesize sizeSymbol = _sizeSymbol;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]])
    {
        self.theoryCounterFee = [[self objectOrNilForKey:kIndexRecordBaseClassTheoryCounterFee fromDictionary:dict] doubleValue];
        self.lossProfit = [[self objectOrNilForKey:kIndexRecordBaseClassLossProfit fromDictionary:dict] doubleValue];
        self.nickName = [self objectOrNilForKey:kIndexRecordBaseClassNickName fromDictionary:dict];
        self.status = [[self objectOrNilForKey:kIndexRecordBaseClassStatus fromDictionary:dict] doubleValue];
        self.couponId = [[self objectOrNilForKey:kIndexRecordBaseClassCouponId fromDictionary:dict] doubleValue];
        self.tradeType = [[self objectOrNilForKey:kIndexRecordBaseClassTradeType fromDictionary:dict] doubleValue];
        self.count = [[self objectOrNilForKey:kIndexRecordBaseClassCount fromDictionary:dict] doubleValue];
        self.futuresId = [[self objectOrNilForKey:kIndexRecordBaseClassFuturesId fromDictionary:dict] doubleValue];
        self.futuresType = [[self objectOrNilForKey:kIndexRecordBaseClassFuturesType fromDictionary:dict] doubleValue];
        self.displayId = [self objectOrNilForKey:kIndexRecordBaseClassDisplayId fromDictionary:dict];
        self.buyDate = [self objectOrNilForKey:kIndexRecordBaseClassBuyDate fromDictionary:dict];
        self.stopProfit = [[self objectOrNilForKey:kIndexRecordBaseClassStopProfit fromDictionary:dict] doubleValue];
        self.cashFund = [[self objectOrNilForKey:kIndexRecordBaseClassCashFund fromDictionary:dict] doubleValue];
        self.stopLossPrice = [[self objectOrNilForKey:kIndexRecordBaseClassStopLossPrice fromDictionary:dict] doubleValue];
        self.buyPrice = [[self objectOrNilForKey:kIndexRecordBaseClassBuyPrice fromDictionary:dict] doubleValue];
        self.sysSetSaleDate = [self objectOrNilForKey:kIndexRecordBaseClassSysSetSaleDate fromDictionary:dict];
        self.internalBaseClassIdentifier = [[self objectOrNilForKey:kIndexRecordBaseClassId fromDictionary:dict] doubleValue];
        self.financyAllocation = [[self objectOrNilForKey:kIndexRecordBaseClassFinancyAllocation fromDictionary:dict] doubleValue];
        self.fundType = [[self objectOrNilForKey:kIndexRecordBaseClassFundType fromDictionary:dict] doubleValue];
        self.counterFee = [[self objectOrNilForKey:kIndexRecordBaseClassCounterFee fromDictionary:dict] doubleValue];
        self.stopLoss = [[self objectOrNilForKey:kIndexRecordBaseClassStopLoss fromDictionary:dict] doubleValue];
        self.saleDate = [self objectOrNilForKey:kIndexRecordBaseClassSaleDate fromDictionary:dict];
        self.salePrice = [[self objectOrNilForKey:kIndexRecordBaseClassSalePrice fromDictionary:dict] doubleValue];
        self.createDate = [self objectOrNilForKey:kIndexRecordBaseClassCreateDate fromDictionary:dict];
        self.stopProfitPrice = [[self objectOrNilForKey:kIndexRecordBaseClassStopProfitPrice fromDictionary:dict] doubleValue];
        self.futuresCode = [self objectOrNilForKey:kIndexRecordBaseClassFuturesCode fromDictionary:dict];
        self.saleOpSource = [self objectOrNilForKey:kIndexRecordBaseClassSaleOpSource fromDictionary:dict];
        self.rate = [self objectOrNilForKey:kIndexRecordBaseClassRate fromDictionary:dict];
        self.conditionId = [[self objectOrNilForKey:kIndexRecordBaseClassConditionId fromDictionary:dict] doubleValue];
        self.conditionPrice = [[self objectOrNilForKey:kIndexRecordBaseClassConditionPrice fromDictionary:dict] doubleValue];
        self.sizeSymbol = [[self objectOrNilForKey:kIndexRecordBaseClassSizeSymbol fromDictionary:dict] doubleValue];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.theoryCounterFee] forKey:kIndexRecordBaseClassTheoryCounterFee];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lossProfit] forKey:kIndexRecordBaseClassLossProfit];
    [mutableDict setValue:self.nickName forKey:kIndexRecordBaseClassNickName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kIndexRecordBaseClassStatus];
    [mutableDict setValue:[NSNumber numberWithDouble:self.couponId] forKey:kIndexRecordBaseClassCouponId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.tradeType] forKey:kIndexRecordBaseClassTradeType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.count] forKey:kIndexRecordBaseClassCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.futuresId] forKey:kIndexRecordBaseClassFuturesId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.futuresType] forKey:kIndexRecordBaseClassFuturesType];
    [mutableDict setValue:self.displayId forKey:kIndexRecordBaseClassDisplayId];
    [mutableDict setValue:self.buyDate forKey:kIndexRecordBaseClassBuyDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.stopProfit] forKey:kIndexRecordBaseClassStopProfit];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cashFund] forKey:kIndexRecordBaseClassCashFund];
    [mutableDict setValue:[NSNumber numberWithDouble:self.stopLossPrice] forKey:kIndexRecordBaseClassStopLossPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buyPrice] forKey:kIndexRecordBaseClassBuyPrice];
    [mutableDict setValue:self.sysSetSaleDate forKey:kIndexRecordBaseClassSysSetSaleDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.internalBaseClassIdentifier] forKey:kIndexRecordBaseClassId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.financyAllocation] forKey:kIndexRecordBaseClassFinancyAllocation];
    [mutableDict setValue:[NSNumber numberWithDouble:self.fundType] forKey:kIndexRecordBaseClassFundType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.counterFee] forKey:kIndexRecordBaseClassCounterFee];
    [mutableDict setValue:[NSNumber numberWithDouble:self.stopLoss] forKey:kIndexRecordBaseClassStopLoss];
    [mutableDict setValue:self.saleDate forKey:kIndexRecordBaseClassSaleDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.salePrice] forKey:kIndexRecordBaseClassSalePrice];
    [mutableDict setValue:self.createDate forKey:kIndexRecordBaseClassCreateDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.stopProfitPrice] forKey:kIndexRecordBaseClassStopProfitPrice];
    [mutableDict setValue:self.futuresCode forKey:kIndexRecordBaseClassFuturesCode];
    [mutableDict setValue:self.saleOpSource forKey:kIndexRecordBaseClassSaleOpSource];
    [mutableDict setValue:self.rate forKey:kIndexRecordBaseClassRate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.conditionId] forKey:kIndexRecordBaseClassConditionId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.conditionPrice] forKey:kIndexRecordBaseClassConditionPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sizeSymbol] forKey:kIndexRecordBaseClassSizeSymbol];

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

    self.theoryCounterFee = [aDecoder decodeDoubleForKey:kIndexRecordBaseClassTheoryCounterFee];
    self.lossProfit = [aDecoder decodeDoubleForKey:kIndexRecordBaseClassLossProfit];
    self.nickName = [aDecoder decodeObjectForKey:kIndexRecordBaseClassNickName];
    self.status = [aDecoder decodeDoubleForKey:kIndexRecordBaseClassStatus];
    self.couponId = [aDecoder decodeDoubleForKey:kIndexRecordBaseClassCouponId];
    self.tradeType = [aDecoder decodeDoubleForKey:kIndexRecordBaseClassTradeType];
    self.count = [aDecoder decodeDoubleForKey:kIndexRecordBaseClassCount];
    self.futuresId = [aDecoder decodeDoubleForKey:kIndexRecordBaseClassFuturesId];
    self.futuresType = [aDecoder decodeDoubleForKey:kIndexRecordBaseClassFuturesType];
    self.displayId = [aDecoder decodeObjectForKey:kIndexRecordBaseClassDisplayId];
    self.buyDate = [aDecoder decodeObjectForKey:kIndexRecordBaseClassBuyDate];
    self.stopProfit = [aDecoder decodeDoubleForKey:kIndexRecordBaseClassStopProfit];
    self.cashFund = [aDecoder decodeDoubleForKey:kIndexRecordBaseClassCashFund];
    self.stopLossPrice = [aDecoder decodeDoubleForKey:kIndexRecordBaseClassStopLossPrice];
    self.buyPrice = [aDecoder decodeDoubleForKey:kIndexRecordBaseClassBuyPrice];
    self.sysSetSaleDate = [aDecoder decodeObjectForKey:kIndexRecordBaseClassSysSetSaleDate];
    self.internalBaseClassIdentifier = [aDecoder decodeDoubleForKey:kIndexRecordBaseClassId];
    self.financyAllocation = [aDecoder decodeDoubleForKey:kIndexRecordBaseClassFinancyAllocation];
    self.fundType = [aDecoder decodeDoubleForKey:kIndexRecordBaseClassFundType];
    self.counterFee = [aDecoder decodeDoubleForKey:kIndexRecordBaseClassCounterFee];
    self.stopLoss = [aDecoder decodeDoubleForKey:kIndexRecordBaseClassStopLoss];
    self.saleDate = [aDecoder decodeObjectForKey:kIndexRecordBaseClassSaleDate];
    self.salePrice = [aDecoder decodeDoubleForKey:kIndexRecordBaseClassSalePrice];
    self.createDate = [aDecoder decodeObjectForKey:kIndexRecordBaseClassCreateDate];
    self.stopProfitPrice = [aDecoder decodeDoubleForKey:kIndexRecordBaseClassStopProfitPrice];
    self.futuresCode = [aDecoder decodeObjectForKey:kIndexRecordBaseClassFuturesCode];
    self.saleOpSource = [aDecoder decodeObjectForKey:kIndexRecordBaseClassSaleOpSource];
    self.rate = [aDecoder decodeObjectForKey:kIndexRecordBaseClassRate];
    self.conditionId = [aDecoder decodeDoubleForKey:kIndexRecordBaseClassConditionId];
    self.conditionPrice = [aDecoder decodeDoubleForKey:kIndexRecordBaseClassConditionPrice];
    self.sizeSymbol = [aDecoder decodeDoubleForKey:kIndexRecordBaseClassSizeSymbol];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_theoryCounterFee forKey:kIndexRecordBaseClassTheoryCounterFee];
    [aCoder encodeDouble:_lossProfit forKey:kIndexRecordBaseClassLossProfit];
    [aCoder encodeObject:_nickName forKey:kIndexRecordBaseClassNickName];
    [aCoder encodeDouble:_status forKey:kIndexRecordBaseClassStatus];
    [aCoder encodeDouble:_couponId forKey:kIndexRecordBaseClassCouponId];
    [aCoder encodeDouble:_tradeType forKey:kIndexRecordBaseClassTradeType];
    [aCoder encodeDouble:_count forKey:kIndexRecordBaseClassCount];
    [aCoder encodeDouble:_futuresId forKey:kIndexRecordBaseClassFuturesId];
    [aCoder encodeDouble:_futuresType forKey:kIndexRecordBaseClassFuturesType];
    [aCoder encodeObject:_displayId forKey:kIndexRecordBaseClassDisplayId];
    [aCoder encodeObject:_buyDate forKey:kIndexRecordBaseClassBuyDate];
    [aCoder encodeDouble:_stopProfit forKey:kIndexRecordBaseClassStopProfit];
    [aCoder encodeDouble:_cashFund forKey:kIndexRecordBaseClassCashFund];
    [aCoder encodeDouble:_stopLossPrice forKey:kIndexRecordBaseClassStopLossPrice];
    [aCoder encodeDouble:_buyPrice forKey:kIndexRecordBaseClassBuyPrice];
    [aCoder encodeObject:_sysSetSaleDate forKey:kIndexRecordBaseClassSysSetSaleDate];
    [aCoder encodeDouble:_internalBaseClassIdentifier forKey:kIndexRecordBaseClassId];
    [aCoder encodeDouble:_financyAllocation forKey:kIndexRecordBaseClassFinancyAllocation];
    [aCoder encodeDouble:_fundType forKey:kIndexRecordBaseClassFundType];
    [aCoder encodeDouble:_counterFee forKey:kIndexRecordBaseClassCounterFee];
    [aCoder encodeDouble:_stopLoss forKey:kIndexRecordBaseClassStopLoss];
    [aCoder encodeObject:_saleDate forKey:kIndexRecordBaseClassSaleDate];
    [aCoder encodeDouble:_salePrice forKey:kIndexRecordBaseClassSalePrice];
    [aCoder encodeObject:_createDate forKey:kIndexRecordBaseClassCreateDate];
    [aCoder encodeDouble:_stopProfitPrice forKey:kIndexRecordBaseClassStopProfitPrice];
    [aCoder encodeObject:_futuresCode forKey:kIndexRecordBaseClassFuturesCode];
    [aCoder encodeObject:_saleOpSource forKey:kIndexRecordBaseClassSaleOpSource];
    [aCoder encodeObject:_rate forKey:kIndexRecordBaseClassRate];
    [aCoder encodeDouble:_conditionId forKey:kIndexRecordBaseClassConditionId];
    [aCoder encodeDouble:_conditionPrice forKey:kIndexRecordBaseClassConditionPrice];
    [aCoder encodeDouble:_sizeSymbol forKey:kIndexRecordBaseClassSizeSymbol];
}

- (id)copyWithZone:(NSZone *)zone
{
    IndexRecordModel *copy = [[IndexRecordModel alloc] init];
    
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
        copy.buyPrice = self.buyPrice;
        copy.sysSetSaleDate = [self.sysSetSaleDate copyWithZone:zone];
        copy.internalBaseClassIdentifier = self.internalBaseClassIdentifier;
        copy.financyAllocation = self.financyAllocation;
        copy.fundType = self.fundType;
        copy.counterFee = self.counterFee;
        copy.stopLoss = self.stopLoss;
        copy.saleDate = [self.saleDate copyWithZone:zone];
        copy.salePrice = self.salePrice ;
        copy.createDate = [self.createDate copyWithZone:zone];
        copy.stopProfitPrice = self.stopProfitPrice;
        copy.futuresCode = [self.futuresCode copyWithZone:zone];
        copy.saleOpSource = [self.saleOpSource copyWithZone:zone];
        copy.rate = [self.rate copyWithZone:zone];
        copy.conditionId = self.conditionId;
        copy.conditionPrice = self.conditionPrice;
        copy.sizeSymbol = self.sizeSymbol;
    }
    
    return copy;
}


@end
