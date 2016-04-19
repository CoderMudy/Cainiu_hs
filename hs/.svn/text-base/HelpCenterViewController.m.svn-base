//
//  HelpCenterViewController.m
//  hs
//
//  Created by RGZ on 15/5/21.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "HelpCenterViewController.h"
#import "DetailViewController.h"
#import "IndexViewController.h"
#import "H5LinkPage.h"
@interface HelpCenterViewController ()<UIWebViewDelegate>
{
    NSString * _webString;
}
@property (nonatomic,strong)UIWebView  * webView;

@end

@implementation HelpCenterViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden  = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    self.navigationController.navigationBarHidden = NO;
    self.rdv_tabBarController.tabBarHidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initNav];
    [self initUI];

}

- (void)initNav
{
    NavView * nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [nav.leftControl addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    nav.titleLab.text = @"帮助中心";
    [self.view addSubview:nav];
    

}
- (void)initUI
{
    _webString = [NSString stringWithFormat:@"%@/activity/helpCenter.html",K_MGLASS_URL];

    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth,ScreenHeigth-64)];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    NSURL * url = [NSURL URLWithString:_webString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}

- (void)leftClick:(id)sender
{

    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[NSString stringWithFormat:@"%@",request.URL] rangeOfString:_webString].location != NSNotFound) {
        return YES;
    }else{
        
        NSString * subURL =[NSString stringWithFormat:@"%@",request.URL];
        H5LinkPage * linkVC = [[H5LinkPage alloc] init];
        linkVC.hiddenNav = NO;
        linkVC.urlStr = subURL;
        NSString * linkTitle = [NSString stringWithFormat:@"%@协议",App_appShortName];
        linkVC.name = linkTitle;
        [self.navigationController pushViewController:linkVC animated:YES];
        return NO;
    }
    return YES;
}
-(void)dealloc{
    _webView.delegate = nil;
}


#pragma mark 表

//#pragma mark 其他按钮
//
//-(void)loadOtherButton{
//    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeigth-(ScreenWidth/3)/(195.0/119), ScreenWidth, (ScreenWidth/3)/(195.0/119))];
//    view.backgroundColor = [UIColor whiteColor];
//    view.alpha = 0.95;
//    [self.view addSubview:view];
//    
//    UIView  *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
//    lineView.backgroundColor = [UIColor lightGrayColor];
//    [view addSubview:lineView];
//    
//    UIButton *qqMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    qqMoreButton.frame = CGRectMake(0, 0, ScreenWidth/3, view.frame.size.height);
//    [qqMoreButton setImage:[UIImage imageNamed:@"help_center_01"] forState:UIControlStateNormal];
//    [qqMoreButton addTarget:self action:@selector(qqClick:) forControlEvents:UIControlEventTouchUpInside];
//    qqMoreButton.clipsToBounds = YES;
//    qqMoreButton.tag = 10;
//    qqMoreButton.layer.cornerRadius = 18;
//    [view addSubview:qqMoreButton];
//    
//    UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    qqButton.frame = CGRectMake(ScreenWidth/3, 0, ScreenWidth/3, view.frame.size.height);
//    [qqButton setImage:[UIImage imageNamed:@"help_center_02"] forState:UIControlStateNormal];
//    qqButton.clipsToBounds = YES;
//    qqButton.layer.cornerRadius = 18;
//    qqButton.tag = 11;
//    [qqButton addTarget:self action:@selector(qqClick:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:qqButton];
//    
//    UIButton *mobileButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    mobileButton.frame = CGRectMake(ScreenWidth/3*2, 0, ScreenWidth/3, view.frame.size.height);
//    [mobileButton setImage:[UIImage imageNamed:@"help_center_03"] forState:UIControlStateNormal];
//    mobileButton.clipsToBounds = YES;
//    mobileButton.layer.cornerRadius = 18;
//    [mobileButton addTarget:self action:@selector(mobileClick) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:mobileButton];
//}
//
//-(void)mobileClick{
//    
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"系统提示" message:@"您是否要拨打客服电话 400-6666-801 ?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alertView show];
//}
//
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 1) {
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://400-6666-801"]]];
//    }
//}

//-(void)qqClick:(UIButton *)btn{
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    if (btn.tag == 10) {
//        pasteboard.string = @"161925625";
//    }
//    else{
//        pasteboard.string = @"502078127";
//    }
//    
//    
//    [UIEngine showShadowPrompt:@"已添加到剪切板"];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
