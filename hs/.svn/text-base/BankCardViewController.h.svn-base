//
//  BankCardViewController.h
//  hs
//
//  Created by RGZ on 15/5/21.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrivateUserInfo.h"

typedef void(^BankCardBlock)(PrivateUserInfo *);

@interface BankCardViewController : HSBaseViewController<UITextFieldDelegate,UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate>
//充值进入
@property (nonatomic,assign)BOOL                isOtherPage;

@property (nonatomic,assign)BOOL                isCharge;

@property (nonatomic,strong)PrivateUserInfo     *privateUserInfo;

@property (nonatomic,assign)BOOL                isBinding;

@property (nonatomic,strong)BankCardBlock       block;

//身份认证（个人资料页面进入)
@property (nonatomic,assign)BOOL isRenZheng;


@end
