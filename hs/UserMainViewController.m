//
//  UserMainViewController.m
//  hs
//
//  Created by hzl on 15-4-22.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#define  QuickButTag 1000

#import "UserMainViewController.h"
#import "UserTableViewCell.h"
#import "LoginViewController.h"
#import "RegViewController.h"
#import "LoginAndRegistView.h"
#import "NetRequest.h"
#import "SettingViewController.h"
#import "PersionInfoViewController.h"
#import "UserPointViewController.h"
#import "AdviceViewController.h"
#import "HelpCenterViewController.h"
#import "MoneyDetaillViewController.h"
#import "RecordController.h"
#import "RGZActionStyleMoreButton.h"
#import "NSString+MD5.h"
#import "FindZBarViewController.h"
#import "CouponsPage.h"
#import "KnowAboutCainiuController.h"
#import "H5LinkPage.h"
#import "AboutUserViewController.h"

#define OtherCellHeight 46.0

@interface UserMainViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //用户信息
    CUserData   * _cuserdata;
    NSString    *_name;
    //个性签名
    NSString    *_sign;
    //股票市值
    NSString    *_stockMarket;
    //账户余额
    NSString    *_accountMoney;
    //首冲1000送100元
    NSString    *_accountPrompt;
    //积分
    NSString    *_integral;
    
    //风火轮开关
    //股票市值开关
    BOOL        _switchStock;
    //可用余额和积分开关
    BOOL        _switchMoney;
    //冻结金额开关
    BOOL        _switchFreeze;
    
    
    //是否开启选择环境按钮
    //环境状态  0:正式    1:测试    2:预发布 3:模拟
    int         environmentState;
    //期货是否开户过
    BOOL        futureRegist;
    
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic)  UIView *logRegView;

@end

@implementation UserMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void )updateUI:(BOOL)bhide
{
    self.logRegView.hidden = bhide;
    [self updateData:bhide];
}

-(void)updateData:(BOOL)login
{
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    if (cacheModel.accountModel.accountIndexModel.accountMoney != nil) {
        _accountMoney=cacheModel.accountModel.accountIndexModel.accountMoney;
    }else{
        _accountMoney = @"0.00元";
    }
    if (cacheModel.accountModel.accountIndexModel.accountIntegral != nil) {
        _integral=cacheModel.accountModel.accountIndexModel.accountIntegral;
    }else{
        _integral=@"0";
    }
    
    _sign=@"";
    _name=@"未登录";
    
    if (login) {
        //本地存储的用户信息
        _cuserdata = [CUserData sharedInstance];
        _name=[[CMStoreManager sharedInstance] getUserNick];
        _sign=[[CMStoreManager sharedInstance] getUserSign];
        
        //缓存
        cacheModel.accountModel.accountIndexModel.nickName = _name;
        cacheModel.accountModel.accountIndexModel.sign = _sign;
        [CacheEngine setCacheInfo:cacheModel];
        
        if ([_sign isEqualToString:@""]||[_sign isEqualToString:@" "]) {
            _sign=@"编辑个性签名";
        }
        
        [self isNeedShowFutureRegist];
        [self getUseMoney];
        [self getUseUserCoupons];
    }
    else{
        if (self.tableView!=nil) {
            [self.tableView reloadData];
        }
    }
}

#pragma mark 风火轮开关

-(void)openSwitch:(NSString *)aStr
{
    if ([aStr isEqualToString:@"money"]) {
        _switchMoney=YES;
    }
}

-(void)closeSwitch:(NSString *)aStr
{
    if ([aStr isEqualToString:@"money"]) {
        _switchMoney=NO;
    }
    else if ([aStr isEqualToString:@"freeze"])
    {
        _switchFreeze=NO;
    }
    else if ([aStr isEqualToString:@"stock"])
    {
        _switchStock=NO;
    }
}

#pragma mark 获取可用余额

