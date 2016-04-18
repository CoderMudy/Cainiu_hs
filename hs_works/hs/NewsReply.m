//
//  NewsReply.m
//
//  Created by   on 16/3/29
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "NewsReply.h"


NSString *const kNewsReplyNewsId = @"newsId";
NSString *const kNewsReplyReplyUserId = @"replyUserId";
NSString *const kNewsReplyReplyUserHead = @"replyUserHead";
NSString *const kNewsReplyId = @"id";
NSString *const kNewsReplyReplyUserNick = @"replyUserNick";
NSString *const kNewsReplyReplyContent = @"replyContent";
NSString *const kNewsReplyNewsName = @"newsName";
NSString *const kNewsReplyUpUserNick = @"upUserNick";
NSString *const kNewsReplyCreateDate = @"createDate";
NSString *const kNewsReplyCmtId = @"cmtId";
NSString *const kNewsReplyReplyId = @"replyId";


@interface NewsReply ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation NewsReply

@synthesize newsId = _newsId;
@synthesize replyUserId = _replyUserId;
@synthesize replyUserHead = _replyUserHead;
@synthesize replyIdentifier = _replyIdentifier;
@synthesize replyUserNick = _replyUserNick;
@synthesize replyContent = _replyContent;
@synthesize newsName = _newsName;
@synthesize upUserNick = _upUserNick;
@synthesize createDate = _createDate;
@synthesize cmtId = _cmtId;
@synthesize replyId = _replyId;


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
            self.newsId = [[self objectOrNilForKey:kNewsReplyNewsId fromDictionary:dict] intValue];
            self.replyUserId = [[self objectOrNilForKey:kNewsReplyReplyUserId fromDictionary:dict] intValue];
            self.replyUserHead = [self objectOrNilForKey:kNewsReplyReplyUserHead fromDictionary:dict];
            self.replyIdentifier = [[self objectOrNilForKey:kNewsReplyId fromDictionary:dict] intValue];
            self.replyUserNick = [self objectOrNilForKey:kNewsReplyReplyUserNick fromDictionary:dict];
            self.replyContent = [self objectOrNilForKey:kNewsReplyReplyContent fromDictionary:dict];
            self.newsName = [self objectOrNilForKey:kNewsReplyNewsName fromDictionary:dict];
            self.upUserNick = [self objectOrNilForKey:kNewsReplyUpUserNick fromDictionary:dict];
            self.createDate = [self objectOrNilForKey:kNewsReplyCreateDate fromDictionary:dict];
            self.cmtId = [[self objectOrNilForKey:kNewsReplyCmtId fromDictionary:dict] intValue];
            self.replyId = [[self objectOrNilForKey:kNewsReplyReplyId fromDictionary:dict] intValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithInt:self.newsId] forKey:kNewsReplyNewsId];
    [mutableDict setValue:[NSNumber numberWithInt:self.replyUserId] forKey:kNewsReplyReplyUserId];
    [mutableDict setValue:self.replyUserHead forKey:kNewsReplyReplyUserHead];
    [mutableDict setValue:[NSNumber numberWithInt:self.replyIdentifier] forKey:kNewsReplyId];
    [mutableDict setValue:self.replyUserNick forKey:kNewsReplyReplyUserNick];
    [mutableDict setValue:self.replyContent forKey:kNewsReplyReplyContent];
    [mutableDict setValue:self.newsName forKey:kNewsReplyNewsName];
    [mutableDict setValue:self.upUserNick forKey:kNewsReplyUpUserNick];
    [mutableDict setValue:self.createDate forKey:kNewsReplyCreateDate];
    [mutableDict setValue:[NSNumber numberWithInt:self.cmtId] forKey:kNewsReplyCmtId];
    [mutableDict setValue:[NSNumber numberWithInt:self.replyId] forKey:kNewsReplyReplyId];

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

    self.newsId = [aDecoder decodeIntForKey:kNewsReplyNewsId];
    self.replyUserId = [aDecoder decodeIntForKey:kNewsReplyReplyUserId];
    self.replyUserHead = [aDecoder decodeObjectForKey:kNewsReplyReplyUserHead];
    self.replyIdentifier = [aDecoder decodeIntForKey:kNewsReplyId];
    self.replyUserNick = [aDecoder decodeObjectForKey:kNewsReplyReplyUserNick];
    self.replyContent = [aDecoder decodeObjectForKey:kNewsReplyReplyContent];
    self.newsName = [aDecoder decodeObjectForKey:kNewsReplyNewsName];
    self.upUserNick = [aDecoder decodeObjectForKey:kNewsReplyUpUserNick];
    self.createDate = [aDecoder decodeObjectForKey:kNewsReplyCreateDate];
    self.cmtId = [aDecoder decodeIntForKey:kNewsReplyCmtId];
    self.replyId = [aDecoder decodeIntForKey:kNewsReplyReplyId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeInt:_newsId forKey:kNewsReplyNewsId];
    [aCoder encodeInt:_replyUserId forKey:kNewsReplyReplyUserId];
    [aCoder encodeObject:_replyUserHead forKey:kNewsReplyReplyUserHead];
    [aCoder encodeInt:_replyIdentifier forKey:kNewsReplyId];
    [aCoder encodeObject:_replyUserNick forKey:kNewsReplyReplyUserNick];
    [aCoder encodeObject:_replyContent forKey:kNewsReplyReplyContent];
    [aCoder encodeObject:_newsName forKey:kNewsReplyNewsName];
    [aCoder encodeObject:_upUserNick forKey:kNewsReplyUpUserNick];
    [aCoder encodeObject:_createDate forKey:kNewsReplyCreateDate];
    [aCoder encodeInt:_cmtId forKey:kNewsReplyCmtId];
    [aCoder encodeInt:_replyId forKey:kNewsReplyReplyId];
}

- (id)copyWithZone:(NSZone *)zone
{
    NewsReply *copy = [[NewsReply alloc] init];
    
    if (copy) {

        copy.newsId = self.newsId;
        copy.replyUserId = self.replyUserId;
        copy.replyUserHead = [self.replyUserHead copyWithZone:zone];
        copy.replyIdentifier = self.replyIdentifier;
        copy.replyUserNick = [self.replyUserNick copyWithZone:zone];
        copy.replyContent = [self.replyContent copyWithZone:zone];
        copy.newsName = [self.newsName copyWithZone:zone];
        copy.upUserNick = [self.upUserNick copyWithZone:zone];
        copy.createDate = [self.createDate copyWithZone:zone];
        copy.cmtId = self.cmtId;
        copy.replyId = self.replyId;
    }
    
    return copy;
}


@end
