//
//  SaleOrderBaseClass.m
//
//  Created by   on 15/6/1
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "SaleOrderBaseClass.h"


NSString *const kSaleOrderBaseClassUserId = @"userId";
NSString *const kSaleOrderBaseClassCodeType = @"codeType";
NSString *const kSaleOrderBaseClassLossProfit = @"lossProfit";
NSString *const kSaleOrderBaseClassExchangeType = @"exchangeType";
NSString *const kSaleOrderBaseClassNickName = @"nickName";
NSString *const kSaleOrderBaseClassStatus = @"status";
NSString *const kSaleOrderBaseClassMarketValue = @"marketValue";
NSString *const kSaleOrderBaseClassHsEntrustNo = @"hsEntrustNo";
NSString *const kSaleOrderBaseClassStockCode = @"stockCode";
NSString *const kSaleOrderBaseClassCashFund = @"cashFund";
NSString *const kSaleOrderBaseClassBuyPrice = @"buyPrice";
NSString *const kSaleOrderBaseClassBuyType = @"buyType";
NSString *const kSaleOrderBaseClassLossAmt = @"lossAmt";
NSString *const kSaleOrderBaseClassFactCount = @"factCount";
NSString *const kSaleOrderBaseClassSaleType = @"saleType";
NSString *const kSaleOrderBaseClassId = @"id";
NSString *const kSaleOrderBaseClassQuantity = @"quantity";
NSString *const kSaleOrderBaseClassHsSaleEntrustNo = @"hsSaleEntrustNo";
NSString *const kSaleOrderBaseClassCounterFee = @"counterFee";
NSString *const kSaleOrderBaseClassAmt = @"amt";
NSString *const kSaleOrderBaseClassPlateType = @"plateType";
NSString *const kSaleOrderBaseClassIsCountProfit = @"isCountProfit";
NSString *const kSaleOrderBaseClassOpenPrice = @"openPrice";
NSString *const kSaleOrderBaseClassPlateCode = @"plateCode";
NSString *const kSaleOrderBaseClassSalePrice = @"salePrice";
NSString *const kSaleOrderBaseClassProType = @"proType";
NSString *const kSaleOrderBaseClassStockAcc = @"stockAcc";
NSString *const kSaleOrderBaseClassStockCom = @"stockCom";
NSString *const kSaleOrderBaseClassFinishDate = @"finishDate";
NSString *const kSaleOrderBaseClassPlateName = @"plateName";
NSString *const kSaleOrderBaseClassOrderId = @"orderId";
NSString *const kSaleOrderBaseClassCreateDate = @"createDate";


@interface SaleOrderBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SaleOrderBaseClass