//可用余额
-(void)getUseMoney
{
    //开启风火轮开关
    [self openSwitch:@"money"];
    
    //获取可用余额
    //[ManagerHUD showHUD:self.view animated:YES];
    //    NSString *money,NSString *integralStr,NSString *useMoney
    [DataEngine requestToGetAllMoneyWithComplete:^(BOOL SUCCESS, NSMutableArray *infoArray) {
        //[ManagerHUD hidenHUD];
        if (SUCCESS) {
            //账户可用余额
            if ([infoArray[2] floatValue]>=100000) {
                NSString *str =[NSString stringWithFormat:@"%.3f",[infoArray[2] doubleValue]/10000.0];
                _accountMoney=[[str substringToIndex:str.length-1] stringByAppendingString:@" 万元"];
            }
            else
            {
                _accountMoney=[[DataEngine addSign:[NSString stringWithFormat:@"%.2lf",[infoArray[2] doubleValue]]] stringByAppendingString:@" 元"];
            }
            
            //积分
            _integral=[DataEngine addSign:[NSString stringWithFormat:@"%.2lf",[infoArray[1] doubleValue]]];
            
            //账户余额存储
            [[CMStoreManager sharedInstance] setAccountFreeze:[NSString stringWithFormat:@"%.2lf",[infoArray[2] doubleValue]]];
            [[NSUserDefaults standardUserDefaults] setObject:infoArray[2] forKey:@"AccountBalance"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //账户积分存储
            [[CMStoreManager sharedInstance] setAccountScore:[infoArray[1] intValue]];
            
            _cuserdata.userBaseClass.data.financyInfo.usedAmt=infoArray[2];
            _cuserdata.userBaseClass.data.financyInfo.score=infoArray[1];
            
            //缓存
            CacheModel *cacheModel = [CacheEngine getCacheInfo];
            cacheModel.accountModel.accountIndexModel.accountMoney = _accountMoney;
            cacheModel.accountModel.accountIndexModel.accountIntegral = _integral;
            [CacheEngine setCacheInfo:cacheModel];
            
            //关闭风火轮开关
            [self closeSwitch:@"money"];
            
            //调用回复信息是否已读的接口
            [self requestAnswerIsRead];
            
            //刷新表
            [self.tableView reloadData];
            
        }
        else
        {
            if(infoArray != nil && infoArray.count>0){
                [UIEngine showShadowPrompt:infoArray[0]];
            }else{
                //                [UIEngine showShadowPrompt:@"！您当前网络不佳，请稍后再试"];
            }
            
            [self closeSwitch:@"money"];
            [self.tableView reloadData];
        }
    }];
}
#pragma mark 获取优惠券数量

- (void)getUseUserCoupons
{
    [RequestDataModel requestCouponsNumSuccessBlock:^(BOOL success, int couponsNum) {
        if (success) {
            _userCouponsNum = couponsNum;
            [_tableView reloadData];
        }
    }];
}

#pragma mark 期货是否开过户

-(void)isNeedShowFutureRegist{
    
    [DataEngine requestToGetFutureRegist:^(BOOL SUCCESS) {
        futureRegist = SUCCESS;
        if (SUCCESS) {
            [_tableView reloadData];
        }
    }];
}

-(void )viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"账户首页"];
    self.rdv_tabBarController.tabBarHidden = NO;
    self.navigationController.navigationBarHidden = YES;
    [[UIEngine sharedInstance] hideProgress];
    
    if ([[CMStoreManager sharedInstance] isLogin]) {
        [self updateUI:YES];
        [self loadData];
    }else{
        [self updateUI:NO];
    }
    
    UIView  * view = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeigth-49, ScreenWidth, 0.5)];
    view.backgroundColor = K_color_line;
    view.tag = 55555;
    [self.rdv_tabBarController.view addSubview:view];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"帐户首页"];
    //关闭风火轮开关
    [self closeSwitch:@"money"];

    self.navigationController.navigationBarHidden = NO;
    self.rdv_tabBarController.tabBarHidden = YES;
    UIView * tabbarLine = [self.rdv_tabBarController.view viewWithTag:55555];
    [tabbarLine removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self loadOtherNotification];
    
    if ([self respondsToSelector: @selector(setEdgesForExtendedLayout:)] ) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self initTableView];
    [self initLoginView];
    [self addbadgeOntabbar];
    
}
- (void)initData
{
    _userCouponsNum = 0;
    futureRegist = NO;
}
#pragma mark 加载通知

-(void)loadOtherNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popRoot) name:uPopRootAccountCenter object:nil];
}

#pragma mark 手势密码忘记
-(void)popRoot
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    loginVC.isGesForget = YES;
    [self.navigationController pushViewController:loginVC animated:NO];
}

#pragma mark Data
#pragma mark -

