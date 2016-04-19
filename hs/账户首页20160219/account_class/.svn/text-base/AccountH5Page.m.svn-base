//
//  AccountOpenPage.m
//  hs
//
//  Created by PXJ on 16/2/25.
//  Copyright © 2016年 luckin. All rights reserved.
//
typedef NS_ENUM(NSInteger, ActionType) {
    AtcionTypeDrawMoney = 0,
    ActionTypeRechargeMoney,
};

#import "AccountH5Page.h"
#import "CouponsPage.h"
#import "AliPayViewController.h"
#import "TransferMoneyViewController.h"
#import "RealNameViewController.h"
#import "AccountRechargeViewController.h"
#import "SubmitViewController.h"
#import "BankCardViewController.h"
#import "ApplyReasonPage.h"
#import "FindKeFuController.h"
#import "FoyerScorePage.h"

@interface AccountH5Page ()<UIWebViewDelegate>
{
    PrivateUserInfo   *_privateUserInfo;
    NSDictionary *submitDic;

}
@property (nonatomic, strong)NSNotification * notification;
@property (nonatomic,strong)NavView * nav;
@property (nonatomic,strong)UIWebView * webView;
@property (nonatomic,strong)UIImageView * stutesBarV;

@end

@implementation AccountH5Page

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addToken];
    [self initUI];
    _notification= [NSNotification notificationWithName:@"changePagePosition" object:self userInfo:nil];

    // Do any additional setup after loading the view.
}

-(void)addToken
{
    if ([[CMStoreManager sharedInstance] isLogin] && !_isHaveToken) {
        if ([_url rangeOfString:@"?"].location !=NSNotFound) {
            _url = [NSString stringWithFormat:@"%@&token=%@",_url,[[CMStoreManager sharedInstance] getUserToken]];
 
        }else{
            _url = [NSString stringWithFormat:@"%@?token=%@&abc=%@",_url,[[CMStoreManager sharedInstance] getUserToken],[Helper randomGet]];
        }
    }
}
- (void)initUI
{
    
    _nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _nav.hidden = YES;
    [_nav.leftControl addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];
  
    _stutesBarV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    [self.view addSubview:_stutesBarV];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeigth-20)];
    [self.view addSubview:_webView];
    
    _webView.scrollView.bounces = NO;
    _webView.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSURL * url = request.URL;
    NSString * urlStr = [NSString stringWithFormat:@"%@",request.URL];
