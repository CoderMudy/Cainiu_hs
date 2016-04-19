//
//  CashPositionDataModel.m
//  hs
//
//  Created by PXJ on 15/12/3.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "CashPositionDataModel.h"

#define KeyCash_account @"account"
#define KeyCash_price @"price"
#define KeyCash_newPrice @"newPrice"
#define KeyCash_consultCost @"consultCost"
#define KeyCash_wareId @"wareId"
#define KeyCash_buyOrSal @"buyOrSal"
#define KeyCash_bidPrice @"bidPrice"
#define KeyCash_askPrice @"askPrice"
#define KeyCash_orderId @"orderId"
#define KeyCash_enableSaleNum @"enableSaleNum"

@implementation CashPositionDataModel
@synthesize account,price,newprice,consultCost,wareId,buyOrSal,bidPrice,askPrice,orderId,enableSaleNum;
- (id)initWithDic:(NSDictionary*)dictionary;
{
    self = [super init];
    if (self) {
        
        if (dictionary[KeyCash_account] != nil && ![dictionary[KeyCash_account] isKindOfClass:[NSNull class]])
        {
            self.account = [NSString stringWithFormat:@"%@",dictionary[KeyCash_account]];
        }
        else{
            self.account = @"";
        }
        
        
        if (dictionary[KeyCash_price] != nil && ![dictionary[KeyCash_price] isKindOfClass:[NSNull class]])
        {
            self.price = [NSString stringWithFormat:@"%@",dictionary[KeyCash_price]];
        }
        else{
            self.price = @"";
        }
        if (dictionary[KeyCash_newPrice] != nil && ![dictionary[KeyCash_newPrice] isKindOfClass:[NSNull class]])
        {
            self.newprice = [NSString stringWithFormat:@"%@",dictionary[KeyCash_newPrice]];
        }
        else{
            self.newprice = @"";
        }
        if (dictionary[KeyCash_consultCost] != nil && ![dictionary[KeyCash_consultCost] isKindOfClass:[NSNull class]])
        {
            self.consultCost = [NSString stringWithFormat:@"%@",dictionary[KeyCash_consultCost]];
        }
        else{
            self.consultCost = @"";
        }
        if (dictionary[KeyCash_wareId] != nil && ![dictionary[KeyCash_wareId] isKindOfClass:[NSNull class]])
        {
            self.wareId = [NSString stringWithFormat:@"%@",dictionary[KeyCash_wareId]];
        }
        else{
            self.wareId = @"";
        }
        if (dictionary[KeyCash_buyOrSal] != nil && ![dictionary[KeyCash_buyOrSal] isKindOfClass:[NSNull class]])
        {
            self.buyOrSal = [NSString stringWithFormat:@"%@",dictionary[KeyCash_buyOrSal]];
        }
        else{
            self.buyOrSal = @"";
        }
        if (dictionary[KeyCash_bidPrice] != nil && ![dictionary[KeyCash_bidPrice] isKindOfClass:[NSNull class]])
        {
            self.bidPrice = [NSString stringWithFormat:@"%@",dictionary[KeyCash_bidPrice]];
        }
        else{
            self.bidPrice = @"";
        }
        if (dictionary[KeyCash_askPrice] != nil && ![dictionary[KeyCash_askPrice] isKindOfClass:[NSNull class]])
        {
            self.askPrice = [NSString stringWithFormat:@"%@",dictionary[KeyCash_askPrice]];
        }
        else{
            self.askPrice = @"";
        }
        if (dictionary[KeyCash_orderId] != nil && ![dictionary[KeyCash_orderId] isKindOfClass:[NSNull class]])
        {
            self.orderId = [NSString stringWithFormat:@"%@",dictionary[KeyCash_orderId]];
        }
        else{
            self.orderId = @"";
        }
        if (dictionary[KeyCash_enableSaleNum] != nil && ![dictionary[KeyCash_enableSaleNum] isKindOfClass:[NSNull class]])
        {
            self.enableSaleNum = [NSString stringWithFormat:@"%@",dictionary[KeyCash_enableSaleNum]];
        }
        else{
            self.enableSaleNum = @"";
        }
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:account        forKey:KeyCash_account];
    [aCoder encodeObject:price          forKey:KeyCash_price];
    [aCoder encodeObject:newprice       forKey:KeyCash_newPrice];
    [aCoder encodeObject:consultCost    forKey:KeyCash_consultCost];
    [aCoder encodeObject:wareId         forKey:KeyCash_wareId];
    [aCoder encodeObject:buyOrSal       forKey:KeyCash_buyOrSal];
    [aCoder encodeObject:bidPrice       forKey:KeyCash_bidPrice];
    [aCoder encodeObject:askPrice       forKey:KeyCash_askPrice];
    [aCoder encodeObject:orderId        forKey:KeyCash_orderId];
    [aCoder encodeObject:enableSaleNum        forKey:KeyCash_enableSaleNum];

}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.account        =[aDecoder decodeObjectForKey:KeyCash_account];
        self.price          =[aDecoder decodeObjectForKey:KeyCash_price];
        self.newprice       =[aDecoder decodeObjectForKey:KeyCash_newPrice];
        self.consultCost    =[aDecoder decodeObjectForKey:KeyCash_consultCost];
        self.wareId         =[aDecoder decodeObjectForKey:KeyCash_wareId];
        self.buyOrSal       =[aDecoder decodeObjectForKey:KeyCash_buyOrSal];
        self.bidPrice       =[aDecoder decodeObjectForKey:KeyCash_bidPrice];
        self.askPrice       =[aDecoder decodeObjectForKey:KeyCash_askPrice];
        self.orderId        =[aDecoder decodeObjectForKey:KeyCash_orderId];
        self.enableSaleNum  =[aDecoder decodeObjectForKey:KeyCash_enableSaleNum];

    }
    
    return self;
}

@end
