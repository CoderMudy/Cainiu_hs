//
//  SignViewController.h
//  hs
//
//  Created by RGZ on 15/5/21.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrivateUserInfo.h"

typedef void(^SignBlock)(NSString *);

@interface SignViewController : HSBaseViewController<UIScrollViewDelegate,UITextViewDelegate>

@property (nonatomic,strong)SignBlock block;

@property (nonatomic,strong)PrivateUserInfo *privateUserInfo;

@end
