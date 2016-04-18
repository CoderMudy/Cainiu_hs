//
//  ELList.m
//
//  Created by   on 15/6/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "ELList.h"


NSString *const kELListOrderId = @"orderId";
NSString *const kELListStockCode = @"stockCode";
NSString *const kELListId = @"id";
NSString *const kELListSysSaleDate = @"sysSaleDate";
NSString *const kELListProVariety = @"proVariety";
NSString *const kELListSalePrice = @"salePrice";
NSString *const kELListUserSaleDate = @"userSaleDate";
NSString *const kELListUserAddDate = @"userAddDate";
NSString *const kELListDisplayId = @"displayId";
NSString *const kELListAmt = @"amt";
NSString *const kELListSysSalePrice = @"sysSalePrice";
NSString *const kELListPlateCode = @"plateCode";
NSString *const kELListFactCount = @"factCount";
NSString *const kELListCounterFee = @"counterFee";
NSString *const kELListWarnAmt = @"warnAmt";
NSString *const kELListOpenPrice = @"openPrice";
NSString *const kELListLossProfit = @"lossProfit";
NSString *const kELListFactBorrowAmt = @"factBorrowAmt";
NSString *const kELListFactSaleCount = @"factSaleCount";
NSString *const kELListUpdateTime = @"updateTime";
NSString *const kELListNickName = @"nickName";
NSString *const kELListProType = @"proType";
NSString *const kELListQuantity = @"quantity";
NSString *const kELListStatus = @"status";
NSString *const kELListCodeType = @"typeCode";
NSString *const kELListStockCom = @"stockName";
NSString *const kELListCreateDate = @"buyDate";
NSString *const kELListSaleType = @"saleType";
NSString *const kELListExitAmt = @"exitAmt";
NSString *const kELListLossAmt = @"lossAmt";
NSString *const kELListPlateType = @"plateType";
NSString *const kELListBuyType = @"fundType";
NSString *const kELListBuyPrice = @"buyPrice";
NSString *const kELListPlateName = @"plateName";
NSString *const kELListUserName = @"userName";
NSString *const kELListFinishDate = @"finishDate";


@interface ELList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ELList

