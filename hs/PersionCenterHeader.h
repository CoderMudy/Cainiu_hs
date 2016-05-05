//
//  PersionCenterHeader.h
//  hs
//
//  Created by RGZ on 15/5/18.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#ifndef hs_PersionCenterHeader_h
#define hs_PersionCenterHeader_h

#define APP_KEY_KEFU        @"c7431582fcc1692580fc14f0bed83097"

#define uUserInfoRealName   @"USERINFOREALNAME"
#define uUserInfoIdCard     @"USERINFOIDCARD"
#define uUserInfoNickStatus @"NICKSTATUS"
#define uPrivateUserInfo    @"PRIVATEUSERINFO"
#define uSystemDate         @"GETSYSTEMDATE"
#define uUserInfo           @"USERINFO_PERSIONCENTER"
#define uForgetGesture      @"FORGETGESTURE"
#define uOtherAccountLogin  @"OTHERACCOUNTLOGIN"
#define uPopRootAccountCenter @"POPROOTACCOUNTCENTER"
#define uCheckUserInfo      @"CheckUserInfo"
#define uFirstOpenClearLoginInfo    @"uFirstOpenClearLoginInfo"
#define uSpotgoodsLogin     @"uSpotgoodsLogin"

#define LoadingEng @"loadingendnotification"

//UDID
//#define UDID       [UUID getUUID]
#define UDID       [OpenUDID value]

//渠道
#define RegSourceCaiNiu     @"20000"
#define RegSourceCaiNiuA    @"40000"

//推广ID
#define ExtendID            @""

#define CAINIU  App_appShortName //@"财牛"

#define NIUA  App_appShortName //@"牛A"

#define AlertColor Color_Gold

//IP
#define HTTP_IP K_URL

//获取本地存储的用户信息
#define getUser_Info [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:uUserInfo]]
//存储用户信息
#define setUser_Info(__UserInfo) [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:__UserInfo] forKey:uUserInfo];\
[[NSUserDefaults standardUserDefaults] synchronize]

//存入UserDefaults
#define saveUserDefaults(__Value,__Key) \
[[NSUserDefaults standardUserDefaults] setObject:__Value forKey:__Key];\
[[NSUserDefaults standardUserDefaults] synchronize];

//取出UserDefaults
#define getUserDefaults(__Key) \
[[NSUserDefaults standardUserDefaults] objectForKey:__Key]

//显示 1个按钮
#define PersionShowAlert(__Title) \
[[UIEngine sharedInstance] showAlertWithTitle:__Title ButtonNumber:1 FirstButtonTitle:@"确认" SecondButtonTitle:@""];\
[UIEngine sharedInstance].alertClick=^(int index)\
{};

//返回按钮
#define BackButtonHeader ;
//系统BackBarButtonItem
//#define BackButtonHeader \
//UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];\
//backItem.title = @"";\
//self.navigationItem.backBarButtonItem = backItem;\

//分隔线顶头
#define HeaderDividers if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {[cell setSeparatorInset:UIEdgeInsetsZero];}if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {[cell setLayoutMargins:UIEdgeInsetsZero];}if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){[cell setPreservesSuperviewLayoutMargins:NO];}
//导航
#define NavTitle(__title) \
self.view.backgroundColor=[UIColor whiteColor];\
[self setNavLeftBut:NSPushMode];\
[self setNavTitle:__title];\
self.navigationController.navigationBarHidden=NO;\
self.rdv_tabBarController.tabBarHidden = YES;
//系统BackBarButtonItem
//#define NavTitle(__title) \
//self.navigationItem.title=__title;\
//self.view.backgroundColor=[UIColor whiteColor];\
//self.navigationController.navigationBarHidden=NO;\
//self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;\
//[self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];\
//self.rdv_tabBarController.tabBarHidden = YES;

#define addTextFieldNotification(__method) [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(__method) name:UITextFieldTextDidChangeNotification object:nil];


#define removeTextFileNotification [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];

//添加验证手势密码通知（忘记）
#define ShowGestureNotification [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGesture) name:uForgetGesture object:nil]

//验证手势密码(忘记)
//-(void)showGesture\
//{\
//    UserInfo    *userInfo = getUser_Info;\
//    userInfo.userGestureIsStart = @"0";\
//    userInfo.userGestureIsSetPWD = @"0";\
//    setUser_Info(userInfo);\
//    [self exit];\
//    self.rdv_tabBarController.selectedIndex = 2;\
//    [[NSNotificationCenter defaultCenter] postNotificationName:uPopRootAccountCenter object:nil];\
//}\
//- (void)resetDefaults {\
//    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];\
//    NSDictionary * dict = [defs dictionaryRepresentation];\
//    for (id key in dict) {\
//    if ([key isEqualToString:@"Environment"]) {\
//    }else{\
//        [defs removeObjectForKey:key];\
//    }\
//    }\
//    [defs synchronize];\
//}\
//-(void)exit\
//{\
//    NSString    *firstLoginStr = getUserDefaults(@"FirstLogin");\
//    [self resetDefaults];\
//    [[CMStoreManager sharedInstance]storeUserToken:nil];\
//    [self.navigationController popViewControllerAnimated:NO];\
//    saveUserDefaults(firstLoginStr, @"FirstLogin");\
//}

#define ShowGestureMethod   \
-(void)showGesture{\
    [self exit];\
}\
- (void)sendNotification\
{\
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"changePagePosition" object:self userInfo:nil]];\
}\
- (void)resetDefaults {\
    [[CMStoreManager sharedInstance]exitLoginClearUserData];\
}\
-(void)exit\
{\
    [self sendNotification];\
    NSString    *firstLoginStr = getUserDefaults(@"FirstLogin");\
    [self resetDefaults];\
    [[CMStoreManager sharedInstance] setbackgroundimage];\
    [[CMStoreManager sharedInstance] storeUserToken:nil];\
    [self.navigationController popToRootViewControllerAnimated:NO];\
    self.rdv_tabBarController.selectedIndex = 3;\
    saveUserDefaults(firstLoginStr, @"FirstLogin");\
}\

