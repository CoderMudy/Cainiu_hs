//
//  IndexPositionDetailController.m
//  hs
//
//  Created by RGZ on 15/8/6.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "IndexPositionDetailController.h"
#import "MainView.h"
#import "MarketModel.h"
#import "NetRequest.h"
#import "TotalMainView.h"
#import "TimeSharingModel.h"
#import "IndexBuyCrossCurveView.h"

#define Tag_timeLabel_position  22

@interface IndexPositionDetailController ()
{
    UIScrollView    *_scrollView;
    IndexPositionDetailModel    *_positionDetailModel;//订单内容
    MainView        *_mainView;//图表视图
    IndexBuyModel   *_indexBuyModel;
    NSMutableArray  *_priceArray;//画点
    NSMutableArray  *_orderInfoArray;//订单信息：交易方向   交易数量  买入价  成交时间  触发止损  触发止盈
    UIButton        *_bottomButton;//平仓按钮
    UILabel         *_lucreLabel;//收益
    UILabel         *_signLabel;//收益前边的符号
    UILabel         *_priceLabel;//买入价--》当前价
    int             floatNum;//小数位数
    UIView          *_redView ;//买卖量
    UIView          *_redCoverView ;
    UIView          *_greenView ;
    UIView          *_greenCoverView ;
    UILabel         *_buyNumLabel;
    UILabel         *_saleNumLabel;
    UIScrollView    *_tableScrollView;//闪电图、分时图
    TotalMainView   *_totalMainView;
    NSMutableArray  *_minutePriceArray;//分时图数据数组
    int             _alertNum;//止损止盈弹窗显示次数
    NSTimer         *_timeSharingTimer;//分时图Timer
    float           defaultUpper;
    float           defaultLower;
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
    int             numCount;//分时图点数
    BOOL            dayOrNight;//分时图区分时间
    BOOL            isDouble;//闪电图是否双线
    float           defaultRangSection;//分时图默认区间
    NSMutableDictionary     *_timeAndNumDictionary;
    int             baseLineNum;//基线数
    NSString        *_datePrefix;
    NSString        *_lastTimeString;//现货09：00-06：00
}
@end

@implementation IndexPositionDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNav];
    
    [self loadData];
    
    [self loadNotification];
    
    [self loadUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
}

#pragma mark Nav

-(void)loadNav{
    
    self.view.backgroundColor = [UIColor colorWithRed:3/255.0 green:0 blue:20/255.0 alpha:1];
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    
    [self.view addSubview:navView];
    //Left Button
    UIImage *leftButtonImage = [UIImage imageNamed:@"return_1.png"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 59, 44)];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchDown];
    [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    leftButton.titleLabel.shadowColor = RGBACOLOR(117,38,0,1.0f);
    leftButton.titleLabel.shadowOffset= CGSizeMake(0, -1);
    leftButton.titleLabel.textColor = [UIColor whiteColor];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(15, 44/2-leftButtonImage.size.height/2, leftButtonImage.size.width, leftButtonImage.size.height)];
    image.image = [UIImage imageNamed:@"return_1"];
    image.userInteractionEnabled = YES;
    [leftButton addSubview:image];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftButtonClick)];
    [image addGestureRecognizer:tap];
    [navView addSubview:leftButton];
    
    
    UILabel  *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    nameLabel.text = [NSString stringWithFormat:@"%@ \n %@",self.name,self.code];
    nameLabel.font = [UIFont systemFontOfSize:10];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.numberOfLines = 0;
    nameLabel.attributedText = [Helper multiplicityText:nameLabel.text from:0 to:(int)self.name.length font:15];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:nameLabel];
    
}

-(void)leftButtonClick{
    [self end];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPositionBosomPage object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)end{
    [_timeSharingTimer invalidate];
}

-(void)start{
    [self loadTimeSharingData];
}

-(void)loadNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCloseConnection object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeConnection) name:kCloseConnection object:nil];
}

-(void)closeConnection{
    [_priceArray removeAllObjects];
    [_mainView setPriceArray:_priceArray];
}

#pragma mark  Data

