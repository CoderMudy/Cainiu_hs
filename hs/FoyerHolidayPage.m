//
//  FoyerHolidayPage.m
//  hs
//
//  Created by PXJ on 16/1/4.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "FoyerHolidayPage.h"
#import "FoyerHolidayView.h"
#import "PositionViewController.h"
#import "IndexViewController.h"
#import "LoginAndRegistView.h"
#import "RegViewController.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"


#define textFont_S 10
#define textFont_M 17
#define textFont_L 20
#define userScore_Tag 50001
#define curScore_Tag 50002
#define holiday_yellowColor  K_COLOR_CUSTEM(233, 153, 14, 1)
@interface FoyerHolidayPage ()
{
    NSString *             _isClear;
    NSString * _IP;
    NSString * _port;
    NSMutableArray * _positionNumArray;
    NSMutableArray * _positionCashNumArray;
    NSString * _enableScore;//可用积分
    NSString * _curCashScore;//冻结积分
    NSString * _lastPrice;
    NSString * _percentage;
    NSTimer * _dataTimer;
}
@property (nonatomic,strong)UIView * logRegView;//登录注册蒙层
@property (nonatomic,strong)UIView * userScoreView; //顶部积分
@property (nonatomic,strong)FoyerProductModel * productModel;
@property (nonatomic,strong)FoyerHolidayView * productView;//品种展示框
@property (nonatomic,strong)NavView * nav;
@property (nonatomic,strong)UIView * warnView;//底部文字显示view
@property (nonatomic,strong)UILabel * nickLab;
@property (nonatomic,strong)UILabel * signLab;
@property (nonatomic,strong)UILabel * profitLab;
@property (nonatomic,strong)UIButton * goHistoryBtn;

@end

