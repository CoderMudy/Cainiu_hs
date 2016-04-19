//
//  AppDelegate.m
//  hs
//
//  Created by hzl on 15/5/6.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "AppDelegate.h"
#import "FinacPage.h"
#import "FindPage.h"
#import "AccountPage.h"
#import "InfomationIndexController.h"
#import "h5DataCenterMgr.h"
#import "NetRequest.h"
#import "WelcomePageView.h"
#import "FoyerPage.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"

#import "UMessage.h"
#import "UMCheckUpdate.h"
#import "LoginViewController.h"

#import "SystemMsgDetailPage.h"
#import "TraderRemindPage.h"

#import "UMOnlineConfig.h"

#define alertView_update_Tag 100000

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

@interface AppDelegate ()<UIAlertViewDelegate>
{
    /**
     *  系统时间戳
     */
    long long       systemTimeInterval;
    /**
     *  本地时间戳
     */
    long long       locationTimeInterval;
    /**
     *  跑秒Timer
     */
    NSTimer         *_timer ;
    BOOL            _isbackground;
    NSDictionary    *_userInfoDic;//推送信息
    
    NSString        *_updatePath;
    
}
@property (nonatomic,strong)RDVTabBarController *rdvTabBarController;
/**
 *  按Home键时的时间戳
 */
@property (nonatomic,assign)int inBackgroundCount;

@end

@implementation AppDelegate

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation );
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * strDeviceToken =[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                stringByReplacingOccurrencesOfString: @" " withString: @""];
    //    NSLog(@"DeviceToken=%@",strDeviceToken);
    [[CMStoreManager sharedInstance] setUmengCode:strDeviceToken];
    
    [UMessage registerDeviceToken:deviceToken];
    
#if DEBUG
    
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken success");
    
    NSLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
#endif
    
    //    NSMutableString *mailUrl = [[NSMutableString alloc]init];
    //    //添加收件人
    //    NSArray *toRecipients = [NSArray arrayWithObject: @"542232567@qq.com"];
    //    [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];
    //    //添加主题
    //    [mailUrl appendFormat:@"&subject=%@",strDeviceToken];
    //    //添加邮件内容
    //    //[mailUrl appendString:@"&body=<b>email</b> body!"];
    //    NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    //    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
    //

}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
 
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
    
}

////开着程序时收到处理，还有一种就是点击收到的通知时会执行该事件。接受服务器消息并改变客户端本地状态（如在app图表显示带数字的小红圈）
//- (void)appUpdate:(NSDictionary *)appInfo
//{
//    NSLog(@"check update %@",appInfo);
//}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    __block NSString * str = userInfo[@"message_type"];//(1:系统消息，2:交易提醒)
    __block NSString * level = userInfo[@"level"];
    __block NSString * content = userInfo[@"content"];
    
    _userInfoDic = userInfo;
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        
        
        NSUInteger selectNum = self.rdvTabBarController.selectedIndex;
        UINavigationController *nav0 = (UINavigationController *)[[(RDVTabBarController *)[UIEngine getCurrentRootViewController] viewControllers] objectAtIndex:selectNum];
        if ([level isEqualToString:@"1"])
        {
            
            NSString * alertTitle;
            if ([str isEqualToString:@"1"]) {
                
                alertTitle = @"系统消息";
                
            }else{
                
                alertTitle  =@"交易提醒";
                
            }
            
            PopUpView * pushMessageAlertView = [[PopUpView alloc] initShowAlertWithTitle:alertTitle setShowText:content showLine:2 setBtnTitleArray:@[@"我知道了",@"查看消息"]];
            pushMessageAlertView.popUpViewStyle = popUpViewStyleShow;
            pushMessageAlertView.confirmClick=^(UIButton*button){
                if (button.tag==66666) {
                    
                    
                }else{
                    
                    [self pageChange];
                    
                }
            };
            
            [nav0.view addSubview:pushMessageAlertView];
        }
    }
}