//    if ( [urlStr rangeOfString:@"/account/banks.html"].location != NSNotFound) {
//        self.url = @"http://stock.cainiu.com/account/banks2.html";
//        [self addToken];
//        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
//        return NO;
//    }
//    
    
    if ([urlStr rangeOfString:@"goto://newH5?isNeedNav=1&link=/activity/send.html"].location !=NSNotFound) {
        self.url = [NSString stringWithFormat:@"%@/activity/send.html?isNeedNav=1",K_MGLASS_URL];
        [self addToken];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
        return NO;
    }
    
    urlStr =[urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([urlStr rangeOfString:@"qr.alipay.com"].location !=NSNotFound) {
        [[UIApplication sharedApplication] openURL:url];
//
//        while ([_webView canGoBack]) {
//            [_webView goBack];
//        }
//        return NO;
        self.url = [NSString stringWithFormat:@"%@/account/accCenter.html",K_MGLASS_URL];
        [self addToken];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
        return NO;
    }
    
    
    if ([urlStr rangeOfString:@"/activity/service"].location !=NSNotFound)
    {
        [self goKefu];
        return NO;
    }
    //是否是去大厅
    if ([[NSString stringWithFormat:@"%@",request.URL] rangeOfString:@":gotoHall"].location != NSNotFound)
    {
        [self goHall];
        return YES;
    }
    NSMutableDictionary * urlParams =[Helper getParams:[url query]];
    _isNeedNav = [urlParams[@"isNeedNav"] boolValue];

    if ([[url scheme] isEqualToString:@"goto"])
    {
        //登录
        if ([[url host] isEqualToString:@"drawMoney"])
        {//提现
            [self drawMoney];
        }else if ([[url host] isEqualToString:@"coupons"])
        {//优惠券
            [self getUseUserCoupons];
        }else if ([[url host] isEqualToString:@"alipay"])
        {//支付宝－－充值
            [self goAlipay];
        }else if ([[url host] isEqualToString:@"changePay"])
        {//转账汇款－－充值
            [self goChangePay];
        }else if ([[url host] isEqualToString:@"hall"])
        {//去行情大厅
            [self goHall];
        }
        else if ([[url host] isEqualToString:@"fangZfutures"])
        {//方正中期
            [self goFangZ];
        }
        else if ([[url host] isEqualToString:@"XHPage"])
        {//现货登录、开户
            NSString * query = [[request.URL query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dic = [Helper getParams:query];
            int status = [dic[@"status"] intValue];
            [self goXHPage:status];
        }else if ([[url host] isEqualToString:@"newH5"])
        {//打开新的H5
            NSString * urlStr = [NSString stringWithFormat:@"%@",url];
            NSString * link = [urlStr componentsSeparatedByString:@"link="][1];
            [self openNewH5WithLink:link];
        }else if ([[url host] isEqualToString:@"applyReason"])
        {//申请成为推广员 －－申请理由
            [self goApplyReason];
        }else if ([[url host] isEqualToString:@"share"])
        {
            //分享
            NSString * query = [[request.URL query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dic = [Helper getParams:query];
            [PageChangeControl goShareWithTitle:dic[@"title"] content:dic[@"content"] urlStr:dic[@"url"] imagePath:nil];
        }else if ([[url host] isEqualToString:@"scorePage"])
        {//去积分模拟
            [self goScorePage];
        }else if ([[url host] isEqualToString:@"goLogin"])
        {
            [self goLogin];
        }
    }else if ([[url scheme] isEqualToString:@"goback"])
    {
        if ([[url host] isEqualToString:@"last"])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }else if([[url host] isEqualToString:@"autoBack"])
        {
            [self autoBack];
        }
    }else if ([[url scheme] isEqualToString:@"tel"])
    {
        [self callWithTel:[url host]];
        return NO;
    }
    return YES;
}
- (void)goScorePage
{
    self.rdv_tabBarController.selectedIndex = 0;
    FoyerScorePage * vc = [[FoyerScorePage alloc] init];
    [self.rdv_tabBarController.viewControllers[0] pushViewController:vc animated:NO];
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}
#pragma mark 去登录
/**
 *去登录
 */
- (void)goLogin
{
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark-H5调用操作
#pragma mark 去客服
/**
 *去客服
 */
- (void)goKefu
{
    FindKeFuController * kefuVC = [[FindKeFuController alloc] init];
    [self.navigationController pushViewController:kefuVC animated:YES];
}
#pragma mark 打开新的H5

/**
 *打开新的H5
 */
- (void)openNewH5WithLink:(NSString *)link
{
    NSString * url = [NSString stringWithFormat:@"%@%@?isNeedNav=%@&token=%@",K_MGLASS_URL,link,_isNeedNav?@"1":@"0",[[CMStoreManager sharedInstance] getUserToken]];
    AccountH5Page * newPage = [[AccountH5Page alloc] init];
    newPage.isNeedNav = _isNeedNav;
    newPage.isHaveToken = YES;
    newPage.url = url;
    [self.navigationController pushViewController:newPage animated:YES];
}

- (void)loadNavWithHidden:(BOOL)isNeedNav
{
    if (isNeedNav)
    {
        _nav.hidden = NO;
        _webView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64);
        
    }else
    {
        _nav.hidden = YES;
        _webView.frame = CGRectMake(0, 20, ScreenWidth, ScreenHeigth-20);
     }
}
#pragma mark 申请理由页（申请成为推广员）
/**
 *申请理由页（申请成为推广员）
 */
- (void)goApplyReason
{
    ApplyReasonPage * vc = [[ApplyReasonPage alloc] init];
    vc.backBlock = ^(){
        [self reloadSelfWebView];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 到方正中期页
/**
 *到方正中期页
 */
- (void)goFangZ
{
    Go_Future_Login;
    
}
#pragma mark 到现货页
/**
 *到方\现货页
 */
- (void)goXHPage:(int)status
{
    SpotgoodsWebController *spotgoodsController = [[SpotgoodsWebController alloc]init];
    spotgoodsController.status = status;
    [self.navigationController pushViewController:spotgoodsController animated:YES];
}
#pragma mark H5返回原生
/**
 *H5返回原生
 */
- (void)goback
{
    if (_webView.canGoBack)
    {
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];

    }
}
- (void)autoBack
{
    if ([_webView canGoBack]) {
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark 出金
/**
 *
 */
- (void)drawMoney
{
    [self checkLoginPassWord];//继续登录密码认证的流程
}

#pragma mark 弹出验证登录密码的警告框
- (void)checkLoginPassWord
{
    
    
    
    __block PopUpView * inputAlertView = [[PopUpView alloc] initInpuStyleAlertWithTitle:@"验证登录密码" setInputItemArray:@[@"请输入登录密码"] setBtnTitleArray:@[@"取消",@"验证"]];
    inputAlertView.twoObjectblock = ^(UIButton *button,NSArray*array)
    {
        if (button.tag==66666)
        {
            [inputAlertView removeFromSuperview];
            inputAlertView = nil;
            
        }else{
            NSString * passWord = [NSString stringWithFormat:@"%@",array[0]];
            if ([passWord isEqualToString:@""])
            {
                [UIEngine showShadowPrompt:@"密码不能为空"];
            }else if(passWord.length<6)
            {
                [UIEngine showShadowPrompt:@"密码位数不能小于6位"];
            }else
            {
                [self clickCheckpassWord:passWord];
                [inputAlertView removeFromSuperview];
            }
        }
    };
    [self.navigationController.view addSubview:inputAlertView];
}
#pragma mark 验证登录密码
- (void)clickCheckpassWord:(NSString *)passWord
{
    
    passWord = [passWord MD5Digest];
    NSDictionary * reqDic = @{@"token":[[CMStoreManager sharedInstance]getUserToken],
                              @"password":passWord};
    NSString * urlStr = K_user_checkPassWord;
    
    __block int data;
    [NetRequest postRequestWithNSDictionary:reqDic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"]intValue]==200) {
            
            [UIEngine sharedInstance].progressStyle = 1;
            [[UIEngine sharedInstance] showProgress];
            [self authRealName:AtcionTypeDrawMoney];
            
        }else{
            if ((NSNull*)dictionary[@"data"] != [NSNull null] && dictionary[@"data"] != nil&&dictionary[@"data"]!=NULL) {
                data  = [dictionary[@"data"]==nil?@"0":dictionary[@"data"] intValue];
            }else{
                
                data = 1;
            }
            if ([dictionary[@"msg"]isEqualToString:@"您输入的密码超过3次错误,请重新登录"]) {
                
                data = 2;
                
            }
            
            PopUpView * showAlert = [[PopUpView alloc] initShowAlertWithShowText:dictionary[@"msg"] setBtnTitleArray:@[@"确定"]];
            showAlert.confirmClick = ^(UIButton* button){
                
                if (data==2) {
                    [self exitLogin];
                    LoginViewController * loginVC = [[LoginViewController alloc] init];
                    [self.navigationController pushViewController:loginVC animated:YES];
                }
            };
            [self.navigationController.view addSubview:showAlert];
        }
        
        
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        
    }];
    
}
-(void)exitLogin
{
    
    [self sendNotification];
    NSString    *firstLoginStr = getUserDefaults(@"FirstLogin");
    [self resetDefault];
    [[CMStoreManager sharedInstance] setbackgroundimage];
    [[CMStoreManager sharedInstance] storeUserToken:nil];
    saveUserDefaults(firstLoginStr, @"FirstLogin");
}
- (void)sendNotification
{
    [[NSNotificationCenter defaultCenter]postNotification:_notification];
}
- (void)resetDefault
{
    [[CMStoreManager sharedInstance]exitLoginClearUserData];
}

//验证真实姓名
-(void)authRealName:(int)type
{
    _privateUserInfo = [[PrivateUserInfo alloc] init];
    [DataEngine requestToAuthbindOfRealNameWithComplete:^(BOOL SUCCESS, NSString * status, NSString * realName, NSString * idCard) {
        if (SUCCESS) {
            if ([status isEqualToString:@"1"]||[status isEqualToString:@"2"]) {
                _privateUserInfo.statusRealName=status;
                _privateUserInfo.realName=realName;
                _privateUserInfo.idCard=idCard;
                [self authBankCard:type];
            }else{
                [[UIEngine sharedInstance] hideProgress];
                RealNameViewController *realVC=[[RealNameViewController alloc]init];
                realVC.isAuth=NO;
                realVC.isOtherPage=YES;
                if (type == ActionTypeRechargeMoney) {
                    realVC.isCharge = YES;
                }
                realVC.privateUserInfo=_privateUserInfo;
                realVC.block=^(PrivateUserInfo *privateUserInfo)
                {
                };
                BackButtonHeader;
                //                [self presentViewController:realVC animated:YES completion:nil];
                [self.navigationController pushViewController:realVC animated:YES];
            }
        }
        else
        {
            [[UIEngine sharedInstance] hideProgress];
            if (status.length>0) {
                [UIEngine showShadowPrompt:status];
            }
            else
            {
                //                [UIEngine showShadowPrompt:@"！您当前网络不佳，请稍后再试"];
            }
        }
    }];
}
//验证银行卡
-(void)authBankCard:(ActionType)type
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       VERSION,@"version",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"%@/user/user/checkBankCard",K_MGLASS_URL];
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        [[UIEngine sharedInstance] hideProgress];
        if ([dictionary[@"code"] integerValue] == 200) {
            
            if ([[NSString stringWithFormat:@"%@",dictionary[@"data"][@"status"]] isEqualToString:@"1"]||[[NSString stringWithFormat:@"%@",dictionary[@"data"][@"status"]] isEqualToString:@"2"]) {
                
                _privateUserInfo.bankCard = dictionary[@"data"][@"bankNum"];
                if (type == ActionTypeRechargeMoney) {
                    AccountRechargeViewController *rechargePage = [[AccountRechargeViewController alloc] init];
                    [rechargePage setNavLeftBut:NSPushMode];
//                    rechargePage.intoStatus = self.intoStatus;
                    rechargePage.bankCard = dictionary[@"data"][@"bankNum"];
                    [self.navigationController pushViewController:rechargePage animated:YES];
                }
                if (type ==  AtcionTypeDrawMoney) {
                    
                    submitDic = dictionary[@"data"];
                    
                    //======在这里判断用户第几次提现
                    //                    [self requestUserTixianNum];
                    
                    //=========
                    //                    if ([self.usedMoney floatValue]<20) {
                    //                        [UIEngine showShadowPrompt:@"可提现金额不足"];
                    //                    }
                    //                    else
                    //                    {
                    //
                    SubmitViewController *submitPage = [[SubmitViewController alloc] init];
                    submitPage.bankName = (NSString *)dictionary[@"data"][@"bankName"] ;
                    submitPage.bankCard = (NSString *)dictionary[@"data"][@"bankNum"] ;
                    submitPage.branName = (NSString *)dictionary[@"data"][@"branName"] ;
                    submitPage.cityName = (NSString *)dictionary[@"data"][@"cityName"] ;
                    submitPage.provName = (NSString *)dictionary[@"data"][@"provName"] ;
                    submitPage.ID = dictionary[@"data"][@"id"] ;
                    submitPage.usedMoney = self.usedMoney;
                    submitPage.privateUserInfo = _privateUserInfo;
                    [self.navigationController pushViewController:submitPage animated:YES];
                    
                    //                    }
                    
                }
                
            }else{
                [[UIEngine sharedInstance] hideProgress];
                BackButtonHeader
                BankCardViewController *bankVC=[[BankCardViewController alloc]init];
                bankVC.isBinding=NO;
                bankVC.isOtherPage=YES;
                if (type == ActionTypeRechargeMoney) {
                    bankVC.isCharge = YES;
                }
                bankVC.privateUserInfo=_privateUserInfo;
                bankVC.block=^(PrivateUserInfo *privateUserInfo)
                {
                    
                };
                [self.navigationController pushViewController:bankVC animated:YES];
            }
        }else{
            [[UIEngine sharedInstance] hideProgress];
            [[[iToast makeText:[dictionary objectForKey:@"msg"]] setGravity:iToastGravityCenter] show];
        }
    } failureBlock:^(NSError *error) {
        
        //        [UIEngine showShadowPrompt:@"！您当前网络不佳，请稍后再试"];
        [[UIEngine sharedInstance] hideProgress];
    }];
}
#pragma mark 支付宝
/**
 *  支付宝
 */
