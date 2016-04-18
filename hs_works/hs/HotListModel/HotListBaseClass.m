//
//  HotListBaseClass.m
//
//  Created by   on 15/5/7
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "HotListBaseClass.h"
#import "HotListData.h"


NSString *const kHotListBaseClassCode = @"code";
NSString *const kHotListBaseClassData = @"data";
NSString *const kHotListBaseClassMsg = @"msg";
NSString *const kHotListBaseClassErrparam = @"errparam";


@interface HotListBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HotListBaseClass

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
            self.code = [[self objectOrNilForKey:kHotListBaseClassCode fromDictionary:dict] doubleValue];
        
    NSObject *receivedHotListData = [dict objectForKey:kHotListBaseClassData];
        
    NSMutableArray *parsedHotListData = [NSMutableArray array];
    if ([receivedHotListData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedHotListData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedHotListData addObject:[HotListData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedHotListData isKindOfClass:[NSDictionary class]]) {
       [parsedHotListData addObject:[HotListData modelObjectWithDictionary:(NSDictionary *)receivedHotListData]];
    }

    self.data = [NSArray arrayWithArray:parsedHotListData];
            self.msg = [self objectOrNilForKey:kHotListBaseClassMsg fromDictionary:dict];
            self.errparam = [self objectOrNilForKey:kHotListBaseClassErrparam fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kHotListBaseClassCode];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kHotListBaseClassData];
    [mutableDict setValue:self.msg forKey:kHotListBaseClassMsg];
    [mutableDict setValue:self.errparam forKey:kHotListBaseClassErrparam];

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

    self.code = [aDecoder decodeDoubleForKey:kHotListBaseClassCode];
    self.data = [aDecoder decodeObjectForKey:kHotListBaseClassData];
    self.msg = [aDecoder decodeObjectForKey:kHotListBaseClassMsg];
    self.errparam = [aDecoder decodeObjectForKey:kHotListBaseClassErrparam];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kHotListBaseClassCode];
    [aCoder encodeObject:_data forKey:kHotListBaseClassData];
    [aCoder encodeObject:_msg forKey:kHotListBaseClassMsg];
    [aCoder encodeObject:_errparam forKey:kHotListBaseClassErrparam];
}

- (id)copyWithZone:(NSZone *)zone
{
    HotListBaseClass *copy = [[HotListBaseClass alloc] init];
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.errparam = [self.errparam copyWithZone:zone];
    }
    
    return copy;
}


@end
