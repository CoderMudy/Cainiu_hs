//
//  orderPage.m
//  hs
//
//  Created by PXJ on 15/5/28.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "orderPage.h"
#import "PositionViewController.h"
#import "DetailViewController.h"
#import "NetRequest.h"
#import "MoneyDetaillViewController.h"
#import "PagePayModel.h"

#import "StockOrderModel.h"

#define GrayColor RGBCOLOR(91, 91, 91);

#define iPhone4s ([UIScreen mainScreen].bounds.size.height <=480)

@interface orderPage()
{
    NSNotification * _notification;

    //轮询下单结果
    NSTimer     *_timer;
    
    //购买股票的参数
    NSString * _quantity;       //买入股数
    NSString  * _buy_type;      //购买类型 （积分，现金）
    NSString * _priceID;        //选择额度的ID
    NSString * _payFee;         //保证金
    NSString * _money;          //交易本金
    NSString * _systemTime;     //用户下单时间（系统时间）
    
    UIScrollView *_scrollView;
    UIView       *_backGroundView;
    
    //*************start************
    //选择倍数的属性需求
    UIImageView *_pointImageView ;
    int         selectCount;
    int         multiple;
    UILabel     *_proLabel;
    UIView      *bottomView;
    
    //倍数红色数字的数组
    NSMutableArray *_redMoneyFontArray;
    NSMutableArray *_redIntegralFontArray;
    //************* end ************
    
    
    
    //现金
    StockOrderModel *_moneyModel;
    //积分
    StockOrderModel *_integralModel;
    //积分人配资额度配置
    NSMutableArray  *_moneyStockArray;
    NSMutableArray  *_integralStockArray;
    //允许最大亏损
    UILabel         *_deficitLabel;
    
    //交易本金
    UILabel         *_capitalMoneyLabel;
    //配资比例
    UILabel         *_capitalScaleLabel;
    
    //点击导航栏切换现金积分
    int         isIntegral;
    
    //代扣交易综合费
    UIButton        *_withHoldBtn;
    //下单
    UIButton        *_orderButton;
    
    //滑块选择倍数的View
    UIView          *_slideView;
    //同意按钮
    UIButton        *_agreeBtn;
    //倒计时5秒
    int             time;
    
    
    //活动
    //应扣服务费
    UILabel         *_activityServiceMoneyLabel;
    //优惠图标
    UILabel         *_activityPreferentialLabel;
    
    UISegmentedControl *seg;
}
@end

@implementation orderPage

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadNav];
    
    
    [self loadUI];
    
    [self loadData];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[UIEngine sharedInstance] hideProgress];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

#pragma mark -
#pragma mark Nav

-(void)loadNav{
//    [self.view setBackgroundColor:RGBCOLOR(244, 244, 244)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    
    [self.view addSubview:navView];
    
    //Left Button
    
    UIImage *leftButtonImage = [UIImage imageNamed:@"return_3.png"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 44, 44)];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchDown];
    [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    leftButton.titleLabel.shadowColor = RGBACOLOR(117,38,0,1.0f);
    leftButton.titleLabel.shadowOffset= CGSizeMake(0, -1);
    leftButton.titleLabel.textColor = [UIColor whiteColor];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44/2-leftButtonImage.size.height/2, leftButtonImage.size.width, leftButtonImage.size.height)];
    image.image = [UIImage imageNamed:@"return_3"];
    image.userInteractionEnabled = YES;
    [leftButton addSubview:image];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftButtonClick)];
    [image addGestureRecognizer:tap];

    [navView addSubview:leftButton];
    
    seg = [[UISegmentedControl alloc]initWithItems:@[@"现金支付",@"积分模拟"]];
    seg.frame = CGRectMake(ScreenWidth/2-ScreenWidth/5*2/2, 12, ScreenWidth/5*2, 20);
    seg.selectedSegmentIndex = 0;
    [seg addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventValueChanged];
    seg.tintColor = CanSelectButBackColor;
    [navView addSubview:seg];
    
    if(self.usedMoney != nil && [self.usedMoney floatValue]<=0 && self.usedIntegral != nil &&[self.usedIntegral floatValue]>0){
        isIntegral = 1;
        seg.selectedSegmentIndex = 1;
    }
    else{
        isIntegral = 0;
    }
    

    
}

-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)segClick:(UISegmentedControl *)seg{
    
    isIntegral = (int)seg.selectedSegmentIndex;
    
//    selectCount = 2;
    
    //配置可选倍数
    [self chooseMultipleConfigur];
    
    [self updateData];
    
    [self touchEnd];
    //去除代扣交易综合费窗口
    [self unLoadWithHold];
}



#pragma mark -
#pragma mark Data

-(void)loadData{
    _notification = [NSNotification notificationWithName:@"changePagePosition" object:self userInfo:nil];
    
    time                            = 0;
    _buy_type                       =@"0";
    _payFee                         = @"200";
    _priceID                        = @"14";
    _money                          = @"2000";
    
    _moneyStockArray = [NSMutableArray arrayWithCapacity:0];
    _integralStockArray = [NSMutableArray arrayWithCapacity:0];
    //选择倍数红字
    _redMoneyFontArray = [NSMutableArray arrayWithCapacity:0];
    _redIntegralFontArray = [NSMutableArray arrayWithCapacity:0];
    
    selectCount = 5;
    
    //获取个人配资信息
    [self getCapitalMoney];
}

#pragma mark -
#pragma mark UI

-(void)loadUI{
    _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64)];
    _backGroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backGroundView];
    
    [self loadSubViews];
}

