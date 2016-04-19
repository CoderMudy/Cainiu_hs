//
//  CashPositionModel.m
//  hs
//
//  Created by PXJ on 15/12/2.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "CashPositionModel.h"

#define KeyCashPosition_SeriaNo @"seriaNo"
#define KeyCashPosition_orderType @"orderType"
#define KeyCashPosition_orderStatus @"orderStatus"
#define KeyCashPosition_buyOrSal @"buyOrSal"
#define KeyCashPosition_wareId @"wareId"
#define KeyCashPosition_price @"price"
#define KeyCashPosition_upPrice @"upPrice"
#define KeyCashPosition_downPrice @"downPrice"
#define KeyCashPosition_num @"num"
#define KeyCashPosition_createTime @"createTime"
#define KeyCashPosition_realNum @"realNum"


@implementation CashPositionModel

@synthesize seriaNo,orderType,orderStatus,buyOrSal,wareId,price,upPrice,downPrice,num,createTime,realNum;
/*
@property (nonatomic,strong)NSString * seriaNo;
@property (nonatomic,strong)NSString * orderType;
@property (nonatomic,strong)NSString * orderStatus;
@property (nonatomic,strong)NSString * buyOrSal;
@property (nonatomic,strong)NSString * wareId;
@property (nonatomic,strong)NSString * price;
@property (nonatomic,strong)NSString * upPrice;
@property (nonatomic,strong)NSString * downPrice;
@property (nonatomic,strong)NSString * num;
@property (nonatomic,strong)NSString * createTime;
*/
- (id)initWithDic:(NSDictionary*)dictionary;
{
    self = [super init];
    if (self) {
        
        if (dictionary[KeyCashPosition_SeriaNo] != nil && ![dictionary[KeyCashPosition_SeriaNo] isKindOfClass:[NSNull class]])
        {
            self.seriaNo = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_SeriaNo]];
        }
        else{
            self.seriaNo = @"";
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
        if (dictionary[KeyCashPosition_realNum] != nil && ![dictionary[KeyCashPosition_realNum] isKindOfClass:[NSNull class]])
        {
            self.realNum = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_realNum]];
        }
        else{
            self.realNum = @"";
        }}
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:seriaNo      forKey:KeyCashPosition_SeriaNo];
    [aCoder encodeObject:orderType      forKey:KeyCashPosition_orderType];
    [aCoder encodeObject:orderStatus      forKey:KeyCashPosition_orderStatus];
    [aCoder encodeObject:buyOrSal      forKey:KeyCashPosition_buyOrSal];
    [aCoder encodeObject:wareId      forKey:KeyCashPosition_wareId];
    [aCoder encodeObject:price      forKey:KeyCashPosition_price];
    [aCoder encodeObject:upPrice      forKey:KeyCashPosition_upPrice];
    [aCoder encodeObject:downPrice      forKey:KeyCashPosition_downPrice];
    [aCoder encodeObject:num      forKey:KeyCashPosition_num];
    [aCoder encodeObject:createTime      forKey:KeyCashPosition_createTime];
    [aCoder encodeObject:realNum      forKey:KeyCashPosition_realNum];
    }
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.seriaNo      =[aDecoder decodeObjectForKey:KeyCashPosition_SeriaNo];
        self.orderType      =[aDecoder decodeObjectForKey:KeyCashPosition_orderType];
        self.orderStatus      =[aDecoder decodeObjectForKey:KeyCashPosition_orderStatus];
        self.buyOrSal      =[aDecoder decodeObjectForKey:KeyCashPosition_buyOrSal];
        self.wareId      =[aDecoder decodeObjectForKey:KeyCashPosition_wareId];
        self.price      =[aDecoder decodeObjectForKey:KeyCashPosition_price];
        self.upPrice      =[aDecoder decodeObjectForKey:KeyCashPosition_upPrice];
        self.downPrice      =[aDecoder decodeObjectForKey:KeyCashPosition_downPrice];
        self.num      =[aDecoder decodeObjectForKey:KeyCashPosition_num];
        self.createTime      =[aDecoder decodeObjectForKey:KeyCashPosition_createTime];
        self.realNum      =[aDecoder decodeObjectForKey:KeyCashPosition_realNum];

    }
    
    return self;
}

@end
