//
//  RealNameViewController.h
//  hs
//
//  Created by RGZ on 15/5/21.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrivateUserInfo.h"
typedef void(^RealNameBlock)(PrivateUserInfo *);

@interface RealNameViewController : HSBaseViewController<UIScrollViewDelegate,UITextFieldDelegate>

//充值页面进入,实名认证结束进入绑定银行卡
@property (nonatomic,assign)BOOL    isOtherPage;

@property (nonatomic,assign)BOOL    isCharge;
//是否需要返回到原址(现货开户需要)
@property (nonatomic,assign)BOOL    isNeedPop;

//是否认证过
@property (nonatomic,assign)BOOL    isAuth;

@property (nonatomic,strong)RealNameBlock block;

@property (nonatomic,strong)PrivateUserInfo *privateUserInfo;

//身份认证（个人资料页面进入)
@property (nonatomic,assign)BOOL isRenZheng;

@end
