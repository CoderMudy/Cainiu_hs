//
//  SecondStepRechargeController.h
//  hs
//
//  Created by RGZ on 15/6/4.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondStepRechargeController : HSBaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, assign) NSInteger rechargeMoney;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *cardNum;
@property (nonatomic, strong) NSString *bankID;
@property (nonatomic, strong) UIImage *bankIcon;



@end
