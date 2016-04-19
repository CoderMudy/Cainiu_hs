//
//  FindKeFuController.m
//  hs
//
//  Created by RGZ on 15/12/18.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "FindKeFuController.h"
#import "AdviceViewController.h"

@interface FindKeFuController ()
{
    UIWebView   *_webView;
}
@end

@implementation FindKeFuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadNav];
    [self loadWeb];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.rdv_tabBarController.tabBarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
}

-(void)loadNav{
    Self_AddNav(@"我的客服", @"return_1");
}

-(void)leftClick{
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)loadWeb{
    UIView * statesBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    statesBarView.backgroundColor = K_color_NavColor;
    [self.view addSubview:statesBarView];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeigth - 20)];
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    [self.view addSubview:_webView];
    NSString * urlStr = [NSString stringWithFormat:@"%@/activity/service.html",K_MGLASS_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [_webView loadRequest:request];
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSURL *url = [request URL];
    NSLog(@"%@",url);
    if ([[url scheme] isEqualToString:@"goto"]) {
        //微客服
        if ([[url host] isEqualToString:@"appKeFu"]) {
            [self clickAppKeFu];
        }
        //qq客服
//        if ([[url host] isEqualToString:@"qqKeFu"]) {
//            [self clickQQKeFu];
//        }
    }else if ([[url scheme] isEqualToString:@"goback"])
    {
        if ([[url host] isEqualToString:@"last"])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else  if ([[url scheme] isEqualToString:@"goback"])
    {
        if ([[url host] isEqualToString:@"last"])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if ([_webView canGoBack]) {
        [_webView goBack];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        }else{
            [UIEngine showShadowPrompt:@"需要安装QQ聊天软件"];
        }
    }
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
}

- (void)goBack
{
    if ([_webView canGoBack]) {
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark clickAppKeFu客服
-(void)clickAppKeFu{
    
    if ([[CMStoreManager sharedInstance] isLogin]) {
        if (AppStyle_SAlE) {
            AdviceViewController * adviceVC = [[AdviceViewController alloc] init];
            [self.navigationController pushViewController:adviceVC animated:YES];
            return;
        }
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.text = [NSString stringWithFormat:@"%@投资客服",App_appShortName];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        
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
        

    }else{
        
        [[UIEngine sharedInstance] showAlertWithTitle:@"请先登录" ButtonNumber:2 FirstButtonTitle:@"返回" SecondButtonTitle:@"登录"];
        [UIEngine sharedInstance].alertClick = ^(int aIndex){
            if (aIndex == 10087) {
                LoginViewController * loginVC = [[LoginViewController alloc] init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        };
    }
}

#pragma mark qq客服

-(void)clickQQKeFu{
    //客服qq
//    UIWebView *qqwebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64)];
//    NSURL   *url = [NSURL URLWithString:@"mqq://im/chat?chat_type=wpa&uin=4006666801&version=1&src_type=web"];
//    NSURL *url = [NSURL URLWithString:QQLink];//mqq://im/chat?chat_type=wpa&uin=800026344&version=1&src_type=web
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [qqwebView loadRequest:request];
//    qqwebView.scrollView.delegate = self;
//    [self.view addSubview:qqwebView];
}

-(void)leftButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    _webView.delegate = nil;
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
