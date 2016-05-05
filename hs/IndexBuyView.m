//
//  IndexBuyView.m
//  hs
//
//  Created by RGZ on 15/7/24.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "IndexBuyView.h"
#import "MainView.h"
#import "MarketModel.h"
#import "NetRequest.h"
#import "TotalMainView.h"
#import "AFURLSessionManager.h"
#import "TimeSharingModel.h"
#import "DoubleMainView.h"
#import "IndexBuyCrossCurveView.h"
#import "DXPopover.h"
#import "IndexMarketInfoView.h"



#define Tag_timeLabel_buy   600


@implementation IndexBuyView
{
    MainView        *_mainView;//闪电图
    TotalMainView   *_totalMainView;//分时图
    DoubleMainView  *_doubleMainView;//闪电双线
    NSMutableArray  *_priceArray;//闪电图价格数组（画线用）
    NSMutableArray  *_minutePriceArray;//分时图价格数组
    NSMutableArray  *_upperPriceArray;
    NSMutableArray  *_lowerPriceArray;
    float           priceUpper;//最高价
    float           priceLower;//最低价
    UILabel         *_nameLabel;//名字和代码
    UILabel         *_changeLabel;//涨跌
    int             floatNum;//小数位数
    UIView          *_redView ;//买卖量
    UIView          *_redCoverView ;
    UIView          *_greenView ;
    UIView          *_greenCoverView ;
    UILabel         *_buyNumLabel;
    UILabel         *_saleNumLabel;
    UIScrollView    *_scrollView;
    NSTimer         *_timeSharingTimer;//分时图Timer
    double           defaultUpper;
    double           defaultLower;
    NSString        *_socketInfoName;
    /*
     十字标注线
     */
    CGPoint                 beginPoint;
    CGPoint                 currentPoint;
    IndexBuyCrossCurveView  *_indexBuyCrossView;
    NSMutableArray          *_crossViewArray;//分时图--》价格、时间
    /*
     分时图新增品种支持不修改代码
     */
    float           rangSection ;//闪电图波动区间
    int             timeArrayCount;//分时图数据条数
    int             numCount;//分时图点数
    BOOL            dayOrNight;//分时图区分时间
    BOOL            isDouble;//闪电图是否双线
    double          defaultRangSection;//分时图默认区间
    NSMutableDictionary     *_timeAndNumDictionary;
    int             baseLineNum;//基线数
    NSString        *_datePrefix;
    NSString        *_lastTimeString;//分时图次日时间
    
    //切换k线图
    CGFloat     _popoverWidth;
    CGSize      _popoverArrowSize;
    CGFloat     _popoverCornerRadius;
    CGFloat     _animationIn;
    CGFloat     _animationOut;
    BOOL        _animationSpring;
    UIButton    *_recordButton;
    BOOL        isChooseMinute;
    
    //k线图
    KMainView       *_kMainView;
    NSString        *_kLineTitle;
    KLineDataModel  *_kLineDataModel;//用于Title的改变
    UIView          *_kLineTitleView;
    UILabel         *_kLineTitleTimeLabel;
    UILabel         *_kLineTitlePriceLabel;
    BOOL            showKLineData;
    BOOL            firstLoadProgress;
    BOOL            marketisOpen;
    
    BOOL            isXH;
    
    //盘口
    IndexMarketInfoView *_marketInfoView;
}


@synthesize bullishBtn,bearishBtn,bullishBtnLabel,bearishBtnLabel,lightningGreenView,lightningRedView;
-(instancetype)initWithFrame:(CGRect)frame Name:(NSString *)aName Code:(NSString *)aCode ProductModel:(FoyerProductModel *)aProductModel{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor    = Color_grayDeep;
        self.productModel       = aProductModel;
        self.name               = aName;
        self.code               = aCode;
        
        [self changeBarColor];
        
        [self loadData];
        
        [self loadNotification];
    
        [self loadUI];
    }
    
    return self;
}

-(void)loadData{
    //是否现货
    if (self.productModel.isXH == 1) {
        isXH = YES;
    }
    
    //市场是否开市
    marketisOpen            = NO;
    //初始化
    _lastTimeString         = @"";
    _priceArray             = [NSMutableArray arrayWithCapacity:0];
    _upperPriceArray        = [NSMutableArray arrayWithCapacity:0];
    _lowerPriceArray        = [NSMutableArray arrayWithCapacity:0];
    _crossViewArray         = [NSMutableArray arrayWithCapacity:0];
    _timeAndNumDictionary   = [NSMutableDictionary dictionaryWithCapacity:0];
    //缓存路径配置
    if (self.code.length > 2) {
        _socketInfoName     = [NSString stringWithFormat:@"%@InfoArray",[self.code substringToIndex:2]];
    }
    else{
        _socketInfoName     = self.code;
    }
    
    //双线闪电图配置
    if ([_productModel.isDoule intValue] == 1) {
        isDouble = YES;
    }
    dayOrNight          = YES;//白天默认
    rangSection         = [_productModel.interval floatValue]/2;//闪电图波动区间默认配置
    [self timeConfiger];//时间轴、点数计算
    defaultRangSection  = [_productModel.scale doubleValue];//分时图默认区间
    defaultRangSection  = defaultRangSection/100;
    baseLineNum         = [_productModel.baseline intValue];//基线数
    //Model 初始化
    _indexBuyModel      = [[IndexBuyModel alloc]initWithName:self.name Code:self.productModel.instrumentID];
    
    
    floatNum = [self.productModel.decimalPlaces intValue];//小数位
    
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    [self loadCacheArray:cacheModel.socketInfoDic[_socketInfoName]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeConnection)
                                                 name:kCloseConnection
                                               object:nil];
    
    //切换到k线图
    UITableView *blueView       = [[UITableView alloc] init];
    blueView.frame              = CGRectMake(0, 0, _popoverWidth, 150);
    blueView.dataSource         = self;
    blueView.delegate           = self;
    blueView.backgroundColor    = Color_Gold;
    blueView.separatorStyle     = UITableViewCellSeparatorStyleNone;
    self.tableView              = blueView;
    
    [self resetPopover];
    
    self.configs = @[
                     @"1分钟",
                     @"3分钟",
                     @"5分钟",
                     @"15分钟",
                     @"日K线",
                     ];
}

#pragma mark -
#pragma mark 行情

-(void)closeConnection{
    [_priceArray      removeAllObjects];
    [_upperPriceArray removeAllObjects];
    [_lowerPriceArray removeAllObjects];
    
    if (isDouble) {
        [_doubleMainView setPriceArray:_upperPriceArray LowerPriceArray:_lowerPriceArray];
    }
    else{
        [_mainView setPriceArray:_priceArray];
    }
}

-(void)end{
    if (_timeSharingTimer != nil) {
        [_timeSharingTimer invalidate];
        _timeSharingTimer = nil;
    }
    
    [_marketInfoView closeTimer];

}

-(void)start{
    [self loadTimeSharingData];
}

#pragma mark 加载缓存行情

-(void)loadCacheArray:(NSMutableArray *)anArray{
    if (anArray !=nil) {
        if (anArray.count > 0) {
            //IndexBuyModel 赋值缓存数据
            [self rangeSection:[IndexBuyModel indexBuyModelCacheDataConfiger:_indexBuyModel
                                                              DataArray:anArray
                                                               FloatNum:floatNum
                                                           RangeSection:rangSection]];
        }
    }
}

#pragma mark 行情

-(void)loadNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSocketData:) name:kSocket_Buy object:nil];
}

-(void)getSocketData:(NSNotification *)notify{
    NSMutableDictionary * infoDic = [NSMutableDictionary dictionaryWithDictionary:notify.userInfo];
    [self marketQuotationsData:infoDic];
}

#pragma mark 行情实时数据

-(void)marketQuotationsData:(NSMutableDictionary *)infoDic{
    //行情实时数据赋值_indexBuyModel
    [IndexBuyModel indexBuyModelAgingDataConfiger:_indexBuyModel DataDic:infoDic InstrumentCode:self.instrumentCode];
    //计算波动区间
    [self rangeSection:infoDic];
    
    
    [_priceArray addObject:[NSString stringWithFormat:@"%.2f",[_indexBuyModel.currentPrice floatValue]]];
    //双线
    if (isDouble) {
        [_upperPriceArray addObject:[NSString stringWithFormat:@"%.2f",[_indexBuyModel.bullishBuyPrice floatValue]]];
        [_lowerPriceArray addObject:[NSString stringWithFormat:@"%.2f",[_indexBuyModel.bearishAveragePrice floatValue]]];
    }
    
    //保持数组200条数据
    if(_priceArray.count>100){
        [_priceArray removeObjectAtIndex:0];
    }
    
    if (isDouble) {
        if(_upperPriceArray.count>100){
            [_upperPriceArray removeObjectAtIndex:0];
        }
        if(_lowerPriceArray.count>100){
            [_lowerPriceArray removeObjectAtIndex:0];
        }
    }
    
    if ([_indexBuyModel.currentPrice floatValue] != 0) {
        //持仓内页发送通知信息
        NSDictionary    *infoDic = @{
                                     @"code":_indexBuyModel.code,
                                     //看空价
                                     @"bidPrice":_indexBuyModel.bearishAveragePrice,
                                     //看多价
                                     @"askPrice":_indexBuyModel.bullishBuyPrice,
                                     //买量
                                     @"buyNum":_indexBuyModel.bearishAverageNum,
                                     //卖量
                                     @"saleNum":_indexBuyModel.bullishBuyNum,
                                     //涨停价
                                     @"highestPrice":_indexBuyModel.highestPrice,
                                     //跌停价
                                     @"lowestPrice":_indexBuyModel.lowestPrice,
                                     //当前价
                                     @"lastPrice":_indexBuyModel.currentPrice,
                                     //涨跌幅：例+0.04% 、 -0.04%
                                     @"changePercent":_indexBuyModel.changePercent,
                                     };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kPositionBosomPage object:infoDic];
        
        [self updateData];
        
        //分时图点实时动
        [self changeLastInfo];
        
        [_marketInfoView changePercentWithPrice:_indexBuyModel.changePrice Percent:_indexBuyModel.changePercent];
        
        //行情动态获取当前价
        [_indexBuyTacticsButton changeCurrentPrice:_indexBuyModel.currentPrice];
    }
}

#pragma mark 计算波动区间

-(void)rangeSection:(NSMutableDictionary *)infoDic{
    //计算上下区间
    if (infoDic[@"lastPrice"] != nil && ![infoDic[@"lastPrice"] isKindOfClass:[NSNull class]]) {
        
        //双线单独计算
        if(isDouble){
            if ([infoDic[@"askPrice1"] floatValue] >= [_indexBuyModel.upperPrice floatValue]) {
                _indexBuyModel.upperPrice = [DataUsedEngine conversionFloatNum:[infoDic[@"askPrice1"] floatValue] +rangSection ExpectFloatNum:floatNum];
                _indexBuyModel.lowerPrice = [DataUsedEngine conversionFloatNum:[infoDic[@"askPrice1"] floatValue] -rangSection ExpectFloatNum:floatNum];
            }
            
            else if ([infoDic[@"bidPrice1"] floatValue] <= [_indexBuyModel.lowerPrice floatValue]){
                _indexBuyModel.upperPrice = [DataUsedEngine conversionFloatNum:[infoDic[@"bidPrice1"] floatValue] +rangSection ExpectFloatNum:floatNum];
                _indexBuyModel.lowerPrice = [DataUsedEngine conversionFloatNum:[infoDic[@"bidPrice1"] floatValue] -rangSection ExpectFloatNum:floatNum];
            }
        }
        else{
            if ([infoDic[@"lastPrice"] floatValue] >= [_indexBuyModel.upperPrice floatValue]) {
                _indexBuyModel.upperPrice = [DataUsedEngine conversionFloatNum:[infoDic[@"lastPrice"] floatValue] +rangSection ExpectFloatNum:floatNum];
                _indexBuyModel.lowerPrice = [DataUsedEngine conversionFloatNum:[infoDic[@"lastPrice"] floatValue] -rangSection ExpectFloatNum:floatNum];
            }
            
            else if ([infoDic[@"lastPrice"] floatValue] <= [_indexBuyModel.lowerPrice floatValue]){
                _indexBuyModel.upperPrice = [DataUsedEngine conversionFloatNum:[infoDic[@"lastPrice"] floatValue] +rangSection ExpectFloatNum:floatNum];
                _indexBuyModel.lowerPrice = [DataUsedEngine conversionFloatNum:[infoDic[@"lastPrice"] floatValue] -rangSection ExpectFloatNum:floatNum];
            }
        }
        
    }
    else{
        _indexBuyModel.upperPrice = @"0.00";
        _indexBuyModel.lowerPrice = @"0.00";
    }
}

