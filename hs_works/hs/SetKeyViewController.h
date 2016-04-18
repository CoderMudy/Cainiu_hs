//
//  SetKeyViewController.h
//  hs
//
//  Created by PXJ on 15/4/25.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetKeyViewController : HSBaseViewController<UITextFieldDelegate>

@property (strong ,nonatomic)NSString * regPhone;
@property (strong ,nonatomic)NSString * checkNum;
@property (strong ,nonatomic)NSString * sourceStr;

@property (nonatomic,assign)BOOL    isBindMobile;
@property (nonatomic,assign)BOOL    isCharge;
@end
