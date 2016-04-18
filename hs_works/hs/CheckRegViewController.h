//
//  CheckRegViewController.h
//  hs
//
//  Created by hzl on 15-4-22.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckRegViewController : HSBaseViewController<UITextFieldDelegate>

@property(nonatomic,strong)NSString * regPhone;
@property(nonatomic,strong)NSString * checkNum;
@property(nonatomic,strong)NSString * sourceStr;
@property (nonatomic,assign)BOOL      isBindMobile;
@property (nonatomic,assign)BOOL    isCharge;

- (IBAction)textFieldValueChange;

@end