@implementation FoyerHolidayPage

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self requestHoliday];//判断是否为假期
    
    if ([[CMStoreManager sharedInstance] isLogin]) {
        [self getpositionNum];
        [self requestCainiuUserScore];//请求用户积分
        [self updateUILogin:YES];
        [self loadUserMessage];//刷新用户昵称签名
        [self requestUserProfit];//请求用户盈利
        [self initWarningView];
        
    }else{
        [self updateUILogin:NO];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = NO;
    [_dataTimer invalidate];
    _dataTimer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initNav];
    [self initUI];
    [self initLoginView];//初始化未登录时的蒙层
    
}
- (void)initData
{
    
}
- (void)initNav
{
    _nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _nav.titleLab.text = @"节假日历史盘";
    [_nav.leftControl addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];
}
- (void)initUI
{
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64)];
    scrollView.scrollEnabled = ScreenHeigth>=568?NO:YES;
    scrollView.contentSize = ScreenHeigth>=568?CGSizeMake(ScreenWidth, ScreenHeigth-64):CGSizeMake(ScreenWidth, 568-64);
    scrollView.backgroundColor = K_color_Purple;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    
    CGFloat headerCenter_Y = 190*ScreenWidth/375 - 64*ScreenWidth/375;
    self.view.backgroundColor = K_color_Purple;
    //    UIImageView * backImg1 = [[UIImageView alloc] init ];
    //    backImg1.center = CGPointMake(ScreenWidth/2, 255*ScreenWidth/375);
    //    backImg1.bounds = CGRectMake(0, 0, ScreenWidth, ScreenWidth*135/375);
    //    backImg1.image = [UIImage imageNamed:@"foyer_9"];
    //    [self.view addSubview:backImg1];
    //
    _userScoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80*ScreenWidth/375)];
    _userScoreView.backgroundColor = K_color_Purple;
    [scrollView addSubview:_userScoreView];
    
    UIImageView * userScoreImg = [[UIImageView alloc] init];
    userScoreImg.center = CGPointMake(24, 27);
    userScoreImg.bounds = CGRectMake(0, 0, 9, 8.5);
    userScoreImg.image = [UIImage imageNamed:@"foyer_15"];
    [_userScoreView addSubview:userScoreImg];
    
    UILabel * userScoreTitle = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, ScreenWidth/2, 15)];
    userScoreTitle.text = @"可用积分";
    userScoreTitle.textColor = K_color_gray;
    userScoreTitle.font = FontSize(textFont_S);
    [_userScoreView addSubview:userScoreTitle];
    
    UILabel * userScore = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(userScoreTitle.frame), ScreenWidth/2, 20)];
    userScore.tag = userScore_Tag;
    userScore.textColor = K_color_red;
    userScore.font = FontSize(textFont_M);
    userScore.text = @"0";
    [_userScoreView addSubview:userScore];
    
    UILabel * curScore = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(userScore.frame), ScreenWidth/2, 15)];
    curScore.tag = curScore_Tag;
    curScore.textColor = K_color_gray;
    curScore.font = FontSize(textFont_S);
    curScore.text = @"冻结积分（0）";
    [_userScoreView addSubview:curScore];
    
    UIImageView * rankImg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30-30, 15, 30, 30)];
    rankImg.image = [UIImage imageNamed:@"foyer_8"];
    [_userScoreView addSubview:rankImg];
    UILabel * rankLab = [[UILabel alloc] init];
    rankLab.center = CGPointMake(rankImg.center.x, 52);
    rankLab.bounds = CGRectMake(0, 0, 80, 12);
    rankLab.text = @"查看排名";
    rankLab.font = FontSize(textFont_S);
    rankLab.textColor = holiday_yellowColor;
    rankLab.textAlignment = NSTextAlignmentCenter;
    [_userScoreView addSubview:rankLab];
    
    UIImageView * backImg2 = [[UIImageView alloc] init ];
    backImg2.center = CGPointMake(ScreenWidth/2, 190*ScreenWidth/375);
    backImg2.bounds = CGRectMake(0, 0, ScreenWidth, 180*ScreenWidth/375);
    backImg2.image = [UIImage imageNamed:@"foyer_11"];
    [scrollView addSubview:backImg2];
    
    
    UIView * headerBack = [[UIView alloc] init];
    headerBack.center = CGPointMake(ScreenWidth/2, headerCenter_Y+2);
    headerBack.bounds = CGRectMake(0, 0, 74*ScreenWidth/375, 74*ScreenWidth/375);
    headerBack.backgroundColor = K_COLOR_CUSTEM(71, 14, 52, 1);
    headerBack.layer.cornerRadius = 37*ScreenWidth/375;
    headerBack.layer.masksToBounds = YES;
    [scrollView addSubview:headerBack];
    
    UIImageView * headerImg = [[UIImageView alloc] init];
    headerImg.center =  headerBack.center;
    headerImg.bounds = CGRectMake(0, 0, 64*ScreenWidth/375, 64*ScreenWidth/375);
    headerImg.layer.cornerRadius = 32*ScreenWidth/375;
    headerImg.layer.masksToBounds = YES;
