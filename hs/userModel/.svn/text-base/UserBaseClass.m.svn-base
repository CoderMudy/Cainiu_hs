//
//  UserBaseClass.m
//
//  Created by   on 15/5/19
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "UserBaseClass.h"
#import "UserData.h"


NSString *const kUserBaseClassCode = @"code";
NSString *const kUserBaseClassData = @"data";
NSString *const kUserBaseClassMsg = @"msg";
NSString *const kUserBaseClassErrparam = @"errparam";


@interface UserBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation UserBaseClass

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
            self.code = [[self objectOrNilForKey:kUserBaseClassCode fromDictionary:dict] doubleValue];
            self.data = [UserData modelObjectWithDictionary:[dict objectForKey:kUserBaseClassData]];
            self.msg = [self objectOrNilForKey:kUserBaseClassMsg fromDictionary:dict];
            self.errparam = [self objectOrNilForKey:kUserBaseClassErrparam fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kUserBaseClassCode];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kUserBaseClassData];
    [mutableDict setValue:self.msg forKey:kUserBaseClassMsg];
    [mutableDict setValue:self.errparam forKey:kUserBaseClassErrparam];

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

    self.code = [aDecoder decodeDoubleForKey:kUserBaseClassCode];
    self.data = [aDecoder decodeObjectForKey:kUserBaseClassData];
    self.msg = [aDecoder decodeObjectForKey:kUserBaseClassMsg];
    self.errparam = [aDecoder decodeObjectForKey:kUserBaseClassErrparam];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kUserBaseClassCode];
    [aCoder encodeObject:_data forKey:kUserBaseClassData];
    [aCoder encodeObject:_msg forKey:kUserBaseClassMsg];
    [aCoder encodeObject:_errparam forKey:kUserBaseClassErrparam];
}

- (id)copyWithZone:(NSZone *)zone
{
    UserBaseClass *copy = [[UserBaseClass alloc] init];
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.errparam = [self.errparam copyWithZone:zone];
    }
    
    return copy;
}


@end