@synthesize userId = _userId;
@synthesize codeType = _codeType;
@synthesize lossProfit = _lossProfit;
@synthesize exchangeType = _exchangeType;
@synthesize nickName = _nickName;
@synthesize status = _status;
@synthesize marketValue = _marketValue;
@synthesize hsEntrustNo = _hsEntrustNo;
@synthesize stockCode = _stockCode;
@synthesize cashFund = _cashFund;
@synthesize buyPrice = _buyPrice;
@synthesize buyType = _buyType;
@synthesize lossAmt = _lossAmt;
@synthesize factCount = _factCount;
@synthesize saleType = _saleType;
@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize quantity = _quantity;
@synthesize hsSaleEntrustNo = _hsSaleEntrustNo;
@synthesize counterFee = _counterFee;
@synthesize amt = _amt;
@synthesize plateType = _plateType;
@synthesize isCountProfit = _isCountProfit;
@synthesize openPrice = _openPrice;
@synthesize plateCode = _plateCode;
@synthesize salePrice = _salePrice;
@synthesize proType = _proType;
@synthesize stockAcc = _stockAcc;
@synthesize stockCom = _stockCom;
@synthesize finishDate = _finishDate;
@synthesize plateName = _plateName;
@synthesize orderId = _orderId;
@synthesize createDate = _createDate;


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
            self.userId = [[self objectOrNilForKey:kSaleOrderBaseClassUserId fromDictionary:dict] doubleValue];
            self.codeType = [self objectOrNilForKey:kSaleOrderBaseClassCodeType fromDictionary:dict];
            self.lossProfit = [[self objectOrNilForKey:kSaleOrderBaseClassLossProfit fromDictionary:dict] doubleValue];
            self.exchangeType = [self objectOrNilForKey:kSaleOrderBaseClassExchangeType fromDictionary:dict];
            self.nickName = [self objectOrNilForKey:kSaleOrderBaseClassNickName fromDictionary:dict];
            self.status = [[self objectOrNilForKey:kSaleOrderBaseClassStatus fromDictionary:dict] doubleValue];
            self.marketValue = [[self objectOrNilForKey:kSaleOrderBaseClassMarketValue fromDictionary:dict] doubleValue];
            self.hsEntrustNo = [self objectOrNilForKey:kSaleOrderBaseClassHsEntrustNo fromDictionary:dict];
            self.stockCode = [self objectOrNilForKey:kSaleOrderBaseClassStockCode fromDictionary:dict];
            self.cashFund = [[self objectOrNilForKey:kSaleOrderBaseClassCashFund fromDictionary:dict] doubleValue];
            self.buyPrice = [[self objectOrNilForKey:kSaleOrderBaseClassBuyPrice fromDictionary:dict] doubleValue];
            self.buyType = [[self objectOrNilForKey:kSaleOrderBaseClassBuyType fromDictionary:dict] doubleValue];
            self.lossAmt = [[self objectOrNilForKey:kSaleOrderBaseClassLossAmt fromDictionary:dict] doubleValue];
            self.factCount = [[self objectOrNilForKey:kSaleOrderBaseClassFactCount fromDictionary:dict] doubleValue];
            self.saleType = [[self objectOrNilForKey:kSaleOrderBaseClassSaleType fromDictionary:dict] doubleValue];
            self.internalBaseClassIdentifier = [[self objectOrNilForKey:kSaleOrderBaseClassId fromDictionary:dict] doubleValue];
            self.quantity = [[self objectOrNilForKey:kSaleOrderBaseClassQuantity fromDictionary:dict] doubleValue];
            self.hsSaleEntrustNo = [self objectOrNilForKey:kSaleOrderBaseClassHsSaleEntrustNo fromDictionary:dict];
            self.counterFee = [[self objectOrNilForKey:kSaleOrderBaseClassCounterFee fromDictionary:dict] doubleValue];
            self.amt = [[self objectOrNilForKey:kSaleOrderBaseClassAmt fromDictionary:dict] doubleValue];
            self.plateType = [self objectOrNilForKey:kSaleOrderBaseClassPlateType fromDictionary:dict];
            self.isCountProfit = [[self objectOrNilForKey:kSaleOrderBaseClassIsCountProfit fromDictionary:dict] doubleValue];
            self.openPrice = [[self objectOrNilForKey:kSaleOrderBaseClassOpenPrice fromDictionary:dict] doubleValue];
            self.plateCode = [self objectOrNilForKey:kSaleOrderBaseClassPlateCode fromDictionary:dict];
            self.salePrice = [[self objectOrNilForKey:kSaleOrderBaseClassSalePrice fromDictionary:dict] doubleValue];
            self.proType = [self objectOrNilForKey:kSaleOrderBaseClassProType fromDictionary:dict];
            self.stockAcc = [self objectOrNilForKey:kSaleOrderBaseClassStockAcc fromDictionary:dict];
            self.stockCom = [self objectOrNilForKey:kSaleOrderBaseClassStockCom fromDictionary:dict];
            self.finishDate = [self objectOrNilForKey:kSaleOrderBaseClassFinishDate fromDictionary:dict];
            self.plateName = [self objectOrNilForKey:kSaleOrderBaseClassPlateName fromDictionary:dict];
            self.orderId = [[self objectOrNilForKey:kSaleOrderBaseClassOrderId fromDictionary:dict] doubleValue];
            self.createDate = [self objectOrNilForKey:kSaleOrderBaseClassCreateDate fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kSaleOrderBaseClassUserId];
    [mutableDict setValue:self.codeType forKey:kSaleOrderBaseClassCodeType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lossProfit] forKey:kSaleOrderBaseClassLossProfit];
    [mutableDict setValue:self.exchangeType forKey:kSaleOrderBaseClassExchangeType];
    [mutableDict setValue:self.nickName forKey:kSaleOrderBaseClassNickName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kSaleOrderBaseClassStatus];
    [mutableDict setValue:[NSNumber numberWithDouble:self.marketValue] forKey:kSaleOrderBaseClassMarketValue];
    [mutableDict setValue:self.hsEntrustNo forKey:kSaleOrderBaseClassHsEntrustNo];
    [mutableDict setValue:self.stockCode forKey:kSaleOrderBaseClassStockCode];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cashFund] forKey:kSaleOrderBaseClassCashFund];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buyPrice] forKey:kSaleOrderBaseClassBuyPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buyType] forKey:kSaleOrderBaseClassBuyType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lossAmt] forKey:kSaleOrderBaseClassLossAmt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.factCount] forKey:kSaleOrderBaseClassFactCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.saleType] forKey:kSaleOrderBaseClassSaleType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.internalBaseClassIdentifier] forKey:kSaleOrderBaseClassId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.quantity] forKey:kSaleOrderBaseClassQuantity];
    [mutableDict setValue:self.hsSaleEntrustNo forKey:kSaleOrderBaseClassHsSaleEntrustNo];
    [mutableDict setValue:[NSNumber numberWithDouble:self.counterFee] forKey:kSaleOrderBaseClassCounterFee];
    [mutableDict setValue:[NSNumber numberWithDouble:self.amt] forKey:kSaleOrderBaseClassAmt];
    [mutableDict setValue:self.plateType forKey:kSaleOrderBaseClassPlateType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isCountProfit] forKey:kSaleOrderBaseClassIsCountProfit];
    [mutableDict setValue:[NSNumber numberWithDouble:self.openPrice] forKey:kSaleOrderBaseClassOpenPrice];
    [mutableDict setValue:self.plateCode forKey:kSaleOrderBaseClassPlateCode];
    [mutableDict setValue:[NSNumber numberWithDouble:self.salePrice] forKey:kSaleOrderBaseClassSalePrice];
    [mutableDict setValue:self.proType forKey:kSaleOrderBaseClassProType];
    [mutableDict setValue:self.stockAcc forKey:kSaleOrderBaseClassStockAcc];
    [mutableDict setValue:self.stockCom forKey:kSaleOrderBaseClassStockCom];
    [mutableDict setValue:self.finishDate forKey:kSaleOrderBaseClassFinishDate];
    [mutableDict setValue:self.plateName forKey:kSaleOrderBaseClassPlateName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderId] forKey:kSaleOrderBaseClassOrderId];
    [mutableDict setValue:self.createDate forKey:kSaleOrderBaseClassCreateDate];

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

    self.userId = [aDecoder decodeDoubleForKey:kSaleOrderBaseClassUserId];
    self.codeType = [aDecoder decodeObjectForKey:kSaleOrderBaseClassCodeType];
    self.lossProfit = [aDecoder decodeDoubleForKey:kSaleOrderBaseClassLossProfit];
    self.exchangeType = [aDecoder decodeObjectForKey:kSaleOrderBaseClassExchangeType];
    self.nickName = [aDecoder decodeObjectForKey:kSaleOrderBaseClassNickName];
    self.status = [aDecoder decodeDoubleForKey:kSaleOrderBaseClassStatus];
    self.marketValue = [aDecoder decodeDoubleForKey:kSaleOrderBaseClassMarketValue];
    self.hsEntrustNo = [aDecoder decodeObjectForKey:kSaleOrderBaseClassHsEntrustNo];
    self.stockCode = [aDecoder decodeObjectForKey:kSaleOrderBaseClassStockCode];
    self.cashFund = [aDecoder decodeDoubleForKey:kSaleOrderBaseClassCashFund];
    self.buyPrice = [aDecoder decodeDoubleForKey:kSaleOrderBaseClassBuyPrice];
    self.buyType = [aDecoder decodeDoubleForKey:kSaleOrderBaseClassBuyType];
    self.lossAmt = [aDecoder decodeDoubleForKey:kSaleOrderBaseClassLossAmt];
    self.factCount = [aDecoder decodeDoubleForKey:kSaleOrderBaseClassFactCount];
    self.saleType = [aDecoder decodeDoubleForKey:kSaleOrderBaseClassSaleType];
    self.internalBaseClassIdentifier = [aDecoder decodeDoubleForKey:kSaleOrderBaseClassId];
    self.quantity = [aDecoder decodeDoubleForKey:kSaleOrderBaseClassQuantity];
    self.hsSaleEntrustNo = [aDecoder decodeObjectForKey:kSaleOrderBaseClassHsSaleEntrustNo];
    self.counterFee = [aDecoder decodeDoubleForKey:kSaleOrderBaseClassCounterFee];
    self.amt = [aDecoder decodeDoubleForKey:kSaleOrderBaseClassAmt];
    self.plateType = [aDecoder decodeObjectForKey:kSaleOrderBaseClassPlateType];
    self.isCountProfit = [aDecoder decodeDoubleForKey:kSaleOrderBaseClassIsCountProfit];
    self.openPrice = [aDecoder decodeDoubleForKey:kSaleOrderBaseClassOpenPrice];
    self.plateCode = [aDecoder decodeObjectForKey:kSaleOrderBaseClassPlateCode];
    self.salePrice = [aDecoder decodeDoubleForKey:kSaleOrderBaseClassSalePrice];
    self.proType = [aDecoder decodeObjectForKey:kSaleOrderBaseClassProType];
    self.stockAcc = [aDecoder decodeObjectForKey:kSaleOrderBaseClassStockAcc];
    self.stockCom = [aDecoder decodeObjectForKey:kSaleOrderBaseClassStockCom];
    self.finishDate = [aDecoder decodeObjectForKey:kSaleOrderBaseClassFinishDate];
    self.plateName = [aDecoder decodeObjectForKey:kSaleOrderBaseClassPlateName];
    self.orderId = [aDecoder decodeDoubleForKey:kSaleOrderBaseClassOrderId];
    self.createDate = [aDecoder decodeObjectForKey:kSaleOrderBaseClassCreateDate];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_userId forKey:kSaleOrderBaseClassUserId];
    [aCoder encodeObject:_codeType forKey:kSaleOrderBaseClassCodeType];
    [aCoder encodeDouble:_lossProfit forKey:kSaleOrderBaseClassLossProfit];
    [aCoder encodeObject:_exchangeType forKey:kSaleOrderBaseClassExchangeType];
    [aCoder encodeObject:_nickName forKey:kSaleOrderBaseClassNickName];
    [aCoder encodeDouble:_status forKey:kSaleOrderBaseClassStatus];
    [aCoder encodeDouble:_marketValue forKey:kSaleOrderBaseClassMarketValue];
    [aCoder encodeObject:_hsEntrustNo forKey:kSaleOrderBaseClassHsEntrustNo];
    [aCoder encodeObject:_stockCode forKey:kSaleOrderBaseClassStockCode];
    [aCoder encodeDouble:_cashFund forKey:kSaleOrderBaseClassCashFund];
    [aCoder encodeDouble:_buyPrice forKey:kSaleOrderBaseClassBuyPrice];
    [aCoder encodeDouble:_buyType forKey:kSaleOrderBaseClassBuyType];
    [aCoder encodeDouble:_lossAmt forKey:kSaleOrderBaseClassLossAmt];
    [aCoder encodeDouble:_factCount forKey:kSaleOrderBaseClassFactCount];
    [aCoder encodeDouble:_saleType forKey:kSaleOrderBaseClassSaleType];
    [aCoder encodeDouble:_internalBaseClassIdentifier forKey:kSaleOrderBaseClassId];
    [aCoder encodeDouble:_quantity forKey:kSaleOrderBaseClassQuantity];
    [aCoder encodeObject:_hsSaleEntrustNo forKey:kSaleOrderBaseClassHsSaleEntrustNo];
    [aCoder encodeDouble:_counterFee forKey:kSaleOrderBaseClassCounterFee];
    [aCoder encodeDouble:_amt forKey:kSaleOrderBaseClassAmt];
    [aCoder encodeObject:_plateType forKey:kSaleOrderBaseClassPlateType];
    [aCoder encodeDouble:_isCountProfit forKey:kSaleOrderBaseClassIsCountProfit];
    [aCoder encodeDouble:_openPrice forKey:kSaleOrderBaseClassOpenPrice];
    [aCoder encodeObject:_plateCode forKey:kSaleOrderBaseClassPlateCode];
    [aCoder encodeDouble:_salePrice forKey:kSaleOrderBaseClassSalePrice];
    [aCoder encodeObject:_proType forKey:kSaleOrderBaseClassProType];
    [aCoder encodeObject:_stockAcc forKey:kSaleOrderBaseClassStockAcc];
    [aCoder encodeObject:_stockCom forKey:kSaleOrderBaseClassStockCom];
    [aCoder encodeObject:_finishDate forKey:kSaleOrderBaseClassFinishDate];
    [aCoder encodeObject:_plateName forKey:kSaleOrderBaseClassPlateName];
    [aCoder encodeDouble:_orderId forKey:kSaleOrderBaseClassOrderId];
    [aCoder encodeObject:_createDate forKey:kSaleOrderBaseClassCreateDate];
}

