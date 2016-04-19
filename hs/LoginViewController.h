//
//  LoginViewController.h
//  hs
//
//  Created by hzl on 15-4-22.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSBaseViewController.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate>

//个人资料页修改登录密码需要
@property (nonatomic,assign) BOOL  isNeedPopRootController;

//注册push进入
@property (nonatomic,assign) BOOL  isRegInto;

@property (nonatomic,strong) NSString *regPhone;

@property (nonatomic,strong) NSString * source;

@property (nonatomic,assign) BOOL   isGesForget;
/**
 *  期货
 */
@property (nonatomic,assign)BOOL    isOtherFutures;
/**
 *  没有返回按钮
 */
@property (nonatomic,assign)BOOL    isNoBackBtn;

@property(nonatomic,strong) NSString *isRegister;

@end
