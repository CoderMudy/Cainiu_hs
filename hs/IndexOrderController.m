//
//  IndexOrderController.m
//  hs
//
//  Created by RGZ on 15/7/28.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "IndexOrderController.h"
#import "DetailViewController.h"
#import "MoneyDetaillViewController.h"
#import "NetRequest.h"
#import "TradeConfigerModel.h"
#import "MarketModel.h"
#import "IndexViewController.h"
#import "AccountH5Page.h"
#import "IndexOrderChooseButton.h"
#import "IndexOrderChooseBillModel.h"
#import "IndexOrderChooseView.h"
#import "IndexOrderChooseModel.h"

#define Tag_stop            699
#define Tag_get             700
#define Tag_oneLine         701
#define Tag_twoLine         702
#define Tag_threeLine       703
#define Tag_fourLine        704
#define Tag_fiveLine        705
//持仓时间：截至本交易时段02:27:59
#define Tag_timeLine        706
#define Tag_bottomButton    707
#define Tag_agreeButton     708
#define Tag_timeLabel       709

#define Tag_rateview        710
#define Tag_chooseStop      711//条件单触发止损Label
#define Tag_chooseGet       712//条件单触发止盈Label

#define Tag_orderChooseNumView  713//条件单选择手数
#define Tag_orderChooseStopView 714//条件单选择止损
#define Tag_orderChooseGetView  715//条件单选择止盈

@interface IndexOrderController ()
{
    NSMutableArray  *_moneyConfigerArray;
    NSMutableArray  *_integralConfigerArray;
    
    TradeConfigerModel  *_moneyTrade;
    TradeConfigerModel  *_integralTrade;
    
    int             selectStop;
    int             selectGet;
    int             chooseStopNum;//沪银、期指选择止损默认0
    int             isIntegral;//是否积分  0:现金  1：积分
    NSTimer         *_timer;//轮询下单是否成功
    NSString        *_systemTime;//用户下单时间（系统时间）
    int             time;//倒计时5秒
    UILabel         *_preferentialLabel;//优惠
    int             floatNum;//小数位
    UILabel         *_priceLabel;//当前买价
    BOOL            isFirstStatus;//第一次进入，需引导
    NSString        *_tradeDicName ;//example:auTradeDic(存储到缓存文件的名字)
    float           exchangeRate;//汇率
    
    //是否开启快速下单
    BOOL            isOpenQuick;
    BOOL            orderQuick;
    NSDictionary    *orderPramDic;
    
    UILabel *_timeLabel;
    UILabel *_timeProLabel;//条件委托只对本时段有效...
    UILabel *_timeSignLabel;//!
    
    NSMutableArray *couPonIDArray;
    BOOL            isCouPonSelect;//是否有勾选优惠券
    NSString           *isAutoCouPon;//是否自动抵扣
    NSInteger         useCouPonNum;

    long long                       oldTimeInterval;//重复下单处理
    IndexOrderChooseBillModel       *_chooseBillModel;//条件单结果Model
    IndexOrderChooseModel           *_chooseDataModel;//条件单数据Model
}
@end

@implementation IndexOrderController
@synthesize selectNum;
@synthesize sunCoupon;//优惠券张数
@synthesize couPonArray;//优惠券数据

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadNav];
    
    [self loadData];
    
    [self loadUI];
    
    [self setUpForDismissKeyboard];
}

#pragma mark - 下单界面新手引导页
- (void)orderGuideView
{
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    if ([cacheModel.isOrderOrLogin isEqualToString:@"YES"])
    {    
        _guideView = [[UIView alloc]init];
        _guideView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
        _guideView.backgroundColor = [UIColor blackColor];
        _guideView.alpha = 0.7;
        [self.view addSubview:_guideView];
        
        UITapGestureRecognizer *portraitTapTWo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_guideView addGestureRecognizer:portraitTapTWo];

        _guide_OneImg = [[UIImageView alloc]init];
        _guide_OneImg.image = [UIImage imageNamed:@"order_guide_5"];
        
        if ([UIScreen mainScreen].bounds.size.height <= 480) {
            _guide_OneImg.frame = CGRectMake(ScreenWidth/2 - 187*0.9*ScreenWidth/320/2, 44, 194*0.9*ScreenWidth/320 , 100*0.9*ScreenWidth/320);
        }else
        {
            _guide_OneImg.frame = CGRectMake(ScreenWidth/2 - 187*0.9*ScreenWidth/320/2, 64, 194*0.9*ScreenWidth/320 , 100*0.9*ScreenWidth/320);
        }
        
        [self.view addSubview:_guide_OneImg];
        UITapGestureRecognizer *portr_one = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_guide_OneImg addGestureRecognizer:portr_one];


        _guide_TwoImg = [[UIImageView alloc]init];
        _guide_TwoImg.image = [UIImage imageNamed:@"order_guide_6"];
        if ([UIScreen mainScreen].bounds.size.height <= 480)
        {
            _guide_TwoImg.frame = CGRectMake(10, CGRectGetMaxY(_guide_OneImg.frame) + 10, ScreenWidth - 20 , 267*0.8*ScreenWidth/320);
        }else
        {
            _guide_TwoImg.frame = CGRectMake(10, CGRectGetMaxY(_guide_OneImg.frame) + 20, ScreenWidth - 20 , 267*0.9*ScreenWidth/320);
        }
        
        [self.view addSubview:_guide_TwoImg];
        
        UITapGestureRecognizer *portr_two = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_guide_TwoImg addGestureRecognizer:portr_two];

        _guide_ThreeImg = [[UIImageView alloc]init];
        _guide_ThreeImg.userInteractionEnabled = YES;
        _guide_ThreeImg.image = [UIImage imageNamed:@"order_guide_1"];
        _guide_ThreeImg.frame = CGRectMake(ScreenWidth/2 - 55*0.9*ScreenWidth/320/2, CGRectGetMaxY(_guide_TwoImg.frame) + 25*ScreenWidth/320, 55*0.9*ScreenWidth/320 , 74*0.9*ScreenWidth/320);
        [self.view addSubview:_guide_ThreeImg];
    
        UITapGestureRecognizer *portr_three = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_guide_ThreeImg addGestureRecognizer:portr_three];

    }
}

- (void)editPortrait
{
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    cacheModel.isOrderOrLogin = @"NO";
    [CacheEngine setCacheInfo:cacheModel];

    [_guide_OneImg removeFromSuperview];
    [_guide_TwoImg removeFromSuperview];
    [_guide_ThreeImg removeFromSuperview];
    [_guideView removeFromSuperview];
}

#pragma mark - 优惠券接口调用
- (void)requestCouPonData
{
    couPonArray = [[NSMutableArray alloc]init];
    
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token,@"futuresId":@([_productModel.productID intValue])};
    [NetRequest postRequestWithNSDictionary:dic url:K_User_CouponList successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            if ([dictionary[@"data"] count] != 0) {
                _isCouPon = @"YES";
                for (NSDictionary *dic in dictionary[@"data"]) {
                    [couPonArray addObject:dic];
                }
                
                [_couPonView removeFromSuperview];
                [self loadOtherMoneyLabel];
                if (isFirstStatus) {
                    [self segClickReloadData];
                }

            }else
            {
              _isCouPon = @"NO";
                if (isFirstStatus) {
                    [self segClickReloadData];
                }
            }
        }else
        {
            if (isFirstStatus) {
                [self segClickReloadData];
            }
        }
        
        if (!isFirstStatus) {
            [self reloadAllData];
        }

        [self orderGuideView];
        [self quickOrderText];

    } failureBlock:^(NSError *error) {
        [self orderGuideView];
        [self quickOrderText];

    }];

}

#pragma mark - 快速下单页面说明文字
- (void)quickOrderText
{

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
    
    addTextFieldNotification(textFieldValueChange);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPositionBosomPage object:self];
    
    removeTextFileNotification;
}

#pragma mark Nav

-(void)loadNav{
    UIImage *leftButtonImage = [UIImage imageNamed:@"return_1.png"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [leftButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchDown];
    [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    leftButton.titleLabel.shadowColor = RGBACOLOR(117,38,0,1.0f);
    leftButton.titleLabel.shadowOffset= CGSizeMake(0, -1);
    leftButton.titleLabel.textColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44/2-leftButtonImage.size.height/2, leftButtonImage.size.width, leftButtonImage.size.height)];
    imageView.image = [UIImage imageNamed:@"return_1"];
    imageView.center = leftButton.center;
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backClick)];
    [imageView addGestureRecognizer:tap];
    
    [self.view addSubview:leftButton];
    
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    self.titleLabel.font = [UIFont systemFontOfSize:11];
    self.titleLabel.text = [NSString stringWithFormat:@"%@\n%@",_indexBuyModel.name,_indexBuyModel.code];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.center = CGPointMake(self.view.center.x, 20+22);
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.attributedText = [Helper multiplicityText:self.titleLabel.text from:0 to:(int)[_indexBuyModel.name length] font:15];
    [self.view addSubview:self.titleLabel];
}
//返回
-(void)backClick{
    UIViewController *viewController = nil;
    for (UIViewController *indexviewController in self.navigationController.viewControllers) {
        if ([indexviewController isKindOfClass:[IndexViewController class]]) {
            viewController = indexviewController;
        }
    }
    [self.navigationController popToViewController:viewController animated:YES];
}

#pragma mark Data

-(void)loadData{
    //条件单数据Model
    _chooseDataModel = [IndexOrderChooseModel getOrderChooseDataModelWithInstrumentCode:_productModel.instrumentCode WithIndexBuyModel:_indexBuyModel];
    //条件单结果
    _chooseBillModel = [[IndexOrderChooseBillModel alloc]init];
    _chooseBillModel.chooseStopMoney = _chooseDataModel.minStopMoney;
    _chooseBillModel.chooseGetMoney = _chooseDataModel.minStopMoney;
    _chooseBillModel.chooseNum = @"1";
    
    _isCouPon = @"NO";
    isCouPonSelect = YES;
    oldTimeInterval = 0;
    //积分Or现金
    [self judgeIntegralOrAmount];
    //止损止盈
    self.stopAndGetFrontHeight = 145.0;
    //保证金手续费
    self.otherMoneyFrontHeight = (140.0/568*ScreenHeigth + (40.0/568*ScreenHeigth) * 3 +17.0/568*ScreenHeigth)-15;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSocketInfo:) name:kPositionBosomPage object:nil];
    
    _numArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:4],[NSNumber numberWithInt:8], nil];
    
    _moneyConfigerArray = [NSMutableArray arrayWithCapacity:0];
    
    _integralConfigerArray = [NSMutableArray arrayWithCapacity:0];
    
    selectStop = 0;
    selectGet = 0;
    
#pragma mark - 缓存数据初始化
    //缓存初始化
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    
    if (cacheModel.tradeDic == nil || [cacheModel.tradeDic isKindOfClass:[NSNull class]]) {
        cacheModel.tradeDic = [NSMutableDictionary dictionaryWithCapacity:0];
        [CacheEngine setCacheInfo:cacheModel];
    }
    
    if (cacheModel.tradeDic[self.productModel.tradeDicName] == nil || [cacheModel.tradeDic isKindOfClass:[NSNull class]]) {
        cacheModel.tradeDic[self.productModel.tradeDicName] = [NSMutableDictionary dictionaryWithCapacity:0];
        [CacheEngine setCacheInfo:cacheModel];
    }
    
    _tradeDicName = self.productModel.tradeDicName;
    if (self.isQuickOrder) {
        self.productModel.tradeSubDicName = [self.productModel.tradeDicName stringByAppendingString:@"QuickOrder"];
    }
    else{
        self.productModel.tradeSubDicName = [self.productModel.tradeDicName stringByAppendingString:@"NoQuickOrder"];
    }
    
    if (cacheModel.tradeDic[self.productModel.tradeSubDicName] != nil && ![cacheModel.tradeDic[self.productModel.tradeSubDicName] isKindOfClass:[NSNull class]]) {
        _moneyConfigerArray = [NSMutableArray arrayWithArray:[cacheModel.tradeDic[self.productModel.tradeSubDicName] objectForKey:@"money"]];
        _integralConfigerArray = [NSMutableArray arrayWithArray:[cacheModel.tradeDic[self.productModel.tradeSubDicName] objectForKey:@"integral"]];
        selectGet = [cacheModel.tradeDic[self.productModel.tradeSubDicName][@"selectGet"] intValue];
        int count = 0;
        
        if (_moneyConfigerArray != nil && ![_moneyConfigerArray isKindOfClass:[NSNull class]]) {
            if (_moneyConfigerArray.count > 0) {
                _moneyTrade = _moneyConfigerArray[0];
                count++;
            }
        }
        
        if (_integralConfigerArray != nil && ![_integralConfigerArray isKindOfClass:[NSNull class]]) {
            if (_integralConfigerArray.count > 0) {
                _integralTrade = _integralConfigerArray[0];
                count++;
            }
        }
        
        if (count != 0) {
            [self reloadAllData];
        }
    }
    else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        cacheModel.tradeDic[self.productModel.tradeSubDicName] = dic;
        [CacheEngine setCacheInfo:cacheModel];
    }
    
    
    chooseStopNum = 0;
    selectNum = 0;
    
    if (!isOpenQuick) {
        [self getMarketEndTime];
        
    }
    
    if (self.buyState !=2 && self.isOpen) {
        
    }
    else{
        [[UIEngine sharedInstance] hideProgress];
        [self getTradeConfigerData];//获取配资额度
    }
}

#pragma mark 获取行情数据

-(void)getSocketInfo:(NSNotification *)notify{
    NSDictionary    * infoDic = notify.object;
    
    if ([infoDic[@"code"] rangeOfString:self.indexBuyModel.code].location != NSNotFound) {
        if (self.buyState == 0) {
            //看多取的价
            _indexBuyModel.currentPrice = infoDic[@"askPrice"];
        }
        else if (self.buyState == 1){
            //看空取的价
            _indexBuyModel.currentPrice = infoDic[@"bidPrice"];
        }
        
        //au
        if ([self.productModel.decimalPlaces floatValue] == 2) {
            _indexBuyModel.currentPrice = [NSString stringWithFormat:@"%.2f",[_indexBuyModel.currentPrice doubleValue]];
        }
        //if
        else if ([self.productModel.decimalPlaces floatValue] == 1){
            _indexBuyModel.currentPrice = [NSString stringWithFormat:@"%.1f",[_indexBuyModel.currentPrice doubleValue]];
        }
        //ag
        else if ([self.productModel.decimalPlaces floatValue] == 0){
            _indexBuyModel.currentPrice = [NSString stringWithFormat:@"%.0f",[_indexBuyModel.currentPrice doubleValue]];
        }
        
        _priceLabel.text = _indexBuyModel.currentPrice;
        
        //更新当前买价
        [self updateCurrentPriceLabel];
        
        //刷新止损止盈价
        [self reloadOfStopPriceOrGetPrice];
    }
}
#pragma mark 获取市场交易时段

-(void)getMarketEndTime{
    
    floatNum = [self.productModel.decimalPlaces intValue];
    
    NSDictionary *dic=@{
                        @"marketId":[NSNumber numberWithInt:[self.productModel.marketId intValue]],
                        };
    NSString     *url=[NSString stringWithFormat:@"http://%@/market/market/marketStatus",HTTP_IP];
    
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] integerValue] == 200) {
            
            NSMutableArray  *marketArray = [NSMutableArray arrayWithCapacity:0];
            
            for (int i = 0; i < [dictionary[@"data"] count]; i++) {
                MarketModel *marketModel = [[MarketModel alloc]init];
                marketModel.desc = dictionary[@"data"][i][@"desc"];
                marketModel.endTime = [dictionary[@"data"][i][@"end_time"] longLongValue];
                marketModel.startTime = [dictionary[@"data"][i][@"start_time"] longLongValue];
                marketModel.status = [dictionary[@"data"][i][@"status"] intValue];
                marketModel.type = [dictionary[@"data"][i][@"type"] intValue];
                [marketArray addObject:marketModel];
            }
            
            orderQuick = NO;
            
            _timeLabel.text = [self autoCalculateEndTime:marketArray];
        }
    } failureBlock:^(NSError *error) {
    }];
}

