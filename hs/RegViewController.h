//
//  RegViewController.h
//  hs
//
//  Created by hzl on 15-4-16.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RegViewController : BaseViewController <UITextFieldDelegate>
@property (strong, nonatomic) UITextField *regIphoneTextField;
@property (strong, nonatomic) NSString * sourceStr;
@property (nonatomic,strong) NSString   *logPhone;
@end
