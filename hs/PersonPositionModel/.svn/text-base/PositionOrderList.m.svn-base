//
//  PositionOrderList.m
//
//  Created by   on 15/7/8
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "PositionOrderList.h"

NSString *const kPositionOrderListMultiple = @"multiple";
NSString *const kPositionOrderListWarnAmt = @"warnAmt";
NSString *const kPositionOrderListMaxLossPrice = @"maxLossPrice";
NSString *const kPositionOrderListTradeDayCount = @"tradeDayCount";
NSString *const kPositionOrderListStockId = @"stockId";
NSString *const kPositionOrderListNickName = @"nickName";
NSString *const kPositionOrderListStatus = @"status";
NSString *const kPositionOrderListFactBuyCount = @"factBuyCount";
NSString *const kPositionOrderListCouponId = @"couponId";
NSString *const kPositionOrderListHeadPic = @"headPic";
NSString *const kPositionOrderListInterest = @"interest";
NSString *const kPositionOrderListFactBorrowAmt = @"factBorrowAmt";
NSString *const kPositionOrderListStockCode = @"stockCode";
NSString *const kPositionOrderListDisplayId = @"displayId";
NSString *const kPositionOrderListBuyDate = @"buyDate";
NSString *const kPositionOrderListCashFund = @"cashFund";
NSString *const kPositionOrderListStockName = @"stockName";
NSString *const kPositionOrderListBuyPrice = @"buyPrice";
NSString *const kPositionOrderListCurPrice = @"curPrice";
NSString *const kPositionOrderListPreClosePrice = @"preClosePrice";
NSString *const kPositionOrderListTraderId = @"traderId";
NSString *const kPositionOrderListSysSetSaleDate = @"sysSetSaleDate";
NSString *const kPositionOrderListId = @"id";
NSString *const kPositionOrderListFundType = @"fundType";
NSString *const kPositionOrderListFinancyAllocation = @"financyAllocation";
NSString *const kPositionOrderListTotalInterest = @"totalInterest";
NSString *const kPositionOrderListCounterFee = @"counterFee";
NSString *const kPositionOrderListOrderPayAmt = @"orderPayAmt";
NSString *const kPositionOrderListMaxLoss = @"maxLoss";
NSString *const kPositionOrderListTypeCode = @"typeCode";


@interface PositionOrderList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PositionOrderList

@synthesize multiple = _multiple;
@synthesize warnAmt = _warnAmt;
@synthesize maxLossPrice = _maxLossPrice;
@synthesize tradeDayCount = _tradeDayCount;
@synthesize stockId = _stockId;
@synthesize nickName = _nickName;
@synthesize status = _status;
@synthesize factBuyCount = _factBuyCount;
@synthesize couponId = _couponId;
@synthesize headPic = _headPic;
@synthesize interest = _interest;
@synthesize factBorrowAmt = _factBorrowAmt;
@synthesize stockCode = _stockCode;
@synthesize displayId = _displayId;
@synthesize buyDate = _buyDate;
@synthesize cashFund = _cashFund;
@synthesize stockName = _stockName;
@synthesize buyPrice = _buyPrice;
@synthesize curPrice = _curPrice;
@synthesize preClosePrice = _preClosePrice;

