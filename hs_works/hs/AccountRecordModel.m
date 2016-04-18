//
//  AccountRecordModel.m
//  hs
//
//  Created by RGZ on 15/6/23.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "AccountRecordModel.h"

@implementation AccountRecordModel

@synthesize conceiveArray,settledArray,conceivePointArray,settledPointArray;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:conceiveArray forKey:@"conceiveArray"];
    [aCoder encodeObject:settledArray forKey:@"settledArray"];
    [aCoder encodeObject:conceivePointArray forKey:@"conceivePointArray"];
    [aCoder encodeObject:settledPointArray forKey:@"settledPointArray"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.conceiveArray=[aDecoder decodeObjectForKey:@"conceiveArray"];
        self.settledArray=[aDecoder decodeObjectForKey:@"settledArray"];
        self.conceivePointArray=[aDecoder decodeObjectForKey:@"conceivePointArray"];
        self.settledPointArray=[aDecoder decodeObjectForKey:@"settledPointArray"];
    }
    
    return self;
}

@end