-(void)loadData{
    _lastTimeString = @"";
    _alertNum = 1;
    _positionDetailModel = [[IndexPositionDetailModel alloc]init];
    _positionDetailModel.type = self.positionList.fundType;
    _positionDetailModel.buyPrice = self.positionList.buyPrice;
    //看多
    if (_positionDetailModel.tradeWay == 0) {
        _positionDetailModel.currentPrice = self.bidPrice;
    }
    //看空
    else if (_positionDetailModel.tradeWay == 1){
        _positionDetailModel.currentPrice = self.askPrice;
    }
    _positionDetailModel.tradeWay = self.positionList.tradeType;
    _positionDetailModel.tradeNum = self.positionList.count;
    _positionDetailModel.tradeTime = self.positionList.buyDate;
    _positionDetailModel.tradeTo = self.positionList.stopLoss;
    _positionDetailModel.tradeGet = self.positionList.stopProfit;
    
    _priceArray = [NSMutableArray arrayWithCapacity:0];
    _crossViewArray = [NSMutableArray arrayWithCapacity:0];
    _timeAndNumDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    
    floatNum = [self.productModel.decimalPlaces intValue];
    //双线闪电图配置
    if ([_productModel.isDoule intValue] == 1) {
        isDouble = YES;
    }
    dayOrNight = YES;//白天默认
    rangSection = [_productModel.interval floatValue]/2;//闪电图波动区间默认配置
    [self timeConfiger];//时间轴、点数计算
    defaultRangSection = [_productModel.scale floatValue]/100.0;//分时图默认区间
    baseLineNum = [_productModel.baseline intValue];//基线数
    
    //***************Data
    //交易方向
    NSString *tradeWay = @"";
    if (_positionDetailModel.tradeWay == 0) {
        tradeWay = @"看多";
    }
    else if (_positionDetailModel.tradeWay == 1){
        tradeWay = @"看空";
    }
    
    //交易数量
    NSString    *tradeNum = [NSString stringWithFormat:@"%d手",_positionDetailModel.tradeNum];
    
    //买入价
    NSString    *buyPrice = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[_positionDetailModel.buyPrice doubleValue]]];
    if(floatNum == 0){
        buyPrice = [buyPrice substringToIndex:buyPrice.length - 3];
    }
    else if (floatNum == 1){
        buyPrice = [buyPrice substringToIndex:buyPrice.length - 1];
    }
    else if (floatNum == 2){
        buyPrice = [buyPrice substringToIndex:buyPrice.length];
    }
    
    
    //成交时间
    NSString    *tradeTime = @"";
    if (_positionDetailModel.tradeTime.length > 8) {
        tradeTime = [NSString stringWithFormat:@"%@",[_positionDetailModel.tradeTime substringFromIndex:_positionDetailModel.tradeTime.length - 8]];
    }
    else{
        tradeTime = [NSString stringWithFormat:@"%@",_positionDetailModel.tradeTime];
    }
    
    //触发止损
    NSString    *tradeTo = @"";
    
    if (_positionDetailModel.tradeTo >= 0) {
        tradeTo = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",_positionDetailModel.tradeTo]];
        tradeTo = [NSString stringWithFormat:@"-%@",tradeTo];
    }
    else{
        tradeTo = [NSString stringWithFormat:@"%.2f",_positionDetailModel.tradeTo];
        tradeTo = [tradeTo stringByReplacingOccurrencesOfString:@"-" withString:@""];
        tradeTo = [DataEngine addSign:tradeTo];
        tradeTo = [NSString stringWithFormat:@"-%@",tradeTo];
    }
    
    //触发止盈
    NSString    *tradeGet = @"";
    tradeGet = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",_positionDetailModel.tradeGet]];
    
    //订单信息
    _orderInfoArray = [NSMutableArray arrayWithObjects:tradeWay,tradeNum,buyPrice,tradeTime,tradeTo,tradeGet, nil];
    
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:kPositionBosomPage object:nil];
    
    _indexBuyModel = [[IndexBuyModel alloc]init];
    if (_positionDetailModel.tradeWay == 0) {
        _indexBuyModel.currentPrice = self.bidPrice;
    }
    else if (_positionDetailModel.tradeWay == 1){
        _indexBuyModel.currentPrice = self.askPrice;
    }
    
    _indexBuyModel.upperPrice = [DataUsedEngine conversionFloatNum:[_indexBuyModel.currentPrice floatValue] + rangSection ExpectFloatNum:floatNum];
    _indexBuyModel.lowerPrice = [DataUsedEngine conversionFloatNum:[_indexBuyModel.currentPrice floatValue] - rangSection ExpectFloatNum:floatNum];
}

#pragma mark UI

-(void)loadUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = Color_black;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64)];
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeigth+64);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = Color_black;
    [self.view addSubview:_scrollView];
    
    [self loadSubUI];
}

-(void)loadSubUI{
    
    
    NSString    *typeStr = @"";
    
    if (_positionDetailModel.type == 0)
    {
        typeStr = self.productModel.currencyUnit;
    }
    else if (_positionDetailModel.type == 1){
        typeStr = @"积分";
    }
    
    //交易类型
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 72, 13)];
    typeLabel.text = [NSString stringWithFormat:@"持仓收益(%@)",typeStr];
    typeLabel.font = [UIFont systemFontOfSize:10];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.backgroundColor = [UIColor grayColor];
    typeLabel.center = CGPointMake(_scrollView.center.x, typeLabel.center.y);
    typeLabel.textColor = Color_black;
    typeLabel.clipsToBounds = YES;
    typeLabel.layer.cornerRadius = 2;
    [_scrollView addSubview:typeLabel];
    
    //收益
    _lucreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, typeLabel.frame.origin.y+typeLabel.frame.size.height+5, ScreenWidth, 50)];
    _lucreLabel.text = @"0";
    _lucreLabel.font = [UIFont systemFontOfSize:53];
    _lucreLabel.textAlignment = NSTextAlignmentCenter;
    if ([_lucreLabel.text floatValue] > 0) {
        _lucreLabel.textColor = Color_red;
    }
    else{
        _lucreLabel.textColor = Color_green;
    }
    _lucreLabel.text = [DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%ld",(long)[_lucreLabel.text integerValue]]];
    [_scrollView addSubview:_lucreLabel];
    
    //收益符号
    _signLabel = [[UILabel alloc]initWithFrame:CGRectMake(_lucreLabel.frame.origin.x-16, _lucreLabel.frame.origin.y, 16, 16)];
    _signLabel.text = @"—";
    _signLabel.font = [UIFont systemFontOfSize:27];
    _signLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_signLabel];
    
    
    //买入价--》当前价
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _lucreLabel.frame.size.height+_lucreLabel.frame.origin.y+8, ScreenWidth, 12)];
    _priceLabel.font = [UIFont systemFontOfSize:13];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.textColor = [UIColor grayColor];
    [_scrollView addSubview:_priceLabel];
    
    //买入价 --》当前价
    if (_positionDetailModel.tradeWay == 0) {
        //看多
        _priceLabel.text = [NSString stringWithFormat:@"%@ → %@",[DataUsedEngine conversionFloatNum:[_positionDetailModel.buyPrice doubleValue] ExpectFloatNum:floatNum],[DataUsedEngine conversionFloatNum:[self.bidPrice doubleValue] ExpectFloatNum:floatNum]];
    }
    else{
        //看空
        _priceLabel.text = [NSString stringWithFormat:@"%@ → %@",[DataUsedEngine conversionFloatNum:[_positionDetailModel.buyPrice doubleValue] ExpectFloatNum:floatNum],[DataUsedEngine conversionFloatNum:[self.askPrice doubleValue] ExpectFloatNum:floatNum]];
    }
    [self loadSharingView:_priceLabel.frame.size.height+_priceLabel.frame.origin.y];
}