- (void)pageChange
{
    NSUInteger selectNum = self.rdvTabBarController.selectedIndex;
    UINavigationController *nav0 = (UINavigationController *)[[(RDVTabBarController *)[UIEngine getCurrentRootViewController] viewControllers] objectAtIndex:selectNum];
    
    
    NSString * str = _userInfoDic[@"message_type"];//(1:系统消息，2:交易提醒)
    NSString * messageId = _userInfoDic[@"messageId"];
    if ([str isEqualToString:@"1"]) {
        //跳转系统消息
        SystemMsgDetailPage * systemMsgDetailVC = [[SystemMsgDetailPage alloc] init];
        systemMsgDetailVC.messageId = messageId;
        systemMsgDetailVC.isPush = YES;
        [[(UIViewController*)nav0.viewControllers.lastObject navigationController] pushViewController:systemMsgDetailVC animated:YES];
    }else if([str isEqualToString:@"2"]){
        //交易提醒
        TraderRemindPage * traderRemindVC = [[TraderRemindPage alloc] init];
        [[(UIViewController*)nav0.viewControllers.lastObject navigationController] pushViewController:traderRemindVC animated:YES];
    }
    
    
    
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    //TabBar
    [self setupViewControllers];
    [self.window setRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
    [self customizeInterface];
    
    [UIView setAnimationsEnabled:YES];
    
    //初始化
    [self initData];
    
    //加载默认环境
    [self loadEnvironment];
    
    //阿里云环境配置文件下载
    [DataEngine requestToDownloadEnvironmentFile];
    
    //加载注销登录通知
    [self loadNotification];
    
    //是否首次进入
    [self loadFirstIntoConfiger];
    
    //获取系统时间
    [self loadTime];
    
    //获取系统时间
    [self getSystemDate];
    
    //导航配置
    [self loadNavConfiger];
    
    //友盟
    [self loadUMWithDidFinishLaunchingWithOptions:launchOptions];
    
    //*******************Share
    [self loadShareConfiger];
    
    //**********************网络
    [self loadCheckNet];
    
    //加载欢迎页
    [self loadWelcome];
    
    //显示控制
    [self showControl];
    
    //系统判断第三方登录
//    [self loadThirdLogin];
    
    
    return YES;
}

-(void)initData{
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    BOOL isExists = [fileManager fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Cache/"]]];
    if (isExists == NO) {
        [fileManager createDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Cache/"]] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    if (cacheModel == nil) {
        cacheModel = [[CacheModel alloc]init];
        [CacheEngine setCacheInfo:cacheModel];
    }
}

#pragma mark Show Control

-(void)showControl{
    //显示控制
    /*
     clear   清仓   1清 其余不清
     "cots": "1",  账户中心的现货开户
     "kline": "1" K线是否显示
     alipay 支付宝展示 1展示  其余不展示
     */
    [ControlCenter sharedInstance].alipay = @"";
    [ControlCenter sharedInstance].kline = @"1";
    [ControlCenter sharedInstance].cots = @"";
    [ControlCenter sharedInstance].clear = @"";
    
    [DataEngine requestToGetShowControlWithCompleteBlock:^(BOOL SUCCESS, NSDictionary *data) {
        if (SUCCESS) {
            [ControlCenter sharedInstance].alipay = [DataUsedEngine nullTrimString:data[@"alipay"]];
            [ControlCenter sharedInstance].kline = [DataUsedEngine nullTrimString:data[@"kline"]];
            [ControlCenter sharedInstance].cots = [DataUsedEngine nullTrimString:@"1"];
            [ControlCenter sharedInstance].clear = [DataUsedEngine nullTrimString:data[@"clear"]];
        }
    }];
}

#pragma mark Notification

-(void)loadNotification{
    //财牛登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearLoginInfoAndGoLogin) name:uFirstOpenClearLoginInfo object:nil];
    //现货登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(spotgoodsLogin) name:uSpotgoodsLogin object:nil];
}

-(void)spotgoodsLogin{
    SpotgoodsLogin
}

-(void)clearLoginInfoAndGoLogin{
    ClearLoginInfoAndGoLogin
}

#pragma mark 首次进入配置

-(void)loadFirstIntoConfiger{
    if ([getUserDefaults(@"FirstLogin") isEqualToString:@""]||getUserDefaults(@"FirstLogin")==nil) {
        saveUserDefaults(@"NO", @"FirstLogin");
    }
}

#pragma mark 跑秒和市场状态数据配置

-(void)loadTime{
    systemTimeInterval = 0;
    locationTimeInterval = 0;
}

#pragma mark 环境配置

-(void)loadEnvironment{
    /**
     *  第一次加载时写死IP/域名，存入缓存
     *  之后从缓存中获取
     */
    NSString  * str =App_HTTP_IP_ONLINE;
    NSString * str1 = App_HTTP_IP_TEST;
    NSString * str2 = App_HTTP_IP_SIMULATE;
    if ([CacheEngine getEnvironmentHTTP_IP_ONLINE] == nil || [[CacheEngine getEnvironmentHTTP_IP_ONLINE] isKindOfClass:[NSNull class]]) {
        [[EnvironmentConfiger sharedInstance] setHTTP_IP_ONLINE:App_HTTP_IP_ONLINE];
    }
    else{
        [[EnvironmentConfiger sharedInstance] setHTTP_IP_ONLINE:[CacheEngine getEnvironmentHTTP_IP_ONLINE]];
    }
    
    if ([CacheEngine getEnvironmentHTTP_IP_TEST] == nil || [[CacheEngine getEnvironmentHTTP_IP_TEST] isKindOfClass:[NSNull class]]) {
        [[EnvironmentConfiger sharedInstance] setHTTP_IP_TEST:App_HTTP_IP_TEST];
    }
    else{
        [[EnvironmentConfiger sharedInstance] setHTTP_IP_TEST:[CacheEngine getEnvironmentHTTP_IP_TEST]];
    }
    
    if ([CacheEngine getEnvironmentHTTP_IP_SIMULATE] == nil || [[CacheEngine getEnvironmentHTTP_IP_SIMULATE] isKindOfClass:[NSNull class]]) {
        [[EnvironmentConfiger sharedInstance] setHTTP_IP_SIMULATE:App_HTTP_IP_SIMULATE];
    }
    else{
        [[EnvironmentConfiger sharedInstance] setHTTP_IP_SIMULATE:[CacheEngine getEnvironmentHTTP_IP_SIMULATE]];
    }
    
    if([[CMStoreManager sharedInstance]getEnvironment]==nil){
        [[CMStoreManager sharedInstance] setEnvironment:[EnvironmentConfiger sharedInstance].HTTP_IP_ONLINE];
    }
    
    [[EnvironmentConfiger sharedInstance] setCurrentSection];
}

#pragma mark 导航配置

-(void)loadNavConfiger{
    UIColor *navcolor = K_color_NavColor;
    [[UINavigationBar appearance] setBarTintColor:navcolor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundColor:K_color_NavColor];
    //@{}代表Dictionary
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    double  version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version>=8.0) {
        [UINavigationBar appearance].translucent = NO;//如果系统版本号低于8.0导航的透明度不设置；
    }
}

- (NSString * )getAppkey
{
    NSString * appkey ;
    
#if defined (CAINIUAPPSTORE)
    appkey =@"55bacc3e67e58e36ed0005e4";// cainiu app strore
    //    NSLog(@"umeng CAINIUAPP");
#elif defined (CAINIUCPS)
    appkey =@"568e556ee0f55a4c5200057f";
#else
    appkey =@"556ff33167e58e3c87001727";// cainiu com test企业版
    //    NSLog(@"umeng else");
#endif
    
    return appkey;
}

- (void)upDate:(NSDictionary*)dic

{
    NSLog(@"%@",dic);
    
    if ([dic[@"update"] boolValue]) {
       
        _updatePath = [NSString stringWithFormat:@"%@",dic[@"path"]];
        NSString * updateStr = [NSString stringWithFormat:@"%@",dic[@"update_log"]];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"有新版本，请前往更新" message:updateStr delegate:self cancelButtonTitle:@"升级" otherButtonTitles:nil, nil];
        alert.delegate = self;
        alert.tag = alertView_update_Tag;
        [alert show];
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==alertView_update_Tag) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_updatePath]];
        exit(0);
        
    }
}


