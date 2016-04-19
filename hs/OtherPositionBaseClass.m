//
//  OtherPositionBaseClass.m
//
//  Created by   on 15/6/1
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "OtherPositionBaseClass.h"


NSString *const kOtherPositionBaseClassStockName = @"stockName";
NSString *const kOtherPositionBaseClassBuyQuatity = @"buyQuatity";
NSString *const kOtherPositionBaseClassStockCode = @"stockCode";
NSString *const kOtherPositionBaseClassBuyPrice = @"buyPrice";
NSString *const kOtherPositionBaseClassCodeType = @"codeType";


@interface OtherPositionBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OtherPositionBaseClass

@synthesize stockName = _stockName;
@synthesize buyQuatity = _buyQuatity;
@synthesize stockCode = _stockCode;
@synthesize buyPrice = _buyPrice;
@synthesize codeType = _codeType;


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
            self.stockName = [self objectOrNilForKey:kOtherPositionBaseClassStockName fromDictionary:dict];
            self.buyQuatity = [self objectOrNilForKey:kOtherPositionBaseClassBuyQuatity fromDictionary:dict];
            self.stockCode = [self objectOrNilForKey:kOtherPositionBaseClassStockCode fromDictionary:dict];
            self.buyPrice = [self objectOrNilForKey:kOtherPositionBaseClassBuyPrice fromDictionary:dict];
            self.codeType = [self objectOrNilForKey:kOtherPositionBaseClassCodeType fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.stockName forKey:kOtherPositionBaseClassStockName];
    [mutableDict setValue:self.buyQuatity forKey:kOtherPositionBaseClassBuyQuatity];
    [mutableDict setValue:self.stockCode forKey:kOtherPositionBaseClassStockCode];
    [mutableDict setValue:self.buyPrice forKey:kOtherPositionBaseClassBuyPrice];
    [mutableDict setValue:self.codeType forKey:kOtherPositionBaseClassCodeType];

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

    self.stockName = [aDecoder decodeObjectForKey:kOtherPositionBaseClassStockName];
    self.buyQuatity = [aDecoder decodeObjectForKey:kOtherPositionBaseClassBuyQuatity];
    self.stockCode = [aDecoder decodeObjectForKey:kOtherPositionBaseClassStockCode];
    self.buyPrice = [aDecoder decodeObjectForKey:kOtherPositionBaseClassBuyPrice];
    self.codeType = [aDecoder decodeObjectForKey:kOtherPositionBaseClassCodeType];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_stockName forKey:kOtherPositionBaseClassStockName];
    [aCoder encodeObject:_buyQuatity forKey:kOtherPositionBaseClassBuyQuatity];
    [aCoder encodeObject:_stockCode forKey:kOtherPositionBaseClassStockCode];
    [aCoder encodeObject:_buyPrice forKey:kOtherPositionBaseClassBuyPrice];
    [aCoder encodeObject:_codeType forKey:kOtherPositionBaseClassCodeType];
}

- (id)copyWithZone:(NSZone *)zone
{
    OtherPositionBaseClass *copy = [[OtherPositionBaseClass alloc] init];
    
    if (copy) {

        copy.stockName = [self.stockName copyWithZone:zone];
        copy.buyQuatity = [self.buyQuatity copyWithZone:zone];
        copy.stockCode = [self.stockCode copyWithZone:zone];
        copy.buyPrice = [self.buyPrice copyWithZone:zone];
        copy.codeType = [self.codeType copyWithZone:zone];
    }
    
    return copy;
}


@end
