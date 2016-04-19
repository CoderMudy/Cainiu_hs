//
//  EntrustView.m
//  hs
//
//  Created by Xse on 15/12/7.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "EntrustView.h"

@implementation EntrustView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //        [self initTableView];
    }
    
    return self;
}

- (void)initEntrustView
{
    UIView *backWihteView = [[UIView alloc]init];
    backWihteView.backgroundColor = [UIColor whiteColor];
    backWihteView.layer.cornerRadius = 5;
    backWihteView.layer.masksToBounds = YES;
    backWihteView.frame  = CGRectMake(0, 0, self.frame.size.width,self.frame.size.height - 40.0/667*ScreenHeigth);// 20 + 20 + 10 + 55*ScreenWidth/320 + 30
    [self addSubview:backWihteView];
    
    UILabel *labelText = [[UILabel alloc]init];
    labelText.text = @"委托成功";
    labelText.frame = CGRectMake(0, 20, backWihteView.frame.size.width, 21);
    labelText.textAlignment = NSTextAlignmentCenter;
    labelText.font = [UIFont systemFontOfSize:15.0];
    labelText.textColor = [UIColor blackColor];
    [backWihteView addSubview:labelText];
    
    UIButton *checkEntrustBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkEntrustBtn setImage:[UIImage imageNamed:@"check_entrust"] forState:UIControlStateNormal];
    checkEntrustBtn.frame = CGRectMake(backWihteView.frame.size.width/2 - 50*ScreenWidth/320/2, CGRectGetMaxY(labelText.frame) + 10, 50*ScreenWidth/320, 55*ScreenWidth/320);
    [checkEntrustBtn addTarget:self action:@selector(clickCheckEntrus:) forControlEvents:UIControlEventTouchUpInside];
    [backWihteView addSubview:checkEntrustBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0,CGRectGetMaxY(backWihteView.frame), backWihteView.frame.size.width, 40.0/667*ScreenHeigth);
    [sureBtn setTitle:@"确定"forState:UIControlStateNormal];
    sureBtn.backgroundColor = Color_red_pink;
    [sureBtn addTarget:self action:@selector(clickSureAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
}

#pragma mark - 点击查看委托单
- (void)clickCheckEntrus:(UIButton *)sender
{
    self.clicCheckEntrust();
    [self removeFromSuperview];
}

#pragma mark - 点击确定
- (void)clickSureAction:(UIButton *)sender
{
    self.clickSureAction();
    [self removeFromSuperview];
    
}

@end