#pragma mark 配置友盟统计

-(void)loadUMWithDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
#pragma mark 打开股票长链接
//    [[h5DataCenterMgr sharedInstance] createSession];
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    NSString * appkey= @"";
#if defined (SELF)
    appkey = [self getAppkey];
#else
    appkey =[SystemDataMgr  umengAppkey];
#endif
    
    /**
     *  添加友盟统计
     */
    [MobClick startWithAppkey:appkey reportPolicy:BATCH   channelId:@"App Store"];
    /**
     *  友盟在线参数
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    [UMOnlineConfig updateOnlineConfigWithAppkey:appkey];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    [UMCheckUpdate checkUpdateWithDelegate:self selector:@selector(upDate:) appkey:appkey channel:@"App Store"];
    
    #if DEBUG
        [MobClick setLogEnabled:YES];
    #endif

    [UMessage startWithAppkey:appkey launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types (iOS 8.0以下)
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    //for log
    [UMessage setLogEnabled:YES];
    
}
/**
 *  友盟在线参数获取成功
 *
 *  @param notification
 */
- (void)onlineConfigCallBack:(NSNotification *)notification {
    NSString    *online = notification.userInfo[@"HTTP_IP_ONLINE"];
    NSString    *test   = notification.userInfo[@"HTTP_IP_TEST"];
    NSString    *simulate   = notification.userInfo[@"HTTP_IP_SIMULATE"];
    
    if (online == nil && test == nil) {
        return;
    }
    
    [[EnvironmentConfiger sharedInstance] setUmHTTP_IP_ONLINE:online];
    [[EnvironmentConfiger sharedInstance] setUmHTTP_IP_TEST:test];
    [[EnvironmentConfiger sharedInstance] setUmHTTP_IP_SIMULATE:simulate];
    [[EnvironmentConfiger sharedInstance] setHTTP_IP_ONLINE:online];
    [[EnvironmentConfiger sharedInstance] setHTTP_IP_TEST:test];
    [[EnvironmentConfiger sharedInstance] setHTTP_IP_SIMULATE:simulate];
    [[EnvironmentConfiger sharedInstance] setCurrentSection];
    /**
     *  3个环境存入缓存
     */
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UMOnlineConfigDidFinishedNotification object:nil];
}