-(void)loadData
{
    //缓存
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    if(cacheModel == nil){
        cacheModel = [[CacheModel alloc]init];
    }
    if (cacheModel.accountModel == nil) {
        PageAccountModel *pageAccountModel = [[PageAccountModel alloc]init];
        AccountIndexModel *accountIndexModel = [[AccountIndexModel alloc]init];
        AccountDetailModel *accountDetailModel = [[AccountDetailModel alloc]init];
        AccountIntegralModel *accountIntegralModel = [[AccountIntegralModel alloc]init];
        AccountRecordModel  *accountRecordModel = [[AccountRecordModel alloc]init];
        
        pageAccountModel.accountDetailModel = accountDetailModel;
        pageAccountModel.accountIndexModel = accountIndexModel;
        pageAccountModel.accountIntegralModel = accountIntegralModel;
        pageAccountModel.accountRecordModel =accountRecordModel;
        
        cacheModel.accountModel = pageAccountModel;
    }
    
    [CacheEngine setCacheInfo:cacheModel];
    
    [self loadNotification];
}

//充值完成后检查实名信息和银行卡
- (void)loadNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkUserInfo) name:uCheckUserInfo object:nil];
}

- (void)checkUserInfo{
    [self authRealName];
}

//验证真实姓名
-(void)authRealName
{
    
    [DataEngine requestToAuthbindOfRealNameWithComplete:^(BOOL SUCCESS, NSString * status, NSString * realName, NSString * idCard) {
        if (SUCCESS) {
            if ([status isEqualToString:@"1"]||[status isEqualToString:@"2"]) {
                [self authBankCard];
                
            }
            else{
                [[UIEngine sharedInstance] showAlertWithTitle:@"为了您的账户安全 \n 请完善个人资料" ButtonNumber:2 FirstButtonTitle:@"取消" SecondButtonTitle:@"完善资料"];
                [UIEngine sharedInstance].alertClick = ^(int aIndex){
                    if (aIndex == 10087) {
                        [self goPersionInfo];
                    }
                };
            }
            
        }
    }];
}

//验证银行卡
-(void)authBankCard
{
    
    [DataEngine requestToAuthbindOfBankWithComplete:^(BOOL SUCCESS, NSString * status, NSString * bankName, NSString * bankCard) {
        if (SUCCESS) {
            if ([status isEqualToString:@"1"]||[status isEqualToString:@"2"]) {
                
            }
            else
            {
                [[UIEngine sharedInstance] showAlertWithTitle:@"为了您的账户安全 \n 请完善个人资料" ButtonNumber:2 FirstButtonTitle:@"取消" SecondButtonTitle:@"完善资料"];
                [UIEngine sharedInstance].alertClick = ^(int aIndex){
                    if (aIndex == 10087) {
                        [self goPersionInfo];
                    }
                };
            }
        }
        
    }];
}

-(void)goPersionInfo{
    BackButtonHeader
    PersionInfoViewController *persionVC=[[PersionInfoViewController alloc]init];
    [self.navigationController pushViewController:persionVC animated:YES];
}

#define mark 加载登录页

- (void)initLoginView
{
    
    _logRegView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth-49)];
    [_logRegView setBackgroundColor:RGBACOLOR(0, 0, 0, 0.6)];
    [self.view addSubview:_logRegView];
    
    LoginAndRegistView * unloginStartView = [[LoginAndRegistView alloc] initWithFrame:CGRectMake(20, 160*ScreenHeigth/667, ScreenWidth - 40, ScreenHeigth - 172*ScreenHeigth/667 - 55*ScreenHeigth/667)];
    unloginStartView.backgroundColor = [UIColor clearColor];
    unloginStartView.userInteractionEnabled = YES;
    unloginStartView.block = ^(UIButton * btn){
        if (btn.tag==20001) {
            [self logBtnClick:nil];
        }else{
            
            [self regBtnClick:nil];
        }
    };
    [_logRegView addSubview:unloginStartView];
    
}
-(void)otherPlaceClick
{
    
}

- (void)initTableView
{
    UIImageView * tabHeaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    tabHeaderView.userInteractionEnabled=YES;
    tabHeaderView.image=[UIImage imageNamed:@"account_background_header"];
    
    UIImageView *settingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-49, 20+12, 20, 20)];
    settingImageView.image = [UIImage imageNamed:@"setting"];
    [tabHeaderView addSubview:settingImageView];
    
    UIButton * setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame =CGRectMake(self.view.bounds.size.width-49-12, 20, 44, 44);
    [setBtn addTarget:self action:@selector(setMessage) forControlEvents:UIControlEventTouchUpInside];
    [tabHeaderView addSubview:setBtn];
    
    [self.view addSubview:tabHeaderView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth-49) style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    self.tableView.backgroundColor = RGBACOLOR(239, 239, 244, 1);
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = tabHeaderView;
    
}

