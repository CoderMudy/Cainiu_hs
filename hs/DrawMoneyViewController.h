//
//  DrawMoneyViewController.h
//  hs
//
//  Created by 杨永刚 on 15/5/25.
//  Copyright (c) 2015年 luckin. All rights reserved.
//


/*
 完善银行卡页面去除
 */


#import "HSBaseViewController.h"

@interface DrawMoneyViewController : HSBaseViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>



@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *bankCard;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *provName;
@property (nonatomic, strong) NSString *branName;
@property (nonatomic, strong) NSString *ID;

@end
