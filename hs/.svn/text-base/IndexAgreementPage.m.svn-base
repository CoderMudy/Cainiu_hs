//
//  IndexAgreementPage.m
//  hs
//
//  Created by PXJ on 15/12/3.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "IndexAgreementPage.h"
#import "IndexOrderController.h"

@interface IndexAgreementPage ()<UIWebViewDelegate>
@property (nonatomic,strong)NavView * nav;
@property (nonatomic,strong)UIWebView * webView;
@end

@implementation IndexAgreementPage

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initWebView];

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
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,64, ScreenWidth, ScreenHeigth-CGRectGetHeight(_nav.frame))];
    
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
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@",request.URL];
    urlString =[urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString=%@",urlString);
    
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    
   if ([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"goto"]){
        
        if ([urlComps[1] isEqualToString:@"gotoFuturesAgree"]){
            [self gotoFuturesAgree];
            
        }else if ([urlComps[1] isEqualToString:@"gotoStockAgree"])
        {
            [self gotoStockAgree];
            
        }else if ([urlComps[1] isEqualToString:@"gotoDisAgreeOrder"]){
            [self leftControlClick];
        }
    }
    return TRUE;
}
- (void)gotoFuturesAgree
{
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    cacheModel.tradeDic[self.productModel.tradeDicName][@"agreement"] = @"1";
    [CacheEngine setCacheInfo:cacheModel];
    
    IndexOrderController *orderVC = [[IndexOrderController alloc]init];
    orderVC.buyState = self.buyState;
    orderVC.mainState = self.mainState;
    orderVC.indexBuyModel = self.indexBuyModel;
    orderVC.canUse = self.canUse;
    orderVC.productModel = self.productModel;
    [self.navigationController pushViewController:orderVC animated:YES];
}
- (void)gotoStockAgree
{

}

//开始请求
- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    if (_name.length<=0) {
        
        
//        [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
        _nav.titleLab.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
        NSLog(@"%@",_nav.titleLab.text);
    }
}

//结束请求
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    
    [ManagerHUD hidenHUD];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error;
{
    NSLog(@"%@",error.localizedDescription);
}

-(void)dealloc{
    self.webView.delegate = nil;
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
