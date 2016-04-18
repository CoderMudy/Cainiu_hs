//
//  HotListData.m
//
//  Created by   on 15/5/7
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "HotListData.h"
#import "HotListOrders.h"


NSString *const kHotListDataNick = @"nick";
NSString *const kHotListDataOrders = @"orders";
NSString *const kHotListDataBenefit = @"benefit";


@interface HotListData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HotListData

@synthesize nick = _nick;
@synthesize orders = _orders;
@synthesize benefit = _benefit;


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
            self.nick = [self objectOrNilForKey:kHotListDataNick fromDictionary:dict];
    NSObject *receivedHotListOrders = [dict objectForKey:kHotListDataOrders];
    NSMutableArray *parsedHotListOrders = [NSMutableArray array];
    if ([receivedHotListOrders isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedHotListOrders) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedHotListOrders addObject:[HotListOrders modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedHotListOrders isKindOfClass:[NSDictionary class]]) {
       [parsedHotListOrders addObject:[HotListOrders modelObjectWithDictionary:(NSDictionary *)receivedHotListOrders]];
    }

    self.orders = [NSArray arrayWithArray:parsedHotListOrders];
            self.benefit = [self objectOrNilForKey:kHotListDataBenefit fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.nick forKey:kHotListDataNick];
    NSMutableArray *tempArrayForOrders = [NSMutableArray array];
    for (NSObject *subArrayObject in self.orders) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForOrders addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForOrders addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForOrders] forKey:kHotListDataOrders];
    [mutableDict setValue:self.benefit forKey:kHotListDataBenefit];

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

    self.nick = [aDecoder decodeObjectForKey:kHotListDataNick];
    self.orders = [aDecoder decodeObjectForKey:kHotListDataOrders];
    self.benefit = [aDecoder decodeObjectForKey:kHotListDataBenefit];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_nick forKey:kHotListDataNick];
    [aCoder encodeObject:_orders forKey:kHotListDataOrders];
    [aCoder encodeObject:_benefit forKey:kHotListDataBenefit];
}

- (id)copyWithZone:(NSZone *)zone
{
    HotListData *copy = [[HotListData alloc] init];
    
    if (copy) {

        copy.nick = [self.nick copyWithZone:zone];
        copy.orders = [self.orders copyWithZone:zone];
        copy.benefit = [self.benefit copyWithZone:zone];
    }
    
    return copy;
}


@end
