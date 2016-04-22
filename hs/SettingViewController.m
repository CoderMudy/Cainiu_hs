//
//  SettingViewController.m
//  hs
//
//  Created by RGZ on 15/5/20.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutUsController.h"
#import "AdviceViewController.h"
#import "HelpCenterViewController.h"
#import "AboutUserViewController.h"
#import "NetRequest.h"
#import "NSString+MD5.h"
#import <ShareSDK/ShareSDK.h>
#import "H5LinkPage.h"




#define  SwitchEvent_Tag 200000
#define  exitBtn_Tag 100000
#define advice_row @"意见反馈"
#define helperCenter_row @"帮助中心"
#define share_row @"分享好友"
#define aboutUs_row @"关于我们"
#define enviro_row @"当前状态"
#define environment_row 4


@interface SettingViewController ()
{
    NSArray   *_titleArray;
    NSArray   *_imgNameArray;
    int         environmentState;
    BOOL        _isChangeOpen;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong)NSNotification * notification;
@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self loginUpdate];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    _notification= [NSNotification notificationWithName:@"changePagePosition" object:self userInfo:nil];
    
    // Do any additional setup after loading the view.
    
    [self loadNav];
    
    [self loadData];
    
    [self loadTable];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

#pragma mark 数据

-(void)loadData
{   if (![[CMStoreManager sharedInstance] isLogin])
{
    _titleArray = @[helperCenter_row,share_row,aboutUs_row];
    _imgNameArray = @[@"account_icon_06",@"share",@"account_icon_07"];
}else{
    if (_userStyle==0)
    {
        _titleArray = @[advice_row,helperCenter_row,share_row,aboutUs_row];
        _imgNameArray = @[@"account_icon_05",@"account_icon_06",@"share",@"account_icon_07"];
    }else
    {
        _titleArray = @[advice_row,helperCenter_row,share_row,aboutUs_row,enviro_row];
        _imgNameArray = @[@"account_icon_05",@"account_icon_06",@"share",@"account_icon_07",@"nowState"];
    }
}
    
    
}

#pragma mark 导航