#pragma mark - 快速登录
//快捷登录
-(void)QuickBut:(NSInteger)type
{
    self.logRegView.hidden = YES;
    
    [UIEngine sharedInstance].progressStyle = 1;
    [[UIEngine sharedInstance] showProgress];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyy-MM-dd-HH-mm-ss"];
    
    
    NSString   *strOpenUUid = [NSString stringWithFormat:@"%d-%@-%d",arc4random()%1000000000,[dateFormatter stringFromDate:[NSDate date]],arc4random()%1000000000];
    
    //判断是牛A还是财牛
    NSString *stype = @"1";
    NSString * niu = @"";
    //    #if defined (CAINIUA)
    //        stype = @"1";
    //        niu = RegSourceCaiNiuA;
    //    #elif defined (NIUAAPPSTORE)
    //    stype = @"1";
    //    niu = RegSourceCaiNiuA;
    //    #else
    //        stype = @"0";
    //        niu = RegSourceCaiNiu;
    //    #endif
    
    niu = App_regSource;
    
    NSDictionary * dic = @{@"openID":strOpenUUid,
                           @"type":[NSString stringWithFormat:@"%ld",(long)type],
                           @"nickName":@"iphone",
                           @"deviceModel":[[UIDevice currentDevice] model],
                           @"deviceImei":UDID,
                           @"deviceVersion":[[UIDevice currentDevice] systemVersion],
                           @"clientVersion":VERSION,
                           @"regSource":niu,
                           @"operator":[DataEngine getCellularProviderName],
                           @"stype":stype,
                           };
    
    NSString * url = @"/user/openIDLogin";
    NSString * loginUrl = [NSString stringWithFormat:@"%@%@",K_MGLASS_URL,url];
    
    [NetRequest postRequestWithNSDictionary:dic url:loginUrl successBlock:^(NSDictionary *dictionary) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonStr);
        
        [[UIEngine sharedInstance] hideProgress];
        
        if ([dictionary[@"code"] intValue]==200) {
            
            //存储用户信息
            [DataEngine saveUserInfo:dictionary];
            
            UserBaseClass * userBaseClass = [UserBaseClass modelObjectWithDictionary:dictionary];
            
            CUserData * cuserdata = [CUserData sharedInstance];
            cuserdata.userBaseClass = userBaseClass;
            //昵称修改状态
            saveUserDefaults(dictionary[@"data"][@"nickStatus"], uUserInfoNickStatus);
            [[CMStoreManager sharedInstance] setUSerHeaderAddress:userBaseClass.data.userInfo.headPic];
            [[CMStoreManager sharedInstance] setUserNick:userBaseClass.data.userInfo.nick];
            [[CMStoreManager sharedInstance] setUserSign:userBaseClass.data.userInfo.personSign];
            [[CMStoreManager sharedInstance] storeUserToken:  cuserdata.userBaseClass.data.tokenInfo.token];
            [[CMStoreManager sharedInstance] storeUserTokenSecret:cuserdata.userBaseClass.data.tokenInfo.userSecret];
            
            [self updateUI:YES];
            
            
        }else{
            NSString * message = dictionary[@"msg"];
            
            [[UIEngine sharedInstance] showAlertWithTitle:message ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
            [UIEngine sharedInstance].alertClick = ^(int aIndex){};
            
            [self updateUI:NO];
        }
        
    } failureBlock:^(NSError *error) {
        [[UIEngine sharedInstance] hideProgress];
        NSLog(@"%ld___%@",(long)error.code, error.localizedDescription);
        
        [[UIEngine sharedInstance] showAlertWithTitle:error.localizedDescription ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
        [UIEngine sharedInstance].alertClick = ^(int aIndex){};
        
        [self updateUI:NO];
    }];
    
}
- (void)clickQuickBut:(UIButton *)but
{
    NSInteger type = but.tag-QuickButTag;
    switch (type) {
        case 3://快捷登录
            [self QuickBut:0];
            break;
        default:
            break;
    }
}

- (void)logBtnClick:(id)sender {
    LoginViewController * logVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:logVC animated:YES];
    //    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
    
}

- (void)regBtnClick:(id)sender {
    RegViewController * regVC = [[RegViewController alloc] init];
    [self.navigationController pushViewController:regVC animated:YES];
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
}

#pragma mark - 获取回复列表是否已读的状态
- (void)requestAnswerIsRead
{
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token};
    [NetRequest postRequestWithNSDictionary:dic url:K_Answer_AnswerIsRead successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            NSInteger isbool = [dictionary[@"data"][@"isbool"] integerValue];
            [self refreshView:isbool];
        }
    } failureBlock:^(NSError *error) {
        
    }];
    
}

