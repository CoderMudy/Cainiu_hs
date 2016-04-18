//
//  InformationViewController.m
//  hs
//
//  Created by RGZ on 15/12/18.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "InformationViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "TokenObj.h"

@interface InformationViewController ()
{
    UIWebView   *_webView;
    //返回
    UIImageView *_leftImg;
    UIButton    *_leftControl;
    //title
    UILabel     *_titleLab;
    //url
    NSString    *_detailInfoURL;
    //分享
    UIImageView *_rightImg;
    UIButton    *_rightControl;
    
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@end

@implementation InformationViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.rdv_tabBarController.tabBarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNav];
    [self loadWeb];
}

-(void)loadNav{
    Self_AddNavBGGround;
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, ScreenWidth-100, 44)];
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.font = [UIFont systemFontOfSize:16];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.text = @"资讯详情";
    [self.view addSubview:_titleLab];
    
    [self showBack];
    
    [self showRightButton];
}

#pragma mark Back

-(void)showBack{
    _webView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64);
    self.rdv_tabBarController.tabBarHidden = YES;
    if (_leftImg == nil || _leftControl == nil) {
        _leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 11, 25)];
        _leftImg.image = [UIImage imageNamed:@"return_1"];
        [self.view addSubview:_leftImg];
        _leftControl = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftControl.alpha = 0.5;
        _leftControl.frame = CGRectMake(0, 20, 54, 44);
        [_leftControl addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_leftControl];
    }
}

-(void)leftClick{
    if ([_webView canGoBack] && ![_titleLab.text isEqualToString:@"资讯详情"]) {
        [_webView goBack];
    }
    else{
        [_progressView removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark Right

-(void)showRightButton{
    if (_rightImg == nil || _rightControl == nil) {
        _rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 15 - 25, 30, 25, 25)];
        _rightImg.image = [UIImage imageNamed:@"news_share"];
        [self.view addSubview:_rightImg];
        _rightControl = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightControl.alpha = 0.5;
        _rightControl.frame = CGRectMake(ScreenWidth - 15 - 25 - 15, 20, 54, 44);
        [_rightControl addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_rightControl];
    }
}

-(void)removeRightButton{
    if (_rightImg != nil) {
        [_rightImg removeFromSuperview];
        _rightImg = nil;
    }
    
    if (_rightControl != nil) {
        [_rightControl removeFromSuperview];
        _rightControl = nil;
    }
}

-(void)rightClick{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:App_shareIconName ofType:@"png"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",_detailInfoURL,@"&share=news"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@ %@",self.news.summary,url]
                                       defaultContent:[NSString stringWithFormat:@"%@ %@",self.news.summary,url]
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:[NSString stringWithFormat:@"%@",self.news.title]
                                                  url:url
                                          description:[NSString stringWithFormat:@"%@ %@",self.news.summary,url]
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess){
                                    [UIEngine showShadowPrompt:@"分享成功！"];
//                                    NSLog(NSLocalizedString(@"恭喜您，分享成功！", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail){
//                                    [UIEngine showShadowPrompt:@"尚未安装此应用，请下载后重试!"];
                                    NSLog(NSLocalizedString(@"分享失败", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}

#pragma mark UI

-(void)loadWeb{
    self.view.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:0.8];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth - 64)];
    _webView.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:0.8];
    _webView.delegate = self;
    _webView.scrollView.delegate = self;
    [self.view addSubview:_webView];
    
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    CGRect barFrame = CGRectMake(0, 0, ScreenWidth, 2);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webView addSubview:_progressView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/activity/newsDtl.html?id=%@",HTTP_IP,self.news.newsID]]];
    [_webView loadRequest:request];
    _detailInfoURL = [NSString stringWithFormat:@"%@",request.URL];
}

#pragma mark webview delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y <= 0) {
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
    
    if (scrollView.contentOffset.y + scrollView.bounds.size.height >= scrollView.contentSize.height) {
        [scrollView setContentOffset:CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height)];
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = [request URL];
    
    if ([[url scheme] isEqualToString:@"goto"]) {
        //返回
        if ([[url host] isEqualToString:@"goLogin"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:uFirstOpenClearLoginInfo object:nil];
        }
    }
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    _titleLab.text = title;
    
    //直接调用JS
//    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    NSString *alertJS=[NSString stringWithFormat:@"function getToken { return %@ ;}",[[CMStoreManager sharedInstance] getUserToken]];
//    [context evaluateScript:alertJS];
    
    //js调用iOS的方法（getToken）
//    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    context[@"getToken"] = ^() {
//    };
    
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    TokenObj *tokenoObj = [[TokenObj alloc] init];
    context[@"AppJs_iOS"]=tokenoObj;
    
    //评论不要分享
    if ([title isEqualToString:@"评论"]) {
        [self removeRightButton];
    }
    else{
        [self showRightButton];
    }
}

#pragma mark NJK Delegate

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
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
