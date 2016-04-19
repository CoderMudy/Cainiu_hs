//
//  MarketIsStatusAlert.m
//  hs
//
//  Created by Xse on 16/1/6.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "MarketIsStatusAlert.h"

@implementation MarketIsStatusAlert
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //        [self initTableView];
    }
    
    return self;
}

- (void)initMarketStatus
{
    //====
    UIView *backWihteView = [[UIView alloc]init];
    backWihteView.backgroundColor = [UIColor whiteColor];
    backWihteView.layer.cornerRadius = 8;
    backWihteView.layer.masksToBounds = YES;
    backWihteView.frame  = CGRectMake(0, 0, ScreenWidth - 60,40*ScreenWidth/320*2 + 40);// 20 + 20 + 10 + 55*ScreenWidth/320 + 30
    [self addSubview:backWihteView];
    
    UILabel *labelText = [[UILabel alloc]init];
    labelText.text = @"您好，交易系统尚未开市";
    labelText.frame = CGRectMake(0, 45*ScreenWidth/320, backWihteView.frame.size.width, 21);
    labelText.textAlignment = NSTextAlignmentCenter;
    labelText.font = [UIFont systemFontOfSize:15.0];
    labelText.textColor = [UIColor blackColor];
    [backWihteView addSubview:labelText];
    
    UILabel *timeLab = [[UILabel alloc]init];
    timeLab.text = @"工作日:9:00-次日6:00可交易";
    timeLab.frame = CGRectMake(0, CGRectGetMaxY(labelText.frame), backWihteView.frame.size.width, 21);
    timeLab.textAlignment = NSTextAlignmentCenter;
    timeLab.font = [UIFont systemFontOfSize:12.0];
    timeLab.textColor = [UIColor orangeColor];
    [backWihteView addSubview:timeLab];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0,CGRectGetMaxY(backWihteView.frame), backWihteView.frame.size.width, 40.0/667*ScreenHeigth);
    [sureBtn setTitle:@"确定"forState:UIControlStateNormal];
    sureBtn.backgroundColor = K_color_red;
    [sureBtn addTarget:self action:@selector(clickSureAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
}

#pragma mark - 点击确定
- (void)clickSureAction:(UIButton *)sender
{
    self.clickSureAction();
    [self removeFromSuperview];
    
}


@end