#pragma mark UI

-(void)loadUI{
    /**
     *  闪电图、分时图、K线图
     */
    float  spHeight = 10/667.0*ScreenHeigth;
    if (ScreenHeigth <= 480) {
        spHeight = 0;
    }
    [self loadSharingView:spHeight];
}

-(void)changeBarColor{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark -
#pragma mark 分时图十字标注线

-(void)loadLongGesture{
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    [longPressGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
    [longPressGestureRecognizer setMinimumPressDuration:0.3f];
    [longPressGestureRecognizer setAllowableMovement:50.0];
    [_totalMainView addGestureRecognizer:longPressGestureRecognizer];
}

#pragma mark 长按就开始生成十字线
-(void)gestureRecognizerHandle:(UILongPressGestureRecognizer*)longResture{
    CGPoint point = [longResture locationInView:self];
    
    // 手指长按开始时更新一般
    if(longResture.state == UIGestureRecognizerStateBegan){
        [self loadGestureView:point];
    }
    // 手指移动时候开始显示十字线
    if (longResture.state == UIGestureRecognizerStateChanged) {
        [self loadGestureView:point];
    }
    
    // 手指离开的时候移除十字线
    if (longResture.state == UIGestureRecognizerStateEnded || longResture.state == UIGestureRecognizerStateFailed || longResture.state == UIGestureRecognizerStateCancelled) {
        [self removeGestureView];
    }
    
}

-(void)segChangeOfIndex:(int)aIndex{
    self.segSelectIndex = aIndex;
}

-(void)loadGestureView:(CGPoint)point{
    beginPoint = point;
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:NSStringFromCGPoint(beginPoint) forKey:@"point"];
    [paramDic setObject:[NSString stringWithFormat:@"%f",defaultUpper] forKey:@"upper"];
    [paramDic setObject:[NSString stringWithFormat:@"%f",defaultLower] forKey:@"lower"];
    [paramDic setObject:[NSString stringWithFormat:@"%d",numCount] forKey:@"number_count"];
    [paramDic setObject:[NSString stringWithFormat:@"%d",floatNum] forKey:@"float_num"];
    [paramDic setObject:[NSString stringWithFormat:@"%d",dayOrNight] forKey:@"day_or_night"];
    [paramDic setObject:_timeAndNumDictionary forKey:@"timeAndNumDic"];
    [paramDic setObject:_crossViewArray forKey:@"price_array"];
    if (_indexBuyCrossView == nil) {
        _indexBuyCrossView = [[IndexBuyCrossCurveView alloc]initWithFrame:_totalMainView.bounds ParamDictionary:paramDic];
        _indexBuyCrossView. userInteractionEnabled = YES;
        [_totalMainView addSubview:_indexBuyCrossView];
        //设置时间线
        [_indexBuyCrossView setTimeLine:self.productModel.timeline];
    }
    else{
        [_indexBuyCrossView changeLocation:point ParamDictionary:paramDic];
    }
}

-(void)removeGestureView{
    [_indexBuyCrossView removeFromSuperview];
    _indexBuyCrossView = nil;
}

#pragma mark -
#pragma mark ScrollView / 闪电图、分时图、k线图切换

-(void)changeClick:(UIButton *)btn{
    if (btn != nil) {
        if (![[ControlCenter sharedInstance] isShowKline] && btn.tag == 668) {
            [[UIEngine sharedInstance] showAlertWithTitle:@"敬请期待" ButtonNumber:1 FirstButtonTitle:@"我知道了" SecondButtonTitle:nil];
            [UIEngine sharedInstance].alertClick = ^(int aIndex){};
            return;
        }
        
        isChooseMinute = NO;
        for (int i = 666; i<670; i++) {
            UIButton    *btnChange = (UIButton *)[self viewWithTag:i];
            [btnChange setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            /**
             *  按钮背景方框
             */
            UIButton    *bgBtn = [self viewWithTag:i+10];
            bgBtn.hidden = YES;
            
            if (btn.tag != 668) {
                if (i == 668) {
                    if (isXH || [self.productModel.loddyType isEqualToString:@"3"]) {
                        [btnChange setTitleColor:Color_gray forState:UIControlStateNormal];
                    }
                    else{
                        [btnChange setTitle:@"K线图" forState:UIControlStateNormal];
                        UIButton *kLineBtn  = [self viewWithTag:668];
                        UIImage *image      = [UIImage imageNamed:@"klineboult_white"];
                        [kLineBtn setImage:image forState:UIControlStateNormal];
                        [kLineBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
                        [kLineBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, -35)];
                    }
                }
            }
        }
        
        //所选bug处理
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        /**
         *  按钮背景方框
         */
        UIButton    *bgBtn = [self viewWithTag:btn.tag+10];
        bgBtn.hidden = NO;
        
        if(btn.tag == 667){
            _recordButton = btn;
            [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width*(btn.tag-666), 0) animated:NO];
        }
        else if (btn.tag == 668) {
            if (!isXH) {
                if (btn.titleLabel.text.length > 3) {
                    UIImage *image = [UIImage imageNamed:@"klineboult_gold"];
                    [btn setImage:image forState:UIControlStateNormal];
                    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
                    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, -40)];
                }
                else{
                    UIImage *image = [UIImage imageNamed:@"klineboult_gold"];
                    [btn setImage:image forState:UIControlStateNormal];
                    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
                    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, -35)];
                }
                [self showPopover];
            }
        }else{
            [[UIEngine sharedInstance] hideProgress];
            _recordButton = btn;
            [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width*(btn.tag-666), 0) animated:NO];
        }
        
        //现货去除盘口
        if (isXH || [self.productModel.loddyType isEqualToString:@"3"]) {
            UIButton    *btnXH = (UIButton *)[self viewWithTag:669];
            [btnXH setTitleColor:Color_gray forState:UIControlStateNormal];
        }
        
        if (btn.tag == 669) {
            [_marketInfoView openTimer];
        }
        else{
            [_marketInfoView closeTimer];
        }
        
        btn.selected = YES;
    }
}

-(void)loadSharingView:(float)aPointY{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 268.0/568*ScreenHeigth)];
    if (ScreenHeigth == 480) {
        _scrollView.frame = CGRectMake(0, aPointY+30.0/568*ScreenHeigth, ScreenWidth, 268.0/568*ScreenHeigth);
    }
    _scrollView.indicatorStyle  = UIScrollViewIndicatorStyleDefault;
    _scrollView.pagingEnabled   = YES;
    _scrollView.contentSize     = CGSizeMake(ScreenWidth*5, _scrollView.bounds.size.height);
    _scrollView.delegate        = self;
    _scrollView.showsHorizontalScrollIndicator  = NO;
    _scrollView.showsVerticalScrollIndicator    = NO;
    _scrollView.userInteractionEnabled          = NO;
    [self addSubview:_scrollView];
    
    float height = _scrollView.frame.size.height-20;
    
    if (ScreenHeigth <= 568) {
        height = height-30;
    }
    
    //闪电图
    if (isDouble) {
        _doubleMainView                 = [[DoubleMainView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,height)
                                               UpperPriceArray:_upperPriceArray
                                               LowerPriceArray:_lowerPriceArray
                                                      FloatNum:floatNum
                                                      BaseLine:baseLineNum];
        _doubleMainView.clipsToBounds   = YES;
        [_scrollView addSubview:_doubleMainView];
        [_doubleMainView setUpperAndLowerLimitsWithUpper:[_indexBuyModel.upperPrice floatValue] Middle:[_indexBuyModel.lowerPrice floatValue] + ([_indexBuyModel.upperPrice floatValue]-[_indexBuyModel.lowerPrice floatValue])/2 Lower:[_indexBuyModel.lowerPrice floatValue]];
    }
    else{
        _mainView               = [[MainView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, height)
                                        PriceArray:_priceArray
                                          FloatNum:floatNum
                                       BaseLineNum:baseLineNum];
        _mainView.clipsToBounds = YES;
        [_scrollView addSubview:_mainView];
        [_mainView setUpperAndLowerLimitsWithUpper:[_indexBuyModel.upperPrice floatValue] Middle:[_indexBuyModel.lowerPrice floatValue] + ([_indexBuyModel.upperPrice floatValue]-[_indexBuyModel.lowerPrice floatValue])/2 Lower:[_indexBuyModel.lowerPrice floatValue]];
    }
    
    //分时图
    _totalMainView = [[TotalMainView alloc]initWithFrame:CGRectMake(_scrollView.bounds.size.width, 0, self.frame.size.width, height)
                                              PriceArray:_priceArray
                                                FloatNum:floatNum
                                                 InfoDic:_timeAndNumDictionary
                                              DayOrNight:YES
                                                BaseLine:baseLineNum];
    [_scrollView addSubview:_totalMainView];
    if (![_lastTimeString isEqualToString:@""]) {
        [_totalMainView setLastTimeLineString:_lastTimeString];
    }
    
    float       upperPrice = 0;
    float       lowerPrice = 0;
    upperPrice = [_indexBuyModel.preClosePrice floatValue]+[_indexBuyModel.preClosePrice floatValue]*defaultRangSection;
    lowerPrice = [_indexBuyModel.preClosePrice floatValue] ;
    
    defaultLower = lowerPrice;
    defaultUpper = upperPrice;
    
    [_totalMainView setUpperAndLowerLimitsWithUpper:upperPrice
                                             Middle:lowerPrice + (upperPrice-lowerPrice)/2
                                              Lower:lowerPrice];
    
    UIButton    *defaultButton = [self loadSharingView];
    
    [self loadLongGesture];
    
    [self loadKLineView];
    
    [self loadBottomView];
    
    [self loadSharingData];
    
    [self kLineDataconfiger];
    
    [self loadTimeSharingData];
    
    [self loadMarketInfo];
    
    //默认显示分时图
    [self changeClick:defaultButton];
    
}