@synthesize orderId = _orderId;
@synthesize stockCode = _stockCode;
@synthesize listIdentifier = _listIdentifier;
@synthesize sysSaleDate = _sysSaleDate;
@synthesize proVariety = _proVariety;
@synthesize salePrice = _salePrice;
@synthesize userSaleDate = _userSaleDate;
@synthesize userAddDate = _userAddDate;
@synthesize displayId = _displayId;
@synthesize amt = _amt;
@synthesize sysSalePrice = _sysSalePrice;
@synthesize plateCode = _plateCode;
@synthesize factCount = _factCount;
@synthesize counterFee = _counterFee;
@synthesize warnAmt = _warnAmt;
@synthesize openPrice = _openPrice;
@synthesize lossProfit = _lossProfit;
@synthesize factBorrowAmt = _factBorrowAmt;
@synthesize factSaleCount = _factSaleCount;
@synthesize updateTime = _updateTime;
@synthesize nickName = _nickName;
@synthesize proType = _proType;
@synthesize quantity = _quantity;
@synthesize status = _status;
@synthesize codeType = _codeType;
@synthesize stockCom = _stockCom;
@synthesize createDate = _createDate;
@synthesize saleType = _saleType;
@synthesize exitAmt = _exitAmt;
@synthesize lossAmt = _lossAmt;
@synthesize plateType = _plateType;
@synthesize buyType = _buyType;
@synthesize buyPrice = _buyPrice;
@synthesize plateName = _plateName;
@synthesize userName = _userName;
@synthesize finishDate = _finishDate;


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
            self.orderId = [[self objectOrNilForKey:kELListOrderId fromDictionary:dict] doubleValue];
            self.stockCode = [self objectOrNilForKey:kELListStockCode fromDictionary:dict];
            self.listIdentifier = [[self objectOrNilForKey:kELListId fromDictionary:dict] doubleValue];
            self.sysSaleDate = [self objectOrNilForKey:kELListSysSaleDate fromDictionary:dict];
            self.proVariety = [[self objectOrNilForKey:kELListProVariety fromDictionary:dict] doubleValue];
            self.salePrice = [[self objectOrNilForKey:kELListSalePrice fromDictionary:dict] doubleValue];
            self.userSaleDate = [self objectOrNilForKey:kELListUserSaleDate fromDictionary:dict];
            self.userAddDate = [self objectOrNilForKey:kELListUserAddDate fromDictionary:dict];
            self.displayId = [self objectOrNilForKey:kELListDisplayId fromDictionary:dict];
            self.amt = [[self objectOrNilForKey:kELListAmt fromDictionary:dict] doubleValue];
            self.sysSalePrice = [[self objectOrNilForKey:kELListSysSalePrice fromDictionary:dict] doubleValue];
            self.plateCode = [self objectOrNilForKey:kELListPlateCode fromDictionary:dict];
            self.factCount = [[self objectOrNilForKey:kELListFactCount fromDictionary:dict] doubleValue];
            self.counterFee = [[self objectOrNilForKey:kELListCounterFee fromDictionary:dict] doubleValue];
            self.warnAmt = [[self objectOrNilForKey:kELListWarnAmt fromDictionary:dict] doubleValue];
            self.openPrice = [[self objectOrNilForKey:kELListOpenPrice fromDictionary:dict] doubleValue];
            self.lossProfit = [[self objectOrNilForKey:kELListLossProfit fromDictionary:dict] doubleValue];
            self.factBorrowAmt = [[self objectOrNilForKey:kELListFactBorrowAmt fromDictionary:dict] doubleValue];
            self.factSaleCount = [[self objectOrNilForKey:kELListFactSaleCount fromDictionary:dict] doubleValue];
            self.updateTime = [self objectOrNilForKey:kELListUpdateTime fromDictionary:dict];
            self.nickName = [self objectOrNilForKey:kELListNickName fromDictionary:dict];
            self.proType = [self objectOrNilForKey:kELListProType fromDictionary:dict];
            self.quantity = [[self objectOrNilForKey:kELListQuantity fromDictionary:dict] doubleValue];
            self.status = [[self objectOrNilForKey:kELListStatus fromDictionary:dict] doubleValue];
            self.codeType = [self objectOrNilForKey:kELListCodeType fromDictionary:dict];
            self.stockCom = [self objectOrNilForKey:kELListStockCom fromDictionary:dict];
            self.createDate = [self objectOrNilForKey:kELListCreateDate fromDictionary:dict];
            self.saleType = [[self objectOrNilForKey:kELListSaleType fromDictionary:dict] doubleValue];
            self.exitAmt = [[self objectOrNilForKey:kELListExitAmt fromDictionary:dict] doubleValue];
            self.lossAmt = [[self objectOrNilForKey:kELListLossAmt fromDictionary:dict] doubleValue];
            self.plateType = [self objectOrNilForKey:kELListPlateType fromDictionary:dict];
            self.buyType = [[self objectOrNilForKey:kELListBuyType fromDictionary:dict] doubleValue];
            self.buyPrice = [[self objectOrNilForKey:kELListBuyPrice fromDictionary:dict] doubleValue];
            self.plateName = [self objectOrNilForKey:kELListPlateName fromDictionary:dict];
            self.userName = [self objectOrNilForKey:kELListUserName fromDictionary:dict];
            self.finishDate = [self objectOrNilForKey:kELListFinishDate fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderId] forKey:kELListOrderId];
    [mutableDict setValue:self.stockCode forKey:kELListStockCode];
    [mutableDict setValue:[NSNumber numberWithDouble:self.listIdentifier] forKey:kELListId];
    [mutableDict setValue:self.sysSaleDate forKey:kELListSysSaleDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.proVariety] forKey:kELListProVariety];
    [mutableDict setValue:[NSNumber numberWithDouble:self.salePrice] forKey:kELListSalePrice];
    [mutableDict setValue:self.userSaleDate forKey:kELListUserSaleDate];
    [mutableDict setValue:self.userAddDate forKey:kELListUserAddDate];
    [mutableDict setValue:self.displayId forKey:kELListDisplayId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.amt] forKey:kELListAmt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sysSalePrice] forKey:kELListSysSalePrice];
    [mutableDict setValue:self.plateCode forKey:kELListPlateCode];
    [mutableDict setValue:[NSNumber numberWithDouble:self.factCount] forKey:kELListFactCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.counterFee] forKey:kELListCounterFee];
    [mutableDict setValue:[NSNumber numberWithDouble:self.warnAmt] forKey:kELListWarnAmt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.openPrice] forKey:kELListOpenPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lossProfit] forKey:kELListLossProfit];
    [mutableDict setValue:[NSNumber numberWithDouble:self.factBorrowAmt] forKey:kELListFactBorrowAmt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.factSaleCount] forKey:kELListFactSaleCount];
    [mutableDict setValue:self.updateTime forKey:kELListUpdateTime];
    [mutableDict setValue:self.nickName forKey:kELListNickName];
    [mutableDict setValue:self.proType forKey:kELListProType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.quantity] forKey:kELListQuantity];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kELListStatus];
    [mutableDict setValue:self.codeType forKey:kELListCodeType];
    [mutableDict setValue:self.stockCom forKey:kELListStockCom];
    [mutableDict setValue:self.createDate forKey:kELListCreateDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.saleType] forKey:kELListSaleType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.exitAmt] forKey:kELListExitAmt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lossAmt] forKey:kELListLossAmt];
    [mutableDict setValue:self.plateType forKey:kELListPlateType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buyType] forKey:kELListBuyType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buyPrice] forKey:kELListBuyPrice];
    [mutableDict setValue:self.plateName forKey:kELListPlateName];
    [mutableDict setValue:self.userName forKey:kELListUserName];
    [mutableDict setValue:self.finishDate forKey:kELListFinishDate];

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

    self.orderId = [aDecoder decodeDoubleForKey:kELListOrderId];
    self.stockCode = [aDecoder decodeObjectForKey:kELListStockCode];
    self.listIdentifier = [aDecoder decodeDoubleForKey:kELListId];
    self.sysSaleDate = [aDecoder decodeObjectForKey:kELListSysSaleDate];
    self.proVariety = [aDecoder decodeDoubleForKey:kELListProVariety];
    self.salePrice = [aDecoder decodeDoubleForKey:kELListSalePrice];
    self.userSaleDate = [aDecoder decodeObjectForKey:kELListUserSaleDate];
    self.userAddDate = [aDecoder decodeObjectForKey:kELListUserAddDate];
    self.displayId = [aDecoder decodeObjectForKey:kELListDisplayId];
    self.amt = [aDecoder decodeDoubleForKey:kELListAmt];
    self.sysSalePrice = [aDecoder decodeDoubleForKey:kELListSysSalePrice];
    self.plateCode = [aDecoder decodeObjectForKey:kELListPlateCode];
    self.factCount = [aDecoder decodeDoubleForKey:kELListFactCount];
    self.counterFee = [aDecoder decodeDoubleForKey:kELListCounterFee];
    self.warnAmt = [aDecoder decodeDoubleForKey:kELListWarnAmt];
    self.openPrice = [aDecoder decodeDoubleForKey:kELListOpenPrice];
    self.lossProfit = [aDecoder decodeDoubleForKey:kELListLossProfit];
    self.factBorrowAmt = [aDecoder decodeDoubleForKey:kELListFactBorrowAmt];
    self.factSaleCount = [aDecoder decodeDoubleForKey:kELListFactSaleCount];
    self.updateTime = [aDecoder decodeObjectForKey:kELListUpdateTime];
    self.nickName = [aDecoder decodeObjectForKey:kELListNickName];
    self.proType = [aDecoder decodeObjectForKey:kELListProType];
    self.quantity = [aDecoder decodeDoubleForKey:kELListQuantity];
    self.status = [aDecoder decodeDoubleForKey:kELListStatus];
    self.codeType = [aDecoder decodeObjectForKey:kELListCodeType];
    self.stockCom = [aDecoder decodeObjectForKey:kELListStockCom];
    self.createDate = [aDecoder decodeObjectForKey:kELListCreateDate];
    self.saleType = [aDecoder decodeDoubleForKey:kELListSaleType];
    self.exitAmt = [aDecoder decodeDoubleForKey:kELListExitAmt];
    self.lossAmt = [aDecoder decodeDoubleForKey:kELListLossAmt];
    self.plateType = [aDecoder decodeObjectForKey:kELListPlateType];
    self.buyType = [aDecoder decodeDoubleForKey:kELListBuyType];
    self.buyPrice = [aDecoder decodeDoubleForKey:kELListBuyPrice];
    self.plateName = [aDecoder decodeObjectForKey:kELListPlateName];
    self.userName = [aDecoder decodeObjectForKey:kELListUserName];
    self.finishDate = [aDecoder decodeObjectForKey:kELListFinishDate];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_orderId forKey:kELListOrderId];
    [aCoder encodeObject:_stockCode forKey:kELListStockCode];
    [aCoder encodeDouble:_listIdentifier forKey:kELListId];
    [aCoder encodeObject:_sysSaleDate forKey:kELListSysSaleDate];
    [aCoder encodeDouble:_proVariety forKey:kELListProVariety];
    [aCoder encodeDouble:_salePrice forKey:kELListSalePrice];
    [aCoder encodeObject:_userSaleDate forKey:kELListUserSaleDate];
    [aCoder encodeObject:_userAddDate forKey:kELListUserAddDate];
    [aCoder encodeObject:_displayId forKey:kELListDisplayId];
    [aCoder encodeDouble:_amt forKey:kELListAmt];
    [aCoder encodeDouble:_sysSalePrice forKey:kELListSysSalePrice];
    [aCoder encodeObject:_plateCode forKey:kELListPlateCode];
    [aCoder encodeDouble:_factCount forKey:kELListFactCount];
    [aCoder encodeDouble:_counterFee forKey:kELListCounterFee];
    [aCoder encodeDouble:_warnAmt forKey:kELListWarnAmt];
    [aCoder encodeDouble:_openPrice forKey:kELListOpenPrice];
    [aCoder encodeDouble:_lossProfit forKey:kELListLossProfit];
    [aCoder encodeDouble:_factBorrowAmt forKey:kELListFactBorrowAmt];
    [aCoder encodeDouble:_factSaleCount forKey:kELListFactSaleCount];
    [aCoder encodeObject:_updateTime forKey:kELListUpdateTime];
    [aCoder encodeObject:_nickName forKey:kELListNickName];
    [aCoder encodeObject:_proType forKey:kELListProType];
    [aCoder encodeDouble:_quantity forKey:kELListQuantity];
    [aCoder encodeDouble:_status forKey:kELListStatus];
    [aCoder encodeObject:_codeType forKey:kELListCodeType];
    [aCoder encodeObject:_stockCom forKey:kELListStockCom];
    [aCoder encodeObject:_createDate forKey:kELListCreateDate];
    [aCoder encodeDouble:_saleType forKey:kELListSaleType];
    [aCoder encodeDouble:_exitAmt forKey:kELListExitAmt];
    [aCoder encodeDouble:_lossAmt forKey:kELListLossAmt];
    [aCoder encodeObject:_plateType forKey:kELListPlateType];
    [aCoder encodeDouble:_buyType forKey:kELListBuyType];
    [aCoder encodeDouble:_buyPrice forKey:kELListBuyPrice];
    [aCoder encodeObject:_plateName forKey:kELListPlateName];
    [aCoder encodeObject:_userName forKey:kELListUserName];
    [aCoder encodeObject:_finishDate forKey:kELListFinishDate];
}

