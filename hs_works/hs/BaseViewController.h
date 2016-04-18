//
//  BaseViewController.h
//  BuFu
//
//  Created by 郑鹏 on 15/4/21.
//  Copyright (c) 2015年 Huifeng Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController


//获取导航栏高度（已废弃--04.25）
- (CGFloat)getNaviHeight;

//设置中间标题(新.NaviTitle,防止标签栏文字被替换--04.25)
- (void)setNaviTitle:(NSString *)title;

- (void)setNaviCenterView:(id)centerView;

//设置返回按钮
- (void)setBackButton;
//模态化返回
- (void)setBackButtonWithTitle:(NSString *)title;
- (void)clickDissmissButton;

//左边按钮(文字)
- (void)setLeftBtnWithTitle:(NSString *)title;
//左边按钮(图片)
- (void)setLeftBtnWithImageName:(NSString *)imageName;
- (void)leftButtonAction;

//右边按钮(文字)
- (void)setRightBtnWithTitle:(NSString *)title;
//右边按钮(图片)
- (void)setRightBtnWithImageName:(NSString *)imageName;
//右边按钮的点击事件
- (void)rightButtonAction;
- (void)setRightBtnDisEnabel;
- (void)setRightBtnEnabel;

//设置导航栏背景图(需要红色导航栏,非默认,需要红色导航栏时需要调用)
- (void)setNavibarBackImage;
//设置导航栏背景色(需要设置导航栏其他颜色,默认无需调用)
- (void)setNavibarBackGroundColor:(UIColor *)color;


@end










