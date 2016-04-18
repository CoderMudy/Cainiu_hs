//
//  StockDetailBaseClass.m
//
//  Created by   on 15/5/18
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "StockDetailBaseClass.h"
#import "StockDetailData.h"


NSString *const kStockDetailBaseClassCode = @"code";
NSString *const kStockDetailBaseClassData = @"data";
NSString *const kStockDetailBaseClassMsg = @"msg";
NSString *const kStockDetailBaseClassErrparam = @"errparam";


@interface StockDetailBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation StockDetailBaseClass

@synthesize code = _code;
@synthesize data = _data;
@synthesize msg = _msg;
@synthesize errparam = _errparam;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.code = [[self objectOrNilForKey:kStockDetailBaseClassCode fromDictionary:dict] doubleValue];
    NSObject *receivedStockDetailData = [dict objectForKey:kStockDetailBaseClassData];
    NSMutableArray *parsedStockDetailData = [NSMutableArray array];
    if ([receivedStockDetailData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedStockDetailData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedStockDetailData addObject:[StockDetailData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedStockDetailData isKindOfClass:[NSDictionary class]]) {
       [parsedStockDetailData addObject:[StockDetailData modelObjectWithDictionary:(NSDictionary *)receivedStockDetailData]];
    }

    self.data = [NSArray arrayWithArray:parsedStockDetailData];
            self.msg = [self objectOrNilForKey:kStockDetailBaseClassMsg fromDictionary:dict];
            self.errparam = [self objectOrNilForKey:kStockDetailBaseClassErrparam fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kStockDetailBaseClassCode];
    NSMutableArray *tempArrayForData = [NSMutableArray array];
    for (NSObject *subArrayObject in self.data) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForData addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForData addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kStockDetailBaseClassData];
    [mutableDict setValue:self.msg forKey:kStockDetailBaseClassMsg];
    [mutableDict setValue:self.errparam forKey:kStockDetailBaseClassErrparam];
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.code = [aDecoder decodeDoubleForKey:kStockDetailBaseClassCode];
    self.data = [aDecoder decodeObjectForKey:kStockDetailBaseClassData];
    self.msg = [aDecoder decodeObjectForKey:kStockDetailBaseClassMsg];
    self.errparam = [aDecoder decodeObjectForKey:kStockDetailBaseClassErrparam];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kStockDetailBaseClassCode];
    [aCoder encodeObject:_data forKey:kStockDetailBaseClassData];
    [aCoder encodeObject:_msg forKey:kStockDetailBaseClassMsg];
    [aCoder encodeObject:_errparam forKey:kStockDetailBaseClassErrparam];
}

- (id)copyWithZone:(NSZone *)zone
{
    StockDetailBaseClass *copy = [[StockDetailBaseClass alloc] init];
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.errparam = [self.errparam copyWithZone:zone];
    }
    
    return copy;
}


@end
