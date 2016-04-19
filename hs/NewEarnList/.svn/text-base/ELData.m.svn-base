//
//  ELData.m
//
//  Created by   on 15/7/9
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "ELData.h"
#import "ELOrderList.h"


NSString *const kELDataUuId = @"uuId";
NSString *const kELDataHeadPic = @"headPic";
NSString *const kELDataStockName = @"stockName";
NSString *const kELDataBuyDate = @"buyDate";
NSString *const kELDataPersonalSign = @"personalSign";
NSString *const kELDataNickName = @"nickName";
NSString *const kELDataOrderList = @"orderList";


@interface ELData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ELData

@synthesize uuId = _uuId;
@synthesize headPic = _headPic;
@synthesize stockName = _stockName;
@synthesize buyDate = _buyDate;
@synthesize personalSign = _personalSign;
@synthesize nickName = _nickName;
@synthesize orderList = _orderList;


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
            self.uuId = [self objectOrNilForKey:kELDataUuId fromDictionary:dict];
            self.headPic = [self objectOrNilForKey:kELDataHeadPic fromDictionary:dict];
            self.stockName = [self objectOrNilForKey:kELDataStockName fromDictionary:dict];
            self.buyDate = [self objectOrNilForKey:kELDataBuyDate fromDictionary:dict];
            self.personalSign = [self objectOrNilForKey:kELDataPersonalSign fromDictionary:dict];
            self.nickName = [self objectOrNilForKey:kELDataNickName fromDictionary:dict];
    NSObject *receivedELOrderList = [dict objectForKey:kELDataOrderList];
    NSMutableArray *parsedELOrderList = [NSMutableArray array];
    if ([receivedELOrderList isKindOfClass:[NSMutableArray class]]) {
        for (NSDictionary *item in (NSMutableArray *)receivedELOrderList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedELOrderList addObject:[ELOrderList modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedELOrderList isKindOfClass:[NSDictionary class]]) {
       [parsedELOrderList addObject:[ELOrderList modelObjectWithDictionary:(NSDictionary *)receivedELOrderList]];
    }

    self.orderList = [NSMutableArray arrayWithArray:parsedELOrderList];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.uuId forKey:kELDataUuId];
    [mutableDict setValue:self.headPic forKey:kELDataHeadPic];
    [mutableDict setValue:self.stockName forKey:kELDataStockName];
    [mutableDict setValue:self.buyDate forKey:kELDataBuyDate];
    [mutableDict setValue:self.personalSign forKey:kELDataPersonalSign];
    [mutableDict setValue:self.nickName forKey:kELDataNickName];
    NSMutableArray *tempArrayForOrderList = [NSMutableArray array];
    for (NSObject *subArrayObject in self.orderList) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForOrderList addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForOrderList addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForOrderList] forKey:kELDataOrderList];

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

    self.uuId = [aDecoder decodeObjectForKey:kELDataUuId];
    self.headPic = [aDecoder decodeObjectForKey:kELDataHeadPic];
    self.stockName = [aDecoder decodeObjectForKey:kELDataStockName];
    self.buyDate = [aDecoder decodeObjectForKey:kELDataBuyDate];
    self.personalSign = [aDecoder decodeObjectForKey:kELDataPersonalSign];
    self.nickName = [aDecoder decodeObjectForKey:kELDataNickName];
    self.orderList = [aDecoder decodeObjectForKey:kELDataOrderList];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_uuId forKey:kELDataUuId];
    [aCoder encodeObject:_headPic forKey:kELDataHeadPic];
    [aCoder encodeObject:_stockName forKey:kELDataStockName];
    [aCoder encodeObject:_buyDate forKey:kELDataBuyDate];
    [aCoder encodeObject:_personalSign forKey:kELDataPersonalSign];
    [aCoder encodeObject:_nickName forKey:kELDataNickName];
    [aCoder encodeObject:_orderList forKey:kELDataOrderList];
}

- (id)copyWithZone:(NSZone *)zone
{
    ELData *copy = [[ELData alloc] init];
    
    if (copy) {

        copy.uuId = [self.uuId copyWithZone:zone];
        copy.headPic = [self.headPic copyWithZone:zone];
        copy.stockName = [self.stockName copyWithZone:zone];
        copy.buyDate = [self.buyDate copyWithZone:zone];
        copy.personalSign = [self.personalSign copyWithZone:zone];
        copy.nickName = [self.nickName copyWithZone:zone];
        copy.orderList = [self.orderList copyWithZone:zone];
    }
    
    return copy;
}


@end