#pragma mark 加载分享配置

-(void)loadShareConfiger{
    //*******************Share
    NSString * shareAppkey =App_shareSDKAppkey;
    NSString * qzoneAPPKey = App_qZoneAppkey;
    NSString * qzoneAPPSecret  = App_qZoneSecret;
    NSString * wxAppkey = App_weChatAppkey;
    NSString * wxAppsecret = App_weChatSecret;
    NSString * weiboAppkey = App_sinaWeiboAppkey;
    NSString * weiboAppSecret = App_sinaWeiboAppSecret;
    NSString * weiboAppUri = App_sinaWeiboRedirectUri;
    
//    NSLog(@"shareAppkey:%@\n qzoneAPPKey:%@\nqzoneAPPSecret:%@\nwxAppkey:%@\nwxAppsecret:%@\nweiboAppkey:%@\nweiboAppSecret:%@\nweiboAppUri:%@",shareAppkey,qzoneAPPKey,qzoneAPPSecret,wxAppkey,wxAppsecret,weiboAppkey,weiboAppSecret,weiboAppUri);
    
    
    [ShareSDK registerApp:shareAppkey];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:qzoneAPPKey
                           appSecret:qzoneAPPSecret
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:qzoneAPPKey
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //添加微信应用（注意：微信分享的初始化，下面是的初始化既支持微信登陆也支持微信分享，只用写其中一个就可以） 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:wxAppkey
                           wechatCls:[WXApi class]];
    //微信登陆的时候需要初始化
    [ShareSDK connectWeChatWithAppId:wxAppkey
                           appSecret:wxAppsecret
                           wechatCls:[WXApi class]];
    
    // 填写新浪微博的回调地址
    [ShareSDK connectSinaWeiboWithAppKey:weiboAppkey
                               appSecret:weiboAppSecret
                             redirectUri:weiboAppUri];

    //连接邮件
    [ShareSDK connectMail];
}