-(UIButton *)loadSharingView{
    NSArray *titleArray = @[@"闪电图",@"分时图",@"K线图",@"盘口"];
    UIButton    *defaultButton = nil;
    for (int i = 0 ; i < 4; i++) {
        UIButton    *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        changeBtn.frame = CGRectMake(20+i*(ScreenWidth-40)/4, CGRectGetMaxY(_scrollView.frame), (ScreenWidth-40)/4, 30);
        changeBtn.tag = 666+i;
        [changeBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        if (i== 0) {
            [changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else{
            [changeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        if(i == 2){
            [changeBtn setTitle:_kLineTitle forState:UIControlStateSelected];
        }
        changeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:10];
        [changeBtn addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
        
        /**
         *  背景方块
         */
        UIButton    *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.bounds = CGRectMake(0, 0, changeBtn.frame.size.width/5*4, changeBtn.frame.size.height/3*2);
        bgBtn.center = changeBtn.center;
        bgBtn.clipsToBounds = YES;
        bgBtn.tag = 666+i+10;
        bgBtn.layer.cornerRadius = 2;
        //        bgBtn.layer.borderWidth = 1;
        //        bgBtn.layer.borderColor = Color_Gold.CGColor;
        bgBtn.backgroundColor = [UIColor colorWithRed:60/255.0 green:59/255.0 blue:60/255.0 alpha:1];
        [self addSubview:bgBtn];
        
        [self addSubview:changeBtn];
        if (i == 0) {
            _recordButton = changeBtn;
        }
        //现货K线不可点
        if (i == 2) {
            if(!isXH){
                UIImage *image = [UIImage imageNamed:@"klineboult_white"];
                [changeBtn setImage:image forState:UIControlStateNormal];
                [changeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
                [changeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, -35)];
            }
            else{
                changeBtn.enabled = NO;
                [changeBtn setTitleColor:Color_gray forState:UIControlStateNormal];
            }
        }
        
        //现货去除盘口
        if (i == 3) {
            if (isXH) {
                changeBtn.enabled = NO;
                [changeBtn setTitleColor:Color_gray forState:UIControlStateNormal];
            }
        }
        
        //假日盘K线盘口不可点
        if (i == 2 || i == 3) {
            if ([self.productModel.loddyType isEqualToString:@"3"]) {
                changeBtn.enabled = NO;
                [changeBtn setTitleColor:Color_gray forState:UIControlStateNormal];
            }
        }
        
        //默认选中分时图
        if (i == 1) {
            defaultButton = changeBtn;
        }
        
    }
    
    return defaultButton;
}

#pragma mark -
#pragma mark 数据获取定时器
-(void)loadTimeSharingData{
    if(_timeSharingTimer != nil){
        [_timeSharingTimer invalidate];
        _timeSharingTimer = nil;
    }
    _timeSharingTimer = [NSTimer scheduledTimerWithTimeInterval:30
                                                         target:self
                                                       selector:@selector(getDataTimer)
                                                       userInfo:nil
                                                        repeats:YES];
    [_timeSharingTimer fire];
}

#pragma mark 分时图、K线图数据获取
-(void)getDataTimer{
    //分时图数据
    [self getTimeSharingData];
    //K线图数据
    if (showKLineData) {
        [self getKLineData];
    }
}

#pragma mark -
#pragma mark 分时图数据处理

//分时图时间和点数配置
-(void)timeConfiger{
    /*
     day    time(NSMutableArray)
     num(NSMutableArray)
     
     night  time(NSMutableArray)
     num(NSMutableArray)
     */
    //    _productModel.timeAndNum//"09:00/76;10:30/61;13:30/151;15:00",
    NSMutableArray *dayTimeArray    = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *dayNumArray     = [NSMutableArray arrayWithCapacity:0];
    NSArray *dayTimeAndNum          = [_productModel.timeAndNum componentsSeparatedByString:@";"];//09:00/76  10:30/61  13:30/151
    
    if (dayTimeAndNum.count > 1) {
        for (int i = 0; i < dayTimeAndNum.count - 1; i ++) {
            NSArray *tmpArray = [dayTimeAndNum[i] componentsSeparatedByString:@"/"];
            
            if (tmpArray!=nil && tmpArray.count > 1) {
                [dayTimeArray addObject:tmpArray[0]];
                [dayNumArray addObject:tmpArray[1]];
            }
        }
        [dayTimeArray addObject:dayTimeAndNum.lastObject];
    }
    else{
        for (int i = 0; i < dayTimeAndNum.count; i ++) {
            NSArray *tmpArray = [dayTimeAndNum[i] componentsSeparatedByString:@"/"];
            
            if (tmpArray!=nil && tmpArray.count > 1) {
                if (tmpArray.count >0) {
                    [dayTimeArray addObject:tmpArray[0]];
                }
                if (tmpArray.count > 1) {
                    [dayNumArray addObject:tmpArray[1]];
                }
            }
        }
    }
    
    //现货9:00-6:00 无法解析问题
    if (dayTimeArray.count == 2) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSDate *frontDate = [dateFormatter dateFromString:dayTimeArray[0]];
        NSDate *betweenDate = [dateFormatter dateFromString:dayTimeArray[1]];
        
        NSTimeInterval timeInterval  = [frontDate timeIntervalSinceDate:betweenDate];
        if (timeInterval > 0) {
            _lastTimeString = [NSString stringWithFormat:@"次日%@",dayTimeArray.lastObject];
            [dayTimeArray removeLastObject];
        }
    }
    
    NSMutableArray *nightTimeArray  = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *nightNumArray   = [NSMutableArray arrayWithCapacity:0];
    NSArray *nightTimeAndNum        = [_productModel.nightTimeAndNum componentsSeparatedByString:@";"];//09:00/76  10:30/61  13:30/151
    if (nightTimeAndNum.count > 1) {
        for (int i = 0; i < nightTimeAndNum.count - 1; i ++) {
            NSArray *tmpArray = [nightTimeAndNum[i] componentsSeparatedByString:@"/"];
            
            if (tmpArray.count > 0) {
                [nightTimeArray addObject:tmpArray[0]];
            }
            if(tmpArray.count > 1){
                [nightNumArray addObject:tmpArray[1]];
            }
        }
        [nightTimeArray addObject:nightTimeAndNum.lastObject];
    }
    else{
        for (int i = 0; i < nightTimeAndNum.count; i ++) {
            NSArray *tmpArray = [nightTimeAndNum[i] componentsSeparatedByString:@"/"];
            
            if (tmpArray.count > 0) {
                [nightTimeArray addObject:tmpArray[0]];
            }
            if(tmpArray.count > 1){
                [nightNumArray addObject:tmpArray[1]];
            }
        }
    }
    
    [_timeAndNumDictionary setObject:[NSDictionary dictionaryWithObjectsAndKeys:dayTimeArray,TIME_INDEXBUY,dayNumArray,NUM_INDEXBUY, nil] forKey:DAY_INDEXBUY];
    [_timeAndNumDictionary setObject:[NSDictionary dictionaryWithObjectsAndKeys:nightTimeArray,TIME_INDEXBUY,nightNumArray,NUM_INDEXBUY, nil] forKey:NIGHT_INDEXBUY];
}

//分时图点实时动
-(void)changeLastInfo{
    
    [_totalMainView addPrice:_indexBuyModel.currentPrice];
    
    if([_indexBuyModel.currentPrice floatValue] > defaultUpper){
        [_totalMainView setUpperAndLowerLimitsWithUpper:[_indexBuyModel.currentPrice floatValue]
                                                 Middle:defaultLower + ([_indexBuyModel.currentPrice floatValue]-defaultLower)/2
                                                  Lower:defaultLower];
    }
    else if ([_indexBuyModel.currentPrice floatValue] < defaultLower){
        [_totalMainView setUpperAndLowerLimitsWithUpper:defaultUpper
                                                 Middle:[_indexBuyModel.currentPrice floatValue] + (defaultUpper-[_indexBuyModel.currentPrice floatValue])/2
                                                  Lower:[_indexBuyModel.currentPrice floatValue]];
    }
//    else{
//        [_totalMainView setUpperAndLowerLimitsWithUpper:defaultUpper
//                                                 Middle:defaultLower + (defaultUpper-defaultLower)/2
//                                                  Lower:defaultLower];
//    }
}

#pragma mark 分时图数据
-(void)getTimeSharingData{
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/Documents/%@.fst",NSHomeDirectory(),self.productModel.instrumentCode]]) {
        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/Documents/%@.fst",NSHomeDirectory(),self.productModel.instrumentCode] error:nil];
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager             = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL              = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/futurequota/%@.fst",HTTP_IP,self.productModel.instrumentCode]];
    
    NSURLRequest *request   = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask  = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *documentsDirectoryURL        = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        NSString    *str            = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/%@.fst",NSHomeDirectory(),self.productModel.instrumentCode] encoding:NSUTF8StringEncoding error:nil];
        NSArray *sortArray          = [str componentsSeparatedByString:@"|"];
        NSMutableArray *temArray    = [NSMutableArray arrayWithCapacity:0];
        
        for (int i = 0; i < sortArray.count; i++) {
            if (i==0) {
                [temArray addObject:sortArray[i]];
            }
            else{
                if ([sortArray[i] isEqualToString:sortArray[i-1]]) {
                }
                else{
                    [temArray addObject:sortArray[i]];
                }
            }
        }
        
        NSMutableArray *timeSharingArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0 ; i < temArray.count; i++) {
            if (temArray[i] != nil && [temArray[i] length]>12) {
                NSArray *separArray         = [temArray[i] componentsSeparatedByString:@","];
                TimeSharingModel    *model  = [[TimeSharingModel alloc]init];
                if (separArray.count == 3) {
                    model.code  = separArray[0];
                    model.price = separArray[1];
                    model.time  = separArray[2];
                    
                    if (i == 0) {
                        NSString    *dateAndTimeStr = model.time;
                        _datePrefix = [dateAndTimeStr substringToIndex:8];
                    }
                    
                    int isInvalidData = [self isInvalidData:model.time];//数据过滤
                    if (isInvalidData == 1) {
                        [timeSharingArray addObject:model];
                        if (i == 0 || i == 5) {
                            [self dayOrNightConfiger:model];
                        }
                    }
                }
            }
        }
        
        //重复数据过滤
        NSMutableArray *timeSharingArrayGoInvalid = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i = 0; i < timeSharingArray.count; i++) {
            TimeSharingModel *model = timeSharingArray[i];
            NSString *time = model.time;
            if (model.time.length >= 12) {
                time = [[model.time substringFromIndex:8] substringToIndex:4];
            }
            BOOL isInvalid = NO;
            
            for (int j = 0; j < timeSharingArrayGoInvalid.count; j++) {
                TimeSharingModel *goInvalidModel = timeSharingArrayGoInvalid[j];
                NSString *goInvalidTime = goInvalidModel.time;
                if (goInvalidModel.time.length >= 12) {
                    goInvalidTime = [[goInvalidModel.time substringFromIndex:8] substringToIndex:4];
                }
                if ([time isEqualToString:goInvalidTime]) {
                    isInvalid = YES;
                }
            }
            if (isInvalid == NO) {
                [timeSharingArrayGoInvalid addObject:model];
            }
        }
        [timeSharingArray removeAllObjects];
        timeSharingArray = [NSMutableArray arrayWithArray:timeSharingArrayGoInvalid];
        
        //设置时间区间
        [_totalMainView setTimeLine:self.productModel.timeline];
        
        //设置是晚上还是白天的数据
        [_totalMainView setDayOrNight:dayOrNight];
        
        NSMutableArray  *timeSharingPriceArray = [NSMutableArray arrayWithCapacity:0];
        
        //规定小数位
        for (int i = 0; i < timeSharingArray.count; i++) {
            TimeSharingModel    *model = timeSharingArray[i];
            [timeSharingPriceArray addObject:[DataUsedEngine conversionFloatNum:[model.price doubleValue] ExpectFloatNum:floatNum]];
        }
        
        //十字标注线数据处理
        for (int i = 0; i < timeSharingPriceArray.count; i++) {
            TimeSharingModel    *model = timeSharingArray[i];
            model.price = [DataUsedEngine conversionFloatNum:[model.price doubleValue] ExpectFloatNum:floatNum];
        }
        _crossViewArray = [NSMutableArray arrayWithArray:timeSharingArray];
        //计算分时图区间
        if (timeSharingPriceArray.count > 0) {
            double upper = [timeSharingPriceArray[0] doubleValue];
            double lower = [timeSharingPriceArray[0] doubleValue];
            
            for (int i = 0; i<timeSharingPriceArray.count; i++) {
                if ([timeSharingPriceArray[i] floatValue] >= upper) {
                    upper = [timeSharingPriceArray[i] doubleValue];
                }
                if ([timeSharingPriceArray[i] floatValue] < lower && [timeSharingPriceArray[i] floatValue] > 0.1) {
                    lower = [timeSharingPriceArray[i] doubleValue];
                }
            }
            
            double defaultUpperTmp = [_indexBuyModel.preClosePrice floatValue]+[_indexBuyModel.preClosePrice floatValue]*defaultRangSection;
            double defaultLowerTmp = [_indexBuyModel.preClosePrice floatValue] ;

            float rangeHeight = defaultUpperTmp - defaultLowerTmp;
            
            if (upper - lower >= defaultUpperTmp - defaultLowerTmp) {
                defaultUpper = upper;
                defaultLower = lower;
            }
            else{
                defaultUpper = lower + rangeHeight;
                defaultLower = lower;
            }
        }
        
        //计算分时图点数
        numCount = [self calculateNumCount];
        
        //分时图数据加载
        [_totalMainView setUpperAndLowerLimitsWithUpper:defaultUpper Middle:defaultLower+(defaultUpper-defaultLower)/2 Lower:defaultLower];
        [_totalMainView setPriceModelArray:timeSharingArray];
    }];
    [downloadTask resume];
}

