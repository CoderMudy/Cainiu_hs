//
//  HolidayCacheModel.m
//  hs
//
//  Created by PXJ on 16/1/19.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "HolidayCacheModel.h"

#define HolidayCache_holidayDic @"holidayDic"
#define HolidayCache_holidayGameShow @"holidayGameShow"

@implementation HolidayCacheModel

@synthesize holidayDic,holidayGameShow;


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:holidayDic forKey:HolidayCache_holidayDic];
    [aCoder encodeObject:holidayGameShow forKey:HolidayCache_holidayGameShow];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.holidayDic=[aDecoder decodeObjectForKey:HolidayCache_holidayDic];
        self.holidayGameShow=[aDecoder decodeObjectForKey:HolidayCache_holidayGameShow];
    }
    return self;
}
@end

