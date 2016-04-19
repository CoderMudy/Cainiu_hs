//
//  IndexPositionData.m
//
//  Created by   on 15/7/29
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "IndexPositionData.h"
#import "IndexPositionFuturesCashOrderList.h"
#import "IndexPositionFuturesScoreOrderList.h"
#import "IndexPositionList.h"


NSString *const kIndexPositionDataFuturesCashOrderList = @"futuresCashOrderList";
NSString *const kIndexPositionDataFuturesScoreOrderList = @"futuresScoreOrderList";
NSString *const kIndexPositionDataList = @"list";

NSString *const kIndexPositionDataScore = @"score";
NSString *const kIndexPositionDatausedAmt = @"usedAmt";


@interface IndexPositionData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation IndexPositionData

@synthesize futuresCashOrderList = _futuresCashOrderList;
@synthesize futuresScoreOrderList = _futuresScoreOrderList;
@synthesize list = _list;
@synthesize score = _score;
@synthesize usedAmt = _usedAmt;

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
        NSObject *receivedIndexPositionFuturesCashOrderList = [dict objectForKey:kIndexPositionDataFuturesCashOrderList];
        NSMutableArray *parsedIndexPositionFuturesCashOrderList = [NSMutableArray array];
        if ([receivedIndexPositionFuturesCashOrderList isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedIndexPositionFuturesCashOrderList) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedIndexPositionFuturesCashOrderList addObject:[IndexPositionFuturesCashOrderList modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedIndexPositionFuturesCashOrderList isKindOfClass:[NSDictionary class]]) {
            [parsedIndexPositionFuturesCashOrderList addObject:[IndexPositionFuturesCashOrderList modelObjectWithDictionary:(NSDictionary *)receivedIndexPositionFuturesCashOrderList]];
        }
        
        self.futuresCashOrderList = [NSArray arrayWithArray:parsedIndexPositionFuturesCashOrderList];
        
        NSObject *receivedIndexPositionFuturesScoreOrderList = [dict objectForKey:kIndexPositionDataFuturesScoreOrderList];
        NSMutableArray *parsedIndexPositionFuturesScoreOrderList = [NSMutableArray array];
        if ([receivedIndexPositionFuturesScoreOrderList isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedIndexPositionFuturesScoreOrderList) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedIndexPositionFuturesScoreOrderList addObject:[IndexPositionFuturesScoreOrderList modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedIndexPositionFuturesScoreOrderList isKindOfClass:[NSDictionary class]]) {
            [parsedIndexPositionFuturesScoreOrderList addObject:[IndexPositionFuturesScoreOrderList modelObjectWithDictionary:(NSDictionary *)receivedIndexPositionFuturesScoreOrderList]];
        }
        
        self.futuresScoreOrderList = [NSArray arrayWithArray:parsedIndexPositionFuturesScoreOrderList];
        NSObject *receivedIndexPositionList = [dict objectForKey:kIndexPositionDataList];
        NSMutableArray *parsedIndexPositionList = [NSMutableArray array];
        if ([receivedIndexPositionList isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedIndexPositionList) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedIndexPositionList addObject:[IndexPositionList modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedIndexPositionList isKindOfClass:[NSDictionary class]]) {
            [parsedIndexPositionList addObject:[IndexPositionList modelObjectWithDictionary:(NSDictionary *)receivedIndexPositionList]];
        }
        
        self.list = [NSArray arrayWithArray:parsedIndexPositionList];

        
        
        self.score = [self objectOrNilForKey:kIndexPositionDataScore fromDictionary:dict];
        self.usedAmt = [self objectOrNilForKey:kIndexPositionDatausedAmt fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForFuturesCashOrderList = [NSMutableArray array];
    for (NSObject *subArrayObject in self.futuresCashOrderList) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForFuturesCashOrderList addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForFuturesCashOrderList addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForFuturesCashOrderList] forKey:kIndexPositionDataFuturesCashOrderList];
    NSMutableArray *tempArrayForFuturesScoreOrderList = [NSMutableArray array];
    for (NSObject *subArrayObject in self.futuresScoreOrderList) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForFuturesScoreOrderList addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForFuturesScoreOrderList addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForFuturesScoreOrderList] forKey:kIndexPositionDataFuturesScoreOrderList];
    
    NSMutableArray *tempArrayForList = [NSMutableArray array];
    for (NSObject *subArrayObject in self.list) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForList addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForList addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForList] forKey:kIndexPositionDataList];

    
    
    [mutableDict setValue:self.score forKey:kIndexPositionDataScore];
    [mutableDict setValue:self.usedAmt forKey:kIndexPositionDatausedAmt];

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
    
    self.futuresCashOrderList = [aDecoder decodeObjectForKey:kIndexPositionDataFuturesCashOrderList];
    self.futuresScoreOrderList = [aDecoder decodeObjectForKey:kIndexPositionDataFuturesScoreOrderList];
    self.list = [aDecoder decodeObjectForKey:kIndexPositionDataList];

    self.score = [aDecoder decodeObjectForKey:kIndexPositionDataScore];
    self.usedAmt = [aDecoder decodeObjectForKey:kIndexPositionDatausedAmt];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_futuresCashOrderList forKey:kIndexPositionDataFuturesCashOrderList];
    [aCoder encodeObject:_futuresScoreOrderList forKey:kIndexPositionDataFuturesScoreOrderList];
    [aCoder encodeObject:_list forKey:kIndexPositionDataList];

    [aCoder encodeObject:_score forKey:kIndexPositionDataScore];
    [aCoder encodeObject:_usedAmt forKey:kIndexPositionDatausedAmt];
}

- (id)copyWithZone:(NSZone *)zone
{
    IndexPositionData *copy = [[IndexPositionData alloc] init];
    
    if (copy) {
        
        copy.futuresCashOrderList = [self.futuresCashOrderList copyWithZone:zone];
        copy.futuresScoreOrderList = [self.futuresScoreOrderList copyWithZone:zone];
        copy.list = [self.list copyWithZone:zone];

        copy.score = [self.score copyWithZone:zone];
        copy.usedAmt= [self.usedAmt copyWithZone:zone];
    }
    
    return copy;
}


@end