@synthesize traderId = _traderId;
@synthesize sysSetSaleDate = _sysSetSaleDate;
@synthesize orderListIdentifier = _orderListIdentifier;
@synthesize fundType = _fundType;
@synthesize financyAllocation = _financyAllocation;
@synthesize totalInterest = _totalInterest;
@synthesize counterFee = _counterFee;
@synthesize orderPayAmt = _orderPayAmt;
@synthesize maxLoss = _maxLoss;
@synthesize typeCode = _typeCode;


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
        
        
        self.multiple = [[self objectOrNilForKey:kPositionOrderListMultiple fromDictionary:dict]intValue];
            self.warnAmt = [[self objectOrNilForKey:kPositionOrderListWarnAmt fromDictionary:dict] doubleValue];
            self.maxLossPrice = [[self objectOrNilForKey:kPositionOrderListMaxLossPrice fromDictionary:dict ]doubleValue];
            self.tradeDayCount = [[self objectOrNilForKey:kPositionOrderListTradeDayCount fromDictionary:dict] doubleValue];
            self.stockId = [[self objectOrNilForKey:kPositionOrderListStockId fromDictionary:dict] doubleValue];
            self.nickName = [self objectOrNilForKey:kPositionOrderListNickName fromDictionary:dict];
            self.status = [[self objectOrNilForKey:kPositionOrderListStatus fromDictionary:dict] doubleValue];
            self.factBuyCount = [[self objectOrNilForKey:kPositionOrderListFactBuyCount fromDictionary:dict]doubleValue];
            self.couponId = [[self objectOrNilForKey:kPositionOrderListCouponId fromDictionary:dict] doubleValue];
            self.headPic = [self objectOrNilForKey:kPositionOrderListHeadPic fromDictionary:dict];
            self.interest = [[self objectOrNilForKey:kPositionOrderListInterest fromDictionary:dict] doubleValue];
            self.factBorrowAmt = [[self objectOrNilForKey:kPositionOrderListFactBorrowAmt fromDictionary:dict] doubleValue];
            self.stockCode = [self objectOrNilForKey:kPositionOrderListStockCode fromDictionary:dict];
            self.displayId = [self objectOrNilForKey:kPositionOrderListDisplayId fromDictionary:dict];
            self.buyDate = [self objectOrNilForKey:kPositionOrderListBuyDate fromDictionary:dict];
            self.cashFund = [[self objectOrNilForKey:kPositionOrderListCashFund fromDictionary:dict] doubleValue];
            self.stockName = [self objectOrNilForKey:kPositionOrderListStockName fromDictionary:dict];
            self.buyPrice = [[self objectOrNilForKey:kPositionOrderListBuyPrice fromDictionary:dict] doubleValue];
            self.curPrice = [[self objectOrNilForKey:kPositionOrderListCurPrice fromDictionary:dict] doubleValue];
            self.preClosePrice = [[self objectOrNilForKey:kPositionOrderListPreClosePrice fromDictionary:dict] doubleValue];

            self.traderId = [[self objectOrNilForKey:kPositionOrderListTraderId fromDictionary:dict] doubleValue];
            self.sysSetSaleDate = [self objectOrNilForKey:kPositionOrderListSysSetSaleDate fromDictionary:dict];
            self.orderListIdentifier = [[self objectOrNilForKey:kPositionOrderListId fromDictionary:dict] doubleValue];
            self.fundType = [[self objectOrNilForKey:kPositionOrderListFundType fromDictionary:dict] doubleValue];
            self.financyAllocation = [[self objectOrNilForKey:kPositionOrderListFinancyAllocation fromDictionary:dict] doubleValue];
            self.totalInterest = [[self objectOrNilForKey:kPositionOrderListTotalInterest fromDictionary:dict] doubleValue];
            self.counterFee = [[self objectOrNilForKey:kPositionOrderListCounterFee fromDictionary:dict] doubleValue];
            self.orderPayAmt = [[self objectOrNilForKey:kPositionOrderListOrderPayAmt fromDictionary:dict] doubleValue];
            self.maxLoss = [[self objectOrNilForKey:kPositionOrderListMaxLoss fromDictionary:dict] doubleValue];
            self.typeCode = [self objectOrNilForKey:kPositionOrderListTypeCode fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithInt:self.multiple] forKey:kPositionOrderListMultiple];
    [mutableDict setValue:[NSNumber numberWithDouble:self.warnAmt] forKey:kPositionOrderListWarnAmt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.maxLossPrice] forKey:kPositionOrderListMaxLossPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.tradeDayCount] forKey:kPositionOrderListTradeDayCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.stockId] forKey:kPositionOrderListStockId];
    [mutableDict setValue:self.nickName forKey:kPositionOrderListNickName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kPositionOrderListStatus];
    [mutableDict setValue:[NSNumber numberWithDouble:self.factBuyCount] forKey:kPositionOrderListFactBuyCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.couponId] forKey:kPositionOrderListCouponId];
    [mutableDict setValue:self.headPic forKey:kPositionOrderListHeadPic];
    [mutableDict setValue:[NSNumber numberWithDouble:self.interest] forKey:kPositionOrderListInterest];
    [mutableDict setValue:[NSNumber numberWithDouble:self.factBorrowAmt] forKey:kPositionOrderListFactBorrowAmt];
    [mutableDict setValue:self.stockCode forKey:kPositionOrderListStockCode];
    [mutableDict setValue:self.displayId forKey:kPositionOrderListDisplayId];
    [mutableDict setValue:self.buyDate forKey:kPositionOrderListBuyDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cashFund] forKey:kPositionOrderListCashFund];
    [mutableDict setValue:self.stockName forKey:kPositionOrderListStockName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buyPrice] forKey:kPositionOrderListBuyPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.curPrice] forKey:kPositionOrderListCurPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.preClosePrice] forKey:kPositionOrderListPreClosePrice];

    [mutableDict setValue:[NSNumber numberWithDouble:self.traderId] forKey:kPositionOrderListTraderId];
    [mutableDict setValue:self.sysSetSaleDate forKey:kPositionOrderListSysSetSaleDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderListIdentifier] forKey:kPositionOrderListId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.fundType] forKey:kPositionOrderListFundType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.financyAllocation] forKey:kPositionOrderListFinancyAllocation];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalInterest] forKey:kPositionOrderListTotalInterest];
    [mutableDict setValue:[NSNumber numberWithDouble:self.counterFee] forKey:kPositionOrderListCounterFee];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderPayAmt] forKey:kPositionOrderListOrderPayAmt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.maxLoss] forKey:kPositionOrderListMaxLoss];
    [mutableDict setValue:self.typeCode forKey:kPositionOrderListTypeCode];

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
    self.multiple = [aDecoder decodeIntForKey:kPositionOrderListMultiple];
    self.warnAmt = [aDecoder decodeDoubleForKey:kPositionOrderListWarnAmt];
    self.maxLossPrice = [aDecoder decodeDoubleForKey:kPositionOrderListMaxLossPrice];
    self.tradeDayCount = [aDecoder decodeDoubleForKey:kPositionOrderListTradeDayCount];
    self.stockId = [aDecoder decodeDoubleForKey:kPositionOrderListStockId];
    self.nickName = [aDecoder decodeObjectForKey:kPositionOrderListNickName];
    self.status = [aDecoder decodeDoubleForKey:kPositionOrderListStatus];
    self.factBuyCount = [aDecoder decodeDoubleForKey:kPositionOrderListFactBuyCount];
    self.couponId = [aDecoder decodeDoubleForKey:kPositionOrderListCouponId];
    self.headPic = [aDecoder decodeObjectForKey:kPositionOrderListHeadPic];
    self.interest = [aDecoder decodeDoubleForKey:kPositionOrderListInterest];
    self.factBorrowAmt = [aDecoder decodeDoubleForKey:kPositionOrderListFactBorrowAmt];
    self.stockCode = [aDecoder decodeObjectForKey:kPositionOrderListStockCode];
    self.displayId = [aDecoder decodeObjectForKey:kPositionOrderListDisplayId];
    self.buyDate = [aDecoder decodeObjectForKey:kPositionOrderListBuyDate];
    self.cashFund = [aDecoder decodeDoubleForKey:kPositionOrderListCashFund];
    self.stockName = [aDecoder decodeObjectForKey:kPositionOrderListStockName];
    self.buyPrice = [aDecoder decodeDoubleForKey:kPositionOrderListBuyPrice];
    self.curPrice = [aDecoder decodeDoubleForKey:kPositionOrderListCurPrice];
    self.preClosePrice = [aDecoder decodeDoubleForKey:kPositionOrderListPreClosePrice];

    self.traderId = [aDecoder decodeDoubleForKey:kPositionOrderListTraderId];
    self.sysSetSaleDate = [aDecoder decodeObjectForKey:kPositionOrderListSysSetSaleDate];
    self.orderListIdentifier = [aDecoder decodeDoubleForKey:kPositionOrderListId];
    self.fundType = [aDecoder decodeDoubleForKey:kPositionOrderListFundType];
    self.financyAllocation = [aDecoder decodeDoubleForKey:kPositionOrderListFinancyAllocation];
    self.totalInterest = [aDecoder decodeDoubleForKey:kPositionOrderListTotalInterest];
    self.counterFee = [aDecoder decodeDoubleForKey:kPositionOrderListCounterFee];
    self.orderPayAmt = [aDecoder decodeDoubleForKey:kPositionOrderListOrderPayAmt];
    self.maxLoss = [aDecoder decodeDoubleForKey:kPositionOrderListMaxLoss];
    self.typeCode = [aDecoder decodeObjectForKey:kPositionOrderListTypeCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:_multiple forKey:kPositionOrderListMultiple];
    [aCoder encodeDouble:_warnAmt forKey:kPositionOrderListWarnAmt];
    [aCoder encodeDouble:_maxLossPrice forKey:kPositionOrderListMaxLossPrice];
    [aCoder encodeDouble:_tradeDayCount forKey:kPositionOrderListTradeDayCount];
    [aCoder encodeDouble:_stockId forKey:kPositionOrderListStockId];
    [aCoder encodeObject:_nickName forKey:kPositionOrderListNickName];
    [aCoder encodeDouble:_status forKey:kPositionOrderListStatus];
    [aCoder encodeDouble:_factBuyCount forKey:kPositionOrderListFactBuyCount];
    [aCoder encodeDouble:_couponId forKey:kPositionOrderListCouponId];
    [aCoder encodeObject:_headPic forKey:kPositionOrderListHeadPic];
    [aCoder encodeDouble:_interest forKey:kPositionOrderListInterest];
    [aCoder encodeDouble:_factBorrowAmt forKey:kPositionOrderListFactBorrowAmt];
    [aCoder encodeObject:_stockCode forKey:kPositionOrderListStockCode];
    [aCoder encodeObject:_displayId forKey:kPositionOrderListDisplayId];
    [aCoder encodeObject:_buyDate forKey:kPositionOrderListBuyDate];
    [aCoder encodeDouble:_cashFund forKey:kPositionOrderListCashFund];
    [aCoder encodeObject:_stockName forKey:kPositionOrderListStockName];
    [aCoder encodeDouble:_buyPrice forKey:kPositionOrderListBuyPrice];
    [aCoder encodeDouble:_curPrice forKey:kPositionOrderListCurPrice];
    [aCoder encodeDouble:_preClosePrice forKey:kPositionOrderListPreClosePrice];

    [aCoder encodeDouble:_traderId forKey:kPositionOrderListTraderId];
    [aCoder encodeObject:_sysSetSaleDate forKey:kPositionOrderListSysSetSaleDate];
    [aCoder encodeDouble:_orderListIdentifier forKey:kPositionOrderListId];
    [aCoder encodeDouble:_fundType forKey:kPositionOrderListFundType];
    [aCoder encodeDouble:_financyAllocation forKey:kPositionOrderListFinancyAllocation];
    [aCoder encodeDouble:_totalInterest forKey:kPositionOrderListTotalInterest];
    [aCoder encodeDouble:_counterFee forKey:kPositionOrderListCounterFee];
    [aCoder encodeDouble:_orderPayAmt forKey:kPositionOrderListOrderPayAmt];
    [aCoder encodeDouble:_maxLoss forKey:kPositionOrderListMaxLoss];
    [aCoder encodeObject:_typeCode forKey:kPositionOrderListTypeCode];
}

