//
//  IndexOrderChooseView.m
//  hs
//
//  Created by RGZ on 16/4/11.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "IndexOrderChooseView.h"

@implementation IndexOrderChooseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.minusButton.frame = CGRectMake(0, 0, self.frame.size.height/5*4, self.frame.size.height);
        [self.minusButton setTitle:@"—" forState:UIControlStateNormal];
        self.minusButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [self.minusButton setTitleColor:Color_Gold forState:UIControlStateNormal];
        [self.minusButton addTarget:self action:@selector(minusClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.minusButton];
        
        self.minusLineView = [[UIView alloc]initWithFrame:CGRectMake(self.minusButton.frame.size.width, 0, 0.5, self.frame.size.height)];
        self.minusLineView.backgroundColor = Color_gray;
        [self addSubview:self.minusLineView];
        
        self.plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.plusButton.frame = CGRectMake(self.frame.size.width - self.frame.size.height/5*4, 0, self.frame.size.height/5*4, self.frame.size.height);
        [self.plusButton setTitle:@"+" forState:UIControlStateNormal];
        self.plusButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.plusButton setTitleColor:Color_Gold forState:UIControlStateNormal];
        [self.plusButton addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.plusButton];
        
        self.plusLineView = [[UIView alloc]initWithFrame:CGRectMake(self.plusButton.frame.origin.x - 0.5, 0, 0.5, self.frame.size.height)];
        self.plusLineView.backgroundColor = Color_gray;
        [self addSubview:self.plusLineView];
        
        UILongPressGestureRecognizer *minusLongGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(minusLongClick)];
        minusLongGes.minimumPressDuration = 0.5;
        [self.minusButton addGestureRecognizer:minusLongGes];
        
        UILongPressGestureRecognizer *plusLongGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(plusLongClick)];
        plusLongGes.minimumPressDuration = 0.5;
        [self.plusButton addGestureRecognizer:plusLongGes];
        
        self.textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.minusLineView.frame), 0, self.frame.size.width - CGRectGetMaxX(self.minusLineView.frame) - (self.frame.size.width - self.plusLineView.frame.origin.x), self.frame.size.height)];
        self.textField.textAlignment = NSTextAlignmentCenter;
        self.textField.text = @"1";
        self.textField.font = [UIFont systemFontOfSize:15];
        self.textField.textColor = [UIColor whiteColor];
        self.textField.delegate = self;
        self.textField.keyboardType = UIKeyboardTypeDecimalPad;
        self.textField.returnKeyType = UIReturnKeyDone;
        [self addSubview:self.textField];
        
        self.jump = 1;
    }
    return self;
}

-(void)minusClick{
    NSArray *array = [self.textField.text componentsSeparatedByString:@"."];
    NSString *str = @"";
    if (array.count == 2) {
        str = [NSString stringWithFormat:@".%@",array[1]];
    }
    
    self.textField.text = [NSString stringWithFormat:@"%d%@",[array[0] intValue] - self.jump , str];
    
    if ([self.textField.text floatValue] < 0) {
        self.textField.text = @"0";
    }
    
    self.minusBlock(self);
}

-(void)plusClick{
    NSArray *array = [self.textField.text componentsSeparatedByString:@"."];
    NSString *str = @"";
    if (array.count == 2) {
        str = [NSString stringWithFormat:@".%@",array[1]];
    }
    
    self.textField.text = [NSString stringWithFormat:@"%d%@",[array[0] intValue] + self.jump , str];
    
    self.plusBlock(self);
}

-(void)minusLongClick{
    self.minusBlock(self);
}

-(void)plusLongClick{
    self.plusBlock(self);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField performSelector:@selector(selectAll:) withObject:textField afterDelay:0];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.editEndBlock(self);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField.text rangeOfString:@"."].location != NSNotFound && [string isEqualToString:@"."]) {
        textField.text = [textField.text substringToIndex:textField.text.length];
        return NO;
    }
    return YES;
    
}



@end
