//
//  UserTokenInfo.h
//
//  Created by   on 15/5/19
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface UserTokenInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *userSecret;
@property (nonatomic, assign) BOOL isdeline;
@property (nonatomic, strong) id userId;
@property (nonatomic, strong) NSString *token;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
