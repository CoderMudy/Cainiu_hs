//
//  PageOrderBuyModel.m
//  hs
//
//  Created by PXJ on 15/6/26.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "PageOrderBuyModel.h"

@implementation PageOrderBuyModel
@synthesize limitPriceArray,listDictionary;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:limitPriceArray forKey:@"limitPriceArray"];
    [aCoder encodeObject:listDictionary forKey:@"listDictionary"];

}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        
        self.limitPriceArray=[aDecoder decodeObjectForKey:@"limitPriceArray"];
        self.listDictionary=[aDecoder decodeObjectForKey:@"listDictionary"];

    }
    
    return self;
}

@end
