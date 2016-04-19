//
//  OrderPriceBaseClass.m
//
//  Created by   on 15/5/27
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "OrderPriceBaseClass.h"
#import "OrderPriceData.h"


NSString *const kOrderPriceBaseClassCode = @"code";
NSString *const kOrderPriceBaseClassData = @"data";
NSString *const kOrderPriceBaseClassMsg = @"msg";
NSString *const kOrderPriceBaseClassErrparam = @"errparam";


@interface OrderPriceBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OrderPriceBaseClass

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
            self.code = [[self objectOrNilForKey:kOrderPriceBaseClassCode fromDictionary:dict] doubleValue];
    NSObject *receivedOrderPriceData = [dict objectForKey:kOrderPriceBaseClassData];
    NSMutableArray *parsedOrderPriceData = [NSMutableArray array];
    if ([receivedOrderPriceData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedOrderPriceData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedOrderPriceData addObject:[OrderPriceData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedOrderPriceData isKindOfClass:[NSDictionary class]]) {
       [parsedOrderPriceData addObject:[OrderPriceData modelObjectWithDictionary:(NSDictionary *)receivedOrderPriceData]];
    }

    self.data = [NSArray arrayWithArray:parsedOrderPriceData];
            self.msg = [self objectOrNilForKey:kOrderPriceBaseClassMsg fromDictionary:dict];
            self.errparam = [self objectOrNilForKey:kOrderPriceBaseClassErrparam fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kOrderPriceBaseClassCode];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kOrderPriceBaseClassData];
    [mutableDict setValue:self.msg forKey:kOrderPriceBaseClassMsg];
    [mutableDict setValue:self.errparam forKey:kOrderPriceBaseClassErrparam];

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

    self.code = [aDecoder decodeDoubleForKey:kOrderPriceBaseClassCode];
    self.data = [aDecoder decodeObjectForKey:kOrderPriceBaseClassData];
    self.msg = [aDecoder decodeObjectForKey:kOrderPriceBaseClassMsg];
    self.errparam = [aDecoder decodeObjectForKey:kOrderPriceBaseClassErrparam];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kOrderPriceBaseClassCode];
    [aCoder encodeObject:_data forKey:kOrderPriceBaseClassData];
    [aCoder encodeObject:_msg forKey:kOrderPriceBaseClassMsg];
    [aCoder encodeObject:_errparam forKey:kOrderPriceBaseClassErrparam];
}

- (id)copyWithZone:(NSZone *)zone
{
    OrderPriceBaseClass *copy = [[OrderPriceBaseClass alloc] init];
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.errparam = [self.errparam copyWithZone:zone];
    }
    
    return copy;
}


@end