- (id)copyWithZone:(NSZone *)zone
{
    PositionOrderList *copy = [[PositionOrderList alloc] init];
    
    if (copy) {
        copy.multiple = self.multiple;
        copy.warnAmt = self.warnAmt;
        copy.maxLossPrice = self.maxLossPrice ;
        copy.tradeDayCount = self.tradeDayCount;
        copy.stockId = self.stockId;
        copy.nickName = [self.nickName copyWithZone:zone];
        copy.status = self.status;
        copy.factBuyCount = self.factBuyCount;
        copy.couponId = self.couponId;
        copy.headPic = [self.headPic copyWithZone:zone];
        copy.interest = self.interest;
        copy.factBorrowAmt = self.factBorrowAmt;
        copy.stockCode = [self.stockCode copyWithZone:zone];
        copy.displayId = [self.displayId copyWithZone:zone];
        copy.buyDate = [self.buyDate copyWithZone:zone];
        copy.cashFund = self.cashFund;
        copy.stockName = [self.stockName copyWithZone:zone];
        copy.buyPrice = self.buyPrice;
        copy.curPrice = self.curPrice;
        copy.preClosePrice = self.preClosePrice;

        copy.traderId = self.traderId;
        copy.sysSetSaleDate = [self.sysSetSaleDate copyWithZone:zone];
        copy.orderListIdentifier = self.orderListIdentifier;
        copy.fundType = self.fundType;
        copy.financyAllocation = self.financyAllocation;
        copy.totalInterest = self.totalInterest;
        copy.counterFee = self.counterFee;
        copy.orderPayAmt = self.orderPayAmt;
        copy.maxLoss = self.maxLoss;
        copy.typeCode = [self.typeCode copyWithZone:zone];
    }
    
    return copy;
}


@end