#pragma mark 计算高度

-(CGFloat)getStringWidth:(NSString *)aString
{
    float height=0;
    height= [self getStringRect_:aString].width;
    return height+10;
}

- ( CGSize )getStringRect:( NSString *)aString
{
    CGSize  size;
    NSAttributedString * atrString = [[ NSAttributedString alloc ]  initWithString :aString];
    NSRange  range =  NSMakeRange ( 0 , atrString. length );
    NSDictionary * dic = [atrString  attributesAtIndex : 0   effectiveRange :&range];
    size=[aString boundingRectWithSize:CGSizeMake(ScreenWidth-40, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return   size;
}

- ( CGSize )getStringRect_:( NSString *)aString{
    CGSize  size;
    UIFont  *nameFont=[ UIFont   fontWithName : @"Helvetica"   size : 53 ];
    size=[aString  sizeWithFont :nameFont  constrainedToSize : CGSizeMake ( ScreenWidth -40,  50 )  lineBreakMode : NSLineBreakByCharWrapping ];
    return   size;
}

#pragma mark Sharing Plans

-(void)changeClick:(UIButton *)btn{
    UIButton    *btnChange1 = (UIButton *)[_scrollView viewWithTag:666];
    UIButton    *btnChange2 = (UIButton *)[_scrollView viewWithTag:667];
    UIView      *lineView   = (UIView   *)[_scrollView viewWithTag:668];
    
    [btnChange1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnChange2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btn setTitleColor:Color_Gold forState:UIControlStateNormal];
    lineView.center = CGPointMake(btn.center.x, lineView.center.y);
    
    if(btn.tag == 666){
        [_tableScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    else if (btn.tag == 667){
        [_tableScrollView setContentOffset:CGPointMake(_tableScrollView.bounds.size.width, 0) animated:NO];
    }
}

-(void)loadSharingView:(float)aPointY{
    
    UIButton    *defaultButton = nil;
    
    for (int i = 0 ; i < 2; i++) {
        UIButton    *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        changeBtn.frame = CGRectMake(20+i*(ScreenWidth-40)/2, aPointY+45.0/568*ScreenHeigth-25.0/568*ScreenHeigth, (ScreenWidth-40)/2, 30);
        changeBtn.tag = 666+i;
        if (i== 0) {
            [changeBtn setTitle:@"闪电图" forState:UIControlStateNormal];
            [changeBtn setTitleColor:Color_Gold forState:UIControlStateNormal];
        }
        else if (i == 1){
            [changeBtn setTitle:@"分时图" forState:UIControlStateNormal];
            [changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        changeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:10];
        [changeBtn addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:changeBtn];
        
        if (i == 0) {
            UIView  *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (ScreenWidth-40)/2-40.0/568*ScreenHeigth, 2)];
            lineView.center = CGPointMake(changeBtn.center.x, changeBtn.frame.origin.y+changeBtn.frame.size.height-8);
            lineView.backgroundColor = Color_Gold;
            lineView.tag = 668;
            [_scrollView addSubview:lineView];
        }
        
        if (i == 1) {
            defaultButton = changeBtn;
        }
    }
    
    _tableScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, aPointY+50.0/568*ScreenHeigth, self.view.frame.size.width, 180.0/568*ScreenHeigth+20)];
    _tableScrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _tableScrollView.pagingEnabled = YES;
    _tableScrollView.contentSize = CGSizeMake(ScreenWidth*2, _scrollView.bounds.size.height);
    _tableScrollView.delegate = self;
    _tableScrollView.showsHorizontalScrollIndicator = NO;
    _tableScrollView.showsVerticalScrollIndicator = NO;
    _tableScrollView.userInteractionEnabled = NO;
    [_scrollView addSubview:_tableScrollView];
    
    float height = 200.0;
    
    if (ScreenHeigth == 480) {
        height = 170.0;
    }
    
    //闪电图
    _mainView = [[MainView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height) PriceArray:_priceArray FloatNum:floatNum BaseLineNum:baseLineNum];
    _mainView.clipsToBounds = YES;
    [_tableScrollView addSubview:_mainView];
    [_mainView setUpperAndLowerLimitsWithUpper:[_indexBuyModel.upperPrice floatValue] Middle:[_indexBuyModel.lowerPrice floatValue] + ([_indexBuyModel.upperPrice floatValue]-[_indexBuyModel.lowerPrice floatValue])/2 Lower:[_indexBuyModel.lowerPrice floatValue]];
    
    //分时图
    _totalMainView = [[TotalMainView alloc]initWithFrame:CGRectMake(_scrollView.bounds.size.width, 0, self.view.frame.size.width, height) PriceArray:_priceArray FloatNum:floatNum InfoDic:_timeAndNumDictionary DayOrNight:YES BaseLine:baseLineNum];
    [_tableScrollView addSubview:_totalMainView];
    
    float       upperPrice = 0;
    float       lowerPrice = 0;
    upperPrice = [_indexBuyModel.currentPrice floatValue]+[_indexBuyModel.currentPrice floatValue]*(defaultRangSection) ;
    lowerPrice = [_indexBuyModel.currentPrice floatValue] ;
    defaultLower = lowerPrice;
    defaultUpper = upperPrice;
    [_totalMainView setUpperAndLowerLimitsWithUpper:upperPrice Middle:lowerPrice + (upperPrice-lowerPrice)/2 Lower:lowerPrice];

    [self loadTimeSharingData];
    
    [self loadBottomButton:_tableScrollView.frame.origin.y+_tableScrollView.frame.size.height];
    
    [self changeClick:defaultButton];
}

-(void)loadTimeSharingData{
    if(_timeSharingTimer != nil){
        [_timeSharingTimer invalidate];
        _timeSharingTimer = nil;
    }
    _timeSharingTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(getTimeSharingData) userInfo:nil repeats:YES];
    [_timeSharingTimer fire];
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
    
    if (_minutePriceArray == nil) {
        return;
    }
    
    if (_minutePriceArray.count == 0) {
        [_minutePriceArray addObject:_indexBuyModel.currentPrice];
        [_totalMainView addPrice:_minutePriceArray.lastObject];
        [_minutePriceArray removeLastObject];
    }
    else{
        [_minutePriceArray addObject:_indexBuyModel.currentPrice];
        [_totalMainView addPrice:_minutePriceArray.lastObject];
        [_minutePriceArray removeLastObject];
    }
    
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
    else{
        [_totalMainView setUpperAndLowerLimitsWithUpper:defaultUpper
                                                 Middle:defaultLower + (defaultUpper-defaultLower)/2
                                                  Lower:defaultLower];
    }
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
        _crossViewArray = timeSharingArray;
        
        //计算分时图区间
        if (timeSharingPriceArray.count > 0) {
            double upper = [timeSharingPriceArray[0] doubleValue];
            double lower = [timeSharingPriceArray[0] doubleValue];
            
            for (int i = 0; i<timeSharingPriceArray.count; i++) {
                if ([timeSharingPriceArray[i] floatValue] >= upper) {
                    upper = [timeSharingPriceArray[i] doubleValue];
                }
                if ([timeSharingPriceArray[i] floatValue] < lower) {
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
            //设置K线图区间
            //            [_kMainView setDefaultRange:rangeHeight];
        }
        
        //计算分时图点数
        numCount = [self calculateNumCount];
        
        //分时图数据加载
        [_totalMainView setUpperAndLowerLimitsWithUpper:defaultUpper Middle:defaultLower+(defaultUpper-defaultLower)/2 Lower:defaultLower];
        [_totalMainView setPriceModelArray:timeSharingArray];
        [self setMinuteArray:timeSharingPriceArray];
        
    }];
    [downloadTask resume];
    
    //更新“本时段持仓时间”
    [self getMarketEndTime];
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
    if (timeLineArray.count == 2) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSDate *frontDate = [dateFormatter dateFromString:timeLineArray[0]];
        NSDate *betweenDate = [dateFormatter dateFromString:timeLineArray[1]];
        
        NSTimeInterval timeInterval  = [frontDate timeIntervalSinceDate:betweenDate];
        if (timeInterval > 0) {
            state = 1;
            return state;
        }
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
            
            
            if (i >= timeLineArray.count-1-1) {
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
                
                if (timeBetween <= 0) {
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

//分时图所需价格数据
-(void)setMinuteArray:(NSMutableArray *)aPriceArray{
    _minutePriceArray = [NSMutableArray arrayWithArray:(NSArray *)aPriceArray];
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
    
    NSMutableArray *numArray = _timeAndNumDictionary[isDayOrNightStr][NUM_INDEXBUY];
    
    for (int i = 0; i< numArray.count; i++) {
        num += [_timeAndNumDictionary[isDayOrNightStr][NUM_INDEXBUY][i] intValue];   //点数
    }
    
    return num;
}

#pragma mark BottomButton

-(void)loadBottomButton:(float)aPointY{
    _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _bottomButton.frame = CGRectMake(20, aPointY+40.0/568*ScreenHeigth, ScreenWidth-40, 40);
    _bottomButton.backgroundColor = Color_red_pink;
    [_bottomButton setBackgroundImage:[UIImage imageNamed:Image_Color_Red_Pink] forState:UIControlStateNormal];
    [_bottomButton setTitle:@"平仓" forState:UIControlStateNormal];
    _bottomButton.clipsToBounds = YES;
    _bottomButton.adjustsImageWhenHighlighted = YES;
    _bottomButton.layer.cornerRadius = 3;
    _bottomButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bottomButton addTarget:self action:@selector(saleToGetSystemTime) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_bottomButton];
    
    //下个交易时间
    UILabel *bargainLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _bottomButton.frame.origin.y+_bottomButton.frame.size.height, ScreenWidth, _bottomButton.frame.size.height)];
        bargainLabel.text = @"";
    bargainLabel.textColor = Color_red;
    bargainLabel.textAlignment = NSTextAlignmentCenter;
    bargainLabel.font = [UIFont boldSystemFontOfSize:13];
    bargainLabel.tag = Tag_timeLabel_position;
    [_scrollView addSubview:bargainLabel];
    
    UILabel * buyAndSaleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _bottomButton.frame.origin.y-30, 30, 30)];
    buyAndSaleLabel.text = [NSString stringWithFormat:@"买卖量"];
    buyAndSaleLabel.font = [UIFont boldSystemFontOfSize:10];
    buyAndSaleLabel.textAlignment = NSTextAlignmentCenter;
    buyAndSaleLabel.textColor = Color_Gold;
    buyAndSaleLabel.center = CGPointMake(ScreenWidth/2, _bottomButton.frame.origin.y-15);
    [_scrollView addSubview:buyAndSaleLabel];
    
    //卖量
    _buyNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(buyAndSaleLabel.frame.origin.x-35, buyAndSaleLabel.frame.origin.y, 35, buyAndSaleLabel.frame.size.height)];
    _buyNumLabel.textColor = Color_red;
    _buyNumLabel.textAlignment = NSTextAlignmentCenter;
    _buyNumLabel.font = [UIFont boldSystemFontOfSize:12];
    [_scrollView addSubview:_buyNumLabel];
    
    //买量
    _saleNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(buyAndSaleLabel.frame.origin.x+buyAndSaleLabel.frame.size.width, buyAndSaleLabel.frame.origin.y, 35, buyAndSaleLabel.frame.size.height)];
    _saleNumLabel.textColor = Color_green;
    _saleNumLabel.textAlignment = NSTextAlignmentCenter;
    _saleNumLabel.font = [UIFont boldSystemFontOfSize:12];
    [_scrollView addSubview:_saleNumLabel];
    
    _redView = [[UIView alloc]initWithFrame:CGRectMake(20+70, 0, _buyNumLabel.frame.origin.x-(20+70+3), 5)];
    _redView.backgroundColor = Color_red;
    _redView.center = CGPointMake(_redView.center.x, _buyNumLabel.center.y);
    [_scrollView addSubview:_redView];
    
    _redCoverView = [[UIView alloc]initWithFrame:_redView.frame];
    _redCoverView.backgroundColor = Color_black;
    [_scrollView addSubview:_redCoverView];
    
    _greenView = [[UIView alloc]initWithFrame:CGRectMake(_saleNumLabel.frame.origin.x+_saleNumLabel.frame.size.width+3, 0, ScreenWidth-20-70-(_saleNumLabel.frame.origin.x+_saleNumLabel.frame.size.width+3), 5)];
    _greenView.backgroundColor = Color_black;
    _greenView.center = CGPointMake(_greenView.center.x, _saleNumLabel.center.y);
    [_scrollView addSubview:_greenView];
    
    _greenCoverView = [[UIView alloc]initWithFrame:_greenView.frame];
    _greenCoverView.backgroundColor = Color_green;
    [_scrollView addSubview:_greenCoverView];
    
    _redCoverView.frame = CGRectMake(_redCoverView.frame.origin.x, _redCoverView.frame.origin.y, _redView.frame.size.width*0.7, _redCoverView.frame.size.height);
    _greenCoverView.frame = CGRectMake(_greenCoverView.frame.origin.x, _greenCoverView.frame.origin.y, _greenView.frame.size.width*0.7, _greenCoverView.frame.size.height);
    [self loadBottomView:_bottomButton.frame.origin.y+_bottomButton.frame.size.height];
}