- (NSString *)autoCalculateEndTime:(NSMutableArray *)aMarketArray{
    
    NSString    *showStr = @"本时段持仓时间至02:25:00";
    
    NSMutableArray *infoArray = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i<aMarketArray.count; i++) {
        MarketModel *marketModel = aMarketArray[i];
        
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:marketModel.startTime/1000];
        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:marketModel.endTime/1000];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"HH:mm"];
        
        
        if (marketModel.status == 2 || marketModel.status == 3) {
            NSString *startDateStr = [dateFormatter stringFromDate:startDate];
            NSString *endDateStr = [dateFormatter stringFromDate:endDate];
            if (endDateStr.length > 1 && ([[endDateStr substringToIndex:1] intValue] == 0)) {
                endDateStr = [NSString stringWithFormat:@"次日%@",endDateStr];
            }
            [infoArray addObject:[NSString stringWithFormat:@"%@-%@",startDateStr,endDateStr]];
        }
    }
    
    NSMutableArray *marketArray = [NSMutableArray arrayWithArray:aMarketArray];
    
    //早上不清仓
    /*
     市场列表id=SHFE,name=上海期货交易所
     市场列表id=DCE,name=大连商品交易所
     市场列表id=CZCE,name=郑州商品交易所
     */
    if (![[ControlCenter sharedInstance] isClear]) {
        if ([self.productModel.marketCode isEqualToString:@"SHFE"] ||
            [self.productModel.marketCode isEqualToString:@"DCE"] ||
            [self.productModel.marketCode isEqualToString:@"CZCE"]) {
            
            MarketModel *newMarketModel = [[MarketModel alloc]init];
            for (int i = 0; i < aMarketArray.count; i++) {
                MarketModel *marketModel = aMarketArray[i];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"HH:mm:ss"];
                NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:marketModel.startTime/1000];
                NSArray *startStrArray = [[dateFormatter stringFromDate:startDate] componentsSeparatedByString:@":"];
                NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:marketModel.endTime/1000];
                NSArray *endStrArray = [[dateFormatter stringFromDate:endDate] componentsSeparatedByString:@":"];
                if (startStrArray.count >= 2 && endStrArray.count >= 2) {
                    if ([startStrArray[0] intValue] == 10 && [endStrArray[0] intValue] == 10) {
                        for (int i = 0; i < marketArray.count; i++) {
                            MarketModel *tmpMarketModel = marketArray[i];
                            if (tmpMarketModel.startTime == marketModel.startTime && tmpMarketModel.endTime == marketModel.endTime) {
                                [marketArray removeObjectAtIndex:i];
                            }
                        }
                    }
                    else if ([startStrArray[0] intValue] != 10 && [endStrArray[0] intValue] == 10){
                        newMarketModel.startTime = marketModel.startTime;
                        newMarketModel.status = marketModel.status;
                        newMarketModel.type = marketModel.type;
                        newMarketModel.desc = marketModel.desc;
                        for (int i = 0; i < marketArray.count; i++) {
                            MarketModel *tmpMarketModel = marketArray[i];
                            if (tmpMarketModel.startTime == marketModel.startTime && tmpMarketModel.endTime == marketModel.endTime) {
                                [marketArray removeObjectAtIndex:i];
                            }
                        }
                    }
                    else if ([startStrArray[0] intValue] == 10 && [endStrArray[0] intValue] != 10){
                        newMarketModel.endTime = marketModel.endTime;
                        newMarketModel.type = marketModel.type;
                        newMarketModel.desc = marketModel.desc;
                        newMarketModel.status = marketModel.status;
                        for (int i = 0; i < marketArray.count; i++) {
                            MarketModel *tmpMarketModel = marketArray[i];
                            if (tmpMarketModel.startTime == marketModel.startTime && tmpMarketModel.endTime == marketModel.endTime) {
                                [marketArray removeObjectAtIndex:i];
                            }
                        }
                    }
                }
            }
            [marketArray addObject:newMarketModel];
        }
    }
    
    for (int i = 0; i<marketArray.count; i++) {
        MarketModel *marketModel = marketArray[i];

        if ([SystemSingleton sharedInstance].timeInterval >= marketModel.startTime && [SystemSingleton sharedInstance].timeInterval <= marketModel.endTime) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:marketModel.endTime/1000];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            NSString *dateStr = [dateFormatter stringFromDate:date];
            
            if (marketModel.status != 2 && marketModel.status != 3) {
                if (self.isOpen) {
                    [[UIEngine sharedInstance] hideProgress];
                }
            }
            else{
                //闪电下单
                if (isOpenQuick) {
                    orderQuick = YES;
                }
                
                showStr = [NSString stringWithFormat:@"本时段持仓时间至%@",dateStr];
            }
        }
    }
    
    BOOL isHaveAlert = NO;
    
    for (int i = 0; i < aMarketArray.count; i++) {
        MarketModel *marketModel = aMarketArray[i];
        
        if ([SystemSingleton sharedInstance].timeInterval >= marketModel.startTime && [SystemSingleton sharedInstance].timeInterval <= marketModel.endTime) {
            if (marketModel.status != 2 && marketModel.status != 3) {
                if (infoArray.count == 0) {
                    if (ScreenWidth <= 320) {
                        [infoArray addObject:@"周六、周日和国家规定"];
                        [infoArray addObject:@"节假日休市"];
                    }
                    else{
                        [infoArray addObject:@"周六、周日和国家规定节假日休市"];
                    }
                }
                [[UIEngine sharedInstance] showAlertSpecialWithTitle:@"当前为非交易时间段" TimeArray:infoArray];
                [UIEngine sharedInstance].alertClick = ^(int aIndex){
                };
                isHaveAlert = YES;
                [[UIEngine sharedInstance] hideProgress];
            }
        }
    }
    
    //闪电下单
    if (isOpenQuick && orderQuick && !isHaveAlert) {
        [self orderGo:orderPramDic];
    }
    
    return showStr;
    
}

//获取配资额度

#pragma mark 获取配资额度

-(void)getTradeConfigerData{
    
    //是否第一次进入，引导用户
    isFirstStatus = NO;
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    if (cacheModel.tradeDic[self.productModel.tradeSubDicName]!=nil) {
        if ([cacheModel.tradeDic[self.productModel.tradeSubDicName] allKeys].count < 4) {
            isFirstStatus = YES;
        }
        if (self.isQuickOrder) {
            selectStop = [cacheModel.tradeDic[self.productModel.tradeSubDicName][@"chooseStopQuick"] intValue];
            selectGet = [cacheModel.tradeDic[self.productModel.tradeSubDicName][@"chooseGetQuick"] intValue];
        }
        else{
            selectStop = [cacheModel.tradeDic[self.productModel.tradeSubDicName][@"chooseStop"] intValue];
            selectGet = [cacheModel.tradeDic[self.productModel.tradeSubDicName][@"chooseGet"] intValue];
        }
        [CacheEngine setCacheInfo:cacheModel];
    }
    
    [UIEngine sharedInstance].progressStyle = 2;
    [[UIEngine sharedInstance] showProgress];
    [DataEngine requestToGetTraderConfiger:self.productModel.instrumentCode completeBlock:^(BOOL SUCCESS, NSMutableArray * moneyArray,NSMutableArray *integralArray) {
        [[UIEngine sharedInstance] hideProgress];
        if (SUCCESS) {
            
            if (moneyArray.count>0 && integralArray.count > 0){
                _moneyConfigerArray = [NSMutableArray arrayWithArray:moneyArray];
                _integralConfigerArray = [NSMutableArray arrayWithArray:integralArray];
                
                [self tradeConfiger];
            }
            else{
                [UIEngine showShadowPrompt:@"配资额度配置失败，请重试"];
                if ([self isKindOfClass:[IndexOrderController class]]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            
        }
        else{
            [UIEngine showShadowPrompt:@"配资额度配置失败，请重试"];
            if ([self isKindOfClass:[IndexOrderController class]]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}

-(void)tradeConfiger{
    //默认选择止损
    [self defaultChooseStop];
    //默认选择止盈
    [self defaultChooseGet:NO];
    [self configerButton];
    //刷新UI数据
    if (isFirstStatus) {
        [self defaultData];
        [self requestCouPonData];
    }
    else{
        //缓存数组
        [self requestCouPonData];
        [self cacheTradeInfo];
        [self reloadAllData];
    }
}

#pragma mark 第一次进入引导

-(void)defaultData{
    _oneLabel.text = @"";
    _oneLabel.attributedText = nil;
    _oneLabel.text = @"请选择止损额度";
    
    _twoLabel.text = @"";
    _twoLabel.attributedText = nil;
    _twoLabel.text = @"请选择止盈额度";
    _twoLabel.superview.backgroundColor = Color_gray;
    
    
    UILabel *threeLabel = (UILabel *)[_couPonView viewWithTag:Tag_threeLine];
    threeLabel.text = [NSString stringWithFormat:@"%@--",self.productModel.currencySign];
}

#pragma mark 缓存数组
-(void)cacheTradeInfo{
    
    NSArray *muliArray = [_moneyTrade.multiple componentsSeparatedByString:@","];
    
    [_numArray removeAllObjects];
    
    for (int i = 0; i<muliArray.count; i++) {
        [_numArray addObject:[NSNumber numberWithInt:[muliArray[i] intValue]]];
    }
    
    //缓存
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    if (cacheModel.tradeDic[self.productModel.tradeSubDicName] == nil) {
        cacheModel.tradeDic[self.productModel.tradeSubDicName] = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    [cacheModel.tradeDic[self.productModel.tradeSubDicName] setObject:_moneyConfigerArray forKey:@"money"];
    [cacheModel.tradeDic[self.productModel.tradeSubDicName] setObject:_integralConfigerArray forKey:@"integral"];
    [CacheEngine setCacheInfo:cacheModel];
}


#pragma mark 默认选择止损
-(void)defaultChooseStop{
    
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    
    BOOL    switchOpen = NO;
    
    if (self.isQuickOrder) {
        if (cacheModel.tradeDic[self.productModel.tradeSubDicName][@"chooseStopQuick"] == nil) {
            switchOpen = NO;
        }
        else{
            switchOpen = YES;
        }
    }
    else{
        if (cacheModel.tradeDic[self.productModel.tradeSubDicName][@"chooseStop"] == nil) {
            switchOpen = NO;
        }
        else{
            switchOpen = YES;
        }
    }
    
    if (!switchOpen) {
        for (int i = 0; i<_moneyConfigerArray.count; i++) {
            TradeConfigerModel *model = _moneyConfigerArray[i];
            
            if ([model.isDefault floatValue] == 1) {
                _moneyTrade = model;
                selectStop = i;
            }
        }
        
        for (int i = 0; i<_integralConfigerArray.count; i++) {
            TradeConfigerModel *model = _integralConfigerArray[i];
            
            if ([model.isDefault floatValue] == 1) {
                _integralTrade = model;
                selectStop = i;
            }
        }
    }
    else{
        if (isIntegral) {
            if (selectStop >= _integralConfigerArray.count) {
                selectStop = (int)_integralConfigerArray.count - 1;
            }
        }
        else{
            if (selectStop >= _moneyConfigerArray.count) {
                selectStop = (int)_moneyConfigerArray.count - 1;
            }
        }
        
        _moneyTrade = _moneyConfigerArray[selectStop];
        _integralTrade = _integralConfigerArray[selectStop];
    }
}

#pragma mark 默认选择止盈

-(void)defaultChooseGet:(BOOL)aDefaultGet{
    
    BOOL    canUseDefault = aDefaultGet ;
    
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    if (canUseDefault==NO) {
        if (self.isQuickOrder) {
            if (cacheModel.tradeDic[self.productModel.tradeSubDicName][@"chooseGetQuick"] == nil || [cacheModel.tradeDic[self.productModel.tradeSubDicName][@"chooseGetQuick"] isKindOfClass:[NSNull class]]) {
                canUseDefault = YES;
            }
            else{
                canUseDefault = NO;
            }
        }
        else{
            if (cacheModel.tradeDic[self.productModel.tradeSubDicName][@"chooseGet"] == nil || [cacheModel.tradeDic[self.productModel.tradeSubDicName][@"chooseGet"] isKindOfClass:[NSNull class]]) {
                canUseDefault = YES;
            }
            else{
                canUseDefault = NO;
            }
        }
    }
    
    if (canUseDefault == YES) {
        if (isIntegral) {
            TradeConfigerModel  *model = _integralConfigerArray[selectStop];
            NSArray *temArray = [model.maxProfit componentsSeparatedByString:@","];
            
            for (int i = 0; i<temArray.count; i++) {
                if ([model.defaultProfit isEqualToString:temArray[i]]) {
                    selectGet = i;
                }
            }
        }
        else{
            TradeConfigerModel  *model = _moneyConfigerArray[selectStop];
            NSArray *temArray = [model.maxProfit componentsSeparatedByString:@","];
            
            for (int i = 0; i<temArray.count; i++) {
                if ([model.defaultProfit isEqualToString:temArray[i]]) {
                    selectGet = i;
                }
            }
        }
    }
    else{
        if (isIntegral) {
            TradeConfigerModel  *model = _integralConfigerArray[selectStop];
            NSArray *temArray = [model.maxProfit componentsSeparatedByString:@","];
            if (temArray != nil && temArray.count - 1 <= selectGet ) {
                if (![temArray.lastObject isEqualToString:@""]) {
                    selectGet = (int)temArray.count - 1;
                }
                else{
                    selectGet = (int)temArray.count - 2;
                }
            }
        }
        else{
            TradeConfigerModel  *model = _moneyConfigerArray[selectStop];
            NSArray *temArray = [model.maxProfit componentsSeparatedByString:@","];
            if (temArray != nil && temArray.count - 1 <= selectGet) {
                if (![temArray.lastObject isEqualToString:@""]) {
                    selectGet = (int)temArray.count - 1;
                }
                else{
                    selectGet = (int)temArray.count - 2;
                }
            }
        }
    }
}

#pragma mark - 更新优惠券数据
- (void)reloadCouPonData
{
    //判断优惠券的张数和面额值是否大于手续费活手数
    sunCoupon = 0.0;
    double couPonMore = 0.0;//优惠券面额
    double couPonLittle = 0.0;//优惠券张数
    
    couPonIDArray = [[NSMutableArray alloc]init];
    if (couPonArray.count > 0 && couPonArray != nil) {
        if (couPonArray.count >[_numArray[selectNum] intValue]) {
            useCouPonNum = [_numArray[selectNum] intValue];
        }else
        {
            useCouPonNum = couPonArray.count;
        }
        for (NSInteger i = 0; i<useCouPonNum; i++)
        {
            NSDictionary *couDic = couPonArray[i];
            //如果优惠券面额大于手续费，那么优惠券得面额就等于手续费
            if ([couDic[@"amount"] doubleValue] > [_tradeModel.counterFee doubleValue] * [self.tradeModel.rate doubleValue]) {
                couPonMore = couPonMore + [_tradeModel.counterFee doubleValue] * [self.tradeModel.rate doubleValue];
            }else//如果优惠券面额小于手续费，那么就等于原来的优惠券面额
            {
                couPonLittle = couPonLittle + [couDic[@"amount"] doubleValue];
            }
            
            [couPonIDArray addObject:couDic[@"id"]];
        }
        //这里是总的加起来优惠了多少钱
        sunCoupon = couPonLittle + couPonMore;
        
        if (self.isQuickOrder) {
            _couPonLab.text = @"自动抵扣";
        }else
        {
            //选中状态下点击
            if (isCouPonSelect) {
                _couPonLab.text = [NSString stringWithFormat:@"使用%ld张￥-%.1f",(long)useCouPonNum,sunCoupon];
            }
            else{
                _couPonLab.text = [NSString stringWithFormat:@"未使用"];
            }
        }
        
        
        
        CGSize couPonSize = [Helper sizeWithText:_couPonLab.text font:[UIFont systemFontOfSize:15.0] maxSize:CGSizeMake(ScreenWidth - 60, 20)];
        _couPonBtn.frame = CGRectMake(ScreenWidth - 60 - couPonSize.width, CGRectGetMinY(_couPonLab.frame), 40, _couPonLab.frame.size.height);
    }
}
#pragma mark -
#pragma mark 刷新数据

-(void)reloadAllData{
    
    //触发止损
    if (self.mainState == 0) {
        chooseStopNum = 0;
    }
    //保证金
    UILabel *threeLabel = (UILabel *)[_couPonView viewWithTag:Tag_threeLine];
    //交易综合费
    UILabel *fourLabel = (UILabel *)[_couPonView viewWithTag:Tag_fourLine];
    if (isIntegral) {
        if (chooseStopNum == 0) {
            _tradeModel = _integralTrade;
        }
        if (selectStop >= _integralConfigerArray.count) {
            selectStop = (int)_integralConfigerArray.count - 1;
        }
    }
    else{
        if (chooseStopNum == 0) {
            _tradeModel = _moneyTrade;
        }
        if (selectStop >= _moneyConfigerArray.count) {
            selectStop = (int)_moneyConfigerArray.count - 1;
        }
    }
    //====
    /**
     *  加载汇率
     */
    [self loadRate];
    [self reloadCouPonData];
    [self configerButton];
    
    NSString    *twoLabelPrice;
    NSArray  * getArray = [_tradeModel.maxProfit componentsSeparatedByString:@","];
    if (getArray != nil && selectGet <= getArray.count-1) {
        twoLabelPrice = getArray[selectGet];
    }
    else{
        twoLabelPrice = @"";
    }
        //手数
//    NSArray *numArray = @[@1,@2,@4,@8];
    if (isIntegral) {
        [self integralDataConfigerWithThreeLabel:threeLabel FourLabel:fourLabel TwoLabelPrice:twoLabelPrice];
    }
    else{
        [self amountDataConfigerWithThreeLabel:threeLabel FourLabel:fourLabel TwoLabelPrice:twoLabelPrice];
    }
    
    //计算止损价、止盈价
    [self reloadOfStopPriceOrGetPrice];
    
    if (self.isQuickOrder) {
        //优惠配置
        [self quickOrderConfigerOfFourLabel];
    }
}
#pragma mark 积分配置
-(void)integralDataConfigerWithThreeLabel:(UILabel *)threeLabel FourLabel:(UILabel *)fourLabel TwoLabelPrice:(NSString *)twoLabelPrice{
    if (_integralConfigerArray != nil && selectStop >= _integralConfigerArray.count) {
        selectStop = (int)_integralConfigerArray.count - 1;
    }
    
    if (threeLabel == nil || fourLabel == nil) {
        return;
    }
    
    _oneLabel.text = [NSString stringWithFormat:@"%@%@积分/手",_productModel.currencySign,[DataEngine addSign:[NSString stringWithFormat:@"%.0f",[_tradeModel.maxLoss floatValue]] pointNum:0]];
    _oneLabel.attributedText = [DataUsedEngine mutableFontArray:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%@%@",_productModel.currencySign,[DataEngine addSign:[NSString stringWithFormat:@"%.0f",[_tradeModel.maxLoss floatValue]] pointNum:0]],@"积分",@"/手", nil] fontArray:[NSMutableArray arrayWithObjects:@"15",@"11",@"15", nil]];
    _twoLabel.text = [NSString stringWithFormat:@"%@%@积分/手",_productModel.currencySign,[DataEngine addSign:[NSString stringWithFormat:@"%.0f",[twoLabelPrice floatValue]] pointNum:0]];
    _twoLabel.attributedText = [DataUsedEngine mutableFontArray:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%@%@",_productModel.currencySign,[DataEngine addSign:[NSString stringWithFormat:@"%.0f",[twoLabelPrice floatValue]] pointNum:0]],@"积分",@"/手", nil] fontArray:[NSMutableArray arrayWithObjects:@"15",@"11",@"15", nil]];
    
    
    fourLabel.text = @"";
    fourLabel.attributedText = nil;
    threeLabel.text = @"";
    threeLabel.attributedText = nil;
    
    //优惠的默认配置(隐藏优惠选项，只显示总手续费)
    _preferentialLabel.hidden = YES;
    NSString    *behindStr = [DataEngine addSign:[NSString stringWithFormat:@"%.0f",[_tradeModel.counterFee doubleValue] * [_numArray[selectNum] intValue]] pointNum:0];
    if (_tradeModel.rate != nil && [_tradeModel.rate floatValue] != 1) {
        NSString    *money = [DataEngine addSign:[NSString stringWithFormat:@"%.0f",([_tradeModel.rate floatValue] * [_tradeModel.counterFee doubleValue] * ([_numArray[selectNum] intValue]))] pointNum:0];
        fourLabel.text = [NSString stringWithFormat:@"￥ %@积分\n (%@ %@积分)",money,self.productModel.currencySign,behindStr];
        fourLabel.attributedText = [DataUsedEngine mutableFontArray:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"￥ %@",money],@"积分\n",[NSString stringWithFormat:@" (%@ %@",self.productModel.currencySign,behindStr],@"积分",@")", nil] fontArray:[NSMutableArray arrayWithObjects: [self get4sFontSize],@"11",@"11",@"8",@"11", nil]];
        
        NSString    *threeMoneyOfRate = [DataEngine addSign:[NSString stringWithFormat:@"%.0f",[_tradeModel.cashFund floatValue] * [_numArray[selectNum] intValue] * [_tradeModel.rate floatValue]] pointNum:0];
        NSString    *threeMoney = [DataEngine addSign:[NSString stringWithFormat:@"%.0f",[_tradeModel.cashFund floatValue] * [_numArray[selectNum] intValue]] pointNum:0];
        
        threeLabel.text = [NSString stringWithFormat:@"￥ %@积分\n (%@ %@积分)",threeMoneyOfRate,self.productModel.currencySign,threeMoney];
        threeLabel.attributedText = [DataUsedEngine mutableFontArray:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"￥ %@",threeMoneyOfRate],@"积分\n",[NSString stringWithFormat:@"(%@ %@",self.productModel.currencySign,threeMoney],@"积分",@")", nil] fontArray:[NSMutableArray arrayWithObjects:[self get4sFontSize],@"11",@"11",@"8",@"11", nil]];
    }
    else{
        fourLabel.text = [NSString stringWithFormat:@"￥ %@积分",behindStr];
        fourLabel.attributedText = [DataUsedEngine mutableFontArray:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"￥ %@",behindStr],@"积分", nil] fontArray:[NSMutableArray arrayWithObjects:[self get4sFontSize],@"11",nil]];
        
        threeLabel.text = [NSString stringWithFormat:@"￥ %@积分",[DataEngine addSign:[NSString stringWithFormat:@"%.0f",[_tradeModel.cashFund floatValue] * [_numArray[selectNum] intValue]] pointNum:0]];
        threeLabel.attributedText = [DataUsedEngine mutableFontArray:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"￥ %@",[DataEngine addSign:[NSString stringWithFormat:@"%.0f",[_tradeModel.cashFund floatValue] * [_numArray[selectNum] intValue]] pointNum:0]],@"积分", nil] fontArray:[NSMutableArray arrayWithObjects:[self get4sFontSize],@"11", nil]];
    }
    
}
#pragma mark 现金配置
-(void)amountDataConfigerWithThreeLabel:(UILabel *)threeLabel FourLabel:(UILabel *)fourLabel TwoLabelPrice:(NSString *)twoLabelPrice{
    if (_moneyConfigerArray != nil && selectStop >= _moneyConfigerArray.count) {
        selectStop = (int)_moneyConfigerArray.count - 1;
    }
    
    NSString    *behindStr = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[_tradeModel.counterFee doubleValue] * [_numArray[selectNum] intValue]]];
    
    _oneLabel.text = [NSString stringWithFormat:@"%@%@/手",self.productModel.currencySign,[DataEngine addSign:[NSString stringWithFormat:@"%.2f",[_tradeModel.maxLoss floatValue]]]];
    _twoLabel.text = [NSString stringWithFormat:@"%@%@/手",self.productModel.currencySign,[DataEngine addSign:[NSString stringWithFormat:@"%.2f",[twoLabelPrice floatValue]]]];
    
    if (_tradeModel.rate != nil &&[_tradeModel.rate floatValue] != 1) {
        NSString    *threeMoneyOfRate = [NSString stringWithFormat:@"%@",[DataEngine addSign:[NSString stringWithFormat:@"%.2f",[_tradeModel.cashFund floatValue] * [_numArray[selectNum] intValue] * [_tradeModel.rate floatValue]]]];
        NSString    *threeMoney = [NSString stringWithFormat:@"%@ %@",self.productModel.currencySign,[DataEngine addSign:[NSString stringWithFormat:@"%.2f",[_tradeModel.cashFund floatValue] * [_numArray[selectNum] intValue]]]];
        threeLabel.text = [NSString stringWithFormat:@"￥ %@\n (%@)",threeMoneyOfRate,threeMoney];
        threeLabel.attributedText = [DataUsedEngine mutableFontArray:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"￥ %@\n ",threeMoneyOfRate],[NSString stringWithFormat:@"(%@)",threeMoney], nil] fontArray:[NSMutableArray arrayWithObjects:[self get4sFontSize],@"11", nil]];
        
        NSString    *fourMoneyOfRate = [NSString stringWithFormat:@"%@",[DataEngine addSign:[NSString stringWithFormat:@"%.2f",[_tradeModel.counterFee doubleValue] * [_numArray[selectNum] intValue] * [_tradeModel.rate floatValue]]]];
        NSString    *fourMoney  = [NSString stringWithFormat:@"%@ %@",self.productModel.currencySign,behindStr];
        fourLabel.text = [NSString stringWithFormat:@"￥ %@\n (%@)",fourMoneyOfRate,fourMoney];
        fourLabel.attributedText = [DataUsedEngine mutableFontArray:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"￥ %@\n ",fourMoneyOfRate],[NSString stringWithFormat:@"(%@)",fourMoney], nil] fontArray:[NSMutableArray arrayWithObjects:[self get4sFontSize],@"11", nil]];
    }
    else{
        threeLabel.text = [NSString stringWithFormat:@"%@ %@",self.productModel.currencySign,[DataEngine addSign:[NSString stringWithFormat:@"%.2f",[_tradeModel.cashFund floatValue] * [_numArray[selectNum] intValue]]]];
        fourLabel.text = [NSString stringWithFormat:@"%@ %@",self.productModel.currencySign,behindStr];
    }
    
    //优惠的默认配置(隐藏优惠选项，只显示总手续费)
    _preferentialLabel.hidden = YES;
    
    
    //判断是否勾选和自动勾选优惠券(并且不是快速下单)
    if (isCouPonSelect == YES && !self.isQuickOrder) {
        
        if (couPonArray.count > 0) {
            //配置交易综合费和优惠
            [self discountAndFourLabelConfiger:fourLabel];
        }
    }
}

