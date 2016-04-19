//
//  PersonPositionBaseClass.m
//
//  Created by   on 15/5/10
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "PersonPositionBaseClass.h"
#import "PersonPositionData.h"


NSString *const kPersonPositionBaseClassCode = @"code";
NSString *const kPersonPositionBaseClassData = @"data";
NSString *const kPersonPositionBaseClassMsg = @"msg";
NSString *const kPersonPositionBaseClassErrparam = @"errparam";


@interface PersonPositionBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PersonPositionBaseClass

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
            self.code = [[self objectOrNilForKey:kPersonPositionBaseClassCode fromDictionary:dict] doubleValue];
            self.data = [PersonPositionData modelObjectWithDictionary:[dict objectForKey:kPersonPositionBaseClassData]];
            self.msg = [self objectOrNilForKey:kPersonPositionBaseClassMsg fromDictionary:dict];
            self.errparam = [self objectOrNilForKey:kPersonPositionBaseClassErrparam fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kPersonPositionBaseClassCode];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kPersonPositionBaseClassData];
    [mutableDict setValue:self.msg forKey:kPersonPositionBaseClassMsg];
    [mutableDict setValue:self.errparam forKey:kPersonPositionBaseClassErrparam];

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

    self.code = [aDecoder decodeDoubleForKey:kPersonPositionBaseClassCode];
    self.data = [aDecoder decodeObjectForKey:kPersonPositionBaseClassData];
    self.msg = [aDecoder decodeObjectForKey:kPersonPositionBaseClassMsg];
    self.errparam = [aDecoder decodeObjectForKey:kPersonPositionBaseClassErrparam];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kPersonPositionBaseClassCode];
    [aCoder encodeObject:_data forKey:kPersonPositionBaseClassData];
    [aCoder encodeObject:_msg forKey:kPersonPositionBaseClassMsg];
    [aCoder encodeObject:_errparam forKey:kPersonPositionBaseClassErrparam];
}

- (id)copyWithZone:(NSZone *)zone
{
    PersonPositionBaseClass *copy = [[PersonPositionBaseClass alloc] init];
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.errparam = [self.errparam copyWithZone:zone];
    }
    
    return copy;
}


@end
