//
//  FindPage.m
//  hs
//
//  Created by PXJ on 15/7/24.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "FindPage.h"
#import "FindTableViewCell.h"
#import "SystemMessagePage.h"
#import "TraderRemindPage.h"
#import "NetRequest.h"
#import "SpreadPage.h"
#import "FindHeaderView.h"
#import "PartnerPage.h"
#import "AdviceViewController.h"
#import "SaleSystemSpreadPage.h"
#import "FindKeFuController.h"
#import "ActionCenter.h"
#import "AccountH5Page.h"



@interface FindPage ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * _nameArray;
    NSArray * _detailArray;
    NSArray * _imageNameArray;
    NSArray * _enableArray;
    NSMutableDictionary * _msgCountDictionary;
    BOOL isShowRedBag;
    
}
@property (nonatomic,strong)UITableView * tableView;

@end

@implementation FindPage
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"发现"];
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = NO;
    
    UIView  * view = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeigth-49, ScreenWidth, 0.5)];
    view.backgroundColor = K_color_line;
    view.tag = 55555;
    [self.rdv_tabBarController.view addSubview:view];
    if ([[CMStoreManager sharedInstance] isLogin]) {
        [self getMessageCount];
        if (!AppStyle_SAlE) {
            [self getTaskRedEnable];// 非销售系统任务中心不加载
        }
    }else{
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"发现"];
    UIView * tabbarLine = [self.rdv_tabBarController.view viewWithTag:55555];
    //    self.rdv_tabBarController.tabBarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [tabbarLine removeFromSuperview];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initNav];
    [self initData];
    [self initTableView];
}
- (void)initNav
{
    NavView * nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    nav.titleLab.text = @"发现";
    [nav hiddenleft];
    [self.view addSubview:nav];
    
}
- (void)initData
{
    _msgCountDictionary = [NSMutableDictionary dictionary];
    _nameArray = @[@"推广赚钱",@"消息中心",@"交易提醒",@"任务中心"];
    _detailArray = @[@"0成本 轻松赚",@"重大消息都在这",@"及时交易时时提醒",@"红包抢不停"];
    _imageNameArray = @[@"findPage_01",@"findPage_02",@"findPage_04",@"findPage_06"];
    _enableArray = @[@"1",@"1",@"1",@"1"];
//    if (AppStyle_SAlE) {
//        _enableArray = @[@"1",@"0",@"0",@"0",@"0",@"0",@"0"];
//        
//    }
}

- (void)getMessageCount//
{
    
    
    NSString * token = [[CMStoreManager sharedInstance] getUserToken];
    token = token==nil?@"":token;
    NSString * url = K_sms_MsgCount;
    [NetRequest postRequestWithNSDictionary:@{@"token":token} url:url successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"]intValue]==200) {
            _msgCountDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary[@"data"]];
            [self loadtableViewData];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
#pragma mark 判断任务中心是否显示红包
- (void)getTaskRedEnable
{
    
    [RequestDataModel requestUserIsEnableRedBag:^(BOOL success, BOOL enable) {
        
        if (success) {
            
            isShowRedBag = enable;
            
        }else{
            
            isShowRedBag = NO;
        }
        [self loadtableViewData];
    }];
    
}
- (void)loadtableViewData
{
    
    [_tableView reloadData];
    
    
}
- (void)initTableView
{
//    FindHeaderView * findHeaderView = [[FindHeaderView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 200*ScreenWidth/375)];
//    findHeaderView.clickViewBlock = ^(int cliViewNum){
//        
//        
//        switch (cliViewNum) {
//            case 1://推广赚钱
//            {
//                [self clickSpread];
//            }
//                break;
//            case 2://消息中心
//            {
//                [_msgCountDictionary setObject:@"0" forKey:@"system"];
//                SystemMessagePage * sysMsgVC = [[SystemMessagePage alloc] init];
//                [self.navigationController pushViewController:sysMsgVC animated:YES];
//            }
//                break;
//            case 3://客服中心
//            {
//                [self clickKeFu];
//            }
//                break;
//                
//            default:
//                break;
//        }
//    };
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-113) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[FindTableViewCell class] forCellReuseIdentifier:@"findCell"];
    
    [self.view addSubview:_tableView];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _nameArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"findCell" forIndexPath:indexPath];
    int row = (int)indexPath.row;
    
    BOOL newRemind ;
    BOOL showRedBag;
    newRemind = NO;
    showRedBag = NO;
    
    switch ((int)indexPath.row) {
        case 0:
        {
            
            if ([[CMStoreManager sharedInstance]isLogin]) {
                newRemind = [_msgCountDictionary[@"trader"]intValue]>0?YES:NO;
            }else{
                newRemind = NO;
            }
        }
            break;
        case 1:{
            if ([[CMStoreManager sharedInstance]isLogin]) {
                showRedBag = isShowRedBag;
            }else{
                showRedBag = YES;
            }
        }
            break;
            
        default:
            break;
    }
    
    [cell setNewMsgRemind:newRemind redBag:showRedBag];
    BOOL enableClick = [_enableArray[indexPath.row] boolValue];
    if (enableClick) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setCellDetailWithImageName:_imageNameArray[row] name:_nameArray[row] detailText:_detailArray[row] enableClick:enableClick];
    return cell;
    
    
}