#pragma mark 配置交易综合费和优惠
-(void)discountAndFourLabelConfiger:(UILabel *)fourLabel{
    //优惠
    NSString    *frontStr = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[_tradeModel.counterFee doubleValue] * [_numArray[selectNum] intValue] - sunCoupon / [_tradeModel.rate floatValue]]];
    NSString    *behindStr = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[_tradeModel.counterFee doubleValue] * [_numArray[selectNum] intValue]]];
    
    NSString    *moneyOfRate = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[_tradeModel.counterFee doubleValue] * [_numArray[selectNum] intValue] * [_tradeModel.rate floatValue] - sunCoupon]];
    
    if (fourLabel != nil) {
        if (_tradeModel.rate != nil && [_tradeModel.rate floatValue] != 1) {
            fourLabel.text = [NSString stringWithFormat:@"%@ %@ ￥ %@\n(%@ %@)",self.productModel.currencySign,behindStr,moneyOfRate,self.productModel.currencySign,frontStr];
            fourLabel.attributedText = [DataUsedEngine mutableFontAndColorArrayAddDeleteLine:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%@ %@ ", self.productModel.currencySign,behindStr],[NSString stringWithFormat:@"￥ %@\n",moneyOfRate],[NSString stringWithFormat:@"(%@ %@)",self.productModel.currencySign,frontStr], nil]
                                                                                   fontArray:[NSMutableArray arrayWithObjects:@"15",@"15",@"11", nil]
                                                                                  colorArray:[NSMutableArray arrayWithObjects:@"99/99/99/1",@"255/255/255/1",@"255/255/255/255/1", nil]];
        }
        else{
            fourLabel.text = [NSString stringWithFormat:@"%@ %@ ￥ %@",self.productModel.currencySign,behindStr,moneyOfRate];
            fourLabel.attributedText = [DataUsedEngine mutableFontAndColorArrayAddDeleteLine:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%@ %@ ", self.productModel.currencySign,behindStr],[NSString stringWithFormat:@"￥ %@",moneyOfRate], nil]
                                                                                   fontArray:[NSMutableArray arrayWithObjects:@"15",@"15", nil]
                                                                                  colorArray:[NSMutableArray arrayWithObjects:@"99/99/99/1",@"255/255/255/1", nil]];
        }
        

        if (!self.isQuickOrder) {
            _preferentialLabel.hidden = NO;
        }
    }
}

#pragma mark 加载汇率
-(void)loadRate{
    UIView  *view = [self.view viewWithTag:Tag_rateview];
    if (_tradeModel != nil && [_tradeModel.rate floatValue] != 1 && view == nil && _couPonView != nil) {
        UIView  *rateView = [[UIView alloc]initWithFrame:CGRectMake(20, _couPonView.frame.origin.y, ScreenWidth-40, 40.0/568*ScreenHeigth+1)];
        rateView.backgroundColor = Color_black;
        rateView.tag    = Tag_rateview;
        [self.view addSubview:rateView];
        
        UILabel    *label = [[UILabel alloc]initWithFrame:CGRectMake(0,0, ScreenWidth/2, 40.0/568*ScreenHeigth)];
        label.text = [NSString stringWithFormat:@"汇率 > %@人民币",_productModel.currencyName];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [UIColor lightGrayColor];
        [rateView addSubview:label];
        
        UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, label.frame.origin.y, rateView.frame.size.width-60, 40.0/568*ScreenHeigth)];
        moneyLabel.textAlignment = NSTextAlignmentRight;
        moneyLabel.text = [NSString stringWithFormat:@"1%@=%.2f元人民币",_productModel.currencyName,[_tradeModel.rate floatValue]];
        moneyLabel.numberOfLines = 0;
        moneyLabel.font = [UIFont systemFontOfSize:13];
        if (ScreenHeigth<=480) {
            moneyLabel.font = [UIFont systemFontOfSize:11];
        }
        moneyLabel.textColor = Color_Gold;
        [rateView addSubview:moneyLabel];
        
        UIView  *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, moneyLabel.frame.origin.y+moneyLabel.frame.size.height, rateView.frame.size.width, 0.5)];
        lineView.backgroundColor = [UIColor grayColor];
        [rateView addSubview:lineView];
        
        _couPonView.frame = CGRectMake(_couPonView.frame.origin.x, rateView.frame.origin.y+rateView.frame.size.height, _couPonView.frame.size.width, _couPonView.frame.size.height);
    }
}

#pragma mark 刷新触发止损、止盈价
//计算止损止盈单价
-(double)calculateStopUnitPrice{
    double aStopPrice = 0.0;
    
    TradeConfigerModel *tradeModel ;
    
    if (isIntegral) {
        if (chooseStopNum == 0) {
            tradeModel = _integralTrade;
        }
    }
    else{
        if (chooseStopNum == 0) {
            tradeModel = _moneyTrade;
        }
    }
    
    aStopPrice = [tradeModel.maxLoss doubleValue];
    
    return aStopPrice;
}

-(double)calculateGetUnitPrice{
    double aGetPrice  = 0.0;
    
    TradeConfigerModel *tradeModel ;
    
    if (isIntegral) {
        if (chooseStopNum == 0) {
            tradeModel = _integralTrade;
        }
    }
    else{
        if (chooseStopNum == 0) {
            tradeModel = _moneyTrade;
        }
    }
    NSString    *twoLabelPrice;
    NSArray  * getArray = [tradeModel.maxProfit componentsSeparatedByString:@","];
    if (getArray != nil && selectGet <= getArray.count-1) {
        twoLabelPrice = getArray[selectGet];
    }
    else{
        twoLabelPrice = @"";
    }
    
    aGetPrice  = [twoLabelPrice doubleValue];
    
    return aGetPrice;
}

-(void)reloadOfStopPriceOrGetPrice{
    
    double  aStopPrice = [self calculateStopUnitPrice] ,
            aGetPrice = [self calculateGetUnitPrice];
    
    double unitPrice = 0.0;
    
    UILabel *stopLabel = (UILabel *)[self.view viewWithTag:Tag_stop];
    UILabel *getLabel  = (UILabel *)[self.view viewWithTag:Tag_get];
    UILabel *chooseStopLabel = (UILabel *)[self.view viewWithTag:Tag_chooseStop];
    UILabel *chooseGetLabel = (UILabel *)[self.view viewWithTag:Tag_chooseGet];
    
    if ([_oneLabel.text isEqualToString:@"￥0.00"]) {
        _oneLabel.text = @"请选择止损额度";
    }
    
    if ([_twoLabel.text isEqualToString:@"￥0.00"]) {
        _twoLabel.text = @"请选择止盈额度";
    }
    
    //市价触发止损、触发止盈
    if (stopLabel != nil) {
        if ([_oneLabel.text rangeOfString:@"请选择"].location == NSNotFound) {
            
            unitPrice = aStopPrice/[self.productModel.multiple doubleValue];
            
            NSString *unitPriceStr = [NSString stringWithFormat:@"%f",unitPrice];
            
            if (self.buyState == 0) {
                stopLabel.text = [NSString stringWithFormat:@"触发止损（价格%@）",[DataUsedEngine conversionFloatNum:[_indexBuyModel.bullishBuyPrice floatValue] - [unitPriceStr floatValue] ExpectFloatNum:[self.productModel.decimalPlaces intValue] ]];
            }
            else if (self.buyState == 1){
                stopLabel.text = [NSString stringWithFormat:@"触发止损（价格%@）",[DataUsedEngine conversionFloatNum:[_indexBuyModel.bearishAveragePrice floatValue] + [unitPriceStr floatValue] ExpectFloatNum:[self.productModel.decimalPlaces intValue] ]];
            }
            
            if (stopLabel.text.length > 4) {
                stopLabel.attributedText = [Helper multiplicityText:stopLabel.text from:4 to:(int)stopLabel.text.length - 4 color:Color_Gold];
            }
        }
    }
    
    if (getLabel != nil) {
        if ([_twoLabel.text rangeOfString:@"请选择"].location == NSNotFound) {
            
            unitPrice = aGetPrice/[self.productModel.multiple doubleValue];
            
            NSString *unitPriceStr = [NSString stringWithFormat:@"%f",unitPrice];
            
            
            if (self.buyState == 0) {
                
                getLabel.text = [NSString stringWithFormat:@"触发止盈（价格%@）",[DataUsedEngine conversionFloatNum:[_indexBuyModel.bullishBuyPrice floatValue] + [unitPriceStr floatValue] ExpectFloatNum:[self.productModel.decimalPlaces intValue] ]];
            }
            else if (self.buyState == 1){
                
                getLabel.text = [NSString stringWithFormat:@"触发止盈（价格%@）",[DataUsedEngine conversionFloatNum:[_indexBuyModel.bearishAveragePrice floatValue] - [unitPriceStr floatValue] ExpectFloatNum:[self.productModel.decimalPlaces intValue] ]];
            }
            
            if (getLabel.text.length > 4) {
                getLabel.attributedText = [Helper multiplicityText:getLabel.text from:4 to:(int)getLabel.text.length - 4 color:Color_Gold];
            }
        }
    }
    
    //条件单
    if (chooseStopLabel != nil) {
        unitPrice = [_chooseBillModel.chooseStopMoney floatValue]/[self.productModel.multiple doubleValue];
        
        NSString *unitPriceStr = [NSString stringWithFormat:@"%f",unitPrice];
        
        if (self.buyState == 0) {
            chooseStopLabel.text = [NSString stringWithFormat:@"参考价格%@",[DataUsedEngine conversionFloatNum:[_indexBuyModel.bullishBuyPrice floatValue] - [unitPriceStr floatValue] ExpectFloatNum:[self.productModel.decimalPlaces intValue] ]];
        }
        else if (self.buyState == 1){
            chooseStopLabel.text = [NSString stringWithFormat:@"参考价格%@",[DataUsedEngine conversionFloatNum:[_indexBuyModel.bearishAveragePrice floatValue] + [unitPriceStr floatValue] ExpectFloatNum:[self.productModel.decimalPlaces intValue] ]];
        }
    }
    
    if (chooseGetLabel != nil) {
        unitPrice = [_chooseBillModel.chooseGetMoney floatValue]/[self.productModel.multiple doubleValue];
        
        NSString *unitPriceStr = [NSString stringWithFormat:@"%f",unitPrice];
        
        if (self.buyState == 0) {
            
            chooseGetLabel.text = [NSString stringWithFormat:@"参考价格%@",[DataUsedEngine conversionFloatNum:[_indexBuyModel.bullishBuyPrice floatValue] + [unitPriceStr floatValue] ExpectFloatNum:[self.productModel.decimalPlaces intValue] ]];
        }
        else if (self.buyState == 1){
            
            chooseGetLabel.text = [NSString stringWithFormat:@"参考价格%@",[DataUsedEngine conversionFloatNum:[_indexBuyModel.bearishAveragePrice floatValue] - [unitPriceStr floatValue] ExpectFloatNum:[self.productModel.decimalPlaces intValue] ]];
        }
    }
}