#pragma mark 加载监视网络

-(void)loadCheckNet{
    //**********************网络
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:nReachabilityChangedNotification object:nil];
    self.conn = [NetReachability reachabilityForInternetConnection];
    [self.conn startNotifier];
}

#pragma mark 加载欢迎页

-(void)loadWelcome{
    //加载欢迎页
    if([CacheEngine isFirstInfo]){
        [self loadWelcomePage];
        [CacheEngine firstInfo];
    }
}

#pragma mark 第三方登录

-(void)loadThirdLogin{
    //系统判断第三方登录
    [DataEngine requestCompleteBlock:^(NSString * data) {
        [CacheEngine setLoginStatus:data];
    } failBlock:^(NSString * data) {
        [CacheEngine setLoginStatus:data];
    }];
}

- (void)appUpdate:(NSDictionary *)appInfo
{
    //    NSLog(@"%@",appInfo);
}

#pragma mark 环境切换

- (void)changeEnvironment:(NSString *)str
{
    NSString * string = [NSString stringWithFormat:@"%@",str];
    [[CMStoreManager sharedInstance] setEnvironment:string];
}

- (void)dealloc
{
    [self.conn stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

void UncaughtExceptionHandler(NSException *exception)
{
//    NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
//    NSString *reason = [exception reason];//非常重要，就是崩溃的原因
//    NSString *name = [exception name];//异常类型
    
    //    NSLog(@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr);
}
#pragma mark - TabBar--Setting
#pragma mark -

- (void)setupViewControllers {
    FoyerPage *foyerPage = [[FoyerPage alloc] init];
    HSNavigationController *foyerPageNav = [[HSNavigationController alloc]
                                            initWithRootViewController:foyerPage];
    
    FindPage *findPage = [[FindPage alloc] init];
    HSNavigationController *findPageNav = [[HSNavigationController alloc]
                                           initWithRootViewController:findPage];
    
    AccountPage *userPage = [[AccountPage alloc] init];
    HSNavigationController *userPageNav = [[HSNavigationController alloc]
                                           initWithRootViewController:userPage];
    
//    UINavigationController *informationNav = [[UINavigationController alloc]initWithRootViewController:
//                                              [[InfomationIndexPage alloc]init]];
    UINavigationController *informationNav = [[UINavigationController alloc]initWithRootViewController:
                                              [[InfomationIndexController alloc]init]];
   _rdvTabBarController = [[RDVTabBarController alloc] init];
    [_rdvTabBarController setViewControllers:@[foyerPageNav,informationNav,findPageNav,
                                               userPageNav]];
    
    UIView * backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    //    backView.frame = tabBarController.tabBarItem;
    
    self.viewController = _rdvTabBarController;
    
    [self customizeTabBarForController:_rdvTabBarController];
}

#pragma mark 首次进入清登录信息
#pragma mark -
-(void)goLogin
{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    loginVC.isNoBackBtn = YES;
    [_rdvTabBarController.viewControllers[0] pushViewController:loginVC animated:NO];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages = @[@"viewvontroller_01",@"viewvontroller_05", @"viewvontroller_02", @"viewvontroller_03"];
    NSArray *taberTitleStr = @[@"行情",@"资讯",@"发现",@"账户"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_1",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_0",
                                                        [tabBarItemImages objectAtIndex:index]]];
        NSDictionary *selectdeAttrubributeDic = @{NSFontAttributeName: [UIFont systemFontOfSize:11.0f],
                                                  NSForegroundColorAttributeName:[UIColor redColor]};
        NSDictionary *unSelectedAttrubributeDic = @{NSFontAttributeName: [UIFont systemFontOfSize:11.0f],
                                                    NSForegroundColorAttributeName:[UIColor grayColor]};
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setTitle:[taberTitleStr objectAtIndex:index]];
        item.selectedTitleAttributes = selectdeAttrubributeDic;
        item.unselectedTitleAttributes = unSelectedAttrubributeDic;
        
        index++;
    }
    
    
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    
    if (cacheModel != nil) {
        if (cacheModel.accountModel != nil) {
            if (cacheModel.accountModel.accountIndexModel != nil) {
                [self goLogin];
            }
        }
    }
}

