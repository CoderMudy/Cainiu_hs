//
//  BaseViewController.m
//  BuFu
//
//  Created by 郑鹏 on 15/4/21.
//  Copyright (c) 2015年 Huifeng Technology Co.,Ltd. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
    UIButton *rightButton;
    UIButton *leftButton;
    UIButton *norbackButton;
    
}
//导航栏背景
@property (nonatomic,strong) UIImageView *bgView;
//导航栏中间文本
@property (nonatomic,strong) UILabel *titleLabel;
//导航栏上的线
@property (nonatomic,strong) UIView *naviBottomLine;

@end

@implementation BaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    [_bgView addSubview:self.titleLabel];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)setNaviTitle:(NSString *)title
{
    self.titleLabel.text = title;
}
- (void)setNaviCenterView:(id)centerView
{
    [self.bgView addSubview:centerView];
}

- (void)setBackButton
{
    norbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [norbackButton setImage:[UIImage imageNamed:@"return_1"] forState:UIControlStateNormal];
    [norbackButton setImageEdgeInsets:UIEdgeInsetsMake(10, 15, 10, 30)];
    [norbackButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    norbackButton.frame = CGRectMake(0, 15, 64, 49);
    norbackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_bgView addSubview:norbackButton];
}
- (void)clickBackButton
{
//    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setBackButtonWithTitle:(NSString *)title
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(13, 20, 80, 44);
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [backButton addTarget:self action:@selector(clickDissmissButton) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_bgView addSubview:backButton];
}

- (void)clickDissmissButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//左边按钮(文字)
- (void)setLeftBtnWithTitle:(NSString *)title
{
    if (leftButton == nil) {
        leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setTitle:title forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    leftButton.frame = CGRectMake(13, 20, 80, 44);
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.bgView addSubview:leftButton];
}
//左边按钮(图片)
- (void)setLeftBtnWithImageName:(NSString *)imageName
{
    if (leftButton == nil) {
        leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    [leftButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(10, 20, 54, 44);
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.bgView addSubview:leftButton];
}

- (void)leftButtonAction
{
    
}



- (void)setRightBtnWithTitle:(NSString *)title
{
    if (rightButton == nil) {
        rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTitle:title forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    rightButton.frame = CGRectMake(ScreenWidth - 90, 20, 80, 44);
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.bgView addSubview:rightButton];
}

- (void)setRightBtnWithImageName:(NSString *)imageName
{
    if (rightButton == nil) {
        rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    [rightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(ScreenWidth - 44, 20, 44, 44);
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.bgView addSubview:rightButton];
}
- (void)setRightBtnDisEnabel
{
    rightButton.userInteractionEnabled = NO;
}
- (void)setRightBtnEnabel
{
    rightButton.userInteractionEnabled = YES;
}
//右边按钮的点击事件   可在子类里重写
- (void)rightButtonAction
{

}

- (CGFloat)getNaviHeight
{
    return 64;
}

- (void)setNavibarBackImage
{
    [_naviBottomLine removeFromSuperview];
    _bgView.backgroundColor = K_color_red;
//    _bgView.image = [UIImage imageNamed:@"title_background"];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [norbackButton setImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];
    self.titleLabel.textColor = [UIColor whiteColor];
}

- (void)setNavibarBackGroundColor:(UIColor *)color
{
    _bgView.backgroundColor = color;
//    self.titleLabel.textColor = [UIColor colorWithRed:0.34f green:0.34f blue:0.34f alpha:1.00f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIView *)naviBottomLine
{
    if (_naviBottomLine==nil) {
        _naviBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, _bgView.bounds.size.height-0.5, ScreenWidth, 0.5)];
        _naviBottomLine.backgroundColor = [UIColor blackColor];
    }
    return _naviBottomLine;
}

- (UIImageView *)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
        [_bgView setBackgroundColor:[UIColor whiteColor]];
        _bgView.userInteractionEnabled = YES;
//        [_bgView addSubview:self.naviBottomLine];
    }
    return _bgView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 20, ScreenWidth/2, 44)];
        _titleLabel.center = CGPointMake(ScreenWidth/2, _titleLabel.center.y);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:18.0];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

@end
