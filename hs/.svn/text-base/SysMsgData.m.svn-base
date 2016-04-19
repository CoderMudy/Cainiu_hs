//
//  SysMsgData.m
//
//  Created by   on 15/8/10
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "SysMsgData.h"


NSString *const kSysMsgDataId = @"id";
NSString *const kSysMsgDataTitle = @"title";
NSString *const kSysMsgDataContent = @"content";
NSString *const kSysMsgDataOrder = @"order";
NSString *const kSysMsgDataCreateDate = @"createDate";
NSString *const kSysMsgDataUpdateDate = @"updateDate";


@interface SysMsgData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SysMsgData

@synthesize dataIdentifier = _dataIdentifier;
@synthesize title = _title;
@synthesize content = _content;
@synthesize order = _order;
@synthesize createDate = _createDate;
@synthesize updateDate = _updateDate;


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
            self.dataIdentifier = [[self objectOrNilForKey:kSysMsgDataId fromDictionary:dict] doubleValue];
            self.title = [self objectOrNilForKey:kSysMsgDataTitle fromDictionary:dict];
            self.content = [self objectOrNilForKey:kSysMsgDataContent fromDictionary:dict];
            self.order = [[self objectOrNilForKey:kSysMsgDataOrder fromDictionary:dict] doubleValue];
            self.createDate = [self objectOrNilForKey:kSysMsgDataCreateDate fromDictionary:dict];
            self.updateDate = [self objectOrNilForKey:kSysMsgDataUpdateDate fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kSysMsgDataId];
    [mutableDict setValue:self.title forKey:kSysMsgDataTitle];
    [mutableDict setValue:self.content forKey:kSysMsgDataContent];
    [mutableDict setValue:[NSNumber numberWithDouble:self.order] forKey:kSysMsgDataOrder];
    [mutableDict setValue:self.createDate forKey:kSysMsgDataCreateDate];
    [mutableDict setValue:self.updateDate forKey:kSysMsgDataUpdateDate];

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

    self.dataIdentifier = [aDecoder decodeDoubleForKey:kSysMsgDataId];
    self.title = [aDecoder decodeObjectForKey:kSysMsgDataTitle];
    self.content = [aDecoder decodeObjectForKey:kSysMsgDataContent];
    self.order = [aDecoder decodeDoubleForKey:kSysMsgDataOrder];
    self.createDate = [aDecoder decodeObjectForKey:kSysMsgDataCreateDate];
    self.updateDate = [aDecoder decodeObjectForKey:kSysMsgDataUpdateDate];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_dataIdentifier forKey:kSysMsgDataId];
    [aCoder encodeObject:_title forKey:kSysMsgDataTitle];
    [aCoder encodeObject:_content forKey:kSysMsgDataContent];
    [aCoder encodeDouble:_order forKey:kSysMsgDataOrder];
    [aCoder encodeObject:_createDate forKey:kSysMsgDataCreateDate];
    [aCoder encodeObject:_updateDate forKey:kSysMsgDataUpdateDate];
}

- (id)copyWithZone:(NSZone *)zone
{
    SysMsgData *copy = [[SysMsgData alloc] init];
    
    if (copy) {

        copy.dataIdentifier = self.dataIdentifier;
        copy.title = [self.title copyWithZone:zone];
        copy.content = [self.content copyWithZone:zone];
        copy.order = self.order;
        copy.createDate = [self.createDate copyWithZone:zone];
        copy.updateDate = [self.updateDate copyWithZone:zone];
    }
    
    return copy;
}


@end
