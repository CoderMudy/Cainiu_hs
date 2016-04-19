//
//  QuickRechargeWebPage.m
//  hs
//
//  Created by PXJ on 15/8/3.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "QuickRechargeWebPage.h"
#import "AccountRechargeViewController.h"

@interface QuickRechargeWebPage ()<UIWebViewDelegate>
{
    UIProgressView * _progressView;


}
@end

@implementation QuickRechargeWebPage

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavTitle:@"充值"];
    [self setNavLeftBut];
    [self loadUI];
    
}

- (void)setNavLeftBut
{
    
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
- (void)leftButtonPressed
{
    
    self.superVC.appearStyle = 2;
    [self.navigationController popViewControllerAnimated:YES];
        
  
}

- (void)loadUI
{
    _progressView =[[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];

    [self.view addSubview:_progressView];
    UIWebView   *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 2, ScreenWidth, ScreenHeigth-66)];
    webView.delegate = self;
    [self.view addSubview:webView];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]];
    [webView loadRequest:request];

}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",request);
    NSLog(@"%@",request.mainDocumentURL.relativePath);
    
    if ([[NSString stringWithFormat:@"%@",request.URL] rangeOfString:@"cainiu:gotoMyAccount"].location != NSNotFound) {
        //成功
        
        if (self.intoStatus == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:uCheckUserInfo object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else if(self.intoStatus ==2){
            int count = (int)self.navigationController.viewControllers.count;
            UIViewController *vc = self.navigationController.viewControllers[count - 4];
            [self.navigationController popToViewController:vc animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        
        }
        
        
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@" 开始");
    _progressView.hidden = NO;
    _progressView.progress = 0.1;

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    NSLog(@"结束");
    if (_progressView) {
        _progressView.progress = 1;
        [self performSelector:@selector(removeProgressVie) withObject:self afterDelay:1];
    }
}
- (void)removeProgressVie
{
    _progressView.hidden = YES;



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
