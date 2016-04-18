//
//  PositionData.m
//
//  Created by   on 15/7/8
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "PositionData.h"
#import "PositionOrderList.h"


NSString *const kPositionDataOrderList = @"orderList";
NSString *const kPositionDataScore = @"score";
NSString *const kPositionDataUsedAmt = @"usedAmt";

@interface PositionData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PositionData

@synthesize orderList = _orderList;
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
    NSObject *receivedPositionOrderList = [dict objectForKey:kPositionDataOrderList];
    NSMutableArray *parsedPositionOrderList = [NSMutableArray array];
    if ([receivedPositionOrderList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedPositionOrderList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedPositionOrderList addObject:[PositionOrderList modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedPositionOrderList isKindOfClass:[NSDictionary class]]) {
       [parsedPositionOrderList addObject:[PositionOrderList modelObjectWithDictionary:(NSDictionary *)receivedPositionOrderList]];
    }

    self.orderList = [NSArray arrayWithArray:parsedPositionOrderList];
        self.score = [self objectOrNilForKey:kPositionDataScore fromDictionary:dict];
        self.usedAmt = [self objectOrNilForKey:kPositionDataUsedAmt fromDictionary:dict];

        
   

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForOrderList] forKey:kPositionDataOrderList];
    [mutableDict setValue:self.score forKey:kPositionDataScore];
    [mutableDict setValue:self.usedAmt forKey:kPositionDataUsedAmt];
    

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

    self.orderList = [aDecoder decodeObjectForKey:kPositionDataOrderList];
    self.score = [aDecoder decodeObjectForKey:kPositionDataScore];
    self.usedAmt = [aDecoder decodeObjectForKey:kPositionDataUsedAmt];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_orderList forKey:kPositionDataOrderList];
    [aCoder encodeObject:_score forKey:kPositionDataScore];
    [aCoder encodeObject:_usedAmt forKey:kPositionDataUsedAmt];
}

- (id)copyWithZone:(NSZone *)zone
{
    PositionData *copy = [[PositionData alloc] init];
    
    if (copy) {

        copy.orderList = [self.orderList copyWithZone:zone];
        copy.score = [self.score copyWithZone:zone];
        copy.usedAmt = [self.usedAmt copyWithZone:zone];
    }
    
    return copy;
}


@end