-(void)loadSubViews{
    UILabel *stockName = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, ScreenWidth, 20)];
    stockName.text = self.orderByModel.stockName;
    stockName.textAlignment = NSTextAlignmentCenter;
    stockName.textColor = GrayColor;
    [_backGroundView addSubview:stockName];
    
    UILabel *stockCode = [[UILabel alloc]initWithFrame:CGRectMake(0, stockName.frame.origin.y+stockName.frame.size.height, ScreenWidth, 13)];
    stockCode.text = self.orderByModel.stockCode;
    stockCode.textAlignment = NSTextAlignmentCenter;
    stockCode.textColor = GrayColor;
    stockCode.font = [UIFont systemFontOfSize:12];
    [_backGroundView addSubview:stockCode];
    
    
    //配资比例
    _capitalScaleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, stockCode.frame.size.height+stockCode.frame.origin.y+60, ScreenWidth/2-30, 20)];
    if (iPhone4s) {
        _capitalScaleLabel.frame = CGRectMake(0, stockCode.frame.size.height+stockCode.frame.origin.y+20, ScreenWidth/2-30, 20);
    }
    
    _capitalScaleLabel.text = @"比例 1:2";
    _capitalScaleLabel.font = [UIFont systemFontOfSize:12];
    _capitalScaleLabel.textAlignment = NSTextAlignmentRight;
    [_backGroundView addSubview:_capitalScaleLabel];
    
    _capitalScaleLabel.attributedText =[self multiplicityText:_capitalScaleLabel.text from:3 to:(int)_capitalScaleLabel.text.length-3 font:16];
    
    
    
    _capitalMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(_capitalScaleLabel.frame.origin.x+_capitalScaleLabel.frame.size.width+18, _capitalScaleLabel.frame.origin.y, ScreenWidth-_capitalScaleLabel.frame.size.width, 20)];
    _capitalMoneyLabel.text = [NSString stringWithFormat:@"交易本金 ￥%@",[self addSign:[NSString stringWithFormat:@"%.2f",[self.orderByModel.selectAmt floatValue]]]];
    _capitalMoneyLabel.font = [UIFont systemFontOfSize:12];
    [_backGroundView addSubview:_capitalMoneyLabel];
    
    _capitalMoneyLabel.attributedText =[self multiplicityText:_capitalMoneyLabel.text from:5 to:(int)_capitalMoneyLabel.text.length-5 font:16];
    
    
    [self loadMultipleView];
    
    //保证金
    NSArray *titleArray = @[@"保证金",@"服务费",@"合计"];
    NSArray *moneyArray = nil;
    if (isIntegral == 0) {
        moneyArray = @[@"￥0.00",@"￥0.00",@"￥0.00"];
    }
    else{
        moneyArray = @[@"￥0.00",@"￥0.00",@"￥0.00"];
    }
    
    
    for (int i = 0; i<3; i++) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, _capitalScaleLabel.frame.size.height+_capitalScaleLabel.frame.origin.y+20+60+35+45*i, 45, 44)];
        if (iPhone4s) {
            leftLabel.frame = CGRectMake(20, _capitalScaleLabel.frame.size.height+_capitalScaleLabel.frame.origin.y+20+60+45*i, 45, 44);
        }
        leftLabel.text = titleArray[i];
        leftLabel.font = [UIFont systemFontOfSize:12];
        leftLabel.textColor = [UIColor grayColor];
        [_backGroundView addSubview:leftLabel];
        
        if (i == 1) {
            _activityPreferentialLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftLabel.frame.size.width+leftLabel.frame.origin.x, leftLabel.frame.origin.y, 40, 16)];
            _activityPreferentialLabel.center = CGPointMake(_activityPreferentialLabel.center.x, leftLabel.center.y);
            _activityPreferentialLabel.backgroundColor = CanSelectButBackColor;
            _activityPreferentialLabel.font = [UIFont systemFontOfSize:10];
            _activityPreferentialLabel.textAlignment = NSTextAlignmentCenter;
            _activityPreferentialLabel.layer.cornerRadius = 2;
            _activityPreferentialLabel.clipsToBounds = YES;
            _activityPreferentialLabel.text = @"优惠";
            _activityPreferentialLabel.textColor = [UIColor whiteColor];
            [_backGroundView addSubview:_activityPreferentialLabel];
            _activityPreferentialLabel.hidden = YES;
        }
        
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(20+(ScreenWidth-40)/2-40-45, leftLabel.frame.origin.y, (ScreenWidth-40)/2+40+45, 44)];
        rightLabel.text = moneyArray[i];
        rightLabel.font = [UIFont systemFontOfSize:15];
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.tag = 1000+i;
        [_backGroundView addSubview:rightLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(17, leftLabel.frame.origin.y+leftLabel.frame.size.height, ScreenWidth-17*2, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_backGroundView addSubview:lineView];
        
        if (i==2) {
            lineView.hidden = YES;
            rightLabel.textColor = [UIColor redColor];
        }
        
    }
    
    //代扣交易综合费
    
    UILabel *withHoldLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, ScreenHeigth-64-120, 95, 13)];
    withHoldLabel.font = [UIFont systemFontOfSize:13];
    withHoldLabel.text = @"代扣交易综合费";
    withHoldLabel.textColor = GrayColor;
    [_backGroundView addSubview:withHoldLabel];
    
    UIButton *withHoldLabelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    withHoldLabelBtn.frame = withHoldLabel.frame;
    withHoldLabelBtn.backgroundColor = [UIColor clearColor];
    [withHoldLabelBtn addTarget:self action:@selector(withHoldBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_backGroundView addSubview:withHoldLabelBtn];
    
    _withHoldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _withHoldBtn.frame = CGRectMake(withHoldLabel.frame.origin.x+withHoldLabel.frame.size.width, withHoldLabel.frame.origin.y, 13, 13);
        [_withHoldBtn setImage:[UIImage imageNamed:@"order_withhold"] forState:UIControlStateNormal];
    [_withHoldBtn addTarget:self action:@selector(withHoldBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_backGroundView addSubview:_withHoldBtn];
    
    
    //允许最大亏损
    _deficitLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-30, _withHoldBtn.frame.origin.y, (ScreenWidth-40)/2+30, 13)];
    _deficitLabel.text = @"允许最大亏损￥0.00";
    _deficitLabel.font = [UIFont systemFontOfSize:13];
    _deficitLabel.textAlignment = NSTextAlignmentRight;
    _deficitLabel.textColor = GrayColor;
    [_backGroundView addSubview:_deficitLabel];
    
    //按钮
    
    NSString *titleName = [self getStatus:self.orderByModel.status];
    
    
    _orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _orderButton.frame = CGRectMake(20, _deficitLabel.frame.origin.y+_deficitLabel.frame.size.height+15, ScreenWidth-40, 44);
    [_orderButton setTitle:titleName forState:UIControlStateNormal];
    if ([titleName isEqualToString:@"确认买入"]) {
        [_orderButton setBackgroundColor:CanSelectButBackColor];
    }
    else{
        [_orderButton setBackgroundColor:[UIColor lightGrayColor]];
    }
    
    _orderButton.clipsToBounds = YES;
    _orderButton.layer.cornerRadius = 6;
    [_orderButton addTarget:self action:@selector(orderClick:) forControlEvents:UIControlEventTouchUpInside];
    _orderButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_backGroundView addSubview:_orderButton];
    
    
    UILabel *agreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-103, _orderButton.frame.size.height+_orderButton.frame.origin.y+15, 205, 16)];
    agreeLabel.text = @"我已阅读并同意《股票T+1参与规则》";
    agreeLabel.font = [UIFont systemFontOfSize:12];
    agreeLabel.center = CGPointMake(agreeLabel.center.x+20, agreeLabel.center.y);
    agreeLabel.textColor = GrayColor;
    agreeLabel.attributedText = [self multiplicityColorText:agreeLabel.text from:7 to:11 color:RGBCOLOR(65, 134, 212)];
    [_backGroundView addSubview:agreeLabel];
    UIButton *agreeInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeInfoBtn.frame = agreeLabel.frame;
    [agreeInfoBtn setBackgroundColor:[UIColor clearColor]];
    [agreeInfoBtn addTarget:self action:@selector(lookRule) forControlEvents:UIControlEventTouchUpInside];
    [_backGroundView addSubview:agreeInfoBtn];
    
    _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _agreeBtn.frame = CGRectMake(agreeLabel.frame.origin.x-20, agreeLabel.frame.origin.y, 16, 16);
    [_agreeBtn setImage:[UIImage imageNamed:@"button_10"] forState:UIControlStateNormal];
    [_agreeBtn setImage:[UIImage imageNamed:@"button_09"] forState:UIControlStateSelected];
    _agreeBtn.selected = YES;
    [_agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_backGroundView addSubview:_agreeBtn];
    
}