#pragma mark 清登录信息
#pragma mark -

#define ClearLoginInfoAndGoLogin \
LoginViewController *loginVC = [[LoginViewController alloc]init];\
loginVC.isNoBackBtn = YES;\
[_rdvTabBarController.viewControllers[_rdvTabBarController.selectedIndex] pushViewController:loginVC animated:NO];\

#define SpotgoodsLogin \
SpotgoodsWebController *spotVC = [[SpotgoodsWebController alloc]init];\
[_rdvTabBarController.viewControllers[_rdvTabBarController.selectedIndex] pushViewController:spotVC animated:NO];

#pragma mark 导航栏
#pragma mark -

#define Self_AddNavUnlessTitle(__LEFT_IMG_NAME__)\
Self_AddNavBGGround \
Self_AddNavLeftImg(__LEFT_IMG_NAME__)\

#define Self_AddNav(__TITLE,__LEFT_IMG_NAME__)\
Self_AddNavBGGround \
Self_AddNavTitle(__TITLE)\
Self_AddNavLeftImg(__LEFT_IMG_NAME__)

#define Self_AddNavTitle(__TITLE__) \
UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, ScreenWidth-100, 44)];\
titleLab.textColor = [UIColor whiteColor];\
titleLab.font = [UIFont systemFontOfSize:16];\
titleLab.textAlignment = NSTextAlignmentCenter;\
titleLab.text = __TITLE__;\
[self.view addSubview:titleLab];

#define Self_AddNavLeftImg(__ImageName__) \
UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 11, 25)];\
leftImg.image = [UIImage imageNamed:__ImageName__];\
[self.view addSubview:leftImg];\
UIButton *leftControl = [UIButton buttonWithType:UIButtonTypeCustom];\
leftControl.alpha = 0.5;\
leftControl.frame = CGRectMake(0, 20, 54, 44);\
[leftControl addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];\
[self.view addSubview:leftControl];

#define Self_AddNavRightImg(__ImageName__) \
UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 11, 25)];\
rightImg.image = [UIImage imageNamed:__ImageName__];\
[self.view addSubview:rightImg];\
UIButton *rightControl = [UIButton buttonWithType:UIButtonTypeCustom];\
rightControl.alpha = 0.5;\
rightControl.frame = CGRectMake(0, 20, 54, 44);\
[rightControl addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];\
[self.view addSubview:rightControl];

#define Self_AddNavRightTitle(__TITLE__) \
UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-95, 30, 75, 24)];\
rightLab.font = [UIFont systemFontOfSize:13];\
rightLab.textAlignment = NSTextAlignmentRight;\
rightLab.textColor = [UIColor whiteColor];\
rightLab.text = __TITLE__;\
[self.view addSubview:rightLab];\
UIButton *rightControl = [UIButton buttonWithType:UIButtonTypeCustom];\
rightControl.frame = CGRectMake(ScreenWidth-74, 20, 74, 44);\
[rightControl addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];\
[self.view addSubview:rightControl];

#define Self_AddNavBGGround \
UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];\
bgView.backgroundColor = K_color_NavColor;\
[self.view addSubview:bgView];

#define Self_AddCloseBtn \
UIButton *closeControl = [UIButton buttonWithType:UIButtonTypeCustom];\
closeControl.frame = CGRectMake(54, 20, 54, 44);\
[closeControl setTitle:@"关闭" forState:UIControlStateNormal];\
closeControl.titleLabel.font = [UIFont systemFontOfSize:15];\
[closeControl addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];\
[self.view addSubview:closeControl];

#define Go_SouthExchange_Login \
SpotgoodsWebController *spotgoodsController = [[SpotgoodsWebController alloc]init];\
spotgoodsController.otherPage = YES;\
[self.navigationController pushViewController:spotgoodsController animated:YES];

#define Go_SouthExchange_Logout \
SpotgoodsModel *spotgoodsModel  = [SpotgoodsAccount sharedInstance].spotgoodsModel;\
spotgoodsModel.spotgoodsToken   = @"";\
spotgoodsModel.httpToken        = @"";\
[SpotgoodsAccount sharedInstance].spotgoodsModel = spotgoodsModel;\
[CacheEngine setSpotgoodsInfoTradeID:@"" Token:@"" HTTPToken:@"" PassWord:@""];

#define Go_Future_Login \
FuturesWebController    *futureVC = [[FuturesWebController alloc]init];\
[self.navigationController pushViewController:futureVC animated:YES];

#define ReceiveMemaryWarning \
if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {\
if (self.isViewLoaded && !self.view.window)\
{\
    self.view = nil;\
}\
}

#pragma mark -

#define QQLink              @"http://stock.luckin.cn/activity/test.html"

#import "UIEngine.h"
#import "DataEngine.h"
#import "DataEngine+Futures.h"
#import "DataEngine+SpotGoods.h"
#import "DataEngine+Table.h"
#import "DataUsedEngine.h"
#import "NetReachability.h"
#import "CLLockVC.h"
#import "UserInfo.h"
#import "LoginViewController.h"
#import "CacheModel.h"
#import "CacheEngine.h"
#import "SystemSingleton.h"
#import "OpenUDID.h"
#import "SpotgoodsWebController.h"
#import "FuturesWebController.h"
#import "InfomationIndexPage.h"
#import "ControlCenter.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "WebView.h"
#import "EnvironmentConfiger.h"

#import "ConfigerPCH.pch"

#endif