- (void)refreshView:(NSInteger)isbool
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:4];
    UserTableViewCell *cell = (UserTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    
    if (isbool == 1)
    {//未读
        NSLog(@"未读");
        UIView *view = [self.rdv_tabBarController.tabBar viewWithTag:888 + 2];
        view.hidden = NO;
        cell.redView.backgroundColor = [UIColor redColor];
    }else
    {
        UIView *view = [self.rdv_tabBarController.tabBar viewWithTag:888 + 2];
        view.hidden = YES;
        cell.redView.backgroundColor = [UIColor clearColor];
    }
    
    
}

- (void)addbadgeOntabbar
{
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + 2;
    badgeView.hidden = YES;
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect tabFrame = self.rdv_tabBarController.tabBar.frame;
    
    //确定小红点的位置
    float percentX = (2 +0.55) / 3.0;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x + 3, y + 4, 6, 6);//圆形大小为10
    badgeView.layer.cornerRadius = 3;//圆形
    badgeView.layer.masksToBounds = YES;
    badgeView.layer.borderWidth = 1;//边框宽度
    badgeView.layer.borderColor = [[UIColor whiteColor]CGColor];//边框颜色
    
    [self.rdv_tabBarController.tabBar addSubview:badgeView];
    
}

#pragma mark--UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int  num = 0;
    switch (section) {
        case 0:
        {
            num = 1;
            
        }
            break;
        case 1:
        {
            num = 1;
        }
            break;
        case 2:
        {
            num = 2;
        }
            break;
        case 3:
        {
            num = 2;
        }
            break;
        case 4:
        {
            num = 3;
        }
            break;
            
        default:
            break;
    }
    return num;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        return 5;
    }
    if (section==3) {
        return 10;
    }
    if (section == 4) {
        return 10;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 3||section == 2||section == 4) {
        UIView *view= [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 3)];
        //        view.backgroundColor = [UIColor whiteColor];
        return view;
    }
    
    return nil;
}

