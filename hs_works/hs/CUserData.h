//
//  CUserData.h
//  hs
//
//  Created by hzl on 15-4-23.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDataModels.h"
@interface CUserData : NSObject

@property (nonatomic,copy)NSMutableDictionary *userdata;
@property (nonatomic,strong)UserBaseClass * userBaseClass;
-(NSString *) userSecret;
-(NSString *) userToken;
-(BOOL)       isdeline;

+ (instancetype)sharedInstance;
@end
