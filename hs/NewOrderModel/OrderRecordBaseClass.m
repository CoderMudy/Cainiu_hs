//
//  OrderRecordBaseClass.m
//
//  Created by   on 15/5/20
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "OrderRecordBaseClass.h"


NSString *const kOrderRecordBaseClassCurPrice = @"curPrice";
NSString *const kOrderRecordBaseClassExchangeType = @"exchangeType";
NSString *const kOrderRecordBaseClassScoreMarketValue = @"scoreMarketValue";
NSString *const kOrderRecordBaseClassNickName = @"nickName";
NSString *const kOrderRecordBaseClassStatus = @"status";
NSString *const kOrderRecordBaseClassRankScore = @"rankScore";
NSString *const kOrderRecordBaseClassMarketValue = @"marketValue";
NSString *const kOrderRecordBaseClassFinishDate = @"finishDate";
NSString *const kOrderRecordBaseClassStockAcc = @"stockAcc";
NSString *const kOrderRecordBaseClassBuyCount = @"buyCount";
NSString *const kOrderRecordBaseClassPlateName = @"plateName";
NSString *const kOrderRecordBaseClassIncomeRate = @"incomeRate";
NSString *const kOrderRecordBaseClassStockCode = @"stockCode";
NSString *const kOrderRecordBaseClassCashFund = @"cashFund";
NSString *const kOrderRecordBaseClassBuyPrice = @"buyPrice";
NSString *const kOrderRecordBaseClassBuyType = @"buyType";
NSString *const kOrderRecordBaseClassStockName = @"stockName";
NSString *const kOrderRecordBaseClassCurCashProfit = @"curCashProfit";
NSString *const kOrderRecordBaseClassOperateAmt = @"operateAmt";
NSString *const kOrderRecordBaseClassOpenPrice = @"openPrice";
NSString *const kOrderRecordBaseClassQuantity = @"quantity";
NSString *const kOrderRecordBaseClassCounterFee = @"counterFee";
NSString *const kOrderRecordBaseClassPlateCode = @"plateCode";
NSString *const kOrderRecordBaseClassCurScoreProfit = @"curScoreProfit";
NSString *const kOrderRecordBaseClassSalePrice = @"salePrice";
NSString *const kOrderRecordBaseClassOrderdetailId = @"orderdetailId";
NSString *const kOrderRecordBaseClassLossFund = @"lossFund";
NSString *const kOrderRecordBaseClassProType = @"proType";
NSString *const kOrderRecordBaseClassCreateDate = @"createDate";
NSString *const kOrderRecordBaseClassStockCodeType = @"stockCodeType";
NSString *const kOrderRecordBaseClassOrderId = @"orderId";
NSString *const kOrderRecordBaseClassUserId = @"userId";


@interface OrderRecordBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OrderRecordBaseClass

