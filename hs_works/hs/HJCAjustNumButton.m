//
//  HJCAjustNumButton.m
//  HJCAdjustButtonTest
//
//  Created by HJaycee on 15/6/4.
//  Copyright (c) 2015年 HJaycee. All rights reserved.
//

#import "HJCAjustNumButton.h"

@interface HJCAjustNumButton ()
{
    UIView *_oneLine;
    UIView *_twoLine;
    NSTimer *_timer;
    
    NSString *floatStr;
}

@end

@implementation HJCAjustNumButton

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    [self commonSetup];
}

- (void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    
    self.layer.borderColor = [lineColor CGColor];
    _oneLine.backgroundColor = lineColor;
    _twoLine.backgroundColor = lineColor;
}

//- (void)setCurrentNum:(NSString *)currentNum{
//    _textField.text = currentNum;
//    NSLog(@"fuck:%@",currentNum);
//}
//
//- (NSString *)currentNum{
//    return _textField.text;
//}

- (instancetype)init{
    if (self = [super init]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    
    UIColor *lineColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    
    self.frame = CGRectMake(0, 0, 110, 30);
    self.backgroundColor = [UIColor blackColor];
    self.layer.cornerRadius = 2;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [lineColor CGColor];
    
    _oneLine = [[UIView alloc] init];
    _oneLine.backgroundColor = lineColor;
    [self addSubview:_oneLine];
    
    _twoLine = [[UIView alloc] init];
    _twoLine.backgroundColor = lineColor;
    [self addSubview:_twoLine];
    
    _decreaseBtn = [[UIButton alloc] init];
    [self setupButton:_decreaseBtn normalImage:@"decrease" HighlightImage:@"decrease"];
    [self addSubview:_decreaseBtn];
    
    _increaseBtn = [[UIButton alloc] init];
    [self setupButton:_increaseBtn normalImage:@"increase" HighlightImage:@"increase"];
    [self addSubview:_increaseBtn];
    
//    [_decreaseBtn setImage:[UIImage imageNamed:norImage] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
//    [btn addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
//    [btn addTarget:self action:@selector(btnTouchUp:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchUpInside|UIControlEventTouchCancel];
    
    _textField = [[UITextField alloc] init];
//    _textField.keyboardAppearance = UIKeyboardAppearanceAlert;
    
    _textField.textColor = [UIColor whiteColor];
    [_textField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _textField.keyboardType = UIKeyboardTypeNamePhonePad;//UIKeyboardTypeDecimalPad
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
    [self addSubview:_textField];
    
    [self commonSetup];
    
}

- (void)commonSetup{
    CGFloat viewH = self.frame.size.height;
    CGFloat viewW = self.frame.size.width;
    
    _oneLine.frame = CGRectMake(viewH, 0, 1, viewH);
    _decreaseBtn.frame = CGRectMake(0, 0, viewH, viewH);
    _twoLine.frame = CGRectMake(viewW - viewH - 1, 0, 1, viewH);
    _increaseBtn.frame = CGRectMake(viewW - viewH, 0, viewH, viewH);
    _textField.frame = CGRectMake(viewH, 0, viewW - viewH * 2, viewH);
}

- (void)setupButton:(UIButton *)btn normalImage:(NSString *)norImage HighlightImage:(NSString *)highImage{
//    [btn setImage:[self readImageFromBundle:norImage] forState:UIControlStateNormal];
//    [btn setImage:[self readImageFromBundle:highImage] forState:UIControlStateHighlighted];
//    [btn addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
//    [btn addTarget:self action:@selector(btnTouchUp:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchUpInside|UIControlEventTouchCancel];
    [btn setImage:[UIImage imageNamed:norImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(btnTouchUp:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchUpInside|UIControlEventTouchCancel];
}

- (void)btnTouchDown:(UIButton *)btn{
    [_textField resignFirstResponder];
    
    if (btn == _increaseBtn) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(increase) userInfo:nil repeats:YES];
    } else {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(decrease) userInfo:nil repeats:YES];
    }
    [_timer fire];
}

- (void)btnTouchUp:(UIButton *)btn{
    [self cleanTimer];
}

- (void)increase{
    
    if (_textField.text.length == 0) {
        _textField.text = @"1";
    }
    
    if (_isIntOrFloat == 0) {
        int newNum = [_textField.text intValue] + 1;
        _textField.text = [NSString stringWithFormat:@"%i", newNum];
    }else if(_isIntOrFloat == 1)
    {
        floatStr = [NSString stringWithFormat:@"%@%@f",@"%",[NSString stringWithFormat:@".%d",[_floatNumStr intValue]]];
        float incrNum = powf(10, [_floatNumStr intValue]);
        float newNum = [_textField.text floatValue] + 1/incrNum;
        _textField.text = [NSString stringWithFormat:floatStr, newNum];
        
    }else
    {
        NSString * toBeingString;
        
        toBeingString = [_textField.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
        toBeingString = [toBeingString stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        int newNum = [toBeingString intValue] + 1;
        toBeingString = [self countNumAndChangeformat:[NSString stringWithFormat:@"%i",newNum]];
        
        _textField.text = [NSString stringWithFormat:@"¥%@", toBeingString];
    }
    
    self.callBack(_textField.text,_textField);
}

- (void)decrease{
    if (_textField.text.length == 0) {
        _textField.text = @"1";
    
    }
    
    //下面的是可以区分是小数点的
    
    if (_isIntOrFloat == 0) {
        int newNum = [_textField.text intValue] -1;
        if (newNum > 0) {
            _textField.text = [NSString stringWithFormat:@"%i", newNum];
            self.callDecreaseBack(_textField.text,_textField);
        } else {
            NSLog(@"num can not less than 1");
        }
    }else if(_isIntOrFloat == 1)
    {
        floatStr = [NSString stringWithFormat:@"%@%@f",@"%",[NSString stringWithFormat:@".%d",[_floatNumStr intValue]]];
        float incrNum = powf(10, [_floatNumStr intValue]);
        float newNum = [_textField.text floatValue] -1/incrNum;
        if (newNum > 0) {
            _textField.text = [NSString stringWithFormat:floatStr, newNum];
            self.callDecreaseBack(_textField.text,_textField);
        } else {
            NSLog(@"num can not less than 1");
        }
    }else
    {
        NSString * toBeingString;
        
        if ([_textField.text rangeOfString:@"¥"].location != NSNotFound)
        {
            toBeingString = [_textField.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
        }else
        {
            toBeingString = [_textField.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
        }
        
        
        toBeingString = [toBeingString stringByReplacingOccurrencesOfString:@"," withString:@""];
        int newNum = [toBeingString intValue] - 1;
        if (newNum > 0)
        {
            toBeingString = [self countNumAndChangeformat:[NSString stringWithFormat:@"%i",newNum]];
            _textField.text = [NSString stringWithFormat:@"¥%@", toBeingString];
        }else
        {
            NSLog(@"num can not less than 1");
        }

    }

}


- (UIImage *)readImageFromBundle:(NSString *)imageName{
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"HJCAdjustNumButton.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *(^getBundleImage)(NSString *) = ^(NSString *n) {
        return [UIImage imageWithContentsOfFile:[bundle pathForResource:n ofType:@"png"]];
    };
    UIImage *myImg = getBundleImage(imageName);
    return myImg;
}

- (void)dealloc{
    [self cleanTimer];
}

- (void)cleanTimer{
    if (_timer.isValid) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSArray *ws = [[UIApplication sharedApplication] windows];
    for(UIView *w in ws){
        NSArray *vs = [w subviews];
        for(UIView *v in vs){
            if([[NSString stringWithUTF8String:object_getClassName(v)] isEqualToString:@"UIKeyboard"]){
                v.backgroundColor = [UIColor redColor];
            }
        }
    }
}

//把钱转成逗号格式
-(NSString *)countNumAndChangeformat:(NSString *)num
{
    NSString * oldString = [NSString stringWithString:num];
    num = [[oldString componentsSeparatedByString:@"."] objectAtIndex:0];
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3)
    {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    
    if([[oldString componentsSeparatedByString:@"."] count] > 1)
        
        return [NSString stringWithFormat:@"%@.%@",newstring,[[oldString componentsSeparatedByString:@"."] objectAtIndex:1]];
    else
        return newstring;
}

@end
