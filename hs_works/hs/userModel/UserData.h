//
//  UserData.h
//
//  Created by   on 15/5/19
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserTokenInfo, UserUserInfo, UserFinancyInfo;

@interface UserData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *userBankList;
@property (nonatomic, strong) UserTokenInfo *tokenInfo;
@property (nonatomic, strong) UserUserInfo *userInfo;
@property (nonatomic, strong) UserFinancyInfo *financyInfo;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