//    headerImg.image = [UIImage imageNamed:@"foyer_10"];
//    [headerImg sd_setImageWithURL:[NSURL URLWithString:[[CMStoreManager sharedInstance] getUserHeader]] placeholderImage:[UIImage imageNamed:@"head_01"]];
    [headerImg setImage:[[CMStoreManager sharedInstance] getUserHeader]];


    [scrollView addSubview:headerImg];
    
    _nickLab = [[UILabel alloc] init];
    _nickLab.center = CGPointMake(ScreenWidth/2, headerCenter_Y+47*ScreenWidth/375);
    _nickLab.bounds = CGRectMake(0, 0, ScreenWidth, 20);
    _nickLab.textColor = [UIColor whiteColor];
    _nickLab.textAlignment = NSTextAlignmentCenter;
    _nickLab.font = FontSize(textFont_M);
    [scrollView addSubview:_nickLab];
    
    _signLab = [[UILabel alloc] init ];
    _signLab.center = CGPointMake(ScreenWidth/2, _nickLab.center.y+15*ScreenWidth/375);
    _signLab.bounds = CGRectMake(0, 0, ScreenWidth*3/5, 14);
    _signLab.textColor = K_color_gray;
    _signLab.textAlignment = NSTextAlignmentCenter;
    _signLab.font = FontSize(textFont_S);
    [scrollView addSubview:_signLab];
    
    UILabel * nowProfitTitle = [[UILabel alloc] init];
    nowProfitTitle.center = CGPointMake(ScreenWidth/2, _signLab.center.y+28*ScreenWidth/375);
    nowProfitTitle.bounds = CGRectMake(0, 0, 100, 15);
    nowProfitTitle.font = FontSize(textFont_S);
    nowProfitTitle.text = @"目前盈利";
    nowProfitTitle.textColor = K_color_gray;
    nowProfitTitle.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:nowProfitTitle];
    
    _profitLab = [[UILabel alloc] init];
    _profitLab.center = CGPointMake(ScreenWidth/2, nowProfitTitle.center.y+20*ScreenWidth/375);
    _profitLab.bounds = CGRectMake(0, 0, ScreenWidth, 25);
    _profitLab.font = FontSize(textFont_L);
    _profitLab.text = @"0";
    _profitLab.textAlignment = NSTextAlignmentCenter;
    _profitLab.textColor = K_color_red;
    [scrollView addSubview:_profitLab];
    
    _productView = [[FoyerHolidayView alloc] initWithFrame:CGRectMake(50*ScreenWidth/375, 280*ScreenWidth/375, ScreenWidth-100*ScreenWidth/375, 175*ScreenWidth/375) style:FoyerHolidayProductStyle];
    [scrollView addSubview:_productView];
    
    CGFloat warnHeight = ScreenHeigth>480?(ScreenHeigth-CGRectGetMaxY(_productView.frame)-64):(504 -CGRectGetMaxY(_productView.frame));
    _warnView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_productView.frame), ScreenWidth,warnHeight)];
    [scrollView addSubview:_warnView];
    [self initWarnPopView];
    
    _goHistoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _goHistoryBtn.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64);
    [self.view addSubview:_goHistoryBtn];
    
    UIControl * rankControl = [[UIControl alloc] init];
    rankControl.center = CGPointMake(rankImg.center.x, 64+rankImg.center.y+5);
    rankControl.bounds = CGRectMake(0, 0, 40, 50);
    [rankControl addTarget:self action:@selector(rankClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rankControl];
    

}
- (void)initWarnPopView
{
    CGFloat warnHeight = _warnView.frame.size.height;
    
    UILabel * warn_1 = [[UILabel alloc] init];
    warn_1.center = CGPointMake(ScreenWidth/2, warnHeight/10);
    warn_1.bounds = CGRectMake(0, 0, ScreenWidth, 15);
    warn_1.text = @"周末及节假日开放娱乐";
    warn_1.textColor = K_color_gray;
    warn_1.textAlignment = NSTextAlignmentCenter;
    warn_1.font = FontSize(textFont_S);
    [_warnView addSubview:warn_1];
    
    UILabel * warn_2 = [[UILabel alloc] init];
    warn_2.text = @"本页品种行情均为历史数据模拟盘";
    CGFloat warnWidth = [Helper calculateTheHightOfText:warn_2.text height:textFont_S+2 font:FontSize(textFont_S)];
    warn_2.center = CGPointMake(ScreenWidth/2, warnHeight*8/15);
    warn_2.bounds = CGRectMake(0, 0, warnWidth+10, 20*ScreenWidth/375);
    warn_2.textColor = holiday_yellowColor;
    warn_2.textAlignment = NSTextAlignmentCenter;
    warn_2.font = FontSize(textFont_S);
    warn_2.layer.cornerRadius = 5;
    warn_2.layer.masksToBounds = YES;
    warn_2.layer.borderColor = holiday_yellowColor.CGColor;
    warn_2.layer.borderWidth = 1;
    [_warnView addSubview:warn_2];
    
    NSString * tel = @"";
#if defined (YQB)
    tel = @"400-8915-690";
    
#else
    tel = @"400-6666-801";
    
#endif

    
    UILabel * warn_3 = [[UILabel alloc] init];
    warn_3.center = CGPointMake(ScreenWidth/2, warnHeight*116/150);
    warn_3.bounds = CGRectMake(0, 0, ScreenWidth, 40);
    warn_3.numberOfLines = 0;
    warn_3.text = [NSString stringWithFormat:@"本活动解释权归%@所有\n如有疑问请联系在线客服或拨打%@",App_appName,tel];
    warn_3.textColor = K_color_gray;
    warn_3.textAlignment = NSTextAlignmentCenter;
    warn_3.font = FontSize(9);
    [_warnView addSubview:warn_3];
}
- (void)initLoginView
{
    
    _logRegView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth)];
    [_logRegView setBackgroundColor:RGBACOLOR(0, 0, 0, 0.5)];
    [self.view addSubview:_logRegView];
    
    LoginAndRegistView * unloginStartView = [[LoginAndRegistView alloc] initWithFrame:CGRectMake(20, 75*ScreenHeigth/667, ScreenWidth - 40, ScreenHeigth - 172*ScreenHeigth/667 - 55*ScreenHeigth/667)];
    unloginStartView.backgroundColor = [UIColor clearColor];
    unloginStartView.userInteractionEnabled = YES;
    [unloginStartView.loginBtn setTitleColor:K_COLOR_CUSTEM(210, 210, 210, 1) forState:UIControlStateNormal];
    unloginStartView.block = ^(UIButton * btn){
        if (btn.tag==20001) {
            [self logBtnClick:nil];
        }else{
            
            [self regBtnClick:nil];
        }
    };
    [_logRegView addSubview:unloginStartView];
}
-(void)initWarningView
{
    CacheModel * cacheModel = [CacheEngine getCacheInfo];
    if (cacheModel.holidayCacheModel ==nil)
    {
        cacheModel.holidayCacheModel = [[HolidayCacheModel alloc] init];
    }
    NSString * lastPopTime = [NSString stringWithFormat:@"%@",cacheModel.holidayCacheModel.holidayGameShow];
    NSDate * nowDate = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString * nowTime = [formatter stringFromDate:nowDate];
    if (lastPopTime.length ==14)
    {
        NSInteger difValue = [Helper countTimeWithNewTime:nowTime lastDate:lastPopTime];
        if (difValue>24*60*60)
        {
            [self showWarningView:nowTime];
        }
    }else{
        [self showWarningView:nowTime];
    }
}
-(void)showWarningView:(NSString *)nowTime
{
    CacheModel * cacheModel = [CacheEngine getCacheInfo];
    if (cacheModel.holidayCacheModel ==nil) {
        cacheModel.holidayCacheModel = [[HolidayCacheModel alloc] init];
    }
    cacheModel.holidayCacheModel.holidayGameShow  = nowTime;
    [CacheEngine setCacheInfo:cacheModel];
    FoyerHolidayView * warningView = [[FoyerHolidayView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth) style:FoyerHolidayWarningStyle];
    [self.view addSubview:warningView];
}

