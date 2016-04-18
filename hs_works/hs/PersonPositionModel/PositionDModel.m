//
//  PositionModel.m
//
//  Created by   on 15/7/8
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "PositionDModel.h"
#import "PositionData.h"


NSString *const kPositionModelCode = @"code";
NSString *const kPositionModelData = @"data";
NSString *const kPositionModelMsg = @"msg";
NSString *const kPositionModelErrparam = @"errparam";


@interface PositionDModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PositionDModel

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
            self.code = [[self objectOrNilForKey:kPositionModelCode fromDictionary:dict] doubleValue];
            self.data = [PositionData modelObjectWithDictionary:[dict objectForKey:kPositionModelData]];
            self.msg = [self objectOrNilForKey:kPositionModelMsg fromDictionary:dict];
            self.errparam = [self objectOrNilForKey:kPositionModelErrparam fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kPositionModelCode];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kPositionModelData];
    [mutableDict setValue:self.msg forKey:kPositionModelMsg];
    [mutableDict setValue:self.errparam forKey:kPositionModelErrparam];

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

    self.code = [aDecoder decodeDoubleForKey:kPositionModelCode];
    self.data = [aDecoder decodeObjectForKey:kPositionModelData];
    self.msg = [aDecoder decodeObjectForKey:kPositionModelMsg];
    self.errparam = [aDecoder decodeObjectForKey:kPositionModelErrparam];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kPositionModelCode];
    [aCoder encodeObject:_data forKey:kPositionModelData];
    [aCoder encodeObject:_msg forKey:kPositionModelMsg];
    [aCoder encodeObject:_errparam forKey:kPositionModelErrparam];
}

- (id)copyWithZone:(NSZone *)zone
{
    PositionDModel *copy = [[PositionDModel alloc] init];
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.errparam = [self.errparam copyWithZone:zone];
    }
    
    return copy;
}


@end
