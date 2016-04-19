//
//  ELBaseClass.m
//
//  Created by   on 15/7/9
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "ELBaseClass.h"
#import "ELData.h"


NSString *const kELBaseClassCode = @"code";
NSString *const kELBaseClassData = @"data";
NSString *const kELBaseClassMsg = @"msg";
NSString *const kELBaseClassErrparam = @"errparam";


@interface ELBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ELBaseClass

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
            self.code = [[self objectOrNilForKey:kELBaseClassCode fromDictionary:dict] doubleValue];
    NSObject *receivedELData = [dict objectForKey:kELBaseClassData];
    NSMutableArray *parsedELData = [NSMutableArray array];
    if ([receivedELData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedELData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedELData addObject:[ELData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedELData isKindOfClass:[NSDictionary class]]) {
       [parsedELData addObject:[ELData modelObjectWithDictionary:(NSDictionary *)receivedELData]];
    }

    self.data = [NSArray arrayWithArray:parsedELData];
            self.msg = [self objectOrNilForKey:kELBaseClassMsg fromDictionary:dict];
            self.errparam = [self objectOrNilForKey:kELBaseClassErrparam fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kELBaseClassCode];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kELBaseClassData];
    [mutableDict setValue:self.msg forKey:kELBaseClassMsg];
    [mutableDict setValue:self.errparam forKey:kELBaseClassErrparam];

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

    self.code = [aDecoder decodeDoubleForKey:kELBaseClassCode];
    self.data = [aDecoder decodeObjectForKey:kELBaseClassData];
    self.msg = [aDecoder decodeObjectForKey:kELBaseClassMsg];
    self.errparam = [aDecoder decodeObjectForKey:kELBaseClassErrparam];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kELBaseClassCode];
    [aCoder encodeObject:_data forKey:kELBaseClassData];
    [aCoder encodeObject:_msg forKey:kELBaseClassMsg];
    [aCoder encodeObject:_errparam forKey:kELBaseClassErrparam];
}

- (id)copyWithZone:(NSZone *)zone
{
    ELBaseClass *copy = [[ELBaseClass alloc] init];
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.errparam = [self.errparam copyWithZone:zone];
    }
    
    return copy;
}


@end