#pragma mark 配置交易数量按钮
-(void)configerButton{
    TradeConfigerModel *tradeNumModel ;
    
    if (isIntegral) {
        if (chooseStopNum == 0) {
            if (_integralTrade == nil) {
                _integralTrade = _integralConfigerArray[0];
            }
            tradeNumModel = _integralTrade;
        }
    }
    else{
        if (chooseStopNum == 0) {
            if (_moneyTrade == nil) {
                _moneyTrade = _moneyConfigerArray[0];
            }
            tradeNumModel = _moneyTrade;
        }
    }
    
    NSArray *muliArray = [tradeNumModel.multiple componentsSeparatedByString:@","];
    
    [_numArray removeAllObjects];
    
    for (int i = 0; i<muliArray.count; i++) {
        [_numArray addObject:[NSNumber numberWithInt:[muliArray[i] intValue]]];
    }
    
    
    NSArray *numsArray = _numArray;
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i< _numArray.count; i++) {
        for (int j = 0; j<numsArray.count; j++) {
            if ([_numArray[i] intValue] == [numsArray[j] intValue]) {
                [array addObject:_numArray[i]];
            }
        }
    }
    
    for (int i = 0; i<_numArray.count; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i+777];
        button.tag = i+777;
        [button setTitle:[NSString stringWithFormat:@"%d手",[_numArray[i] intValue]] forState:UIControlStateNormal];
    }
    
}
#pragma mark -
#pragma mark UI

-(void)loadUI{
    self.view.backgroundColor = Color_black;
    
    [self loadSeg];
    
    //当前价
    [self loadCurrentPriceLabel];
    
    //触发止损、止盈、手数
    [self loadStopAndGetUI];
    
    //保证金、手续费
    [self loadOtherMoneyLabel];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ScreenHeigth-80.0/667*ScreenHeigth-5.0/568.0*ScreenHeigth - 20.0/568*ScreenHeigth, ScreenWidth, 20.0/568*ScreenHeigth)];
    _timeLabel.font = [UIFont boldSystemFontOfSize:13];
    _timeLabel.textColor = Color_Red;
    _timeLabel.tag = Tag_timeLabel;
    _timeLabel.text = @"本时段持仓时间至02:25:00";
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_timeLabel];
    if (!self.canUse) {
        _timeLabel.hidden = YES;
    }

    _timeProLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _timeLabel.frame.origin.y - 10, ScreenWidth, 10)];
    _timeProLabel.textColor = Color_Red;
    _timeProLabel.text = @"条件委托只对本时段有效，过点自动撤销委托";
    _timeProLabel.font = [UIFont systemFontOfSize:9];
    _timeProLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_timeProLabel];
    _timeProLabel.frame = CGRectMake(_timeProLabel.frame.origin.x, _timeProLabel.frame.origin.y, [DataUsedEngine getStringRectWithString:_timeProLabel.text Font:9 Width:ScreenWidth Height:10].width, _timeProLabel.frame.size.height);
    _timeProLabel.center = CGPointMake(ScreenWidth/2+6, _timeProLabel.center.y);
    _timeProLabel.hidden = YES;
    
    
    _timeSignLabel = [[UILabel alloc]initWithFrame:CGRectMake(_timeProLabel.frame.origin.x - 12, _timeProLabel.frame.origin.y, 10, 10)];
    _timeSignLabel.backgroundColor = Color_Red;
    _timeSignLabel.text = @"!";
    _timeSignLabel.font = [UIFont systemFontOfSize:10];
    _timeSignLabel.textAlignment = NSTextAlignmentCenter;
    _timeSignLabel.clipsToBounds = YES;
    _timeSignLabel.layer.cornerRadius = 10/2.0;
    _timeSignLabel.center = CGPointMake(_timeSignLabel.center.x, _timeProLabel.center.y);
    [self.view addSubview:_timeSignLabel];
    _timeSignLabel.hidden = YES;
    
    [self loadBottomButton];
    
}

#pragma mark 当前价

-(void)loadCurrentPriceLabel{
    
    UILabel *proLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (64+40)/568.0*ScreenHeigth, ScreenWidth, 14)];
    if (self.buyState == 0) {
        proLabel.text  = @"看多价";
    }
    else{
        proLabel.text  = @"看空价";
    }
    proLabel.textAlignment = NSTextAlignmentCenter;
    proLabel.font = [UIFont systemFontOfSize:10];
    proLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:proLabel];
    
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, proLabel.frame.size.height+proLabel.frame.origin.y, ScreenWidth, 20)];
    _priceLabel.text = @"— —";
    _priceLabel.font = [UIFont systemFontOfSize:17];
    _priceLabel.textColor = Color_Gold;
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_priceLabel];
    
    if (self.buyState == 0) {
        _priceLabel.text = _indexBuyModel.bullishBuyPrice;
    }
    else if (self.buyState == 1){
        _priceLabel.text = _indexBuyModel.bearishAveragePrice;
    }
    
    if ([self.productModel.decimalPlaces intValue] == 2) {
        _priceLabel.text = [NSString stringWithFormat:@"%.2f",[_priceLabel.text doubleValue]];
    }
    else if ([self.productModel.decimalPlaces intValue] == 1){
        _priceLabel.text = [NSString stringWithFormat:@"%.1f",[_priceLabel.text doubleValue]];
    }
    else if ([self.productModel.decimalPlaces intValue] == 0){
        _priceLabel.text = [NSString stringWithFormat:@"%.0f",[_priceLabel.text doubleValue]];
    }
    else{
        _priceLabel.text = [NSString stringWithFormat:@"%.2f",[_priceLabel.text doubleValue]];
    }
    
    [self updateCurrentPriceLabel];
}

-(void)updateCurrentPriceLabel{
    
    if ([_priceLabel.text rangeOfString:@"."].location != NSNotFound) {
        NSArray *temArray = [_priceLabel.text componentsSeparatedByString:@"."];
        
        if (temArray != nil && temArray.count > 0) {
            _priceLabel.attributedText = [Helper multiplicityText:_priceLabel.text from:0 to:(int)[temArray[0] length] font:23];
        }
    }
    else{
        _priceLabel.attributedText = [Helper multiplicityText:_priceLabel.text from:0 to:(int)[_priceLabel.text length] font:23];
    }
}

#pragma mark 触发止盈、止损
-(void)loadStopAndGetUI{
    //BGView
    self.chooseBGView = [[UIView alloc]initWithFrame:CGRectMake(0, self.stopAndGetFrontHeight/568*ScreenHeigth, ScreenWidth, 3*(40.0/568*ScreenHeigth))];
    [self.view addSubview:self.chooseBGView];
    
    NSArray *array = @[@"交易数量",@"触发止损",@"触发止盈"];
    
    for (int i = 0; i < 3; i++) {
        
        float labelWidth = 60;
        
        if (i != 0) {
            labelWidth = ScreenWidth/2;
        }
        
        UILabel    *label = [[UILabel alloc]initWithFrame:CGRectMake(20, i*(40.0/568*ScreenHeigth), labelWidth, 40.0/568*ScreenHeigth)];
        label.text = array[i];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [UIColor lightGrayColor];
        if (i==1) {
            label.tag = Tag_stop;
        }
        else if (i == 2){
            label.tag = Tag_get;
        }
        [self.chooseBGView addSubview:label];
        
        if (i==0) {
            UIView *view = [self transactionNumberView:CGRectMake(60+20, label.frame.origin.y, ScreenWidth-60-40, 40.0/568*ScreenHeigth)];
            [self.chooseBGView addSubview:view];
        }
        else{
            if (i == 1) {
                
                UIView  *clickView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth - (320.0/5*2)-20, label.frame.origin.y+7, 320.0/5*2+10, (40.0/568*ScreenHeigth)/5*3)];
                clickView.backgroundColor = Color_Gold;
                clickView.clipsToBounds = YES;
                clickView.layer.cornerRadius = 2;
                clickView.userInteractionEnabled = YES;
                [self.chooseBGView addSubview:clickView];
                
                _oneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320.0/5*2-15+10, (40.0/568*ScreenHeigth)/5*3)];
                _oneLabel.textAlignment = NSTextAlignmentRight;
                _oneLabel.text = @"请选择止损金额/手";
                _oneLabel.font = [UIFont systemFontOfSize:15];
                _oneLabel.textColor = [UIColor blackColor];
                _oneLabel.tag = Tag_oneLine;
                _oneLabel.userInteractionEnabled = YES;
                [clickView addSubview:_oneLabel];
                
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(clickView.frame.size.width-10, 9, 5, clickView.frame.size.height-18)];
                imageView.image = [UIImage imageNamed:@"button_order"];
                imageView.userInteractionEnabled = YES;
                [clickView addSubview:imageView];
                
                UITapGestureRecognizer *stopTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseStop)];
                [clickView addGestureRecognizer:stopTap];
                
                
            }
            else{
                
                UIView  *clickView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth - (320.0/5*2) - 20, label.frame.origin.y+7, 320.0/5*2+10, (40.0/568*ScreenHeigth)/5*3)];
                clickView.backgroundColor = Color_Gold;
                clickView.clipsToBounds = YES;
                clickView.layer.cornerRadius = 2;
                [self.chooseBGView addSubview:clickView];
                
                _twoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320.0/5*2-15+10, (40.0/568*ScreenHeigth)/5*3)];
                _twoLabel.textAlignment = NSTextAlignmentRight;
                _twoLabel.text = @"请选择止盈金额/手";
                _twoLabel.font = [UIFont systemFontOfSize:15];
                _twoLabel.textColor = [UIColor blackColor];
                _twoLabel.tag = Tag_twoLine;
                [clickView addSubview:_twoLabel];
                
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(clickView.frame.size.width-10, 9, 5, clickView.frame.size.height-18)];
                imageView.image = [UIImage imageNamed:@"button_order"];
                imageView.userInteractionEnabled = YES;
                [clickView addSubview:imageView];
                
                UITapGestureRecognizer *getTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseGet)];
                [clickView addGestureRecognizer:getTap];
            }
            
        }
        
    }
}

#pragma mark 保证金手续费
/**
 *  保证金手续费
 */
-(void)loadOtherMoneyLabel{
    
    NSMutableArray     *bottomArray;
    
    if ([_isCouPon isEqualToString:@"NO"]) {
        if (self.isQuickOrder) {
            if ([self.productModel.loddyType isEqualToString:@"1"]) {
                bottomArray = [NSMutableArray arrayWithObjects:@"冻结 > 保证金",@"支付 > 交易综合费",@"优惠券", nil];
            }
            else{
                bottomArray = [NSMutableArray arrayWithObjects:@"冻结 > 保证金",@"支付 > 交易综合费", nil];
            }
        }
        else{
            bottomArray = [NSMutableArray arrayWithObjects:@"冻结 > 保证金",@"支付 > 交易综合费", nil];
        }
    }else
    {
        if ([self.productModel.loddyType isEqualToString:@"1"]) {
            bottomArray = [NSMutableArray arrayWithObjects:@"冻结 > 保证金",@"支付 > 交易综合费",@"优惠券", nil];
        }
        else{
            bottomArray = [NSMutableArray arrayWithObjects:@"冻结 > 保证金",@"支付 > 交易综合费", nil];
        }
    }
    
    _couPonView = [[UIView alloc]init];
    _couPonView.frame = CGRectMake(0, self.otherMoneyFrontHeight, ScreenWidth, bottomArray.count *(40.0/568*ScreenHeigth));
    [self.view addSubview:_couPonView];
    
    
    UIView  *rateView = [self.view viewWithTag:Tag_rateview];
    if (rateView != nil) {
        _couPonView.frame = CGRectMake(_couPonView.frame.origin.x, rateView.frame.origin.y+rateView.frame.size.height, _couPonView.frame.size.width, _couPonView.frame.size.height);
    }
    
    for (int i = 0 ; i<bottomArray.count; i++) {
        UILabel    *label = [[UILabel alloc]initWithFrame:CGRectMake(20,i*(40.0/568*ScreenHeigth), ScreenWidth/2, 40.0/568*ScreenHeigth)];
        label.text = bottomArray[i];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [UIColor lightGrayColor];
        [_couPonView addSubview:label];
        
        UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(60+20, label.frame.origin.y, ScreenWidth-60-40, 40.0/568*ScreenHeigth)];
        moneyLabel.textAlignment = NSTextAlignmentRight;
        moneyLabel.text = @"￥0.00";
        moneyLabel.numberOfLines = 0;
        moneyLabel.font = [UIFont boldSystemFontOfSize:15];
        if (ScreenHeigth<=480) {
            moneyLabel.font = [UIFont systemFontOfSize:12];
        }
        moneyLabel.textColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
        
        //=====
        if (i == 0) {
            moneyLabel.tag = Tag_threeLine;
        }else if (i ==1)
        {
            moneyLabel.tag = Tag_fourLine;
        }else if (i == 2)
        {
            if ([_isCouPon isEqualToString:@"NO"]) {
                moneyLabel.tag = Tag_fiveLine;
                _couPonLab.hidden = YES;
                if (self.isQuickOrder) {
                    _couPonLab.hidden = NO;
                    _couPonLab = moneyLabel;
                    _couPonLab.tag = 1001010;
                    _couPonLab.frame = moneyLabel.frame;
                    _couPonLab.text = @"自动抵扣";
                    _couPonLab.textColor = [UIColor redColor];
                    [_couPonView addSubview:_couPonLab];
                    
                    CGSize moneSize = [Helper sizeWithText:moneyLabel.text font:[UIFont  systemFontOfSize:15.0] maxSize:CGSizeMake(ScreenWidth - 60 - 40, label.frame.size.height)];
                    _couPonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    _couPonBtn.tag = 1001011;
                    _couPonBtn.frame = CGRectMake(ScreenWidth - 60 - moneSize.width - 5, CGRectGetMinY(moneyLabel.frame), 40, label.frame.size.height);
                    [_couPonBtn setImage:[UIImage imageNamed:@"coupon_00"] forState:UIControlStateNormal];
                    [_couPonBtn addTarget:self action:@selector(clickCouPonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [_couPonView addSubview:_couPonBtn];

                }
            }else
            {
                _couPonLab = moneyLabel;
                _couPonLab.tag = 1001010;
                _couPonLab.frame = moneyLabel.frame;
                _couPonLab.text = @"使用1张";
                _couPonLab.textColor = [UIColor redColor];
                [_couPonView addSubview:_couPonLab];

                CGSize moneSize = [Helper sizeWithText:moneyLabel.text font:[UIFont  systemFontOfSize:15.0] maxSize:CGSizeMake(ScreenWidth - 60 - 40, label.frame.size.height)];
                _couPonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _couPonBtn.tag = 1001011;
                _couPonBtn.frame = CGRectMake(ScreenWidth - 60 - moneSize.width - 5, CGRectGetMinY(moneyLabel.frame), 40, label.frame.size.height);
                [_couPonBtn setImage:[UIImage imageNamed:@"coupon_00"] forState:UIControlStateNormal];
                [_couPonBtn addTarget:self action:@selector(clickCouPonAction:) forControlEvents:UIControlEventTouchUpInside];
                [_couPonView addSubview:_couPonBtn];

            }
        }
        
        if ([_isCouPon isEqualToString:@"YES"] || self.isQuickOrder) {
            if (i == 3) {
                moneyLabel.tag = Tag_fiveLine;
            }
        }
        [_couPonView addSubview:moneyLabel];
        
        if (i != bottomArray.count-1) {
            UIView  *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, label.frame.origin.y+label.frame.size.height, ScreenWidth-40, 0.5)];
            lineView.backgroundColor = [UIColor grayColor];
            [_couPonView addSubview:lineView];
        }
        if (i==1) {
            _preferentialLabel = [[UILabel alloc]initWithFrame:CGRectMake(112, label.frame.origin.y, 40, 16)];
            _preferentialLabel.center = CGPointMake(_preferentialLabel.center.x, label.center.y);
            _preferentialLabel.backgroundColor = CanSelectButBackColor;
            _preferentialLabel.font = [UIFont systemFontOfSize:10];
            _preferentialLabel.textAlignment = NSTextAlignmentCenter;
            _preferentialLabel.layer.cornerRadius = 2;
            _preferentialLabel.clipsToBounds = YES;
            _preferentialLabel.text = @"优惠";
            _preferentialLabel.textColor = [UIColor whiteColor];
            [_couPonView addSubview:_preferentialLabel];
            _preferentialLabel.hidden = YES;
        }
    }
    
    
    
    if (self.isQuickOrder) {
        [self couPonChange];
        
        if (self.isOpen) {
            _couPonBtn.enabled = NO;
        }
    }
}

