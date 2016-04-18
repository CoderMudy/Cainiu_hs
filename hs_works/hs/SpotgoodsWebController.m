//
//  SpotgoodsWebControllerViewController.m
//  hs
//
//  Created by RGZ on 15/12/3.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "SpotgoodsWebController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SpotgoodsAccount.h"
#import "RealNameViewController.h"
#import "SpotTransferSearchController.h"
#import "CyberPay/CyberPayPlugin.h"

@interface SpotgoodsWebController ()<CyberPayPluginDelegate>
{
    UILabel     *_titleLabel;
    
    UILabel     *_rightLab;
    UIButton    *_rightControl;
    NSString    *_merId;//异度支付商户编号
    NSString    *_orderNo;//异度支付商户编号
}
@end

@implementation SpotgoodsWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadNav];
    [self loadWebView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.rdv_tabBarController.tabBarHidden = YES;
    /**
     *  保留上次页面信息
     *
     *  @param !
     *
     *  @return 
     */
//    if ([SpotgoodsAccount sharedInstance].isNeedRegist && self.webView != nil) {
//         [self.webView reload];
//    }
}

-(void)loadNav{
    self.view.backgroundColor = [UIColor blackColor];
    Self_AddNavUnlessTitle(@"return_1");
    
    _rightLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-95, 30, 75, 24)];
    _rightLab.font = [UIFont systemFontOfSize:13];
    _rightLab.textAlignment = NSTextAlignmentRight;
    _rightLab.textColor = [UIColor whiteColor];
    _rightLab.text = @"客服";
    [self.view addSubview:_rightLab];
    
    _rightControl = [UIButton buttonWithType:UIButtonTypeCustom];\
    _rightControl.frame = CGRectMake(ScreenWidth-74, 20, 74, 44);\
    [_rightControl addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];\
    [self.view addSubview:_rightControl];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, ScreenWidth-100, 44)];\
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];
}

