//
//  CashOrderSucModel.m
//  hs
//
//  Created by PXJ on 15/12/7.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "CashOrderSucModel.h"

#define KeyCashPosition_date @"date"
#define KeyCashPosition_contNo @"contNo"
#define KeyCashPosition_conPrice @"conPrice"
#define KeyCashPosition_buyOrSal @"buyOrSal"
#define KeyCashPosition_wareId @"wareId"
#define KeyCashPosition_contNum @"contNum"
#define KeyCashPosition_bargainTime @"bargainTime"
#define KeyCashPosition_tmpMoney @"tmpMoney"
#define KeyCashPosition_contQty @"contQty"


@implementation CashOrderSucModel

@synthesize date,contNo,conPrice,buyOrSal,wareId,contNum,bargainTime,tmpMoney,contQty;


- (id)initWithDic:(NSDictionary*)dictionary;
{
    self = [super init];
    if (self) {
        
        if (dictionary[KeyCashPosition_date] != nil && ![dictionary[KeyCashPosition_date] isKindOfClass:[NSNull class]])
        {
            self.date = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_date]];
        }
        else{
            self.date = @"";
        }
        
        
        if (dictionary[KeyCashPosition_contNo] != nil && ![dictionary[KeyCashPosition_contNo] isKindOfClass:[NSNull class]])
        {
            self.contNo = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_contNo]];
        }
        else{
            self.contNo = @"";
        }
        if (dictionary[KeyCashPosition_conPrice] != nil && ![dictionary[KeyCashPosition_conPrice] isKindOfClass:[NSNull class]])
        {
            self.conPrice = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_conPrice]];
        }
        else{
            self.conPrice = @"";
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
        if (dictionary[KeyCashPosition_contNum] != nil && ![dictionary[KeyCashPosition_contNum] isKindOfClass:[NSNull class]])
        {
            self.contNum = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_contNum]];
        }
        else{
            self.contNum = @"";
        }
        if (dictionary[KeyCashPosition_bargainTime] != nil && ![dictionary[KeyCashPosition_bargainTime] isKindOfClass:[NSNull class]])
        {
            self.bargainTime = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_bargainTime]];
        }
        else{
            self.bargainTime = @"";
        }
        if (dictionary[KeyCashPosition_tmpMoney] != nil && ![dictionary[KeyCashPosition_tmpMoney] isKindOfClass:[NSNull class]])
        {
            self.tmpMoney = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_tmpMoney]];
        }
        else{
            self.tmpMoney = @"";
        }
        if (dictionary[KeyCashPosition_contQty] != nil && ![dictionary[KeyCashPosition_contQty] isKindOfClass:[NSNull class]])
        {
            self.contQty = [NSString stringWithFormat:@"%@",dictionary[KeyCashPosition_contQty]];
        }
        else{
            self.contQty = @"";
        }}
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:date      forKey:KeyCashPosition_date];
    [aCoder encodeObject:contNo      forKey:KeyCashPosition_contNo];
    [aCoder encodeObject:conPrice      forKey:KeyCashPosition_conPrice];
    [aCoder encodeObject:buyOrSal      forKey:KeyCashPosition_buyOrSal];
    [aCoder encodeObject:wareId      forKey:KeyCashPosition_wareId];
    [aCoder encodeObject:contNum      forKey:KeyCashPosition_contNum];
    [aCoder encodeObject:bargainTime      forKey:KeyCashPosition_bargainTime];
    [aCoder encodeObject:tmpMoney      forKey:KeyCashPosition_tmpMoney];
    [aCoder encodeObject:contQty      forKey:KeyCashPosition_contQty];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.date      =[aDecoder decodeObjectForKey:KeyCashPosition_date];
        self.contNo      =[aDecoder decodeObjectForKey:KeyCashPosition_contNo];
        self.conPrice      =[aDecoder decodeObjectForKey:KeyCashPosition_conPrice];
        self.buyOrSal      =[aDecoder decodeObjectForKey:KeyCashPosition_buyOrSal];
        self.wareId      =[aDecoder decodeObjectForKey:KeyCashPosition_wareId];
        self.contNum      =[aDecoder decodeObjectForKey:KeyCashPosition_contNum];
        self.bargainTime      =[aDecoder decodeObjectForKey:KeyCashPosition_bargainTime];
        self.tmpMoney      =[aDecoder decodeObjectForKey:KeyCashPosition_tmpMoney];
        self.contQty      =[aDecoder decodeObjectForKey:KeyCashPosition_contQty];
        
    }
    
    return self;
}
@end
