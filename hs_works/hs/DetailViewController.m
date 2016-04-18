
//  DetailViewController.m
//  hs
//
//  Created by RGZ on 15/5/23.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "DetailViewController.h"




//财牛用户参与沪深A股交易合作涉及费用及资费标准
#define URLRULE_WANFA  [NSString stringWithFormat:@"%@/rule/wanfa.html",K_MGLASS_URL];
#define URLRULE_WANFA_A  [NSString stringWithFormat:@"%@/rule/wanfa_a.html",K_MGLASS_URL];

//财牛投资人与用户参与沪深A股交易合作协议

#define URLRULE_T1   [NSString stringWithFormat:@"%@/rule/t1.html",K_MGLASS_URL];
#define URLRULE_T1_A   [NSString stringWithFormat:@"%@/rule/t1_a.html",K_MGLASS_URL];



//合作协议",@"资费标准",@"充值协议",@"T+1规则
//玩法，交易，充值，提现

//关于我们
#define URLAboutUs      @"http://www.baidu.com"

//合作协议
#define URLPlayHelper     [NSString stringWithFormat:@"%@/rule/t1.html",K_MGLASS_URL]
 ;
#define URLPlayHelper_A  [NSString stringWithFormat:@"%@/rule/t1_a.html",K_MGLASS_URL]
//资费标准
#define URLBusiness    [NSString stringWithFormat:@"%@/rule/wanfa.html",K_MGLASS_URL]
#define URLBusiness_A    [NSString stringWithFormat:@"%@/rule/wanfa_a.html",K_MGLASS_URL]
//充值协议
//#define URLChargeMoeny  [NSString stringWithFormat:@"http://%@/rule/recharge.html",HTTP_IP];
//T+1规则
#define URLT1 [NSString stringWithFormat:@"%@/rule/agreement.html",K_MGLASS_URL]
#define URLT1_A [NSString stringWithFormat:@"%@/rule/agreement_a.html",K_MGLASS_URL]
//股票T+1参与规则
#define URLRule  [NSString stringWithFormat:@"http://%@/rule/t1.html",HTTP_IP];
#define URLRule_A  [NSString stringWithFormat:@"http://%@/rule/t1_a.html",HTTP_IP];
//充值服务协议
#define URLChargeMoney [NSString stringWithFormat:@"%@/rule/recharge.html",K_MGLASS_URL]
#define URLChargeMoney_A [NSString stringWithFormat:@"%@/rule/recharge_a.html",K_MGLASS_URL]





//沪金、期指、沪银协议
//资费
#define URL_AU_Charges        [NSString stringWithFormat:@"%@/rule/aumCost.html",K_MGLASS_URL]
//合作
#define URL_AU_Collaborate    [NSString stringWithFormat:@"%@/rule/aumProtocol.html",K_MGLASS_URL]

#define URL_IF_Charges        [NSString stringWithFormat:@"%@rule/IFmCost.html",K_MGLASS_URL]
#define URL_IF_Collaborate    [NSString stringWithFormat:@"%@/rule/IFmProtocol.html",K_MGLASS_URL]
#define URL_AG_Charges        [NSString stringWithFormat:@"%@/rule/aumCost.html",K_MGLASS_URL]
#define URL_AG_Collaborate    [NSString stringWithFormat:@"%@/rule/agmProtocol.html",K_MGLASS_URL]

@interface DetailViewController ()
{
    NSString    *_url;
    NSString    *_title;
    
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    [self loadNav];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [ MobClick beginLogPageView:@"帮助中心"];
    [self loadUI];
}

-(void)loadNav
{
//    NavTitle(_title);
    NSString * navTitle = [NSString stringWithFormat:@"%@协议",App_appShortName];
    [self setNavTitle:navTitle];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_1"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadData
{
//    NSString * niu = @"";
    int niuState = 0;
    
//#if defined (CAINIUA)
//    niuState = 1;
//    niu = @"牛A";
//    
//#elif defined (NIUAAPPSTORE)
//    niuState = 1;
//    niu = @"牛A";
//#else
//    niuState = 0;
//    niu = @"财牛";
//#endif
    
//    niu  = App_appShortName;
//    NSLog(@"%d",self.index);
    
    
    switch (self.index) {
            
        case 0:
        {
            _url=URLPlayHelper;
            if (niuState == 1) {
                _url=URLPlayHelper_A;
            }
            _title = self.otherTitle;
        }
            break;
        case 1:
        {
            _url=URLBusiness;
            if (niuState == 1) {
                _url=URLBusiness_A;
            }
            _title = self.otherTitle;
        }
            break;
        case 2:
        {
            _url=URLChargeMoney;
            if (niuState == 1) {
                _url=URLChargeMoney_A;
            }
            _title = self.otherTitle;
        }
            break;
        case 3:
        {
            _url=URLT1;
            if (niuState == 1) {
                _url=URLT1_A;
            }
            _title = self.otherTitle;
        }
            break;
        case 4:
        {
            _url=URLAboutUs;
            _title = self.otherTitle;
        }
            break;
        case 5:
        {
            _url=URLT1;
            if (niuState == 1) {
                _url=URLT1_A;
            }
            _title = self.otherTitle;
        }
            break;
        case 6:
        {
            _url=URLChargeMoney;
            if (niuState == 1) {
                _url=URLChargeMoney_A;
            }
            _title = self.otherTitle;
        }
            break;
        case 7:
        {
            _url=URLRULE_WANFA;
            
            if (niuState == 1) {
                _url=URLRULE_WANFA_A;
            }
            _title=[NSString stringWithFormat:@"沪深A股资费标准"];
        }
            break;
            
        case 8:
        {
            _url=URLRULE_T1;
            if (niuState == 1) {
                _url=URLRULE_T1_A;
            }
            _title=[NSString stringWithFormat:@"沪深A股合作协议"];
        }
            break;
        case 9:
        {
            _url=URL_AU_Collaborate;
            _title=@"沪金参与规则";
        }
            break;
        //沪金资费
        case 10:
        {
            _url=URL_AU_Charges;
            _title=self.otherTitle;
        }
            break;
        //沪金合作
        case 11:
        {
            _url=URL_AU_Collaborate;
            _title=self.otherTitle;
        }
            break;
        //期指资费
        case 12:
        {
            _url=URL_IF_Charges;
            _title=self.otherTitle;
        }
            break;
        //期指合作
        case 13:
        {
            _url=URL_IF_Collaborate;
            _title=self.otherTitle;
        }
            break;
        //沪银资费
        case 14:
        {
            _url=URL_AG_Charges;
            _title=self.otherTitle;
        }
            break;
        //沪银合作
        case 15:
        {
            _url=URL_AG_Collaborate;
            _title=self.otherTitle;
        }
            break;
            
        default:
            break;
    }
    
    if (self.isUseCustomURL) {
        _url = self.customURL;
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"帮助中心"];
    
    [[UIEngine sharedInstance] hideProgress];
}

-(void)loadUI
{
    
    [UIEngine sharedInstance].progressStyle=1;
    [[UIEngine sharedInstance] showProgress];
    
    [self performSelector:@selector(closeProgress) withObject:nil afterDelay:1];
    
    UIWebView   *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth-64)];
    [self.view addSubview:webView];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [webView loadRequest:request];
}

-(void)closeProgress
{
    [[UIEngine sharedInstance] hideProgress];
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
