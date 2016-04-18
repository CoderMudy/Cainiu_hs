//
//  ActivityPage.m
//  hs
//
//  Created by PXJ on 15/8/7.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "ActivityPage.h"
#import "ActivityModel.h"
#import "AccountH5Page.h"
#import "LoginViewController.h"
#import "H5LinkPage.h"
#import "CouponsPage.h"
@interface ActivityPage ()<UIWebViewDelegate>
{
    NSString * _url;
    
}
@property (nonatomic,strong)NavView * nav;
@end

@implementation ActivityPage

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
    [self addToken];
    [self loadWebView];
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadNav];
}

-(void)addToken
{
    if ([[CMStoreManager sharedInstance] isLogin]) {
        _url = [NSString stringWithFormat:@"%@&token=%@",_activityModel.htmlUrl,[[CMStoreManager sharedInstance] getUserToken]];
    }else{
        _url = _activityModel.htmlUrl;
    }
}
-(void)loadNav
{
    _nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _nav.titleLab.text = _activityModel.titleName;
    [_nav.leftControl addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];
}

-(void)loadWebView
{
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64)];
    NSURL * url = [NSURL URLWithString:_url];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    _webView.delegate = self;
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}
#pragma mark UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if(title.length>0)
    {
        _nav.titleLab.text = title;

    }
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSURL *url = [request URL];
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:@"/activity/turntable"].location !=NSNotFound) {
        [self showShare];
    }
    
    if ([[url scheme] isEqualToString:@"goto"]) {
        //跳转账户
        if ([[url host] isEqualToString:@"account"]) {
            [self gotoAccout];
            return NO;
        }
    }
    NSString *urlString = [NSString stringWithFormat:@"%@",request.URL];
    urlString =[urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"objc"])
    {
        NSArray * itemArray = [(NSString *)urlComps[1] componentsSeparatedByString:@":/"];
        
        
        [self openHtml:itemArray[0] url:itemArray[1]];
    }else
        if ([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"goto"]){
            
            if ([urlComps[1] isEqualToString:@"gotoHall"]) {
                [self leftButtonClick];
            }else if([urlComps[1] isEqualToString:@"gotoCoupon"]){
                
                [self goCoupon];
            }else if([urlComps[1] isEqualToString:@"goLogin"]){
                
                [self goLogin];
                
            }else if ([urlComps[1] isEqualToString:@"gotoTaskCenter"]){
                
                [self gotoTastCenter];
            }
            return NO;
        }else
            if ([[NSString stringWithFormat:@"%@",request.URL] rangeOfString:@"cainiu:gotoTaskCenter"].location != NSNotFound) {
                
                if ([[CMStoreManager sharedInstance] isLogin]) {
                    
                    [self gotoTastCenter];
                }else {
                    PopUpView * loginAlertView = [[PopUpView alloc] initShowAlertWithShowText:@"请先登录" setBtnTitleArray:@[@"返回",@"登录"]];
                    [self.navigationController.view addSubview:loginAlertView];
                    loginAlertView.confirmClick = ^(UIButton * button){
                        switch (button.tag) {
                            case 66666:
                            {
                            }
                                break;
                            case 66667:
                            {
                                LoginViewController * loginVC = [[LoginViewController alloc] init];
                                [self.navigationController pushViewController:loginVC animated:YES];
                            }
                                break;
                            default:
                                break;
                        }
                    };
                }
                return NO;
            }
    return YES;
}
- (void)openHtml:(NSString *)title url:(NSString *)url
{
    H5LinkPage * vc = [[H5LinkPage alloc] init];
    vc.urlStr = [NSString stringWithFormat:@"%@/%@",K_MGLASS_URL,url];
    vc.hiddenNav = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)showShare
{
    [_nav.rightControl addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    _nav.rightLab.text = @"分享";
}
- (void)share
{
    NSString * url = [NSString stringWithFormat:@"%@/activity/share.html",K_MGLASS_URL];
    NSString * title = @"积分兑豪礼，100%中奖，更有苹果6S等你来拿";
    NSString * content = @"玩幸运大转盘，豪礼赚翻天。更有邀请好友送1000元现金，躺着也能把钱赚！";
    [PageChangeControl goShareWithTitle:title content:content urlStr:url imagePath:nil];
}
#pragma mark 去账户
- (void)gotoAccout
{
    self.rdv_tabBarController.selectedIndex = 3;
    [self.navigationController popToRootViewControllerAnimated:YES];

}
#pragma mark 去优惠券
- (void)goCoupon
{
    [self getUseUserCoupons];
}
#pragma mark 获取优惠券数量

- (void)getUseUserCoupons
{
    [RequestDataModel requestCouponsNumSuccessBlock:^(BOOL success, int couponsNum)
    {
        if (success)
        {
            CouponsPage *couponPage = [[CouponsPage alloc]init];
            couponPage.couponsNum = couponsNum;
            [self.navigationController pushViewController:couponPage animated:YES];
        }
    }];
}
#pragma mark 去登录
- (void)goLogin
{
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}
- (void)gotoTastCenter{
    self.rdv_tabBarController.selectedIndex = 2;
    AccountH5Page * vc = [[AccountH5Page alloc] init];
    vc.url= [NSString stringWithFormat:@"%@/activity/award.html?&abc=%u",K_MGLASS_URL,arc4random()%999];
    [self.rdv_tabBarController.viewControllers[2] pushViewController:vc animated:NO];
    [self.navigationController popToRootViewControllerAnimated:NO];
    
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