#pragma mark 代扣交易综合费点击事件

-(void)withHoldBtnClick{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
    coverView.tag = 1999;
    [_backGroundView addSubview:coverView];
    
    UIImageView *withHoldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, _withHoldBtn.frame.origin.y-(ScreenWidth-40)/(670/219.0), (ScreenWidth-40), (ScreenWidth-40)/(670/219.0))];
    withHoldImageView.image = [UIImage imageNamed:@"BombBox"];
    [coverView addSubview:withHoldImageView];
    
    UILabel *proLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, withHoldImageView.frame.size.width-20, withHoldImageView.frame.size.height-20)];
    proLabel.numberOfLines = 0;
    proLabel.font = [UIFont systemFontOfSize:11];
    proLabel.text = @"交易综合费卖出时一次性扣除，费用包含向证券公司支付的佣金、印花税和过户费等。";
    proLabel.textColor = RGBCOLOR(111, 111, 111);
    proLabel.alpha = 0;
    [withHoldImageView addSubview:proLabel];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(unLoadWithHold)];
    [coverView addGestureRecognizer:tap];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        withHoldImageView.bounds = CGRectMake(20, _withHoldBtn.frame.origin.y-(ScreenWidth-40)/(670/219.0), (ScreenWidth-40), (ScreenWidth-40)/(670/219.0));
    } completion:^(BOOL finished) {
        proLabel.alpha = 1;
    }];
}

-(void)unLoadWithHold{
    UIView *coverView = [_backGroundView viewWithTag:1999];
    [coverView removeFromSuperview];
}

#pragma mark agree Agreement 

-(void)agreeBtnClick:(UIButton *)btn{
    if (btn.selected) {
        btn.selected = NO;
        [_orderButton setBackgroundColor:[UIColor lightGrayColor]];
    }
    else{
        btn.selected = YES;
        if ([[self getStatus:self.orderByModel.status] isEqualToString:@"确认买入"] && selectCount <= 5) {
            [_orderButton setBackgroundColor:CanSelectButBackColor];
        }
        else{
            [_orderButton setBackgroundColor:[UIColor lightGrayColor]];
        }
    }
}

#pragma mark -
#pragma mark 滑动选择倍数视图

-(void)loadMultipleView{
    _slideView = [[UIView alloc]initWithFrame:CGRectMake(17, _capitalScaleLabel.frame.size.height+_capitalScaleLabel.frame.origin.y+20, ScreenWidth-17*2, 60)];
    [_backGroundView addSubview:_slideView];
    
    [self loadMultiple:_slideView];
}

#pragma mark 配置选择倍数颜色

-(void)chooseMultipleColorChangeWithMoneyArray:(NSMutableArray *)moneyArray Integral:(NSMutableArray *)integralArray{
    
    for (int i = 0; i<moneyArray.count; i++) {
        StockOrderModel *orderModel = moneyArray[i];
        
        [_redMoneyFontArray addObject:[NSNumber numberWithFloat:orderModel.stockMultiple]];
        
    }
    
    for (int i = 0; i<integralArray.count; i++) {
        StockOrderModel *orderModel = integralArray[i];
        
        [_redIntegralFontArray addObject:[NSNumber numberWithFloat:orderModel.stockMultiple]];
        
    }
    
    [self chooseMultipleConfigur];
}
//默认选择5
-(void)chooseMultipleConfigur{
    
    UIView *topView = [_slideView viewWithTag:11111];
    
    for (int i = 0; i<9; i++) {
        UILabel *label = (UILabel *)[topView viewWithTag:i+2];
        label.textColor = GrayColor;
        label.bounds = CGRectMake(0, 0, label.frame.size.width, 13);
        label.font = [UIFont systemFontOfSize:12];
    }
    
    if (isIntegral == 0) {
        //配置金额可选倍数的颜色
        for (int i = 0; i<9; i++) {
            UILabel *label = (UILabel *)[topView viewWithTag:i+2];
            for (int j = 0; j<_redMoneyFontArray.count; j++) {
                if ((int)label.tag == [_redMoneyFontArray[j] intValue]) {
                    label.textColor = [UIColor redColor];
                    if (label.tag == selectCount) {
                        label.bounds = CGRectMake(0, 0, label.frame.size.width, 22);
                        label.font = [UIFont systemFontOfSize:22];
                    }
                }
            }
        }
        
        //配置金额最大倍数
        for (int i = 0; i < _redMoneyFontArray.count; i++) {
            
            if (i==0) {
                multiple = [_redMoneyFontArray[i] intValue] ;
            }
            if ([_redMoneyFontArray[i] intValue] > multiple) {
                multiple = [_redMoneyFontArray[i] intValue] ;
            }
        }
    }
    else if (isIntegral == 1){
        //配置积分可选倍数的颜色
        for (int i = 0; i<9; i++) {
            UILabel *label = (UILabel *)[topView viewWithTag:i+2];
            label.textColor = GrayColor;
            for (int j = 0; j<_redIntegralFontArray.count; j++) {
                if ((int)label.tag == [_redIntegralFontArray[j] intValue]) {
                    label.textColor = [UIColor redColor];
                    if (label.tag == selectCount) {
                        label.bounds = CGRectMake(0, 0, label.frame.size.width, 22);
                        label.font = [UIFont systemFontOfSize:22];
                    }
                }
            }
        }
        
        //配置积分最大倍数
        for (int i = 0; i < _redIntegralFontArray.count; i++) {
            if (i==0) {
                multiple = [_redIntegralFontArray[i] intValue] ;
            }
            if ([_redIntegralFontArray[i] intValue] > multiple) {
                multiple = [_redIntegralFontArray[i] intValue] ;
            }
        }
    }
    
    //滑块归位
    [self chooseViewBegin];
}