#pragma mark 自动抵扣 按钮配置
-(void) couPonChange{
    UILabel *sumLab = [self.couPonView viewWithTag:705];
    CGSize couPonSize = [Helper sizeWithText:self.couPonLab.text font:[UIFont systemFontOfSize:15.0] maxSize:CGSizeMake(ScreenWidth - 60 - 40, 40.0/568*ScreenHeigth)];
    
    self.couPonBtn.frame = CGRectMake(ScreenWidth - 60 - couPonSize.width, CGRectGetMinY(self.couPonLab.frame), 40, self.couPonLab.frame.size.height);
    
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:cacheModel.tradeDic[self.productModel.tradeDicName][kOrderQuickDic]];
    NSString *fontStr = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[self.tradeModel.counterFee floatValue] * [self.numArray[self.selectNum] intValue] + [self.tradeModel.cashFund floatValue] * [self.numArray[self.selectNum] intValue]]];
    NSString *behindStr = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[self.tradeModel.counterFee floatValue] * [self.numArray[self.selectNum] intValue] + [self.tradeModel.cashFund floatValue] * [self.numArray[self.selectNum] intValue] - self.sunCoupon]];
    
    if (![dataDic[@"isQuickCouponStatus"] isEqualToString:@"NO"])
    {
        if (![self.isAutoBtn isEqualToString:@"NO"]) {
            if ([self.couPonLab.text isEqualToString:@"自动抵扣"])
            {
                sumLab.text = [NSString stringWithFormat:@"￥ %@",fontStr];
            }else
            {
                NSString *ceshiStr = [NSString stringWithFormat:@"￥%@ ￥%@",fontStr,behindStr];
                sumLab.attributedText = [self multiplicityActivity:ceshiStr from:0 to:(int)(fontStr.length+1) color:[UIColor lightGrayColor] otherFontWithFrom:0 to:0 SecondOtherFontWithFrom:0 to:0];
            }
            
            [self.couPonBtn setImage:[UIImage imageNamed:@"coupon_00"] forState:UIControlStateNormal];
            [self.couPonBtn setSelected:NO];
        }else
        {
            [self.couPonBtn setImage:[UIImage imageNamed:@"coupon_01"] forState:UIControlStateNormal];
            [self.couPonBtn setSelected:YES];
            sumLab.text = [NSString stringWithFormat:@"￥ %@",fontStr];
        }
        
    }else
    {
        [self.couPonBtn setImage:[UIImage imageNamed:@"coupon_01"] forState:UIControlStateNormal];
        [self.couPonBtn setSelected:YES];
        sumLab.text = [NSString stringWithFormat:@"￥ %@",fontStr];
    }
    if (self.isOpen) {
        self.couPonBtn.enabled = NO;
    }else
    {
        self.couPonBtn.enabled = YES;
    }
}

#pragma mark -
#pragma mark 选择止损

-(void)chooseStop{
    
    if ([_oneLabel.superview.backgroundColor isEqual:Color_Gold]) {
        NSMutableArray *infoArray = [NSMutableArray arrayWithCapacity:0];
        
        if (isIntegral==0) {
            for (int i = 0; i < _moneyConfigerArray.count; i++) {
                TradeConfigerModel *tradeModel = _moneyConfigerArray[i];
                [infoArray addObject:tradeModel.maxLoss];
            }
        }
        else{
            for (int i = 0; i < _integralConfigerArray.count; i++) {
                TradeConfigerModel *tradeModel = _integralConfigerArray[i];
                [infoArray addObject:tradeModel.maxLoss];
            }
        }
        
        NSString    *unit = self.productModel.currencySign;
        
        [[UIEngine sharedInstance] showOrderAlertWithTitle:@"请选择止损金额/手" DataArray:infoArray isMoney:isIntegral DefaultSelect:selectStop Unit:unit];
        
        [UIEngine sharedInstance].orderClick = ^(int aIndex){
            selectStop = aIndex;
            if (isIntegral == 0) {
                _moneyTrade = _moneyConfigerArray[selectStop];
            }
            else{
                _integralTrade = _integralConfigerArray[selectStop];
            }
            
            CacheModel *cacheModel = [CacheEngine getCacheInfo];
            if (self.isQuickOrder) {
                [cacheModel.tradeDic[self.productModel.tradeSubDicName] setObject:[NSNumber numberWithInt:aIndex] forKey:@"chooseStopQuick"];
            }
            else{
                [cacheModel.tradeDic[self.productModel.tradeSubDicName] setObject:[NSNumber numberWithInt:aIndex] forKey:@"chooseStop"];
            }
            
            [CacheEngine setCacheInfo:cacheModel];
            
            if (isFirstStatus == YES) {
                _twoLabel.superview.backgroundColor = Color_Gold;
                
                TradeConfigerModel *tradeModel ;
                
                if (isIntegral) {
                    if (chooseStopNum == 0) {
                        tradeModel = _integralTrade;
                    }
                    
                    if (selectStop >= _integralConfigerArray.count) {
                        selectStop = (int)_integralConfigerArray.count - 1;
                    }
                }
                else{
                    if (chooseStopNum == 0) {
                        tradeModel = _moneyTrade;
                    }
                    
                    if (selectStop >= _moneyConfigerArray.count) {
                        selectStop = (int)_moneyConfigerArray.count - 1;
                    }
                }
                
                if(isIntegral){
                    if (_integralConfigerArray != nil && selectStop >= _integralConfigerArray.count) {
                        selectStop = (int)_integralConfigerArray.count - 1;
                    }
                    _oneLabel.text = [NSString stringWithFormat:@"%@%@积分/手",_productModel.currencySign,[DataEngine addSign:[NSString stringWithFormat:@"%.0f",[tradeModel.maxLoss floatValue]] pointNum:0]];
                    _oneLabel.attributedText = [DataUsedEngine mutableFontArray:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%@%@",_productModel.currencySign,[DataEngine addSign:[NSString stringWithFormat:@"%.0f",[tradeModel.maxLoss floatValue]] pointNum:0]],@"积分",@"/手", nil] fontArray:[NSMutableArray arrayWithObjects:@"15",@"11",@"15", nil]];
                    
                }
                else{
                    if (_moneyConfigerArray != nil && selectStop >= _moneyConfigerArray.count) {
                        selectStop = (int)_moneyConfigerArray.count - 1;
                    }
                    _oneLabel.text = [NSString stringWithFormat:@"%@%@/手",self.productModel.currencySign,[DataEngine addSign:[NSString stringWithFormat:@"%.2f",[tradeModel.maxLoss floatValue]]]];
                }
                //刷新止损止盈价
                [self reloadOfStopPriceOrGetPrice];
            }
            else{
                [self defaultChooseGet:YES];
                
                //选择完止盈，重新选择止损，存储默认止盈
                CacheModel *cacheModel = [CacheEngine getCacheInfo];
                if (self.isQuickOrder) {
                    [cacheModel.tradeDic[self.productModel.tradeSubDicName] setObject:[NSNumber numberWithInt:selectGet] forKey:@"chooseGetQuick"];
                }
                else{
                    [cacheModel.tradeDic[self.productModel.tradeSubDicName] setObject:[NSNumber numberWithInt:selectGet] forKey:@"chooseGet"];
                }
                [CacheEngine setCacheInfo:cacheModel];
                
                [self reloadAllData];
            }
        };
    }
}

#pragma mark 选择止盈

-(void)chooseGet{
    
    if ([_twoLabel.superview.backgroundColor isEqual:Color_Gold]) {
        NSMutableArray *infoArray;
        
        if (isIntegral==0) {
            TradeConfigerModel *tradeModel = _moneyConfigerArray[selectStop];
            
            NSArray *temArray = [tradeModel.maxProfit componentsSeparatedByString:@","];
            
            infoArray = [NSMutableArray arrayWithArray:temArray];
            
        }
        else{
            TradeConfigerModel *tradeModel = _integralConfigerArray[selectStop];
            
            NSArray *temArray = [tradeModel.maxProfit componentsSeparatedByString:@","];
            
            infoArray = [NSMutableArray arrayWithArray:temArray];
        }
        
        NSString    *unit = self.productModel.currencySign;
        
        [[UIEngine sharedInstance] showOrderAlertWithTitle:@"请选择止盈金额/手" DataArray:infoArray isMoney:isIntegral DefaultSelect:selectGet Unit:unit];
        
        [UIEngine sharedInstance].orderClick = ^(int aIndex){
            selectGet = aIndex;
            
            if (isFirstStatus) {
                //缓存数组
                [self cacheTradeInfo];
            }
            
            isFirstStatus = NO;
            
            CacheModel *cacheModel = [CacheEngine getCacheInfo];
            if (self.isQuickOrder) {
                [cacheModel.tradeDic[self.productModel.tradeSubDicName] setObject:[NSNumber numberWithInt:aIndex] forKey:@"chooseGetQuick"];
            }
            else{
                [cacheModel.tradeDic[self.productModel.tradeSubDicName] setObject:[NSNumber numberWithInt:aIndex] forKey:@"chooseGet"];
            }
            [CacheEngine setCacheInfo:cacheModel];
            
            [self reloadAllData];
        };

    }
}

#pragma mark 选择最大止损
-(void)stopClick:(UIButton *)btn{
    UIButton *btnOne = (UIButton *)[self.view viewWithTag:750];
    btnOne.backgroundColor = Color_black;
    [btnOne setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *btnTwo = (UIButton *)[self.view viewWithTag:751];
    btnTwo.backgroundColor = Color_black;
    [btnTwo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    btn.backgroundColor = Color_Gold;
    [btn setTitleColor:Color_black forState:UIControlStateNormal];
    
    if (btn.tag == 751) {
        chooseStopNum = 1;
    }
    else{
        chooseStopNum = 0;
    }
    
    [self reloadAllData];
}

#pragma mark 积分和现金处理

-(void)judgeIntegralOrAmount{
    if ([self .productModel.loddyType isEqualToString:@"1"]) {
        isIntegral = NO;
    }
    else{
        isIntegral = YES;
    }
}

-(NSString *)get4sFontSize{
    /**
     *  字体大小适配
     */
    NSString *fontSize = @"15";
    if (ScreenHeigth<=480) {
        fontSize = @"12";
    }
    return fontSize;
}

-(void)segClickReloadData{
    if (!isIntegral) {
       //调用是否有优惠券的接口
        if (couPonArray.count > 0) {
            _isCouPon = @"YES";
            [_couPonView removeFromSuperview];
            [self loadOtherMoneyLabel];
        }
        if (selectStop >= _moneyConfigerArray.count) {
            selectStop = (int)_moneyConfigerArray.count - 1;
        }
        _moneyTrade = _moneyConfigerArray[selectStop];
    }
    else{
        if (selectStop >= _integralConfigerArray.count) {
            selectStop = (int)_integralConfigerArray.count - 1;
        }
        _integralTrade = _integralConfigerArray[selectStop];
        
        _isCouPon = @"NO";
        [_couPonView removeFromSuperview];
        [self loadOtherMoneyLabel];
    }
    
    if (!isFirstStatus) {
        [self reloadAllData];
    }
    else{
        if (isIntegral) {
            if (chooseStopNum == 0) {
                _tradeModel = _integralTrade;
            }
            
            if (selectStop >= _integralConfigerArray.count) {
                selectStop = (int)_integralConfigerArray.count - 1;
            }
        }
        else{
            if (chooseStopNum == 0) {
                _tradeModel = _moneyTrade;
            }
            
            if (selectStop >= _moneyConfigerArray.count) {
                selectStop = (int)_moneyConfigerArray.count - 1;
            }
        }

        UILabel *fourLabel = (UILabel *)[_couPonView viewWithTag:Tag_fourLine];
        fourLabel.text = @"";
        fourLabel.attributedText = nil;
        
        UILabel *threeLabel = (UILabel *)[_couPonView viewWithTag:Tag_threeLine];
        threeLabel.text = @"";
        threeLabel.attributedText = nil;
        
        
        
        if (isIntegral) {
            
            if ([_oneLabel.text rangeOfString:@"请选择"].location == NSNotFound) {
                _oneLabel.text = [NSString stringWithFormat:@"%@%@积分/手",_productModel.currencySign,[DataEngine addSign:[NSString stringWithFormat:@"%.0f",[_tradeModel.maxLoss floatValue]]]];
                _oneLabel.attributedText = [DataUsedEngine mutableFontArray:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%@%@",_productModel.currencySign,[DataEngine addSign:[NSString stringWithFormat:@"%.0f",[_tradeModel.maxLoss floatValue]]]],@"积分",@"/手", nil] fontArray:[NSMutableArray arrayWithObjects:@"15",@"11",@"15", nil]];
            }
            
            if (_tradeModel.rate != nil && [_tradeModel.rate floatValue] != 1) {
                NSString *behindStr = [DataEngine addSign:[NSString stringWithFormat:@"%.0f",[_tradeModel.counterFee floatValue] * [_numArray[selectNum] floatValue]] pointNum:0];
                NSString    *money = [DataEngine addSign:[NSString stringWithFormat:@"%.0f",([_tradeModel.rate floatValue] * [_tradeModel.counterFee doubleValue] * ([_numArray[selectNum] intValue]))] pointNum:0];
                fourLabel.text = [NSString stringWithFormat:@"￥ %@积分\n (%@ %@积分)",money,self.productModel.currencySign,behindStr];
                fourLabel.attributedText = [DataUsedEngine mutableFontArray:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"￥ %@",money],@"积分\n",[NSString stringWithFormat:@" (%@ %@",self.productModel.currencySign,behindStr],@"积分",@")", nil] fontArray:[NSMutableArray arrayWithObjects: [self get4sFontSize],@"11",@"11",@"8",@"11", nil]];
                
                NSString    *threeMoneyOfRate = @"--";
                NSString    *threeMoney = @"--";
                
                threeLabel.text = [NSString stringWithFormat:@"￥ %@积分\n (%@ %@积分)",threeMoneyOfRate,self.productModel.currencySign,threeMoney];
                threeLabel.attributedText = [DataUsedEngine mutableFontArray:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"￥ %@",threeMoneyOfRate],@"积分\n",[NSString stringWithFormat:@"(%@ %@",self.productModel.currencySign,threeMoney],@"积分",@")", nil] fontArray:[NSMutableArray arrayWithObjects:[self get4sFontSize],@"11",@"11",@"8",@"11", nil]];
            }
            else{
                NSString *fourMoney = [DataEngine addSign:[NSString stringWithFormat:@"%.0f",[_tradeModel.counterFee floatValue] * [_numArray[selectNum] floatValue]] pointNum:0];
                fourLabel.text = [DataEngine addSign:[NSString stringWithFormat:@"￥ %@积分",fourMoney] pointNum:0];
                fourLabel.attributedText = [DataUsedEngine mutableFontArray:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"￥ %@",fourMoney],@"积分", nil] fontArray:[NSMutableArray arrayWithObjects:[self get4sFontSize],@"11", nil]];
                threeLabel.text = @"--";
            }

            _preferentialLabel.hidden = YES;
        }
        else{
            
            if ([_oneLabel.text rangeOfString:@"请选择"].location == NSNotFound) {
                _oneLabel.text = [NSString stringWithFormat:@"￥%@/手",[DataEngine addSign:[NSString stringWithFormat:@"%.2f",[_tradeModel.maxLoss floatValue]]]];
            }
            
            //优惠
            NSString    *behindStr = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[_tradeModel.counterFee doubleValue] * [_numArray[selectNum] intValue]]];
            _preferentialLabel.hidden = YES;
            
            if (_tradeModel.rate != nil && [_tradeModel.rate floatValue] != 1) {
                NSString    *threeMoneyOfRate = [NSString stringWithFormat:@"%@",
                                                 @"--"];
                NSString    *threeMoney = [NSString stringWithFormat:@"%@ %@",
                                           self.productModel.currencySign,
                                           @"--"];
                threeLabel.text = [NSString stringWithFormat:@"￥ %@\n (%@)",threeMoneyOfRate,threeMoney];
                threeLabel.attributedText = [DataUsedEngine mutableFontArray:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"￥ %@\n ",threeMoneyOfRate],[NSString stringWithFormat:@"(%@)",threeMoney], nil] fontArray:[NSMutableArray arrayWithObjects:[self get4sFontSize],@"11", nil]];
                
                NSString    *fourMoneyOfRate = [NSString stringWithFormat:@"%@",[DataEngine addSign:[NSString stringWithFormat:@"%.2f",[_tradeModel.counterFee doubleValue] * [_numArray[selectNum] intValue] * [_tradeModel.rate floatValue]]]];
                NSString    *fourMoney  = [NSString stringWithFormat:@"%@ %@",self.productModel.currencySign,behindStr];
                fourLabel.text = [NSString stringWithFormat:@"%@\n (%@)",self.productModel.currencySign,behindStr];
                fourLabel.attributedText = [DataUsedEngine mutableFontArray:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"￥ %@\n ",fourMoneyOfRate],[NSString stringWithFormat:@"(%@)",fourMoney], nil] fontArray:[NSMutableArray arrayWithObjects:[self get4sFontSize],@"11", nil]];
            }
            else{
                fourLabel.text = [NSString stringWithFormat:@"%@ %@",self.productModel.currencySign,behindStr];
                threeLabel.text = [NSString stringWithFormat:@"%@ --",self.productModel.currencySign];;
            }
            
            //判断优惠券的张数和面额值是否大于手续费活手数
            sunCoupon = 0.0;
            double couPonMore = 0.0;
            double couPonLittle = 0.0;
            
            couPonIDArray = [[NSMutableArray alloc]init];
            
            if (couPonArray.count > 0 && couPonArray != nil) {
                if (couPonArray.count >[_numArray[selectNum] intValue]) {
                    useCouPonNum = [_numArray[selectNum] intValue];
                }else
                {
                    useCouPonNum = couPonArray.count;
                }
                for (NSInteger i = 0; i<useCouPonNum; i++)
                {
                    NSDictionary *couDic = couPonArray[i];
                    if ([couDic[@"amount"] doubleValue] > [_tradeModel.counterFee doubleValue] * [self.tradeModel.rate doubleValue]) {
                        couPonMore = couPonMore + [_tradeModel.counterFee doubleValue] * [self.tradeModel.rate doubleValue];
                    }else
                    {
                        couPonLittle = couPonLittle + [couDic[@"amount"] doubleValue];
                    }
                    
                    [couPonIDArray addObject:couDic[@"id"]];
                }
                
                sunCoupon = couPonLittle + couPonMore;
                if (self.isQuickOrder)
                {
                    CGSize moneSize = [Helper sizeWithText:@"自动抵扣" font:[UIFont  systemFontOfSize:15.0] maxSize:CGSizeMake(ScreenWidth - 60 - 40,_couPonLab.frame.size.height)];

                    _couPonLab.text = @"自动抵扣";
                     _couPonBtn.frame = CGRectMake(ScreenWidth - 60 - moneSize.width - 5, CGRectGetMinY(_couPonLab.frame), 40, _couPonLab.frame.size.height);
                }
                else if(isCouPonSelect){
                    _couPonLab.text = [NSString stringWithFormat:@"使用%ld张￥-%.1f",(long)useCouPonNum,sunCoupon];
                }
                else{
                    _couPonLab.text = @"未使用";
                }
                //优惠配置
                if (!self.isQuickOrder && isCouPonSelect) {
                    [self discountAndFourLabelConfiger:fourLabel];
                    [self reloadCouPonData];
                }
            }
            
            if (isCouPonSelect == YES) {
                [self.couPonBtn setImage:[UIImage imageNamed:@"coupon_00"] forState:UIControlStateNormal];

            }else
            {
                [self.couPonBtn setImage:[UIImage imageNamed:@"coupon_01"] forState:UIControlStateNormal];
            }
        }
    }
}

