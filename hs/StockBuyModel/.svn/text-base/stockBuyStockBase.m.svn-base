//
//  stockBuyStockBase.m
//
//  Created by   on 15/5/7
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "stockBuyStockBase.h"
#import "stockBuyData.h"


NSString *const kstockBuyStockBaseData = @"data";


@interface stockBuyStockBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation stockBuyStockBase

@synthesize data = _data;


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
    NSObject *receivedstockBuyData = [dict objectForKey:kstockBuyStockBaseData];
    NSMutableArray *parsedstockBuyData = [NSMutableArray array];
    if ([receivedstockBuyData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedstockBuyData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedstockBuyData addObject:[stockBuyData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedstockBuyData isKindOfClass:[NSDictionary class]]) {
       [parsedstockBuyData addObject:[stockBuyData modelObjectWithDictionary:(NSDictionary *)receivedstockBuyData]];
    }

    self.data = [NSArray arrayWithArray:parsedstockBuyData];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kstockBuyStockBaseData];

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

    self.data = [aDecoder decodeObjectForKey:kstockBuyStockBaseData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_data forKey:kstockBuyStockBaseData];
}

- (id)copyWithZone:(NSZone *)zone
{
    stockBuyStockBase *copy = [[stockBuyStockBase alloc] init];
    
    if (copy) {

        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
