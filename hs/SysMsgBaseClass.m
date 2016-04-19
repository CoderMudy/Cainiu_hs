//
//  SysMsgBaseClass.m
//
//  Created by   on 15/8/10
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "SysMsgBaseClass.h"
#import "SysMsgData.h"


NSString *const kSysMsgBaseClassCode = @"code";
NSString *const kSysMsgBaseClassData = @"data";
NSString *const kSysMsgBaseClassMsg = @"msg";
NSString *const kSysMsgBaseClassErrparam = @"errparam";


@interface SysMsgBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SysMsgBaseClass

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
            self.code = [[self objectOrNilForKey:kSysMsgBaseClassCode fromDictionary:dict] doubleValue];
    NSObject *receivedSysMsgData = [dict objectForKey:kSysMsgBaseClassData];
    NSMutableArray *parsedSysMsgData = [NSMutableArray array];
    if ([receivedSysMsgData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedSysMsgData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedSysMsgData addObject:[SysMsgData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedSysMsgData isKindOfClass:[NSDictionary class]]) {
       [parsedSysMsgData addObject:[SysMsgData modelObjectWithDictionary:(NSDictionary *)receivedSysMsgData]];
    }

    self.data = [NSArray arrayWithArray:parsedSysMsgData];
            self.msg = [self objectOrNilForKey:kSysMsgBaseClassMsg fromDictionary:dict];
            self.errparam = [self objectOrNilForKey:kSysMsgBaseClassErrparam fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kSysMsgBaseClassCode];
    NSMutableArray *tempArrayForData = [NSMutableArray array];
    for (NSObject *subArrayObject in self.data) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForData addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForData addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kSysMsgBaseClassData];
    [mutableDict setValue:self.msg forKey:kSysMsgBaseClassMsg];
    [mutableDict setValue:self.errparam forKey:kSysMsgBaseClassErrparam];

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

    self.code = [aDecoder decodeDoubleForKey:kSysMsgBaseClassCode];
    self.data = [aDecoder decodeObjectForKey:kSysMsgBaseClassData];
    self.msg = [aDecoder decodeObjectForKey:kSysMsgBaseClassMsg];
    self.errparam = [aDecoder decodeObjectForKey:kSysMsgBaseClassErrparam];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kSysMsgBaseClassCode];
    [aCoder encodeObject:_data forKey:kSysMsgBaseClassData];
    [aCoder encodeObject:_msg forKey:kSysMsgBaseClassMsg];
    [aCoder encodeObject:_errparam forKey:kSysMsgBaseClassErrparam];
}

- (id)copyWithZone:(NSZone *)zone
{
    SysMsgBaseClass *copy = [[SysMsgBaseClass alloc] init];
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.errparam = [self.errparam copyWithZone:zone];
    }
    
    return copy;
}


@end
