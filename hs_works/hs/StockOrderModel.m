//
//  StockOrderModel.m
//  hs
//
//  Created by RGZ on 15/7/7.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "StockOrderModel.h"

@implementation StockOrderModel

@synthesize stockCashFund,stockCounterFee,stockFinancyAllocation,stockFundType,stockID,stockInterest,stockMaxLoss,stockMultiple,stockStatus,stockWarnAmt,stockDeductCounterFee;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithFloat:stockCashFund] forKey:@"stockCashFund"];
    [aCoder encodeObject:[NSNumber numberWithFloat:stockCounterFee] forKey:@"stockCounterFee"];
    [aCoder encodeObject:[NSNumber numberWithFloat:stockFinancyAllocation] forKey:@"stockFinancyAllocation"];
    [aCoder encodeObject:[NSNumber numberWithInt:stockFundType] forKey:@"stockFundType"];
    [aCoder encodeObject:[NSNumber numberWithInt:stockID] forKey:@"stockID"];
    [aCoder encodeObject:[NSNumber numberWithInt:stockInterest] forKey:@"stockInterest"];
    [aCoder encodeObject:[NSNumber numberWithFloat:stockMaxLoss] forKey:@"stockMaxLoss"];
    [aCoder encodeObject:[NSNumber numberWithFloat:stockMultiple] forKey:@"stockMultiple"];
    [aCoder encodeObject:[NSNumber numberWithInt:stockStatus] forKey:@"stockStatus"];
    [aCoder encodeObject:[NSNumber numberWithFloat:stockWarnAmt] forKey:@"stockWarnAmt"];
    [aCoder encodeObject:[NSNumber numberWithFloat:stockDeductCounterFee] forKey:@"stockDeductCounterFee"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.stockCashFund=[[aDecoder decodeObjectForKey:@"stockCashFund"] floatValue];
        self.stockCounterFee=[[aDecoder decodeObjectForKey:@"stockCounterFee"] floatValue];
        self.stockFinancyAllocation=[[aDecoder decodeObjectForKey:@"stockFinancyAllocation"] floatValue];
        self.stockFundType=[[aDecoder decodeObjectForKey:@"stockFundType"] intValue];
        self.stockID=[[aDecoder decodeObjectForKey:@"stockID"] intValue];
        self.stockInterest=[[aDecoder decodeObjectForKey:@"stockInterest"] intValue];
        self.stockMaxLoss=[[aDecoder decodeObjectForKey:@"stockMaxLoss"] floatValue];
        self.stockMultiple=[[aDecoder decodeObjectForKey:@"stockMultiple"] floatValue];
        self.stockStatus = [[aDecoder decodeObjectForKey:@"stockStatus"] intValue];
        self.stockWarnAmt = [[aDecoder decodeObjectForKey:@"stockWarnAmt"] floatValue];
        self.stockDeductCounterFee = [[aDecoder decodeObjectForKey:@"stockDeductCounterFee"] floatValue];
    }
    
    return self;
}

@end