- (void)customizeInterface {
    
    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        backgroundImage = [UIImage imageNamed:@"navigationbar_background_tall"];
        
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                           NSForegroundColorAttributeName: [UIColor blackColor],
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        backgroundImage = [UIImage imageNamed:@"navigationbar_background"];
        
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:18],
                           UITextAttributeTextColor: [UIColor blackColor],
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    
    backgroundImage = nil;
    textAttributes = nil;
}

#pragma mark Share
//*****************Share**********************
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
//*****************Share**********************

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //    NSLog(@"applicationWillResignActive");
}
//home
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    _isbackground = YES;
    _userInfoDic = nil;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
#pragma mark 关闭stock长链接
//    [[h5DataCenterMgr sharedInstance] destroySession];
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:0];
    self.inBackgroundCount=[date timeIntervalSince1970];
    
    //行情断线
    [[NSNotificationCenter defaultCenter] postNotificationName:kCloseConnection object:nil];
    
    //调用通知，关闭五档行情的定时器
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeFiveTime" object:@"exit"];
    
}
//重回应用
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
#pragma mark 打开股票长链接
//    [[h5DataCenterMgr sharedInstance] createSession];
    //     NSLog(@"applicationWillEnterForeground");
    NSDate * date=[NSDate dateWithTimeIntervalSinceNow:0];
    
    int endDate=[date timeIntervalSince1970];
    int timeInterval=endDate-self.inBackgroundCount;
    
    //超过2分钟--少于3小时
    if(timeInterval>=120 && timeInterval <60*60*3)
    {
        if ([[CMStoreManager sharedInstance] isLogin]) {
            if ([CacheEngine isOpenGes] && [CacheEngine isSetPwd]) {
                [CLLockVC showVerifyLockVCInVC:self.window.rootViewController forgetPwdBlock:^{
                    //                    NSLog(@"忘记密码");
                    [[NSNotificationCenter defaultCenter] postNotificationName:uForgetGesture object:nil];
                } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                    //                    NSLog(@"密码正确");
                    [lockVC dismiss:0.0f];
                }];
            }
        }
    }
    //超过3小时
    else if (timeInterval >= 60*60*3){
        if ([[CMStoreManager sharedInstance] isLogin]) {
            NSString    *firstLoginStr = getUserDefaults(@"FirstLogin");
            [[CMStoreManager sharedInstance] exitLoginClearUserData];
            [[CMStoreManager sharedInstance] setbackgroundimage];
            saveUserDefaults(firstLoginStr, @"FirstLogin");
            [[NSNotificationCenter defaultCenter] postNotificationName:uFirstOpenClearLoginInfo object:nil];

        }
    }
    
    //同步时间
    
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    
    systemTimeInterval = 0;
    locationTimeInterval = 0;
    [self getSystemDate];
    
    //行情断线重连
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisConToConnection object:nil];
    
    //打开五档行情定时器
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeFiveTime" object:@"start"];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSString * str = _userInfoDic[@"message_type"];
    NSString * messageId = _userInfoDic[@"messageId"];
    NSUInteger selectNum = self.rdvTabBarController.selectedIndex;
    UINavigationController *nav0 = (UINavigationController *)[[(RDVTabBarController *)[UIEngine getCurrentRootViewController] viewControllers] objectAtIndex:selectNum];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    if ([str isEqualToString:@"1"]) {
        //跳转系统消息
        SystemMsgDetailPage * systemMsgDetailVC = [[SystemMsgDetailPage alloc] init];
        systemMsgDetailVC.messageId = messageId;
        systemMsgDetailVC.isPush = YES;
        [[(UIViewController*)nav0.viewControllers.lastObject navigationController] pushViewController:systemMsgDetailVC animated:YES];
    }else if([str isEqualToString:@"2"]){
        //交易提醒
        TraderRemindPage * traderRemindVC = [[TraderRemindPage alloc] init];
        [[(UIViewController*)nav0.viewControllers.lastObject navigationController] pushViewController:traderRemindVC animated:YES];
        
    }
    _userInfoDic = nil;
    _isbackground = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //     NSLog(@"applicationWillTerminate");
}