-(void)loadBottomView:(float)aPointY{
    UILabel *proLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, aPointY+42.0/568.0*ScreenHeigth, ScreenWidth, 12)];
    proLabel.text = @"订单信息";
    proLabel.textColor = [UIColor whiteColor];
    proLabel.font = [UIFont systemFontOfSize:10];
    proLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:proLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, proLabel.frame.size.height+proLabel.frame.origin.y+4, ScreenWidth-40, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [_scrollView addSubview:lineView];
    
    NSArray *titleArray = @[@"交易方向",@"交易数量",@"买入价",@"成交时间",@"触发止损",@"触发止盈"];
    
    for (int i = 0; i < 3; i++) {
        for (int j = 0 ; j < 2; j++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20+(ScreenWidth-40)/2*j, 1.0/568.0*ScreenHeigth+lineView.frame.size.height+lineView.frame.origin.y+28*i, (ScreenWidth-40)/2/3, 28)];
            label.text = titleArray[i*2+j];
            label.font = [UIFont boldSystemFontOfSize:10];
            label.textColor = K_color_gray;
            [_scrollView addSubview:label];
            
            UILabel *labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(20+(ScreenWidth-40)/2*j, 1.0/568.0*ScreenHeigth+lineView.frame.size.height+lineView.frame.origin.y+28*i, (ScreenWidth-40)/2-18, 28)];
            labelDetail.text = _orderInfoArray[i*2+j];
            labelDetail.backgroundColor = [UIColor clearColor];
            labelDetail.font = [UIFont systemFontOfSize:15];
            labelDetail.textAlignment = NSTextAlignmentRight;
            labelDetail.textColor = [UIColor whiteColor];
            [_scrollView addSubview:labelDetail];
        }
    }
    
    [self getMarketEndTime];
    
    [self uploadData];
    
}