-(UIView *)transactionNumberView:(CGRect)aRect{
    _tradeNumView = [[UIView alloc]initWithFrame:aRect];
    _tradeNumView.backgroundColor = Color_black;
    
    //默认交易数量
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    int num = 0;
    if (self.isQuickOrder) {
        num = [cacheModel.tradeDic[self.productModel.tradeSubDicName][@"numfloat"] intValue];
    }
    
    selectNum = num;
    
    for (int i = 0 ; i<4; i++) {
        UIView  *lineFrontView = [[UIView alloc]initWithFrame:CGRectMake(i*((ScreenWidth-40-60)/4), 8, 0.5, _tradeNumView.bounds.size.height/5*3)];
        lineFrontView.backgroundColor = [UIColor lightGrayColor];
        [_tradeNumView addSubview:lineFrontView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*((ScreenWidth-40-60)/4), 8, ((ScreenWidth-40-60)/4)+1, _tradeNumView.bounds.size.height/5*3);
        
        if (i==3) {
            UIView *lineRightView = [[UIView alloc]initWithFrame:CGRectMake(button.frame.origin.x+button.frame.size.width-1, button.frame.origin.y, 0.5, _tradeNumView.bounds.size.height/5*3)];
            lineRightView.backgroundColor = [UIColor lightGrayColor];
            [_tradeNumView addSubview:lineRightView];
        }
    }
    
    for (int i = 0 ; i<_numArray.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1] forState:UIControlStateNormal];
        button.frame = CGRectMake(i*((ScreenWidth-40-60)/4), 8, ((ScreenWidth-40-60)/4)+1, _tradeNumView.bounds.size.height/5*3);
        [button setTitle:[NSString stringWithFormat:@"%d手",[_numArray[i] intValue]] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        button.backgroundColor = [UIColor clearColor];
        if (i==num) {
            button.backgroundColor = Color_Gold;
            [button setTitleColor:Color_black forState:UIControlStateNormal];
        }
        button.tag = i+777;
        [button addTarget:self action:@selector(chooseNum:) forControlEvents:UIControlEventTouchUpInside];
        [_tradeNumView addSubview:button];
    }
    return _tradeNumView;
}

-(void)chooseNum:(UIButton *)button{
    
    BOOL    canUse = NO;
    
    for (int i = 0; i<4; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:777+i];
        if ([btn.backgroundColor isEqual:Color_Gold]) {
            canUse = YES;
        }
    }
    
    //是否被快速下单冻结
    if (canUse) {
        for (int i = 0; i<4; i++) {
            UIButton *btn = (UIButton *)[self.view viewWithTag:777+i];
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        button.backgroundColor = Color_Gold;
        [button setTitleColor:Color_black forState:UIControlStateNormal];
        
        selectNum = (int)button.tag - 777;
        
        if(!isFirstStatus){
            [self reloadAllData];
        }else{
            [self segClickReloadData];
        }
        
        //保存选中手数
        if (self.isQuickOrder) {
            CacheModel *cacheModel = [CacheEngine getCacheInfo];
            cacheModel.tradeDic[self.productModel.tradeSubDicName][@"numfloat"] = [NSString stringWithFormat:@"%d",selectNum];
            [CacheEngine setCacheInfo:cacheModel];
            //优惠配置
            [self quickOrderConfigerOfFourLabel];
        }
    }
}

#pragma mark 看多/看空 买入

