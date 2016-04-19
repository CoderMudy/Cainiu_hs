//
//  UserTokenInfo.m
//
//  Created by   on 15/5/19
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "UserTokenInfo.h"


NSString *const kUserTokenInfoUserSecret = @"userSecret";
NSString *const kUserTokenInfoIsdeline = @"isdeline";
NSString *const kUserTokenInfoUserId = @"userId";
NSString *const kUserTokenInfoToken = @"token";


@interface UserTokenInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation UserTokenInfo

@synthesize userSecret = _userSecret;
@synthesize isdeline = _isdeline;
@synthesize userId = _userId;
@synthesize token = _token;


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
            self.userSecret = [self objectOrNilForKey:kUserTokenInfoUserSecret fromDictionary:dict];
            self.isdeline = [[self objectOrNilForKey:kUserTokenInfoIsdeline fromDictionary:dict] boolValue];
            self.userId = [self objectOrNilForKey:kUserTokenInfoUserId fromDictionary:dict];
            self.token = [self objectOrNilForKey:kUserTokenInfoToken fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.userSecret forKey:kUserTokenInfoUserSecret];
    [mutableDict setValue:[NSNumber numberWithBool:self.isdeline] forKey:kUserTokenInfoIsdeline];
    [mutableDict setValue:self.userId forKey:kUserTokenInfoUserId];
    [mutableDict setValue:self.token forKey:kUserTokenInfoToken];

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

    self.userSecret = [aDecoder decodeObjectForKey:kUserTokenInfoUserSecret];
    self.isdeline = [aDecoder decodeBoolForKey:kUserTokenInfoIsdeline];
    self.userId = [aDecoder decodeObjectForKey:kUserTokenInfoUserId];
    self.token = [aDecoder decodeObjectForKey:kUserTokenInfoToken];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_userSecret forKey:kUserTokenInfoUserSecret];
    [aCoder encodeBool:_isdeline forKey:kUserTokenInfoIsdeline];
    [aCoder encodeObject:_userId forKey:kUserTokenInfoUserId];
    [aCoder encodeObject:_token forKey:kUserTokenInfoToken];
}

- (id)copyWithZone:(NSZone *)zone
{
    UserTokenInfo *copy = [[UserTokenInfo alloc] init];
    
    if (copy) {

        copy.userSecret = [self.userSecret copyWithZone:zone];
        copy.isdeline = self.isdeline;
        copy.userId = [self.userId copyWithZone:zone];
        copy.token = [self.token copyWithZone:zone];
    }
    
    return copy;
}


@end
