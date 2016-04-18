//
//  SpotTransferSearchController.m
//  hs
//
//  Created by RGZ on 15/12/30.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "SpotTransferSearchController.h"

@interface SpotTransferSearchController ()
{
    UILabel     *_titleLabel;
    
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@end

@implementation SpotTransferSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadNav];
    
    [self loadWebView];
}

-(void)loadNav{
    Self_AddNavUnlessTitle(@"return_1");
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, ScreenWidth-100, 44)];\
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];

}

-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadWebView{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/activity/transRecord.html?token=%@&traderId=%@&cainiuToken=%@",HTTP_IP,[[SpotgoodsAccount sharedInstance] getSpotgoodsToken],[[SpotgoodsAccount sharedInstance] getTradeID],[[CMStoreManager sharedInstance] getUserToken]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    _titleLabel.text = title;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
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
