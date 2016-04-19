//
//  OrderPriceData.m
//
//  Created by   on 15/5/27
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "OrderPriceData.h"


NSString *const kOrderPriceDataId = @"id";
NSString *const kOrderPriceDataScoreFundOption = @"scoreFundOption";
NSString *const kOrderPriceDataHighestFee = @"highestFee";
NSString *const kOrderPriceDataCounterFeeOption = @"counterFeeOption";
NSString *const kOrderPriceDataOpAmt = @"opAmt";
NSString *const kOrderPriceDataCashFundOption = @"cashFundOption";
NSString *const kOrderPriceDataOpScore = @"opScore";
NSString *const kOrderPriceDataLowestFee = @"lowestFee";
NSString *const kOrderPriceDataType = @"type";
NSString *const kOrderPriceDataHighestScore = @"highestScore";
NSString *const kOrderPriceDataDayFee = @"dayFee";
NSString *const kOrderPriceDataCounterScoreOption = @"counterScoreOption";
NSString *const kOrderPriceDataLowestScore = @"lowestScore";
NSString *const kOrderPriceDataDayScore = @"dayScore";
NSString *const kOrderPriceDataMaxLoss = @"maxLoss";


@interface OrderPriceData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OrderPriceData

@synthesize dataIdentifier = _dataIdentifier;
@synthesize scoreFundOption = _scoreFundOption;
@synthesize highestFee = _highestFee;
@synthesize counterFeeOption = _counterFeeOption;
@synthesize opAmt = _opAmt;
@synthesize cashFundOption = _cashFundOption;
@synthesize opScore = _opScore;
@synthesize lowestFee = _lowestFee;
@synthesize type = _type;
@synthesize highestScore = _highestScore;
@synthesize dayFee = _dayFee;
@synthesize counterScoreOption = _counterScoreOption;
@synthesize lowestScore = _lowestScore;
@synthesize dayScore = _dayScore;
@synthesize maxLoss = _maxLoss;


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
            self.dataIdentifier = [[self objectOrNilForKey:kOrderPriceDataId fromDictionary:dict] doubleValue];
            self.scoreFundOption = [self objectOrNilForKey:kOrderPriceDataScoreFundOption fromDictionary:dict];
            self.highestFee = [[self objectOrNilForKey:kOrderPriceDataHighestFee fromDictionary:dict] doubleValue];
            self.counterFeeOption = [self objectOrNilForKey:kOrderPriceDataCounterFeeOption fromDictionary:dict];
            self.opAmt = [[self objectOrNilForKey:kOrderPriceDataOpAmt fromDictionary:dict] doubleValue];
            self.cashFundOption = [self objectOrNilForKey:kOrderPriceDataCashFundOption fromDictionary:dict];
            self.opScore = [[self objectOrNilForKey:kOrderPriceDataOpScore fromDictionary:dict] doubleValue];
            self.lowestFee = [[self objectOrNilForKey:kOrderPriceDataLowestFee fromDictionary:dict] doubleValue];
            self.type = [[self objectOrNilForKey:kOrderPriceDataType fromDictionary:dict] doubleValue];
            self.highestScore = [[self objectOrNilForKey:kOrderPriceDataHighestScore fromDictionary:dict] doubleValue];
            self.dayFee = [[self objectOrNilForKey:kOrderPriceDataDayFee fromDictionary:dict] doubleValue];
            self.counterScoreOption = [self objectOrNilForKey:kOrderPriceDataCounterScoreOption fromDictionary:dict];
            self.lowestScore = [[self objectOrNilForKey:kOrderPriceDataLowestScore fromDictionary:dict] doubleValue];
            self.dayScore = [[self objectOrNilForKey:kOrderPriceDataDayScore fromDictionary:dict] doubleValue];
            self.maxLoss = [self objectOrNilForKey:kOrderPriceDataMaxLoss fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kOrderPriceDataId];
    [mutableDict setValue:self.scoreFundOption forKey:kOrderPriceDataScoreFundOption];
    [mutableDict setValue:[NSNumber numberWithDouble:self.highestFee] forKey:kOrderPriceDataHighestFee];
    [mutableDict setValue:self.counterFeeOption forKey:kOrderPriceDataCounterFeeOption];
    [mutableDict setValue:[NSNumber numberWithDouble:self.opAmt] forKey:kOrderPriceDataOpAmt];
    [mutableDict setValue:self.cashFundOption forKey:kOrderPriceDataCashFundOption];
    [mutableDict setValue:[NSNumber numberWithDouble:self.opScore] forKey:kOrderPriceDataOpScore];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lowestFee] forKey:kOrderPriceDataLowestFee];
    [mutableDict setValue:[NSNumber numberWithDouble:self.type] forKey:kOrderPriceDataType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.highestScore] forKey:kOrderPriceDataHighestScore];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dayFee] forKey:kOrderPriceDataDayFee];
    [mutableDict setValue:self.counterScoreOption forKey:kOrderPriceDataCounterScoreOption];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lowestScore] forKey:kOrderPriceDataLowestScore];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dayScore] forKey:kOrderPriceDataDayScore];
    [mutableDict setValue:self.maxLoss forKey:kOrderPriceDataMaxLoss];

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

    self.dataIdentifier = [aDecoder decodeDoubleForKey:kOrderPriceDataId];
    self.scoreFundOption = [aDecoder decodeObjectForKey:kOrderPriceDataScoreFundOption];
    self.highestFee = [aDecoder decodeDoubleForKey:kOrderPriceDataHighestFee];
    self.counterFeeOption = [aDecoder decodeObjectForKey:kOrderPriceDataCounterFeeOption];
    self.opAmt = [aDecoder decodeDoubleForKey:kOrderPriceDataOpAmt];
    self.cashFundOption = [aDecoder decodeObjectForKey:kOrderPriceDataCashFundOption];
    self.opScore = [aDecoder decodeDoubleForKey:kOrderPriceDataOpScore];
    self.lowestFee = [aDecoder decodeDoubleForKey:kOrderPriceDataLowestFee];
    self.type = [aDecoder decodeDoubleForKey:kOrderPriceDataType];
    self.highestScore = [aDecoder decodeDoubleForKey:kOrderPriceDataHighestScore];
    self.dayFee = [aDecoder decodeDoubleForKey:kOrderPriceDataDayFee];
    self.counterScoreOption = [aDecoder decodeObjectForKey:kOrderPriceDataCounterScoreOption];
    self.lowestScore = [aDecoder decodeDoubleForKey:kOrderPriceDataLowestScore];
    self.dayScore = [aDecoder decodeDoubleForKey:kOrderPriceDataDayScore];
    self.maxLoss = [aDecoder decodeObjectForKey:kOrderPriceDataMaxLoss];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_dataIdentifier forKey:kOrderPriceDataId];
    [aCoder encodeObject:_scoreFundOption forKey:kOrderPriceDataScoreFundOption];
    [aCoder encodeDouble:_highestFee forKey:kOrderPriceDataHighestFee];
    [aCoder encodeObject:_counterFeeOption forKey:kOrderPriceDataCounterFeeOption];
    [aCoder encodeDouble:_opAmt forKey:kOrderPriceDataOpAmt];
    [aCoder encodeObject:_cashFundOption forKey:kOrderPriceDataCashFundOption];
    [aCoder encodeDouble:_opScore forKey:kOrderPriceDataOpScore];
    [aCoder encodeDouble:_lowestFee forKey:kOrderPriceDataLowestFee];
    [aCoder encodeDouble:_type forKey:kOrderPriceDataType];
    [aCoder encodeDouble:_highestScore forKey:kOrderPriceDataHighestScore];
    [aCoder encodeDouble:_dayFee forKey:kOrderPriceDataDayFee];
    [aCoder encodeObject:_counterScoreOption forKey:kOrderPriceDataCounterScoreOption];
    [aCoder encodeDouble:_lowestScore forKey:kOrderPriceDataLowestScore];
    [aCoder encodeDouble:_dayScore forKey:kOrderPriceDataDayScore];
    [aCoder encodeObject:_maxLoss forKey:kOrderPriceDataMaxLoss];
}

- (id)copyWithZone:(NSZone *)zone
{
    OrderPriceData *copy = [[OrderPriceData alloc] init];
    
    if (copy) {

        copy.dataIdentifier = self.dataIdentifier;
        copy.scoreFundOption = [self.scoreFundOption copyWithZone:zone];
        copy.highestFee = self.highestFee;
        copy.counterFeeOption = [self.counterFeeOption copyWithZone:zone];
        copy.opAmt = self.opAmt;
        copy.cashFundOption = [self.cashFundOption copyWithZone:zone];
        copy.opScore = self.opScore;
        copy.lowestFee = self.lowestFee;
        copy.type = self.type;
        copy.highestScore = self.highestScore;
        copy.dayFee = self.dayFee;
        copy.counterScoreOption = [self.counterScoreOption copyWithZone:zone];
        copy.lowestScore = self.lowestScore;
        copy.dayScore = self.dayScore;
        copy.maxLoss = [self.maxLoss copyWithZone:zone];
    }
    
    return copy;
}


@end