- (void)changeCellBack:(FindTableViewCell*)cell
{
    cell.backgroundColor = [UIColor whiteColor];
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_enableArray[indexPath.row] boolValue]) {
        
        [_tableView deselectRowAtIndexPath:indexPath animated:NO];
        
    }
    
    switch (indexPath.row) {
        case 0://交易提醒
        {
            
            if ([[CMStoreManager sharedInstance] isLogin]) {
                if([[CMStoreManager sharedInstance] getAccountCainiuStatus]){
                    
                    [_msgCountDictionary setObject:@"0" forKey:@"trader"];
                    TraderRemindPage * traderVC = [[TraderRemindPage alloc] init];
                    [self.navigationController pushViewController:traderVC animated:YES];
                }else{
                    [self goOpenCainiuAccount];
                    
                }
            }else{
                
                [self goLogin];
            }
        }
            break;
            
        case 1:{
            if (AppStyle_SAlE) {
                break;
            }
            [_tableView deselectRowAtIndexPath:indexPath animated:NO];
            
            if ([[CMStoreManager sharedInstance] isLogin]) {
                if([[CMStoreManager sharedInstance] getAccountCainiuStatus]){
                    
                    AccountH5Page * vc = [[AccountH5Page alloc] init];
                    vc.url = [NSString stringWithFormat:@"%@/activity/award.html?version=8&abc=%u",K_MGLASS_URL,arc4random()%999];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [self goOpenCainiuAccount];
                }
            }else{
                
                [self goLogin];
            }
            break;
            
        }
            
        case 2://活动中心
        {
            
            ActionCenter * actionCenter = [[ActionCenter alloc] init];
            actionCenter.titleNav = @"活动中心";
            actionCenter.urlStr =[NSString stringWithFormat:@"%@/activity/hdCenter.html?version=8&abc=%@",K_MGLASS_URL,[Helper randomGet]];
            [self.navigationController pushViewController:actionCenter animated:YES];
        }
            break;
            
        default:
            
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenWidth*70/375;
}
#pragma mark 开启财牛账户
- (void)goOpenCainiuAccount
{
    
    PopUpView * loginAlertView = [[PopUpView alloc] initShowAlertWithShowText:[NSString stringWithFormat:@"您还没有开启%@账户",App_appShortName] setBtnTitleArray:@[@"取消",@"立即开启"]];
    [self.navigationController.view addSubview:loginAlertView];
    loginAlertView.confirmClick = ^(UIButton * button){
        switch (button.tag) {
            case 66666:
            {
            }
                break;
            case 66667:
            {
                AccountH5Page *h5 = [[AccountH5Page alloc]init];
                h5.url = [NSString stringWithFormat:@"%@/account/openAccount.html?abc=%u&token=%@&type=original",K_MGLASS_URL,arc4random()%999,[[CMStoreManager sharedInstance] getUserToken]];;
                [self.navigationController pushViewController:h5 animated:YES];
                
            }
                break;
            default:
                break;
        }
    };
}

#pragma mark 去登录
- (void)goLogin
{
    
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
#pragma mark clickSpread推广赚钱
-(void)clickSpread
{
    
    if ([[CMStoreManager sharedInstance] isLogin]) {
        
        if(AppStyle_SAlE){
            
            SaleSystemSpreadPage * vc = [[SaleSystemSpreadPage alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
            return;
        }
        if([[CMStoreManager sharedInstance] getAccountCainiuStatus]){
            
            
            
            [ManagerHUD showHUD:self.view animated:YES];
            [RequestDataModel requestUserIsSpreadSuccess:^(BOOL success, int isSpreadUser) {
                [ManagerHUD hidenHUD];
                if (success) {
                    
                    if(isSpreadUser==3) {
                        PartnerPage * partnerPage = [[PartnerPage alloc] init];
                        [self.navigationController pushViewController:partnerPage animated:YES];
                        
                    }else
                    {
                        [self goSpread];
                    }
                }else
                {
                    [self goSpread];
                    
                }
            }];
        }else{
            [self goOpenCainiuAccount];
            
        }
    }else{
        
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
}
- (void)goSpread
{
    AccountH5Page * vc = [[AccountH5Page alloc] init];
    vc.url =[NSString stringWithFormat:@"%@/activity/spread.html?abc=%@",K_MGLASS_URL,[Helper randomGet]];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark clickKeFu客服
-(void)clickKeFu{
    FindKeFuController *kefuVC = [[FindKeFuController alloc]init];
    [self.navigationController pushViewController:kefuVC animated:YES];
}
-(void)leftButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if (_tableView.contentOffset.y<0) {
        _tableView.contentOffset = CGPointMake(0, 0);
        
    }
    
}// any offset changes


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
