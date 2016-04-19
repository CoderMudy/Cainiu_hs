//
//  IndexPositionBaseClass.m
//
//  Created by   on 15/7/29
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "IndexPositionBaseClass.h"
#import "IndexPositionData.h"


NSString *const kIndexPositionBaseClassCode = @"code";
NSString *const kIndexPositionBaseClassData = @"data";
NSString *const kIndexPositionBaseClassMsg = @"msg";
NSString *const kIndexPositionBaseClassErrparam = @"errparam";


@interface IndexPositionBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation IndexPositionBaseClass

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
            self.code = [[self objectOrNilForKey:kIndexPositionBaseClassCode fromDictionary:dict] doubleValue];
            self.data = [IndexPositionData modelObjectWithDictionary:[dict objectForKey:kIndexPositionBaseClassData]];
            self.msg = [self objectOrNilForKey:kIndexPositionBaseClassMsg fromDictionary:dict];
            self.errparam = [self objectOrNilForKey:kIndexPositionBaseClassErrparam fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kIndexPositionBaseClassCode];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kIndexPositionBaseClassData];
    [mutableDict setValue:self.msg forKey:kIndexPositionBaseClassMsg];
    [mutableDict setValue:self.errparam forKey:kIndexPositionBaseClassErrparam];

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

    self.code = [aDecoder decodeDoubleForKey:kIndexPositionBaseClassCode];
    self.data = [aDecoder decodeObjectForKey:kIndexPositionBaseClassData];
    self.msg = [aDecoder decodeObjectForKey:kIndexPositionBaseClassMsg];
    self.errparam = [aDecoder decodeObjectForKey:kIndexPositionBaseClassErrparam];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kIndexPositionBaseClassCode];
    [aCoder encodeObject:_data forKey:kIndexPositionBaseClassData];
    [aCoder encodeObject:_msg forKey:kIndexPositionBaseClassMsg];
    [aCoder encodeObject:_errparam forKey:kIndexPositionBaseClassErrparam];
}

- (id)copyWithZone:(NSZone *)zone
{
    IndexPositionBaseClass *copy = [[IndexPositionBaseClass alloc] init];
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.errparam = [self.errparam copyWithZone:zone];
    }
    
    return copy;
}


@end