-(void)loadNav
{
    NavView * nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    nav.titleLab.text = @"设置中心";
    [nav.leftControl addTarget:self action:@selector(leftControlClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
    
}
- (void)leftControlClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sendNotification
{
    [[NSNotificationCenter defaultCenter]postNotification:_notification];
}
#pragma mark 退出登录

-(void)loadExitButton
{
    UIButton * exitButton=[UIButton buttonWithType:UIButtonTypeCustom];
    exitButton.frame=CGRectMake(0, _titleArray.count*50+30, ScreenWidth, 44.0/568*ScreenHeigth);
    exitButton.tag = exitBtn_Tag;
    exitButton.backgroundColor= [UIColor whiteColor];
    [exitButton addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    exitButton.titleLabel.font=[UIFont systemFontOfSize:18];
    [exitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    exitButton.layer.cornerRadius=6;
    exitButton.clipsToBounds=YES;
    [self.tableView addSubview:exitButton];
}


-(void)exit
{
    //南交所登出
    Go_SouthExchange_Logout;
    [self sendNotification];
    NSString    *firstLoginStr = getUserDefaults(@"FirstLogin");
    [[CMStoreManager sharedInstance] exitLoginClearUserData];
    [[CMStoreManager sharedInstance] setbackgroundimage];
    [self.navigationController popViewControllerAnimated:NO];
    //没有缓存登录信息
    saveUserDefaults(firstLoginStr, @"FirstLogin");
}
- (void)loginUpdate
{
    UIButton * exitBtn = (UIButton*)[_tableView viewWithTag:exitBtn_Tag];
    
    if ([[CMStoreManager sharedInstance] isLogin])
    {
        exitBtn.hidden = NO;
    }else{
        exitBtn.hidden = YES;
    }
}
#pragma mark 表

-(void)loadTable
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    
    [self loadExitButton];
}
#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * rowName = _titleArray[indexPath.row];
    if ([rowName isEqualToString:enviro_row] &&_isChangeOpen)
    {
        return 100;
    }
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    HeaderDividers;
    NSString * rowName = _titleArray[indexPath.row];
    
    UIImageView * imgV = [[UIImageView alloc] init];
    imgV.center = CGPointMake(30, 25);
    imgV.bounds = CGRectMake(0, 0, 17, 17);
    imgV.image = [UIImage imageNamed:_imgNameArray[indexPath.row]];
    [cell addSubview:imgV];
    
    UILabel  * textLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame)+5, 10, 100, 30)];
    textLab.text = _titleArray[indexPath.row];
    textLab.font = [UIFont systemFontOfSize:14];
    [cell addSubview: textLab];
    UILabel * environmentLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-80, 10, 40,30)];
    [cell addSubview:environmentLab];
    
    UIImageView * rowImgV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30, 20, 15, 9)];
    [cell addSubview:rowImgV];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if([rowName isEqualToString: enviro_row]){
        UIButton * openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        openBtn.frame = CGRectMake(0, 0, ScreenWidth, 50);
        [openBtn addTarget:self action:@selector(openSwitch) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:openBtn];
        
        NSArray * btnArray = [NSArray array];
        environmentState = [EnvironmentConfiger sharedInstance].currentSection;
        environmentLab.text = [NSString stringWithFormat:@"%d 区",environmentState];
        environmentLab.textColor = K_color_gray;
        if (_isChangeOpen)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            rowImgV.image = [UIImage imageNamed:@"arrow_1"];
        }else{
            rowImgV.image = [UIImage imageNamed:@""];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        switch (_userStyle)
        {
            case 1:
            {
                btnArray = @[@"1区",@"3区"];
            }
                break;
            case 2:
            {
                btnArray = @[@"1区",@"2区",@"3区"];
            }
                break;
            default:
                break;
        }
        int num = (int)btnArray.count;
        for (int i=0; i<num; i++) {
            int btnNum = [btnArray[i] intValue];
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat btnWidth =  (ScreenWidth-120)/3;
            button.frame = CGRectMake(30+(i%3)*(btnWidth+30), 50+i/3*55, (ScreenWidth-120)/3, 40);
            button.hidden = !_isChangeOpen;
            [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [button setTitle:btnArray[i] forState:UIControlStateNormal];
            button.layer.cornerRadius = 5;
            button.layer.masksToBounds = YES;
            button.layer.borderWidth = 1;
            if (btnNum==environmentState)
            {
                button.layer.borderColor = [K_color_red CGColor];
                button.selected = YES;
                button.enabled = NO;
                [button setTitleColor:K_color_red forState:UIControlStateNormal];
            }else
            {
                button.selected = NO;
                button.enabled = YES;
                button.layer.borderColor = [K_color_gray CGColor];
                [button setTitleColor:K_color_gray forState:UIControlStateNormal];
            }
            button.tag =SwitchEvent_Tag +num;
            [button addTarget:self action:@selector(switchEnvironment:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * rowName = _titleArray[indexPath.row];
    
    if ([rowName isEqualToString:advice_row]) {
        [self goAdvicePage];
        
        
    }else if ([rowName isEqualToString:helperCenter_row])
    {
        [self goHelperPage];
        
    }
    else if ([rowName isEqualToString:share_row])
    {
        [self loadShare];
        
    }
    else if ([rowName isEqualToString:aboutUs_row])
    {
        [self goAboutUsPage];
        
    }
    
}
#pragma mark 意见反馈
- (void)goAdvicePage
{
    AdviceViewController * adviceVC = [[AdviceViewController alloc] init];
    [self.navigationController pushViewController:adviceVC animated:YES];
}
#pragma mark 帮助中心
- (void)goHelperPage
{
    HelpCenterViewController *helperVC=[[HelpCenterViewController alloc]init];
    [self.navigationController pushViewController:helperVC animated:YES];
}
#pragma mark 关于我们
- (void)goAboutUsPage
{
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
#pragma mark 分享
-(void)loadShare
{
    
    
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:App_shareIconName ofType:@"png"];
    NSString *url = @"";
    NSString *niu = @"";
    niu = App_appName;
    url = App_OfficialWeb;
    
    
    [PageChangeControl goShareWithTitle:[NSString stringWithFormat:@"%@\n%@",niu,url]
                                content:[NSString stringWithFormat:@"%@\n%@",niu,url]
                                 urlStr:url
                              imagePath:imagePath];
    
}
- (void)openSwitch
{
    
    if (!_isChangeOpen)
    {
        
        __block PopUpView * inputAlertView = [[PopUpView alloc] initInpuStyleAlertWithTitle:@"验证密码" setInputItemArray:@[@"请输入密码"] setBtnTitleArray:@[@"取消",@"验证"]];
        
        inputAlertView.twoObjectblock = ^(UIButton *button,NSArray*array)
        {
            if (button.tag==66666)
            {
                [inputAlertView removeFromSuperview];
                inputAlertView = nil;
                
            }else
            {
                NSString * passWord = [NSString stringWithFormat:@"%@",array[0]];
                if ([passWord isEqualToString:@""])
                {
                    [UIEngine showShadowPrompt:@"密码不能为空"];
                }
                else{
                    [self clickPassWord:passWord];
                    [inputAlertView removeFromSuperview];
                }
            }
        };
        [self.navigationController.view addSubview:inputAlertView];
    }else{
        _isChangeOpen = !_isChangeOpen;
        UIButton * button = (UIButton*)[self.tableView viewWithTag:exitBtn_Tag];
        button.frame = CGRectMake(20, _titleArray.count*50+30, ScreenWidth-40, 44.0/568*ScreenHeigth);
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:environment_row inSection:0];
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)clickPassWord:(NSString *)psw
{
    NSString * passWord = [[psw MD5Digest] uppercaseString];
    [ManagerHUD showHUD:self.view  animated:YES];
    [RequestDataModel requestEnviromentPassWord:passWord SuccessBlock:^(BOOL success, int clickStatus, NSString *msg) {
        [ManagerHUD hidenHUD];
        if (success) {
            if (clickStatus==1)
            {
                _isChangeOpen = YES;
                UIButton * button = (UIButton*)[self.tableView viewWithTag:exitBtn_Tag];
                button.frame = CGRectMake(20, _titleArray.count*50+30+50, ScreenWidth-40, 44.0/568*ScreenHeigth);
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:environment_row inSection:0];
                [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            [UIEngine showShadowPrompt:msg];
        }else{
        }
    }];
}
-(void)switchEnvironment:(UIButton *)button
{
    __block int btnNum = [button.titleLabel.text intValue];
    NSString * environmentStr = HTTP_IP;
    switch (btnNum)
    {
        case 1:
        {
            environmentStr =  [EnvironmentConfiger sharedInstance].HTTP_IP_ONLINE;
        }
            break;
        case 2:
        {
            environmentStr = [EnvironmentConfiger sharedInstance].HTTP_IP_TEST;
        }
            break;
        case 3:
        {
            environmentStr = [EnvironmentConfiger sharedInstance].HTTP_IP_SIMULATE;
        }
            break;
        default:
            break;
    }
    [self changeEnvironment:environmentStr];
}
- (void)changeEnvironment:(NSString *)str
{
    //清空本地数据库
    [KLineDao deleteAllInfo];
    [UIEngine showShadowPrompt:@"切换成功"];
    [self clearFoyerHistoryData];
    [self exit];
    [[CMStoreManager sharedInstance] setEnvironment:str];
    [[EnvironmentConfiger sharedInstance] setCurrentSection];
    self.gologinBlock();
}
-(void)clearFoyerHistoryData
{
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    cacheModel.productSectionArray = [NSMutableArray array];
    cacheModel.bannerArray      = [NSMutableArray array];
    [CacheEngine setCacheInfo:cacheModel];
    CacheModel *model = [CacheEngine getCacheInfo];
    NSLog(@"%@",model.bannerArray);
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
