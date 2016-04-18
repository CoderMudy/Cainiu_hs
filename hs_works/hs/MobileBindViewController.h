//
//  MobileBindViewController.h
//  hs
//
//  Created by RGZ on 15/6/2.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrivateUserInfo.h"

typedef void(^MobileBlock)(PrivateUserInfo *);

@interface MobileBindViewController : HSBaseViewController<UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic,assign)BOOL    isBind;

@property (nonatomic,assign)BOOL    isCharge;

//@property (nonatomic,assign)BOOL                isOtherPage;

@property (nonatomic,strong)PrivateUserInfo     *privateUserInfo;

@property (nonatomic,strong)MobileBlock       block;

@end


