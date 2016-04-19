//
//  CashPositionModel.m
//  hs
//
//  Created by PXJ on 15/12/2.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "CashPositionListModel.h"

#define KeyCashPosition_serialNo @"serialNo"
#define KeyCashPosition_orderType @"orderType"
#define KeyCashPosition_orderStatus @"orderStatus"
#define KeyCashPosition_buyOrSal @"buyOrSal"
#define KeyCashPosition_wareId @"wareId"
#define KeyCashPosition_price @"price"
#define KeyCashPosition_upPrice @"upPrice"
#define KeyCashPosition_downPrice @"downPrice"
#define KeyCashPosition_num @"num"
#define KeyCashPosition_createTime @"createTime"
#define KeyCashPosition_contNum @"contNum"
#define KeyCashPosition_conPrice @"conPrice"
#define KeyCashPosition_orderId @"id"
#define KeyCashPosition_fDate @"fDate"
#define KeyCashPosition_bidPrice @"bidPrice"
#define KeyCashPosition_askPrice @"askPrice"
#define KeyCashPosition_checkNum @"checkNum"
#define KeyCashPosition_state @"state"
#define KeyCashPosition_billNo @"billNo"



@implementation CashPositionListModel

@synthesize serialNo,orderType,orderStatus,buyOrSal,wareId,price,upPrice,downPrice,num,createTime,contNum,conPrice,orderId,fDate,bidPrice,askPrice,checkNum,state,billNo;