-(void)loadBottomButton{
    self.bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bottomBtn.frame = CGRectMake(20, ScreenHeigth-80.0/667*ScreenHeigth, ScreenWidth-40, 40.0/667*ScreenHeigth);
    if (!self.canUse) {
        [self.bottomBtn setTitle:@"已闭市" forState:UIControlStateNormal];
        self.bottomBtn.backgroundColor = [UIColor grayColor];
    }
    else{
        if (self.buyState == 0) {
            [self.bottomBtn setTitle:@"看多买入" forState:UIControlStateNormal];
            [self.bottomBtn setBackgroundImage:[UIImage imageNamed:Image_Color_Red] forState:UIControlStateNormal];
            self.bottomBtn.backgroundColor = Color_red;
        }
        else{
            [self.bottomBtn setTitle:@"看空买入" forState:UIControlStateNormal];
            [self.bottomBtn setBackgroundImage:[UIImage imageNamed:Image_Color_Green] forState:UIControlStateNormal];
            self.bottomBtn.backgroundColor = Color_green;
        }
    }
    [self.bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.bottomBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.bottomBtn.clipsToBounds = YES;
    self.bottomBtn.layer.cornerRadius = 3;
    self.bottomBtn.tag = Tag_bottomButton;
    [self.bottomBtn addTarget:self action:@selector(bottomClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomBtn];
    
    [self loadAgreement:self.bottomBtn];
}

-(void)bottomClick:(UIButton *)btn{
    if (![btn.backgroundColor isEqual:[UIColor grayColor]]) {
        
        if ([_twoLabel.text rangeOfString:@"选择"].location != NSNotFound || [_oneLabel.text rangeOfString:@"选择"].location != NSNotFound) {
            [[UIEngine sharedInstance] showAlertWithTitle:@"首次下单需要选择止损、止盈额度 \n下次将会记住您的选择" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
            [UIEngine sharedInstance].alertClick = ^(int aIndex){};
        }
        else{
            [self getSystemDate];
        }
    }
}

-(NSString *)toJSON:(id)aParam
{
    NSData   *jsonData=[NSJSONSerialization dataWithJSONObject:aParam options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

#pragma mark - 查询订单交易状态

//查询订单交易状态r
- (void)searchOrderStork:(NSString *)idArray
{
    if (_timer == nil) {
        return;
    }else{
        int fundType = 0;
        if (![self.productModel.loddyType isEqualToString:@"1"]) {
            fundType = 1;
        }
        
        NSDictionary *dic = @{
                              @"futuredOrderIdsStr" : idArray,
                              @"version" : VERSION ,
                              @"token" : [[CMStoreManager sharedInstance] getUserToken],
                              @"fundType":[NSNumber numberWithInt:fundType],
                              };
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/order/futures/orderStatus", K_MGLASS_URL];
        
        [NetRequest postRequestWithNSDictionary:dic
                                            url:urlStr
                                   successBlock:^(NSDictionary *dictionary) {
                                       
               if ([dictionary[@"code"] intValue] == 200) {
                   
                   //                                   data:
                   //                                       -2：买入失败
                   //                                       0：买待处理，创建订单默认状态
                   //                                       1：买处理中
                   //                                       2：买委托成功，即申报成功
                   //                                       3：持仓中
                   //                                       4：卖处理中
                   //                                       5：卖委托成功，即申报成功
                   //                                       6：卖出成功
                   
                   int count = 0;
                   for (int i = 0; i < [dictionary[@"data"] count]; i++) {
                       if ([dictionary[@"data"][i][@"status"] floatValue] == 2 || [dictionary[@"data"][i][@"status"] floatValue] == 3) {
                           [_timer invalidate];
                           _timer = nil;
                           [[UIEngine sharedInstance] hideProgress];
                           
                           /**
                            *  下单成功刷新持仓收益
                            */
                           [[NSNotificationCenter defaultCenter] postNotificationName:kOrderSuccess object:nil];
                           
                           [[UIEngine sharedInstance] showAlertWithTitle:@"已申报成功" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
                           [UIEngine sharedInstance].alertClick = ^(int aIndex){
                               [[NSNotificationCenter defaultCenter] postNotificationName:kSegValueChange object:nil];
                               UIViewController *viewController = nil;
                               for (UIViewController *indexViewController in self.navigationController.viewControllers) {
                                   if ([indexViewController isKindOfClass:[IndexViewController class]]) {
                                       viewController = indexViewController;
                                   }
                               }
                               [self.navigationController popToViewController:viewController animated:YES];
                           };
                           break;
                       }
                       else if([dictionary[@"data"][i][@"status"] floatValue] == 0 || [dictionary[@"data"][i][@"status"] floatValue] == 1){
                           count ++;
                           if (count == [dictionary[@"data"] count]) {
                               [self searchOrderStork:idArray];
                           }
                       }
                       else{
                           
                           [_timer invalidate];
                           _timer = nil;
                           [[UIEngine sharedInstance] hideProgress];
                           
                           [[UIEngine sharedInstance] showAlertWithTitle:@"申报失败" ButtonNumber:2 FirstButtonTitle:@"返回大厅" SecondButtonTitle:@"确定"];
                           [UIEngine sharedInstance].alertClick = ^(int aIndex){
                               if (aIndex == 10086) {
                                    [self closeSocket];
                                   if (isOpenQuick) {
                                       self.backBlock();
                                   }
                                   else{
                                       [self.navigationController popToRootViewControllerAnimated:YES];
                                   }
                               }
                           };
                           
                           
                       }
                   }
                   
               }
               else{
                   [self searchOrderStork:idArray];
               }
               
           }
           failureBlock:^(NSError *error){
               [self searchOrderStork:idArray];
               
           }];
        }
}

//加“,”
//-(NSString *)addSign:(NSString *)aStr
//{
//    NSString *point=[aStr substringFromIndex:aStr.length-3];
//    
//    NSString *money=[aStr substringToIndex:aStr.length-3];
//    
//    return [[DataEngine countNumAndChangeformat:money] stringByAppendingString:point];
//}

-(void)afterTime{
    
    time ++;
    if (time > 5) {
        
        [_timer invalidate];
        _timer = nil;
        [[UIEngine sharedInstance] hideProgress];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        if(!isOpenQuick){
            [self closeSocket];
        }
        else{
            self.backBlock();
        }
    }
}

-(void)closeSocket{
    //断开行情socket
    [[NSNotificationCenter defaultCenter] postNotificationName:kCloseConnection object:nil];
}

//系统时间

-(void)getSystemDate
{
    [UIEngine sharedInstance].progressStyle = 2;
    [[UIEngine sharedInstance] showProgress];
    [DataEngine requestToGetSystemDateWithComplete:^(BOOL SUCCESS, NSString *data , NSString *timeInterval) {
        if (SUCCESS) {
            _systemTime = data;
        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            
            _systemTime = [dateFormatter stringFromDate:[NSDate date]];
        }
        
        
        
        TradeConfigerModel *tradeModel;
        if (isIntegral) {
            if (chooseStopNum == 0) {
                tradeModel = _integralTrade;
            }
        }
        else{
            if (chooseStopNum == 0) {
                tradeModel = _moneyTrade;
            }
        }
//        NSNumber *count = [NSNumber numberWithInt:1];
//        if (selectNum >=0 && selectNum <= 3) {
//            count = _numArray[selectNum];
//        }
        NSString *tradeID = @"";
        if (tradeModel == nil || [tradeModel isKindOfClass:[NSNull class]]) {
            tradeID = @"0";
        }
        else{
            tradeID = tradeModel.tradeID;
        }
        
        NSDictionary *dic = [NSDictionary dictionary];
        //判断是否有选择使用优惠券。如果使用了。就新增加一个字段。
        if (isCouPonSelect == YES)
        {
            dic = @{
                    @"tradeType": [NSNumber numberWithInt:self.buyState], //看多看空
                    @"userBuyDate": _systemTime,              //购买时间
                    @"userBuyPrice": _indexBuyModel.currentPrice, //价格
                    
                    @"rate":[NSNumber numberWithDouble:[tradeModel.rate doubleValue]],
                    @"futuresCode": _indexBuyModel.code,      //代码
                    @"count": _numArray[selectNum],            //手数
                    @"traderId": tradeID,                 //配资ID
                    @"stopProfit":[tradeModel.maxProfit componentsSeparatedByString:@","][selectGet],//止盈金额
                    @"couponIds":couPonIDArray,
                    };

        }else
        {
            dic = @{
                    @"tradeType": [NSNumber numberWithInt:self.buyState], //看多看空
                    @"userBuyDate": _systemTime,              //购买时间
                    @"userBuyPrice": _indexBuyModel.currentPrice, //价格
                    
                    @"rate":[NSNumber numberWithDouble:[tradeModel.rate doubleValue]],
                    @"futuresCode": _indexBuyModel.code,      //代码
                    @"count": _numArray[selectNum],            //手数
                    @"traderId": tradeID,                 //配资ID
                    @"stopProfit":[tradeModel.maxProfit componentsSeparatedByString:@","][selectGet],//止盈金额
                    };
        }
         [self orderBegin:dic];
        
        dic = nil;
    }];
}

//闪电下单保存数据
//打开
-(void)quickOrderData:(NSString *)isQuikKeepCoupon{
    TradeConfigerModel *tradeModel;
    if (isIntegral) {
        if (chooseStopNum == 0) {
            tradeModel = _integralTrade;
        }
    }
    else{
        if (chooseStopNum == 0) {
            tradeModel = _moneyTrade;
        }
    }
    NSString *tradeID = @"";
    if (tradeModel == nil || [tradeModel isKindOfClass:[NSNull class]]) {
        tradeID = @"0";
    }
    else{
        tradeID = tradeModel.tradeID;
    }
    NSDictionary *dic = @{
                          @"rate":[NSNumber numberWithDouble:[tradeModel.rate doubleValue]],
                          @"count": _numArray[selectNum],            //手数
                          @"traderId": tradeID,                 //配资ID
                          @"stopProfit":[tradeModel.maxProfit componentsSeparatedByString:@","][selectGet],//止盈金额
                          };
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dataDic setValue:isQuikKeepCoupon forKey:@"isQuickCouponStatus"];
    
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    cacheModel.tradeDic[_tradeDicName][kOrderQuickDic] = [NSMutableDictionary dictionaryWithDictionary:dataDic];
    cacheModel.tradeDic[_tradeDicName][kOrderQuickIsOpen] = @"YES";
    [CacheEngine setCacheInfo:cacheModel];
    
    
}
//关闭
-(void)quickOrderClose
{
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    cacheModel.tradeDic[_tradeDicName][kOrderQuickIsOpen] = @"NO";
    [CacheEngine setCacheInfo:cacheModel];
}

-(void)orderBegin:(NSDictionary *)aPramDic{
    
    orderPramDic = [NSDictionary dictionaryWithDictionary:aPramDic];
    
    _tradeDicName = self.productModel.tradeDicName;
    
    if (oldTimeInterval == 0 || (long long)oldTimeInterval != [SystemSingleton sharedInstance].timeInterval) {
        oldTimeInterval = [SystemSingleton sharedInstance].timeInterval;
    }
    else{
        return;
    }
    
    
    isOpenQuick = NO;
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    if (cacheModel.tradeDic[_tradeDicName][kOrderQuickIsOpen] == nil || [cacheModel.tradeDic[_tradeDicName][kOrderQuickIsOpen] isKindOfClass:[NSNull class]] || [cacheModel.tradeDic[_tradeDicName][kOrderQuickIsOpen] isEqualToString:@"NO"]) {
        isOpenQuick = NO;
    }
    else if ([cacheModel.tradeDic[_tradeDicName][kOrderQuickIsOpen] isEqualToString:@"YES"]){
        isOpenQuick = YES;
    }
    else{
        isOpenQuick = NO;
    }
    
    //未打开闪电下单 或 合约状态可售
    if (!isOpenQuick || self.canUse) {
        [self orderGo:orderPramDic];
    }
    else{
        [self getMarketEndTime];
    }
}

-(void)orderGo:(NSDictionary *)aPramDic{
    NSString *jsonStr = [self toJSON:aPramDic];
    NSDictionary *jsonDic = @{
                              @"orderData" : jsonStr,
                              @"version" : @"0.0.3" ,
                              @"token" : [[CMStoreManager sharedInstance] getUserToken]
                              };
    [DataEngine requestToBuy:jsonDic completeBlock:^(BOOL SUCCESS, NSDictionary *dictionary) {
        if (SUCCESS) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(afterTime) userInfo:nil repeats:YES];
            [self searchOrderStork:dictionary[@"data"][@"futuredOrderIdsStr"]];
        }
        //抱歉，目前暂不支持现金交易！  注：在现金大厅不会出现
        else if ([dictionary[@"code"] intValue] == 49999 || [dictionary[@"code"] intValue] == 49997){
            if (isOpenQuick) {
                [[UIEngine sharedInstance] showAlertWithTitle:@"抱歉，目前暂不支持现金交易！" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
                [UIEngine sharedInstance].alertClick = ^(int aIndex){
                    self.cantTradeBlock();
                    [[UIEngine sharedInstance] hideProgress];
                };
            }
            else{
                [[UIEngine sharedInstance] showAlertWithTitle:@"抱歉，目前暂不支持现金交易！" ButtonNumber:2 FirstButtonTitle:@"确定" SecondButtonTitle:@"返回"];
                [UIEngine sharedInstance].alertClick = ^(int aIndex){
                    if (aIndex == 10087) {
                        [self backClick];
                    }
                    [[UIEngine sharedInstance] hideProgress];
                };
            }
        }
        //余额不足
        else if([dictionary[@"code"] intValue] == 44007){
            
            if (isOpenQuick) {
                [[UIEngine sharedInstance] showAlertWithTitle:@"您当前现金余额不足，请先充值" ButtonNumber:2 FirstButtonTitle:@"取消" SecondButtonTitle:@"充值"];
                [UIEngine sharedInstance].alertClick = ^(int aIndex){
                    if (aIndex == 10086) {
                        
                    }
                    if (aIndex == 10087) {
                        //                        [self closeSocket];
                        self.accountBlock();
                    }
                };
            }
            else{
                if (isIntegral == 0) {
                    [[UIEngine sharedInstance] showAlertWithTitle:@"您当前现金余额不足，请先充值" ButtonNumber:2 FirstButtonTitle:@"返回" SecondButtonTitle:@"充值"];
                    [UIEngine sharedInstance].alertClick = ^(int aIndex){
                        if (aIndex == 10086) {
                            [self backClick];
                        }
                        if (aIndex == 10087) {
                            [self getAccountMoney];
                        }
                    };
                }
                else{
                    [[UIEngine sharedInstance] showAlertWithTitle:@"您当前积分余额不足，无法买入" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
                    [UIEngine sharedInstance].alertClick = ^(int aIndex){
                        
                    };
                }
            }            
            [[UIEngine sharedInstance] hideProgress];
        }
        else if([dictionary[@"code"] intValue] == 44026){
            //44026 涨跌幅过滤
            [[UIEngine sharedInstance] showAlertWithTitle:@"申报失败，涨跌幅过滤" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
            [UIEngine sharedInstance].alertClick = ^(int aIndex){
                
            };
            [[UIEngine sharedInstance] hideProgress];
        }
        //用户提交买入价格为0或空、行情波动大于等于4个点
        else if ([dictionary[@"code"] intValue] == 44031 || [dictionary[@"code"] intValue] == 44032){
            if (dictionary[@"msg"] != nil && ![dictionary[@"msg"] isKindOfClass:[NSNull class]]) {
                NSArray *messageInfo = [dictionary[@"msg"] componentsSeparatedByString:@"|"];
                if (messageInfo.count > 1) {
                    [[UIEngine sharedInstance] showAlertWithOrderWithTitle:messageInfo[0] Message:messageInfo[1]];
                    [UIEngine sharedInstance].alertClick = ^(int aIndex){};
                }
            }
            [[UIEngine sharedInstance] hideProgress];
        }
        else {
            NSString *msg = @"";
            if (dictionary == nil || dictionary[@"msg"] == nil) {
                msg = @"申报失败";
            }
            else{
                msg = dictionary[@"msg"];
            }
            [[UIEngine sharedInstance] showAlertWithTitle:[DataUsedEngine nullTrimString:msg] ButtonNumber:2 FirstButtonTitle:@"返回大厅" SecondButtonTitle:@"确定"];
            [UIEngine sharedInstance].alertClick = ^(int aIndex){
                if (aIndex == 10086) {
                    [self closeSocket];
                    
                    if (isOpenQuick) {
                        self.backBlock();
                    }
                    else{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }
            };
            [[UIEngine sharedInstance] hideProgress];
        }
    }];
}

-(void)changeBottomButton{
    UIButton    *bottomBtn = (UIButton *)[self.view viewWithTag:Tag_bottomButton];
    
    UIButton    *agreeBtn = (UIButton *)[self.view viewWithTag:Tag_agreeButton];
    
    if (agreeBtn.selected) {
        if (!self.canUse) {
            [bottomBtn setTitle:@"已闭市" forState:UIControlStateNormal];
            bottomBtn.backgroundColor = [UIColor grayColor];
            [bottomBtn setBackgroundImage:[UIImage imageNamed:Image_Color_Gray] forState:UIControlStateNormal];
            bottomBtn.enabled = NO;
        }
        else{
            if (self.buyState == 0) {
                [bottomBtn setTitle:@"看多买入" forState:UIControlStateNormal];
                bottomBtn.backgroundColor = CanSelectButBackColor;
                [bottomBtn setBackgroundImage:[UIImage imageNamed:Image_Color_Red] forState:UIControlStateNormal];
            }
            else{
                [bottomBtn setTitle:@"看空买入" forState:UIControlStateNormal];
                bottomBtn.backgroundColor = Color_green;
                [bottomBtn setBackgroundImage:[UIImage imageNamed:Image_Color_Green] forState:UIControlStateNormal];
            }
            bottomBtn.enabled = YES;
        }
    }
    else{
        if (!self.canUse) {
            [bottomBtn setTitle:@"已闭市" forState:UIControlStateNormal];
        }
        else{
            if (self.buyState == 0) {
                [bottomBtn setTitle:@"看多买入" forState:UIControlStateNormal];
            }
            else{
                [bottomBtn setTitle:@"看空买入" forState:UIControlStateNormal];
            }
        }
        bottomBtn.backgroundColor = [UIColor grayColor];
        [bottomBtn setBackgroundImage:[UIImage imageNamed:Image_Color_Gray] forState:UIControlStateNormal];
        bottomBtn.enabled = NO;
    }
}

#pragma mark 去充值

-(void)getAccountMoney{
    AccountH5Page *accountH5Page = [[AccountH5Page alloc]init];
    accountH5Page.url = [NSString stringWithFormat:@"http://%@/account/banks.html?type=original",HTTP_IP];
    [self.navigationController pushViewController:accountH5Page animated:YES];
}


#pragma mark 同意协议

-(void)loadAgreement:(UIButton *)btn{
    UILabel *agreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-120, btn.frame.size.height+btn.frame.origin.y+8, 240, 16)];
    agreeLabel.text = [NSString stringWithFormat:@"我已阅读并同意《投资人与用户交易合作协议》"];
    agreeLabel.font = [UIFont systemFontOfSize:11];
    agreeLabel.center = CGPointMake(agreeLabel.center.x+20, agreeLabel.center.y);
    agreeLabel.textColor = [UIColor lightGrayColor];
    
    agreeLabel.attributedText = [Helper multiplicityText:agreeLabel.text from:7 to:(int)agreeLabel.text.length-7 color:Color_Gold];;
    [self.view addSubview:agreeLabel];
    UIButton *agreeInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeInfoBtn.frame = agreeLabel.frame;
    [agreeInfoBtn setBackgroundColor:[UIColor clearColor]];
    [agreeInfoBtn addTarget:self action:@selector(lookRule) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreeInfoBtn];
    
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeBtn.frame = CGRectMake(agreeLabel.frame.origin.x-20+2, agreeLabel.frame.origin.y+2, 12, 12);
    [agreeBtn setImage:[UIImage imageNamed:@"button_10"] forState:UIControlStateNormal];
    [agreeBtn setImage:[UIImage imageNamed:@"button_09_1"] forState:UIControlStateSelected];
    agreeBtn.selected = YES;
    agreeBtn.tag = Tag_agreeButton;
    [agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreeBtn];
}

-(void)lookRule{
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    
    detailVC.isUseCustomURL = YES;
    detailVC.customURL = [NSString stringWithFormat:@"http://%@/rule/rule_transaction.html",HTTP_IP];
    detailVC.otherTitle = [NSString stringWithFormat:@"%@协议",App_appShortName];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)agreeBtnClick:(UIButton *)btn{
    if (btn.selected) {
        btn.selected = NO;
    }
    else{
        btn.selected = YES;
    }
    
    [self changeBottomButton];
}

#pragma mark - 点击勾选优惠券
- (void)clickCouPonAction:(UIButton *)sender
{
    
    if ([self.couPonBtn isSelected]) {
        //选中
        [self.couPonBtn setImage:[UIImage imageNamed:@"coupon_00"] forState:UIControlStateNormal];
        [self.couPonBtn setSelected:NO];
        isCouPonSelect = YES;
        
        self.isOrderQuickCouPon = @"YES";
        self.isAutoBtn = @"YES";
    }else{
        //未选中
        [self.couPonBtn setImage:[UIImage imageNamed:@"coupon_01"] forState:UIControlStateNormal];
        [self.couPonBtn setSelected:YES];
        isCouPonSelect = NO;
        
        self.isOrderQuickCouPon = @"NO";
        self.isAutoBtn = @"NO";
    }
    if (self.isQuickOrder) {//快速下单
        _couPonLab.text = @"自动抵扣";
        [self quickOrderConfigerOfFourLabel];
    }else//非快速下单
    {
        if ([_oneLabel.text rangeOfString:@"请选择"].location == NSNotFound && [_twoLabel.text rangeOfString:@"请选择"].location == NSNotFound) {
            [self reloadAllData];
        }
        else if(!isIntegral){
            NSString    *behindStr = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[_tradeModel.counterFee doubleValue] * [_numArray[selectNum] intValue]]];
            UILabel *fourLabel = [_couPonView viewWithTag:Tag_fourLine];
            //无优惠
            if ([self.couPonBtn isSelected]) {
                if (_tradeModel.rate != nil && [_tradeModel.rate floatValue] != 1) {
                    NSString    *fourMoneyOfRate = [NSString stringWithFormat:@"%@",[DataEngine addSign:[NSString stringWithFormat:@"%.2f",[_tradeModel.counterFee doubleValue] * [_numArray[selectNum] intValue] * [_tradeModel.rate floatValue]]]];
                    NSString    *fourMoney  = [NSString stringWithFormat:@"%@ %@",self.productModel.currencySign,behindStr];
                    fourLabel.text = [NSString stringWithFormat:@"￥ %@\n (%@)",fourMoneyOfRate,fourMoney];
                    fourLabel.attributedText = [DataUsedEngine mutableFontArray:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"￥ %@\n ",fourMoneyOfRate],[NSString stringWithFormat:@"(%@)",fourMoney], nil] fontArray:[NSMutableArray arrayWithObjects:[self get4sFontSize],@"11", nil]];
                }
                else{
                    fourLabel.text = [NSString stringWithFormat:@"%@%@",self.productModel.currencySign,behindStr];
                }
                
                _preferentialLabel.hidden = YES;
            }
            //有优惠
            else{
                NSString    *frontStr = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[_tradeModel.counterFee doubleValue] * [_numArray[selectNum] intValue] - sunCoupon / [_tradeModel.rate floatValue]]];
                NSString    *behindStr = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[_tradeModel.counterFee doubleValue] * [_numArray[selectNum] intValue]]];
                fourLabel.text = [NSString stringWithFormat:@"%@%@ %@%@",self.productModel.currencySign,behindStr,self.productModel.currencySign,frontStr];
                fourLabel.attributedText = [self multiplicityActivity:fourLabel.text from:0 to:(int)(behindStr.length+self.productModel.currencySign.length) color:[UIColor lightGrayColor] otherFontWithFrom:0 to:0 SecondOtherFontWithFrom:0 to:0];
                _preferentialLabel.hidden = NO;
            }
        }
        
        //选中状态下点击
        if (isCouPonSelect) {
            _couPonLab.text = [NSString stringWithFormat:@"使用%ld张￥-%.1f",(long)useCouPonNum,sunCoupon];
        }
        else{
            _couPonLab.text = [NSString stringWithFormat:@"未使用"];
        }
        
        if (isCouPonSelect) {
            //交易综合费
            UILabel *fourLabel = (UILabel *)[_couPonView viewWithTag:Tag_fourLine];
            [self discountAndFourLabelConfiger:fourLabel];
        }
        
        [self reloadCouPonData];
    }
    
}

-(void)quickOrderConfigerOfFourLabel{
    NSString    *behindStr = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[_tradeModel.counterFee doubleValue] * [_numArray[selectNum] intValue]]];
    UILabel *fourLabel = [_couPonView viewWithTag:Tag_fourLine];
    if (isIntegral) {
        behindStr = [DataEngine addSign:[NSString stringWithFormat:@"%.0f",[_tradeModel.counterFee doubleValue] * [_numArray[selectNum] intValue]] pointNum:0];
        if (_tradeModel.rate != nil && [_tradeModel.rate floatValue] != 1) {
            NSString    *money = [DataEngine addSign:[NSString stringWithFormat:@"%.0f",([_tradeModel.rate floatValue] * [_tradeModel.counterFee doubleValue] * ([_numArray[selectNum] intValue]))] pointNum:0];
            fourLabel.text = [NSString stringWithFormat:@"￥ %@积分\n (%@ %@积分)",money,self.productModel.currencySign,behindStr];
            fourLabel.attributedText = [DataUsedEngine mutableFontArray:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"￥ %@",money],@"积分\n",[NSString stringWithFormat:@" (%@ %@",self.productModel.currencySign,behindStr],@"积分",@")", nil] fontArray:[NSMutableArray arrayWithObjects: [self get4sFontSize],@"11",@"11",@"8",@"11", nil]];
        }
        else{
            fourLabel.text = [NSString stringWithFormat:@"￥ %@积分",behindStr];
            fourLabel.attributedText = [DataUsedEngine mutableFontArray:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"￥ %@",behindStr],@"积分", nil] fontArray:[NSMutableArray arrayWithObjects:[self get4sFontSize],@"11",nil]];
        }
    }
    else{
        behindStr = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[_tradeModel.counterFee doubleValue] * [_numArray[selectNum] intValue]]];
        if (_tradeModel.rate != nil && [_tradeModel.rate floatValue] != 1) {
            NSString    *fourMoneyOfRate = [NSString stringWithFormat:@"%@",[DataEngine addSign:[NSString stringWithFormat:@"%.2f",[_tradeModel.counterFee doubleValue] * [_numArray[selectNum] intValue] * [_tradeModel.rate floatValue]]]];
            NSString    *fourMoney  = [NSString stringWithFormat:@"%@ %@",self.productModel.currencySign,behindStr];
            fourLabel.text = [NSString stringWithFormat:@"￥ %@\n (%@)",fourMoneyOfRate,fourMoney];
            fourLabel.attributedText = [DataUsedEngine mutableFontArray:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"￥ %@\n ",fourMoneyOfRate],[NSString stringWithFormat:@"(%@)",fourMoney], nil] fontArray:[NSMutableArray arrayWithObjects:[self get4sFontSize],@"11", nil]];
        }else{
            fourLabel.text = [NSString stringWithFormat:@"%@ %@",self.productModel.currencySign,behindStr];
        }
        
    }
    _preferentialLabel.hidden = YES;
    behindStr = nil;
}

-(NSMutableAttributedString *)multiplicityActivity:(NSString *)aStr from:(int)aFrom to:(int)aTo color:(UIColor *)aColor otherFontWithFrom:(int)aOtherFrrm to:(int)aOtherTo SecondOtherFontWithFrom:(int)aSecondFrom to:(int)aSecondTo
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:aStr];
    
    [str addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(aFrom, aTo)];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(aFrom,aTo)];
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:11] range:NSMakeRange(aOtherFrrm, aOtherTo)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:11] range:NSMakeRange(aSecondFrom, aSecondTo)];
    
    return str;
}

#pragma mark - 点击屏幕任意地方键盘消失
- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark 条件单选择选项

