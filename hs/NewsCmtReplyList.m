//
//  NewsCmtReplyList.m
//
//  Created by   on 16/3/29
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "NewsCmtReplyList.h"
#import "NewsCmt.h"
#import "NewsReply.h"


NSString *const kNewsCmtReplyListCmt = @"cmt";
NSString *const kNewsCmtReplyListReply = @"reply";
NSString *const kNewsCmtReplyListIsOpen = @"isOpen";

@interface NewsCmtReplyList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation NewsCmtReplyList

@synthesize cmt = _cmt;
@synthesize reply = _reply;
@synthesize isOpen = _isOpen;


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
        self.isOpen = [[self objectOrNilForKey:kNewsCmtReplyListIsOpen fromDictionary:dict] doubleValue];
        self.cmt = [NewsCmt modelObjectWithDictionary:[dict objectForKey:kNewsCmtReplyListCmt]];
    NSObject *receivedNewsReply = [dict objectForKey:kNewsCmtReplyListReply];
    NSMutableArray *parsedNewsReply = [NSMutableArray array];
    if ([receivedNewsReply isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedNewsReply) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedNewsReply addObject:[NewsReply modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedNewsReply isKindOfClass:[NSDictionary class]]) {
       [parsedNewsReply addObject:[NewsReply modelObjectWithDictionary:(NSDictionary *)receivedNewsReply]];
    }

    self.reply = [NSArray arrayWithArray:parsedNewsReply];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.cmt dictionaryRepresentation] forKey:kNewsCmtReplyListCmt];
    [mutableDict setValue:[NSNumber numberWithBool:self.isOpen] forKey:kNewsCmtReplyListIsOpen];
    NSMutableArray *tempArrayForReply = [NSMutableArray array];
    for (NSObject *subArrayObject in self.reply) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForReply addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForReply addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForReply] forKey:kNewsCmtReplyListReply];

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

    self.cmt = [aDecoder decodeObjectForKey:kNewsCmtReplyListCmt];
    self.reply = [aDecoder decodeObjectForKey:kNewsCmtReplyListReply];
    self.isOpen = [aDecoder decodeObjectForKey:kNewsCmtReplyListIsOpen];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_cmt forKey:kNewsCmtReplyListCmt];
    [aCoder encodeObject:_reply forKey:kNewsCmtReplyListReply];
    [aCoder encodeBool:_isOpen forKey:kNewsCmtReplyListIsOpen];
}

- (id)copyWithZone:(NSZone *)zone
{
    NewsCmtReplyList *copy = [[NewsCmtReplyList alloc] init];
    
    if (copy) {

        copy.cmt = [self.cmt copyWithZone:zone];
        copy.reply = [self.reply copyWithZone:zone];
        copy.isOpen = self.isOpen;
    }
    
    return copy;
}


@end