#define CellX 50.0/375.0*ScreenWidth

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserTableViewCell *cell=[[UserTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    //向右箭头
    UIImageView *accessoryImageView = [[UIImageView alloc]init];
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        accessoryImageView.frame = CGRectMake(7, 0, 10, 24);
        accessoryImageView.image = [UIImage imageNamed:@"return_1"];
        accessoryImageView.transform = CGAffineTransformMakeScale(-1, 1);
        
        UIView  *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
        view.backgroundColor = [UIColor clearColor];
        [view addSubview:accessoryImageView];
        cell.accessoryView = view;
    }
    else{
        accessoryImageView.frame = CGRectMake(0, 0, 24, 24);
        accessoryImageView.image = [UIImage imageNamed:@"button_02"];
        cell.accessoryView = accessoryImageView;
    }
    
    cell.lineView.frame=CGRectMake(0, OtherCellHeight, ScreenWidth, 0.5);
    cell.lineView.backgroundColor=[UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:0.8];
    switch (indexPath.section) {
        case 0:
        {
            cell.backgroundImageView.frame=CGRectMake(0, 0, ScreenWidth, 80);
            cell.backgroundImageView.image=[UIImage imageNamed:@"account_background_middle"];
            cell.lineView.backgroundColor=[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:0.8];
            cell.lineView.frame=CGRectMake(0, 80, ScreenWidth, 1);
            cell.alpha=0.6;
            [cell.userHeaderBtn setBackgroundImage:[UIImage imageNamed:@"head_01"] forState:UIControlStateNormal];
            cell.titlelab.text = _name;
            cell.titlelab.font = [UIFont systemFontOfSize:18.0f];
            cell.titlelab.textColor = [UIColor whiteColor];
            cell.titlelab.frame = CGRectMake(80, 20, 250.0/320*ScreenWidth, 25);
            cell.detailLab.textColor=[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.95];
            cell.detailLab.text = _sign;
            cell.detailLab.font = [UIFont systemFontOfSize:12.0f];
            cell.detailLab.frame = CGRectMake(80, 40, 200/320.0*ScreenWidth, 20);
            cell.messageLab = nil;
            
            //二维码
            UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-40-15, 0, 15, 15)];
            iconImageView.center = CGPointMake(iconImageView.center.x, cell.userHeaderBtn.center.y);
            iconImageView.userInteractionEnabled = YES;
            iconImageView.image = [UIImage imageNamed:@"QR_white"];
            [cell addSubview:iconImageView];
        }
            break;
        case 1:
        {
            
            
            
            cell.messageLab.frame = CGRectMake(ScreenWidth-195, cell.bounds.size.height/2-10, 150, 20);
            cell.titlelab.textColor = cell.messageLab.textColor =  [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.95];
            cell.detailLab.textColor=[UIColor whiteColor];
            cell.lineView.backgroundColor=[UIColor clearColor];
            cell.messageLab.textAlignment=NSTextAlignmentRight;
            
            
            //账户余额
            
            if (indexPath.row == 0)
            {
                cell.backgroundImageView.frame=CGRectMake(0, 0, ScreenWidth, 70);
                cell.backgroundImageView.image=[UIImage imageNamed:@"account_background_footer"];
                cell.backgroundImageView.userInteractionEnabled = YES;
                
                cell.titlelab.frame = CGRectMake(20,16, 100, 10);
                cell.detailLab.frame = CGRectMake(20, cell.titlelab.frame.size.height+cell.titlelab.frame.origin.y+2, cell.bounds.size.width/2, 30);
                cell.titlelab.font = cell.detailLab.font = cell.messageLab.font = [UIFont systemFontOfSize:12];
                cell.titlelab.text = @"可用余额";
                cell.titlelab.userInteractionEnabled = YES;
                cell.detailLab.text = _accountMoney;
                cell.detailLab.userInteractionEnabled = YES;
                NSRange range = [_accountMoney rangeOfString:@"万"];
                
                if (range.location != NSNotFound) {
                    cell.detailLab.attributedText=[self multiplicityText:cell.detailLab.text from:0 to:(int)cell.detailLab.text.length-2 font:22];
                }
                else
                {
                    cell.detailLab.attributedText=[self multiplicityText:cell.detailLab.text from:0 to:(int)cell.detailLab.text.length-1 font:22];
                }
                
                
                cell.messageLab = nil;
                cell.accessoryView = nil;
                
                //充值/提现
                UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth-20-70, 0, 70, 70)];
                rightView.backgroundColor = [UIColor clearColor];
                rightView.userInteractionEnabled = YES;
                [cell addSubview:rightView];
                
                UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35.5, 35.5)];
                iconImageView.center = CGPointMake(rightView.frame.size.width/2, rightView.frame.size.height/2-5);
                iconImageView.userInteractionEnabled = YES;
                iconImageView.image = [UIImage imageNamed:@"Button_16"];
                [rightView addSubview:iconImageView];
                
                UILabel *iconLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, iconImageView.frame.origin.y+iconImageView.frame.size.height, rightView.frame.size.width, 20)];
                iconLabel.text = @"充值/提现";
                iconLabel.textColor = [UIColor whiteColor];
                iconLabel.userInteractionEnabled = YES;
                iconLabel.font = [UIFont systemFontOfSize:12];
                iconLabel.textAlignment = NSTextAlignmentCenter;
                iconLabel.backgroundColor = [UIColor clearColor];
                [rightView addSubview:iconLabel];
                
                if (_switchMoney) {
                    [self loadActivityWithFrame:CGRectMake(15, 0, cell.detailLab.frame.size.height, cell.detailLab.frame.size.height) baseView:cell.detailLab style:0];
                }
            }
        }
            break;
        case 2:
        {
//            cell.titlelab.frame = CGRectMake(CellX, 10, 200, 24);
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            if(indexPath.row==0){
                cell.imageView.image = [UIImage imageNamed:@"account_icon_01"];
                cell.messageLab.frame = CGRectMake(ScreenWidth-200-40, 46/2-15 + 2, 200, 26);
                cell.messageLab.textAlignment = NSTextAlignmentRight;
                cell.detailLab = nil;
                cell.textLabel.text = @"优惠券";
                cell.messageLab.font = [UIFont systemFontOfSize:14];
                cell.messageLab.text = [NSString stringWithFormat:@"%ld张",(long)_userCouponsNum];
                cell.messageLab.textColor = [UIColor lightGrayColor];
                cell.userInteractionEnabled = YES;
            }else{
                cell.imageView.image = [UIImage imageNamed:@"account_icon_02"];
                cell.messageLab.frame=CGRectMake(ScreenWidth-200-40, 46/2-13, 200, 26);
                cell.messageLab.textColor=[UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
                cell.messageLab.textAlignment=NSTextAlignmentRight;
                cell.detailLab = nil;
                cell.textLabel.text = @"总积分";
                cell.messageLab.text = _integral;
                cell.userInteractionEnabled = YES;
                cell.lineView.alpha = 0;
            }
        }
            break;
        case 3:
        {
            cell.detailLab = nil;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.accessoryView = nil;
            if(indexPath.row == 0){
                if ([[ControlCenter sharedInstance] isShowCots]) {
                    cell.imageView.image = [UIImage imageNamed:@"account_icon_03"];
                    cell.textLabel.text = @"关联现货账户";
                    CGFloat titleWidth = [Helper calculateTheHightOfText:cell.titlelab.text height:24 font:[UIFont systemFontOfSize:14.0]];
                    cell.redView.frame  = CGRectMake(15 + titleWidth, 11, 8, 8);
                    cell.redView.layer.cornerRadius = 4;
                    cell.redView.layer.masksToBounds = YES;
                    cell.lineView.alpha = 1;
                    
                    if ([SpotgoodsAccount sharedInstance].isNeedLogin && [SpotgoodsAccount sharedInstance].isNeedRegist) {
                        cell.messageLab.frame = CGRectMake(ScreenWidth - 20 - 80, 10, 80, OtherCellHeight-20);
                        cell.messageLab.backgroundColor = Color_red;
                        cell.messageLab.text = @"开户";
                        cell.messageLab.textColor = [UIColor whiteColor];
                        cell.messageLab.font = [UIFont systemFontOfSize:14];
                        cell.messageLab.textAlignment = NSTextAlignmentCenter;
                        cell.messageLab.layer.cornerRadius = 5;
                        cell.messageLab.clipsToBounds = YES;
                    }
                    else{
                        cell.messageLab = nil;
                    }
                }
            }
            else if(indexPath.row == 1){
                cell.imageView.image = [UIImage imageNamed:@"account_icon_04"];
                cell.textLabel.text = @"关联期货账户";
                CGFloat titleWidth = [Helper calculateTheHightOfText:cell.titlelab.text height:24 font:[UIFont systemFontOfSize:14.0]];
                cell.redView.frame  = CGRectMake(15 + titleWidth, 11, 8, 8);
                cell.redView.layer.cornerRadius = 4;
                cell.redView.layer.masksToBounds = YES;
                cell.lineView.alpha = 0;
                
                if (futureRegist == NO) {
                    cell.messageLab.frame = CGRectMake(ScreenWidth - 20 - 80, 10, 80, OtherCellHeight-20);
                    cell.messageLab.backgroundColor = Color_red;
                    cell.messageLab.text = @"开户";
                    cell.messageLab.textColor = [UIColor whiteColor];
                    cell.messageLab.font = [UIFont systemFontOfSize:14];
                    cell.messageLab.textAlignment = NSTextAlignmentCenter;
                    cell.messageLab.layer.cornerRadius = 5;
                    cell.messageLab.clipsToBounds = YES;
                }
                else{
                    cell.messageLab = nil;
                }
                
            }
        }
            break;
        case 4:
        {
            cell.messageLab = nil;
            cell.detailLab = nil;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            if(indexPath.row == 0){
                cell.imageView.image = [UIImage imageNamed:@"account_icon_05"];
                cell.textLabel.text = @"意见反馈";
                CGFloat titleWidth = [Helper calculateTheHightOfText:cell.titlelab.text height:24 font:[UIFont systemFontOfSize:14.0]];
                cell.redView.frame  = CGRectMake(15 + titleWidth, 11, 8, 8);
                cell.redView.layer.cornerRadius = 4;
                cell.redView.layer.masksToBounds = YES;
                
            }else if(indexPath.row == 1){
                cell.imageView.image = [UIImage imageNamed:@"account_icon_06"];
                cell.textLabel.text = @"帮助中心";
            }
            else if (indexPath.row == 2){
                cell.imageView.image = [UIImage imageNamed:@"account_icon_07"];
                cell.textLabel.text = @"关于我们";
                cell.lineView.alpha = 0;
            }
        }
            break;
            
        default:
            break;
    }
    return cell;
}

