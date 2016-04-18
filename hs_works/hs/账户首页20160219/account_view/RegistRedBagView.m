//
//  RegistRedBagView.m
//  hs
//
//  Created by PXJ on 16/2/26.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "RegistRedBagView.h"

@implementation RegistRedBagView

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

    UIControl * backControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
    backControl.backgroundColor = [UIColor blackColor];
    backControl.alpha = 0.7;
    [backControl addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backControl];

    
    UIImageView * registRedImgV = [[UIImageView alloc] init];
    registRedImgV.center = CGPointMake(ScreenWidth/2, ScreenHeigth*2/5);
    registRedImgV.bounds = CGRectMake(0, 0, ScreenWidth*2/3, ScreenWidth*2/3);
    registRedImgV.image = [UIImage imageNamed:@"registReg"];
    [self addSubview:registRedImgV];
    
    UIButton * redBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    redBtn.frame = registRedImgV.frame;
    [redBtn addTarget:self action:@selector(redbagClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:redBtn];
    
    UIButton * getRedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getRedBtn.center = CGPointMake(ScreenWidth/2, CGRectGetMaxY(redBtn.frame)+40);
    getRedBtn.bounds = CGRectMake(0, 0, CGRectGetWidth(registRedImgV.frame)*2/3, 30);
    getRedBtn.backgroundColor = K_color_red;
    getRedBtn.layer.cornerRadius = 13;
    getRedBtn.layer.masksToBounds = YES;
    [getRedBtn addTarget:self action:@selector(redbagClick) forControlEvents:UIControlEventTouchUpInside];
    [getRedBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self addSubview:getRedBtn];
    
}
- (void)redbagClick
{

    self.redBagBlock();
    [self removeFromSuperview];

}
- (void)removeSelf
{
    [self redbagClick];
}
@end
