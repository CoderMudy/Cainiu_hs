//
//  FoyerPage.m
//  hs
//
//  Created by PXJ on 15/7/24.
//  Copyright (c) 2015年 luckin. All rights reserved.
//
#import "FoyerPage.h"
#import "FoyerTableView.h"
#import "UnLoginView.h"
#import "ActivityPage.h"
#import "ActivityModel.h"
#import "HolidayPopView.h"
#import "FoyerHolidayPage.h"
#import "FoyerScorePage.h"
#import "FindKeFuController.h"
#import "AccountH5Page.h"
#import "PositionViewController.h"
#import "LoginViewController.h"
#import "IndexViewController.h"

#define adImg_tag 1300
#define adBtn_tag 1301

@interface FoyerPage ()<UnLoginViewDelegate>
{
    FoyerTableView *_foyerTableView;
    NSMutableArray * _indexTypeStateArray;    //期货状态数组
    //    BOOL _isposition[4];
    NSString * _IP;
    NSString * _port;
    BOOL isNeedRequestHoliday;//判断是否需要请求假期
    }
//累计帮用户赚到
@property (nonatomic,strong) UILabel * userLab;
//累计提供资金
@property (nonatomic,strong) UILabel * provideLab;
@property (nonatomic,strong) UIView * goCainiuView;
@end

@implementation FoyerPage

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"行情大厅"];
    self.view.backgroundColor = K_color_line;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = NO;
    [_foyerTableView viewAppearLoadData];
 
}
ShowGestureMethod
- (void)viewDidLoad {
    [super viewDidLoad];

    if ([[CMStoreManager sharedInstance] isLogin]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"uFirstOpenClearLoginInfo" object:nil];

    }
    
    //添加手势通知
    ShowGestureNotification;
    //    self.title = @"行情大厅";
    UIView * navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    navView.backgroundColor = K_color_NavColor;
    [self.view addSubview:navView];
    UILabel * navTitle = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, ScreenWidth-200, 44)];
    navTitle.text = @"行情大厅";
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.font = [UIFont systemFontOfSize:16];
    navTitle.textColor = [UIColor whiteColor];
    [navView addSubview:navTitle];

    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(ScreenWidth-70, 20, 60, 44);
    [leftBtn.titleLabel setFont:FontSize(13)];
    [leftBtn setTitle:@" 客服" forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"foyer_2"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(clickKeFu) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:leftBtn];
    _indexTypeStateArray = [NSMutableArray array];
    if([[CMStoreManager sharedInstance] getFoyerPageStatus])
    {
        _indexTypeStateArray =[[CMStoreManager sharedInstance] getFoyerPageStatus];
    }
    [self initView]; //初始化界面视图

}
#pragma mark 页面跳转
- (void)pushChangeWithPage:(NSString*)pushPage dic:(NSDictionary*)dic productModel:(FoyerProductModel*)productModel
{
    //积分盘
    if ([pushPage isEqualToString:@"FoyerScorePage"])
    {
        FoyerScorePage * vc = [[FoyerScorePage alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    //假期盘
    if ([pushPage isEqualToString:@"FoyerHolidayPage"])
    {
        FoyerHolidayPage * vc = [[FoyerHolidayPage alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    //登录
    if ([pushPage isEqualToString:@"LoginViewController"])
    {
        [self remindLogin];
    }
    //股票
    if ([pushPage isEqualToString:@"PositionViewController"])
    {
        PositionViewController * positionVC = [[PositionViewController alloc] init];
        [self.navigationController pushViewController:positionVC animated:YES];
    }
    //任务中心
    if ([pushPage isEqualToString:@"TaskCenterH5Page"])
    {
        if([[CMStoreManager sharedInstance] getAccountCainiuStatus]){
            //任务中心
            AccountH5Page * vc = [[AccountH5Page alloc] init];
            vc.url           = [NSString stringWithFormat:@"%@/activity/award.html?version=8&abc=%u",K_MGLASS_URL,arc4random()%999];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            [self goOpenCainiuAccount];
             
        }
   }
    //活动页
    if ([pushPage isEqualToString:@"ActivityPage"])
    {
        NSString * htmlStr      = dic[@"html"]==nil?@"":dic[@"html"];
        ActivityModel * model   =  [[ActivityModel alloc] init];
        model.titleName         = dic[@"titleName"]==nil?@"活动":dic[@"titleName"];
        model.htmlUrl           = [NSString stringWithFormat:@"%@?version=8&abc=%d",htmlStr,arc4random()%999];
        ActivityPage * activityVC = [[ActivityPage alloc] init];
        activityVC.activityModel = model;
        [self.navigationController pushViewController:activityVC animated:YES];
    }
    //进入行情页
    if ([pushPage isEqualToString:@"IndexViewController"])
    {
        IndexViewController * indexVC   = [[IndexViewController alloc] init];
        indexVC.ip                      = dic[@"ip"];
        indexVC.port                    = dic[@"port"];
        indexVC.name                    = productModel.commodityName;
        indexVC.code                    = productModel.instrumentID;
        indexVC.isPosition              = [dic[@"isPosition"] boolValue];
        indexVC.productModel            = productModel;
        if ([self.navigationController.viewControllers.lastObject isKindOfClass:[FoyerPage class]]) {
            [self.navigationController pushViewController:indexVC animated:YES];
        }
    }
    //弹弹窗
    if ([pushPage isEqualToString:@"PopUpView"]) {
        PopUpView * popVIew = [[PopUpView alloc] initShowAlertWithShowText:@"敬请期待" setBtnTitleArray:@[@"确定"]];
        popVIew.confirmClick = ^(UIButton * button)
        {
            
        };
        [self.navigationController.view addSubview:popVIew];

    }
    if ([pushPage isEqualToString:@"OpenCainiuAccountPage"]) {
        AccountH5Page * vc = [[AccountH5Page alloc] init];
        vc.url = [NSString stringWithFormat:@"%@/account/openAccount.html?version=8&abc=%u",K_MGLASS_URL,arc4random()%999];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 初始化页面控件
- (void)initView
{
    __weak typeof(self) weakSelf = self;

    //表
    _foyerTableView             = [[FoyerTableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64-50)];
    _foyerTableView.backStyle   = BackStyleDefault;
    _foyerTableView.pushBlock   = ^(NSString * pushPage,NSDictionary * dic,FoyerProductModel *productModel){
        [weakSelf pushChangeWithPage:pushPage dic:dic productModel:productModel];
    };
    [self.view addSubview:_foyerTableView];
   

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

- (void)remindLogin
{
    PopUpView * loginAlertView = [[PopUpView alloc] initShowAlertWithShowText:@"请先登录" setBtnTitleArray:@[@"取消",@"登录"]];
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
                loginVC.isBackLastPage = YES;
                [self.navigationController pushViewController:loginVC animated:YES];
            }
                break;
            default:
                break;
        }
    };
}
#pragma mark clickKeFu客服
-(void)clickKeFu{
    [PageChangeControl goKeFuWithSource:self];
}




- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"行情大厅"];
    [_foyerTableView viewDisAppearLoadData];
    [ManagerHUD hidenHUD];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    ReceiveMemaryWarning;
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
