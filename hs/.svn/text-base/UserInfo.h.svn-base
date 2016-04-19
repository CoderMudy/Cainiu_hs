//
//  UserInfo.h
//  hs
//
//  Created by RGZ on 15/6/15.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject<NSCoding>


//昵称修改状态（1：已修改过，0：未修改过）
@property (nonatomic,strong)NSString    *userNickStatus;
//昵称修改时间
@property (nonatomic,strong)NSString    *userNickUpdateDate;


//Token

//用户的唯一标识，下一次自动登录使用，客户端需要保存
@property (nonatomic,strong)NSString    *userTokenUserSecret;
//用户会话标识，每一次请求必须字段，用于维持会话，客户端需要保存
@property (nonatomic,strong)NSString    *userTokenToken;
//false标识当前会话未过期，true标识已经过期，需要重新发起会话续期请求
@property (nonatomic,strong)NSString    *userTokenIsDeline;
//用户ID(null)
@property (nonatomic,strong)NSString    *userTokenUserID;


//UserInfo

//手机号
@property (nonatomic,strong)NSString    *userUserInfoTele;
//实名
@property (nonatomic,strong)NSString    *userUserInfoName;
//昵称
@property (nonatomic,strong)NSString    *userUserInfoNick;
//用户所属级别：普通用户
@property (nonatomic,strong)NSString    *userUserInfoCLS;
//性别
@property (nonatomic,strong)NSString    *userUserInfoSex;
//生日
@property (nonatomic,strong)NSString    *userUserInfoBirth;
//头像地址url
@property (nonatomic,strong)NSString    *userUserInfoHeadPic;
//签名
@property (nonatomic,strong)NSString    *userUserInfoSign;
//city市
@property (nonatomic,strong)NSString    *userUserInfoCity;
//reg_date注册时间
@property (nonatomic,strong)NSString    *userUserInfoRegDate;
//address地址
@property (nonatomic,strong)NSString    *userUserInfoAddress;
//region区
@property (nonatomic,strong)NSString    *userUserInfoRegion;
//provice省
@property (nonatomic,strong)NSString    *userUserInfoProvice;


//Gesture


//是否设置手势密码 1：设置 0：未设置
@property (nonatomic,strong)NSString    *userGestureIsSetPWD;
//是否启动手势密码  1：启动  0：未启动
@property (nonatomic,strong)NSString    *userGestureIsStart;
//是否第三方登录      0：不是 1：是
@property (nonatomic,strong)NSString    *userGestureIsOpenidLogin;



@end
