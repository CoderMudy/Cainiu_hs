//
//  HJCAjustNumButton.h
//  HJCAdjustButtonTest
//
//  Created by HJaycee on 15/6/4.
//  Copyright (c) 2015年 HJaycee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJCAjustNumButton : UIView

@property(nonatomic,strong)  UIButton *decreaseBtn;//减
@property(nonatomic,strong)  UIButton *increaseBtn;//加


/**
 *  边框颜色，默认值是浅灰色
 */
@property (nonatomic, assign) UIColor *lineColor;

/**
 *  文本框内容
 */
@property (nonatomic, copy) NSString *currentNum;

/**
 *  文本框内容改变后的回调
 */
@property (nonatomic, copy) void (^callBack) (NSString *currentNum,UITextField *textFiled);//加
@property (nonatomic, copy) void (^callDecreaseBack) (NSString *currentNum,UITextField *textFiled);//减

@property(nonatomic,strong)  UITextField *textField;

//判断是加减是int还是float  0为int 1 为float
@property(nonatomic,assign) NSInteger isIntOrFloat;

@property(nonatomic,strong) NSString *floatNumStr;//保留几位小数

@property(nonatomic,strong) NSString *text;

@end
