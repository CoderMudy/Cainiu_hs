//
//  PersonPositionData.m
//
//  Created by   on 15/5/10
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "PersonPositionData.h"
#import "PersonPositionPosiBoList.h"


NSString *const kPersonPositionDataTotalCashProfit = @"totalCashProfit";
NSString *const kPersonPositionDataTotalScoreProfit = @"totalScoreProfit";
NSString *const kPersonPositionDataPosiBoList = @"posiBoList";


@interface PersonPositionData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PersonPositionData

@synthesize totalCashProfit = _totalCashProfit;
@synthesize totalScoreProfit = _totalScoreProfit;
@synthesize posiBoList = _posiBoList;


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
            self.totalCashProfit = [[self objectOrNilForKey:kPersonPositionDataTotalCashProfit fromDictionary:dict] doubleValue];
            self.totalScoreProfit = [[self objectOrNilForKey:kPersonPositionDataTotalScoreProfit fromDictionary:dict] doubleValue];
    NSObject *receivedPersonPositionPosiBoList = [dict objectForKey:kPersonPositionDataPosiBoList];
    NSMutableArray *parsedPersonPositionPosiBoList = [NSMutableArray array];
    if ([receivedPersonPositionPosiBoList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedPersonPositionPosiBoList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedPersonPositionPosiBoList addObject:[PersonPositionPosiBoList modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedPersonPositionPosiBoList isKindOfClass:[NSDictionary class]]) {
       [parsedPersonPositionPosiBoList addObject:[PersonPositionPosiBoList modelObjectWithDictionary:(NSDictionary *)receivedPersonPositionPosiBoList]];
    }

    self.posiBoList = [NSArray arrayWithArray:parsedPersonPositionPosiBoList];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalCashProfit] forKey:kPersonPositionDataTotalCashProfit];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalScoreProfit] forKey:kPersonPositionDataTotalScoreProfit];
    NSMutableArray *tempArrayForPosiBoList = [NSMutableArray array];
    for (NSObject *subArrayObject in self.posiBoList) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForPosiBoList addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForPosiBoList addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForPosiBoList] forKey:kPersonPositionDataPosiBoList];

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

    self.totalCashProfit = [aDecoder decodeDoubleForKey:kPersonPositionDataTotalCashProfit];
    self.totalScoreProfit = [aDecoder decodeDoubleForKey:kPersonPositionDataTotalScoreProfit];
    self.posiBoList = [aDecoder decodeObjectForKey:kPersonPositionDataPosiBoList];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_totalCashProfit forKey:kPersonPositionDataTotalCashProfit];
    [aCoder encodeDouble:_totalScoreProfit forKey:kPersonPositionDataTotalScoreProfit];
    [aCoder encodeObject:_posiBoList forKey:kPersonPositionDataPosiBoList];
}

- (id)copyWithZone:(NSZone *)zone
{
    PersonPositionData *copy = [[PersonPositionData alloc] init];
    
    if (copy) {

        copy.totalCashProfit = self.totalCashProfit;
        copy.totalScoreProfit = self.totalScoreProfit;
        copy.posiBoList = [self.posiBoList copyWithZone:zone];
    }
    
    return copy;
}


@end
