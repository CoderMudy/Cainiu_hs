//
//  PageSSViewModel.m
//  hs
//
//  Created by PXJ on 15/7/1.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "PageSSViewModel.h"

@implementation PageSSViewModel





@synthesize name,price,priceChange,priceChangePerCent;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:[NSNumber numberWithFloat:priceChange] forKey:@"priceChange"];
    [aCoder encodeObject:[NSNumber numberWithFloat:price] forKey:@"price"];
    [aCoder encodeObject:[NSNumber numberWithFloat:priceChangePerCent] forKey:@"priceChangePerCent"];

}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        
        self.name=[aDecoder decodeObjectForKey:@"name"];
        self.priceChange=[[aDecoder decodeObjectForKey:@"priceChange"]floatValue];
        self.price=[[aDecoder decodeObjectForKey:@"price"] floatValue];
        self.priceChangePerCent=[[aDecoder decodeObjectForKey:@"priceChangePerCent"]floatValue];
    
        
    }
    
    return self;
}



@end
