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
@property (nonatomic,strong) HolidayPopView * holidayPopView;
//累计帮用户赚到
@property (nonatomic,strong) UILabel * userLab;
//累计提供资金
@property (nonatomic,strong) UILabel * provideLab;
@property (nonatomic,strong) UnLoginView * unloginView;
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
    if (_unloginView.hidden)
    {
        [_unloginView ADShowNeedTest:YES];
        [self.rdv_tabBarController.view bringSubviewToFront:_unloginView];
    }else
    {
        [self.rdv_tabBarController.view bringSubviewToFront:_unloginView];
    }
    [self chickSafe];//判断了解财牛
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
    navView.backgroundColor = K_color_red;
    [self.view addSubview:navView];
    UILabel * navTitle = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, ScreenWidth-200, 44)];
    navTitle.text = @"行情大厅";
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.font = [UIFont systemFontOfSize:16];
    navTitle.textColor = [UIColor whiteColor];
    [navView addSubview:navTitle];
    UIImageView * adbuttonImg = [[UIImageView alloc] init];
    adbuttonImg.image = [UIImage imageNamed:@"foyer_1"];
    adbuttonImg.center =CGPointMake(ScreenWidth-27, 42);
    adbuttonImg.bounds =  CGRectMake(0, 0, 20, 20);
    [navView addSubview:adbuttonImg];
    UIControl * control = [[UIControl alloc] init ];//WithFrame:adbuttonImg.frame];
    control.center = adbuttonImg.center;
    control.bounds = CGRectMake(0, 0, 44, 44);
    [control addTarget:self action:@selector(showAdvert) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:control];
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 20, 80, 44);
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
    __block UIImageView * adimg = adbuttonImg;
    __block UIControl *adcotrol = control;
    _unloginView.showBtnHidden = ^(BOOL hidden){
        //如果 Hidden==yes 则广告的图标不需要出现
        adimg.hidden = hidden;
        adcotrol.hidden = hidden;
    };
}
#pragma mark 点击广告图标，弹出广告窗口
-(void)showAdvert
{
    [_unloginView unloginViewHidden:NO];
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
    _foyerTableView             = [[FoyerTableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-144)];
    _foyerTableView.backStyle   = BackStyleDefault;
    _foyerTableView.pushBlock   = ^(NSString * pushPage,NSDictionary * dic,FoyerProductModel *productModel){
        [weakSelf pushChangeWithPage:pushPage dic:dic productModel:productModel];
    };
    [self.view addSubview:_foyerTableView];
    
    
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeigth-50-30, ScreenWidth, 30.5)];
    backView.backgroundColor= K_COLOR_CUSTEM(255, 251, 248, 1);
    [self.view addSubview:backView];
    
    NSString * yellowText       = @"人保财险";
    NSString * strText          = @"账户资金安全由";
    NSString * str              = @"账户资金安全由人保财险承保";
    NSAttributedString * atrStr = [Helper multiplicityText:str from:(int)strText.length to:(int)yellowText.length color:K_COLOR_CUSTEM(200, 120, 40, 1)];
    CGFloat warnLabWidth        = [Helper calculateTheHightOfText:str height:16 font:FontSize(12)];
    UILabel * warnLab           = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-warnLabWidth/2 +ScreenWidth/50, ScreenHeigth-49-30, warnLabWidth, 30)];
    warnLab.attributedText = atrStr;
    warnLab.font                = FontSize(12);
    [self.view addSubview:warnLab];
    
    UIImageView * imgV_icon1     = [[UIImageView alloc] init];
    imgV_icon1.image             = [UIImage imageNamed:@"1"];
    imgV_icon1.center            = CGPointMake(warnLab.frame.origin.x-ScreenWidth/50-5, warnLab.center.y);
    imgV_icon1.bounds            = CGRectMake(0, 0, 14, 14);
    [self.view addSubview:imgV_icon1];
    
#if defined (YQB)
    
