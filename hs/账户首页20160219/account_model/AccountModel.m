//
//  AccountModel.m
//  hs
//
//  Created by PXJ on 16/2/24.
//  Copyright © 2016年 luckin. All rights reserved.
//

#define AccountModel_code @"code"
#define AccountModel_amt @"amt"
#define AccountModel_floatAmt @"floatAmt"
#define AccountModel_status @"status"
#define AccountModel_type @"type"
#define AccountModel_imgUrl @"imgUrl"
#define AccountModel_url @"url"
#define AccountModel_name @"name"

#import "AccountModel.h"

@implementation AccountModel

@synthesize code,amt,floatAmt,status,type,imgUrl,url,name;

+(id)accountModelWithDictionary:(NSDictionary*)dictionary;
{
    return [[AccountModel alloc] initWithDictionary:dictionary];
}

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if(self)
    {
        if (dictionary[AccountModel_code] != nil && ![dictionary[AccountModel_code] isKindOfClass:[NSNull class]])
        {
            self.code = [NSString stringWithFormat:@"%@",dictionary[AccountModel_code]];
        }
        else
        {
            self.code = @"";
        }
        
        if (dictionary[AccountModel_amt] != nil && ![dictionary[AccountModel_amt] isKindOfClass:[NSNull class]])
        {
            self.amt = [NSString stringWithFormat:@"%@",dictionary[AccountModel_amt]];
        }
        else
        {
            self.amt = @"";
        }
        
        if (dictionary[AccountModel_floatAmt] != nil && ![dictionary[AccountModel_floatAmt] isKindOfClass:[NSNull class]])
        {
            self.floatAmt = [NSString stringWithFormat:@"%@",dictionary[AccountModel_floatAmt]];
        }
        else
        {
            self.floatAmt = @"";
        }
        if (dictionary[AccountModel_status] != nil && ![dictionary[AccountModel_status] isKindOfClass:[NSNull class]])
        {
            self.status = [NSString stringWithFormat:@"%@",dictionary[AccountModel_status]];
        }
        else
        {
            self.status = @"";
        }
        if (dictionary[AccountModel_type] != nil && ![dictionary[AccountModel_type] isKindOfClass:[NSNull class]])
        {
            self.type = [NSString stringWithFormat:@"%@",dictionary[AccountModel_type]];
        }
        else
        {
            self.type = @"";
        }
        if (dictionary[AccountModel_imgUrl] != nil && ![dictionary[AccountModel_imgUrl] isKindOfClass:[NSNull class]])
        {
            self.imgUrl = [NSString stringWithFormat:@"%@",dictionary[AccountModel_imgUrl]];
        }
        else
        {
            self.imgUrl = @"";
        }
        if (dictionary[AccountModel_url] != nil && ![dictionary[AccountModel_url] isKindOfClass:[NSNull class]])
        {
            self.url = [NSString stringWithFormat:@"%@",dictionary[AccountModel_url]];
        }
        else
        {
            self.url = @"";
        }
        if (dictionary[AccountModel_name] != nil && ![dictionary[AccountModel_name] isKindOfClass:[NSNull class]])
        {
            self.name = [NSString stringWithFormat:@"%@",dictionary[AccountModel_name]];
        }
        else
        {
            self.name = @"";
        }

    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:code      forKey:AccountModel_code];
    [aCoder encodeObject:amt      forKey:AccountModel_amt];
    [aCoder encodeObject:floatAmt      forKey:AccountModel_floatAmt];
    [aCoder encodeObject:status      forKey:AccountModel_status];
    [aCoder encodeObject:type      forKey:AccountModel_type];
    [aCoder encodeObject:imgUrl      forKey:AccountModel_imgUrl];
    [aCoder encodeObject:url      forKey:AccountModel_url];
    [aCoder encodeObject:name      forKey:AccountModel_name];

}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.code      =[aDecoder decodeObjectForKey:AccountModel_code];
        self.amt      =[aDecoder decodeObjectForKey:AccountModel_amt];
        self.floatAmt      =[aDecoder decodeObjectForKey:AccountModel_floatAmt];
        self.status      =[aDecoder decodeObjectForKey:AccountModel_status];
        self.type      =[aDecoder decodeObjectForKey:AccountModel_type];
        self.imgUrl      =[aDecoder decodeObjectForKey:AccountModel_imgUrl];
        self.url      =[aDecoder decodeObjectForKey:AccountModel_url];
        self.name      =[aDecoder decodeObjectForKey:AccountModel_name];

    }
    return self;
}
@end