-(void)showPopView
{
    FoyerHolidayView * popView = [[FoyerHolidayView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth) style:FoyerHolidayPopViewStyle];
    [self.view addSubview:popView];
}
-(void)updateUILogin:(BOOL)bhide
{
    self.logRegView.hidden = bhide;
}
- (void)loadScoreView
{
    UILabel * userScore = (UILabel*)[_userScoreView viewWithTag:userScore_Tag];
    UILabel * curScore = (UILabel *)[_userScoreView viewWithTag:curScore_Tag];
    userScore.text =  [_enableScore isEqualToString:@"0"]?@"0":[Helper addSign:_enableScore num:0];
    curScore.text = [NSString stringWithFormat:@"冻结积分（%@）", [_curCashScore isEqualToString:@"0"]?@"0":[Helper addSign:_curCashScore num:0]];
}
- (void)loadProductView:(BOOL)enableClick
{
    if(!enableClick)
    {
        [_goHistoryBtn addTarget:self action:@selector(showPopView) forControlEvents:UIControlEventTouchUpInside];
    }else
    {
        _productView.productName.text = _productModel.commodityName;
        [_goHistoryBtn addTarget:self action:@selector(goTrade:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)loadUserMessage
{
    _nickLab.text = [[CMStoreManager sharedInstance] getUserNick];
    _signLab.text = [[CMStoreManager sharedInstance]getUserSign];
}
- (void)loadUserProfit:(NSString*)profit
{
    _profitLab.text = [Helper countNumChangeformat:profit];
}
#pragma mark 判断是否显示持仓
- (void)loadPosiNum:(NSArray*)numArray
{
    _productView.positionImg.hidden = YES;
    if ([_productModel.marketCode rangeOfString:@"SRPME"].location != NSNotFound )
    {
        for (NSDictionary * dic in _positionCashNumArray)
        {
            if ([dic[@"instrumentCode"] rangeOfString:_productModel.instrumentCode].location !=NSNotFound)
            {
                float num                   = [dic[@"score"]intValue];
                if (num>0) {
                    _productView.positionImg.hidden = NO;
                }
                break;
            }
        }
    }else {
        for (NSDictionary * dic in _positionNumArray)
        {
            if ([dic[@"instrumentCode"] rangeOfString:_productModel.instrumentCode].location !=NSNotFound)
            {
                float num                   = [dic[@"score"]intValue];
                if (num>0)
                {
                    _productView.positionImg.hidden = NO;
                }
                break;
            }
        }
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

- (void)rankClick
{
    [UIEngine showShadowPrompt:@"更多功能暂未开放，敬请期待"];
}
#pragma mark 请求__是否为假期
- (void)requestHoliday
{
    [RequestDataModel requestMarkerIsHolidaySuccessBlock:^(BOOL success, BOOL isHoliDay,NSString* holiDay) {
        if (isHoliDay) {
            [self requestProductDataWithIsHoliday:isHoliDay];
            
        }else{
            [self loadProductView:NO];
            
        }
    }];
    
}
#pragma mark 请求__假期产品列表
- (void)requestProductDataWithIsHoliday:(BOOL)isHoliday
{
    [RequestDataModel requestProductDataWithType:@"3" SuccessBlock:^(BOOL success, NSMutableArray *mutableArray)
     {
         BOOL isHoliday =NO;
         if (success) {
             if (mutableArray.count>0) {
                 for (NSDictionary * dictionary in mutableArray) {
                     _productModel = [FoyerProductModel productModelWithDictionary:dictionary];
                     isHoliday = YES;
                     _dataTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(requestCacheData) userInfo:nil repeats:YES];
                     [_dataTimer fire];
                 }
             }
         }
         [self loadProductView:isHoliday];
         
     }];
}
#pragma mark 请求__用户资金
- (void)requestCainiuUserScore
{

    [DataEngine requestToGetAllMoneyWithComplete:^(BOOL success, NSMutableArray *scoreArray) {
        if (success)
        {
            _enableScore = [NSString stringWithFormat:@"%d",[scoreArray[1] intValue]];
            _curCashScore = [NSString stringWithFormat:@"%d",[scoreArray[4] intValue]];
           [self loadScoreView];
        }
    }];
}


#pragma mark - 获取用户持仓订单数量

- (void)getpositionNum{
    if ([[CMStoreManager sharedInstance] isLogin]) {
        
        [RequestDataModel requestPosiOrderNum:NO successBlock:^(BOOL success, NSArray *dataArray) {
            if (dataArray.count>0) {
                _positionNumArray = [NSMutableArray arrayWithArray:dataArray];
                [self loadPosiNum:_positionNumArray];
                
            }else{
            }
        }];
        if (![[SpotgoodsAccount sharedInstance] isNeedLogin])//南交所用户登录后需要请求现货持仓数量
        {
            [RequestDataModel requestPosiOrderNum:YES successBlock:^(BOOL success, NSArray *dataArray)
             {
                 if (dataArray.count>0) {
                     _positionCashNumArray = [NSMutableArray arrayWithArray:dataArray];
                     [self loadPosiNum:_positionCashNumArray];
                     
                 }else{
                 }
             }];
        }
        
    }
}
#pragma mark 请求单个类的行情价及涨跌幅
-(void)requestCacheData{
    
    __block int market = [_productModel.marketStatus intValue];
    __block NSString * lastPrice = @"--";
    __block NSString * percentage = @"-%";
    [RequestDataModel requestFoyerCacheData:_productModel.instrumentCode successBlock:^(BOOL success, NSDictionary *dictionary) {
        UIColor * showColor = K_color_grayBlack;
        NSString * profitMark = @"";
        if (success&&[dictionary class]!=[NSNull class]&& dictionary)
        {
            if (dictionary[@"percentage"])
            {
                percentage = [NSString stringWithFormat:@"%f",[dictionary[@"percentage"] floatValue]/100 ];
                _percentage = percentage;
            }
            if (dictionary[@"lastPrice"])
            {
                lastPrice  = [NSString stringWithFormat:@"%f",[dictionary[@"lastPrice"] floatValue]];
                _lastPrice = lastPrice;
            }
            if (market==1)
            {
                if ([percentage rangeOfString:@"-"].location!=NSNotFound)
                {
                    showColor = K_color_green;
                }else
                {
                    profitMark = @"+";
                    showColor = K_color_red;
                }
            }else
            {
                showColor = K_color_grayBlack;
            }
        }
        NSString * profit = [self countProfitWithLastPrice:_lastPrice rise:_percentage];
        _productView.price.text = [NSString stringWithFormat:@"%.0f",_lastPrice.floatValue];
        _productView.rise.text = [NSString stringWithFormat:@"%@%.0f %@%.2f%%",profitMark,profit.floatValue,profitMark,_percentage.floatValue*100];
        _productView.price.textColor = _productView.rise.textColor  = showColor;
    }];
}
#pragma mark 请求————用户盈利
- (void)requestUserProfit
{
    [RequestDataModel requestFoyerHolidayProfitSuccessBlock:^(BOOL success, NSDictionary *dictionary) {
        if (success) {
            NSString * userProfit = [NSString stringWithFormat:@"%.0f",[dictionary[@"data"] floatValue]];
            [self loadUserProfit:userProfit];
        }
    }];
}
- (NSString *)countProfitWithLastPrice:(NSString*)lastPrice rise:(NSString*)rise{
    
    CGFloat profit = (lastPrice.floatValue *rise.floatValue)/(1+rise.floatValue);
    return [NSString stringWithFormat:@"%.0f",profit];
}
- (void)goTrade:(UIControl*)control
{
    [ManagerHUD showHUD:self.view  animated:YES andAutoHide:10];
    [self getClickEnableWithProductModel:_productModel];
    
}

- (void)getClickEnableWithProductModel:(FoyerProductModel * )productModel{
    if (productModel.vendibility.intValue==0) {
            [ManagerHUD hidenHUD];
            PopUpView * popVIew = [[PopUpView alloc] initShowAlertWithShowText:@"敬请期待" setBtnTitleArray:@[@"确定"]];
            popVIew.confirmClick = ^(UIButton * button){
        };
        [self.navigationController.view addSubview:popVIew];
    }else{
        if ([productModel.commodityName rangeOfString:@"股票"].location !=NSNotFound)
        {
            PositionViewController * positionVC = [[PositionViewController alloc] init];
            [self.navigationController pushViewController:positionVC animated:YES];
            [ManagerHUD hidenHUD];
        }else
        {
            [self getIPWithIndexPath];
        }
    }
}
- (void)getIPWithIndexPath;
{
    
    [DataEngine requestToGetIPAndPortWithBlock:^(BOOL success, NSString * IP, NSString *Port)
     {
         [ManagerHUD hidenHUD];
         _IP = IP;
         _port = Port;
         BOOL isPosition = NO;
         if ([_productModel.marketCode rangeOfString:@"SRPME"].location != NSNotFound )
         {
             for (NSDictionary * dic in _positionCashNumArray)
             {
                 if ([dic[@"instrumentCode"] rangeOfString:_productModel.instrumentCode].location !=NSNotFound)
                 {
                     float num               = [dic[@"cash"]intValue] +[dic[@"score"]intValue];
                     if (num>0)
                     {
                         isPosition          = YES;
                     }
                     break;
                 }
             }
         }else
         {
             for (NSDictionary * dic in _positionNumArray)
             {
                 if ([dic[@"instrumentCode"] rangeOfString:_productModel.instrumentCode].location !=NSNotFound)
                 {
                     float num               = [dic[@"cash"]intValue] +[dic[@"score"]intValue];
                     if (num>0)
                     {
                         isPosition          = YES;
                     }
                     break;
                 }
             }
         }
         IndexViewController * indexVC   = [[IndexViewController alloc] init];
         indexVC.ip                      = IP;
         indexVC.port                    = Port;
         indexVC.name                    = _productModel.commodityName;
         indexVC.code                    = _productModel.instrumentID;
         indexVC.isPosition              = isPosition;
         indexVC.productModel            = _productModel;
         [self.navigationController pushViewController:indexVC animated:YES];
     }];
    
}

- (void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