#pragma mark 平仓
-(void)saleToGetSystemTime{
    
    [UIEngine sharedInstance].progressStyle = 2;
    [[UIEngine sharedInstance] showProgress];
    
    [DataEngine requestToGetSystemDateWithComplete:^(BOOL SUCCESS, NSString *data , NSString *timeInterval) {
        NSString    *time = @"";
        if (SUCCESS) {
            time = data;
        }
        else{
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            time = [dateFormatter stringFromDate:[NSDate date]];
        }
        [self saleGetJSONOrderIdWithSaletime:time];
    }];
}

#pragma mark 平仓__2__转换json格式的OrderId

- (void)saleGetJSONOrderIdWithSaletime:(NSString *)saleTime{
    NSMutableArray * orderIdArray =[NSMutableArray array];
    NSMutableString *cashMutableStr=[[NSMutableString alloc] initWithString:@""] ;
    NSMutableString *scoreMutableStr=[[NSMutableString alloc] initWithString:@""] ;
    NSString  * cashStr= @"";
    NSString  * scoreStr = @"";
    if (_positionDetailModel.type==0) {//现金
        if (self.positionList.listIdentifier) {
            [cashMutableStr  appendString:[NSString stringWithFormat:@"%.0f,",self.positionList.listIdentifier]];
        }
    }else if(_positionDetailModel.type ==1){//积分
        if (self.positionList.listIdentifier) {
            [scoreMutableStr appendString:[NSString stringWithFormat:@"%.0f,",self.positionList.listIdentifier]];
        }
    }
    if (cashMutableStr.length>0) {
        cashStr  = [cashMutableStr substringToIndex:cashMutableStr.length-1];
    }
    if (scoreMutableStr.length>0) {
        scoreStr  = [scoreMutableStr substringToIndex:scoreMutableStr.length-1];
    }
    NSDictionary * cashDic = @{@"fundType":@"0",@"orderId":cashStr};
    [orderIdArray addObject:cashDic];
    
    NSDictionary * scoreDic = @{@"fundType":@"1",@"orderId":scoreStr};
    [orderIdArray addObject:scoreDic];
    
    NSString * saleOrderId = [Helper toJSON:orderIdArray];
    [self saleWithTime:saleTime saleOrderId:saleOrderId isCheck:@"true"];
}