-(void)chooseViewBegin{
    
    if (_proLabel != nil) {
        [_proLabel removeFromSuperview];
        _proLabel = nil;
    }
    
    UIView *view = [self.view viewWithTag:11111];
    for (UILabel *label in view.subviews) {
        if (label.tag == selectCount) {
                _pointImageView.center = CGPointMake(label.center.x , _pointImageView.center.y);
                [self moveRefreshData:label];
        }
    }
    //移除代扣视图
    [self unLoadWithHold];
    
    [self updateData];
}

#pragma mark 选择倍数

-(void)loadMultiple:(UIView *)view{
    multiple = 5;
    
    float width = view.frame.size.width;
    
    //Top
    
    UIView *topView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 25)];
    topView.tag = 11111;
    [view addSubview:topView];
    
    for (int i = 0; i<9; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0+i*(width/9), 12, width/9, 13)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.text = [NSString stringWithFormat:@"%d",i+2];
        label.textColor = GrayColor;
        label.tag = i+2;
        [topView addSubview:label];
    }
    
    
    //Bottom
    
    bottomView= [[UIView alloc]initWithFrame:CGRectMake(0, topView.frame.origin.y+topView.frame.size.height, width, 50)];
    [view addSubview:bottomView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, bottomView.frame.size.height/2-7, width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:lineView];
    
    _pointImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35/2+5, 43/2+6)];
    _pointImageView.image = [UIImage imageNamed:@"PointRed"];
    _pointImageView.center = CGPointMake(width/9/2, lineView.center.y-2);
    [bottomView addSubview:_pointImageView];
    
    
//    selectCount = 2;
}

#pragma mark -
#pragma mark 下单按钮事件

-(void)orderClick:(UIButton *)btn{
    if ([btn.backgroundColor isEqual:[UIColor lightGrayColor]]) {
        
    }
    else{
        [self getSystemDate];
    }
}

#pragma mark -
#pragma mark 获取个人配资

