//
//  PageSSViewModel.m
//  hs
//
//  Created by PXJ on 15/7/1.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "RealTimeStockModel.h"

@implementation RealTimeStockModel





@synthesize name,code,codeType,price,buyPrice,salePrice,openPrice,hightPrice,lowPrice,closePrice,preClosePrice,priceChange,priceChangePerCent,tradeStatus,buyCount,timestamp;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:code forKey:@"code"];
    [aCoder encodeObject:codeType forKey:@"codeType"];
    [aCoder encodeObject:[NSNumber numberWithFloat:price] forKey:@"price"];
    [aCoder encodeObject:[NSNumber numberWithFloat:buyPrice] forKey:@"buyPrice"];
    [aCoder encodeObject:[NSNumber numberWithFloat:salePrice] forKey:@"salePrice"];
    [aCoder encodeObject:[NSNumber numberWithFloat:openPrice] forKey:@"openPrice"];
    [aCoder encodeObject:[NSNumber numberWithFloat:hightPrice] forKey:@"hightPrice"];
    [aCoder encodeObject:[NSNumber numberWithFloat:lowPrice] forKey:@"lowPrice"];
    [aCoder encodeObject:[NSNumber numberWithFloat:closePrice] forKey:@"closePrice"];
    [aCoder encodeObject:[NSNumber numberWithFloat:preClosePrice] forKey:@"preClosePrice"];
    [aCoder encodeObject:[NSNumber numberWithFloat:priceChange] forKey:@"priceChange"];
    [aCoder encodeObject:[NSNumber numberWithFloat:priceChangePerCent] forKey:@"priceChangePerCent"];
    [aCoder encodeObject:[NSNumber numberWithInt:tradeStatus] forKey:@"tradeStatus"];
    [aCoder encodeObject:[NSNumber numberWithInt:buyCount] forKey:@"buyCount"];
    [aCoder encodeObject:[NSNumber numberWithInt:timestamp] forKey:@"timestamp"];

}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        
        self.name               =[aDecoder decodeObjectForKey:@"name"];
        self.code               =[aDecoder decodeObjectForKey:@"code"];
        self.codeType           =[aDecoder decodeObjectForKey:@"codeType"];
        self.price              =[[aDecoder decodeObjectForKey:@"price"] floatValue];
        self.buyPrice           =[[aDecoder decodeObjectForKey:@"buyPrice"]floatValue];
        self.salePrice          =[[aDecoder decodeObjectForKey:@"salePrice"]floatValue];
        self.openPrice          =[[aDecoder decodeObjectForKey:@"openPrice"]floatValue];
        self.hightPrice         =[[aDecoder decodeObjectForKey:@"hightPrice"]floatValue];
        self.lowPrice           =[[aDecoder decodeObjectForKey:@"lowPrice"]floatValue];
        self.closePrice         =[[aDecoder decodeObjectForKey:@"closePrice"]floatValue];
        self.preClosePrice      =[[aDecoder decodeObjectForKey:@"preClosePrice"]floatValue];
        self.priceChange        =[[aDecoder decodeObjectForKey:@"priceChange"]floatValue];
        self.priceChangePerCent =[[aDecoder decodeObjectForKey:@"priceChangePerCent"]floatValue];
        self.tradeStatus        =[[aDecoder decodeObjectForKey:@"tradeStatus"]intValue];
        self.buyCount           =[[aDecoder decodeObjectForKey:@"buyCount"]intValue];
        self.timestamp          =[[aDecoder decodeObjectForKey:@"timestamp"]intValue];

        
    }
    
    return self;
}

- (id)realTimeStockModelwithHsrealtime:(HsRealtime*)realtime withBuyPrice:(float)buyprice salePrice:(float)saleprice buycount:(int)buycount
{
    if (self) {
        
        
        self.name               =realtime.name==nil?@"":realtime.name;
        self.code               =realtime.code==nil?@"":realtime.code;
        self.codeType           =realtime.codeType==nil?@"":realtime.codeType;
        self.price              =realtime.newPrice;
        self.buyPrice           =buyprice;
        self.salePrice          =saleprice;
        self.openPrice          =realtime.openPrice;
        self.hightPrice         =realtime.highPrice;
        self.lowPrice           =realtime.lowPrice;
        self.closePrice         =realtime.closePrice;
        self.preClosePrice      =realtime.preClosePrice;
        self.priceChange        =realtime.priceChange;
        self.priceChangePerCent =realtime.priceChangePercent;
        self.tradeStatus        =realtime.tradeStatus;
        self.buyCount           =buycount;
        self.timestamp          =(int)realtime.timestamp;
        
        
        
        
    }

    return self;



}


@end