- (id)copyWithZone:(NSZone *)zone
{
    SaleOrderBaseClass *copy = [[SaleOrderBaseClass alloc] init];
    
    if (copy) {

        copy.userId = self.userId;
        copy.codeType = [self.codeType copyWithZone:zone];
        copy.lossProfit = self.lossProfit;
        copy.exchangeType = [self.exchangeType copyWithZone:zone];
        copy.nickName = [self.nickName copyWithZone:zone];
        copy.status = self.status;
        copy.marketValue = self.marketValue;
        copy.hsEntrustNo = [self.hsEntrustNo copyWithZone:zone];
        copy.stockCode = [self.stockCode copyWithZone:zone];
        copy.cashFund = self.cashFund;
        copy.buyPrice = self.buyPrice;
        copy.buyType = self.buyType;
        copy.lossAmt = self.lossAmt;
        copy.factCount = self.factCount;
        copy.saleType = self.saleType;
        copy.internalBaseClassIdentifier = self.internalBaseClassIdentifier;
        copy.quantity = self.quantity;
        copy.hsSaleEntrustNo = [self.hsSaleEntrustNo copyWithZone:zone];
        copy.counterFee = self.counterFee;
        copy.amt = self.amt;
        copy.plateType = [self.plateType copyWithZone:zone];
        copy.isCountProfit = self.isCountProfit;
        copy.openPrice = self.openPrice;
        copy.plateCode = [self.plateCode copyWithZone:zone];
        copy.salePrice = self.salePrice;
        copy.proType = [self.proType copyWithZone:zone];
        copy.stockAcc = [self.stockAcc copyWithZone:zone];
        copy.stockCom = [self.stockCom copyWithZone:zone];
        copy.finishDate = [self.finishDate copyWithZone:zone];
        copy.plateName = [self.plateName copyWithZone:zone];
        copy.orderId = self.orderId;
        copy.createDate = [self.createDate copyWithZone:zone];
    }
    
    return copy;
}


@end
