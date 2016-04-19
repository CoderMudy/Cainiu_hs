//
//  LogRegView.m
//  hs
//
//  Created by PXJ on 15/7/30.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "LoginAndRegistView.h"

@implementation LoginAndRegistView

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
        float width = self.frame.size.width;
//        float height = self.frame.size.height;
        
//        UIImageView * whiteBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
//        whiteBackView.userInteractionEnabled = YES;
//        whiteBackView.image = [UIImage imageNamed:@"white"];
//        [self addSubview:whiteBackView];
        
        UIImageView * topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , self.frame.size.width, self.frame.size.width*468/687)];
        

        topImageView.image  = [UIImage imageNamed:@"longin_image"];
        [self addSubview:topImageView];
        
        
        
        
        UIImageView * registImageV = [[UIImageView alloc] init];
        registImageV.userInteractionEnabled =YES;
        registImageV.image = [UIImage imageNamed:@"regist"];
        registImageV.center = CGPointMake(width/2, CGRectGetMaxY(topImageView.frame) + 158/2*ScreenHeigth/667);
        registImageV.bounds = CGRectMake(0, 0, width*6/7, (width*6/7)*68/431);
        registImageV.layer.cornerRadius = 10;
        registImageV.layer.masksToBounds = YES;
        [self addSubview:registImageV];
        
        
        _registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registBtn.tag = 20000;
//        _registBtn.backgroundColor = [UIColor clearColor];
        _registBtn.center = CGPointMake(width/2, CGRectGetMaxY(topImageView.frame) + 158/2*ScreenHeigth/667);
        _registBtn.bounds = CGRectMake(0, 0, width*6/7, 44);
        [_registBtn addTarget:self action:@selector(loginOrRegistBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_registBtn];
        
        
//        UIImageView * loginImageV = [[UIImageView alloc] init];
//        loginImageV.userInteractionEnabled = YES;
//        loginImageV.image = [UIImage imageNamed:@"login"];
//        loginImageV.center =CGPointMake(width/2, _registBtn.center.y+width/8);
//        loginImageV.bounds = CGRectMake(0, 0, width/4, (width/4)*16/126);
//        [self addSubview:loginImageV];
//        
//   
        
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.tag = 20001;
        _loginBtn.center = CGPointMake(width/2, CGRectGetMaxY(_registBtn.frame) + 45*ScreenHeigth/667);
        _loginBtn.bounds = CGRectMake(0, 0, width*6/7, 44);
        [_loginBtn setTitle:@"已有账号？立即登录" forState:UIControlStateNormal];
        [_loginBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_loginBtn setTitleColor: K_COLOR_CUSTEM(210, 210, 210, 1) forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginOrRegistBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_loginBtn];
      
    }
    return self;


}

-(void)loginOrRegistBtnClick:(UIButton*)sender
{
    self.block(sender);
}
@end
