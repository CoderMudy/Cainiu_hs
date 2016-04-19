//
//  LinkPage.m
//  hs
//
//  Created by PXJ on 15/8/19.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "H5LinkPage.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface H5LinkPage ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView * webView;
@property (nonatomic,strong)NavView * nav;
@end

@implementation H5LinkPage

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.name];
    self.rdv_tabBarController.tabBarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [ManagerHUD showHUD:self.view  animated:YES andAutoHide:5];


}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.name];
    self.navigationController.navigationBarHidden = NO;


}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = _name;
    [self initWebView];
    [self setNavLeftBut];

}
- (void)setNavLeftBut
{
    if (_hiddenNav) {
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 44, 44)];
        [leftButton addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchDown];
        [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
        leftButton.titleLabel.shadowColor = RGBACOLOR(117,38,0,1.0f);
        leftButton.titleLabel.shadowOffset= CGSizeMake(0, -1);
        leftButton.titleLabel.textColor = [UIColor whiteColor];
        [leftButton setTitle:@"返回" forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"return_1.png"] forState:UIControlStateNormal];
        [self.view addSubview:leftButton];
        
    }else
    {
        [self initNav];
    
  
    
    }

}
- (void)initNav
{
    _nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _nav.titleLab.text = self.name;
    [_nav.leftControl addTarget:self action:@selector(leftControlClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];

}
- (void)leftControlClick
{
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)initWebView{

    _webView = [[UIWebView alloc] init];
    if (_hiddenNav) {
        
        
        _webView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
    }else{
    
        _webView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64);

    }
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
- (void)leftButtonPressed
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    
    
    NSString *urlString = [[request URL] absoluteString];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString=%@",urlString);
    
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];

    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"objc"])
    {
        
        if ([urlComps[1] isEqualToString:@"callNavUIWithTitle:url:"]) {
            
            NSArray * itemArray = [(NSString *)urlComps[2] componentsSeparatedByString:@":/"];
            [self openHtml:itemArray[1] url:itemArray[0]];

            
        }else {
        
            [self openHtml:urlComps[1] url:urlComps[2]];

        }
        
        

       
    }else if ([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"goto"]){
    
        if ([urlComps[1] isEqualToString:@"goLogin"]) {
            
            [self goLogin];
        }else if ([urlComps[1] isEqualToString:@"gotoHall"]){
            [self goFoyerPage];
        
        }else if ([urlComps[1] isEqualToString:@"gotoSpread"])
        {
            [self goSpread];
        
        }else if ([urlComps[1] isEqualToString:@"gotoCoupon"]){
            [self goCoupon];
        
        }
    }
    return TRUE;
}

#pragma mark 结束请求

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (![title isEqualToString:@""]) {
        _nav.titleLab.text = title;
 
    }
}
#pragma mark 开始请求

- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    if (_name.length<=0) {
        
    
        [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
        _nav.titleLab.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
        NSLog(@"%@",_nav.titleLab.text);
    }
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error;
{
}

- (void)openHtml:(NSString *)title url:(NSString *)url
{
    H5LinkPage * vc = [[H5LinkPage alloc] init];
    vc.urlStr = [NSString stringWithFormat:@"%@/%@?version=8",K_MGLASS_URL,url];
    vc.hiddenNav = NO;
    vc.name = title;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goLogin
{

}
- (void)goFoyerPage
{

}
- (void)goSpread
{

}
- (void)goCoupon
{


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