@synthesize curPrice = _curPrice;
@synthesize exchangeType = _exchangeType;
@synthesize scoreMarketValue = _scoreMarketValue;
@synthesize nickName = _nickName;
@synthesize status = _status;
@synthesize rankScore = _rankScore;
@synthesize marketValue = _marketValue;
@synthesize finishDate = _finishDate;
@synthesize stockAcc = _stockAcc;
@synthesize buyCount = _buyCount;
@synthesize plateName = _plateName;
@synthesize incomeRate = _incomeRate;
@synthesize stockCode = _stockCode;
@synthesize cashFund = _cashFund;
@synthesize buyPrice = _buyPrice;
@synthesize buyType = _buyType;
@synthesize stockName = _stockName;
@synthesize curCashProfit = _curCashProfit;
@synthesize operateAmt = _operateAmt;
@synthesize openPrice = _openPrice;
@synthesize quantity = _quantity;
@synthesize counterFee = _counterFee;
@synthesize plateCode = _plateCode;
@synthesize curScoreProfit = _curScoreProfit;
@synthesize salePrice = _salePrice;
@synthesize orderdetailId = _orderdetailId;
@synthesize lossFund = _lossFund;
@synthesize proType = _proType;
@synthesize createDate = _createDate;
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
            self.curPrice = [self objectOrNilForKey:kOrderRecordBaseClassCurPrice fromDictionary:dict];
            self.exchangeType = [self objectOrNilForKey:kOrderRecordBaseClassExchangeType fromDictionary:dict];
            self.scoreMarketValue = [self objectOrNilForKey:kOrderRecordBaseClassScoreMarketValue fromDictionary:dict];
            self.nickName = [self objectOrNilForKey:kOrderRecordBaseClassNickName fromDictionary:dict];
            self.status = [[self objectOrNilForKey:kOrderRecordBaseClassStatus fromDictionary:dict] doubleValue];
            self.rankScore = [[self objectOrNilForKey:kOrderRecordBaseClassRankScore fromDictionary:dict] doubleValue];
            self.marketValue = [self objectOrNilForKey:kOrderRecordBaseClassMarketValue fromDictionary:dict];
            self.finishDate = [self objectOrNilForKey:kOrderRecordBaseClassFinishDate fromDictionary:dict];
            self.stockAcc = [self objectOrNilForKey:kOrderRecordBaseClassStockAcc fromDictionary:dict];
            self.buyCount = [self objectOrNilForKey:kOrderRecordBaseClassBuyCount fromDictionary:dict];
            self.plateName = [self objectOrNilForKey:kOrderRecordBaseClassPlateName fromDictionary:dict];
            self.incomeRate = [self objectOrNilForKey:kOrderRecordBaseClassIncomeRate fromDictionary:dict];
            self.stockCode = [self objectOrNilForKey:kOrderRecordBaseClassStockCode fromDictionary:dict];
            self.cashFund = [self objectOrNilForKey:kOrderRecordBaseClassCashFund fromDictionary:dict];
            self.buyPrice = [self objectOrNilForKey:kOrderRecordBaseClassBuyPrice fromDictionary:dict];
            self.buyType = [self objectOrNilForKey:kOrderRecordBaseClassBuyType fromDictionary:dict];
            self.stockName = [self objectOrNilForKey:kOrderRecordBaseClassStockName fromDictionary:dict];
            self.curCashProfit = [self objectOrNilForKey:kOrderRecordBaseClassCurCashProfit fromDictionary:dict];
            self.operateAmt = [self objectOrNilForKey:kOrderRecordBaseClassOperateAmt fromDictionary:dict];
            self.openPrice = [self objectOrNilForKey:kOrderRecordBaseClassOpenPrice fromDictionary:dict];
            self.quantity = [self objectOrNilForKey:kOrderRecordBaseClassQuantity fromDictionary:dict];
            self.counterFee = [self objectOrNilForKey:kOrderRecordBaseClassCounterFee fromDictionary:dict];
            self.plateCode = [self objectOrNilForKey:kOrderRecordBaseClassPlateCode fromDictionary:dict];
            self.curScoreProfit = [self objectOrNilForKey:kOrderRecordBaseClassCurScoreProfit fromDictionary:dict];
            self.salePrice = [self objectOrNilForKey:kOrderRecordBaseClassSalePrice fromDictionary:dict];
            self.orderdetailId = [self objectOrNilForKey:kOrderRecordBaseClassOrderdetailId fromDictionary:dict];
            self.lossFund = [self objectOrNilForKey:kOrderRecordBaseClassLossFund fromDictionary:dict];
            self.proType = [self objectOrNilForKey:kOrderRecordBaseClassProType fromDictionary:dict];
            self.createDate = [self objectOrNilForKey:kOrderRecordBaseClassCreateDate fromDictionary:dict];
            self.stockCodeType = [self objectOrNilForKey:kOrderRecordBaseClassStockCodeType fromDictionary:dict];
            self.orderId = [self objectOrNilForKey:kOrderRecordBaseClassOrderId fromDictionary:dict];
            self.userId = [self objectOrNilForKey:kOrderRecordBaseClassUserId fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.curPrice forKey:kOrderRecordBaseClassCurPrice];
    [mutableDict setValue:self.exchangeType forKey:kOrderRecordBaseClassExchangeType];
    [mutableDict setValue:self.scoreMarketValue forKey:kOrderRecordBaseClassScoreMarketValue];
    [mutableDict setValue:self.nickName forKey:kOrderRecordBaseClassNickName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kOrderRecordBaseClassStatus];
    [mutableDict setValue:[NSNumber numberWithDouble:self.rankScore] forKey:kOrderRecordBaseClassRankScore];
    [mutableDict setValue:self.marketValue forKey:kOrderRecordBaseClassMarketValue];
    [mutableDict setValue:self.finishDate forKey:kOrderRecordBaseClassFinishDate];
    [mutableDict setValue:self.stockAcc forKey:kOrderRecordBaseClassStockAcc];
    [mutableDict setValue:self.buyCount forKey:kOrderRecordBaseClassBuyCount];
    [mutableDict setValue:self.plateName forKey:kOrderRecordBaseClassPlateName];
    [mutableDict setValue:self.incomeRate forKey:kOrderRecordBaseClassIncomeRate];
    [mutableDict setValue:self.stockCode forKey:kOrderRecordBaseClassStockCode];
    [mutableDict setValue:self.cashFund forKey:kOrderRecordBaseClassCashFund];
    [mutableDict setValue:self.buyPrice forKey:kOrderRecordBaseClassBuyPrice];
    [mutableDict setValue:self.buyType forKey:kOrderRecordBaseClassBuyType];
    [mutableDict setValue:self.stockName forKey:kOrderRecordBaseClassStockName];
    [mutableDict setValue:self.curCashProfit forKey:kOrderRecordBaseClassCurCashProfit];
    [mutableDict setValue:self.operateAmt forKey:kOrderRecordBaseClassOperateAmt];
    [mutableDict setValue:self.openPrice forKey:kOrderRecordBaseClassOpenPrice];
    [mutableDict setValue:self.quantity forKey:kOrderRecordBaseClassQuantity];
    [mutableDict setValue:self.counterFee forKey:kOrderRecordBaseClassCounterFee];
    [mutableDict setValue:self.plateCode forKey:kOrderRecordBaseClassPlateCode];
    [mutableDict setValue:self.curScoreProfit forKey:kOrderRecordBaseClassCurScoreProfit];
    [mutableDict setValue:self.salePrice forKey:kOrderRecordBaseClassSalePrice];
    [mutableDict setValue:self.orderdetailId forKey:kOrderRecordBaseClassOrderdetailId];
    [mutableDict setValue:self.lossFund forKey:kOrderRecordBaseClassLossFund];
    [mutableDict setValue:self.proType forKey:kOrderRecordBaseClassProType];
    [mutableDict setValue:self.createDate forKey:kOrderRecordBaseClassCreateDate];
    [mutableDict setValue:self.stockCodeType forKey:kOrderRecordBaseClassStockCodeType];
    [mutableDict setValue:self.orderId forKey:kOrderRecordBaseClassOrderId];
    [mutableDict setValue:self.userId forKey:kOrderRecordBaseClassUserId];

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

    self.curPrice = [aDecoder decodeObjectForKey:kOrderRecordBaseClassCurPrice];
    self.exchangeType = [aDecoder decodeObjectForKey:kOrderRecordBaseClassExchangeType];
    self.scoreMarketValue = [aDecoder decodeObjectForKey:kOrderRecordBaseClassScoreMarketValue];
    self.nickName = [aDecoder decodeObjectForKey:kOrderRecordBaseClassNickName];
    self.status = [aDecoder decodeDoubleForKey:kOrderRecordBaseClassStatus];
    self.rankScore = [aDecoder decodeDoubleForKey:kOrderRecordBaseClassRankScore];
    self.marketValue = [aDecoder decodeObjectForKey:kOrderRecordBaseClassMarketValue];
    self.finishDate = [aDecoder decodeObjectForKey:kOrderRecordBaseClassFinishDate];
    self.stockAcc = [aDecoder decodeObjectForKey:kOrderRecordBaseClassStockAcc];
    self.buyCount = [aDecoder decodeObjectForKey:kOrderRecordBaseClassBuyCount];
    self.plateName = [aDecoder decodeObjectForKey:kOrderRecordBaseClassPlateName];
    self.incomeRate = [aDecoder decodeObjectForKey:kOrderRecordBaseClassIncomeRate];
    self.stockCode = [aDecoder decodeObjectForKey:kOrderRecordBaseClassStockCode];
    self.cashFund = [aDecoder decodeObjectForKey:kOrderRecordBaseClassCashFund];
    self.buyPrice = [aDecoder decodeObjectForKey:kOrderRecordBaseClassBuyPrice];
    self.buyType = [aDecoder decodeObjectForKey:kOrderRecordBaseClassBuyType];
    self.stockName = [aDecoder decodeObjectForKey:kOrderRecordBaseClassStockName];
    self.curCashProfit = [aDecoder decodeObjectForKey:kOrderRecordBaseClassCurCashProfit];
    self.operateAmt = [aDecoder decodeObjectForKey:kOrderRecordBaseClassOperateAmt];
    self.openPrice = [aDecoder decodeObjectForKey:kOrderRecordBaseClassOpenPrice];
    self.quantity = [aDecoder decodeObjectForKey:kOrderRecordBaseClassQuantity];
    self.counterFee = [aDecoder decodeObjectForKey:kOrderRecordBaseClassCounterFee];
    self.plateCode = [aDecoder decodeObjectForKey:kOrderRecordBaseClassPlateCode];
    self.curScoreProfit = [aDecoder decodeObjectForKey:kOrderRecordBaseClassCurScoreProfit];
    self.salePrice = [aDecoder decodeObjectForKey:kOrderRecordBaseClassSalePrice];
    self.orderdetailId = [aDecoder decodeObjectForKey:kOrderRecordBaseClassOrderdetailId];
    self.lossFund = [aDecoder decodeObjectForKey:kOrderRecordBaseClassLossFund];
    self.proType = [aDecoder decodeObjectForKey:kOrderRecordBaseClassProType];
    self.createDate = [aDecoder decodeObjectForKey:kOrderRecordBaseClassCreateDate];
    self.stockCodeType = [aDecoder decodeObjectForKey:kOrderRecordBaseClassStockCodeType];
    self.orderId = [aDecoder decodeObjectForKey:kOrderRecordBaseClassOrderId];
    self.userId = [aDecoder decodeObjectForKey:kOrderRecordBaseClassUserId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_curPrice forKey:kOrderRecordBaseClassCurPrice];
    [aCoder encodeObject:_exchangeType forKey:kOrderRecordBaseClassExchangeType];
    [aCoder encodeObject:_scoreMarketValue forKey:kOrderRecordBaseClassScoreMarketValue];
    [aCoder encodeObject:_nickName forKey:kOrderRecordBaseClassNickName];
    [aCoder encodeDouble:_status forKey:kOrderRecordBaseClassStatus];
    [aCoder encodeDouble:_rankScore forKey:kOrderRecordBaseClassRankScore];
    [aCoder encodeObject:_marketValue forKey:kOrderRecordBaseClassMarketValue];
    [aCoder encodeObject:_finishDate forKey:kOrderRecordBaseClassFinishDate];
    [aCoder encodeObject:_stockAcc forKey:kOrderRecordBaseClassStockAcc];
    [aCoder encodeObject:_buyCount forKey:kOrderRecordBaseClassBuyCount];
    [aCoder encodeObject:_plateName forKey:kOrderRecordBaseClassPlateName];
    [aCoder encodeObject:_incomeRate forKey:kOrderRecordBaseClassIncomeRate];
    [aCoder encodeObject:_stockCode forKey:kOrderRecordBaseClassStockCode];
    [aCoder encodeObject:_cashFund forKey:kOrderRecordBaseClassCashFund];
    [aCoder encodeObject:_buyPrice forKey:kOrderRecordBaseClassBuyPrice];
    [aCoder encodeObject:_buyType forKey:kOrderRecordBaseClassBuyType];
    [aCoder encodeObject:_stockName forKey:kOrderRecordBaseClassStockName];
    [aCoder encodeObject:_curCashProfit forKey:kOrderRecordBaseClassCurCashProfit];
    [aCoder encodeObject:_operateAmt forKey:kOrderRecordBaseClassOperateAmt];
    [aCoder encodeObject:_openPrice forKey:kOrderRecordBaseClassOpenPrice];
    [aCoder encodeObject:_quantity forKey:kOrderRecordBaseClassQuantity];
    [aCoder encodeObject:_counterFee forKey:kOrderRecordBaseClassCounterFee];
    [aCoder encodeObject:_plateCode forKey:kOrderRecordBaseClassPlateCode];
    [aCoder encodeObject:_curScoreProfit forKey:kOrderRecordBaseClassCurScoreProfit];
    [aCoder encodeObject:_salePrice forKey:kOrderRecordBaseClassSalePrice];
    [aCoder encodeObject:_orderdetailId forKey:kOrderRecordBaseClassOrderdetailId];
    [aCoder encodeObject:_lossFund forKey:kOrderRecordBaseClassLossFund];
    [aCoder encodeObject:_proType forKey:kOrderRecordBaseClassProType];
    [aCoder encodeObject:_createDate forKey:kOrderRecordBaseClassCreateDate];
    [aCoder encodeObject:_stockCodeType forKey:kOrderRecordBaseClassStockCodeType];
    [aCoder encodeObject:_orderId forKey:kOrderRecordBaseClassOrderId];
    [aCoder encodeObject:_userId forKey:kOrderRecordBaseClassUserId];
}