-(void)saleWithTime:(NSString   *)aTime saleOrderId:(NSString *)saleOrderId isCheck:(NSString*)isCheck{
    NSString *price = @"";
    if (_positionDetailModel.tradeWay == 0) {
        price = self.bidPrice;
    }
    else{
        price = self.askPrice;
    }
    __block NSString* saleDateB = aTime;
    __block NSString* saleOrderIdB = saleOrderId;
    
    
    [DataEngine requestToSaleWithID:saleOrderId type:self.positionList.fundType price:price date:aTime isCheck:(NSString*)isCheck successBlock:^(BOOL SUCCESS, NSString * code, NSDictionary  *dictionary) {
        NSString * msg = [NSString stringWithFormat:@"%@",dictionary[@"msg"]];
        [[UIEngine sharedInstance] hideProgress];
        if (SUCCESS) {
            switch ([code intValue]) {
                case 200:{
                    [self success];
                }
                    break;
                case 44032:{
                    
                    
                    NSMutableArray *msgArray = [NSMutableArray arrayWithArray:[msg componentsSeparatedByString:@"|"]];
                    NSString * cashProfit = [NSString stringWithFormat:@"%@",dictionary[@"data"][@"cashLossProfit"]];
                    NSString * scoreProfit =[NSString stringWithFormat:@"%@",dictionary[@"data"][@"scoreLossProfit"]];
                    NSString * unit = _productModel.currencyUnit;// [Helper unitWithCurrency:_productModel.currency];
                    
                    cashProfit = [[DataEngine sharedInstance] trimString:cashProfit];
                    scoreProfit = [[DataEngine sharedInstance] trimString:scoreProfit];
                    
                    [[UIEngine sharedInstance] showAlertWithSellingWithTitle:[[DataEngine sharedInstance] trimString:msgArray[0]]  Message:[[DataEngine sharedInstance] trimString:msgArray[1]] Money:cashProfit MoneyUnit:unit Integral:scoreProfit];
                   [UIEngine sharedInstance].alertClick = ^(int aIndex){
                        
                        switch (aIndex) {
                            case 10087:
                            {
                                //重新发送平仓请求
                                [self saleWithTime:saleDateB saleOrderId:saleOrderIdB isCheck:@"false"];
                            }
                                break;
                                
                            default:
                                break;
                        }
                    };

                }
                    break;
//                case 201:{
//                    [self success];//平仓中(成功)
//                }
//                    break;
//                case 440016:{
//                    [self other:msg];//非法订单
//                }
//                    break;
//                case 44001:{
//                    [self problem];
//                }
//                    break;
                default:{
//                    [self fail];
                    [self other:msg];
                }
                    break;
            }
        }
        else{
            [self fail];
        }
    }];
}

