//
//  UserBaseClass.h
//
//  Created by   on 15/5/19
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserData;

@interface UserBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double code;
@property (nonatomic, strong) UserData *data;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *errparam;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
