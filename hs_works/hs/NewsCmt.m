//
//  NewsCmt.m
//
//  Created by   on 16/3/29
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "NewsCmt.h"


NSString *const kNewsCmtNewsId = @"newsId";
NSString *const kNewsCmtContent = @"content";
NSString *const kNewsCmtUserId = @"userId";
NSString *const kNewsCmtId = @"id";
NSString *const kNewsCmtUserNick = @"userNick";
NSString *const kNewsCmtUserHead = @"userHead";
NSString *const kNewsCmtNewsName = @"newsName";
NSString *const kNewsCmtCreateDate = @"createDate";


@interface NewsCmt ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation NewsCmt

@synthesize newsId = _newsId;
@synthesize content = _content;
@synthesize userId = _userId;
@synthesize cmtIdentifier = _cmtIdentifier;
@synthesize userNick = _userNick;
@synthesize userHead = _userHead;
@synthesize newsName = _newsName;
@synthesize createDate = _createDate;


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
            self.newsId = [[self objectOrNilForKey:kNewsCmtNewsId fromDictionary:dict] intValue];
            self.content = [self objectOrNilForKey:kNewsCmtContent fromDictionary:dict];
            self.userId = [[self objectOrNilForKey:kNewsCmtUserId fromDictionary:dict] intValue];
            self.cmtIdentifier = [[self objectOrNilForKey:kNewsCmtId fromDictionary:dict] intValue];
            self.userNick = [self objectOrNilForKey:kNewsCmtUserNick fromDictionary:dict];
            self.userHead = [self objectOrNilForKey:kNewsCmtUserHead fromDictionary:dict];
            self.newsName = [self objectOrNilForKey:kNewsCmtNewsName fromDictionary:dict];
            self.createDate = [self objectOrNilForKey:kNewsCmtCreateDate fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithInt:self.newsId] forKey:kNewsCmtNewsId];
    [mutableDict setValue:self.content forKey:kNewsCmtContent];
    [mutableDict setValue:[NSNumber numberWithInt:self.userId] forKey:kNewsCmtUserId];
    [mutableDict setValue:[NSNumber numberWithInt:self.cmtIdentifier] forKey:kNewsCmtId];
    [mutableDict setValue:self.userNick forKey:kNewsCmtUserNick];
    [mutableDict setValue:self.userHead forKey:kNewsCmtUserHead];
    [mutableDict setValue:self.newsName forKey:kNewsCmtNewsName];
    [mutableDict setValue:self.createDate forKey:kNewsCmtCreateDate];

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

    self.newsId = [aDecoder decodeIntForKey:kNewsCmtNewsId];
    self.content = [aDecoder decodeObjectForKey:kNewsCmtContent];
    self.userId = [aDecoder decodeIntForKey:kNewsCmtUserId];
    self.cmtIdentifier = [aDecoder decodeIntForKey:kNewsCmtId];
    self.userNick = [aDecoder decodeObjectForKey:kNewsCmtUserNick];
    self.userHead = [aDecoder decodeObjectForKey:kNewsCmtUserHead];
    self.newsName = [aDecoder decodeObjectForKey:kNewsCmtNewsName];
    self.createDate = [aDecoder decodeObjectForKey:kNewsCmtCreateDate];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeInt:_newsId forKey:kNewsCmtNewsId];
    [aCoder encodeObject:_content forKey:kNewsCmtContent];
    [aCoder encodeInt:_userId forKey:kNewsCmtUserId];
    [aCoder encodeInt:_cmtIdentifier forKey:kNewsCmtId];
    [aCoder encodeObject:_userNick forKey:kNewsCmtUserNick];
    [aCoder encodeObject:_userHead forKey:kNewsCmtUserHead];
    [aCoder encodeObject:_newsName forKey:kNewsCmtNewsName];
    [aCoder encodeObject:_createDate forKey:kNewsCmtCreateDate];
}

- (id)copyWithZone:(NSZone *)zone
{
    NewsCmt *copy = [[NewsCmt alloc] init];
    
    if (copy) {

        copy.newsId = self.newsId;
        copy.content = [self.content copyWithZone:zone];
        copy.userId = self.userId;
        copy.cmtIdentifier = self.cmtIdentifier;
        copy.userNick = [self.userNick copyWithZone:zone];
        copy.userHead = [self.userHead copyWithZone:zone];
        copy.newsName = [self.newsName copyWithZone:zone];
        copy.createDate = [self.createDate copyWithZone:zone];
    }
    
    return copy;
}


@end