#pragma mark 分时图无效数据过滤
//1:有效 0：无效
-(int)isInvalidData:(NSString *)aTime{
    
    int state = 0;
    
    NSArray *timeLineTmpArray = [_productModel.timeline componentsSeparatedByString:@";"];
    NSMutableArray *timeLineArray = [NSMutableArray arrayWithArray:timeLineTmpArray];
    //现货9:00-6:00 无法解析问题
    for (int i = 0; i < timeLineArray.count ; i++) {
        if ([timeLineArray[i] isEqualToString:@""]) {
            [timeLineArray removeObjectAtIndex:i];
            break;
        }
    }
    //只有一段时间的处理
    if (timeLineArray.count == 2) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSDate *frontDate = [dateFormatter dateFromString:timeLineArray[0]];
        NSDate *betweenDate = [dateFormatter dateFromString:timeLineArray[1]];
        frontDate    = [DataUsedEngine timeZoneChange:frontDate];
        betweenDate  = [DataUsedEngine timeZoneChange:betweenDate];
        
        NSTimeInterval timeInterval  = [frontDate timeIntervalSinceDate:betweenDate];
        //次日时间处理
        if (timeInterval > 0) {
            betweenDate = [betweenDate dateByAddingTimeInterval:24*60*60];
        }
        
        [dateFormatter setDateFormat:@"HHmm"];
        NSDate      *createDate = [dateFormatter dateFromString:[[aTime substringFromIndex:8] substringToIndex:4]];
        createDate = [DataUsedEngine timeZoneChange:createDate];
        NSTimeInterval timeIntervalFront    = [createDate timeIntervalSinceDate:frontDate];
        NSTimeInterval timeIntervalBetween  = [createDate timeIntervalSinceDate:betweenDate];
        
        if (timeIntervalFront >= 0 && timeIntervalBetween <= 0) {
            state = 1;
        }
        else if (timeIntervalFront < 0){
            createDate = [createDate dateByAddingTimeInterval:24*60*60];
            timeIntervalBetween  = [createDate timeIntervalSinceDate:betweenDate];
            if (timeIntervalBetween <= 0) {
                state = 1;
            }
        }
        
        return state;
    }
    
    if (aTime != nil && aTime.length > 11) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSDate      *createDate = [dateFormatter dateFromString:aTime];
        createDate = [DataUsedEngine timeZoneChange:createDate];
        
        [dateFormatter setDateFormat:@"yyyyMMddHH:mm"];
        for (int i = 0; i < timeLineArray.count-1; i+=2) {
            NSDate  *dateTmpFront   = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@%@",_datePrefix,timeLineArray[i]]];
            NSDate  *dateTmpBetween = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@%@",_datePrefix,timeLineArray[i+1]]];
            dateTmpFront    = [DataUsedEngine timeZoneChange:dateTmpFront];
            dateTmpBetween  = [DataUsedEngine timeZoneChange:dateTmpBetween];
            
            NSTimeInterval timeIntervalFront    = [createDate timeIntervalSinceDate:dateTmpFront];
            NSTimeInterval timeIntervalBetween  = [createDate timeIntervalSinceDate:dateTmpBetween];
            
            //晚盘
            if (aTime.length >= 12 && ([[[aTime substringFromIndex:8] substringToIndex:2] intValue] != 15) && i >= timeLineArray.count-2) {
                if (timeIntervalFront >= 0) {
                    state = 1;
                }
            }
            
            if (timeIntervalFront >= 0 && timeIntervalBetween <= 0) {
                state = 1;
            }
        }
    }
    else{
        return 0;
    }
    
    return state;
}



#pragma mark 分时图判断DayOrNight

-(void)dayOrNightConfiger:(TimeSharingModel *)model{
    if ([self isXHShareTimeConfiger]) {
        dayOrNight = YES;
        return;
    }
    
    if (model.time != nil && model.time.length > 11) {
        NSString    * dateStr          =[model.time substringToIndex:12];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
        
        NSDate      *createDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",dateStr]];
        createDate              = [DataUsedEngine timeZoneChange:createDate];
        
        
        NSMutableArray *dayTimeTmpArray     = _timeAndNumDictionary[DAY_INDEXBUY][TIME_INDEXBUY];
        NSMutableArray *nightTImeTmpArray   = _timeAndNumDictionary[NIGHT_INDEXBUY][TIME_INDEXBUY];
        BOOL isDayOrNight                   = [self judgeDayOrNight:dayTimeTmpArray
                                                  IsDayArrayOrNight:YES
                                                         TimeOfData:createDate];
        if (isDayOrNight == NO) {
            dayOrNight = [self judgeDayOrNight:nightTImeTmpArray
                             IsDayArrayOrNight:NO
                                    TimeOfData:createDate];
        }
        else{
            dayOrNight = YES;
        }
    }
    //时间获取不到，补充默认
    else{
        NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"HH"];
        NSString    *dateStr            = [dateFormatter stringFromDate:[NSDate date]];
        
        if ([dateStr floatValue] >= 9 && [dateStr floatValue] <21) {
            dayOrNight = YES;
        }
        else {
            dayOrNight= NO;
        }
    }
}

-(BOOL)judgeDayOrNight:(NSMutableArray *)aTimeArray IsDayArrayOrNight:(BOOL)aDayOrNightArray TimeOfData:(NSDate *)aTimeOfData{
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMddHH:mm"];
    
    if (aDayOrNightArray) {
        BOOL aDayOrNight = NO;
        for (int i = 0; i<aTimeArray.count; i++) {
            if (i == 0) {
                NSString    *timeStr        = aTimeArray[i];
                timeStr                     = [timeStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSDate *dateOfArray         = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@%@",_datePrefix,timeStr]];
                dateOfArray                 = [DataUsedEngine timeZoneChange:dateOfArray];
                NSTimeInterval timeBetween  = [aTimeOfData timeIntervalSinceDate:dateOfArray];
                
                if (timeBetween <= 0) {
                    aDayOrNight = NO;
                }
                else{
                    aDayOrNight = YES;
                }
            }
            else if (i == aTimeArray.count-1){
                NSString    *timeStr        = aTimeArray[i];
                timeStr                     = [timeStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSDate *dateOfArray         = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@%@",_datePrefix,timeStr]];
                dateOfArray                 = [DataUsedEngine timeZoneChange:dateOfArray];
                NSTimeInterval timeBetween  = [aTimeOfData timeIntervalSinceDate:dateOfArray];
                
                if (timeBetween <= 0) {
                    aDayOrNight = YES;
                }
                else{
                    aDayOrNight = NO;
                }
            }
            else{
                aDayOrNight = YES;
            }
        }
        
        return aDayOrNight;
    }
    else{
        BOOL aDayOrNight = YES;
        for (int i = 0; i<aTimeArray.count; i++) {
            if (i == 0) {
                NSString    *timeStr        = aTimeArray[i];
                timeStr                     = [timeStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSDate *dateOfArray         = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@%@",_datePrefix,timeStr]];
                dateOfArray                 = [DataUsedEngine timeZoneChange:dateOfArray];
                NSTimeInterval timeBetween  = [aTimeOfData timeIntervalSinceDate:dateOfArray];
                
                if (timeBetween < 0) {
                    aDayOrNight = YES;
                }
                else{
                    aDayOrNight = NO;
                }
            }
        }
        return aDayOrNight;
    }
    
}

-(BOOL)isXHShareTimeConfiger{
    NSArray *timeLineTmpArray = [_productModel.timeline componentsSeparatedByString:@";"];
    NSMutableArray *timeLineArray = [NSMutableArray arrayWithArray:timeLineTmpArray];
    //现货9:00-6:00 无法解析问题
    for (int i = 0; i < timeLineArray.count ; i++) {
        if ([timeLineArray[i] isEqualToString:@""]) {
            [timeLineArray removeObjectAtIndex:i];
            break;
        }
    }
    if (timeLineArray.count == 2) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSDate *frontDate = [dateFormatter dateFromString:timeLineArray[0]];
        NSDate *betweenDate = [dateFormatter dateFromString:timeLineArray[1]];
        
        NSTimeInterval timeInterval  = [frontDate timeIntervalSinceDate:betweenDate];
        if (timeInterval > 0) {
            return YES;
        }
    }
    return NO;
}

//计算分时图点数
-(int)calculateNumCount{
    
    NSString *isDayOrNightStr = @"";
    
    if (dayOrNight) {
        isDayOrNightStr = @"day";
    }
    else{
        isDayOrNightStr = @"night";
    }
    
    int num = 0;
    
    for (int i = 0; i<[_timeAndNumDictionary[isDayOrNightStr][NUM_INDEXBUY] count]; i++) {
        num += [_timeAndNumDictionary[isDayOrNightStr][NUM_INDEXBUY][i] intValue];   //点数
    }
    
    return num;
}

#pragma mark -
#pragma mark K线图----

#pragma mark K线数据获取
-(void)getKLineData{
    //先获取数据库中最后一条数据的时间，然后取决于是否传时间字段
    NSString *time = @"";
    NSMutableArray *allArray = [KLineDao getAllKLineDataWithInstrumentID:self.productModel.instrumentID AndKLineMinute:[IndexSingleControl sharedInstance].klineTime];
    if (allArray != nil && allArray.count > 0) {
        KLineDataModel *klineDataModel = allArray.lastObject;
        time = klineDataModel.time;
    }
    
    if (firstLoadProgress == NO) {
        firstLoadProgress = YES;
    }
    
    [DataEngine requestToGetKLineWithType:self.productModel.instrumentID Time:time KLineMinute:[IndexSingleControl sharedInstance].klineTime successBlock:^(BOOL SUCCESS , NSMutableArray * dataArray) {
        if (SUCCESS) {
            if (dataArray != nil && dataArray.count > 0) {
                [_kMainView klineShowData:dataArray];
                [_kMainView updateWithMarket:marketisOpen];
                if (dataArray.count >= 5) {
                    [_kMainView moveLast:marketisOpen];
                }
                [KlineDataEngine klineDataFactory:dataArray WithInstrumentID:self.productModel.instrumentID completeBlock:^(){
//                    NSLog(@"存入数据库成功");
                }];
            }
            else{
                /**
                 *  更新数据
                 */
                [_kMainView klineShowData:dataArray];
                /**
                 *  整体刷新
                 */
                [_kMainView updateWithMarket:marketisOpen];
                [_kMainView timeChange];
            }
        }
        else{
            [_kMainView klineShowData:dataArray];
            [_kMainView updateWithMarket:marketisOpen];
            [_kMainView timeChange];
        }
    }];
}

-(void)kLineDataconfiger{
    double defaultUpperTmp = [_indexBuyModel.preClosePrice floatValue]+[_indexBuyModel.preClosePrice floatValue]*defaultRangSection;
    double defaultLowerTmp = [_indexBuyModel.preClosePrice floatValue] ;
    
    float rangeHeight = defaultUpperTmp - defaultLowerTmp;
    [_kMainView setKLineDefaultHeight:rangeHeight];
}

-(void)loadKLineView{
    
    IndexBuyView *indexBuyV             = self;
    
    _scrollView.scrollEnabled           = NO;
    _scrollView.userInteractionEnabled  = YES;
    
    float height = _scrollView.frame.size.height-20;
    if (ScreenHeigth <= 568) {
        height = height-20;
    }
    _kMainView                          = [[KMainView alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width*2,
                                                                                     0,
                                                                                     _scrollView.frame.size.width,
                                                                                     height)
                                                                 FloatNum:floatNum
                                                         WithInstrumentID:self.productModel.instrumentID];
    _kMainView.userInteractionEnabled   = YES;
    _kMainView.mainBeginBlock   = ^(KLineDataModel *klineModel){
        [indexBuyV beginChangeTitle:klineModel];
    };
    _kMainView.mainEndBlock     = ^(){
        [indexBuyV endChangeTitle];
    };
    [_scrollView addSubview:_kMainView];
}

-(void)beginChangeTitle:(KLineDataModel *)klineModel{
    if (_kLineTitleView == nil) {
        
        _kLineTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, self.superScrollView.frame.origin.y-64)];
        _kLineTitleView.backgroundColor = [UIColor blackColor];
        [self.superview.superview addSubview:_kLineTitleView];
        
        _kLineTitleTimeLabel                 = [[UILabel alloc]initWithFrame:CGRectMake(0, _kLineTitleView.frame.size.height/2 - 20/667.0*ScreenHeigth, ScreenWidth, 20/667.0*ScreenHeigth)];
        _kLineTitleTimeLabel.textAlignment   = NSTextAlignmentCenter;
        _kLineTitleTimeLabel.font            = [UIFont systemFontOfSize:11];
        _kLineTitleTimeLabel.textColor       = [UIColor whiteColor];
        _kLineTitleTimeLabel.numberOfLines   = 0;
//        _kLineTitleTimeLabel.backgroundColor = Color_black;
        [_kLineTitleView addSubview:_kLineTitleTimeLabel];
        
        _kLineTitlePriceLabel                   = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                                                           _kLineTitleView.frame.size.height/2,
                                                                                           ScreenWidth,
                                                                                           20/667.0*ScreenHeigth)];
        _kLineTitlePriceLabel.textAlignment     = NSTextAlignmentCenter;
        _kLineTitlePriceLabel.font              = [UIFont systemFontOfSize:11];
        _kLineTitlePriceLabel.textColor         = [UIColor whiteColor];
        _kLineTitlePriceLabel.numberOfLines     = 0;