-(void)leftClick{
    if ([_titleLabel.text isEqualToString:@"南交所开户"]) {
        [[UIEngine sharedInstance] showAlertWithTitle:@"确定要放弃开户吗？" ButtonNumber:2 FirstButtonTitle:@"放弃" SecondButtonTitle:@"继续"];
        [UIEngine sharedInstance].alertClick = ^(int aIndex){
            if (aIndex == 10086) {
                [self.progressView removeFromSuperview];
                [self.navigationController popViewControllerAnimated:YES];
            }
        };
    }
    else if ([_titleLabel.text isEqualToString:@"南交所信息"] ||
             [_titleLabel.text isEqualToString:@"南交所登录"]){
        [self.progressView removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
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
        [self.progressView removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)closeClick{
    [self.progressView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightClick{
    if ([_titleLabel.text isEqualToString:@"出金"] || [_titleLabel.text isEqualToString:@"入金"]) {
        SpotTransferSearchController    *spottransferSearchVC = [[SpotTransferSearchController alloc]init];
        [self.navigationController pushViewController:spottransferSearchVC animated:YES];
    }
    else{
        [PageChangeControl goKeFuWithSource:self];
    }
}

-(void)leftButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadWebView{
    NSURL *url = nil;
    
    if (self.status == 1) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/activity/register.html?token=%@",HTTP_IP,[[CMStoreManager sharedInstance] getUserToken]]];
    }
    else if (self.status == 2){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/activity/njsLogin.html?token=%@",HTTP_IP,[[CMStoreManager sharedInstance] getUserToken]]];
    }
    else{
        if ([SpotgoodsAccount sharedInstance].isNeedRegist) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/activity/register.html?token=%@",HTTP_IP,[[CMStoreManager sharedInstance] getUserToken]]];
        }
        else if ([SpotgoodsAccount sharedInstance].isNeedLogin) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/activity/njsLogin.html?token=%@",HTTP_IP,[[CMStoreManager sharedInstance] getUserToken]]];
        }
        else{
            //入金
            if (self.isDeposit) {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/activity/moneyIn.html?cainiuToken=%@&token=%@&traderId=%@",HTTP_IP,[[CMStoreManager sharedInstance] getUserToken],[[SpotgoodsAccount sharedInstance] getSpotgoodsToken],[[SpotgoodsAccount sharedInstance] getTradeID]]];
            }
            else{
                url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/activity/njsInfor.html?cainiuToken=%@&token=%@&index=%d",HTTP_IP,[[CMStoreManager sharedInstance] getUserToken],[[SpotgoodsAccount sharedInstance] getSpotgoodsToken],arc4random()%10000000]];
            }
        }
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    _titleLabel.text = title;
    
    if ([title isEqualToString:@"出金"] || [title isEqualToString:@"入金"]) {
        _rightLab.text = @"转账查询";
    }
    else{
        _rightLab.text = @"客服";
    }
    
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        context[@"spotgoodsLogined"] = ^() {
            NSArray *args = [JSContext currentArguments];
            if (args.count >= 4) {
                NSString *tradeID   = [DataUsedEngine nullTrimString:args[0]];
                NSString *token     = [DataUsedEngine nullTrimString:args[1]];
                NSString *httpToekn = [DataUsedEngine nullTrimString:args[2]];
                NSString *password  = [DataUsedEngine nullTrimString:args[3]];
                [self cacheWithToken:token
                             TradeID:tradeID
                           HTTPToken:httpToekn
                            Password:password];
            }
        };
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSURL *url = [request URL];
    
    if ([[url scheme] isEqualToString:@"goto"]) {
        //登录
        if ([[url host] isEqualToString:@"login"]) {
            NSMutableDictionary *params = [self getParams:[url query]];
            NSString *token     = [DataUsedEngine nullTrimString:params[@"token"]];
            NSString *tradeID   = [DataUsedEngine nullTrimString:params[@"tradeID"]];
            NSString *httpToekn = [DataUsedEngine nullTrimString:params[@"httptoken"]];
            NSString *password  = [DataUsedEngine nullTrimString:params[@"tradePass"]];
            [self cacheWithToken:token
                         TradeID:tradeID
                       HTTPToken:httpToekn
                        Password:password];
        }
        //入金
        if ([[url host] isEqualToString:@"cyberPay"]) {
            NSMutableDictionary *params = [self getParams:[url query]];
            _merId     = [DataUsedEngine nullTrimString:params[@"merid"]];
            _orderNo   = [DataUsedEngine nullTrimString:params[@"orderNo"]];
            [self sendPayDetail];
        }
        //退出登录
        if ([[url host] isEqualToString:@"logout"]) {
            [self logout];
        }
        
        //返回
        if ([[url host] isEqualToString:@"back"]) {
            [self pop];
        }
        
        //注册完善资料
        if ([[url host] isEqualToString:@"goComplementInfo"]) {
            [self goAuth];
        }
    }
    
    return YES;
}

#pragma mark 用户账户信息（是否开启财牛、积分、南交所账户）
-(void)requestToGetAccount{
    [RequestDataModel requestUserAccountsInfoSuccessBlock:^(BOOL success, id Info) {
        
    }];
}

#pragma mark 异度支付
-(void)sendPayDetail
{
    NSMutableDictionary * dicOrderInfo = [NSMutableDictionary dictionary];
    //添加订单信息，对应4.2.2.1字段关系对应说明
    [dicOrderInfo setObject:_merId forKey:@"MERID"];
    [dicOrderInfo setObject:_orderNo forKey:@"ORDERNO"];
#if TARGET_IPHONE_SIMULATOR
    //模拟器
#elif TARGET_OS_IPHONE
    [[CyberPayPlugin getInstance] enterPaymentController:dicOrderInfo withDelegate:self];

#endif
    

}
#pragma mark 异度支付——回调
-(void)payResultInfo:(NSString *)paycode {
    //参考4.2.2.2返回结果
    NSString * payValue;
    if([paycode isEqualToString:@"01"]){
        //成功结果处理
        payValue = @"A";
    }else if([paycode isEqualToString:@"02"]){
        //失败结果处理
        payValue = @"B";
    }else if([paycode isEqualToString:@"03"]){
        //取消支付请求
        payValue = @"C";
    }
    [self cyberPayFinishWithValue:payValue];
}
#pragma mark 异度支付——拿到支付结果反馈服务端
-(void)cyberPayFinishWithValue:(NSString *)payValue
{
    if(_merId.length<=0)
    {
        _merId = @" ";
    }
    if (_orderNo.length<=0) {
        _orderNo = @" ";
    }
    if (payValue.length<=0) {
        payValue = @" ";
    }
    NSDictionary * dic = @{@"merId":_merId,
                           @"orderNo":_orderNo,
                           @"orderState":payValue};
    [RequestDataModel feedbackServiceWithDic:dic successBlock:^(BOOL success) {
        NSLog(@"%d",success);
    }];
}
-(void)cacheWithToken:(NSString *)aToken TradeID:(NSString *)aTradeID HTTPToken:(NSString *)aHttpToken Password:(NSString *)aPassword{
    SpotgoodsModel *spotgoodsModel  = [[SpotgoodsModel alloc]init];
    spotgoodsModel.member           = aTradeID;
    spotgoodsModel.spotgoodsToken   = aToken;
    spotgoodsModel.httpToken        = aHttpToken;
    spotgoodsModel.password         = aPassword;
    
    [SpotgoodsAccount sharedInstance].spotgoodsModel = spotgoodsModel;
    [CacheEngine setSpotgoodsInfoTradeID:aTradeID Token:aToken HTTPToken:aHttpToken PassWord:aPassword];
    
    //行情开户登录后直接返回行情
    if (self.otherPage) {
        [RequestDataModel requestUserAccountsInfoSuccessBlock:^(BOOL success, id Info) {
            //获取账户信息(是否开户)
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

-(void)logout{
    //只清token
//    Go_SouthExchange_Logout
    
    //清除所有信息
    SpotgoodsModel *spotgoodsModel  = [SpotgoodsAccount sharedInstance].spotgoodsModel;
    spotgoodsModel.spotgoodsToken   = @"";
    spotgoodsModel.httpToken        = @"";
    spotgoodsModel.member           = @"";
    spotgoodsModel.password         = @"";
    [SpotgoodsAccount sharedInstance].spotgoodsModel = spotgoodsModel;
    [CacheEngine clearSpotgoodsInfo];
    
    [self pop];
}

-(void)pop{
    [self leftClick];
}

-(void)goAuth{
    RealNameViewController *realVC=[[RealNameViewController alloc]init];
    realVC.isAuth=NO;
    realVC.isOtherPage = YES;
    realVC.isNeedPop = YES;
    realVC.block=^(PrivateUserInfo *privateUserInfo){};
    [self.navigationController pushViewController:realVC animated:YES];
}

-(NSMutableDictionary *)getParams:(NSString *)aParamsStr{
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSArray *carveArray = [aParamsStr componentsSeparatedByString:@"&"];
    for (int i = 0; i < carveArray.count; i++) {
        NSArray *array =[carveArray[i] componentsSeparatedByString:@"="];
        if (array.count >= 2) {
            [paramsDic setObject:array[1] forKey:array[0]];
        }
    }
    return paramsDic;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"====error");
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
