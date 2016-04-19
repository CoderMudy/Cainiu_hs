//
//  TradeConfigerModel.m
//  hs
//
//  Created by RGZ on 15/7/29.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "TradeConfigerModel.h"

@implementation TradeConfigerModel

@synthesize tradeID,financyAllocation,fundType,isEnabled,cashFund,theoryCounterFee,counterFee,maxProfit,maxLoss,multiple,isDefault,defaultProfit;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    @autoreleasepool {
        [aCoder encodeObject:tradeID forKey:@"tradeID"];
        [aCoder encodeObject:financyAllocation forKey:@"financyAllocation"];
        [aCoder encodeObject:fundType forKey:@"fundType"];
        [aCoder encodeObject:isEnabled forKey:@"isEnabled"];
        [aCoder encodeObject:cashFund forKey:@"cashFund"];
        [aCoder encodeObject:theoryCounterFee forKey:@"theoryCounterFee"];
        [aCoder encodeObject:counterFee forKey:@"counterFee"];
        [aCoder encodeObject:maxProfit forKey:@"maxProfit"];
        [aCoder encodeObject:maxLoss forKey:@"maxLoss"];
        [aCoder encodeObject:multiple forKey:@"multiple"];
        [aCoder encodeObject:isDefault forKey:@"isDefault"];
        [aCoder encodeObject:defaultProfit forKey:@"defaultProfit"];
    }
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.tradeID=[aDecoder decodeObjectForKey:@"tradeID"];
        self.financyAllocation=[aDecoder decodeObjectForKey:@"financyAllocation"];
        self.fundType=[aDecoder decodeObjectForKey:@"fundType"];
        self.isEnabled=[aDecoder decodeObjectForKey:@"isEnabled"];
        self.cashFund=[aDecoder decodeObjectForKey:@"cashFund"];
        self.theoryCounterFee=[aDecoder decodeObjectForKey:@"theoryCounterFee"];
        self.counterFee=[aDecoder decodeObjectForKey:@"counterFee"];
        self.maxProfit=[aDecoder decodeObjectForKey:@"maxProfit"];
        self.maxLoss = [aDecoder decodeObjectForKey:@"maxLoss"];
        self.multiple = [aDecoder decodeObjectForKey:@"multiple"];
        self.isDefault = [aDecoder decodeObjectForKey:@"isDefault"];
        self.defaultProfit = [aDecoder decodeObjectForKey:@"defaultProfit"];
    }
    
    return self;
}


@end