//        _kLineTitlePriceLabel.backgroundColor   = Color_black;
        [_kLineTitleView addSubview:_kLineTitlePriceLabel];
    }
    
    if (klineModel.time.length >= 12) {
        NSString *time = klineModel.time;
        NSString *oneLineInfo = [NSString stringWithFormat:@"%@-%@ %@:%@ 成交量 %ld",[[time substringFromIndex:4] substringToIndex:2],[[time substringFromIndex:6] substringToIndex:2],[[time substringFromIndex:8] substringToIndex:2],[[time substringFromIndex:10] substringToIndex:2],klineModel.volume];
        NSString *twoLineInfo       = [NSString stringWithFormat:@"开盘%@ 最高%@ 最低%@ 收盘%@ ",
                                        [DataUsedEngine conversionFloatNum:klineModel.openPrice ExpectFloatNum:floatNum],
                                        [DataUsedEngine conversionFloatNum:klineModel.maxPrice ExpectFloatNum:floatNum],
                                        [DataUsedEngine conversionFloatNum:klineModel.minPrice ExpectFloatNum:floatNum],
                                        [DataUsedEngine conversionFloatNum:klineModel.closePrice ExpectFloatNum:floatNum]];
        _kLineTitleTimeLabel.text   = oneLineInfo;
        _kLineTitlePriceLabel.text  = twoLineInfo;
        _kLineTitlePriceLabel.textColor = [UIColor colorWithRed:77/255.0 green:177/255.0 blue:52/255.0 alpha:1];
        //225,39,44
        _kLineTitlePriceLabel.attributedText = [DataUsedEngine mutableFontAndColorArray:
                                                [NSMutableArray arrayWithObjects:
                                                 @"开盘",
                                                 [DataUsedEngine conversionFloatNum:klineModel.openPrice ExpectFloatNum:floatNum],
                                                 @" 最高",
                                                 [DataUsedEngine conversionFloatNum:klineModel.maxPrice ExpectFloatNum:floatNum],
                                                 @" 最低",
                                                 [DataUsedEngine conversionFloatNum:klineModel.minPrice ExpectFloatNum:floatNum],
                                                 @" 收盘",
                                                 [DataUsedEngine conversionFloatNum:klineModel.closePrice ExpectFloatNum:floatNum],
                                                 @" ",
                                                 nil]
                                                                              fontArray:nil
                                                                             colorArray:[NSMutableArray arrayWithObjects:
                                                                                         @"255/255/255/1",
                                                                                         @"225/39/44/1",
                                                                                         @"255/255/255/1",
                                                                                         @"225/39/44/1",
                                                                                         @"255/255/255/1",
                                                                                         @"77/177/52/1",
                                                                                         @"255/255/255/1",
                                                                                         @"77/177/52/1",
                                                                                         @"1/1/1/1",nil
                                                                                         ]];
        
//        if (_kLineTitleTimeLabel.center.x != ScreenWidth/2) {
//            static float point_X;
//            if (point_X > 0) {
//                float width                 = [Helper calculateTheHightOfText:_kLineTitleTimeLabel.text
//                                                                       height:_kLineTitleTimeLabel.frame.size.height
//                                                                         font:_kLineTitleTimeLabel.font];
//                _kLineTitleTimeLabel.frame  = CGRectMake(point_X, 0, width + 20, _kLineTitleTimeLabel.frame.size.height);
//            }
//            else{
//                float width                 = [Helper calculateTheHightOfText:_kLineTitleTimeLabel.text
//                                                                       height:_kLineTitleTimeLabel.frame.size.height
//                                                                         font:_kLineTitleTimeLabel.font];
//                _kLineTitleTimeLabel.frame  = CGRectMake(0, 0, width+20, _kLineTitleTimeLabel.frame.size.height);
//                point_X = _kLineTitleTimeLabel.frame.origin.x;
//            }
//        }
    }
    
}

-(void)endChangeTitle{
    [_kLineTitleView removeFromSuperview];
    _kLineTitleView = nil;
}


#pragma mark K线图下拉列表选择
- (void)resetPopover {
    self.popover = [DXPopover new];
    _popoverWidth = 100;
}

- (void)showPopover {
    [self updateTableViewFrame];
    
    UIButton   *btn = (UIButton *)[self viewWithTag:668];
    
    CGPoint startPoint =
    CGPointMake(CGRectGetMidX(btn.frame), CGRectGetMaxY(btn.frame) + 5);
    [self.popover showAtPoint:startPoint
               popoverPostion:DXPopoverPositionDown
              withContentView:self.tableView
                       inView:self];
    
    __weak typeof(self) weakSelf = self;
    self.popover.didDismissHandler = ^{
        UIButton *changeFrontBtn = [weakSelf getRecordButton];
        if (![weakSelf isChooseMinute]) {
            [weakSelf changeClick:changeFrontBtn];
        }
        [weakSelf bounceTargetView:btn];
    };
}

-(BOOL)isChooseMinute{
    return isChooseMinute;
}

-(UIButton *)getRecordButton{
    return _recordButton;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.configs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId];
        
        if (indexPath.row != 0) {
            UIView  *lineView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, self.tableView.frame.size.width-10, 0.5)];
            lineView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
            [cell addSubview:lineView];
        }
        
    }
    cell.textLabel.text = self.configs[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.backgroundColor = Color_Gold;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    isChooseMinute = YES;
    _recordButton = nil;
    
    _kLineTitle = self.configs[indexPath.row];
    
    UIButton    *btnChange = (UIButton *)[self viewWithTag:668];
    [btnChange setTitle:_kLineTitle forState:UIControlStateNormal];
    
    if (indexPath.row == 0) {
        [IndexSingleControl sharedInstance].klineTime = KLineMinute_1;
    } else if (indexPath.row == 1) {
        [IndexSingleControl sharedInstance].klineTime = KLineMinute_3;
    } else if (indexPath.row == 2) {
        [IndexSingleControl sharedInstance].klineTime = KLineMinute_5;
    } else if (indexPath.row == 3) {
        [IndexSingleControl sharedInstance].klineTime = KLineMinute_15;
    } else if (indexPath.row == 4) {
//        [KLineControl sharedInstance].klineTime = KLineMinute_30;
        [IndexSingleControl sharedInstance].klineTime = KLineMinute_Day;
    } else if (indexPath.row == 5) {
//        [KLineControl sharedInstance].klineTime = KLineMinute_Day;
    }
    [_kMainView loadDefaultView];
    [self.popover dismiss];
    
    UIButton *btn = [self viewWithTag:668];
    if (btn.titleLabel.text.length > 3) {
        UIImage *image = [UIImage imageNamed:@"klineboult_gold"];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, -40)];
    }
    else{
        UIImage *image = [UIImage imageNamed:@"klineboult_gold"];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, -35)];
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width*2, 0) animated:NO];
    
    showKLineData = YES;
    //K线移动到最后
    [_kMainView setLastMove];
    [_kMainView moveLast:marketisOpen];
    [self getDataTimer];
}

- (void)updateTableViewFrame {
    CGRect tableViewFrame           = self.tableView.frame;
    tableViewFrame.size.width       = _popoverWidth;
    self.tableView.frame            = tableViewFrame;
    self.popover.contentInset       = UIEdgeInsetsZero;
    self.popover.backgroundColor    = [UIColor whiteColor];
}

- (void)bounceTargetView:(UIView *)targetView {
    targetView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.3
          initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         targetView.transform = CGAffineTransformIdentity;
                     }
                     completion:nil];
}

#pragma mark 盘口

-(void)loadMarketInfo{
    _marketInfoView = [[IndexMarketInfoView alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width*3, 0, ScreenWidth, _scrollView.contentSize.height-50) ProductModel:self.productModel];
    [_scrollView addSubview:_marketInfoView];
}

#pragma mark -
#pragma mark 缓存

-(void)loadSharingData{
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    [self drawCacheLine:cacheModel.socketInfoDic[_socketInfoName]];
}

