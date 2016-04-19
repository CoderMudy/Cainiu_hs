//
//  HSBaseViewController.m
//  hs
//
//  Created by 杨永刚 on 15/5/16.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "HSBaseViewController.h"

@interface HSBaseViewController ()
{
    NSPushType _pushType;
    UIImageView * _backImageView;
}

@end

@implementation HSBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector: @selector(setEdgesForExtendedLayout:)] ) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
}
- (void)setTitleViewImage:(NSString *)imageName
{
   
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _backImageView.image = [UIImage imageNamed:imageName];
    self.navigationItem.titleView= _backImageView;
    
}

- (void)setNavTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 165,44)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:NavigationTitleFont];
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = title;
    self.navigationItem.titleView = label;
}

- (void)setNavLeftBut:(NSPushType)pushType
{
    _pushType = pushType;
    
    UIImage *leftButtonImage = [UIImage imageNamed:@"return_1.png"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftButton addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchDown];
    [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    leftButton.titleLabel.shadowColor = RGBACOLOR(117,38,0,1.0f);
    leftButton.titleLabel.shadowOffset= CGSizeMake(0, -1);
    leftButton.titleLabel.textColor = [UIColor whiteColor];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44/2-leftButtonImage.size.height/2, leftButtonImage.size.width, leftButtonImage.size.height)];
    image.image = [UIImage imageNamed:@"return_1"];
    image.userInteractionEnabled = YES;
    [leftButton addSubview:image];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftButtonPressed)];
    [image addGestureRecognizer:tap];
    
    UIBarButtonItem *leftbtn =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbtn;
}

- (void)setNavRigthBut:(NSString *)titleStr butImage:(UIImage *)butImage butHeigthImage:(UIImage *)heigtLigthImage select:(SEL)selector
{
    UIButton *rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBut.titleLabel setFont:[UIFont systemFontOfSize:14]];
    CGSize strSize = [titleStr sizeWithAttributes: @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}];
    [rightBut setFrame:CGRectMake(0, 0, strSize.width+10, 30)];
    if(butImage)[rightBut setFrame:CGRectMake(0, 0, butImage.size.width, butImage.size.height)];
    if(butImage)[rightBut setImage:butImage forState:UIControlStateNormal];
    if(heigtLigthImage)[rightBut setImage:heigtLigthImage forState:UIControlStateHighlighted];
    if(titleStr)[rightBut setTitle:titleStr forState:UIControlStateNormal];
    [rightBut addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBut];
}

- (void)leftButtonPressed;
{
    if (self.customLeft) {
        self.leftClick();
        return;
    }
    
    if (_pushType == NSPushMode) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (_pushType == NSPresentMode) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
    }
    if (_pushType == NSPushRootMode) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)rigthButtonPressed
{
    
}

@end
