//
//  UserUserInfo.m
//
//  Created by   on 15/5/19
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "UserUserInfo.h"

NSString *const KUserUserInfoIsStaff = @"is_staff";
NSString *const kUserUserInfoUserCls = @"user_cls";
NSString *const kUserUserInfoTele = @"tele";
NSString *const kUserUserInfoHeadPic = @"head_pic";
NSString *const kUserUserInfoSex = @"sex";
NSString *const kUserUserInfoBirth = @"birth";
NSString *const kUserUserInfoNick = @"nick";
NSString *const kUserUserInfoProvice = @"provice";
NSString *const kUserUserInfoPersonSign = @"person_sign";
NSString *const kUserUserInfoAddress = @"address";
NSString *const kUserUserInfoRegDate = @"reg_date";
NSString *const kUserUserInfoCity = @"city";
NSString *const kUserUserInfoRegion = @"region";
NSString *const kUserUserInfoName = @"name";


@interface UserUserInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation UserUserInfo

@synthesize isStaff = _isStaff;
@synthesize userCls = _userCls;
@synthesize tele = _tele;
@synthesize headPic = _headPic;
@synthesize sex = _sex;
@synthesize birth = _birth;
@synthesize nick = _nick;
@synthesize provice = _provice;
@synthesize personSign = _personSign;
@synthesize address = _address;
@synthesize regDate = _regDate;
@synthesize city = _city;
@synthesize region = _region;
@synthesize name = _name;


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
        self.isStaff = [[self objectOrNilForKey:KUserUserInfoIsStaff fromDictionary:dict]intValue];
            self.userCls = [self objectOrNilForKey:kUserUserInfoUserCls fromDictionary:dict];
            self.tele = [self objectOrNilForKey:kUserUserInfoTele fromDictionary:dict];
            self.headPic = [self objectOrNilForKey:kUserUserInfoHeadPic fromDictionary:dict];
            self.sex = [self objectOrNilForKey:kUserUserInfoSex fromDictionary:dict];
            self.birth = [self objectOrNilForKey:kUserUserInfoBirth fromDictionary:dict];
            self.nick = [self objectOrNilForKey:kUserUserInfoNick fromDictionary:dict];
            self.provice = [self objectOrNilForKey:kUserUserInfoProvice fromDictionary:dict];
            self.personSign = [self objectOrNilForKey:kUserUserInfoPersonSign fromDictionary:dict];
            self.address = [self objectOrNilForKey:kUserUserInfoAddress fromDictionary:dict];
            self.regDate = [self objectOrNilForKey:kUserUserInfoRegDate fromDictionary:dict];
            self.city = [self objectOrNilForKey:kUserUserInfoCity fromDictionary:dict];
            self.region = [self objectOrNilForKey:kUserUserInfoRegion fromDictionary:dict];
            self.name = [self objectOrNilForKey:kUserUserInfoName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithInt:self.isStaff] forKey:KUserUserInfoIsStaff];
    [mutableDict setValue:self.userCls forKey:kUserUserInfoUserCls];
    [mutableDict setValue:self.tele forKey:kUserUserInfoTele];
    [mutableDict setValue:self.headPic forKey:kUserUserInfoHeadPic];
    [mutableDict setValue:self.sex forKey:kUserUserInfoSex];
    [mutableDict setValue:self.birth forKey:kUserUserInfoBirth];
    [mutableDict setValue:self.nick forKey:kUserUserInfoNick];
    [mutableDict setValue:self.provice forKey:kUserUserInfoProvice];
    [mutableDict setValue:self.personSign forKey:kUserUserInfoPersonSign];
    [mutableDict setValue:self.address forKey:kUserUserInfoAddress];
    [mutableDict setValue:self.regDate forKey:kUserUserInfoRegDate];
    [mutableDict setValue:self.city forKey:kUserUserInfoCity];
    [mutableDict setValue:self.region forKey:kUserUserInfoRegion];
    [mutableDict setValue:self.name forKey:kUserUserInfoName];

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

    self.isStaff = [aDecoder decodeIntForKey:KUserUserInfoIsStaff];
    self.userCls = [aDecoder decodeObjectForKey:kUserUserInfoUserCls];
    self.tele = [aDecoder decodeObjectForKey:kUserUserInfoTele];
    self.headPic = [aDecoder decodeObjectForKey:kUserUserInfoHeadPic];
    self.sex = [aDecoder decodeObjectForKey:kUserUserInfoSex];
    self.birth = [aDecoder decodeObjectForKey:kUserUserInfoBirth];
    self.nick = [aDecoder decodeObjectForKey:kUserUserInfoNick];
    self.provice = [aDecoder decodeObjectForKey:kUserUserInfoProvice];
    self.personSign = [aDecoder decodeObjectForKey:kUserUserInfoPersonSign];
    self.address = [aDecoder decodeObjectForKey:kUserUserInfoAddress];
    self.regDate = [aDecoder decodeObjectForKey:kUserUserInfoRegDate];
    self.city = [aDecoder decodeObjectForKey:kUserUserInfoCity];
    self.region = [aDecoder decodeObjectForKey:kUserUserInfoRegion];
    self.name = [aDecoder decodeObjectForKey:kUserUserInfoName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeInt:_isStaff forKey:KUserUserInfoIsStaff];
    [aCoder encodeObject:_userCls forKey:kUserUserInfoUserCls];
    [aCoder encodeObject:_tele forKey:kUserUserInfoTele];
    [aCoder encodeObject:_headPic forKey:kUserUserInfoHeadPic];
    [aCoder encodeObject:_sex forKey:kUserUserInfoSex];
    [aCoder encodeObject:_birth forKey:kUserUserInfoBirth];
    [aCoder encodeObject:_nick forKey:kUserUserInfoNick];
    [aCoder encodeObject:_provice forKey:kUserUserInfoProvice];
    [aCoder encodeObject:_personSign forKey:kUserUserInfoPersonSign];
    [aCoder encodeObject:_address forKey:kUserUserInfoAddress];
    [aCoder encodeObject:_regDate forKey:kUserUserInfoRegDate];
    [aCoder encodeObject:_city forKey:kUserUserInfoCity];
    [aCoder encodeObject:_region forKey:kUserUserInfoRegion];
    [aCoder encodeObject:_name forKey:kUserUserInfoName];
}

- (id)copyWithZone:(NSZone *)zone
{
    UserUserInfo *copy = [[UserUserInfo alloc] init];
    
    if (copy) {
        copy.isStaff = self.isStaff;
        copy.userCls = [self.userCls copyWithZone:zone];
        copy.tele = [self.tele copyWithZone:zone];
        copy.headPic = [self.headPic copyWithZone:zone];
        copy.sex = [self.sex copyWithZone:zone];
        copy.birth = [self.birth copyWithZone:zone];
        copy.nick = [self.nick copyWithZone:zone];
        copy.provice = [self.provice copyWithZone:zone];
        copy.personSign = [self.personSign copyWithZone:zone];
        copy.address = [self.address copyWithZone:zone];
        copy.regDate = [self.regDate copyWithZone:zone];
        copy.city = [self.city copyWithZone:zone];
        copy.region = [self.region copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