//点击充值提现的事件
-(void)goRecharge
{
    [self moneyDetaillBut];
}

-(void)loadActivityWithFrame:(CGRect)aFrame baseView:(UIView *)aView style:(int)aStyle
{
    //初始化:
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    indicator.tag = 999;
    
    //设置显示样式,见UIActivityIndicatorViewStyle的定义
    if (aStyle==0) {
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    }
    else
    {
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    
    
    //设置背景色
    indicator.backgroundColor = [UIColor clearColor];
    
    //设置背景为圆角矩形
    indicator.layer.cornerRadius = 6;
    indicator.layer.masksToBounds = YES;
    //设置显示位置
    [indicator setFrame:aFrame];
    
    //开始显示Loading动画
    [indicator startAnimating];
    
    [aView addSubview:indicator];
}

-(NSMutableAttributedString *)multiplicityText:(NSString *)aStr from:(int)aFrom to:(int)aTo font:(float)aFont
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:aStr];
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:aFont] range:NSMakeRange(aFrom, aTo)];
    
    return str;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    
    if(indexPath.section== 0)
    {
        height = 80.0;
        
    }
    else if (indexPath.section == 1)
    {
        
        height = 70.0;
    }
    else
    {
        //控制是否显示现货开户
        if (indexPath.section == 3 && indexPath.row == 0) {
            if (![[ControlCenter sharedInstance] isShowCots]) {
                height = 0;
            }
            else{
                height = OtherCellHeight;
            }
        }
        else{
            height = OtherCellHeight;
        }
    }
    return height;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==0)
    {
        if (indexPath.row==0) {
            BackButtonHeader
            PersionInfoViewController *persionVC=[[PersionInfoViewController alloc]init];
            [self.navigationController pushViewController:persionVC animated:YES];
        }
    }
    if (indexPath.section == 1) {
        [self goRecharge];
    }
    
    if (indexPath.section ==2)
    {
        if (indexPath.row==0)
        {
            CouponsPage *couponPage = [[CouponsPage alloc]init];
            couponPage.couponsNum = (int)_userCouponsNum;
            [self.navigationController pushViewController:couponPage animated:YES];
        }
        if (1 == indexPath.row)
        {
            
            UserPointViewController *userPoint = [[UserPointViewController alloc] init];
            userPoint.userScore = _integral;
            [self.navigationController pushViewController:userPoint animated:YES];
        }
    }
    //交易所登录
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            SpotgoodsWebController *spotgoodsController = [[SpotgoodsWebController alloc]init];
            [self.navigationController pushViewController:spotgoodsController animated:YES];
        }
        else if (indexPath.row == 1){
            Go_Future_Login;
        }
    }
    if (indexPath.section ==4)
    {
        if (indexPath.row==0) {
            AdviceViewController * adviceVC = [[AdviceViewController alloc] init];
            [self.navigationController pushViewController:adviceVC animated:YES];
        }
        else if (indexPath.row ==1){
            BackButtonHeader
            HelpCenterViewController *helperVC=[[HelpCenterViewController alloc]init];
            [self.navigationController pushViewController:helperVC animated:YES];
        }
        else if (indexPath.row == 2){
            //关于我们
            BackButtonHeader
            if (AppStyle_SAlE) {
                H5LinkPage * linkVC  = [[H5LinkPage alloc] init];
                linkVC.name = @"关于我们";
                linkVC.hiddenNav = NO;
                linkVC.urlStr = [NSString stringWithFormat:@"%@/activity/aboutus.html",K_MGLASS_URL];
                [self.navigationController pushViewController:linkVC animated:YES];
            }else{
                AboutUserViewController *aboutCtrl = [[AboutUserViewController alloc]init];
                [self.navigationController pushViewController:aboutCtrl animated:YES];
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setMessage
{
    NSString * isStaff = [[CMStoreManager sharedInstance] getUserIsStaff];
    __block SettingViewController *settingVC=[[SettingViewController alloc]init];
    settingVC.gologinBlock = ^(){
        [self logBtnClick:nil];
    };
    //判断当前应用的类型 1销售系统  0财牛应用
    if (AppStyle_SAlE) {
        settingVC.userStyle = 0;
        [self.navigationController pushViewController:settingVC animated:YES];
        return;
    }
    if (isStaff) {
        settingVC.userStyle = [isStaff isEqualToString:@"0"]?0:[isStaff intValue];
        [self.navigationController pushViewController:settingVC animated:YES];
        
    }else{
        [ManagerHUD showHUD:self.view animated:YES];
        [RequestDataModel requestUserPowerSuccessBlock:^(BOOL success, int userPower) {
            [ManagerHUD hidenHUD];
            settingVC.userStyle =userPower;
            [self.navigationController pushViewController:settingVC animated:YES];
            NSLog(@"%d",userPower);
        }];
    }
}

- (void)moneyDetaillBut
{
    MoneyDetaillViewController *moneyDetailPage = [[MoneyDetaillViewController alloc] init];
    moneyDetailPage.usedMoney = _accountMoney;
    moneyDetailPage.intoStatus = 1;
    [self.navigationController pushViewController:moneyDetailPage animated:YES];
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height || scrollView.contentOffset.y < 0) {
//        scrollView.scrollEnabled = NO;
//    }
//    else{
//        scrollView.scrollEnabled = YES;
//    }
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
