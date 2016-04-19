//
//  PagePositionModel.m
//  hs
//
//  Created by PXJ on 15/6/26.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "PagePositionModel.h"

@implementation PagePositionModel

@synthesize positionDmodel,dataArray,dataDetailArray,realtimeSH,realtimeSZ;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:positionDmodel forKey:@"positionDmodel"];
    [aCoder encodeObject:dataArray forKey:@"dataArray"];
    [aCoder encodeObject:dataDetailArray forKey:@"dataDetailArray"];
    [aCoder encodeObject:realtimeSZ forKey:@"realtimeSZ"];
    [aCoder encodeObject:realtimeSH forKey:@"realtimeSH"];

}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        
        self.positionDmodel=[aDecoder decodeObjectForKey:@"positionDmodel"];
        self.dataArray=[aDecoder decodeObjectForKey:@"dataArray"];
        self.dataDetailArray=[aDecoder decodeObjectForKey:@"dataDetailArray"];
        self.realtimeSH=[aDecoder decodeObjectForKey:@"realtimeSH"];
        self.realtimeSZ=[aDecoder decodeObjectForKey:@"realtimeSZ"];

    }
    
    return self;
}







@end