-(void)loadSeg{
    _seg = [[UISegmentedControl alloc]initWithItems:@[@"市价",@"条件单"]];
    if (ScreenHeigth <= 480) {
        _seg.frame = CGRectMake(ScreenWidth/2-ScreenWidth/5*2/2-10, 60, ScreenWidth/5*2+20, 32.0/667*ScreenHeigth);
    }
    else{
        _seg.frame = CGRectMake(ScreenWidth/2-ScreenWidth/5*2/2-10, 64+5, ScreenWidth/5*2+20, 32.0/667*ScreenHeigth);
    }
    _seg.selectedSegmentIndex = 0;
    [_seg addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventValueChanged];
    _seg.tintColor = [UIColor colorWithRed:234/255.0 green:194/255.0 blue:129/255.0 alpha:1];
    [self.view addSubview:_seg];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Helvetica" size:10],NSFontAttributeName,nil];
    [_seg setTitleTextAttributes:dic forState:UIControlStateNormal];
}

-(void)segClick:(UISegmentedControl *)seg{
    seg.selectedSegmentIndex = 0;
    [[UIEngine sharedInstance] showAlertWithTitle:@"敬请期待" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
    [UIEngine sharedInstance].alertClick = ^(int aIndex){
        
    };
    
//    [self.chooseBGView removeFromSuperview];
//    self.chooseBGView = nil;
//    UIView  *rateView = [self.view viewWithTag:Tag_rateview];
//    if (seg.selectedSegmentIndex == 1) {
//        
//        [self loadChooseStopAndGetUI];//条件单止损止盈
//        
//        //汇率选项
//        if (rateView != nil) {
//            rateView.frame = CGRectMake(20, self.chooseBGView.frame.origin.y + self.chooseBGView.frame.size.height, ScreenWidth, rateView.frame.size.height);
//            self.couPonView.frame = CGRectMake(0, rateView.frame.origin.y + rateView.frame.size.height, ScreenWidth, self.couPonView.frame.size.height);
//        }
//        else{
//            self.couPonView.frame = CGRectMake(0, self.chooseBGView.frame.origin.y + self.chooseBGView.frame.size.height, ScreenWidth, self.couPonView.frame.size.height);
//        }
//        
//        //底部按钮
//        if (self.buyState == 0) {
//            [self.bottomBtn setTitle:@"确认委托（看多）" forState:UIControlStateNormal];
//            [self.bottomBtn setBackgroundImage:[UIImage imageNamed:Image_Color_Red] forState:UIControlStateNormal];
//            self.bottomBtn.backgroundColor = Color_red;
//        }
//        else{
//            [self.bottomBtn setTitle:@"确认委托（看空）" forState:UIControlStateNormal];
//            [self.bottomBtn setBackgroundImage:[UIImage imageNamed:Image_Color_Green] forState:UIControlStateNormal];
//            self.bottomBtn.backgroundColor = Color_green;
//        }
//        
//        /**
//         *  显示提示语
//         */
//        _timeSignLabel.hidden = NO;
//        _timeProLabel.hidden = NO;
//    }
//    else{
//        [self loadStopAndGetUI];//加载止损止盈
//        [self tradeConfiger];
//        //汇率选项
//        if (rateView != nil) {
//            rateView.frame = CGRectMake(20, self.otherMoneyFrontHeight, ScreenWidth - 40, rateView.frame.size.height);
//            self.couPonView.frame = CGRectMake(0, rateView.frame.origin.y + rateView.frame.size.height, ScreenWidth, self.couPonView.frame.size.height);
//        }
//        else{
//            self.couPonView.frame = CGRectMake(0, self.otherMoneyFrontHeight, ScreenWidth, self.couPonView.frame.size.height);
//        }
//        self.couPonView.frame = CGRectMake(0, CGRectGetMaxY(self.chooseBGView.frame), ScreenWidth, self.couPonView.frame.size.height);
//        
//        //底部按钮
//        if (self.buyState == 0) {
//            [self.bottomBtn setTitle:@"看多买入" forState:UIControlStateNormal];
//            [self.bottomBtn setBackgroundImage:[UIImage imageNamed:Image_Color_Red] forState:UIControlStateNormal];
//            self.bottomBtn.backgroundColor = Color_red;
//        }
//        else{
//            [self.bottomBtn setTitle:@"看空买入" forState:UIControlStateNormal];
//            [self.bottomBtn setBackgroundImage:[UIImage imageNamed:Image_Color_Green] forState:UIControlStateNormal];
//            self.bottomBtn.backgroundColor = Color_green;
//        }
//        
//        /**
//         *  显示提示语
//         */
//        _timeSignLabel.hidden = YES;
//        _timeProLabel.hidden = YES;
//    }
//    
//    [self reloadOfStopPriceOrGetPrice];//刷新参考止损止盈价格
}

-(void)loadChooseStopAndGetUI{
    //BGView
    self.chooseBGView = [[UIView alloc]initWithFrame:CGRectMake(0, self.stopAndGetFrontHeight/568*ScreenHeigth, ScreenWidth, 4*(40.0/568*ScreenHeigth))];
    [self.view addSubview:self.chooseBGView];
    
    NSArray *titleArray = @[@"委托条件",@"设置手数",@"触发止损",@"触发止盈"];
    NSArray *detailArray = @[@"满足条件市价下单",@"可买1-20手",@"参考价格--",@"参考价格--"];
    
    for (int i = 0; i < 4; i++) {
        
        UIView  *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, i*(40.0/568*ScreenHeigth), ScreenWidth, (40.0/568*ScreenHeigth))];
        [self.chooseBGView addSubview:bgView];
        
        //40.0/568*ScreenHeigth
        //Label
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 2, ScreenWidth/3, (25.0/568*ScreenHeigth))];
        titleLabel.text = titleArray[i];
        titleLabel.textColor = Color_gray;
        titleLabel.font = [UIFont systemFontOfSize:13];
        [bgView addSubview:titleLabel];
        
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, (25.0/568*ScreenHeigth), ScreenWidth/3, (10.0/568*ScreenHeigth))];
        detailLabel.text = detailArray[i];
        detailLabel.textColor = Color_Gold;
        detailLabel.font = [UIFont systemFontOfSize:9];
        [bgView addSubview:detailLabel];
        if (i == 2) {
            detailLabel.tag = Tag_chooseStop;
        }
        else if(i == 3){
            detailLabel.tag = Tag_chooseGet;
        }
        
        if (i == 0) {
            IndexOrderChooseButton *chooseBtn = [[IndexOrderChooseButton alloc]initWithFrame:CGRectMake(ScreenWidth - (ScreenWidth/3*2 - 80) - 20, (8.0/568*ScreenHeigth), ScreenWidth/3*2 - 80, bgView.frame.size.height-(15.0/568*ScreenHeigth))];
            chooseBtn.clipsToBounds = YES;
            chooseBtn.layer.cornerRadius = 3;
            chooseBtn.indexOrderChooseButtonBlock = ^(){
                [self orderChooseButtonClick];
            };
            [bgView addSubview:chooseBtn];
        }
        else{
            IndexOrderChooseView *chooseView = [[IndexOrderChooseView alloc]initWithFrame:CGRectMake(ScreenWidth - (ScreenWidth/3*2 - 80) - 20, (8.0/568*ScreenHeigth), ScreenWidth/3*2 - 80, bgView.frame.size.height-(15.0/568*ScreenHeigth))];
            chooseView.clipsToBounds = YES;
            chooseView.layer.cornerRadius = 3;
            chooseView.layer.borderColor = Color_gray.CGColor;
            chooseView.layer.borderWidth = 1;
            [bgView addSubview:chooseView];
            chooseView.textField.keyboardType = UIKeyboardTypeNumberPad;
            switch (i) {
                case 1:
                    chooseView.tag = Tag_orderChooseNumView;
                    break;
                case 2:
                    chooseView.tag = Tag_orderChooseStopView;
                    chooseView.textField.text = _chooseBillModel.chooseStopMoney;
                    chooseView.jump = [_chooseDataModel.jump intValue];
                    break;
                case 3:
                    chooseView.tag = Tag_orderChooseGetView;
                    chooseView.textField.text = _chooseBillModel.chooseGetMoney;
                    chooseView.jump = [_chooseDataModel.jump intValue];
                    break;
                default:
                    break;
            }
            chooseView.minusBlock = ^(IndexOrderChooseView *aChooseView){
                [self minusBlock:aChooseView];
            };
            chooseView.plusBlock = ^(IndexOrderChooseView *aChooseView){
                [self plusBlock:aChooseView];
            };
            chooseView.editEndBlock = ^(IndexOrderChooseView *aChooseView){
                [self editEndBlock:aChooseView];
            };
            [chooseView.textField addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventValueChanged];
        }
        
    }
}
//条件单选项减
-(void)minusBlock:(IndexOrderChooseView *)aChooseView{
    
    if (aChooseView.tag == Tag_orderChooseNumView) {
        if ([aChooseView.textField.text floatValue] < 1) {//不少于1手
            aChooseView.textField.text = @"1";
            [UIEngine showShadowPrompt:@"最少手数为1手"];
        }
        _chooseBillModel.chooseNum = aChooseView.textField.text;//手数改变
        [self changeChooseNum];//手数改变计算止盈止损
    }
    else if (aChooseView.tag == Tag_orderChooseStopView){
        if ([aChooseView.textField.text floatValue] < [_chooseDataModel.minStopMoney floatValue] ) {//最低止损金额 * 手数
            aChooseView.textField.text = [NSString stringWithFormat:@"%d",[_chooseDataModel.minStopMoney intValue]];
        }
        [self changeDataAndReloadReferencePrice:aChooseView];//刷新参考止损、止盈价格
    }
    else if (aChooseView.tag == Tag_orderChooseGetView){
        if ([aChooseView.textField.text floatValue] < [_chooseDataModel.jump floatValue]) {//最少1个点止盈
            aChooseView.textField.text = [NSString stringWithFormat:@"%d",[_chooseDataModel.jump intValue]];
        }
        
        [self changeDataAndReloadReferencePrice:aChooseView];//刷新参考止损、止盈价格
    }
}
//条件单选项加
-(void)plusBlock:(IndexOrderChooseView *)aChooseView{
    if (aChooseView.tag == Tag_orderChooseNumView) {
        if ([aChooseView.textField.text floatValue] > 20) {//不多于20手
            aChooseView.textField.text = @"20";
            [UIEngine showShadowPrompt:@"最大手数为20手"];
        }
        _chooseBillModel.chooseNum = aChooseView.textField.text;//手数改变
        [self changeChooseNum];//手数改变计算止盈止损
    }
    else if (aChooseView.tag == Tag_orderChooseStopView){
        
        [self changeDataAndReloadReferencePrice:aChooseView];//刷新参考止损、止盈价格
    }
    else if (aChooseView.tag == Tag_orderChooseGetView){
        
        [self changeDataAndReloadReferencePrice:aChooseView];//刷新参考止损、止盈价格
    }
}

//设置委托条件
-(void)orderChooseButtonClick{
    NSLog(@"orderChooseButtonClick");
    int type = AlertDelegateOrderMore;
    if (self.buyState == 0) {
        type = AlertDelegateOrderMore;
    }
    else{
        type = AlertDelegateOrderLess;
    }
    [[UIEngine sharedInstance] showAlertWithType:type ButtonNum:2 LeftTitle:@"取消" RightTitle:@"确定"];
    [UIEngine sharedInstance].alertClick = ^(int aIndex){
        if (aIndex == 10087) {
            
        }
    };
}

//结束编辑
-(void)editEndBlock:(IndexOrderChooseView *)aChooseView{
    
    switch (aChooseView.tag) {
        case Tag_orderChooseNumView:
        {
            if ([aChooseView.textField.text intValue] > 20) {
                aChooseView.textField.text = @"20";
                [UIEngine showShadowPrompt:@"最大手数为20手"];
            }
            if ([aChooseView.textField.text floatValue] < 1) {
                aChooseView.textField.text = @"1";
                [UIEngine showShadowPrompt:@"最少手数为1手"];
            }
            
            aChooseView.textField.text = [NSString stringWithFormat:@"%d",[aChooseView.textField.text intValue]];
            _chooseBillModel.chooseNum = aChooseView.textField.text;
            [self changeChooseNum];//改变保证金手续费
        }
            break;
        case Tag_orderChooseStopView://止损跳转倍数
        {
            if ([aChooseView.textField.text intValue]%[_chooseDataModel.jump intValue] >= [_chooseDataModel.jump intValue]/2) {//自动归倍
                aChooseView.textField.text = [NSString stringWithFormat:@"%d",[aChooseView.textField.text intValue]/[_chooseDataModel.jump intValue]*[_chooseDataModel.jump intValue] + [_chooseDataModel.jump intValue]];
            }
            else{
                aChooseView.textField.text = [NSString stringWithFormat:@"%d",[aChooseView.textField.text intValue]/[_chooseDataModel.jump intValue]*[_chooseDataModel.jump intValue]];
            }
            
            if ([aChooseView.textField.text intValue] < [_chooseDataModel.minStopMoney intValue]) {//止损不小于最低止损
                aChooseView.textField.text = [NSString stringWithFormat:@"%d",[_chooseDataModel.minStopMoney intValue]];
            }
            
            aChooseView.textField.text = [NSString stringWithFormat:@"%d",[aChooseView.textField.text intValue]];
            [self changeDataAndReloadReferencePrice:aChooseView];//刷新参考止损、止盈价格
        }
            break;
        case Tag_orderChooseGetView:
        {
            
            if ([aChooseView.textField.text intValue]%[_chooseDataModel.jump intValue] >= [_chooseDataModel.jump intValue]/2) {//自动归倍
                aChooseView.textField.text = [NSString stringWithFormat:@"%d",[aChooseView.textField.text intValue]/[_chooseDataModel.jump intValue]*[_chooseDataModel.jump intValue] + [_chooseDataModel.jump intValue]];
            }
            else{
                aChooseView.textField.text = [NSString stringWithFormat:@"%d",[aChooseView.textField.text intValue]/[_chooseDataModel.jump intValue]*[_chooseDataModel.jump intValue]];
            }
            
            if ([aChooseView.textField.text intValue] < [_chooseDataModel.jump intValue]) {//止盈不小于一个点
                aChooseView.textField.text = [NSString stringWithFormat:@"%d",[_chooseDataModel.jump intValue]];
            }
            
            aChooseView.textField.text = [NSString stringWithFormat:@"%d",[aChooseView.textField.text intValue]];
            [self changeDataAndReloadReferencePrice:aChooseView];//刷新参考止损、止盈价格
        }
            break;
            
        default:
            break;
    }
}
/**
 *  刷新参考止损、止盈价格
 */
-(void)changeDataAndReloadReferencePrice:(IndexOrderChooseView *)aChooseView{
    switch (aChooseView.tag) {
        case Tag_orderChooseNumView:
        {
            _chooseBillModel.chooseNum = aChooseView.textField.text;
        }
            break;
        case Tag_orderChooseStopView:
        {
            _chooseBillModel.chooseStopMoney = aChooseView.textField.text;
        }
            break;
        case Tag_orderChooseGetView:
        {
            _chooseBillModel.chooseGetMoney = aChooseView.textField.text;
        }
            break;
            
        default:
            break;
    }
    [self reloadOfStopPriceOrGetPrice];//刷新参考止损止盈价格
    [self checkStopAndGetRule];//检查止盈、止损超过涨跌幅
}

/**
 *  检查止盈、止损超过涨跌幅
 */
-(void)checkStopAndGetRule{
    UILabel *chooseStopLabel = (UILabel *)[self.view viewWithTag:Tag_chooseStop];
    UILabel *chooseGetLabel = (UILabel *)[self.view viewWithTag:Tag_chooseGet];
    
    if (chooseStopLabel != nil && chooseGetLabel != nil) {
        NSString *stopPrice = [chooseStopLabel.text substringFromIndex:4];
        NSString *getPrice = [chooseGetLabel.text substringFromIndex:4];
        
        if (self.buyState == 0) {//看多
            if ([stopPrice floatValue] < [_chooseDataModel.lowestPrice floatValue]) {
                [UIEngine showShadowPrompt:@"超过当日涨跌幅"];
            }
            
            if ([getPrice floatValue] > [_chooseDataModel.highestPrice floatValue]) {
                [UIEngine showShadowPrompt:@"超过当日涨跌幅"];
            }
        }
        else{//看空
            if ([stopPrice floatValue] > [_chooseDataModel.highestPrice floatValue]) {
                [UIEngine showShadowPrompt:@"超过当日涨跌幅"];
            }
            
            if ([getPrice floatValue] < [_chooseDataModel.lowestPrice floatValue]) {
                [UIEngine showShadowPrompt:@"超过当日涨跌幅"];
            }
        }
        NSLog(@"涨停价：%@,跌停价：%@",_chooseDataModel.highestPrice,_chooseDataModel.lowestPrice);
        
    }
    
    //（涨停价/跌停价 - 当前价格）* 每次跳动金额 = 止损金额
    if (self.buyState == 0) {
//        float   stopMoney = ([_chooseDataModel.highestPrice floatValue] - [_priceLabel.text floatValue]) * [_chooseDataModel.jump floatValue] ;
        
    }
    else{
        
    }
    
    
    
    
    
}

-(void)textFieldValueChange{
    IndexOrderChooseView *orderChooseView = [self.view viewWithTag:Tag_orderChooseNumView];
    if ([orderChooseView.textField.text intValue] > 20) {
        orderChooseView.textField.text = @"20";
        [UIEngine showShadowPrompt:@"最大手数为20手"];
    }
    if ([orderChooseView.textField.text floatValue] < 1) {
        orderChooseView.textField.text = @"1";
        [UIEngine showShadowPrompt:@"最少手数为1手"];
    }
    
}

//手数改变（改变保证金手续费）
-(void)changeChooseNum{
    
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
