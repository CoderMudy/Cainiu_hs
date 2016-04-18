//
//  UserData.m
//
//  Created by   on 15/5/19
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "UserData.h"
#import "UserTokenInfo.h"
#import "UserUserInfo.h"
#import "UserFinancyInfo.h"


NSString *const kUserDataUserBankList = @"userBankList";
NSString *const kUserDataTokenInfo = @"tokenInfo";
NSString *const kUserDataUserInfo = @"userInfo";
NSString *const kUserDataFinancyInfo = @"financyInfo";


@interface UserData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation UserData

@synthesize userBankList = _userBankList;
@synthesize tokenInfo = _tokenInfo;
@synthesize userInfo = _userInfo;
@synthesize financyInfo = _financyInfo;


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
            self.userBankList = [self objectOrNilForKey:kUserDataUserBankList fromDictionary:dict];
            self.tokenInfo = [UserTokenInfo modelObjectWithDictionary:[dict objectForKey:kUserDataTokenInfo]];
            self.userInfo = [UserUserInfo modelObjectWithDictionary:[dict objectForKey:kUserDataUserInfo]];
            self.financyInfo = [UserFinancyInfo modelObjectWithDictionary:[dict objectForKey:kUserDataFinancyInfo]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForUserBankList = [NSMutableArray array];
    for (NSObject *subArrayObject in self.userBankList) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForUserBankList addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForUserBankList addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForUserBankList] forKey:kUserDataUserBankList];
    [mutableDict setValue:[self.tokenInfo dictionaryRepresentation] forKey:kUserDataTokenInfo];
    [mutableDict setValue:[self.userInfo dictionaryRepresentation] forKey:kUserDataUserInfo];
    [mutableDict setValue:[self.financyInfo dictionaryRepresentation] forKey:kUserDataFinancyInfo];

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

    self.userBankList = [aDecoder decodeObjectForKey:kUserDataUserBankList];
    self.tokenInfo = [aDecoder decodeObjectForKey:kUserDataTokenInfo];
    self.userInfo = [aDecoder decodeObjectForKey:kUserDataUserInfo];
    self.financyInfo = [aDecoder decodeObjectForKey:kUserDataFinancyInfo];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_userBankList forKey:kUserDataUserBankList];
    [aCoder encodeObject:_tokenInfo forKey:kUserDataTokenInfo];
    [aCoder encodeObject:_userInfo forKey:kUserDataUserInfo];
    [aCoder encodeObject:_financyInfo forKey:kUserDataFinancyInfo];
}

- (id)copyWithZone:(NSZone *)zone
{
    UserData *copy = [[UserData alloc] init];
    
    if (copy) {

        copy.userBankList = [self.userBankList copyWithZone:zone];
        copy.tokenInfo = [self.tokenInfo copyWithZone:zone];
        copy.userInfo = [self.userInfo copyWithZone:zone];
        copy.financyInfo = [self.financyInfo copyWithZone:zone];
    }
    
    return copy;
}


@end