-(void)getCapitalMoney{
    
    //加载缓存
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    if (cacheModel.payModel != nil) {
        _moneyStockArray = [NSMutableArray arrayWithArray:cacheModel.payModel.moneyStockArray];
        _integralStockArray = [NSMutableArray arrayWithArray:cacheModel.payModel.integralStockArray];
        [self reloadDataWithPrivateConfigur];
    }
    
    
    [DataEngine requestToGetCapitalMoney:self.orderByModel.selectAmt Complete:^(BOOL SUCCESS, NSMutableArray *moneyArray, NSMutableArray *integralArray) {
        if (SUCCESS) {
            _moneyStockArray = [NSMutableArray arrayWithArray:moneyArray];
            _integralStockArray = [NSMutableArray arrayWithArray:integralArray];
            
            //缓存
            if (cacheModel.payModel == nil) {
                PagePayModel *payModel = [[PagePayModel alloc]init];
                payModel.moneyStockArray = [NSMutableArray arrayWithArray:_moneyStockArray];
                payModel.integralStockArray = [NSMutableArray arrayWithArray:_integralStockArray];
                cacheModel.payModel = payModel;
                [CacheEngine setCacheInfo:cacheModel];
            }
            //获取到个人配资后刷新
            [self reloadDataWithPrivateConfigur];
        }
        else{
            [[UIEngine sharedInstance] showAlertWithTitle:@"个人操盘配置获取失败，请重新选择" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
            [UIEngine sharedInstance].alertClick = ^(int aIndex){
                [self.navigationController popViewControllerAnimated:YES];
            };
        }
    }];
}

//获取到个人配资后刷新
-(void)reloadDataWithPrivateConfigur{
    //获取对应倍数的个人额度配置
    [self getPrivateConfigur];
    
    //选择倍数颜色配置
    [self chooseMultipleColorChangeWithMoneyArray:_moneyStockArray Integral:_integralStockArray];
    
    //保证金数据配置
    [self updateData];
}

//获取对应倍数的个人额度配置
-(void)getPrivateConfigur{
    //获取对应倍数的个人额度配置
    
    for (int i = 0; i<_moneyStockArray.count; i++) {
        StockOrderModel *orderModel = _moneyStockArray[i];
        if (orderModel.stockMultiple == selectCount) {
            _moneyModel = orderModel;
            break;
        }
    }
    
    for (int i = 0; i<_integralStockArray.count; i++) {
        StockOrderModel *orderModel = _integralStockArray[i];
        if (orderModel.stockMultiple == selectCount) {
            _integralModel = orderModel;
            break;
        }
    }
}

#pragma mark -
#pragma mark 协议

- (void)lookRule
{
    DetailViewController    *detailVC = [[DetailViewController alloc]init];
    detailVC.index = 5;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -
#pragma mark 获取股票当前状态

//获取股票当前状态
-(NSString *)getStatus:(int )tradeStatus
{
    //    0  可售
    //    1   黑名单
    //    2   名称过滤
    //    3   涨跌幅过滤
    //    4	失效（被管理员删除）
    //    5	停牌
    //    6	触及涨停
    //    7	非可买股中
    //    8	连续涨停
    
    
    NSInteger marketStatus = [[SystemSingleton sharedInstance] getMarketStatus];
    
        switch (marketStatus) {
            case 20:
                return @"未开市";
                break;
            case 21:
                return @"集合竞价";
                break;
            case 22:
            {
                //确认买入
                switch (tradeStatus) {
                    case 0:
                        return [NSString stringWithFormat:@"%@",@"确认买入"];
                        break;
//                    case 1:
//                        return [NSString stringWithFormat:@"%@",@"黑名单"];
//                        break;
//                    case 2:
//                        return [NSString stringWithFormat:@"%@",@"名称过滤"];
//                        break;
//                    case 3:
//                        return [NSString stringWithFormat:@"%@",@"涨跌幅过滤"];
//                        break;
//                    case 4:
//                        return [NSString stringWithFormat:@"%@",@"失效(被管理员删除)"];
//                        break;
                    case 5:
                        return [NSString stringWithFormat:@"%@",@"停牌"];
                        break;
//                    case 6:
//                        return [NSString stringWithFormat:@"%@",@"触及涨停"];
//                        break;
//                    case 7:
//                        return [NSString stringWithFormat:@"%@",@"非可买股中"];
//                        break;
//                    case 8:
//                        return [NSString stringWithFormat:@"%@",@"连续涨停"];
//                        break;
                    default:
                        return @"今日禁买";
                        break;
                }
            }
                break;
            case 23:
                return @"午休市";
                break;
            case 24:
                return @"已闭市";
                break;
            case 100:
                return @"确认买入";
                break;
            default:
                return @"确认买入";
        }
    
}

#pragma mark -
#pragma mark - 发送订单请求
- (void)orderStork
{
    //友盟统计
    _quantity = [NSString stringWithFormat:@"%d",self.orderByModel.buyCount];
    if (isIntegral == 0) {
        _buy_type = @"现金";
    }else{
        _buy_type = @"积分";
    }
    
   
    
    for (int i = 0; i<_moneyStockArray.count; i++) {
        StockOrderModel *orderModel = _moneyStockArray[i];
        if (orderModel.stockMultiple == selectCount) {
            _moneyModel = orderModel;
            break;
        }
    }
    
    for (int i = 0; i<_integralStockArray.count; i++) {
        StockOrderModel *orderModel = _integralStockArray[i];
        if (orderModel.stockMultiple == selectCount) {
            _integralModel = orderModel;
            break;
        }
    }
    
    int stockID = 0;
    if (isIntegral == 1) {
         stockID = _integralModel.stockID;
        
        //友盟统计
        _payFee = [NSString stringWithFormat:@"%.2f",_integralModel.stockCashFund];
    }
    else if(isIntegral == 0){
        stockID = _moneyModel.stockID;
        
        //友盟统计
        _payFee = [NSString stringWithFormat:@"%.2f",_moneyModel.stockCashFund];
    }
    
    //友盟统计
    _priceID = [NSString stringWithFormat:@"%d",stockID];
    _money = self.orderByModel.selectAmt;
    
    
    NSDictionary *dic = @{
                          @"stockCode": self.orderByModel.stockCode,
                          @"typeCode": self.orderByModel.stockCodeType,
                          @"stockName": self.orderByModel.stockName,
                          @"userBuyCount": [NSNumber numberWithInt:self.orderByModel.buyCount],
                          @"tradeDayCount": [NSNumber numberWithInt:1],
                          @"traderId": [NSNumber numberWithInt:stockID],
                          @"userBuyPrice": [NSNumber numberWithFloat:self.orderByModel.price],
                          @"userBuyDate": _systemTime,
                          };
    
    NSString *jsonStr = [self toJSON:dic];
    NSDictionary *jsonDic = @{
                              @"orderData" : jsonStr,
                              @"version" : VERSION ,
                              @"token" : [[CMStoreManager sharedInstance] getUserToken]
                              };
    NSString *urlStr =
    [NSString stringWithFormat:@"%@/order/order/buy", K_MGLASS_URL];
    
    
    //****************************友盟统计*************************************
    NSDictionary *dict = @{@"Operation" : @"buttonClick", @"buyType" : _buy_type,@"result":@"success"};
    [MobClick event:@"stockbuy" attributes:dict];
    
    {
        NSDictionary *dict = @{@"Operation" : @"buttonResult", @"buyType" : _buy_type,@"result":@"success"};
        [MobClick event:@"stockbuy" attributes:dict];
    }
    {
        NSDictionary *dict = @{@"Operation" : @"buttonResult", @"buyType" : _buy_type,@"result":@"error"};
        [MobClick event:@"stockbuy" attributes:dict];
    }
    //****************************end*************************************
    
    
    [NetRequest postRequestWithNSDictionary:jsonDic
                                        url:urlStr
                               successBlock:^(NSDictionary *dictionary) {
                                   
                                   if ([dictionary[@"code"] intValue] == 200) {
                                       _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(afterTime) userInfo:nil repeats:YES];
                                       [_timer fire];
                                       [self searchOrderStork:[dictionary[@"data"] intValue]];

                                   }
                                   //抱歉，目前暂不支持现金交易！
                                   else if ([dictionary[@"code"] intValue] == 49998){
                                       [[UIEngine sharedInstance] showAlertWithTitle:@"抱歉，目前暂不支持现金交易！" ButtonNumber:2 FirstButtonTitle:@"确定" SecondButtonTitle:@"积分模拟"];
                                       [UIEngine sharedInstance].alertClick = ^(int aIndex){
                                           //积分模拟
                                           if (aIndex == 10087) {
                                               isIntegral = 1;
                                               seg.selectedSegmentIndex = 1;
                                               [self segClick:seg];
                                           }
                                           [[UIEngine sharedInstance] hideProgress];
                                       };
                                   }
                                   //余额不足
                                   else if([dictionary[@"code"] intValue] == 44007){
                                       
                                       if (isIntegral == 0) {
                                           [[UIEngine sharedInstance] showAlertWithTitle:@"您当前现金余额不足，请先充值" ButtonNumber:2 FirstButtonTitle:@"返回" SecondButtonTitle:@"充值"];
                                           [UIEngine sharedInstance].alertClick = ^(int aIndex){
                                               if (aIndex == 10087) {
                                                   [self getAccountMoney];
                                               }
                                           };
                                       }
                                       else{
                                           [[UIEngine sharedInstance] showAlertWithTitle:@"您当前积分余额不足，无法买入" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
                                           [UIEngine sharedInstance].alertClick = ^(int aIndex){
                                               if (aIndex == 10087) {
                                                   [self getAccountMoney];
                                               }
                                           };
                                       }
                                       
                                       [[UIEngine sharedInstance] hideProgress];
                                   }
                                   //涨跌幅过滤
                                   else if ([dictionary[@"code"] intValue] == 44026){
                                       [[UIEngine sharedInstance] showAlertWithTitle:@"申报失败 \n超过涨跌幅限制" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
                                       [UIEngine sharedInstance].alertClick = ^(int aIndex){
                                       };
                                       [[UIEngine sharedInstance] hideProgress];
                                   }
                                   else {
                                       //44003 可卖
                                       [[UIEngine sharedInstance] showAlertWithTitle:@"申报失败" ButtonNumber:2 FirstButtonTitle:@"放弃" SecondButtonTitle:@"再次提交"];
                                       [UIEngine sharedInstance].alertClick = ^(int aIndex){
                                           if (aIndex == 10086) {
                                               self.rdv_tabBarController.selectedIndex = 1;
                                               [self.navigationController popToRootViewControllerAnimated:YES];
                                           }
                                       };
                                       [[UIEngine sharedInstance] hideProgress];
                                   }
                               }
                               failureBlock:^(NSError *error) {
                                   NSLog(@"下单失败");
                                   
                                   [[UIEngine sharedInstance] showAlertWithTitle:@"当前网络异常，请稍后查看购买结果" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
                                   [UIEngine sharedInstance].alertClick = ^(int aIndex){};
                                   [[UIEngine sharedInstance] hideProgress];
                               }];
}



-(void)afterTime{
    
    time ++;
    if (time > 5) {
        [_timer invalidate];
        _timer = nil;
        
        self.rdv_tabBarController.selectedIndex = 0;
        [self sendNotification];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)sendNotification
{
    [[NSNotificationCenter defaultCenter]postNotification:_notification];
}

-(NSString *)toJSON:(id)aParam
{
    NSData   *jsonData=[NSJSONSerialization dataWithJSONObject:aParam options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

#pragma mark 去充值

-(void)getAccountMoney{
        MoneyDetaillViewController *moneyVC = [[MoneyDetaillViewController alloc]init];
        [self.navigationController pushViewController:moneyVC animated:NO];
}

//系统时间

-(void)getSystemDate
{
    [UIEngine sharedInstance].progressStyle = 1;
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
        
        [self orderStork];
    }];
}

#pragma mark -
#pragma mark - 查询订单交易状态

//查询订单交易状态r
- (void)searchOrderStork:(int)aID
{
    if (_timer == nil) {
        return;
    }else{
    
        NSDictionary *dic = @{
                              @"orderId" : [NSNumber numberWithInt:aID],
                              @"version" : VERSION ,
                              @"token" : [[CMStoreManager sharedInstance] getUserToken],
                              };
        
        NSString *urlStr =
        [NSString stringWithFormat:@"%@/order/order/orderStatus", K_MGLASS_URL];
        NSLog(@"%@", urlStr);
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
                                           if ([dictionary[@"data"] floatValue] == 2 || [dictionary[@"data"] floatValue] == 3) {
                                               [_timer invalidate];
                                               _timer = nil;
                                               [[UIEngine sharedInstance] hideProgress];
                                               
                                               [[UIEngine sharedInstance] showAlertWithTitle:@"已申报成功" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
                                               [UIEngine sharedInstance].alertClick = ^(int aIndex){
                                                   self.rdv_tabBarController.selectedIndex = 0;
                                                   [self sendNotification];
                                                   [self.navigationController popToRootViewControllerAnimated:YES];
                                               };
                                           }
                                           else if([dictionary[@"data"] floatValue] == 0 || [dictionary[@"data"] floatValue] == 1){
                                               [self searchOrderStork:aID];
                                           }
                                           else{
                                               
                                               [_timer invalidate];
                                               _timer = nil;
                                               [[UIEngine sharedInstance] hideProgress];
                                               
                                               [[UIEngine sharedInstance] showAlertWithTitle:@"申报失败" ButtonNumber:2 FirstButtonTitle:@"放弃" SecondButtonTitle:@"再次提交"];
                                               [UIEngine sharedInstance].alertClick = ^(int aIndex){
                                                   if (aIndex == 10086) {
                                                       self.rdv_tabBarController.selectedIndex = 1;
                                                       [self.navigationController popToRootViewControllerAnimated:YES];
                                                   }
                                               };
                                               
                                               
                                           }
                                       }
                                       else{
                                           [self searchOrderStork:aID];
                                       }
                                       
                                   }
                                   failureBlock:^(NSError *error){
                                       [self searchOrderStork:aID];
                                       
                                   }];
    }
}

//加“,”
-(NSString *)addSign:(NSString *)aStr
{
    NSString *point=[aStr substringFromIndex:aStr.length-3];
    
    NSString *money=[aStr substringToIndex:aStr.length-3];
    
    return [[DataEngine countNumAndChangeformat:money] stringByAppendingString:point];
}

#pragma mark -
#pragma mark 移动滑块

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_slideView];
    
    if (_proLabel != nil) {
        [_proLabel removeFromSuperview];
        _proLabel = nil;
    }
    
    if (point.y < _slideView.frame.size.height && point.y > 0) {
        
        
        if (point.x <_slideView.frame.size.width && point.x > 0) {
            _pointImageView.center = CGPointMake(point.x , _pointImageView.center.y);
        }
        
        UIView *view = [self.view viewWithTag:11111];
        for (UILabel *label in view.subviews) {
            if (label.tag > 0 && label.tag != 11111) {
                if (_pointImageView.center.x > label.frame.origin.x && _pointImageView.center.x <label.frame.origin.x+label.frame.size.width) {
                    if ([label.textColor isEqual: [UIColor redColor]]) {
                        _pointImageView.image = [UIImage imageNamed:@"PointRed"];
                    }
                    else{
                        _pointImageView.image = [UIImage imageNamed:@"PointGray"];
                    }
                    
                    [self loadAnimationOfFont];
                    
                }
            }
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchEnd];
    
}

-(void)touchEnd{
    if (_proLabel != nil) {
        [_proLabel removeFromSuperview];
        _proLabel = nil;
    }
    
    UIView *view = [self.view viewWithTag:11111];
    for (UILabel *label in view.subviews) {
        if (label.tag > 0 && label.tag != 11111) {
            if (_pointImageView.center.x > label.frame.origin.x && _pointImageView.center.x <label.frame.origin.x+label.frame.size.width) {
                _pointImageView.center = CGPointMake(label.center.x , _pointImageView.center.y);
                selectCount = [label.text intValue];
                
                [self moveRefreshData:label];
                
            }
        }
    }
    //移除代扣视图
    [self unLoadWithHold];
    NSLog(@"%d",selectCount);
}

-(void)moveRefreshData:(UILabel *)label{
    _capitalScaleLabel.text = [NSString stringWithFormat:@"比例 1:%d",selectCount];
    _capitalScaleLabel.attributedText =[self multiplicityText:_capitalScaleLabel.text from:3 to:(int)_capitalScaleLabel.text.length-3 font:16];
    
    //获取对应倍数的个人额度配置
    [self getPrivateConfigur];
    
    
    [self updateData];
    
    if (selectCount == multiple) {
        _proLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 13)];
        _proLabel.text = @"Max";
        _proLabel.textAlignment = NSTextAlignmentCenter;
        _proLabel.font = [UIFont systemFontOfSize:10];
        _proLabel.textColor = [UIColor redColor];
        _proLabel.center = CGPointMake(label.center.x, (_pointImageView.frame.size.height+_pointImageView.frame.origin.y+13)-6);
        [bottomView addSubview:_proLabel];
    }
    
    if (![label.textColor isEqual:[UIColor redColor]]) {
        
        [self clearData];
        
        _proLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 13)];
        _proLabel.text = @"暂无权限";
        _proLabel.textAlignment = NSTextAlignmentCenter;
        _proLabel.textColor = [UIColor redColor];
        _proLabel.font = [UIFont systemFontOfSize:10];
        _proLabel.center = CGPointMake(label.center.x, (_pointImageView.frame.size.height+_pointImageView.frame.origin.y+13)-6);
        [bottomView addSubview:_proLabel];
        
        [_orderButton setBackgroundColor:[UIColor lightGrayColor]];
        
    }
    
    if ([_orderButton.titleLabel.text isEqualToString:@"确认买入"]) {
        if (selectCount <= multiple && _agreeBtn.selected == YES) {
            [_orderButton setBackgroundColor:CanSelectButBackColor];
        }
        else{
            [_orderButton setBackgroundColor:[UIColor lightGrayColor]];
        }
    }
    else{
        [_orderButton setBackgroundColor:[UIColor lightGrayColor]];
    }
    
}

