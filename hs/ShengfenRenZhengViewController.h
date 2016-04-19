//
//  ShengfenRenZhengViewController.h
//  hs
//
//  Created by Xse on 15/10/19.
//  Copyright © 2015年 luckin. All rights reserved.
//  =====身份认证页面

#import "HSBaseViewController.h"
#import "PrivateUserInfo.h"
#import "BaseViewController.h"
@interface ShengfenRenZhengViewController : BaseViewController

@property(nonatomic,strong) PrivateUserInfo *userInfo;
@property(nonatomic,strong) NSString *shenHeStatus;//审核状态

@property(nonatomic,strong) NSMutableArray *infoArray;//上传过图片，服务器返回的图片
@property(nonatomic,strong) NSString *faileMsg;

@end
