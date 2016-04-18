//
//  CommisionCashView.m
//  hs
//
//  Created by PXJ on 15/10/27.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "CommisionCashView.h"

@implementation CommisionCashView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        
        
        
    }
    return self;
}
- (void)initUI
{
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.6;
    [self addSubview:backView];
    
    UIView * alertView = [[UIView alloc] init];
    alertView.center = CGPointMake(ScreenWidth/2, ScreenHeigth/2);
    alertView.bounds = CGRectMake(0, 0, ScreenWidth-50, (ScreenWidth-40)*280/270);
    alertView.backgroundColor = K_color_red;
    alertView.layer.cornerRadius = 10;
    alertView.layer.masksToBounds = YES;
    [self addSubview:alertView];
    
    
    UIView * whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-50, (ScreenWidth-40)*240/270)];
    whiteView.layer.cornerRadius = 10;
    whiteView.layer.masksToBounds = YES;
    whiteView.backgroundColor = [UIColor whiteColor];
    [alertView addSubview:whiteView];
    
    
    UIImageView * sucImgV = [[UIImageView alloc] init];
    sucImgV.center = CGPointMake(ScreenWidth/2-25, 80*ScreenWidth/320);
    sucImgV.bounds = CGRectMake(0, 0, 62*ScreenWidth/375, 70*ScreenWidth/375);
    sucImgV.image = [UIImage imageNamed:@"spread_7"];
    [whiteView addSubview:sucImgV];
    
    UILabel * warnLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 150*ScreenWidth/320, ScreenWidth-80,(ScreenWidth-40)*240/270 -150*ScreenWidth/320 )];
    warnLab.textColor =[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.8];
    warnLab.font = [UIFont systemFontOfSize:11*ScreenWidth/375];
    warnLab.numberOfLines = 0;
    NSString * warnText = @"温馨提示：\n\n1、工作日（9:00-17:00）申请提现，通过审核即可到账。\n2、双休日及节假日申请提现，顺延至下一工作日处理。";
    NSMutableAttributedString * atrWarnText = [Helper mutableFontAndColorText:warnText from:0 to:5 font:12*ScreenWidth/375 from:0 to:5 color:K_color_red];
    warnLab.attributedText = atrWarnText;
    
    [whiteView addSubview:warnLab];
    
    
    
   
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(0, whiteView.frame.size.height, ScreenWidth-50, (ScreenWidth-40)*40/270);
    confirmBtn.backgroundColor = K_color_red;
    confirmBtn.layer.cornerRadius = 10;
    confirmBtn.layer.masksToBounds = YES;
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [confirmBtn addTarget:self action:@selector(hiddenSelf) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:confirmBtn];

}
- (void)hiddenSelf
{

//    [self removeFromSuperview];
    self.alertConfirm();
}
@end