#else
    
    _goCainiuView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeigth-50-30, ScreenWidth, 30)];
    _goCainiuView.backgroundColor = K_COLOR_CUSTEM(255, 251, 248, 1);
    [self.view addSubview:_goCainiuView];
    
    CGFloat cainiuLength        = [Helper calculateTheHightOfText:[NSString stringWithFormat:@"点击了解%@",App_appShortName] height:14 font:FontSize(12)];
    UILabel * cainiuLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-cainiuLength/2 +ScreenWidth/50, 0, cainiuLength, 30)];
    cainiuLab.backgroundColor = K_COLOR_CUSTEM(255, 251, 248, 1);
    cainiuLab.textColor = K_color_red;
    cainiuLab.text = [NSString stringWithFormat:@"点击了解%@",App_appShortName];
    cainiuLab.textAlignment = NSTextAlignmentCenter;
    cainiuLab.font = FontSize(12);
    [_goCainiuView addSubview:cainiuLab];
    
    UIImageView * imgV_icon2     = [[UIImageView alloc] init];
    imgV_icon2.image             = [UIImage imageNamed:@"1"];
    imgV_icon2.center            = CGPointMake(cainiuLab.frame.origin.x-ScreenWidth/50-5, cainiuLab.center.y);
    imgV_icon2.bounds            = CGRectMake(0, 0, 14, 14);
    [_goCainiuView addSubview:imgV_icon2];
    
    
    
    UIControl * control = [[UIControl alloc] init];
    control.center = warnLab.center;
    control.bounds = CGRectMake(0, 0, warnLab.frame.size.width+40, warnLab.frame.size.height);
    [control addTarget:self action:@selector(goSafeAgreement) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
#endif

    
    CacheModel * casheModel = [CacheEngine getCacheInfo];
    NSString * isclick = casheModel.isClickLJCN;
    if (![isclick isEqualToString:@"YES"]) {
        _goCainiuView.hidden = NO;
    }else{
        _goCainiuView.hidden = YES;
    }

    
    _unloginView = [[UnLoginView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
    _unloginView.delegate = self;
    _unloginView.hidden= YES;
    _unloginView.imgClickBlock = ^(NSString * adTitle,NSString * imgUrl)
    {
        ActivityPage * adtivit = [[ActivityPage alloc] init];
        ActivityModel * activitymodel = [[ActivityModel alloc]init];
        activitymodel.titleName = adTitle;
        activitymodel.htmlUrl= [NSString stringWithFormat:@"%@?version=8&abc=%d",imgUrl,arc4random()%999];
        adtivit.activityModel = activitymodel;
        [weakSelf.navigationController pushViewController:adtivit animated:YES];
    };
    [self.rdv_tabBarController.view addSubview:_unloginView];
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
#pragma mark 了解财牛
- (void)chickSafe
{
    CacheModel * casheModel = [CacheEngine getCacheInfo];
    if (![casheModel.isClickLJCN isEqualToString:@"YES"])
    {
        _goCainiuView.hidden = NO;
    }else{
        _goCainiuView.hidden = YES;
    }
}
#pragma mark 了解财牛跳转
- (void)goSafeAgreement
{
    CacheModel * casheModel = [CacheEngine getCacheInfo];
    if (![casheModel.isClickLJCN isEqualToString:@"YES"])
    {
        casheModel.isClickLJCN = [NSString stringWithFormat:@"YES"];
        [CacheEngine setCacheInfo:casheModel];
        _goCainiuView.hidden = YES;
    }
    ActivityPage * adtivit = [[ActivityPage alloc] init];
    adtivit.webView.backgroundColor = Color_black;
    adtivit.view.backgroundColor = Color_black;
    adtivit.webView.scrollView.backgroundColor = Color_black;
    adtivit.webView.scrollView.bounces = NO;
    ActivityModel  * activitymodel = [[ActivityModel alloc] init];
    activitymodel.titleName = App_appShortName;
    activitymodel.htmlUrl= [NSString stringWithFormat:@"%@/activity/aboutus.html?abc=%d",K_MGLASS_URL,arc4random()%999];
    adtivit.activityModel = activitymodel;
    [self.navigationController pushViewController:adtivit animated:YES];
}

#pragma mark -设置刷新View数据m
- (void)setPUllRefreshViewWithDictionary:(NSDictionary*)dictionary
{
    NSString * amtValue = [NSString stringWithFormat:@"%@",dictionary[@"profit"]];
    float amtV = amtValue.floatValue;
    amtValue =[DataEngine addSign:[NSString stringWithFormat:@"%.2f",amtV]];
    amtValue = [NSString stringWithFormat:@"%@元",amtValue];
    NSAttributedString * amtAttriStr= [Helper multiplicityText:amtValue from:(int)(amtValue.length-1) to:1 font:12];
    amtAttriStr = [Helper multableText:amtAttriStr from:0 to:(int)amtAttriStr.length-1 color:K_COLOR_CUSTEM(242, 40, 58, 1)];
    _userLab.attributedText = [Helper multableText:amtAttriStr from:(int)amtAttriStr.length-1 to:1 color:K_COLOR_CUSTEM(153, 153, 153, 1)];
    NSString *profitValue = [NSString stringWithFormat:@"%@",dictionary[@"amt"]];
    float profitV = profitValue.floatValue;
    profitValue =[DataEngine addSign:[NSString stringWithFormat:@"%.2f",profitV]];
    profitValue = [NSString stringWithFormat:@"%@元",profitValue];
    NSAttributedString * profitAttriStr= [Helper multiplicityText:profitValue from:(int)(profitValue.length-1) to:1 font:12];
    profitAttriStr = [Helper multableText:profitAttriStr from:0 to:(int)profitAttriStr.length-1 color:K_COLOR_CUSTEM(242, 40, 58, 1)];
    _provideLab.attributedText = [Helper multableText:profitAttriStr from:(int)profitAttriStr.length-1 to:1 color:K_COLOR_CUSTEM(153, 153, 153, 1)];
}
- (void)requestHoliday
{
    __weak typeof(self) weakSelf = self;
    [RequestDataModel requestMarkerIsHolidaySuccessBlock:^(BOOL success, BOOL isHoliDay, NSString *holiDay)
    {
        if (success)
        {
            holiDay = [NSString stringWithFormat:@"%@000000",holiDay];
            if (isHoliDay)
            {
                CacheModel * cacheModel = [CacheEngine getCacheInfo];
                if (cacheModel.holidayCacheModel ==nil) {
                    cacheModel.holidayCacheModel = [[HolidayCacheModel alloc] init];
                }
                NSString * holiDayDate = [NSString stringWithFormat:@"%@",cacheModel.holidayCacheModel.holidayDic[@"holiDayDate"]];
                NSString * holiDayOpenTime = [NSString stringWithFormat:@"%@",cacheModel.holidayCacheModel.holidayDic[@"holiDayOpenTime"]];
                NSDate * nowDate = [NSDate date];
                NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyyMMddHHmmss"];
                NSString * nowTime = [formatter stringFromDate:nowDate];
                if ([holiDayDate isEqualToString:holiDay])
                {
                    NSInteger difValue = [Helper countTimeWithNewTime:nowTime lastDate:holiDayOpenTime];
                    if (difValue>3*60*60)
                    {
                        [weakSelf cacheHoliday:holiDay openTime:nowTime];
                    }
                }else
                {
                    [weakSelf cacheHoliday:holiDay openTime:nowTime];
                }
            }
        }
    }];
}
#pragma mark 缓存假期信息并判断是否打开
- (void)cacheHoliday:(NSString *)holiday openTime:(NSString*)openTime
{
    CacheModel * cacheModel = [CacheEngine getCacheInfo];
    if (cacheModel.holidayCacheModel ==nil)
    {
        cacheModel.holidayCacheModel = [[HolidayCacheModel alloc] init];
    }
    cacheModel.holidayCacheModel.holidayDic = @{@"holiDayDate":holiday,@"holiDayOpenTime":openTime};
    [CacheEngine setCacheInfo:cacheModel];
    if (!_holidayPopView.isShow)
    {
        __weak typeof(self) weakSelf = self;
        _holidayPopView = [[HolidayPopView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
        _holidayPopView.goHolidayBlock = ^(){
            [weakSelf goHolidayPage];
        };
        _holidayPopView.hidden = YES;
        _holidayPopView.isShow = YES;
        [self.view addSubview:_holidayPopView];
        [_holidayPopView unloginViewHidden:NO];
        
    }
}
#pragma mark 跳转节假日场
- (void)goHolidayPage
{
    FoyerHolidayPage * foyerVC = [[FoyerHolidayPage alloc] init];
    [self.navigationController pushViewController:foyerVC animated:YES];
}
- (void)closePopView
{
    if (isNeedRequestHoliday)
    {
        [self requestHoliday];
        isNeedRequestHoliday = NO;
    }
}
- (void)isNeedShowUnLogView:(BOOL)isNeedShow
{
    if (!isNeedShow)
    {
        [self requestHoliday];
    }else{
        isNeedRequestHoliday = YES;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"行情大厅"];
    [_foyerTableView viewDisAppearLoadData];
    [self.rdv_tabBarController.view sendSubviewToBack:_unloginView];
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
