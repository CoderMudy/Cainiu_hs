//
//  OrderByModel.m
//  hs
//
//  Created by PXJ on 15/7/7.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "OrderByModel.h"

@implementation OrderByModel
@synthesize  price,buyCount,status,selectAmt,stockName,stockCode,stockCodeType;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:selectAmt forKey:@"selectAmt"];
    [aCoder encodeObject:stockName forKey:@"stockName"];
    [aCoder encodeObject:stockCode forKey:@"stockCode"];
    [aCoder encodeObject:stockCodeType forKey:@"stockCodeType"];
    [aCoder encodeObject:[NSNumber numberWithFloat:price] forKey:@"price"];
    [aCoder encodeObject:[NSNumber numberWithInt:buyCount] forKey:@"buyCount"];
    [aCoder encodeObject:[NSNumber numberWithInt:status] forKey:@"status"];

}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        
        self.selectAmt       =[aDecoder decodeObjectForKey:@"selectAmt"];
        self.stockName       =[aDecoder decodeObjectForKey:@"stockName"];
        self.stockCode       =[aDecoder decodeObjectForKey:@"stockCode"];
        self.stockCodeType   =[aDecoder decodeObjectForKey:@"stockCodeType"];
        self.price           =[[aDecoder decodeObjectForKey:@"price"] floatValue];
        self.buyCount        =[[aDecoder decodeObjectForKey:@"buyCount"]intValue];
        self.status          =[[aDecoder decodeObjectForKey:@"status"]intValue];
        
        
    }
    
    return self;
}
@end
