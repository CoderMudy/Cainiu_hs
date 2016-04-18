//
//  ActionCenter.m
//  hs
//
//  Created by PXJ on 16/1/20.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "ActionCenter.h"

@interface ActionCenter ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView * webView;
@property (nonatomic,strong)NavView * nav;
@end

@implementation ActionCenter

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
    self.rdv_tabBarController.tabBarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //    [ManagerHUD showHUD:self.view  animated:YES andAutoHide:5];
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
    self.navigationController.navigationBarHidden = NO;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addToken];
    [self initWebView];
    [self initNav];
    
}
- (void)initNav
{
    _nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _nav.titleLab.text = _titleNav;
    [_nav.leftControl addTarget:self action:@selector(leftControlClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];
    
}
- (void)leftControlClick
{
    if ([_webView canGoBack]) {
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

-(void)addToken
{
    if ([[CMStoreManager sharedInstance] isLogin]) {
        _urlStr = [NSString stringWithFormat:@"%@&token=%@",_urlStr,[[CMStoreManager sharedInstance] getUserToken]];
    }
}

- (void)initWebView{
    
    _webView = [[UIWebView alloc] init];
    _webView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64);
    _webView.delegate = self;
    if ([_urlStr rangeOfString:@"?"].location!=NSNotFound) {
        _urlStr = [NSString stringWithFormat:@"%@&abc=%d",_urlStr,arc4random()%999];
    }else{
        _urlStr = [NSString stringWithFormat:@"%@?abc=%d",_urlStr,arc4random()%999];
    }
    NSURL * url = [NSURL URLWithString:_urlStr];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    
    return TRUE;
}

#pragma mark 结束请求

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (![title isEqualToString:@""]) {
        _nav.titleLab.text = title;
        
    }}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error;
{
    NSLog(@"%@",error.localizedDescription);
}
-(void)dealloc{
    _webView.delegate = nil;
}

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