- (id)initWithDic:(NSDictionary*)dictionary;
{
    self = [super init];
    if (self) {
        
        if (dictionary[KeyCashPosition_serialNo] != nil && ![dictionary[KeyCashPosition_serialNo] isKindOfClass:[NSNull class]])
        {
            self.serialNo = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_serialNo]];
        }
        else{
            self.serialNo = @"";
        }


        if (dictionary[KeyCashPosition_orderType] != nil && ![dictionary[KeyCashPosition_orderType] isKindOfClass:[NSNull class]])
        {
            self.orderType = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_orderType]];
        }
        else{
            self.orderType = @"";
        }
        if (dictionary[KeyCashPosition_orderStatus] != nil && ![dictionary[KeyCashPosition_orderStatus] isKindOfClass:[NSNull class]])
        {
            self.orderStatus = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_orderStatus]];
        }
        else{
            self.orderStatus = @"";
        }
        if (dictionary[KeyCashPosition_buyOrSal] != nil && ![dictionary[KeyCashPosition_buyOrSal] isKindOfClass:[NSNull class]])
        {
            self.buyOrSal = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_buyOrSal]];
        }
        else{
            self.buyOrSal = @"";
        }
        if (dictionary[KeyCashPosition_wareId] != nil && ![dictionary[KeyCashPosition_wareId] isKindOfClass:[NSNull class]])
        {
            self.wareId = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_wareId]];
        }
        else{
            self.wareId = @"";
        }
        if (dictionary[KeyCashPosition_price] != nil && ![dictionary[KeyCashPosition_price] isKindOfClass:[NSNull class]])
        {
            self.price = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_price]];
        }
        else{
            self.price = @"";
        }
        if (dictionary[KeyCashPosition_upPrice] != nil && ![dictionary[KeyCashPosition_upPrice] isKindOfClass:[NSNull class]])
        {
            self.upPrice = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_upPrice]];
        }
        else{
            self.upPrice = @"";
        }
        if (dictionary[KeyCashPosition_downPrice] != nil && ![dictionary[KeyCashPosition_downPrice] isKindOfClass:[NSNull class]])
        {
            self.downPrice = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_downPrice]];
        }
        else{
            self.downPrice = @"";
        }
        if (dictionary[KeyCashPosition_num] != nil && ![dictionary[KeyCashPosition_num] isKindOfClass:[NSNull class]])
        {
            self.num = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_num]];
        }
        else{
            self.num = @"";
        }
        if (dictionary[KeyCashPosition_createTime] != nil && ![dictionary[KeyCashPosition_createTime] isKindOfClass:[NSNull class]])
        {
            self.createTime = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_createTime]];
        }
        else{
            self.createTime = @"";
        }
        if (dictionary[KeyCashPosition_contNum] != nil && ![dictionary[KeyCashPosition_contNum] isKindOfClass:[NSNull class]])
        {
            self.contNum = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_contNum]];
        }
        else{
            self.contNum = @"";
        }
        if (dictionary[KeyCashPosition_conPrice] != nil && ![dictionary[KeyCashPosition_conPrice] isKindOfClass:[NSNull class]])
        {
            self.conPrice = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_conPrice]];
        }
        else{
            self.conPrice = @"";
        }
        if (dictionary[KeyCashPosition_orderId] != nil && ![dictionary[KeyCashPosition_orderId] isKindOfClass:[NSNull class]])
        {
            self.orderId = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_orderId]];
        }
        else{
            self.orderId = @"";
        }
        if (dictionary[KeyCashPosition_fDate] != nil && ![dictionary[KeyCashPosition_fDate] isKindOfClass:[NSNull class]])
        {
            self.fDate = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_fDate]];
        }
        else{
            self.fDate = @"";
        }
        if (dictionary[KeyCashPosition_bidPrice] != nil && ![dictionary[KeyCashPosition_bidPrice] isKindOfClass:[NSNull class]])
        {
            self.bidPrice = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_bidPrice]];
        }
        else{
            self.bidPrice = @"";
        }
        if (dictionary[KeyCashPosition_askPrice] != nil && ![dictionary[KeyCashPosition_askPrice] isKindOfClass:[NSNull class]])
        {
            self.askPrice = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_askPrice]];
        }
        else{
            self.askPrice = @"";
        }
        if (dictionary[KeyCashPosition_checkNum] != nil && ![dictionary[KeyCashPosition_checkNum] isKindOfClass:[NSNull class]])
        {
            self.checkNum = [dictionary[KeyCashPosition_checkNum] intValue];
        }
        else{
            self.checkNum = 0;
        }
        if (dictionary[KeyCashPosition_state] != nil && ![dictionary[KeyCashPosition_state] isKindOfClass:[NSNull class]])
        {
            self.state = dictionary[KeyCashPosition_state];
        }
        else{
            self.state = 0;
        }
        if (dictionary[KeyCashPosition_billNo] != nil && ![dictionary[KeyCashPosition_billNo] isKindOfClass:[NSNull class]])
        {
            self.billNo = dictionary[KeyCashPosition_billNo];
        }
        else{
            self.billNo = 0;
        }
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:serialNo      forKey:KeyCashPosition_serialNo];
    [aCoder encodeObject:orderType      forKey:KeyCashPosition_orderType];
    [aCoder encodeObject:orderStatus      forKey:KeyCashPosition_orderStatus];
    [aCoder encodeObject:buyOrSal      forKey:KeyCashPosition_buyOrSal];
    [aCoder encodeObject:wareId      forKey:KeyCashPosition_wareId];
    [aCoder encodeObject:price      forKey:KeyCashPosition_price];
    [aCoder encodeObject:upPrice      forKey:KeyCashPosition_upPrice];
    [aCoder encodeObject:downPrice      forKey:KeyCashPosition_downPrice];
    [aCoder encodeObject:num      forKey:KeyCashPosition_num];
    [aCoder encodeObject:createTime      forKey:KeyCashPosition_createTime];
    [aCoder encodeObject:contNum      forKey:KeyCashPosition_contNum];
    [aCoder encodeObject:conPrice      forKey:KeyCashPosition_conPrice];
    [aCoder encodeObject:orderId      forKey:KeyCashPosition_orderId];
    [aCoder encodeObject:fDate      forKey:KeyCashPosition_fDate];
    [aCoder encodeObject:bidPrice      forKey:KeyCashPosition_bidPrice];
    [aCoder encodeObject:askPrice      forKey:KeyCashPosition_askPrice];
    [aCoder encodeInt:checkNum forKey:KeyCashPosition_checkNum];
    [aCoder encodeObject:state      forKey:KeyCashPosition_state];
    [aCoder encodeObject:billNo      forKey:KeyCashPosition_billNo];

    }
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.serialNo      =[aDecoder decodeObjectForKey:KeyCashPosition_serialNo];
        self.orderType      =[aDecoder decodeObjectForKey:KeyCashPosition_orderType];
        self.orderStatus      =[aDecoder decodeObjectForKey:KeyCashPosition_orderStatus];
        self.buyOrSal      =[aDecoder decodeObjectForKey:KeyCashPosition_buyOrSal];
        self.wareId      =[aDecoder decodeObjectForKey:KeyCashPosition_wareId];
        self.price      =[aDecoder decodeObjectForKey:KeyCashPosition_price];
        self.upPrice      =[aDecoder decodeObjectForKey:KeyCashPosition_upPrice];
        self.downPrice      =[aDecoder decodeObjectForKey:KeyCashPosition_downPrice];
        self.num      =[aDecoder decodeObjectForKey:KeyCashPosition_num];
        self.createTime      =[aDecoder decodeObjectForKey:KeyCashPosition_createTime];
        self.contNum      =[aDecoder decodeObjectForKey:KeyCashPosition_contNum];
        self.conPrice      =[aDecoder decodeObjectForKey:KeyCashPosition_conPrice];
        self.orderId      =[aDecoder decodeObjectForKey:KeyCashPosition_orderId];
        self.fDate      =[aDecoder decodeObjectForKey:KeyCashPosition_fDate];
        self.bidPrice      =[aDecoder decodeObjectForKey:KeyCashPosition_bidPrice];
        self.askPrice      =[aDecoder decodeObjectForKey:KeyCashPosition_askPrice];
        self.checkNum      =[aDecoder decodeIntForKey:KeyCashPosition_checkNum];
        self.state      =[aDecoder decodeObjectForKey:KeyCashPosition_state];
        self.billNo      =[aDecoder decodeObjectForKey:KeyCashPosition_billNo];

    }
    
    return self;
}

@end