-(void)drawCacheLine:(NSMutableArray *)anArray{
    
    
    for(int i = 0;i < anArray.count; i++){
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:anArray[i]];
        dic[@"lastPrice"] = [NSString stringWithFormat:@"%@",dic[@"lastPrice"]];
        
        if (i == anArray.count-1) {
            _indexBuyModel.upperPrice = [DataUsedEngine conversionFloatNum:[dic[@"lastPrice"] floatValue] ExpectFloatNum:floatNum];
            [_priceArray addObject:[DataUsedEngine conversionFloatNum:[dic[@"lastPrice"] floatValue] ExpectFloatNum:floatNum]];
        }
    }
    [self rangeSection:anArray.lastObject];
    if (isDouble) {
        [_doubleMainView setUpperAndLowerLimitsWithUpper:[_indexBuyModel.upperPrice floatValue] Middle:[_indexBuyModel.lowerPrice floatValue] + ([_indexBuyModel.upperPrice floatValue]-[_indexBuyModel.lowerPrice floatValue])/2 Lower:[_indexBuyModel.lowerPrice floatValue]];
    }
    else{
        [_mainView setUpperAndLowerLimitsWithUpper:[_indexBuyModel.upperPrice floatValue] Middle:[_indexBuyModel.lowerPrice floatValue] + ([_indexBuyModel.upperPrice floatValue]-[_indexBuyModel.lowerPrice floatValue])/2 Lower:[_indexBuyModel.lowerPrice floatValue]];
    }
    
    if (_priceArray != nil && _priceArray.count > 0) {
        if (![_priceArray.lastObject isEqualToString:@"0.00"] || ![_priceArray.lastObject isEqualToString:@"0"] || ![_priceArray.lastObject isEqualToString:@"0.0"]) {
            
            if (isDouble) {
                [_doubleMainView setPriceArray:_upperPriceArray LowerPriceArray:_lowerPriceArray];
            }
            else{
                [_mainView setPriceArray:_priceArray];
            }
            //TotalMainView
            [_totalMainView setPriceArray:_priceArray];
        }
    }
    
}
#pragma mark 刷新数据
-(void)updateData{
    _indexBuyModel.currentPrice = [DataUsedEngine conversionFloatNum:_indexBuyModel.currentPrice.floatValue ExpectFloatNum:floatNum];
 
    if ([_indexBuyModel.changePercent rangeOfString:@"+"].location != NSNotFound) {
        _indexBuyModel.changePercent = [_indexBuyModel.changePercent stringByReplacingOccurrencesOfString:@"+" withString:@""];
    }
    if ([_indexBuyModel.changePercent rangeOfString:@"nan"].location != NSNotFound || [_indexBuyModel.changePercent rangeOfString:@"inf"].location != NSNotFound) {
        _indexBuyModel.changePercent = @"0.00%";
    }
    //判断是涨还是跌
    if ([_indexBuyModel.changePrice floatValue] >= 0) {
        _changeLabel.text = [NSString stringWithFormat:@"%@  +%@  +%@",_indexBuyModel.currentPrice,_indexBuyModel.changePrice,_indexBuyModel.changePercent];
    }
    else{
        _changeLabel.text = [NSString stringWithFormat:@"%@  %@  %@",_indexBuyModel.currentPrice,_indexBuyModel.changePrice,_indexBuyModel.changePercent];
    }
    
    //看多/看空
    _indexBuyModel.bullishBuyPrice =  [DataUsedEngine conversionFloatNum:_indexBuyModel.bullishBuyPrice.floatValue ExpectFloatNum:floatNum];
    _indexBuyModel.bearishAveragePrice = [DataUsedEngine conversionFloatNum:_indexBuyModel.bearishAveragePrice.floatValue ExpectFloatNum:floatNum];
    
    bullishBtnLabel.text = @"";
    bearishBtnLabel.text = @"";
    bullishBtnLabel.text = [NSString stringWithFormat:@"买多价%@",_indexBuyModel.bullishBuyPrice];
    bearishBtnLabel.text = [NSString stringWithFormat:@"买空价%@",_indexBuyModel.bearishAveragePrice];
    
    float bullishLightRedWidth = 0;
    
    if (bullishBtnLabel.text.length > 5) {
        NSArray *bullishPriceArray = [bullishBtnLabel.text componentsSeparatedByString:@"."];
        if (ScreenHeigth<667) {
            bullishBtnLabel.font = [UIFont systemFontOfSize:10];
            bullishBtnLabel.attributedText = [Helper multiplicityText:bullishBtnLabel.text from:3 to:(int)[bullishPriceArray[0] length]-3 font:17];
            
            bullishLightRedWidth += [Helper calculateTheHightOfText:@"买卖价" height:0 font:[UIFont systemFontOfSize:10]];
            bullishLightRedWidth += [Helper calculateTheHightOfText:_indexBuyModel.bullishBuyPrice height:0 font:[UIFont systemFontOfSize:17]];
        }
        else{
            bullishBtnLabel.attributedText = [Helper multiplicityText:bullishBtnLabel.text from:3 to:(int)[bullishPriceArray[0] length]-3 font:21];
            
            bullishLightRedWidth += [Helper calculateTheHightOfText:@"买卖价" height:0 font:[UIFont systemFontOfSize:13]];
            bullishLightRedWidth += [Helper calculateTheHightOfText:_indexBuyModel.bullishBuyPrice height:0 font:[UIFont systemFontOfSize:21]];
        }
        if (floatNum == 0) {
            bullishLightRedWidth += 10;
        }
    }
    bullishBtnLabel.bounds  = CGRectMake(0, 0, bullishLightRedWidth, bullishBtnLabel.bounds.size.height);
    lightningRedView.center = CGPointMake( bullishBtnLabel.frame.origin.x - lightningRedView.frame.size.width/2, bullishBtnLabel.frame.size.height/2+2);
    
    float bearishLightGreenWidth = 0;
    
    if (bearishBtnLabel.text.length > 5) {
        NSArray *bearishPriceArray = [bearishBtnLabel.text componentsSeparatedByString:@"."];
        if (ScreenHeigth < 667) {
            bearishBtnLabel.font = [UIFont systemFontOfSize:10];
            bearishBtnLabel.attributedText = [Helper multiplicityText:bearishBtnLabel.text from:3 to:(int)[bearishPriceArray[0] length]-3 font:17];
            
            bearishLightGreenWidth += [Helper calculateTheHightOfText:@"买卖价" height:0 font:[UIFont systemFontOfSize:10]];
            bearishLightGreenWidth += [Helper calculateTheHightOfText:_indexBuyModel.bullishBuyPrice height:0 font:[UIFont systemFontOfSize:17]];
        }
        else{
            bearishBtnLabel.attributedText = [Helper multiplicityText:bearishBtnLabel.text from:3 to:(int)[bearishPriceArray[0] length]-3 font:21];
            
            bearishLightGreenWidth += [Helper calculateTheHightOfText:@"买卖价" height:0 font:[UIFont systemFontOfSize:13]];
            bearishLightGreenWidth += [Helper calculateTheHightOfText:_indexBuyModel.bearishAveragePrice height:0 font:[UIFont systemFontOfSize:21]];
        }
        if (floatNum == 0) {
            bearishLightGreenWidth += 10;
        }
    }
    bearishBtnLabel.bounds    = CGRectMake(0, 0, bearishLightGreenWidth, bearishBtnLabel.bounds.size.height);
    lightningGreenView.center = CGPointMake( bearishBtnLabel.frame.origin.x - lightningGreenView.frame.size.width/2, bearishBtn.frame.size.height/2+2);

    
    if (isDouble) {
        [_doubleMainView setUpperAndLowerLimitsWithUpper:[_indexBuyModel.upperPrice floatValue] Middle:[_indexBuyModel.lowerPrice floatValue] + (([_indexBuyModel.upperPrice floatValue])-([_indexBuyModel.lowerPrice floatValue]))/2 Lower:([_indexBuyModel.lowerPrice floatValue])];
    }
    else{
        [_mainView setUpperAndLowerLimitsWithUpper:[_indexBuyModel.upperPrice floatValue] Middle:[_indexBuyModel.lowerPrice floatValue] + (([_indexBuyModel.upperPrice floatValue])-([_indexBuyModel.lowerPrice floatValue]))/2 Lower:([_indexBuyModel.lowerPrice floatValue])];
    }
    
    if (self.segSelectIndex == 0) {
        if (isDouble) {
            [_doubleMainView setPriceArray:_upperPriceArray LowerPriceArray:_lowerPriceArray];
        }
        else{
            [_mainView setPriceArray:_priceArray];
        }
    }
    
    //买卖量
    if (_indexBuyModel.bearishAverageNum.length>0 && _indexBuyModel.bullishBuyNum.length>0) {
        _buyNumLabel.text  = _indexBuyModel.bearishAverageNum;
        _saleNumLabel.text = _indexBuyModel.bullishBuyNum;
        
        if (!([_indexBuyModel.bullishBuyNum floatValue] == 0 && [_indexBuyModel.bearishAverageNum floatValue] == 0)) {
            float percent = [_indexBuyModel.bullishBuyNum floatValue]/([_indexBuyModel.bullishBuyNum floatValue] + [_indexBuyModel.bearishAverageNum floatValue]);
            
            _redCoverView.frame     = CGRectMake(_redCoverView.frame.origin.x,
                                             _redCoverView.frame.origin.y,
                                             _redView.frame.size.width*percent,
                                             _redCoverView.frame.size.height);
            _greenCoverView.frame   = CGRectMake(_greenCoverView.frame.origin.x,
                                                 _greenCoverView.frame.origin.y,
                                                 _greenView.frame.size.width*percent,
                                                 _greenCoverView.frame.size.height);
        }
    }
}

#pragma mark 加载底部视图