#pragma mark -
#pragma mark Animation

-(void)loadAnimationOfFont{
    
    [self removeAnimationOfFont];
    
    UIView *view = [self.view viewWithTag:11111];
    
    for (UILabel *label in view.subviews) {
        if (label.tag > 0 && label.tag != 11111) {
            if (_pointImageView.center.x > label.frame.origin.x && _pointImageView.center.x <label.frame.origin.x+label.frame.size.width) {
                
                if ([label.textColor isEqual:[UIColor redColor]]) {
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        label.bounds = CGRectMake(0, 0, label.frame.size.width, 22);
                        label.font = [UIFont systemFontOfSize:22];
                    } completion:^(BOOL finished) {
                        
                    }];
                }
            }
        }
    }
}

-(void)removeAnimationOfFont{
    UIView *view = [self.view viewWithTag:11111];
    
    for (UILabel *label in view.subviews) {
        if (label.tag > 0 && label.tag != 11111) {
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                label.bounds = CGRectMake(0, 0, label.frame.size.width, 13);
                label.font = [UIFont systemFontOfSize:12];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

#pragma mark 属性字符串
-(NSMutableAttributedString *)multiplicityText:(NSString *)aStr from:(int)aFrom to:(int)aTo font:(float)aFont
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:aStr];
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:aFont] range:NSMakeRange(aFrom, aTo)];
    
    return str;
}