- (id)copyWithZone:(NSZone *)zone
{
    ELList *copy = [[ELList alloc] init];
    
    if (copy) {

        copy.orderId = self.orderId;
        copy.stockCode = [self.stockCode copyWithZone:zone];
        copy.listIdentifier = self.listIdentifier;
        copy.sysSaleDate = [self.sysSaleDate copyWithZone:zone];
        copy.proVariety = self.proVariety;
        copy.salePrice = self.salePrice;
        copy.userSaleDate = [self.userSaleDate copyWithZone:zone];
        copy.userAddDate = [self.userAddDate copyWithZone:zone];
        copy.displayId = [self.displayId copyWithZone:zone];
        copy.amt = self.amt;
        copy.sysSalePrice = self.sysSalePrice;
        copy.plateCode = [self.plateCode copyWithZone:zone];
        copy.factCount = self.factCount;
        copy.counterFee = self.counterFee;
        copy.warnAmt = self.warnAmt;
        copy.openPrice = self.openPrice;
        copy.lossProfit = self.lossProfit;
        copy.factBorrowAmt = self.factBorrowAmt;
        copy.factSaleCount = self.factSaleCount;
        copy.updateTime = [self.updateTime copyWithZone:zone];
        copy.nickName = [self.nickName copyWithZone:zone];
        copy.proType = [self.proType copyWithZone:zone];
        copy.quantity = self.quantity;
        copy.status = self.status;
        copy.codeType = [self.codeType copyWithZone:zone];
        copy.stockCom = [self.stockCom copyWithZone:zone];
        copy.createDate = [self.createDate copyWithZone:zone];
        copy.saleType = self.saleType;
        copy.exitAmt = self.exitAmt;
        copy.lossAmt = self.lossAmt;
        copy.plateType = [self.plateType copyWithZone:zone];
        copy.buyType = self.buyType;
        copy.buyPrice = self.buyPrice;
        copy.plateName = [self.plateName copyWithZone:zone];
        copy.userName = [self.userName copyWithZone:zone];
        copy.finishDate = [self.finishDate copyWithZone:zone];
    }
    
    return copy;
}


@end