//订单id部位空
-(void)problem{
    [[UIEngine sharedInstance] showAlertWithTitle:@"订单出现问题" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
    [UIEngine sharedInstance].alertClick=^(int aIndex){
    };
}

-(void)ing{
    [[UIEngine sharedInstance] showAlertWithTitle:@"系统平仓中" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
    [UIEngine sharedInstance].alertClick=^(int aIndex){
    };
}

-(void)other:(NSString *)aMsg{
    if (aMsg == nil || [aMsg isKindOfClass:[NSNull class]]) {
        aMsg = @"";
    }
    [[UIEngine sharedInstance] showAlertWithTitle:aMsg ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
    [UIEngine sharedInstance].alertClick=^(int aIndex){
    };
}

-(void)success{
    [[UIEngine sharedInstance] showAlertWithTitle:@"申报成功" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
    [UIEngine sharedInstance].alertClick=^(int aIndex){
        if (aIndex == 10086) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kPositionBosomPage object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
}

-(void)fail{
    [[UIEngine sharedInstance] showAlertWithTitle:@"申报失败" ButtonNumber:2 FirstButtonTitle:@"放弃" SecondButtonTitle:@"再次提交"];
    [UIEngine sharedInstance].alertClick=^(int aIndex){
        if (aIndex == 10087) {
            [self saleToGetSystemTime];
        }
    };
}

#pragma mark 更新数据

-(void)uploadData{
    //收益
    double lucre = 0;
    //黄金
    if (_positionDetailModel.tradeWay == 0) {
        //看多
        lucre = [self.productModel.multiple doubleValue] * ([self.bidPrice doubleValue] - [_positionDetailModel.buyPrice doubleValue]);
    }
    else if(_positionDetailModel.tradeWay == 1){
        //看空
        lucre = [self.productModel.multiple doubleValue] * ([_positionDetailModel.buyPrice doubleValue] - [self.askPrice doubleValue]);
    }
    [self checkLossOrProfit:lucre];//检查止盈止损
    
    NSString    *lucreStr ;
    if ([self.code rangeOfString:@"CN"].location != NSNotFound) {
        lucreStr = [NSString stringWithFormat:@"%.1lf",lucre];
    }
    else{
        lucreStr = [NSString stringWithFormat:@"%.0lf",lucre];
    }
    
    NSString    *signStr = @"+";
    if ([lucreStr rangeOfString:@"-"].location != NSNotFound) {
        signStr = @"—";
        lucreStr = [lucreStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    lucreStr = [DataEngine countNumAndChangeformat:lucreStr];
    float lucreWidth = [self getStringWidth:lucreStr] + 8;
    
    _lucreLabel.bounds = CGRectMake(0,0,lucreWidth, _lucreLabel.bounds.size.height);
    _lucreLabel.center = CGPointMake(_scrollView.center.x, _lucreLabel.center.y);
    _lucreLabel.text = lucreStr;
    
    _signLabel.frame = CGRectMake(_lucreLabel.frame.origin.x-_signLabel.frame.size.width, _lucreLabel.frame.origin.y, _signLabel.frame.size.width, _signLabel.frame.size.height);
    _signLabel.text = signStr;
    
    if ([signStr isEqualToString:@"+"]) {
        _lucreLabel.textColor = Color_red_pink;
        _signLabel.textColor = Color_red_pink;
        _bottomButton.backgroundColor = Color_red_pink;
        [_bottomButton setBackgroundImage:[UIImage imageNamed:Image_Color_Red_Pink] forState:UIControlStateNormal];
    }
    else if ([signStr isEqualToString:@"-"]||[signStr isEqualToString:@"—"]){
        _lucreLabel.textColor = Color_green;
        _signLabel.textColor = Color_green;
        _bottomButton.backgroundColor = Color_green;
        [_bottomButton setBackgroundImage:[UIImage imageNamed:Image_Color_Green] forState:UIControlStateNormal];
    }
    
    //买入价 --》当前价
    if (_positionDetailModel.tradeWay == 0) {
        //看多
        _priceLabel.text = [NSString stringWithFormat:@"%@ → %@",[DataUsedEngine conversionFloatNum:[_positionDetailModel.buyPrice doubleValue] ExpectFloatNum:floatNum],[DataUsedEngine conversionFloatNum:[self.bidPrice doubleValue] ExpectFloatNum:floatNum]];
    }
    else{
        //看空
        _priceLabel.text = [NSString stringWithFormat:@"%@ → %@",[DataUsedEngine conversionFloatNum:[_positionDetailModel.buyPrice doubleValue] ExpectFloatNum:floatNum],[DataUsedEngine conversionFloatNum:[self.askPrice doubleValue] ExpectFloatNum:floatNum]];
    }
    
    //买卖量
    if (_indexBuyModel.bearishAverageNum.length>0 && _indexBuyModel.bullishBuyNum.length>0) {
        _buyNumLabel.text = _indexBuyModel.bearishAverageNum;
        _saleNumLabel.text = _indexBuyModel.bullishBuyNum;
        
        float percent = [_indexBuyModel.bullishBuyNum floatValue]/([_indexBuyModel.bullishBuyNum floatValue] + [_indexBuyModel.bearishAverageNum floatValue]);
        
        _redCoverView.frame = CGRectMake(_redCoverView.frame.origin.x, _redCoverView.frame.origin.y, _redView.frame.size.width*percent, _redCoverView.frame.size.height);
        _greenCoverView.frame = CGRectMake(_greenCoverView.frame.origin.x, _greenCoverView.frame.origin.y, _greenView.frame.size.width*percent, _greenCoverView.frame.size.height);
    }
    
    //***********MainView
    [self rangeSection:[NSString stringWithFormat:@"%.2lf",[_indexBuyModel.currentPrice doubleValue]]];
    [_mainView setUpperAndLowerLimitsWithUpper:[_indexBuyModel.upperPrice floatValue] Middle:[_indexBuyModel.lowerPrice floatValue] + (([_indexBuyModel.upperPrice floatValue])-([_indexBuyModel.lowerPrice floatValue]))/2 Lower:([_indexBuyModel.lowerPrice floatValue])];
    //***********TotalMainView
    
    if (_priceArray.count == 0 || _priceArray.count == 1) {
        [_priceArray addObject:[NSString stringWithFormat:@"%.2lf",[_indexBuyModel.currentPrice doubleValue]]];
    }
    if(_priceArray.count>200){
        [_priceArray removeObjectAtIndex:0];
    }
    [_mainView setPriceArray:_priceArray];
}
#pragma mark - 检查是否止盈／损

- (void)checkLossOrProfit:(float)lucre{
    if (lucre>=_positionList.stopProfit&&lucre>0) {
        [self searchOrderState:_positionList saleStyle:1];
    }
    if (lucre<=_positionList.stopLoss*(-1)&&lucre<0) {
        [self searchOrderState:_positionList saleStyle:2];
    }
}
- (void)searchOrderState:(IndexPositionList*)orderModel saleStyle:(int)saleStyle//saleStyle(1:止盈，2:止损)
{
    if (_alertNum>=2) {
        return;
    }else{
        _alertNum ++;
    }
    NSString * str = [Helper toJSON:[NSArray arrayWithObject:[NSNumber numberWithInt:orderModel.listIdentifier]]];
    
    NSDictionary * reqDic = @{@"token":[[CMStoreManager sharedInstance]getUserToken],
                              @"fundType":[NSNumber numberWithInt:orderModel.fundType],
                              @"futuredOrderIdsStr":str,
                              @"version":VERSION
                              };
    __block int style= saleStyle;//saleStyle(1:止盈，2:止损)
    
    NSString * urlStr = K_order_orderState;
    
    [NetRequest postRequestWithNSDictionary:reqDic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"]intValue]==200) {
            NSArray * array = dictionary[@"data"];
            NSDictionary * stateIdDic = array.lastObject;
            int status = [stateIdDic[@"status"] intValue];
            if (status == 6) {
                NSString * alertShowText;
                if (style==1) {
                    alertShowText = @"当前订单触及止盈线\n已被系统平仓";
                }
                else{
                    alertShowText = @"当前订单触及止损线\n已被系统平仓";
                }
                PopUpView * saleAlert = [[PopUpView alloc] initShowAlertWithShowText:alertShowText setBtnTitleArray:@[@"确定"]];
                saleAlert.confirmClick=^(UIButton*button){
                    [self.navigationController popViewControllerAnimated:YES];
                };
                [self.navigationController.view addSubview:saleAlert];
            }else{
                _alertNum--;
            }
        }else{
            _alertNum--;
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        _alertNum--;
    }];
}

-(void)rangeSection:(NSString *)aPrice{
    //计算上下区间
    if ([aPrice floatValue] >= [_indexBuyModel.upperPrice floatValue]) {
        _indexBuyModel.upperPrice = [DataUsedEngine conversionFloatNum:[aPrice floatValue] +rangSection ExpectFloatNum:floatNum];
        _indexBuyModel.lowerPrice = [DataUsedEngine conversionFloatNum:[aPrice floatValue] -rangSection ExpectFloatNum:floatNum];
    }
    else if ([aPrice floatValue] <= [_indexBuyModel.lowerPrice floatValue]){
        _indexBuyModel.upperPrice = [DataUsedEngine conversionFloatNum:[aPrice floatValue] +rangSection ExpectFloatNum:floatNum];
        _indexBuyModel.lowerPrice = [DataUsedEngine conversionFloatNum:[aPrice floatValue] -rangSection ExpectFloatNum:floatNum];
    }
}

-(void)getNotification:(NSNotification *)notify{
    NSDictionary    * infoDic = notify.object;
    
    if ([infoDic[@"code"] rangeOfString:self.code].location != NSNotFound) {
        if (_positionDetailModel.tradeWay == 0) {
            //看多取的价
            self.bidPrice = infoDic[@"bidPrice"];
            _indexBuyModel.currentPrice = infoDic[@"bidPrice"];
            [_priceArray addObject:[DataUsedEngine conversionFloatNum:[self.bidPrice floatValue] ExpectFloatNum:floatNum]];
        }
        else if (_positionDetailModel.tradeWay == 1){
            //看空取的价
            self.askPrice = infoDic[@"askPrice"];
            _indexBuyModel.currentPrice = infoDic[@"askPrice"];
            [_priceArray addObject:[DataUsedEngine conversionFloatNum:[self.askPrice floatValue] ExpectFloatNum:floatNum]];
        }
        _indexBuyModel.bullishBuyNum = infoDic[@"saleNum"];
        _indexBuyModel.bearishAverageNum = infoDic[@"buyNum"];
        
        [self uploadData];
        //分时图实时跳动
        [self changeLastInfo];
    }
    else{
        NSLog(@"持仓内页错误code（数据匹配错误）");
    }
}

#pragma mark 获取市场交易时段
-(void)getMarketEndTime{
            
            UILabel *timeLabel = (UILabel *)[_scrollView viewWithTag:Tag_timeLabel_position];
            timeLabel.text = [IndexSingleControl sharedInstance].storaging;
    
    if (timeLabel.text != nil && [timeLabel.text rangeOfString:@"下个交易时间"].location != NSNotFound) {
        [self end];
    }
           
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