-(void)loadBottomView{
    //下个交易时间高度+持仓直播高度+买多买空高度
    float adapterHeight =self.frame.size.height - (30.0/667*ScreenHeigth + 36.0/568*ScreenHeigth + 36.0/568.0*ScreenHeigth + 5);
    
    //看多
    bullishBtn           = [UIButton buttonWithType:UIButtonTypeCustom];
    bullishBtn.frame     = CGRectMake(15,
                                    adapterHeight,
                                    (ScreenWidth-30/568.0*ScreenWidth)/2-15/568.0*ScreenWidth,
                                    36.0/568.0*ScreenHeigth);
    bullishBtn.clipsToBounds      = YES;
    bullishBtn.layer.cornerRadius = 3;
    [bullishBtn setBackgroundImage:[UIImage imageNamed:Image_Color_Red] forState:UIControlStateNormal];
    bullishBtn.titleLabel.font    = [UIFont systemFontOfSize:13];
    [bullishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bullishBtn addTarget:self action:@selector(bullishInside:) forControlEvents:UIControlEventTouchUpInside];
    bullishBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [bullishBtn addTarget:self action:@selector(backGroundChange:) forControlEvents:UIControlEventTouchDown];
    bullishBtn.tag = 90;
    [self addSubview:bullishBtn];
    
    
    bullishBtnLabel                 = [[UILabel alloc]initWithFrame:bullishBtn.bounds];
    bullishBtnLabel.text            = [NSString stringWithFormat:@"买多价%@",_indexBuyModel.bullishBuyPrice];
    bullishBtnLabel.textAlignment   = NSTextAlignmentCenter;
    bullishBtnLabel.font            = [UIFont systemFontOfSize:13];
    bullishBtnLabel.backgroundColor = [UIColor clearColor];
    [bullishBtn addSubview:bullishBtnLabel];
    
    float bullishLightRedWidth = 0;
    
    if (bullishBtnLabel.text.length > 5) {
        NSArray *bullishPriceArray = [bullishBtnLabel.text componentsSeparatedByString:@"."];
        if (ScreenHeigth<667) {
            bullishBtnLabel.font = [UIFont systemFontOfSize:10];
            bullishBtnLabel.attributedText = [Helper multiplicityText:bullishBtnLabel.text from:3 to:(int)[bullishPriceArray[0] length]-3 font:17];
            
            bullishLightRedWidth += [Helper calculateTheHightOfText:@"买卖价" height:0 font:[UIFont systemFontOfSize:10]];
            bullishLightRedWidth += [Helper calculateTheHightOfText:_indexBuyModel.bullishBuyPrice height:0 font:[UIFont systemFontOfSize:17]];
        }
        else{
            bullishBtnLabel.attributedText = [Helper multiplicityText:bullishBtnLabel.text from:3 to:(int)[bullishPriceArray[0] length]-3 font:21];
            
            bullishLightRedWidth += [Helper calculateTheHightOfText:@"买卖价" height:0 font:[UIFont systemFontOfSize:13]];
            bullishLightRedWidth += [Helper calculateTheHightOfText:_indexBuyModel.bullishBuyPrice height:0 font:[UIFont systemFontOfSize:21]];
        }
        
        if (floatNum == 0) {
            bullishLightRedWidth += 10;
        }
    }
    bullishBtnLabel.bounds = CGRectMake(0, 0, bullishLightRedWidth, bullishBtnLabel.bounds.size.height);
    
    
    //看空
    bearishBtn                      = [UIButton buttonWithType:UIButtonTypeCustom];
    bearishBtn.frame                = CGRectMake(ScreenWidth-15-bullishBtn.frame.size.width,
                                                 bullishBtn.frame.origin.y,
                                                 bullishBtn.frame.size.width,
                                                 36.0/568.0*ScreenHeigth);
    bearishBtn.clipsToBounds        = YES;
    bearishBtn.layer.cornerRadius   = 3;
    [bearishBtn setBackgroundImage:[UIImage imageNamed:Image_Color_Green] forState:UIControlStateNormal];
    bearishBtn.titleLabel.font      = [UIFont systemFontOfSize:13];
    [bearishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bearishBtn addTarget:self action:@selector(bearishInside:) forControlEvents:UIControlEventTouchUpInside];
    [bearishBtn addTarget:self action:@selector(backGroundChange:) forControlEvents:UIControlEventTouchDown];
    bearishBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    bearishBtn.tag = 91;
    [self addSubview:bearishBtn];
    
    bearishBtnLabel                 = [[UILabel alloc]initWithFrame:bearishBtn.bounds];
    if (isXH) {
        bearishBtnLabel.frame           = CGRectMake(0,
                                                     0,
                                                     bearishBtn.frame.size.width,
                                                     bearishBtn.frame.size.height);
    }
    else{
        bearishBtnLabel.frame           = CGRectMake(18/375.0*ScreenWidth,
                                                     0,
                                                     bearishBtn.frame.size.width-15,
                                                     bearishBtn.frame.size.height);
    }
    bearishBtnLabel.text            = [NSString stringWithFormat:@"买空价%@",_indexBuyModel.bearishAveragePrice];
    bearishBtnLabel.textAlignment   = NSTextAlignmentCenter;
    bearishBtnLabel.font            = [UIFont systemFontOfSize:13];
    bearishBtnLabel.backgroundColor = [UIColor clearColor];
    [bearishBtn addSubview:bearishBtnLabel];
    
    float bearishLightGreenWidth = 0;
    
    if (bearishBtnLabel.text.length > 5) {
        NSArray *bearishPriceArray = [bearishBtnLabel.text componentsSeparatedByString:@"."];
        if (ScreenHeigth < 667) {
            bearishBtnLabel.font = [UIFont systemFontOfSize:10];
            bearishBtnLabel.attributedText = [Helper multiplicityText:bearishBtnLabel.text from:3 to:(int)[bearishPriceArray[0] length]-3 font:17];
            
            bearishLightGreenWidth += [Helper calculateTheHightOfText:@"买卖价" height:0 font:[UIFont systemFontOfSize:10]];
            bearishLightGreenWidth += [Helper calculateTheHightOfText:_indexBuyModel.bullishBuyPrice height:0 font:[UIFont systemFontOfSize:17]];
        }
        else{
            bearishBtnLabel.attributedText = [Helper multiplicityText:bearishBtnLabel.text from:3 to:(int)[bearishPriceArray[0] length]-3 font:21];
            
            bearishLightGreenWidth += [Helper calculateTheHightOfText:@"买卖价" height:0 font:[UIFont systemFontOfSize:13]];
            bearishLightGreenWidth += [Helper calculateTheHightOfText:_indexBuyModel.bearishAveragePrice height:0 font:[UIFont systemFontOfSize:21]];
        }
        if (floatNum == 0) {
            bearishLightGreenWidth += 10;
        }
    }
    bearishBtnLabel.bounds = CGRectMake(0, 0, bearishLightGreenWidth, bearishBtnLabel.bounds.size.height);
    
    
    if (!isXH) {
        lightningRedView        = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 12/8*7, 18/8*7)];
        lightningRedView.image  = [UIImage imageNamed:@"lightning_red"];
        lightningRedView.userInteractionEnabled = YES;
        lightningRedView.center = CGPointMake( bullishBtnLabel.frame.origin.x - lightningRedView.frame.size.width/2, bullishBtnLabel.frame.size.height/2+2);
        [bullishBtn addSubview:lightningRedView];
        
        lightningGreenView          = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 12/8*7, 18/8*7)];
        lightningGreenView.image    = [UIImage imageNamed:@"lightning_green"];
        lightningGreenView.userInteractionEnabled = YES;
        lightningGreenView.center   = CGPointMake( bearishBtnLabel.frame.origin.x - lightningGreenView.frame.size.width/2, bearishBtn.frame.size.height/2+2);
        [bearishBtn addSubview:lightningGreenView];
        
        BOOL    isOpen = NO;
        CacheModel *cacheModel = [CacheEngine getCacheInfo];
        if (cacheModel.tradeDic[self.productModel.tradeDicName][kOrderQuickIsOpen] == nil || [cacheModel.tradeDic[self.productModel.tradeDicName][kOrderQuickIsOpen] isKindOfClass:[NSNull class]] || [cacheModel.tradeDic[self.productModel.tradeDicName][kOrderQuickIsOpen] isEqualToString:@"NO"]) {
            isOpen = NO;
        }
        else if ([cacheModel.tradeDic[self.productModel.tradeDicName][kOrderQuickIsOpen] isEqualToString:@"YES"] ){
            isOpen = YES;
        }
        else{
            isOpen = NO;
        }
        _orderLightningBtn                  = [UIButton  buttonWithType:UIButtonTypeCustom];
        _orderLightningBtn.backgroundColor  = [UIColor clearColor];
        _orderLightningBtn.frame            = CGRectMake(0, 0, (bullishBtn.frame.size.height+5)*58/48, bullishBtn.frame.size.height+5);
        _orderLightningBtn.center           = CGPointMake(ScreenWidth/2, bearishBtn.center.y);
        [_orderLightningBtn addTarget:self action:@selector(orderLightning) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_orderLightningBtn];
        
        
        _orderLightningBtn.userInteractionEnabled = YES;
        if (isOpen) {
            [_orderLightningBtn setImage:[UIImage imageNamed:@"order_lightning_on"] forState:UIControlStateNormal];
            [bullishBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [bearishBtn setBackgroundImage:nil forState:UIControlStateNormal];
            bullishBtn.layer.borderWidth = 1;
            bullishBtn.layer.borderColor = Color_red.CGColor;
            bearishBtn.layer.borderWidth = 1;
            bearishBtn.layer.borderColor = Color_green.CGColor;
            lightningRedView.hidden      = NO;
            lightningGreenView.hidden    = NO;
        }
        else{
            [_orderLightningBtn setImage:[UIImage imageNamed:@"order_lightning_off"] forState:UIControlStateNormal];
            [bullishBtn setBackgroundImage:[UIImage imageNamed:Image_Color_Red] forState:UIControlStateNormal];
            [bearishBtn setBackgroundImage:[UIImage imageNamed:Image_Color_Green] forState:UIControlStateNormal];
            bullishBtn.layer.borderWidth = 0;
            bearishBtn.layer.borderWidth = 0;
            lightningGreenView.hidden    = YES;
            lightningRedView.hidden      = YES;
        }
    }
    
    //下个交易时间
    UILabel *bargainLabel           = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                                               bearishBtn.frame.origin.y+bearishBtn.frame.size.height+5.0/568.0*ScreenHeigth,
                                                                               ScreenWidth,
                                                                               30.0/667*ScreenHeigth)];
    bargainLabel.textColor          = Color_red;
    bargainLabel.textAlignment      = NSTextAlignmentCenter;
    bargainLabel.font               = [UIFont boldSystemFontOfSize:13];
    bargainLabel.tag                = Tag_timeLabel_buy;
    [self addSubview:bargainLabel];
    
    UILabel * buyAndSaleLabel       = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    buyAndSaleLabel.text            = [NSString stringWithFormat:@"买卖量"];
    buyAndSaleLabel.font            = [UIFont boldSystemFontOfSize:10];
    buyAndSaleLabel.textAlignment   = NSTextAlignmentCenter;
    buyAndSaleLabel.textColor       = [UIColor blackColor];
    buyAndSaleLabel.center          = CGPointMake(ScreenWidth/2, bullishBtn.frame.origin.y-30.0/568.0*ScreenHeigth + (30.0/568.0*ScreenHeigth)/2);
    [self addSubview:buyAndSaleLabel];
    
    //卖量
    _buyNumLabel                    = [[UILabel alloc]initWithFrame:CGRectMake(
                                                                           buyAndSaleLabel.frame.origin.x-35,
                                                                           buyAndSaleLabel.frame.origin.y,
                                                                           35,
                                                                           buyAndSaleLabel.frame.size.height)];
    _buyNumLabel.textColor          = Color_red;
    _buyNumLabel.textAlignment      = NSTextAlignmentCenter;
    _buyNumLabel.font               = [UIFont boldSystemFontOfSize:12];
    [self addSubview:_buyNumLabel];
    
    //买量
    _saleNumLabel                   = [[UILabel alloc]initWithFrame:CGRectMake(buyAndSaleLabel.frame.origin.x+buyAndSaleLabel.frame.size.width,
                                                                               buyAndSaleLabel.frame.origin.y,
                                                                               35,
                                                                               buyAndSaleLabel.frame.size.height)];
    _saleNumLabel.textColor         = Color_green;
    _saleNumLabel.textAlignment     = NSTextAlignmentCenter;
    _saleNumLabel.font              = [UIFont boldSystemFontOfSize:12];
    [self addSubview:_saleNumLabel];
    
    if (isXH) {
        _buyNumLabel.frame          = CGRectMake(buyAndSaleLabel.frame.origin.x-48,
                                                 buyAndSaleLabel.frame.origin.y,
                                                 48,
                                                 buyAndSaleLabel.frame.size.height);
        _saleNumLabel.frame         = CGRectMake(buyAndSaleLabel.frame.origin.x+buyAndSaleLabel.frame.size.width,
                                                 buyAndSaleLabel.frame.origin.y,
                                                 48,
                                                 buyAndSaleLabel.frame.size.height);
    }
    
    _redView                    = [[UIView alloc]initWithFrame:CGRectMake(90, 0, _buyNumLabel.frame.origin.x-(90+3), 5)];
    _redView.backgroundColor    = Color_red;
    _redView.center             = CGPointMake(_redView.center.x, _buyNumLabel.center.y);
    [self addSubview:_redView];
    
    _redCoverView = [[UIView alloc]initWithFrame:_redView.frame];
    _redCoverView.backgroundColor = Color_grayDeep;
    [self addSubview:_redCoverView];
    
    _greenView = [[UIView alloc]initWithFrame:CGRectMake(_saleNumLabel.frame.origin.x+_saleNumLabel.frame.size.width+3,
                                                         0,
                                                         ScreenWidth-90-(_saleNumLabel.frame.origin.x+_saleNumLabel.frame.size.width+3),
                                                         5)];
    _greenView.backgroundColor      = Color_grayDeep;
    _greenView.center               = CGPointMake(_greenView.center.x, _saleNumLabel.center.y);
    [self addSubview:_greenView];
    
    _greenCoverView = [[UIView alloc]initWithFrame:_greenView.frame];
    _greenCoverView.backgroundColor = Color_green;
    [self addSubview:_greenCoverView];
    
    _redCoverView.frame             = CGRectMake(_redCoverView.frame.origin.x,
                                                 _redCoverView.frame.origin.y,
                                                 _redView.frame.size.width*0.7,
                                                 _redCoverView.frame.size.height);
    _greenCoverView.frame           = CGRectMake(_greenCoverView.frame.origin.x,
                                                 _greenCoverView.frame.origin.y,
                                                 _greenView.frame.size.width*0.7,
                                                 _greenCoverView.frame.size.height);
    
    
    float changeNum = 25;
    
    if (ScreenWidth <= 480) {
        changeNum = 18;
    }
    
    //涨跌
    _changeLabel                = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                                           buyAndSaleLabel.frame.origin.y-changeNum,
                                                                           ScreenWidth,
                                                                           30)];
    _changeLabel.textAlignment  = NSTextAlignmentCenter;
    _changeLabel.textColor      = [UIColor blackColor];
    _changeLabel.font           = [UIFont systemFontOfSize:15];
    //判断是涨还是跌
    
    if ([_indexBuyModel.changePercent rangeOfString:@"+"].location != NSNotFound) {
        _indexBuyModel.changePercent = [_indexBuyModel.changePercent stringByReplacingOccurrencesOfString:@"+" withString:@""];
    }
    if ([_indexBuyModel.changePercent rangeOfString:@"nan"].location != NSNotFound) {
        _indexBuyModel.changePercent = @"0.00%";
    }
    
    if ([_indexBuyModel.changePrice floatValue] >= 0) {
        _changeLabel.text = [NSString stringWithFormat:@"%@  +%@  +%@",_indexBuyModel.currentPrice,_indexBuyModel.changePrice,_indexBuyModel.changePercent];
    }
    else{
        _changeLabel.text = [NSString stringWithFormat:@"%@  %@  %@",_indexBuyModel.currentPrice,_indexBuyModel.changePrice,_indexBuyModel.changePercent];
    }
    [self addSubview:_changeLabel];
    
    /**
     *  非现货显示持仓时间和下个交易时间段
     */
    if (self.productModel.isXH != 1) {
        [self getAfternoonIsClear];
    }
    
    /**
     *  加载底部Bar  我的队伍、持仓直播、我的私聊
     */
    [self loadTabBar];
}

