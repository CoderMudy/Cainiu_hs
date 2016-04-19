//
//  FuturesWebController.m
//  hs
//
//  Created by RGZ on 15/12/23.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "FuturesWebController.h"
#import "PersionInfoViewController.h"
#import "NJKWebViewProgressView.h"
#import "AccountH5Page.h"
@interface FuturesWebController ()
{
    UILabel     *_titleLabel;
    
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    BOOL _isNeedNav;
}
@end

@implementation FuturesWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self  loadNav];
    [self  loadWebView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)loadNav{
    self.view.backgroundColor = [UIColor blackColor];
    Self_AddNavUnlessTitle(@"return_1");
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, ScreenWidth-100, 44)];\
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];
    
}

-(void)leftClick{
    if ([_titleLabel.text isEqualToString:@"南交所开户"]) {
        [[UIEngine sharedInstance] showAlertWithTitle:@"开户是否成功？" ButtonNumber:2 FirstButtonTitle:@"成功" SecondButtonTitle:@"失败"];
        [UIEngine sharedInstance].alertClick = ^(int aIndex){
            if (aIndex == 10086) {
                [self goBack];
            }
        };
    }
    else{
        [self goBack];
    }
}

-(void)goBack{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        Self_AddCloseBtn;
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)closeClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadWebView{
    NSURL   *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/activity/openAccount.html?token=%@",HTTP_IP,[[CMStoreManager sharedInstance] getUserToken]]];
    NSURLRequest    *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSURL *url = [request URL];
    NSMutableDictionary * urlParams =[Helper getParams:[url query]];
    _isNeedNav = [urlParams[@"isNeedNav"] boolValue];

    if ([[url scheme] isEqualToString:@"goto"]) {
        //退出登录
        if ([[url host] isEqualToString:@"logout"]) {
        }
        
        //返回
        if ([[url host] isEqualToString:@"back"]) {
            [self pop];
        }
        
        //注册完善资料
        if ([[url host] isEqualToString:@"goComplementInfo"]) {
            [self goPersionPage];
        }
        
        //财牛token过期，提示登录财牛
        if ([[url host] isEqualToString:@"getToken"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:uFirstOpenClearLoginInfo object:nil];
        }
        if ([[url host] isEqualToString:@"newH5"])
        {//打开新的H5
            NSString * urlStr = [NSString stringWithFormat:@"%@",url];
            NSString * link = [urlStr componentsSeparatedByString:@"link="][1];
            [self openNewH5WithLink:link];
        }
    }
    
    return YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"web Error");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    _titleLabel.text = title;
    NSLog(@"web finish");
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"web start");
}

-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)goPersionPage{
    PersionInfoViewController *persionVC = [[PersionInfoViewController alloc]init];
    [self.navigationController pushViewController:persionVC animated:YES];
}
#pragma mark 打开新的H5

/**
 *打开新的H5
 */
- (void)openNewH5WithLink:(NSString *)link
{
    NSString * url = [NSString stringWithFormat:@"%@%@",K_MGLASS_URL,link];
    AccountH5Page * newPage = [[AccountH5Page alloc] init];
    newPage.isNeedNav = _isNeedNav;
    newPage.isHaveToken = YES;
    newPage.url = url;
    [self.navigationController pushViewController:newPage animated:YES];
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