// 禁用旋屏(在Xcode 4.5之后)

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window

{
    
    return (UIInterfaceOrientationMaskPortrait);
    
}

#pragma mark 网络

- (void)networkStateChange
{
    [self checkNetworkState];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)checkNetworkState
{
    // 1.检测wifi状态
    NetReachability *wifi = [NetReachability reachabilityForLocalWiFi];
    
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    NetReachability *conn = [NetReachability reachabilityForInternetConnection];
    
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
        [UIEngine showShadowPrompt:@"您已成功切换到WiFi环境"];
        
        //行情断线重连
        [[NSNotificationCenter defaultCenter] postNotificationName:kDisConToConnection object:nil];
        
    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        [UIEngine showShadowPrompt:@"您当前使用的是2G/3G/4G网络"];
        
        //行情断线重连
        [[NSNotificationCenter defaultCenter] postNotificationName:kDisConToConnection object:nil];
        
    } else { // 没有网络
        
        [UIEngine showShadowPrompt:@"! 您当前网络不可用，请检查网络设置"];
        [[UIEngine sharedInstance] hideProgress];
    }
    
}

#pragma mark 加载欢迎页

-(void)loadWelcomePage{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSArray * array = [[UIApplication sharedApplication] windows];
    if (array.count >= 2) {
        window = [array objectAtIndex:1];
    }
    WelcomePageView *welcomeVC = [[WelcomePageView alloc]initWithFrame:self.window.bounds];
    [window addSubview:welcomeVC];
}

#pragma mark 获取系统时间

-(void)getSystemDate{
    //系统时间
    
    [DataEngine requestToGetSystemDateWithComplete:^(BOOL SUCCESS, NSString *data , NSString *timeInterval) {
        if (SUCCESS) {
            systemTimeInterval = [timeInterval longLongValue];
            [SystemSingleton sharedInstance].timeString = [NSString stringWithFormat:@"%@",[data substringToIndex:10]];
            [SystemSingleton sharedInstance].timeInterval = systemTimeInterval;
            if(AppStyle_SAlE){
            
            }else {
            //获取市场状态
            [self getMarketStatus];
            }
        }
        else
        {
            systemTimeInterval = [[NSDate date] timeIntervalSince1970];
        }
        if (_timer == nil) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeIntervalGO) userInfo:nil repeats:YES];
        }
    }];
}
#pragma mark 系统跑秒
-(void)timeIntervalGO{
    systemTimeInterval += 1000;
    locationTimeInterval += 1;
    
    if (locationTimeInterval == 60*10) {
        [_timer invalidate];
        _timer = nil;
        systemTimeInterval = 0;
        locationTimeInterval = 0;
        [self getSystemDate];
    }
    
    [SystemSingleton sharedInstance].timeInterval = systemTimeInterval;
    
    //    NSLog(@"\n++++++++++++++++++++同步跑秒：%lld \n--------------------手机系统：%f \n--------------------市场状态:%ld",[SystemSingleton sharedInstance].timeInterval,[[NSDate date] timeIntervalSince1970],[[SystemSingleton sharedInstance] getMarketStatus]);
    
}

#pragma mark 市场状态（股票）

-(void)getMarketStatus{
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *timeStr = [SystemSingleton sharedInstance].timeString;
    
    NSMutableDictionary * infoDic = [CacheEngine getMarketStatus];
    
    if(infoDic == nil)
    {
        [self requestMarketInfo];
    }
    else if (![infoDic[@"msg"] isEqualToString:timeStr]){
        [self requestMarketInfo];
    }
    else{
        
    }
}

-(void)requestMarketInfo{
    [DataEngine requestToGetMarketStatus:^(BOOL, NSMutableDictionary * dictionary) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [CacheEngine setMarketStatus:dic];
    }];
}

@end