-(void)loadTabBar{
    
    self.bottomBgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 36.0/568*ScreenHeigth, ScreenWidth, 36.0/568*ScreenHeigth)];
    self.bottomBgView.backgroundColor = Color_grayDeep;
    [self addSubview:self.bottomBgView];
    
    UIView  *hlineView = [[UIView alloc]init];
    hlineView.frame = CGRectMake(0, 0, ScreenWidth, 1.5);
    hlineView.backgroundColor = Color_line;
    [self.bottomBgView addSubview:hlineView];
    
    NSArray *tabBarTitle = @[@" 金十财经",@"持仓直播"];
    NSArray *tabBarImg   = @[@"jinshicaijing_off",@"chicangzhibo_off"];
    
    for (int i = 0; i < 2; i++) {
        if (i == 0) {
            UIButton    *tabBarBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
            tabBarBtn.frame = CGRectMake(i * (ScreenWidth/2), hlineView.frame.origin.y+hlineView.frame.size.height, ScreenWidth/2, self.bottomBgView.frame.size.height - hlineView.frame.origin.y);
            [tabBarBtn setImage:[UIImage imageNamed:tabBarImg[i]] forState:UIControlStateNormal];
            [tabBarBtn setTitle:tabBarTitle[i] forState:UIControlStateNormal];
            tabBarBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [tabBarBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [tabBarBtn addTarget:self action:@selector(goldenFinancialClick) forControlEvents:UIControlEventTouchUpInside];
            [self.bottomBgView addSubview:tabBarBtn];
//            tabBarBtn.enabled = NO;
            
            /**
             *  竖线
             */
            UIView  *vlineView = [[UIView alloc]initWithFrame:CGRectMake(tabBarBtn.frame.origin.x + tabBarBtn.frame.size.width - 0.5,hlineView.frame.origin.y + 5, 1, tabBarBtn.frame.size.height - 10)];
            vlineView.backgroundColor = Color_line;
            [self.bottomBgView addSubview:vlineView];
        }
        
        /**
         *  持仓直播         *
         */
        
        if (i == 1) {
            _indexBuyTacticsButton          = [[IndexBuyTacticsButton alloc]initWithFrame:CGRectMake(i * (ScreenWidth/2), hlineView.frame.origin.y+hlineView.frame.size.height, ScreenWidth/2, self.bottomBgView.frame.size.height - hlineView.frame.origin.y)
                                                                             ProductModel:self.productModel
                                                                             CurrentPrice:_indexBuyModel.currentPrice];
            [self.bottomBgView addSubview:_indexBuyTacticsButton];
        }
    }
}

#pragma mark 金十财经
-(void)goldenFinancialClick{
    [[UIEngine sharedInstance] showAlertWithTitle:@"敬请期待" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:nil];
    [UIEngine sharedInstance].alertClick = ^(int aIndex){};
}

#pragma mark backgroundChange

-(void)backGroundChange:(UIButton *)btn{
    self.backGroundHeightBlock(btn);
}

#pragma mark -
#pragma mark 闪电下单

-(void)orderLightning{
    [self goNext:2];
}

#pragma mark 获取市场交易时段

-(void)getAfternoonIsClear{
    /**
     *  中午不清仓
     */
    NSDictionary *dicParam=@{
                             @"futuresType":self.productModel.instrumentCode,
                             };
    NSString     *urlParam=[NSString stringWithFormat:@"http://%@/market/market/getHoldTimeLast",HTTP_IP];
    [NetRequest postRequestWithNSDictionary:dicParam url:urlParam successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] integerValue] == 200) {
            if ([DataUsedEngine nullTrim:dictionary[@"data"]]&&[DataUsedEngine nullTrim:dictionary[@"data"][@"timestamp"]]) {
                long long timeInterval = [dictionary[@"data"][@"timestamp"] longLongValue];
                
                if ([SystemSingleton sharedInstance].timeInterval <  timeInterval) {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                    [dateFormatter setDateFormat:@"HH:mm:ss"];
                    NSDate  *americaDate = [NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
                    [IndexSingleControl sharedInstance].storaging = [NSString stringWithFormat:@"本时段持仓时间至%@",[dateFormatter stringFromDate:americaDate]];
                    UILabel *timeLabel = (UILabel *)[self viewWithTag:Tag_timeLabel_buy];
                    timeLabel.text = [IndexSingleControl sharedInstance].storaging;
                    marketisOpen = YES;
                    if (marketisOpen) {
                        [_indexBuyTacticsButton open];
                    }
                    else{
                        [_indexBuyTacticsButton close];
                    }
                }
                else{
                    [self getMarketEndTime];
                }
                
            }
            else{
                [self getMarketEndTime];
            }
        }
        else{
            [self getMarketEndTime];
        }
    } failureBlock:^(NSError *error) {
        /**
         *  接口失败，请求市场交易时段
         */
        [self getMarketEndTime];
    }];
}

-(void)getMarketEndTime{
    /**
     *  市场交易时段
     */
    NSDictionary *dic=@{
                        @"marketId":[NSNumber numberWithInt:[self.productModel.marketId intValue]],
                        };
    NSString     *url=[NSString stringWithFormat:@"http://%@/market/market/marketStatus",HTTP_IP];
    
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] integerValue] == 200) {
            
            NSMutableArray  *marketArray = [NSMutableArray arrayWithCapacity:0];
            
            for (int i = 0; i < [dictionary[@"data"] count]; i++) {
                MarketModel *marketModel    = [[MarketModel alloc]init];
                marketModel.desc            = dictionary[@"data"][i][@"desc"];
                marketModel.endTime         = [dictionary[@"data"][i][@"end_time"] longLongValue];
                marketModel.startTime       = [dictionary[@"data"][i][@"start_time"] longLongValue];
                marketModel.status          = [dictionary[@"data"][i][@"status"] intValue];
                marketModel.type            = [dictionary[@"data"][i][@"type"] intValue];
                [marketArray addObject:marketModel];
            }
            
            UILabel *timeLabel = (UILabel *)[self viewWithTag:Tag_timeLabel_buy];
            timeLabel.text = [self autoCalculateEndTime:marketArray];
            [IndexSingleControl sharedInstance].storaging = timeLabel.text;
        }
    } failureBlock:^(NSError *error) {
    }];
}

- (NSString *)autoCalculateEndTime:(NSMutableArray *)aMarketArray{
    
    NSString    *showStr = @"";
    NSMutableArray *infoArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<aMarketArray.count; i++) {
        MarketModel *marketModel        = aMarketArray[i];
        NSDate *startDate               = [NSDate dateWithTimeIntervalSince1970:marketModel.startTime/1000];
        NSDate *endDate                 = [NSDate dateWithTimeIntervalSince1970:marketModel.endTime/1000];
        NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        
        if (marketModel.status == 2 || marketModel.status == 3 ) {
            NSString *startDateStr  = [dateFormatter stringFromDate:startDate];
            NSString *endDateStr    = [dateFormatter stringFromDate:endDate];
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
                for (int i = 0; i<marketArray.count; i++) {
                    MarketModel *otherMarketModel = marketArray[i];
                    
                    if (otherMarketModel.startTime == marketModel.endTime || (otherMarketModel.startTime <= marketModel.endTime+10000 && otherMarketModel.startTime >= marketModel.endTime-10000)) {
                        
                        NSDate *startDate               = [NSDate dateWithTimeIntervalSince1970:otherMarketModel.startTime/1000];
                        NSDate *endDate                 = [NSDate dateWithTimeIntervalSince1970:otherMarketModel.endTime/1000];
                        NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc]init];
                        [dateFormatter setDateFormat:@"HH:mm:ss"];
                        NSString    *startStr           = [dateFormatter stringFromDate:startDate];
                        NSString    *endStr             = [dateFormatter stringFromDate:endDate];
                        
                        if (otherMarketModel.status != 0) {
                            showStr = [NSString stringWithFormat:@"下个交易时间为 %@—%@",startStr,endStr];
                            marketisOpen = NO;
                        }
                    }
                }
            }
            else{
                marketisOpen = YES;
                showStr = [NSString stringWithFormat:@"本时段持仓时间至%@",dateStr];
            }
        }
    }
    
    if (marketisOpen) {
        [_indexBuyTacticsButton open];
    }
    else{
        [_indexBuyTacticsButton close];
    }
    
    return showStr;
}

-(void)bullishInside:(UIButton *)btn{
    [self goNext:0];
}

-(void)bullishOutside:(UIButton *)btn{
    btn.backgroundColor = [UIColor grayColor];
}

-(void)bearishInside:(UIButton *)btn{
    [self goNext:1];
}

-(void)bearishOutside:(UIButton *)btn{
    btn.backgroundColor = [UIColor grayColor];
}

#pragma mark 是否打开快速下单

-(BOOL)isOpen{
    BOOL isOpen = NO;
    
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    if (cacheModel.tradeDic[self.productModel.tradeDicName][kOrderQuickIsOpen] == nil || [cacheModel.tradeDic[self.productModel.tradeDicName][kOrderQuickIsOpen] isKindOfClass:[NSNull class]] || [cacheModel.tradeDic[self.productModel.tradeDicName][kOrderQuickIsOpen] isEqualToString:@"NO"]) {
        isOpen = NO;
    }
    else if ([cacheModel.tradeDic[self.productModel.tradeDicName][kOrderQuickIsOpen] isEqualToString:@"YES"] ){
        isOpen = YES;
    }
    else{
        isOpen = NO;
    }
    return isOpen;
}

//0：看多  1：看空  2：快速下单
-(void)goNext:(int)aState{
    
    [UIEngine sharedInstance].progressStyle = 2;
    [[UIEngine sharedInstance] showProgress];
    [self getState:aState];
}

#pragma mark 获取合约状态

-(void)getState:(int)aState{
    
    BOOL    isQuickOrder = NO;
    
    if (aState == 2) {
        isQuickOrder = YES;
    }
    
    //aState:看多看空
    [DataEngine requestToGetFuturesState:_indexBuyModel.code completeBlock:^(BOOL SUCCESS, NSString *data) {
        if (![self isOpen]) {
            [[UIEngine sharedInstance] hideProgress];
        }
        if (SUCCESS) {
            
            int    result = 0;
            if ([data isEqualToString:@"9"]) {
                //闭市
                result = 2;
            }
            else if ([data isEqualToString:@"0"]){
                //可售
                result = 0;
            }
            else{
                //今日禁买
                result = 1;
            }
            
            self.block(_indexBuyModel,aState,result,isQuickOrder);
        
        }
        else{
            if (data != nil && data.length>0) {
//                [UIEngine showShadowPrompt:data];
            }
            
            self.block(_indexBuyModel,aState,0,isQuickOrder);
        }
    }];
}

-(void)disConnection{
    
    if (isDouble) {
        [_doubleMainView setUpperAndLowerLimitsWithUpper:[_indexBuyModel.upperPrice floatValue]
                                                  Middle:[_indexBuyModel.lowerPrice floatValue] + (([_indexBuyModel.upperPrice floatValue])-([_indexBuyModel.lowerPrice floatValue]))/2
                                                   Lower:([_indexBuyModel.lowerPrice floatValue])];
        
        [_doubleMainView setPriceArray:_upperPriceArray LowerPriceArray:_lowerPriceArray];
    }
    else {
        [_mainView setUpperAndLowerLimitsWithUpper:[_indexBuyModel.upperPrice floatValue]
                                            Middle:[_indexBuyModel.lowerPrice floatValue] + (([_indexBuyModel.upperPrice floatValue])-([_indexBuyModel.lowerPrice floatValue]))/2
                                             Lower:([_indexBuyModel.lowerPrice floatValue])];
        
        [_mainView setPriceArray:_priceArray];
    }
}

-(void)dealloc{
    [bullishBtn removeFromSuperview];
    [bullishBtnLabel removeFromSuperview];
    [bearishBtn removeFromSuperview];
    [bearishBtnLabel removeFromSuperview];
    [lightningRedView removeFromSuperview];
    [lightningGreenView removeFromSuperview];
    [_orderLightningBtn removeFromSuperview];
    [_buyNumLabel removeFromSuperview];
    [_saleNumLabel removeFromSuperview];
    [_redView removeFromSuperview];
    [_greenView removeFromSuperview];
    [_redCoverView removeFromSuperview];
    [_greenCoverView removeFromSuperview];
    [_changeLabel removeFromSuperview];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