-(void)goAlipay{
    //_rechargeWay = 1;
    AliPayViewController *alipayCtrl = [[AliPayViewController alloc]init];
    [self.navigationController pushViewController:alipayCtrl animated:YES];
}
#pragma mark 转账汇款
/**
 *  转账汇款
 */
-(void)goChangePay{
    //转账汇款
    //_rechargeWay = 2;
    TransferMoneyViewController *tranCtrl = [[TransferMoneyViewController alloc]init];
    [self.navigationController pushViewController:tranCtrl animated:YES];
}
#pragma mark 跳转大厅
- (void)goHall
{
    self.rdv_tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}
#pragma mark- 获取优惠券数量

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

#pragma mark 拨号
- (void)callWithTel:(NSString*)tel
{
    [PageChangeControl callWithTel:tel];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self loadNavWithHidden:_isNeedNav];
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if(title.length>0)
    {
        _nav.titleLab.text = title;
        
    }
    NSString * urlStr = [NSString stringWithFormat:@"%@",webView.request.URL];
    //判断如果在财牛账户页statusBar为图片
    if ([urlStr rangeOfString:@"/account/accCenter.html"].location!=NSNotFound) {
        _stutesBarV.image = [UIImage imageNamed:@"userAccountStutesBar"];
    }else {
        _stutesBarV.image = nil;
        _stutesBarV.backgroundColor = K_color_red;
        
        
    }
    
    if ([urlStr rangeOfString:@"qr.alipay.com"].location !=NSNotFound)
    {
        [_webView goBack];
    }
}
- (void)reloadSelfWebView
{

    [_webView reload];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"%@",webView.request.URL);

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error.localizedDescription);
}
//
//-(NSMutableDictionary *)getParams:(NSString *)aParamsStr{
//    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithCapacity:0];
//    NSArray *carveArray = [aParamsStr componentsSeparatedByString:@"&"];
//    for (int i = 0; i < carveArray.count; i++) {
//        NSArray *array =[carveArray[i] componentsSeparatedByString:@"="];
//        if (array.count >= 2) {
//            [paramsDic setObject:array[1] forKey:array[0]];
//        }
//    }
//    return paramsDic;
//}
//

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
