//
//  UserUserInfo.h
//
//  Created by   on 15/5/19
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface UserUserInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) int isStaff;
@property (nonatomic, strong) NSString *userCls;
@property (nonatomic, strong) NSString *tele;
@property (nonatomic, strong) NSString *headPic;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) id birth;
@property (nonatomic, strong) NSString *nick;
@property (nonatomic, strong) id provice;
@property (nonatomic, strong) id personSign;
@property (nonatomic, strong) id address;
@property (nonatomic, strong) NSString *regDate;
@property (nonatomic, strong) id city;
@property (nonatomic, strong) id region;
@property (nonatomic, strong) NSString *name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