- (id)copyWithZone:(NSZone *)zone
{
    OrderRecordBaseClass *copy = [[OrderRecordBaseClass alloc] init];
    
    if (copy) {

        copy.curPrice = [self.curPrice copyWithZone:zone];
        copy.exchangeType = [self.exchangeType copyWithZone:zone];
        copy.scoreMarketValue = [self.scoreMarketValue copyWithZone:zone];
        copy.nickName = [self.nickName copyWithZone:zone];
        copy.status = self.status;
        copy.rankScore = self.rankScore;
        copy.marketValue = [self.marketValue copyWithZone:zone];
        copy.finishDate = [self.finishDate copyWithZone:zone];
        copy.stockAcc = [self.stockAcc copyWithZone:zone];
        copy.buyCount = [self.buyCount copyWithZone:zone];
        copy.plateName = [self.plateName copyWithZone:zone];
        copy.incomeRate = [self.incomeRate copyWithZone:zone];
        copy.stockCode = [self.stockCode copyWithZone:zone];
        copy.cashFund = [self.cashFund copyWithZone:zone];
        copy.buyPrice = [self.buyPrice copyWithZone:zone];
        copy.buyType = [self.buyType copyWithZone:zone];
        copy.stockName = [self.stockName copyWithZone:zone];
        copy.curCashProfit = [self.curCashProfit copyWithZone:zone];
        copy.operateAmt = [self.operateAmt copyWithZone:zone];
        copy.openPrice = [self.openPrice copyWithZone:zone];
        copy.quantity = [self.quantity copyWithZone:zone];
        copy.counterFee = [self.counterFee copyWithZone:zone];
        copy.plateCode = [self.plateCode copyWithZone:zone];
        copy.curScoreProfit = [self.curScoreProfit copyWithZone:zone];
        copy.salePrice = [self.salePrice copyWithZone:zone];
        copy.orderdetailId = [self.orderdetailId copyWithZone:zone];
        copy.lossFund = [self.lossFund copyWithZone:zone];
        copy.proType = [self.proType copyWithZone:zone];
        copy.createDate = [self.createDate copyWithZone:zone];
        copy.stockCodeType = [self.stockCodeType copyWithZone:zone];
        copy.orderId = [self.orderId copyWithZone:zone];
        copy.userId = [self.userId copyWithZone:zone];
    }
    
    return copy;
}


@end
