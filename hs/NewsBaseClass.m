//
//  NewsBaseClass.m
//
//  Created by   on 16/3/29
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "NewsBaseClass.h"
#import "NewsCmtReplyList.h"


NSString *const kNewsBaseClassCmtReplyList = @"cmtReplyList";
NSString *const kNewsBaseClassTotalCmt = @"totalCmt";


@interface NewsBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation NewsBaseClass

@synthesize cmtReplyList = _cmtReplyList;
@synthesize totalCmt = _totalCmt;


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
    NSObject *receivedNewsCmtReplyList = [dict objectForKey:kNewsBaseClassCmtReplyList];
    NSMutableArray *parsedNewsCmtReplyList = [NSMutableArray array];
    if ([receivedNewsCmtReplyList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedNewsCmtReplyList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedNewsCmtReplyList addObject:[NewsCmtReplyList modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedNewsCmtReplyList isKindOfClass:[NSDictionary class]]) {
       [parsedNewsCmtReplyList addObject:[NewsCmtReplyList modelObjectWithDictionary:(NSDictionary *)receivedNewsCmtReplyList]];
    }

    self.cmtReplyList = [NSArray arrayWithArray:parsedNewsCmtReplyList];
            self.totalCmt = [[self objectOrNilForKey:kNewsBaseClassTotalCmt fromDictionary:dict] intValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForCmtReplyList = [NSMutableArray array];
    for (NSObject *subArrayObject in self.cmtReplyList) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForCmtReplyList addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForCmtReplyList addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForCmtReplyList] forKey:kNewsBaseClassCmtReplyList];
    [mutableDict setValue:[NSNumber numberWithInt:self.totalCmt] forKey:kNewsBaseClassTotalCmt];

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

    self.cmtReplyList = [aDecoder decodeObjectForKey:kNewsBaseClassCmtReplyList];
    self.totalCmt = [aDecoder decodeDoubleForKey:kNewsBaseClassTotalCmt];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_cmtReplyList forKey:kNewsBaseClassCmtReplyList];
    [aCoder encodeInt:_totalCmt forKey:kNewsBaseClassTotalCmt];
}

- (id)copyWithZone:(NSZone *)zone
{
    NewsBaseClass *copy = [[NewsBaseClass alloc] init];
    
    if (copy) {

        copy.cmtReplyList = [self.cmtReplyList copyWithZone:zone];
        copy.totalCmt = self.totalCmt;
    }
    
    return copy;
}


@end