-(NSMutableAttributedString *)multiplicityColorWithFont:(NSString *)aStr from:(int)aFrom to:(int)aTo color:(UIColor *)aColor font:(float)aFont
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:aStr];
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:aFont] range:NSMakeRange(aFrom, aTo)];
    [str addAttribute:NSForegroundColorAttributeName value:aColor range:NSMakeRange(aFrom,aTo)];
    
    return str;
}

-(NSMutableAttributedString *)multiplicityColorText:(NSString *)aStr from:(int)aFrom to:(int)aTo color:(UIColor *)aColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:aStr];
    
    [str addAttribute:NSForegroundColorAttributeName value:aColor range:NSMakeRange(aFrom,aTo)];
    
    return str;
}

-(NSMutableAttributedString *)multiplicityActivity:(NSString *)aStr from:(int)aFrom to:(int)aTo color:(UIColor *)aColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:aStr];
    
    [str addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(aFrom, aTo)];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(aFrom,aTo)];
    
    return str;
}

#pragma mark -
#pragma mark 更新数据

//更新保证金、服务费、合计数据
-(void)updateData{
    UILabel *depositLabel = (UILabel *)[_backGroundView viewWithTag:1000];
    
    UILabel *serviceLabel = (UILabel *)[_backGroundView viewWithTag:1001];
    
    UILabel *totalLabel   = (UILabel *)[_backGroundView viewWithTag:1002];
    
    totalLabel.textColor = serviceLabel.textColor = depositLabel.textColor = CanSelectButBackColor;
    
    if (isIntegral == 0) {
        depositLabel.text = [NSString stringWithFormat:@"￥%@",[DataEngine addSign:[NSString stringWithFormat:@"%.2f",_moneyModel.stockCashFund]]];
        
        
        if (_moneyModel.stockDeductCounterFee != _moneyModel.stockInterest) {
            //更新服务费
            serviceLabel.text = [NSString stringWithFormat:@"￥%@ ￥%@",[DataEngine addSign:[NSString stringWithFormat:@"%.2f",_moneyModel.stockDeductCounterFee*2]],[DataEngine addSign:[NSString stringWithFormat:@"%.2f",_moneyModel.stockInterest*2]]];
            //显示活动图标
            _activityPreferentialLabel.hidden = NO;
            serviceLabel.attributedText = [self multiplicityActivity:serviceLabel.text from:0 to:(int)([DataEngine addSign:[NSString stringWithFormat:@"%.2f",_moneyModel.stockDeductCounterFee*2]].length+1) color:[UIColor lightGrayColor]];
        }else{
            serviceLabel.attributedText = nil;
            //更新服务费
            serviceLabel.text = [NSString stringWithFormat:@"￥%@",[DataEngine addSign:[NSString stringWithFormat:@"%.2f",_moneyModel.stockInterest*2]]];
            //隐藏活动图标
            _activityPreferentialLabel.hidden = YES;
            
        }
        
        //总计
        totalLabel.text = [NSString stringWithFormat:@"￥%@",[DataEngine addSign:[NSString stringWithFormat:@"%.2f",_moneyModel.stockCashFund+_moneyModel.stockInterest*2]]];
        //允许最大亏损
        _deficitLabel.text = [NSString stringWithFormat:@"允许最大亏损￥%@",[DataEngine addSign:[NSString stringWithFormat:@"%.2f",_moneyModel.stockMaxLoss]]];
        //配资
        _capitalMoneyLabel.text = [NSString stringWithFormat:@"交易本金 ￥%@",[self addSign:[NSString stringWithFormat:@"%.2f",[self.orderByModel.selectAmt floatValue]]]];
    }
    else{
        depositLabel.text = [[DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",_integralModel.stockCashFund]] stringByAppendingString:@"积分"];
        
        if (_integralModel.stockInterest != _integralModel.stockDeductCounterFee) {
            
            
            //积分四舍五入之后，出现的优惠显示问题
            if (![[NSString stringWithFormat:@"%.0f",_integralModel.stockInterest] isEqualToString:[NSString stringWithFormat:@"%.0f",_integralModel.stockDeductCounterFee]]) {
                //更新服务费
                serviceLabel.text = [NSString stringWithFormat:@"%@积分 %@积分",[DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",_integralModel.stockDeductCounterFee*2]],[DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",_integralModel.stockInterest*2]]];
                serviceLabel.attributedText = [self multiplicityActivity:serviceLabel.text from:0 to:(int)([DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",_integralModel.stockDeductCounterFee*2]].length+2) color:[UIColor lightGrayColor]];
                //显示活动图标
                _activityPreferentialLabel.hidden = NO;
            }
            else{
                serviceLabel.attributedText = nil;
                //更新服务费
                serviceLabel.text = [[DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",_integralModel.stockInterest*2]] stringByAppendingString:@"积分"];
                //隐藏活动图标
                _activityPreferentialLabel.hidden = YES;
            }
            
        }
        else{
            serviceLabel.attributedText = nil;
            //更新服务费
            serviceLabel.text = [[DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",_integralModel.stockInterest*2]] stringByAppendingString:@"积分"];
            _activityPreferentialLabel.hidden = YES;
        }
        
        
        
        //总计
        totalLabel.text = [[DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",_integralModel.stockCashFund+_integralModel.stockInterest*2]] stringByAppendingString:@"积分"];
        //允许最大亏损
        _deficitLabel.text = [[NSString stringWithFormat:@"允许最大亏损 %@",[DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",_integralModel.stockMaxLoss]]] stringByAppendingString:@"积分"];
        //交易本金
        _capitalMoneyLabel.text = [[NSString stringWithFormat:@"交易本金 %@",[DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",[self.orderByModel.selectAmt floatValue]]]] stringByAppendingString:@"积分"];
    }
    //交易本金
    if (_capitalMoneyLabel.text.length >5) {
        _capitalMoneyLabel.attributedText =[self multiplicityText:_capitalMoneyLabel.text from:5 to:(int)_capitalMoneyLabel.text.length-5 font:16];
    }
    
    if (_capitalScaleLabel.text.length >3) {
        //配资比例
        _capitalScaleLabel.attributedText =[self multiplicityColorWithFont:_capitalScaleLabel.text from:3 to:(int)_capitalScaleLabel.text.length-3 color:[UIColor redColor] font:16];
    }
}

-(void)clearData{
    UILabel *depositLabel = (UILabel *)[_backGroundView viewWithTag:1000];
    
    UILabel *serviceLabel = (UILabel *)[_backGroundView viewWithTag:1001];
    
    UILabel *totalLabel   = (UILabel *)[_backGroundView viewWithTag:1002];
    
    
    if (isIntegral == 0) {
        _deficitLabel.text = @"允许最大亏损 ——";
        depositLabel.text = @"——";
        serviceLabel.text = @"——";
        totalLabel.text = @"——";
    }
    else{
        _deficitLabel.text = @"允许最大亏损 ——";
        depositLabel.text = @"——";
        serviceLabel.text = @"——";
        totalLabel.text = @"——";
    }
    //隐藏活动图标
    _activityPreferentialLabel.hidden = YES;
    _capitalMoneyLabel.attributedText =[self multiplicityText:_capitalMoneyLabel.text from:5 to:(int)_capitalMoneyLabel.text.length-5 font:16];
    _capitalScaleLabel.attributedText =[self multiplicityColorWithFont:_capitalScaleLabel.text from:3 to:(int)_capitalScaleLabel.text.length-3 color:[UIColor blackColor] font:16];
    
    totalLabel.textColor = depositLabel.textColor = serviceLabel.textColor = [UIColor grayColor];
}

@end
