//
//  SpotIndexViewController.m
//  Xianhuo
//
//  Created by Xse on 15/11/23.
//  Copyright © 2015年 杭州市向淑娥. All rights reserved.
//

#import "SpotIndexViewController.h"
#import "HJCAjustNumButton.h"
#import "FiveMarketView.h"
#import "EntrustView.h"
#import "MyCashOrderPage.h"
#import "MarketModel.h"
#import "MarketIsStatusAlert.h"

#define Tag_marketStop            98765
#define Tag_marketGet             98764
#define Tag_limitedStop           98763
#define Tag_limitedGet            98762
#define Tag_numberofHand          98766
#define Tag_numberofLimitedHand   98767
#define Tag_LimitedPrice          98768
#define Tag_moneyLab              20000

#define Tag_priceMarketGet        801
#define Tag_priceMarketStop       802
#define Tag_priceLimitedGet       803
#define Tag_priceLimitedStop      804
#define Tag_buyNumMarket          805
#define Tag_buyNumLimited         806

#define Tag_marketSelect          8000
#define Tag_limitedSelect         9000

//止盈止损文本框下面的涨跌幅
#define Tag_marketGetRange        121210
#define Tag_marketStopRange       121211
#define Tag_limitedGetRange       121212
#define Tag_limitedStopRange      121213

#define CauMoneyNum               0.1//保证金的百分之十（）
#define PounDageNum               0.0008//万分之八（手续费和计算可买手数的时候用到）
#define PounMoneyNum              10
#define OnePerCent                0.01//止盈默认值 = 当前价+当前价*0.03
#define RangeStopLow              0.005//止损默认值= 当前价-当前价*0.005

#define KspotIndexMarketDic       @"market"
#define KspotIndexLimitedDic      @"limited"

#define KMarketStop               @"marketStop"
#define KMarketGet               @"marketGet"
#define KLimitedStop               @"limitedStop"
#define KLImitedGet               @"limitedGet"

#define K_green_color            [UIColor colorWithRed:51/255.0 green:177/255.0 blue:51/255.0 alpha:1]

@interface SpotIndexViewController()<UITextFieldDelegate>
{
    NSInteger isSegSelect;
    NSInteger markeIsStatus;//交易时间是否已经闭市（9闭市，0可售）
    
    UIView *showTextView;
    UIView *showMoneyView;
    
    UIView *bottomView;
    
    UIScrollView *tpkScrollView;
    
    //example:auTradeDic(存储到缓存文件的名字)
    NSString        *_spotIndexDicName ;

    //限价、手数
    
    //定义参数。保存文本框里面输入的东西。
    NSString *marktStop;//市价止损
    NSString *marktGet;//市价止盈
    
    NSString *limitedStop;//限价止损
    NSString *limitedGet;//限价止盈
    
    //是否第一次进入期货下单页面
    NSString *isFirstIndex;
    
    //用户总资产
    NSString *userFund;
    NSString *resultStr;
    NSString *floatNumStr;//小数位数
    NSString *userBuyNum;//用户可买手数
    
    UIView *fiveBackView;
    
    //是否选中止盈止损（包括市价。限价）
    BOOL isSelectMarketStop;
    BOOL isSelectMarketGet;
    BOOL isSelectLimitedStop;
    BOOL isSelectLimitedGet;
    
    UILabel *tishiLab;
}

@property (nonatomic,strong) UISegmentedControl *seg;
@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) NSDictionary *spotIndexDic;
@property (nonatomic,strong) NSMutableDictionary *marketPriceDic;//市价
@property (nonatomic,strong) NSMutableDictionary *limitedPriceDic;//限价

@property (nonatomic,strong) NSString            *highestPrice;//涨停价

@property (nonatomic,strong) NSString            *lowestPrice;//跌停价

@property (nonatomic,strong) UILabel             *upsAndDownsLab;

@end

@implementation SpotIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self requestCotsLowOrHighPriceData];
    
    isFirstIndex = @"YES";
    
    _marketPriceDic = [NSMutableDictionary dictionaryWithCapacity:0];
    _limitedPriceDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSocketInfo:) name:kPositionBosomPage object:nil];
    
    floatNumStr = [NSString stringWithFormat:@"%@%@f",@"%",[NSString stringWithFormat:@".%ld",(long)_floatNum]];
    
    isSelectLimitedGet      = NO;
    isSelectLimitedStop     = NO;
    isSelectMarketGet       = NO;
    isSelectMarketStop      = NO;
    
    [self loadNav];
    [self loadUIView];
    
    [self loadNowPrice];
    
    [self loadUpView];
    
    [self loadBottomView];
    
    [self setUpForDismissKeyboard];
    
//    [self getMarketEndTime];//弹出交易时间段
    
//    [self isRefreshData];
    
    
    // 键盘显示通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //获取用户总资产
//    [self getUserFund];
    [self requestMarketIsStatus];
    addTextFieldNotification(textFieldValueChange);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    removeTextFileNotification;
}

-(void)chageTextField:(NSNotification*)no
{
    UITextField *textMarketStop = [showTextView viewWithTag:Tag_marketStop];
    UITextField *textMarketGet = [showTextView viewWithTag:Tag_marketGet];
    UITextField *textLimitedStop = [showTextView viewWithTag:Tag_limitedStop];
    UITextField *textLimitedGet = [showTextView viewWithTag:Tag_limitedGet];
    
    if (isSegSelect == 0)
    {
        UITextField * textField = (UITextField*)no.object;
        if (textField == textMarketStop) {
            textMarketStop.text = resultStr;
        }else if (textField == textMarketGet)
        {
            textMarketGet.text = resultStr;
        }
    }else
    {
        UITextField * textField = (UITextField*)no.object;
        if (textField == textLimitedStop) {
            textLimitedStop.text = resultStr;
        }else if (textField == textLimitedGet)
        {
            textLimitedGet.text = resultStr;
        }
    }
}

#pragma mark - 判断是否需要刷新数据
- (void)isRefreshData
{
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    if (![cacheModel.isFirstSpotIndex isEqualToString:@"YES"] || cacheModel.isFirstSpotIndex != nil)
    {
        [self reloadSpotIndextData];
    }
}

-(void)loadNav{
    
    tpkScrollView = [[UIScrollView alloc]init];
    tpkScrollView.backgroundColor = [UIColor blackColor];
    tpkScrollView.frame = CGRectMake(0, 49, ScreenWidth,ScreenHeigth - 49);
    //    tpkScrollView.contentSize = CGSizeMake(ScreenWidth , ScreenHeigth-64);
    [self.view addSubview:tpkScrollView];
    
    
    UIImage *leftButtonImage = [UIImage imageNamed:@"return_1.png"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [leftButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchDown];
    [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    leftButton.titleLabel.shadowColor = RGBACOLOR(117,38,0,1.0f);
    leftButton.titleLabel.shadowOffset= CGSizeMake(0, -1);
    leftButton.backgroundColor = [UIColor clearColor];
    leftButton.titleLabel.textColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44/2-leftButtonImage.size.height/2, leftButtonImage.size.width, leftButtonImage.size.height)];
    imageView.image = [UIImage imageNamed:@"return_1"];
//    imageView.backgroundColor = [UIColor blackColor];
    imageView.center = leftButton.center;
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backClick)];
    [imageView addGestureRecognizer:tap];
    
    [self.view addSubview:leftButton];
    
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 44)];
    self.titleLabel.font = [UIFont systemFontOfSize:11];
    self.titleLabel.backgroundColor = [UIColor blackColor];
    self.titleLabel.text = [NSString stringWithFormat:@"%@\n%@",_productModel.commodityName,_productModel.instrumentID];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.center = CGPointMake(self.view.center.x, 20+22);
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.attributedText = [Helper multiplicityText:self.titleLabel.text from:0 to:(int)[@"白银现货" length] font:15];
    [self.view addSubview:self.titleLabel];
    
}

#pragma mark - 当前价
- (void)loadNowPrice
{
    if ([UIScreen mainScreen].bounds.size.height > 568) {
        tpkScrollView.scrollEnabled = NO;
    }else
    {
        tpkScrollView.scrollEnabled = YES;
    }
    
    UILabel *proLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_seg.frame) + 15*ScreenWidth/320, ScreenWidth, 14)];
    if (_buyState == 0)
    {
        proLabel.text  = @"看多价";
    }else
    {
        proLabel.text  = @"看空价";
    }
    proLabel.textAlignment = NSTextAlignmentCenter;
    proLabel.font = [UIFont systemFontOfSize:10];
    proLabel.textColor = [UIColor lightGrayColor];
    [tpkScrollView addSubview:proLabel];
    
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(proLabel.frame), ScreenWidth, 20)];
    if (_buyState == 0)
    {
        _priceLabel.text = _buyPrice;
    }else
    {
        _priceLabel.text = _salePrice;
    }
    _priceLabel.font = [UIFont systemFontOfSize:17];
    _priceLabel.textColor = Color_Gold;
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [tpkScrollView addSubview:_priceLabel];
    
    _upsAndDownsLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_priceLabel.frame), ScreenWidth, 15)];
    _upsAndDownsLab.text = @"--";
//    _upsAndDownsLab.backgroundColor = [UIColor redColor];
    _upsAndDownsLab.font = [UIFont systemFontOfSize:10.0];
    _upsAndDownsLab.textColor = Color_Gold;
    _upsAndDownsLab.textAlignment = NSTextAlignmentCenter;
    [tpkScrollView addSubview:_upsAndDownsLab];
}

#pragma mark - 手数/止损/止赢
- (void)loadUpView
{
    showTextView = [[UIView alloc]init];
    
    NSArray *arrayTitle;
    NSArray *arrayDetail;
    
    if (isSegSelect == 0)
    {
        arrayTitle = @[@"设置手数",@"止盈",@"止损"];
        arrayDetail = @[@"可买0手",@"触发价",@"触发价"];

    }else
    {
        arrayTitle = @[@"限价买入",@"设置手数",@"止盈",@"止损"];
        arrayDetail = @[@"查看五档行情",@"可买0手",@"触发价",@"触发价"];
    }

    [tpkScrollView addSubview:showTextView];
    
     showTextView.frame = CGRectMake(0, CGRectGetMaxY(_upsAndDownsLab.frame) + 15, ScreenWidth,arrayTitle.count*12 + arrayTitle.count*45);
    
    if ([UIScreen mainScreen].bounds.size.height <= 480)
    {
        showTextView.frame = CGRectMake(0, CGRectGetMaxY(_upsAndDownsLab.frame) + 15, ScreenWidth,arrayTitle.count*12 + arrayTitle.count*35);//i*12 + 35*ScreenWidth/320 *i

    }else
    {
        showTextView.frame = CGRectMake(0, CGRectGetMaxY(_upsAndDownsLab.frame) + 15, ScreenWidth,arrayTitle.count*12 + arrayTitle.count*45);
    }
//    if ([UIScreen mainScreen].bounds.size.height <=568)
//    {
//        
//            showTextView.frame = CGRectMake(0, CGRectGetMaxY(_priceLabel.frame) + 20*ScreenWidth/320, ScreenWidth,arrayTitle.count*12 + arrayTitle.count*40);
//            showMoneyView.frame = CGRectMake(0, CGRectGetMaxY(showTextView.frame), ScreenWidth, 3*35*ScreenWidth/320);
//        
//        if ([UIScreen mainScreen].bounds.size.height <=480)
//        {
//            bottomView.frame = CGRectMake(0,CGRectGetMaxY(showMoneyView.frame) + 20 , ScreenWidth, 30 +40*667/ScreenHeigth + 10 + 20 + 20);
//        }else if([UIScreen mainScreen].bounds.size.height <=568)
//        {
//            bottomView.frame = CGRectMake(0,CGRectGetMaxY(showMoneyView.frame) + 20 , ScreenWidth, 30 +40*667/ScreenHeigth + 10 + 20 + 20);
//        }
//        
//        tpkScrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(bottomView.frame) - 64);
//        
//    }else
//    {        
//        showTextView.frame = CGRectMake(0, CGRectGetMaxY(_upsAndDownsLab.frame) + 15, ScreenWidth,arrayTitle.count*12 + arrayTitle.count*45);
//        showMoneyView.frame = CGRectMake(0, CGRectGetMaxY(showTextView.frame) + 5*ScreenWidth/320, ScreenWidth, 40.0/568*ScreenHeigth*3);
//        bottomView.frame = CGRectMake(0, tpkScrollView.frame.size.height - (70*ScreenWidth/320 + 40*667/ScreenHeigth), ScreenWidth, 80 +40*667/ScreenHeigth);
//    }
    
    for (NSInteger i = 0; i < arrayTitle.count; i++)
    {
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.text = arrayTitle[i];
        if ([UIScreen mainScreen].bounds.size.height <=480)
        {
            titleLab.frame = CGRectMake(20*ScreenWidth/320,i*12 + 35*ScreenWidth/320 *i, 60, 20);
            
        }else
        {
            titleLab.frame = CGRectMake(20*ScreenWidth/320,i*12 + 45*ScreenWidth/320 *i, 60, 20);
        }
        
        titleLab.textColor = [UIColor lightGrayColor];
        titleLab.backgroundColor = [UIColor blackColor];
        titleLab.font = [UIFont systemFontOfSize:12.0];
        [showTextView addSubview:titleLab];
        
        UILabel *groupLab = [[UILabel alloc]init];
        groupLab.text = arrayDetail[i];
        groupLab.frame = CGRectMake(CGRectGetMinX(titleLab.frame), CGRectGetMaxY(titleLab.frame) -2, 90*ScreenWidth/320, 20);
        groupLab.backgroundColor = [UIColor blackColor];
        groupLab.font = [UIFont systemFontOfSize:11.0];
        [showTextView addSubview:groupLab];
        
        HJCAjustNumButton *btn = [[HJCAjustNumButton alloc]init];
        [btn.textField addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventValueChanged];
        btn.frame = CGRectMake(ScreenWidth - 20*ScreenWidth/320 - 160*ScreenWidth/320, CGRectGetMinY(titleLab.frame), 160*ScreenWidth/320, 35);
        btn.textField.delegate = self;
        btn.textField.font = [UIFont systemFontOfSize:13.0];
//        btn.textField.selectedTextRange = btn.textField.text;
        btn.floatNumStr = _productModel.decimalPlaces;
        
        if (isSegSelect == 0)
        {
            
            if (i == 0)
            {
                //市价手数textfiled
                groupLab.textColor = [UIColor colorWithRed:234/255.0 green:194/255.0 blue:129/255.0 alpha:1];
                btn.textField.tag = Tag_numberofHand;
                groupLab.tag = Tag_buyNumMarket;
                
            }else if (i == 1)
            {
                //市价止盈
                groupLab.textColor = [UIColor lightGrayColor];
                btn.textField.tag = Tag_marketGet;
                btn.textField.placeholder = @"不设置";
                groupLab.tag = Tag_priceMarketGet;
                
            }else if (i == 2)
            {
                //市价止损
                btn.textField.tag = Tag_marketStop;
                groupLab.textColor = [UIColor lightGrayColor];
                btn.textField.placeholder = @"不设置";
                groupLab.tag = Tag_priceMarketStop;
            }

        }else
        {
            
            if (i == 0)
            {
                groupLab.textColor = [UIColor colorWithRed:234/255.0 green:194/255.0 blue:129/255.0 alpha:1];
                btn.textField.text = _priceLabel.text;
                btn.textField.tag = Tag_LimitedPrice;
                //如果是限价，查看五档行情
                groupLab.userInteractionEnabled = YES;
                UITapGestureRecognizer *supportBinkTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkMarket)];
                [groupLab addGestureRecognizer:supportBinkTapGes];

            }else if (i == 1)
            {
                groupLab.textColor = [UIColor colorWithRed:234/255.0 green:194/255.0 blue:129/255.0 alpha:1];
                //限价手数textfiled
                btn.textField.tag = Tag_numberofLimitedHand;
                groupLab.tag = Tag_buyNumLimited;
            }else if (i == 2)
            {
                groupLab.textColor = [UIColor lightGrayColor];
                //限价止盈
                btn.textField.tag = Tag_limitedGet;
                btn.textField.placeholder = @"不设置";
                groupLab.tag = Tag_priceLimitedGet;
            }else if (i == 3)
            {
                groupLab.textColor = [UIColor lightGrayColor];
                //限价止损
                btn.textField.tag = Tag_limitedStop;
                btn.textField.placeholder = @"不设置";
                groupLab.tag = Tag_priceLimitedStop;
            }
        }
        [btn.textField setValue:[UIColor colorWithRed:222/255.0 green:224/255.0 blue:216/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
        
        btn.lineColor = [UIColor lightGrayColor];
        //加号
        btn.callBack = ^(NSString *currentNum,UITextField *textField)
        {
            [self changeBuyNum];
            [self reloadMoneyData];
            [self reloadStopOrGetData];
            
            [self downChangeStopOrGetText:textField];
            if (isSegSelect == 0)//如果是市价
            {
                if (i == 1)
                {
                    marktStop = currentNum;

                }else if (i == 2)
                {
                    marktGet = currentNum;
                }
            }else//如果是限价
            {
                if (i == 2)
                {
                    limitedStop = currentNum;
                }else if (i == 3)
                {
                    limitedStop = currentNum;
                }
            }
        };
        
        btn.callDecreaseBack = ^(NSString *cureentNum,UITextField *textFiled)
        {
            [self changeBuyNum];
            [self reloadMoneyData];
            [self reloadStopOrGetData];
            //减号
            [self downChangeStopOrGetText:textFiled];
        };

        
        //判断文本框输出键盘类型的
        if (i == 0)
        {
            if (isSegSelect == 0)
            {
                btn.textField.keyboardType = UIKeyboardTypeNumberPad;
                btn.isIntOrFloat = 0;
            }else
            {
                btn.textField.keyboardType = UIKeyboardTypeDecimalPad;
                btn.isIntOrFloat = 1;
            }
            
        }else
        {
            if (isSegSelect == 1)
            {
                if (i == 1)
                {
                    btn.isIntOrFloat = 0;
                    btn.textField.keyboardType = UIKeyboardTypeNumberPad;
                }else
                {
                    btn.isIntOrFloat = 1;
                    btn.textField.keyboardType = UIKeyboardTypeDecimalPad;
                }
            }else
            {
                btn.isIntOrFloat = 1;
                btn.textField.keyboardType = UIKeyboardTypeDecimalPad;
            }
        }
        
        [showTextView addSubview:btn];
        
        //选中按钮
        if (isSegSelect == 0)
        {
            if (i != 0)
            {
                UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                selectBtn.tag = Tag_marketSelect + i;
                [selectBtn addTarget:self action:@selector(clickSelectAction:) forControlEvents:UIControlEventTouchUpInside];
                [selectBtn setImage:[UIImage imageNamed:@"spotIndex_normal"] forState:UIControlStateNormal];
                [showTextView addSubview:selectBtn];
                
                if ([UIScreen mainScreen].bounds.size.height <=480)
                {
                    selectBtn.frame     = CGRectMake(10, i*12 + 35*ScreenWidth/320 *i, 40, 35);
                    titleLab.frame = CGRectMake(CGRectGetMaxX(selectBtn.frame),i*12 + 35*ScreenWidth/320 *i, 30, 20);
                    groupLab.frame = CGRectMake(CGRectGetMinX(titleLab.frame), CGRectGetMaxY(titleLab.frame) -2, 90*ScreenWidth/320, 20);
                }else
                {
                    selectBtn.frame     = CGRectMake(10, i*12 + 45*ScreenWidth/320 *i, 40, 35);
                    titleLab.frame = CGRectMake(CGRectGetMaxX(selectBtn.frame),i*12 + 45*ScreenWidth/320 *i, 30, 20);
                    groupLab.frame = CGRectMake(CGRectGetMinX(titleLab.frame), CGRectGetMaxY(titleLab.frame) -2, 90*ScreenWidth/320, 20);
                }
                
                UILabel *stopLab = [[UILabel alloc]init];
                stopLab.hidden = YES;
                if (i == 1)
                {
                    stopLab.text = @"较当前价涨+％";
                    stopLab.textColor = Color_red_pink;
                    stopLab.tag = Tag_marketGetRange;
                }else
                {
                    stopLab.text = @"较当前价跌-％";
                    stopLab.textColor = K_color_green;
                    stopLab.tag = Tag_marketStopRange;
                }
                stopLab.font = [UIFont systemFontOfSize:11.0];
                stopLab.frame = CGRectMake(ScreenWidth - 20*ScreenWidth/320 - 160*ScreenWidth/320, CGRectGetMaxY(btn.frame), 160*ScreenWidth/320, 20);
                stopLab.textAlignment = NSTextAlignmentCenter;
                [showTextView addSubview:stopLab];
                
            }
        }else
        {
            if (i == 0)
            {
                CGSize groupSize = [Helper sizeWithText:groupLab.text font:[UIFont systemFontOfSize:11.0] maxSize:CGSizeMake(90*ScreenWidth/320, 20)];
                groupLab.frame = CGRectMake(CGRectGetMinX(titleLab.frame), CGRectGetMaxY(titleLab.frame) -2, groupSize.width, 20);
                
                //限价查看五档行情的小图标
                UIImageView *limitiedImg = [[UIImageView alloc]init];
                limitiedImg.userInteractionEnabled = YES;
                limitiedImg.frame = CGRectMake(CGRectGetMaxX(groupLab.frame) + 2, 0, 10*ScreenWidth/320, 10*ScreenWidth/320);
                limitiedImg.center = CGPointMake(CGRectGetMaxX(groupLab.frame) + 10, groupLab.center.y);
                limitiedImg.image = [UIImage imageNamed:@"limitied_icon"];
                [showTextView addSubview:limitiedImg];
                
                UITapGestureRecognizer *supportBinkTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkMarket)];
                [limitiedImg addGestureRecognizer:supportBinkTapGes];
            }
            
            if (i == 2 || i == 3)
            {
                UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                //                selectBtn.backgroundColor = [UIColor redColor];
                selectBtn.tag = Tag_limitedSelect + i;
                selectBtn.frame     = CGRectMake(10, i*12 + 45*ScreenWidth/320 *i, 40, 35);
                [selectBtn addTarget:self action:@selector(clickSelectAction:) forControlEvents:UIControlEventTouchUpInside];
                [selectBtn setImage:[UIImage imageNamed:@"spotIndex_normal"] forState:UIControlStateNormal];
                [showTextView addSubview:selectBtn];
                
                if ([UIScreen mainScreen].bounds.size.height <=480)
                {
                    selectBtn.frame     = CGRectMake(10, i*12 + 35*ScreenWidth/320 *i, 40, 35);
                    titleLab.frame = CGRectMake(CGRectGetMaxX(selectBtn.frame),i*12 + 35*ScreenWidth/320 *i, 30, 20);
                    groupLab.frame = CGRectMake(CGRectGetMinX(titleLab.frame), CGRectGetMaxY(titleLab.frame) -2, 100, 20);
                }else
                {
                    selectBtn.frame     = CGRectMake(10, i*12 + 45*ScreenWidth/320 *i, 40, 35);
                    titleLab.frame = CGRectMake(CGRectGetMaxX(selectBtn.frame),i*12 + 45*ScreenWidth/320 *i, 30, 20);
                    groupLab.frame = CGRectMake(CGRectGetMinX(titleLab.frame), CGRectGetMaxY(titleLab.frame) -2, 100, 20);
                }
            
                UILabel *stopLab = [[UILabel alloc]init];
                stopLab.hidden = YES;
                if (i == 2)
                {
                    stopLab.text = @"较当前价涨+％";
                    stopLab.textColor = Color_red_pink;
                    stopLab.tag  = Tag_limitedGetRange;
                }else
                {
                    stopLab.text = @"较当前价跌-％";
                    stopLab.textColor = K_color_green;
                    stopLab.tag = Tag_limitedStopRange;
                }
                stopLab.font = [UIFont systemFontOfSize:11.0];
                stopLab.frame = CGRectMake(ScreenWidth - 20*ScreenWidth/320 - 160*ScreenWidth/320, CGRectGetMaxY(btn.frame), 160*ScreenWidth/320, 20);
                stopLab.textAlignment = NSTextAlignmentCenter;
                [showTextView addSubview:stopLab];
                
            }
        }

    }
    
    if (isSegSelect == 0)
    {
        tishiLab.hidden = NO;
    }else
    {
        tishiLab.hidden = YES;
    }
    [self loadDonwView];
}

#pragma 预扣保证金/成交后手续费/合计支付
- (void)loadDonwView
{
    showMoneyView = [[UIView alloc]init];

    [tpkScrollView addSubview:showMoneyView];
    
    NSArray *arrayTitle;
    NSArray *arrayDetail;

    if (isSegSelect == 0)
    {
        arrayTitle = @[@"参考手续费"];
        arrayDetail = @[@"以成交时对应手续费为准"];
        
    }else
    {
        arrayTitle = @[@"预扣保证金",@"参考手续费"];
        arrayDetail = @[@"",@"以成交时对应手续费为准"];
    }
    
    showMoneyView.frame = CGRectMake(0, CGRectGetMaxY(showTextView.frame) + 5*ScreenWidth/320, ScreenWidth, 40.0/568*ScreenHeigth*arrayTitle.count);

    for (NSInteger i = 0; i < arrayTitle.count; i++)
    {
        UILabel *label = [[UILabel alloc]init];
        label.text = arrayTitle[i];
        label.font = [UIFont systemFontOfSize:11.0];
        label.textColor = [UIColor lightGrayColor];
        CGSize labelSize = [Helper sizeWithText:label.text font:[UIFont systemFontOfSize:14.0] maxSize:CGSizeMake(ScreenWidth/2, 20)];
        label.frame = CGRectMake(20*ScreenWidth/320, 40.0/568*ScreenHeigth*i, labelSize.width, (38.0/568*ScreenHeigth));
        
        [showMoneyView addSubview:label];
        
        UILabel *moneyLab = [[UILabel alloc]init];
        moneyLab.text = @"￥--";
        moneyLab.font = [UIFont systemFontOfSize:14.0];
        moneyLab.textColor = [UIColor colorWithRed:222/255.0 green:224/255.0 blue:216/255.0 alpha:1];
        moneyLab.frame = CGRectMake(CGRectGetMaxX(label.frame), CGRectGetMinY(label.frame), ScreenWidth - CGRectGetMaxX(label.frame) - 20, label.frame.size.height);
        moneyLab.textAlignment = NSTextAlignmentRight;
        [showMoneyView addSubview:moneyLab];
        
        if (isSegSelect == 1)
        {
            moneyLab.tag = i + Tag_moneyLab;
            
            if (i == 1)
            {
                label.frame = CGRectMake(20*ScreenWidth/320, 40.0/568*ScreenHeigth*i, labelSize.width, 20);
                UILabel *groupLab = [[UILabel alloc]init];
                groupLab.text = arrayDetail[i];
                groupLab.frame = CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label.frame) -2, ScreenWidth/2, 20);
                groupLab.textColor = [UIColor lightGrayColor];
                groupLab.backgroundColor = [UIColor blackColor];
                groupLab.font = [UIFont systemFontOfSize:11.0];
                [showMoneyView addSubview:groupLab];
                
                if ([UIScreen mainScreen].bounds.size.height <=568)
                {
                    showMoneyView.frame = CGRectMake(0, CGRectGetMaxY(showTextView.frame), ScreenWidth, (38 + 40)/568*ScreenHeigth*arrayTitle.count);
                    if ([UIScreen mainScreen].bounds.size.height <= 480)
                    {
                        bottomView.frame = CGRectMake(0,CGRectGetMaxY(showMoneyView.frame) + 80 , ScreenWidth, 30 +40*667/ScreenHeigth + 10 + 20 + 20);
                        tpkScrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(bottomView.frame) - 64 + 80);
                    }
                }else
                {
                    showMoneyView.frame = CGRectMake(0, CGRectGetMaxY(showTextView.frame) + 15*ScreenWidth/320, ScreenWidth, (38 + 45)/568*ScreenHeigth*arrayTitle.count);
                }
            }else
            {
                UIView  *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, label.frame.origin.y+label.frame.size.height, ScreenWidth-40, 0.5)];
                lineView.backgroundColor = [UIColor grayColor];
                [showMoneyView addSubview:lineView];
            }

        }else
        {
            moneyLab.tag = i + Tag_moneyLab;
            
            label.frame = CGRectMake(20*ScreenWidth/320, 40.0/568*ScreenHeigth*i, labelSize.width, 20);
            UILabel *groupLab = [[UILabel alloc]init];
            groupLab.text = arrayDetail[i];
            groupLab.frame = CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label.frame) -2, ScreenWidth/2, 20);
            groupLab.textColor = [UIColor lightGrayColor];
            groupLab.backgroundColor = [UIColor blackColor];
            groupLab.font = [UIFont systemFontOfSize:11.0];
            [showMoneyView addSubview:groupLab];
            
            if ([UIScreen mainScreen].bounds.size.height <=568)
            {
                showMoneyView.frame = CGRectMake(0, CGRectGetMaxY(showTextView.frame), ScreenWidth, 50/568*ScreenHeigth*arrayTitle.count);
                if ([UIScreen mainScreen].bounds.size.height <=480)
                {
                    bottomView.frame = CGRectMake(0,CGRectGetMaxY(showMoneyView.frame) + 80 , ScreenWidth, 30 +40*667/ScreenHeigth + 10 + 20 + 20);
                    tpkScrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(bottomView.frame) - 64 + 80);
                }
            }else
            {
                showMoneyView.frame = CGRectMake(0, CGRectGetMaxY(showTextView.frame) + 15*ScreenWidth/320, ScreenWidth, 60/568*ScreenHeigth*arrayTitle.count);
            }
        }
        
    }
}

- (void)loadBottomView
{
    bottomView = [[UIView alloc]init];
    if ([UIScreen mainScreen].bounds.size.height <=568)
    {
        if ([UIScreen mainScreen].bounds.size.height <=480)
        {
            bottomView.frame = CGRectMake(0,CGRectGetMaxY(showMoneyView.frame) + 80 , ScreenWidth, 30 +40*667/ScreenHeigth + 10 + 20 + 20);
            tpkScrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(bottomView.frame) - 64 + 80);
        }else
        {
            bottomView.frame = CGRectMake(0,tpkScrollView.frame.size.height - (50 + 40*667/ScreenHeigth) , ScreenWidth, 30 +40*667/ScreenHeigth + 10 + 20 + 20);
        }
        
        tpkScrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(bottomView.frame) - 64);
        
    }else
    {
        bottomView.frame = CGRectMake(0, tpkScrollView.frame.size.height - (70*ScreenWidth/320 + 40*667/ScreenHeigth), ScreenWidth, 80 +40*667/ScreenHeigth);
    }
    
    [tpkScrollView addSubview:bottomView];
    
    tishiLab = [[UILabel alloc]init];
    tishiLab.text = @"买入价格以成交时市价为准";
    tishiLab.font = [UIFont systemFontOfSize:12.0];
    tishiLab.textColor = K_color_red;
    tishiLab.textAlignment = NSTextAlignmentCenter;
    tishiLab.frame = CGRectMake(0, 0, ScreenWidth, 20);
    [bottomView addSubview:tishiLab];
    
    if (isSegSelect == 0)
    {
        tishiLab.hidden = NO;
    }else
    {
        tishiLab.hidden = YES;
    }
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.tag = 11111111;
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    buyBtn.frame = CGRectMake(20*ScreenWidth/320, CGRectGetMaxY(tishiLab.frame) + 10, ScreenWidth - 20*2*ScreenWidth/320, 40.0/667*ScreenHeigth);
    if (_buyState == 0)
    {
        [buyBtn setTitle:@"看多买入" forState:UIControlStateNormal];
        [buyBtn setBackgroundColor:Color_red_pink];
    }else
    {
        [buyBtn setTitle:@"看空买入" forState:UIControlStateNormal];
        [buyBtn setBackgroundColor:Color_green];
    }
    
    [buyBtn addTarget:self action:@selector(clickBuyAction:) forControlEvents:UIControlEventTouchUpInside];
    buyBtn.clipsToBounds = YES;
    buyBtn.layer.cornerRadius = 3;
    [bottomView addSubview:buyBtn];

}

- (void)loadUIView
{
    _seg = [[UISegmentedControl alloc]initWithItems:@[@"市价",@"限价"]];
    _seg.frame = CGRectMake(ScreenWidth/2-ScreenWidth/5*2/2-10, 0, ScreenWidth/5*2+20, 32.0/667*ScreenHeigth);
    _seg.selectedSegmentIndex = 0;
    [_seg addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventValueChanged];
    _seg.tintColor = [UIColor colorWithRed:234/255.0 green:194/255.0 blue:129/255.0 alpha:1];
    [tpkScrollView addSubview:_seg];

}

#pragma mark 获取行情数据

-(void)getSocketInfo:(NSNotification *)notify{
    NSDictionary    * infoDic = notify.object;
    
    //当前价改变的时候，止盈止损较当前价的涨跌跟着改变
    UILabel *marketGetRangeLab      = [showTextView viewWithTag:Tag_marketGetRange];
    UILabel *marketStopRangeLab     = [showTextView viewWithTag:Tag_marketStopRange];
    
    UITextField *textMarketStop         = [showTextView viewWithTag:Tag_marketStop];
    UITextField *textMarketGet          = [showTextView viewWithTag:Tag_marketGet];
    
    NSString *priceIndexStr = _priceLabel.text;

    if (self.buyState == 0) {
        //看多取的价
        _priceLabel.text = infoDic[@"askPrice"];
        
        if (isSegSelect == 0)
        {
            if ([textMarketGet.text floatValue] != 0)
            {
                //看多的时候：止盈的涨
                marketGetRangeLab.textColor = Color_red_pink;
                //市价涨跌止盈止损较当前幅度（涨：（文本框里的文字-当前价）/当前价*100  跌同涨）
                marketGetRangeLab.text      = [NSString stringWithFormat:@"较当前价涨+%@％",[NSString stringWithFormat:floatNumStr,fabs(([textMarketGet.text floatValue] - [priceIndexStr floatValue])/[priceIndexStr floatValue]*100.00)]];
                marketGetRangeLab.attributedText = [Helper multiplicityText:marketGetRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];
            }
            
            if ([textMarketStop.text floatValue] != 0)
            {
                //止损
                marketStopRangeLab.textColor = K_color_green;
                marketStopRangeLab.hidden = NO;
                marketStopRangeLab.text     = [NSString stringWithFormat:@"较当前价跌-%@％",[NSString stringWithFormat:floatNumStr,fabs(([textMarketStop.text floatValue] - [priceIndexStr floatValue])/[priceIndexStr floatValue]*100.00)]];
                marketStopRangeLab.attributedText = [Helper multiplicityText:marketStopRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];
            }
        }
    }
    else if (self.buyState == 1){
        //看空取的价
        _priceLabel.text = infoDic[@"bidPrice"];
        
        if (isSegSelect == 0)
        {
            if ([textMarketGet.text floatValue] != 0)
            {
                //=====止盈
                marketGetRangeLab.textColor = K_color_green;
                marketGetRangeLab.text     = [NSString stringWithFormat:@"较当前价跌-%@％",[NSString stringWithFormat:floatNumStr,fabs(([textMarketGet.text floatValue] - [priceIndexStr floatValue])/[priceIndexStr floatValue]*100.00)]];
                marketGetRangeLab.attributedText = [Helper multiplicityText:marketGetRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];
            }
            
            if ([textMarketStop.text floatValue] != 0)
            {
                //止损
                marketStopRangeLab.textColor = Color_red_pink;
                //市价涨跌止盈止损较当前幅度（涨：（文本框里的文字-当前价）/当前价*100  跌同涨）
                marketStopRangeLab.text      = [NSString stringWithFormat:@"较当前价涨+%@％",[NSString stringWithFormat:floatNumStr,fabs(([textMarketStop.text floatValue] - [priceIndexStr floatValue])/[priceIndexStr floatValue]*100.00)]];
                marketStopRangeLab.attributedText = [Helper multiplicityText:marketStopRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];
            }
        }
    }
    
    _upsAndDownsLab.text = infoDic[@"changePercent"];
    [self reloadMoneyData];
}

-(void)segClick:(UISegmentedControl *)seg
{
    [self requestCotsLowOrHighPriceData];
    if (seg.selectedSegmentIndex == 0) {
        NSLog(@"市价");
        isSegSelect = 0;
        [showTextView removeFromSuperview];
        [showMoneyView removeFromSuperview];
        [self loadUpView];
        
    }else
    {
        isSegSelect = 1;
        [showTextView removeFromSuperview];
        [showMoneyView removeFromSuperview];
        [self loadUpView];
        NSLog(@"限价");
    }

    //    [self isRefreshData];//读取缓存中得数据（暂时先屏蔽掉）
}

#pragma mark - 看多买入或者看空买入？
- (void)clickBuyAction:(UIButton *)sender
{
    UITextField *textMarketStop = [showTextView viewWithTag:Tag_marketStop];
    UITextField *textMarketGet = [showTextView viewWithTag:Tag_marketGet];
    UITextField *textLimitedStop = [showTextView viewWithTag:Tag_limitedStop];
    UITextField *textLimitedGet = [showTextView viewWithTag:Tag_limitedGet];
    
    UITextField *textNumberHand = [showTextView viewWithTag:Tag_numberofHand];
    UITextField *limitedNumbHand = [showTextView viewWithTag:Tag_numberofLimitedHand];
    
    //点击看多买入的时候进行缓存

    isFirstIndex = @"NO";
    _spotIndexDicName = [NSString stringWithFormat:@"%@SpotIndexDic",_productModel.instrumentCode];
    //缓存
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    cacheModel.isFirstSpotIndex = isFirstIndex;
    if (cacheModel.tradeDic == nil) {
        cacheModel.tradeDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    if (cacheModel.tradeDic[_spotIndexDicName] == nil) {
        cacheModel.tradeDic[_spotIndexDicName] = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    
    if (isSegSelect == 0)
    {
        if ((isSelectMarketGet == YES && isSelectMarketStop == NO) || (isSelectMarketStop == YES && isSelectMarketGet == NO))//只有止盈止损同时选中
        {
            [UIEngine showShadowPrompt:@"止盈止损需要同时选中"];
            return;

        }else if (textMarketGet.text.length >0 && textMarketStop.text.length > 0)
        {
            //吧止盈止损缓存（暂时没有用到）
            [_marketPriceDic setObject:textMarketStop.text forKey:KMarketStop];
            [_marketPriceDic setObject:textMarketGet.text forKey:KMarketGet];
            [cacheModel.tradeDic[_spotIndexDicName] setObject:_marketPriceDic forKey:KspotIndexMarketDic];
           
        }
        
        if ([textNumberHand.text floatValue]  == 0 && [userFund floatValue] >0)
        {
            [UIEngine showShadowPrompt:@"手数未设置"];
            return;
        }
    
        [self requestMarketOrder];//市价委托下单接口调用
       
    }else
    {
        if ((isSelectLimitedGet == NO && isSelectLimitedStop == YES)|| (isSelectLimitedStop == NO && isSelectLimitedGet == YES))
        {
            [UIEngine showShadowPrompt:@"止盈止损需要同时选中"];
            return;
        }
        
        [_limitedPriceDic setObject:textLimitedStop.text forKey:KLimitedStop];
        [_limitedPriceDic setObject:textLimitedGet.text forKey:KLImitedGet];
        [cacheModel.tradeDic[_spotIndexDicName] setObject:_limitedPriceDic forKey:KspotIndexLimitedDic];
        
        if ([limitedNumbHand.text floatValue]  == 0 && [userFund floatValue] > 0)
        {
            [UIEngine showShadowPrompt:@"手数未设置"];
            return;
        }
        [self requestLimitedData:@"NO"];
    }
    
    [CacheEngine setCacheInfo:cacheModel];
    
}

-(void)agreeBtnClick:(UIButton *)btn{
    if (btn.selected) {
        btn.selected = NO;
    }
    else{
        btn.selected = YES;
    }
    
}

#pragma mark - 现货合作协议入口
-(void)lookRule
{
    NSLog(@"跳入到现货合作协议");
}

#pragma mark - 查看五档行情
- (void)checkMarket
{
    fiveBackView = [[UIView alloc]init];
    fiveBackView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
    fiveBackView.backgroundColor = [UIColor blackColor];
    fiveBackView.alpha = 0.7;
    [self.view addSubview:fiveBackView];
    
    if (markeIsStatus == 9)
    {
        MarketIsStatusAlert *markeView = [[MarketIsStatusAlert alloc]init];
        markeView.frame = CGRectMake(30, ScreenHeigth/2 -(40*ScreenWidth/320*2 + 40 + 40.0/667*ScreenHeigth)/2 , ScreenWidth - 60,40*ScreenWidth/320*2 + 40 + 40.0/667*ScreenHeigth);
        [markeView initMarketStatus];
        markeView.layer.cornerRadius = 8;
        markeView.layer.masksToBounds = YES;
        markeView.backgroundColor = K_color_red;
        [self.view addSubview:markeView];
        
        [markeView setClickSureAction:^()
         {
             [fiveBackView removeFromSuperview];
         }];
    }else
    {
        FiveMarketView *fiveView = [[FiveMarketView alloc]init];
        fiveView.tag = 898989;
        fiveView.btnTitle = @"买入";
        fiveView.instrumentType = _productModel.instrumentCode;
        fiveView.buyState = _buyState;
        
        CGFloat fiveHeight = 25*ScreenWidth/320*10 + 20 + 15*ScreenWidth/320 + 40 + 30*ScreenWidth/320 + 40/667*ScreenHeigth + 50;
        
        fiveView.frame = CGRectMake(35*ScreenWidth/320, (ScreenHeigth - fiveHeight)/2, ScreenWidth - 35*ScreenWidth/320*2 , fiveHeight);
        [fiveView initTableView];
        fiveView.layer.cornerRadius = 8;
        fiveView.layer.masksToBounds = YES;
        [fiveView setClickBack:^()
         {
             NSLog(@"---");
             [fiveBackView removeFromSuperview];
             
         }];
        
        [fiveView setClickBuy:^(NSString *priceStr)
         {
             [fiveBackView removeFromSuperview];
             [self requestLimitedData:priceStr];
             
         }];
        [self.view addSubview:fiveView];
    }
//    fiveBackView = [[UIView alloc]init];
//    fiveBackView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
//    fiveBackView.backgroundColor = [UIColor blackColor];
//    fiveBackView.alpha = 0.7;
//    [self.view addSubview:fiveBackView];
    
}

#pragma mark - 返回按钮
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 刷新数据
- (void)reloadSpotIndextData
{
    UITextField *textMarketStop = [showTextView viewWithTag:Tag_marketStop];
    UITextField *textMarketGet = [showTextView viewWithTag:Tag_marketGet];
    UITextField *textLimitedStop = [showTextView viewWithTag:Tag_limitedStop];
    UITextField *textLimitedGet = [showTextView viewWithTag:Tag_limitedGet];
   
    //缓存
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    _spotIndexDicName = [NSString stringWithFormat:@"%@SpotIndexDic",_productModel.instrumentCode];
    
    if (isSegSelect == 0)//市价
    {
        NSMutableDictionary *marketDataDic = [NSMutableDictionary dictionaryWithDictionary:cacheModel.tradeDic[_spotIndexDicName][KspotIndexMarketDic]];
        
//        NSLog(@"缓存：%@",marketDataDic);[loginBtn setAlpha:(bEnable ? 1:0.9)];
//        textMarketStop.text = [marketDataDic[KMarketStop] isEqualToString:@""]?@"可设置":marketDataDic[KMarketStop];
        
        NSLog(@"缓存测试：%@",marketDataDic);
        if ([marketDataDic[KMarketStop] isEqualToString:@""] || marketDataDic[KMarketStop] == nil) {
            textMarketStop.placeholder = @"不设置";
        }else
        {
            textMarketStop.text = marketDataDic[KMarketStop];
        }
        
        if ([marketDataDic[KMarketGet] isEqualToString:@""] || marketDataDic[KMarketGet] == nil)
        {
            textMarketGet.placeholder  = @"不设置";
        }else
        {
            textMarketGet.text  = marketDataDic[KMarketGet];
        }
        
    }else
    {
        NSMutableDictionary *limitedDataDic = [NSMutableDictionary dictionaryWithDictionary:cacheModel.tradeDic[_spotIndexDicName][KspotIndexLimitedDic]];
        
        if ([limitedDataDic[KLimitedStop] isEqualToString:@""] || limitedDataDic[KLimitedStop] == nil) {
            textLimitedStop.placeholder = @"不设置";
        }else
        {
            textLimitedStop.text = limitedDataDic[KLimitedStop];
        }
        
        if ([limitedDataDic[KLImitedGet] isEqualToString:@""] || limitedDataDic[KLImitedGet] == nil)
        {
            textLimitedGet.placeholder  = @"不设置";
        }else
        {
            textLimitedGet.text  = limitedDataDic[KLImitedGet];
        }

    }
    
    [textMarketGet setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [textMarketStop setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [textLimitedStop setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [textLimitedGet setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self reloadStopOrGetData];
    [self reloadMoneyData];
}

#pragma mark - 刷新下面保证金手续费等数据
- (void)reloadMoneyData
{
    UITextField *textNumberHand = [showTextView viewWithTag:Tag_numberofHand];
    UITextField *limitedNumbHand = [showTextView viewWithTag:Tag_numberofLimitedHand];
    
    
    UITextField *textLimitedPrice       = [showTextView viewWithTag:Tag_LimitedPrice];
    
    if (isSegSelect == 0)
    {
        UILabel *cauMoney = [showMoneyView viewWithTag:Tag_moneyLab];
        
        //手续费计算方法：当前价*手数*PounDageNum
        cauMoney.text = [NSString stringWithFormat:@"￥%@",[NSString stringWithFormat:floatNumStr,[textNumberHand.text doubleValue]*[_priceLabel.text doubleValue] *PounDageNum]];
        
    }else
    {
        UILabel *cauMoney = [showMoneyView viewWithTag:Tag_moneyLab];
        UILabel *chargeLab = [showMoneyView viewWithTag:Tag_moneyLab + 1];
        
        //保证金计算方法：当前价*手数*10%
        cauMoney.text = [NSString stringWithFormat:@"￥%@",[NSString stringWithFormat:floatNumStr,[limitedNumbHand.text doubleValue] *[textLimitedPrice.text doubleValue] *CauMoneyNum]];
        
        //手续费//手续费计算方法：当前价*手数*PounDageNum
        chargeLab.text = [NSString stringWithFormat:@"￥%@",[NSString stringWithFormat:floatNumStr,[limitedNumbHand.text doubleValue]*[textLimitedPrice.text doubleValue] *PounDageNum]];
    }
    
}


#pragma mark - 获取用户总资产
- (void)getUserFund
{
    [RequestDataModel requestCashUserFundSuccessBlock:^(BOOL success, NSDictionary *dictionary) {
        if (success)
        {
            userFund = [NSString stringWithFormat:@"%.2f",[dictionary[@"ENABLEMONEY"] floatValue]];
        }
//        userFund = [NSString stringWithFormat:@"%.2f",[@"1000" floatValue]];
        
        
        NSString *moneyStr = [NSString stringWithFormat:@"%f",([userFund floatValue ]*PounMoneyNum - [userFund floatValue]*PounDageNum*PounMoneyNum)/[_priceLabel.text floatValue]];
       
        if ([moneyStr intValue]>=100000)
        {
            NSString *str =[NSString stringWithFormat:@"%d",(int)[moneyStr intValue]/10000];
            userBuyNum=[[str substringToIndex:str.length-1] stringByAppendingString:@"万"];
        }else
        {
            userBuyNum =  [NSString stringWithFormat:@"%d",(int)[moneyStr intValue]];
        }
        
        UILabel *marketLab = [showTextView viewWithTag:Tag_buyNumMarket];
        UILabel *limitedLab = [showTextView viewWithTag:Tag_buyNumLimited];
        UITextField *textNumberHand = [showTextView viewWithTag:Tag_numberofHand];
        UITextField *limitedNumbHand = [showTextView viewWithTag:Tag_numberofLimitedHand];
        
        if ([userBuyNum intValue] > 100)
        {
            textNumberHand.text = @"100";
            limitedNumbHand.text = @"100";
        }else
        {
            limitedNumbHand.text = userBuyNum;
            textNumberHand.text = userBuyNum;
        }
        
        marketLab.text = [NSString stringWithFormat:@"可买%@手",userBuyNum];
        limitedLab.text = [NSString stringWithFormat:@"可买%@手",userBuyNum];

        [self reloadMoneyData];//刷新下面手续费的钱
    }];
}

#pragma mark - 市价委托下单
- (void)requestMarketOrder
{
    UITextField *textMarketStop = [showTextView viewWithTag:Tag_marketStop];
    UITextField *textMarketGet = [showTextView viewWithTag:Tag_marketGet];
    UITextField *textNumberHand = [showTextView viewWithTag:Tag_numberofHand];

//    NSString *markeStopStr = [textMarketStop.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
//    NSString *markeGetStr  = [textMarketGet.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    
    NSString * token = [[SpotgoodsAccount sharedInstance] getSpotgoodsToken];
    NSString *tradeId = [[SpotgoodsAccount sharedInstance] getTradeID];
    NSString *buyOrSal = @"";
    if (_buyState == 0)//0看多。（买入）1卖出
    {
        buyOrSal = @"B";
    }else
    {
        buyOrSal = @"S";
    }
    
    NSDictionary *dic;
    
    if (textMarketStop.text.length > 0 && textMarketGet.text.length > 0)
    {
        dic = @{@"token":token,@"traderId":tradeId,@"buyOrSal":buyOrSal,@"wareId":_productModel.instrumentID,@"price":_priceLabel.text,@"upPrice":@([textMarketGet.text doubleValue]),@"downPrice":@([textMarketStop.text doubleValue]),@"num":@([textNumberHand.text intValue])};
    }else
    {
        dic = @{@"token":token,@"traderId":tradeId,@"buyOrSal":buyOrSal,@"wareId":_productModel.instrumentID,@"price":_priceLabel.text,@"num":@([textNumberHand.text intValue])};
    }
    
    
    
    [NetRequest postRequestWithNSDictionary:dic url:K_Cash_MarketOrder successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            fiveBackView = [[UIView alloc]init];
            fiveBackView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
            fiveBackView.backgroundColor = [UIColor blackColor];
            fiveBackView.alpha = 0.7;
            [self.view addSubview:fiveBackView];
            
            __block EntrustView *enView = [[EntrustView alloc]init];
            enView.backgroundColor = Color_red_pink;
            enView.frame = CGRectMake(35, ScreenHeigth/2-(80 + 55*ScreenWidth/320 + 40/667*ScreenHeigth)/2, ScreenWidth - 35*2,  55*ScreenWidth/320 + 80 + 40.0/667*ScreenHeigth);
            enView.layer.cornerRadius = 5;
            enView.layer.masksToBounds = YES;
            [self.view addSubview:enView];
            [enView setClicCheckEntrust:^()
             {
                 //跳转到委托单界面
                 [fiveBackView removeFromSuperview];
                 MyCashOrderPage * vc = [[MyCashOrderPage alloc] init];
                 vc.productModel = self.productModel;
                 vc.myCashOrderStyle = MyCashOrderSign;
                 [self.navigationController pushViewController:vc animated:YES];
             }];
            
            [enView setClickSureAction:^()
             {
                 [fiveBackView removeFromSuperview];
                 //返回到持仓页面
                 [[NSNotificationCenter defaultCenter] postNotificationName:kSegValueChange object:nil];
                 UIViewController *viewController = self.navigationController.viewControllers[1];
                 [self.navigationController popToViewController:viewController animated:YES];
             }];
            
            [enView initEntrustView];

        }else
        {
            [[UIEngine sharedInstance] showAlertWithTitle:dictionary[@"msg"] ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
            [UIEngine sharedInstance].alertClick =^ (int aIndex){
                
            };
        }
        
    } failureBlock:^(NSError *error) {
        NSLog(@"失败");
    }];
}

#pragma mark - 限价委托下单
- (void)requestLimitedData:(NSString *)priceStr
{
    UITextField *textLimitedStop = [showTextView viewWithTag:Tag_limitedStop];
    UITextField *textLImitedGet = [showTextView viewWithTag:Tag_limitedGet];
    //上面的要更改
    UITextField *limitedNumbHand = [showTextView viewWithTag:Tag_numberofLimitedHand];
    UITextField *limitedPrice    = [showTextView viewWithTag:Tag_LimitedPrice];
    
    NSString * token = [[SpotgoodsAccount sharedInstance] getSpotgoodsToken];
    NSString *tradeId = [[SpotgoodsAccount sharedInstance] getTradeID];
    
    NSString *buyOrSal = @"";
    if (_buyState == 0)//0看多。（买入）1卖出
    {
        buyOrSal = @"B";
    }else
    {
        buyOrSal = @"S";
    }
    
    NSString *limitedPriceStr = @"";
    if ([priceStr isEqualToString:@"NO"])
    {
        limitedPriceStr = limitedPrice.text;
    }else
    {
        limitedPriceStr = priceStr;
    }
    
    NSDictionary * dic;
    if (textLImitedGet.text.length > 0 && textLimitedStop.text.length > 0)
    {
        dic = @{@"token":token,@"traderId":tradeId,@"buyOrSal":buyOrSal,@"wareId":_productModel.instrumentID,@"price":@([limitedPriceStr doubleValue]),@"upPrice":@([textLImitedGet.text doubleValue]),@"downPrice":@([textLimitedStop.text doubleValue]),@"num":@([limitedNumbHand.text intValue])};

    }else
    {
        dic = @{@"token":token,@"traderId":tradeId,@"buyOrSal":buyOrSal,@"wareId":_productModel.instrumentID,@"price":@([limitedPriceStr doubleValue]),@"num":@([limitedNumbHand.text intValue])};
    }
    
    
    [NetRequest postRequestWithNSDictionary:dic url:K_Cash_LimitedOrder successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            fiveBackView = [[UIView alloc]init];
            fiveBackView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
            fiveBackView.backgroundColor = [UIColor blackColor];
            fiveBackView.alpha = 0.7;
            [self.view addSubview:fiveBackView];
            
           __block EntrustView *enView = [[EntrustView alloc]init];
            enView.backgroundColor = Color_red_pink;
            enView.frame = CGRectMake(35, ScreenHeigth/2-(80 + 55*ScreenWidth/320 + 40/667*ScreenHeigth)/2, ScreenWidth - 35*2,  55*ScreenWidth/320 + 80 + 40.0/667*ScreenHeigth);
            enView.layer.cornerRadius = 5;
            enView.layer.masksToBounds = YES;
            [self.view addSubview:enView];
            [enView setClicCheckEntrust:^()
             {
                 //跳转到委托单界面
                 [fiveBackView removeFromSuperview];
                 MyCashOrderPage * vc = [[MyCashOrderPage alloc] init];
                 vc.productModel = self.productModel;
                 vc.myCashOrderStyle = MyCashOrderSign;
                 [self.navigationController pushViewController:vc animated:YES];
             }];
            
            [enView setClickSureAction:^()
            {
                [fiveBackView removeFromSuperview];
                //返回到持仓页面
                [[NSNotificationCenter defaultCenter] postNotificationName:kSegValueChange object:nil];
                UIViewController *viewController = self.navigationController.viewControllers[1];
                [self.navigationController popToViewController:viewController animated:YES];
            }];
            
            [enView initEntrustView];
            
        }else
        {
            [[UIEngine sharedInstance] showAlertWithTitle:dictionary[@"msg"] ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
            [UIEngine sharedInstance].alertClick =^ (int aIndex){
                
            };
        }
        
    } failureBlock:^(NSError *error) {
        NSLog(@"失败");
    }];

}

#pragma mark - 获取交易系统是否已经闭市
- (void)requestMarketIsStatus
{
    [RequestDataModel requestMarketIsStatus:_productModel.instrumentCode futureCode:_productModel.instrumentID successBlock:^(BOOL success,NSInteger marketStatus)
    {
        if (success)
        {
            markeIsStatus = marketStatus;
            if (marketStatus == 9)
            {
                fiveBackView = [[UIView alloc]init];
                fiveBackView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
                fiveBackView.backgroundColor = [UIColor blackColor];
                fiveBackView.alpha = 0.7;
                [self.view addSubview:fiveBackView];
                
                MarketIsStatusAlert *markeView = [[MarketIsStatusAlert alloc]init];
                markeView.frame = CGRectMake(30, ScreenHeigth/2 -(40*ScreenWidth/320*2 + 40 + 40.0/667*ScreenHeigth)/2 , ScreenWidth - 60,40*ScreenWidth/320*2 + 40 + 40.0/667*ScreenHeigth);
                [markeView initMarketStatus];
                markeView.layer.cornerRadius = 8;
                markeView.layer.masksToBounds = YES;
                markeView.backgroundColor = K_color_red;
                [self.view addSubview:markeView];

                [markeView setClickSureAction:^()
                {
                    [fiveBackView removeFromSuperview];
                }];
                
                UIButton *bottomBtn = [bottomView viewWithTag:11111111];
                [bottomBtn setTitle:@"已闭市" forState:UIControlStateNormal];
                bottomBtn.backgroundColor = [UIColor grayColor];
                bottomBtn.enabled = NO;
            }else
            {
                UIButton *bottomBtn = [bottomView viewWithTag:11111111];
                bottomBtn.enabled = YES;
                
                if (_buyState == 0)
                {
                    [bottomBtn setTitle:@"看多买入" forState:UIControlStateNormal];
                    bottomBtn.backgroundColor = Color_red_pink;
                }else
                {
                    [bottomBtn setTitle:@"看空买入" forState:UIControlStateNormal];
                    bottomBtn.backgroundColor = Color_green;
                }
            }
        }
    }];
}
//    NSDictionary * dic = @{@"futureType":_productModel.instrumentCode,@"futureCode":_productModel.instrumentID};
//        
//    [NetRequest postRequestWithNSDictionary:dic url:K_Cash_MarketIsStatus successBlock:^(NSDictionary *dictionary) {
//        
//        if ([dictionary[@"code"] intValue]==200)
//        {
//            NSInteger marketStatus = [dictionary[@"data"][@"status"] intValue];
//            NSLog(@"status:%@",dictionary[@"data"][@"status"]);
//            if (marketStatus == 0)//市场闭市
//            {
//                UIButton *bottomBtn = [bottomView viewWithTag:11111111];
//                [bottomBtn setTitle:@"已闭市" forState:UIControlStateNormal];
//                bottomBtn.backgroundColor = [UIColor grayColor];
//                bottomBtn.enabled = NO;
//            }
//            
//        }
//    } failureBlock:^(NSError *error) {
//        
//    }];

#pragma mark - 获取涨停价、跌停价
- (void)requestCotsLowOrHighPriceData
{
    NSString * token = [[SpotgoodsAccount sharedInstance] getSpotgoodsToken];
    NSString *tradeId = [[SpotgoodsAccount sharedInstance] getTradeID];

    NSDictionary *dic;
    
    if (token != nil  && tradeId != nil)
    {
        dic = @{@"token":token,@"traderId":tradeId,@"wareId":_productModel.instrumentID};
    }
    
    [NetRequest postRequestWithNSDictionary:dic url:K_Cash_LowsOrHighPrice successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            NSArray * array = [NSArray arrayWithObject:dictionary[@"data"][@"DATAS"]];
            _highestPrice = [array[0][0] objectForKey:@"LIMITUP"];
            _lowestPrice  = [array[0][0] objectForKey:@"LIMITDOWN"];;
            
            NSInteger userNum;
            if (_buyState == 0)
            {
                userNum = [[array[0][0] objectForKey:@"MAXBQTY"] intValue];//用户可下单手数
            }else
            {
                userNum = [[array[0][0] objectForKey:@"MAXSQTY"] intValue];//用户可下单手数
            }
            
            if (userNum>=100000)
            {
                NSString *str =[NSString stringWithFormat:@"%d",(int)userNum/10000];
                userBuyNum=[[str substringToIndex:str.length-1] stringByAppendingString:@"万"];
            }else
            {
                userBuyNum =  [NSString stringWithFormat:@"%ld",(long)userNum];
            }
            
            UILabel *marketLab = [showTextView viewWithTag:Tag_buyNumMarket];
            UILabel *limitedLab = [showTextView viewWithTag:Tag_buyNumLimited];
            UITextField *textNumberHand = [showTextView viewWithTag:Tag_numberofHand];
            UITextField *limitedNumbHand = [showTextView viewWithTag:Tag_numberofLimitedHand];
            
            if ([userBuyNum intValue] > 100)
            {
                textNumberHand.text = @"100";
                limitedNumbHand.text = @"100";
            }else
            {
                limitedNumbHand.text = userBuyNum;
                textNumberHand.text = userBuyNum;
            }
            
            marketLab.text = [NSString stringWithFormat:@"可买%@手",userBuyNum];
            limitedLab.text = [NSString stringWithFormat:@"可买%@手",userBuyNum];
            
            [self reloadMoneyData];//刷新下面手续费的钱

        }
    } failureBlock:^(NSError *error) {
        
        NSLog(@"失败");
    }];

}

#pragma mark - 刷新止盈止损的价格
- (void)reloadStopOrGetData
{
//    UILabel *marketStopLab = [showTextView viewWithTag:Tag_priceMarketStop];
//    UILabel *marketGetLab = [showTextView viewWithTag:Tag_priceMarketGet];
//    UILabel *limitedStopLab = [showTextView viewWithTag:Tag_priceLimitedStop];
//    UILabel *limitedGetLab = [showTextView viewWithTag:Tag_priceLimitedGet];
    
    UITextField *textLimitedPrice       = [showTextView viewWithTag:Tag_LimitedPrice];
    
    UITextField *textMarketStop = [showTextView viewWithTag:Tag_marketStop];
    UITextField *textMarketGet = [showTextView viewWithTag:Tag_marketGet];
    UITextField *textLimitedStop = [showTextView viewWithTag:Tag_limitedStop];
    UITextField *textLimitedGet = [showTextView viewWithTag:Tag_limitedGet];
    
    UILabel *marketGetRangeLab      = [showTextView viewWithTag:Tag_marketGetRange];
    UILabel *limitedGetRangeLab     = [showTextView viewWithTag:Tag_limitedGetRange];
    UILabel *marketStopRangeLab     = [showTextView viewWithTag:Tag_marketStopRange];
    UILabel *limitedStopRangeLab    = [showTextView viewWithTag:Tag_limitedStopRange];
    
//    UITextField *textNumberHand = [showTextView viewWithTag:Tag_numberofHand];
//    UITextField *limitedNumbHand = [showTextView viewWithTag:Tag_numberofLimitedHand];
    
    UIButton *marketSelectStop = (UIButton *)[showTextView viewWithTag:Tag_marketSelect + 2];
    UIButton *marketSelectGet = (UIButton *)[showTextView viewWithTag:Tag_marketSelect + 1];
    UIButton *limitedSelectStop = (UIButton *)[showTextView viewWithTag:Tag_limitedSelect + 3];
    UIButton *limitedSelectGet = (UIButton *)[showTextView viewWithTag:Tag_limitedSelect + 2];
    
//    float incrNum                       = powf(10, [_productModel.decimalPlaces intValue]);
//    //当前价+1个点
//    NSString *priceGetStr               = [NSString stringWithFormat:floatNumStr,[_priceLabel.text floatValue] + 1/incrNum];
//    //当前价-1个点
//    NSString *priceStopStr              = [NSString stringWithFormat:floatNumStr,[_priceLabel.text floatValue] - 1/incrNum];
//    NSString *hightPriceStr             = _highestPrice;
//    
//    NSString *lowPriceStr               = [NSString stringWithFormat:floatNumStr,([_lowestPrice floatValue] - [_lowestPrice floatValue]*RangeStopLow)];
    
    NSString *priceIndexStr = _priceLabel.text;

    
    if (isSegSelect == 0)
    {
        //是否勾选市价上止盈止损
        if (textMarketStop.text.length > 0)
        {
            //选中
            [marketSelectStop setImage:[UIImage imageNamed:@"spotIndex_select"] forState:UIControlStateNormal];
            [marketSelectStop setSelected:YES];
            isSelectMarketStop = YES;
            
            if (![_priceLabel.text isEqualToString:@"--"] || [_priceLabel.text floatValue] != 0)
            {
                float marketText = ([textMarketStop.text floatValue] - [priceIndexStr floatValue])/[priceIndexStr floatValue]*100.00;
                marketStopRangeLab.hidden = NO;
                if (_buyState == 0)//看多
                {
                    marketStopRangeLab.textColor = K_color_green;
                    if (marketText > 0)//如果大于0 就加一个加号，否则不做操作
                    {
                        marketStopRangeLab.text     = [NSString stringWithFormat:@"较当前价跌+%@％",[NSString stringWithFormat:floatNumStr,marketText]];
                    }else
                    {
                        marketStopRangeLab.text     = [NSString stringWithFormat:@"较当前价跌%@％",[NSString stringWithFormat:floatNumStr,marketText]];
                    }
                    
                    marketStopRangeLab.attributedText = [Helper multiplicityText:marketStopRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];
                }else if (_buyState == 1)//看空
                {
                    marketStopRangeLab.textColor = Color_red_pink;
                    //市价涨跌止盈止损较当前幅度（涨：（文本框里的文字-当前价）/当前价*100  跌同涨）
                    
                    if (marketText > 0)
                    {
                        marketStopRangeLab.text      = [NSString stringWithFormat:@"较当前价涨+%@％",[NSString stringWithFormat:floatNumStr,marketText]];
                    }else
                    {
                        marketStopRangeLab.text      = [NSString stringWithFormat:@"较当前价涨%@％",[NSString stringWithFormat:floatNumStr,marketText]];
                    }
                    
                    marketStopRangeLab.attributedText = [Helper multiplicityText:marketStopRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];
                }
                
            }
        }else
        {
            //未选中
            [marketSelectStop setImage:[UIImage imageNamed:@"spotIndex_normal"] forState:UIControlStateNormal];
            [marketSelectStop setSelected:NO];
            isSelectMarketStop = NO;
            marketStopRangeLab.hidden = YES;
        }
        
        //是否勾选市价上止盈止损
        if (textMarketGet.text.length > 0)
        {
            //选中
            [marketSelectGet setImage:[UIImage imageNamed:@"spotIndex_select"] forState:UIControlStateNormal];
            [marketSelectGet setSelected:YES];
            isSelectMarketGet = YES;
            
            if (![_priceLabel.text isEqualToString:@"--"] || [_priceLabel.text floatValue] != 0)
            {
                marketGetRangeLab.hidden = NO;
                float marketGetRangeText = ([textMarketGet.text floatValue] - [priceIndexStr floatValue])/[priceIndexStr floatValue]*100.00;
                
                if (_buyState == 0)//看多
                {
                    marketGetRangeLab.textColor = Color_red_pink;
                    //市价涨跌止盈止损较当前幅度（涨：（文本框里的文字-当前价）/当前价*100  跌同涨）
                    if (marketGetRangeText > 0)//如果大于0 。加一个加号
                    {
                        marketGetRangeLab.text      = [NSString stringWithFormat:@"较当前价涨+%@％",[NSString stringWithFormat:floatNumStr,marketGetRangeText]];
                    }else
                    {
                        marketGetRangeLab.text      = [NSString stringWithFormat:@"较当前价涨%@％",[NSString stringWithFormat:floatNumStr,marketGetRangeText]];
                    }
                    
                    marketGetRangeLab.attributedText = [Helper multiplicityText:marketGetRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];

                }else if (_buyState == 1)//看空
                {
                    marketGetRangeLab.textColor = K_color_green;
                    //市价涨跌止盈止损较当前幅度（涨：（文本框里的文字-当前价）/当前价*100  跌同涨）
                    
                    if (marketGetRangeText > 0)
                    {
                        marketGetRangeLab.text      = [NSString stringWithFormat:@"较当前价跌+%@％",[NSString stringWithFormat:floatNumStr,marketGetRangeText]];
                    }else
                    {
                        marketGetRangeLab.text      = [NSString stringWithFormat:@"较当前价跌%@％",[NSString stringWithFormat:floatNumStr,marketGetRangeText]];
                    }
                    
                    marketGetRangeLab.attributedText = [Helper multiplicityText:marketGetRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];

                }
            }
        }else
        {
            //未选中
            [marketSelectGet setImage:[UIImage imageNamed:@"spotIndex_normal"] forState:UIControlStateNormal];
            [marketSelectGet setSelected:NO];
            isSelectMarketGet = NO;
            marketGetRangeLab.hidden = YES;
        }

        
    }else
    {
        //是否勾选限价上止盈止损
        if (textLimitedStop.text.length > 0)
        {
            //选中
            [limitedSelectStop setImage:[UIImage imageNamed:@"spotIndex_select"] forState:UIControlStateNormal];
            [limitedSelectStop setSelected:YES];
            isSelectLimitedStop = YES;
            
            if (![textLimitedPrice.text isEqualToString:@""] && textLimitedPrice.text != nil && [textLimitedPrice.text floatValue] != 0)
            {
                float limitedStopRangeText = ([textLimitedStop.text floatValue] - [textLimitedPrice.text floatValue])/[textLimitedPrice.text floatValue]*100.00;
                
                if (_buyState == 0)
                {
                    limitedStopRangeLab.textColor = K_color_green;
                    if (limitedStopRangeText > 0)
                    {
                        limitedStopRangeLab.text     = [NSString stringWithFormat:@"较限价跌+%@％",[NSString stringWithFormat:floatNumStr,limitedStopRangeText]];
                    }else
                    {
                        limitedStopRangeLab.text     = [NSString stringWithFormat:@"较限价跌%@％",[NSString stringWithFormat:floatNumStr,limitedStopRangeText]];
                    }
                    
                    limitedStopRangeLab.attributedText = [Helper multiplicityText:limitedStopRangeLab.text from:0 to:4 color:[UIColor lightGrayColor]];
                }else if (_buyState == 1)
                {
                    limitedStopRangeLab.textColor = Color_red_pink;
                    
                    if (limitedStopRangeText > 0)//大于0的时候，前面加一个加号
                    {
                        limitedStopRangeLab.text     = [NSString stringWithFormat:@"较限价涨+%@％",[NSString stringWithFormat:floatNumStr,limitedStopRangeText]];
                    }else
                    {
                        limitedStopRangeLab.text     = [NSString stringWithFormat:@"较限价涨%@％",[NSString stringWithFormat:floatNumStr,limitedStopRangeText]];
                    }
                    
                    limitedStopRangeLab.attributedText = [Helper multiplicityText:limitedStopRangeLab.text from:0 to:4 color:[UIColor lightGrayColor]];
                }
                limitedStopRangeLab.hidden = NO;
                
            }
            
        }else
        {
            //未选中
            [limitedSelectStop setImage:[UIImage imageNamed:@"spotIndex_normal"] forState:UIControlStateNormal];
            [limitedSelectStop setSelected:NO];
            isSelectLimitedStop = NO;
            
            limitedStopRangeLab.hidden = YES;
        }
        
        //是否勾选限价上止盈止损
        if (textLimitedGet.text.length > 0)
        {
            //选中
            [limitedSelectGet setImage:[UIImage imageNamed:@"spotIndex_select"] forState:UIControlStateNormal];
            [limitedSelectGet setSelected:YES];
            isSelectLimitedGet = YES;
            
            if (![textLimitedPrice.text isEqualToString:@""] && textLimitedPrice.text != nil && [textLimitedPrice.text floatValue] != 0)
            {
                float limiteGetRangeText = ([textLimitedGet.text floatValue] - [textLimitedPrice.text floatValue])/[textLimitedPrice.text floatValue]*100.00;
                if (_buyState == 0)
                {
                    if (limiteGetRangeText > 0)//大于0 。前面加一个加号
                    {
                        limitedGetRangeLab.text      = [NSString stringWithFormat:@"较限价涨+%@％",[NSString stringWithFormat:floatNumStr,limiteGetRangeText]];
                    }else
                    {
                        limitedGetRangeLab.text      = [NSString stringWithFormat:@"较限价涨%@％",[NSString stringWithFormat:floatNumStr,limiteGetRangeText]];
                    }
                    
                    limitedGetRangeLab.textColor = Color_red_pink;
                    limitedGetRangeLab.attributedText = [Helper multiplicityText:limitedGetRangeLab.text from:0 to:4 color:[UIColor lightGrayColor]];
                }else if (_buyState == 1)
                {
                    if (limiteGetRangeText > 0)
                    {
                        limitedGetRangeLab.text      = [NSString stringWithFormat:@"较限价跌+%@％",[NSString stringWithFormat:floatNumStr,limiteGetRangeText]];
                    }else
                    {
                        limitedGetRangeLab.text      = [NSString stringWithFormat:@"较限价跌%@％",[NSString stringWithFormat:floatNumStr,limiteGetRangeText]];
                    }
                    
                    limitedGetRangeLab.textColor = K_color_green;
                    limitedGetRangeLab.attributedText = [Helper multiplicityText:limitedGetRangeLab.text from:0 to:4 color:[UIColor lightGrayColor]];
                }
                limitedGetRangeLab.hidden = NO;
                
            }
            
        }else
        {
            //未选中
            [limitedSelectGet setImage:[UIImage imageNamed:@"spotIndex_normal"] forState:UIControlStateNormal];
            [limitedSelectGet setSelected:NO];
            isSelectLimitedGet = NO;
            
            limitedGetRangeLab.hidden = YES;
        }

    }
}

#pragma mark - TextDelegate
- (void)textFieldValueChange
{
    [self changeBuyNum];
    
    [self reloadMoneyData];
    [self reloadStopOrGetData];
}

#pragma mark - 如果输入的手数超过可买手数的时候变回可买手数
- (void)changeBuyNum
{
    UITextField *textNumberHand = [showTextView viewWithTag:Tag_numberofHand];
    UITextField *limitedNumbHand = [showTextView viewWithTag:Tag_numberofLimitedHand];
    
    if (isSegSelect == 0)
    {
        if ([textNumberHand.text intValue] > [userBuyNum intValue])
        {
            textNumberHand.text = userBuyNum;
        }
    }else
    {
        if ([limitedNumbHand.text intValue] > [userBuyNum intValue])
        {
            limitedNumbHand.text = userBuyNum;
        }
    }
}

#pragma mark - 点击文本框的时候，全选文本框里的文字
- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    textField.tintColor = [UIColor redColor];
    UITextPosition *beginingOfDoc=textField.beginningOfDocument;
    UITextPosition *startPos = [textField positionFromPosition:beginingOfDoc offset:0];
    
    UITextPosition *endPos = [textField positionFromPosition:beginingOfDoc offset:textField.text.length];
    
    UITextRange *selectionRange= [textField textRangeFromPosition:startPos toPosition:endPos];
    [textField setSelectedTextRange:selectionRange];
}

#pragma mark - 键盘落下的时候，计算止盈止损的范围是否输入正确
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self downChangeStopOrGetText:textField];
}

#pragma mark -====
- (void)downChangeStopOrGetText:(UITextField *)textField
{
    UITextField *textMarketStop         = [showTextView viewWithTag:Tag_marketStop];
    UITextField *textMarketGet          = [showTextView viewWithTag:Tag_marketGet];
    UITextField *textLimitedStop        = [showTextView viewWithTag:Tag_limitedStop];
    UITextField *textLimitedGet         = [showTextView viewWithTag:Tag_limitedGet];
    
    UITextField *textLimitedPrice       = [showTextView viewWithTag:Tag_LimitedPrice];
    
    UILabel *marketGetRangeLab      = [showTextView viewWithTag:Tag_marketGetRange];
    UILabel *limitedGetRangeLab     = [showTextView viewWithTag:Tag_limitedGetRange];
    UILabel *marketStopRangeLab     = [showTextView viewWithTag:Tag_marketStopRange];
    UILabel *limitedStopRangeLab    = [showTextView viewWithTag:Tag_limitedStopRange];
    
    float incrNum                       = powf(10, [_productModel.decimalPlaces intValue]);
    //当前价+3个点
    NSString *priceGetStr               = [NSString stringWithFormat:floatNumStr,[_priceLabel.text floatValue] + 3/incrNum];
    //当前价-3个点
    NSString *priceStopStr              = [NSString stringWithFormat:floatNumStr,[_priceLabel.text floatValue] - 3/incrNum];
    NSString *hightPriceStr             = _highestPrice;
    
    NSString *lowPriceStr               = [NSString stringWithFormat:floatNumStr,([_lowestPrice floatValue] - [_lowestPrice floatValue]*RangeStopLow)];
    
    NSString *priceIndexStr = _priceLabel.text;
    
    if (isSegSelect == 0)
    {
        if ([_priceLabel.text isEqualToString:@"--"] || [_priceLabel.text floatValue] == 0)
        {
            //如果获取不到看多价的时候应该怎么弄
            marketGetRangeLab.hidden = YES;
            marketStopRangeLab.hidden = YES;
        }else
        {
            if ([_lowestPrice isEqualToString:@""] || _lowestPrice == nil || [_highestPrice isEqualToString:@""] || _highestPrice == nil)
            {
                //                    [UIEngine showShadowPrompt:@"获取数据失败"];
                return;
            }

            if (textField == textMarketGet)
            {
                if (textMarketGet.text <=0 || [textMarketGet.text isEqualToString:@""])
                {
                    return;
                }
                
                if (_buyState == 0)//看多的时候  当前价 + 1一个点<市价止盈的范围<涨停价
                {
                    //如果止盈价格小于当前价
                    if ([textMarketGet.text floatValue]< [priceGetStr floatValue])
                    {
//                        [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止盈范围%@~%@",priceGetStr,hightPriceStr]];
                        textMarketGet.text = priceGetStr;
                        
                    }else if([textMarketGet.text floatValue] > [hightPriceStr floatValue])
                    {
//                        [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止盈范围%@~%@",priceGetStr,hightPriceStr]];
                        textMarketGet.text = hightPriceStr;
                        
                    }
                    marketGetRangeLab.textColor = Color_red_pink;
                    marketGetRangeLab.hidden = NO;
                    //市价涨跌止盈止损较当前幅度（涨：（文本框里的文字-当前价）/当前价*100  跌同涨）
                    marketGetRangeLab.text      = [NSString stringWithFormat:@"较当前价涨+%@％",[NSString stringWithFormat:floatNumStr,fabs(([textMarketGet.text floatValue] - [priceIndexStr floatValue])/[priceIndexStr floatValue]*100.00)]];
                    marketGetRangeLab.attributedText = [Helper multiplicityText:marketGetRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];
                    return;
                    
                }else if (_buyState == 1)//看空:  跌停价<市价止盈<当前价一个点
                {
                    //如果止损小于了跌停或者止损大于了当前价-1个点。提示止损的范围（跌停价 - 跌停价*0.5%<止损<当前价 - 一个点）
                    if ([textMarketGet.text floatValue] < [lowPriceStr floatValue])
                    {
//                        [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止损范围%@~%@",lowPriceStr,priceStopStr]];
                        textMarketGet.text = lowPriceStr;
                        
                    }else if ([textMarketGet.text floatValue] > [priceStopStr floatValue])//
                    {
//                        [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止损范围%@~%@",lowPriceStr,priceStopStr]];
                        textMarketGet.text = priceStopStr;//priceStopStr就是当前价减去的一个点
                    }
                    
                    marketGetRangeLab.textColor = K_color_green;
                    marketGetRangeLab.hidden = NO;
                    marketGetRangeLab.text     = [NSString stringWithFormat:@"较当前价跌-%@％",[NSString stringWithFormat:floatNumStr,fabs(([textMarketGet.text floatValue] - [priceIndexStr floatValue])/[priceIndexStr floatValue]*100.00)]];
                    marketGetRangeLab.attributedText = [Helper multiplicityText:marketGetRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];
                    return;

                }
                
            }
            
            
            if (textField == textMarketStop)
            {
                if (textMarketStop.text <=0 || [textMarketStop.text isEqualToString:@""])
                {
                    return;
                }
                
                if (_buyState == 0)//看多的时候 跌停价<市价止损<当前价-一个点
                {
                    //如果止损小于了跌停或者止损大于了当前价-1个点。提示止损的范围（跌停价 - 跌停价*0.5%<止损<当前价 - 一个点）
                    if ([textMarketStop.text floatValue] < [lowPriceStr floatValue])
                    {
//                        [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止损范围%@~%@",lowPriceStr,priceStopStr]];
                        textMarketStop.text = lowPriceStr;
                        
                    }else if ([textMarketStop.text floatValue] > [priceStopStr floatValue])//
                    {
//                        [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止损范围%@~%@",lowPriceStr,priceStopStr]];
                        textMarketStop.text = priceStopStr;//priceStopStr就是当前价减去的一个点
                    }
                    
                    marketStopRangeLab.textColor = K_color_green;
                    marketStopRangeLab.hidden = NO;
                    marketStopRangeLab.text     = [NSString stringWithFormat:@"较当前价跌-%@％",[NSString stringWithFormat:floatNumStr,fabs(([textMarketStop.text floatValue] - [priceIndexStr floatValue])/[priceIndexStr floatValue]*100.00)]];
                    marketStopRangeLab.attributedText = [Helper multiplicityText:marketStopRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];
                    return;

                }else if (_buyState == 1)//看空  当前价 + 1一个点<市价止损的范围<涨停价
                {
                    //如果止盈价格小于当前价
                    if ([textMarketStop.text floatValue]< [priceGetStr floatValue])
                    {
//                        [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止盈范围%@~%@",priceGetStr,hightPriceStr]];
                        textMarketStop.text = priceGetStr;
                        
                    }else if([textMarketStop.text floatValue] > [hightPriceStr floatValue])
                    {
//                        [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止盈范围%@~%@",priceGetStr,hightPriceStr]];
                        textMarketStop.text = hightPriceStr;
                        
                    }
                    marketStopRangeLab.textColor = Color_red_pink;
                    marketStopRangeLab.hidden = NO;
                    //市价涨跌止盈止损较当前幅度（涨：（文本框里的文字-当前价）/当前价*100  跌同涨）
                    marketStopRangeLab.text      = [NSString stringWithFormat:@"较当前价涨+%@％",[NSString stringWithFormat:floatNumStr,fabs(([textMarketStop.text floatValue] - [priceIndexStr floatValue])/[priceIndexStr floatValue]*100.00)]];
                    marketStopRangeLab.attributedText = [Helper multiplicityText:marketStopRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];
                    return;
                }
                
            }

        }

        
    }else
    {
        //判断如果限价为空的时候
        if (![textLimitedPrice.text isEqualToString:@""] || textLimitedPrice != nil ||![textLimitedPrice.text isEqualToString:@"--"] ||[textLimitedPrice.text floatValue] != 0)
        {
            priceGetStr               = [NSString stringWithFormat:floatNumStr,[textLimitedPrice.text floatValue] + 1/incrNum];
            priceStopStr              = [NSString stringWithFormat:floatNumStr,[textLimitedPrice.text floatValue] - 1/incrNum];
            
            if ([_lowestPrice isEqualToString:@""] || _lowestPrice == nil || [_highestPrice isEqualToString:@""] || _highestPrice == nil)
            {
                //                    [UIEngine showShadowPrompt:@"获取数据失败"];
                return;
            }

            if (textField == textLimitedGet)
            {
                if (textLimitedGet.text <=0 || [textLimitedGet.text isEqualToString:@""])
                {
                    return;
                }
                
                if (_buyState == 0)//看多 当前价 + 一个点<限价止盈范围<涨停价
                {
                    //如果止盈价格小于当前价
                    if ([textLimitedGet.text floatValue]< [priceGetStr floatValue])
                    {
//                        [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止盈范围%@~%@",priceGetStr,hightPriceStr]];
                        textLimitedGet.text = priceGetStr;
                        
                    }else if ([textLimitedGet.text floatValue] > [hightPriceStr floatValue])
                    {
//                        [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止盈范围%@~%@",priceGetStr,hightPriceStr]];
                        textLimitedGet.text = hightPriceStr;
                        
                        return;
                    }
                    
                    limitedGetRangeLab.textColor = Color_red_pink;
                    limitedGetRangeLab.hidden = NO;
                    limitedGetRangeLab.text      = [NSString stringWithFormat:@"较限价涨+%@％",[NSString stringWithFormat:floatNumStr,fabs(([textLimitedGet.text floatValue] - [textLimitedPrice.text floatValue])/[textLimitedPrice.text floatValue]*100.00)]];
                    limitedGetRangeLab.attributedText = [Helper multiplicityText:limitedGetRangeLab.text from:0 to:4 color:[UIColor lightGrayColor]];
                }else if(_buyState == 1)//看空 跌停价<限价止盈<当前价 - 一个点
                {
                    //如果止损小于了跌停或者止损大于了当前价-1个点。提示止损的范围
                    if ([textLimitedGet.text floatValue] < [lowPriceStr floatValue])
                    {
//                        [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止损范围%@~%@",lowPriceStr,priceStopStr]];
                        textLimitedGet.text = lowPriceStr;
                        
                    }else if([textLimitedGet.text floatValue] > [priceStopStr floatValue])
                    {
//                        [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止损范围%@~%@",lowPriceStr,priceStopStr]];
                        textLimitedGet.text = priceStopStr;
                        
                    }
                    
                    limitedGetRangeLab.textColor = K_color_green;
                    limitedGetRangeLab.hidden = NO;
                    limitedGetRangeLab.text     = [NSString stringWithFormat:@"较限价跌-%@％",[NSString stringWithFormat:floatNumStr,fabs(([textLimitedGet.text floatValue] - [textLimitedPrice.text floatValue])/[textLimitedPrice.text floatValue]*100.00)]];
                    limitedGetRangeLab.attributedText = [Helper multiplicityText:limitedGetRangeLab.text from:0 to:4 color:[UIColor lightGrayColor]];
                }
                
            }else if (textField == textLimitedStop)
            {
                if (textLimitedStop.text <=0 || [textLimitedStop.text isEqualToString:@""])
                {
                    return;
                }
                
                if (_buyState == 0)//看多 跌停价<限价止损<当前价 - 一个点
                {
                    //如果止损小于了跌停或者止损大于了当前价-1个点。提示止损的范围
                    if ([textLimitedStop.text floatValue] < [lowPriceStr floatValue])
                    {
//                        [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止损范围%@~%@",lowPriceStr,priceStopStr]];
                        textLimitedStop.text = lowPriceStr;
                        
                    }else if([textLimitedStop.text floatValue] > [priceStopStr floatValue])
                    {
//                        [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止损范围%@~%@",lowPriceStr,priceStopStr]];
                        textLimitedStop.text = priceStopStr;
                        
                    }
                    
                    limitedStopRangeLab.textColor = K_color_green;
                    limitedStopRangeLab.hidden = NO;
                    limitedStopRangeLab.text     = [NSString stringWithFormat:@"较限价跌-%@％",[NSString stringWithFormat:floatNumStr,fabs(([textLimitedStop.text floatValue] - [textLimitedPrice.text floatValue])/[textLimitedPrice.text floatValue]*100.00)]];
                    limitedStopRangeLab.attributedText = [Helper multiplicityText:limitedStopRangeLab.text from:0 to:4 color:[UIColor lightGrayColor]];
                }else if (_buyState == 1)//看空 当前价 + 一个点<限价止损范围<涨停价
                {
                    //如果止盈价格小于当前价
                    if ([textLimitedStop.text floatValue]< [priceGetStr floatValue])
                    {
//                        [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止盈范围%@~%@",priceGetStr,hightPriceStr]];
                        textLimitedStop.text = priceGetStr;
                        
                    }else if ([textLimitedStop.text floatValue] > [hightPriceStr floatValue])
                    {
//                        [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止盈范围%@~%@",priceGetStr,hightPriceStr]];
                        textLimitedStop.text = hightPriceStr;
                    }
                    
                    limitedStopRangeLab.textColor = Color_red_pink;
                    limitedStopRangeLab.hidden = NO;
                    limitedStopRangeLab.text      = [NSString stringWithFormat:@"较限价涨+%@％",[NSString stringWithFormat:floatNumStr,fabs(([textLimitedStop.text floatValue] - [textLimitedPrice.text floatValue])/[textLimitedPrice.text floatValue]*100.00)]];
                    limitedStopRangeLab.attributedText = [Helper multiplicityText:limitedStopRangeLab.text from:0 to:4 color:[UIColor lightGrayColor]];
                }
                
            }else if (textField == textLimitedPrice)
            {
                if ([textLimitedPrice.text floatValue] > [_highestPrice floatValue])
                {
                    textLimitedPrice.text = _highestPrice;
                }
                
                if ([textLimitedPrice.text floatValue] < [_lowestPrice floatValue])
                {
//                    [UIEngine showShadowPrompt:[NSString stringWithFormat:@"限价范围%@~%@",_lowestPrice,_highestPrice]];
                    textLimitedPrice.text = _priceLabel.text;
                    return;
                }else if ([textLimitedPrice.text floatValue] >[_highestPrice floatValue] )
                {
//                    [UIEngine showShadowPrompt:[NSString stringWithFormat:@"限价范围%@~%@",_lowestPrice,_highestPrice]];
                    textLimitedPrice.text = _priceLabel.text;
                    return;
                }
            }
 
        }else
        {
            //限价如果为空的时候
            limitedStopRangeLab.hidden = YES;
            limitedGetRangeLab.hidden  = YES;
        }
        
    }

}

#pragma mark - 止盈止损是否选中
- (void)clickSelectAction:(UIButton *)sender
{
    UIButton *marketSelectStop = (UIButton *)[showTextView viewWithTag:Tag_marketSelect + 2];
    UIButton *marketSelectGet = (UIButton *)[showTextView viewWithTag:Tag_marketSelect + 1];
    UIButton *limitedSelectStop = (UIButton *)[showTextView viewWithTag:Tag_limitedSelect + 3];
    UIButton *limitedSelectGet = (UIButton *)[showTextView viewWithTag:Tag_limitedSelect + 2];
    
    switch (sender.tag)
    {
        case Tag_marketSelect + 2:
        {
            if ([marketSelectStop isSelected])
            {
                //未选中
                [marketSelectStop setImage:[UIImage imageNamed:@"spotIndex_normal"] forState:UIControlStateNormal];
                [marketSelectStop setSelected:NO];
                isSelectMarketStop = NO;
                [self changeSelectStop:NO];
                
                //未选中
                [marketSelectGet setImage:[UIImage imageNamed:@"spotIndex_normal"] forState:UIControlStateNormal];
                [marketSelectGet setSelected:NO];
                isSelectMarketGet = NO;
                [self changeSelectGet:NO];
                
            }else{
                //选中
                [marketSelectStop setImage:[UIImage imageNamed:@"spotIndex_select"] forState:UIControlStateNormal];
                [marketSelectStop setSelected:YES];
                isSelectMarketStop = YES;
                //选中止盈
                [self changeSelectStop:YES];
                
                //选中
                [marketSelectGet setImage:[UIImage imageNamed:@"spotIndex_select"] forState:UIControlStateNormal];
                [marketSelectGet setSelected:YES];
                
                isSelectMarketGet = YES;
                //选中止盈止损的时候要更新止盈止损的默认值和当前涨跌价格
                [self changeSelectGet:YES];
            }
        }
            break;
        case Tag_marketSelect + 1:
        {
            if ([marketSelectGet isSelected])
            {
                //未选中
                [marketSelectGet setImage:[UIImage imageNamed:@"spotIndex_normal"] forState:UIControlStateNormal];
                [marketSelectGet setSelected:NO];
                isSelectMarketGet = NO;
                [self changeSelectGet:NO];
                
                //未选中
                [marketSelectStop setImage:[UIImage imageNamed:@"spotIndex_normal"] forState:UIControlStateNormal];
                [marketSelectStop setSelected:NO];
                isSelectMarketStop = NO;
                [self changeSelectStop:NO];
                
            }else{
                //选中
                [marketSelectGet setImage:[UIImage imageNamed:@"spotIndex_select"] forState:UIControlStateNormal];
                [marketSelectGet setSelected:YES];

                isSelectMarketGet = YES;
                //选中止盈止损的时候要更新止盈止损的默认值和当前涨跌价格
                [self changeSelectGet:YES];
                
                //止损也选中
                [marketSelectStop setImage:[UIImage imageNamed:@"spotIndex_select"] forState:UIControlStateNormal];
                [marketSelectStop setSelected:YES];
                isSelectMarketStop = YES;
                //选中止盈
                [self changeSelectStop:YES];
            }

        }
            break;
        case Tag_limitedSelect + 3:
        {
            if ([limitedSelectStop isSelected])
            {
                //未选中
                [limitedSelectStop setImage:[UIImage imageNamed:@"spotIndex_normal"] forState:UIControlStateNormal];
                [limitedSelectStop setSelected:NO];
                isSelectLimitedStop = NO;
                [self changeSelectStop:NO];
                
                //止盈止损同时未选中
                [limitedSelectGet setImage:[UIImage imageNamed:@"spotIndex_normal"] forState:UIControlStateNormal];
                [limitedSelectGet setSelected:NO];
                isSelectLimitedGet = NO;
                [self changeSelectGet:NO];
                
            }else{
                //选中
                [limitedSelectStop setImage:[UIImage imageNamed:@"spotIndex_select"] forState:UIControlStateNormal];
                [limitedSelectStop setSelected:YES];
                isSelectLimitedStop = YES;
                //选中止盈止损的时候要更新止盈止损的默认值和当前涨跌价格
                [self changeSelectStop:YES];
                
                //止盈止损同时选中
                [limitedSelectGet setImage:[UIImage imageNamed:@"spotIndex_select"] forState:UIControlStateNormal];
                [limitedSelectGet setSelected:YES];
                isSelectLimitedGet = YES;
                //选中止盈止损的时候要更新止盈止损的默认值和当前涨跌价格
                [self changeSelectGet:YES];

            }

        }
            break;

        case Tag_limitedSelect + 2:
        {
            if ([limitedSelectGet isSelected])
            {
                //未选中
                [limitedSelectGet setImage:[UIImage imageNamed:@"spotIndex_normal"] forState:UIControlStateNormal];
                [limitedSelectGet setSelected:NO];
                isSelectLimitedGet = NO;
                [self changeSelectGet:NO];
                
                //止盈止损同时未选中
                [limitedSelectStop setImage:[UIImage imageNamed:@"spotIndex_normal"] forState:UIControlStateNormal];
                [limitedSelectStop setSelected:NO];
                isSelectLimitedStop = NO;
                [self changeSelectStop:NO];
                
            }else{
                //选中
                [limitedSelectGet setImage:[UIImage imageNamed:@"spotIndex_select"] forState:UIControlStateNormal];
                [limitedSelectGet setSelected:YES];
                isSelectLimitedGet = YES;
                //选中止盈止损的时候要更新止盈止损的默认值和当前涨跌价格
                [self changeSelectGet:YES];
                
                //止盈止损同时选中
                [limitedSelectStop setImage:[UIImage imageNamed:@"spotIndex_select"] forState:UIControlStateNormal];
                [limitedSelectStop setSelected:YES];
                isSelectLimitedStop = YES;
                //选中止盈止损的时候要更新止盈止损的默认值和当前涨跌价格
                [self changeSelectStop:YES];
            }

        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 计算止盈涨幅度默认值
- (void)changeSelectGet:(BOOL)getText
{
    UITextField *textMarketGet      = [showTextView viewWithTag:Tag_marketGet];
    UITextField *textLimitedGet     = [showTextView viewWithTag:Tag_limitedGet];
    
    UILabel *marketGetRangeLab      = [showTextView viewWithTag:Tag_marketGetRange];
    UILabel *limitedGetRangeLab     = [showTextView viewWithTag:Tag_limitedGetRange];
    
    UITextField *textLimitedPrice       = [showTextView viewWithTag:Tag_LimitedPrice];
    
    NSString *priceIndexStr = _priceLabel.text;
    
    if (getText == YES)//选中止盈的时候
    {
        if (isSegSelect == 0)
        {
            if ([_priceLabel.text isEqualToString:@"--"] || [_priceLabel.text floatValue] == 0)//如果没有获取到看多价的时候
            {
                marketGetRangeLab.hidden    = YES;
                limitedGetRangeLab.hidden   = YES;
                
                //文本框的显示需要问设计
            }else
            {
                if (_buyState == 0)//看多 当前价 + 一个点<市价止盈范围<涨停价
                {
                    marketGetRangeLab.textColor = Color_red_pink;
                    //市价止盈止损默认
                    textMarketGet.text          = [NSString stringWithFormat:floatNumStr,[priceIndexStr floatValue] + [priceIndexStr floatValue]*OnePerCent];
                    //市价涨跌止盈止损较当前幅度（涨：（文本框里的文字-当前价）/当前价*100  跌同涨）
                    marketGetRangeLab.text      = [NSString stringWithFormat:@"较当前价涨+%@％",[NSString stringWithFormat:floatNumStr,fabs(([textMarketGet.text floatValue] - [priceIndexStr floatValue])/[priceIndexStr floatValue]*100.00)]];
                    marketGetRangeLab.attributedText = [Helper multiplicityText:marketGetRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];
                }else if(_buyState == 1)
                {
                    //看空  止盈范围：跌停价<市价止盈<当前价- 一个点
                    marketGetRangeLab.textColor = K_color_green;
                    
                    textMarketGet.text         = [NSString stringWithFormat:floatNumStr,[priceIndexStr floatValue] - [priceIndexStr floatValue]*RangeStopLow];
                    marketGetRangeLab.text     = [NSString stringWithFormat:@"较当前价跌-%@％",[NSString stringWithFormat:floatNumStr,fabs(([textMarketGet.text floatValue] - [priceIndexStr floatValue])/[priceIndexStr floatValue]*100.00)]];
                    marketGetRangeLab.attributedText = [Helper multiplicityText:marketGetRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];
                }
                
                marketGetRangeLab.hidden = NO;
                
            }
            
        }else
        {
            if ([textLimitedPrice.text isEqualToString:@"--"] || [textLimitedPrice.text isEqualToString:@""]||textLimitedPrice.text == nil || [textLimitedPrice.text floatValue] == 0)
            {
                limitedGetRangeLab.hidden = YES;
            }else
            {
                if (_buyState == 0)//看多 当前价 + 一个点<市价止盈范围<涨停价
                {
                    limitedGetRangeLab.textColor = Color_red_pink;
                    //限价止盈止损默认
                    textLimitedGet.text         = [NSString stringWithFormat:floatNumStr,[textLimitedPrice.text floatValue] + [textLimitedPrice.text floatValue]*OnePerCent];
                    limitedGetRangeLab.text      = [NSString stringWithFormat:@"较限价涨+%@％",[NSString stringWithFormat:floatNumStr,fabs(([textLimitedGet.text floatValue] - [textLimitedPrice.text floatValue])/[textLimitedPrice.text floatValue]*100.00)]];
                    limitedGetRangeLab.attributedText = [Helper multiplicityText:limitedGetRangeLab.text from:0 to:4 color:[UIColor lightGrayColor]];

                }else if(_buyState == 1)//看空 止盈范围：跌停价<市价止盈<当前价- 一个点
                {
                    limitedGetRangeLab.textColor = K_color_green;
                    textLimitedGet.text         = [NSString stringWithFormat:floatNumStr,[textLimitedPrice.text floatValue] - [textLimitedPrice.text floatValue]*RangeStopLow];
                    //市价涨跌止盈止损较当前幅度（涨：（文本框里的文字-当前价）/当前价*100  跌同涨）
                    limitedGetRangeLab.text     = [NSString stringWithFormat:@"较限价跌-%@％",[NSString stringWithFormat:floatNumStr,fabs(([textLimitedGet.text floatValue] - [textLimitedPrice.text floatValue])/[textLimitedPrice.text floatValue]*100.00)]];
                    limitedGetRangeLab.attributedText = [Helper multiplicityText:limitedGetRangeLab.text from:0 to:4 color:[UIColor lightGrayColor]];
                }
                
                limitedGetRangeLab.hidden = NO;
            }
            
        }

        
    }else
    {
        //未选中
        //未选中
        if (isSegSelect == 0)
        {
            textMarketGet.text         = @"";
            marketGetRangeLab.text     = @"较当前价+0.00％";
            marketGetRangeLab.hidden   = YES;
        }else
        {
            textLimitedGet.text        = @"";
            limitedGetRangeLab.text    = @"较限价+0.00％";
            limitedGetRangeLab.hidden  = YES;
        }

    }
    
}

#pragma mark - 计算止损涨跌幅度默认值
- (void)changeSelectStop:(BOOL)stopText
{
    UITextField *textMarketStop     = [showTextView viewWithTag:Tag_marketStop];
    UITextField *textLimitedStop    = [showTextView viewWithTag:Tag_limitedStop];
    
    UILabel *marketStopRangeLab     = [showTextView viewWithTag:Tag_marketStopRange];
    UILabel *limitedStopRangeLab    = [showTextView viewWithTag:Tag_limitedStopRange];
    
    UITextField *textLimitedPrice       = [showTextView viewWithTag:Tag_LimitedPrice];
    
    NSString *priceIndexStr         = _priceLabel.text;
    
    if (stopText == YES)//选中的情况下
    {
        
            if (isSegSelect == 0)
            {
                if ([_priceLabel.text isEqualToString:@"--"] || [_priceLabel.text floatValue] == 0)
                {
                    marketStopRangeLab.hidden   = YES;
                }else
                {
                    if (_buyState == 0)//看多 跌停价<市价止损范围<当前价-一个点
                    {
                        marketStopRangeLab.textColor = K_color_green;
                        textMarketStop.text         = [NSString stringWithFormat:floatNumStr,[priceIndexStr floatValue] - [priceIndexStr floatValue]*RangeStopLow];
                        marketStopRangeLab.text     = [NSString stringWithFormat:@"较当前价跌-%@％",[NSString stringWithFormat:floatNumStr,fabs(([textMarketStop.text floatValue] - [priceIndexStr floatValue])/[priceIndexStr floatValue]*100.00)]];
                        marketStopRangeLab.attributedText = [Helper multiplicityText:marketStopRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];
                    }else if (_buyState == 1)//看空 当前价+一个点<市价止损范围<涨停价
                    {
                        marketStopRangeLab.textColor = Color_red_pink;
                        //市价止盈止损默认
                        textMarketStop.text          = [NSString stringWithFormat:floatNumStr,[priceIndexStr floatValue] + [priceIndexStr floatValue]*OnePerCent];
                        //市价涨跌止盈止损较当前幅度（涨：（文本框里的文字-当前价）/当前价*100  跌同涨）
                        marketStopRangeLab.text      = [NSString stringWithFormat:@"较当前价涨+%@％",[NSString stringWithFormat:floatNumStr,fabs(([textMarketStop.text floatValue] - [priceIndexStr floatValue])/[priceIndexStr floatValue]*100.00)]];
                        marketStopRangeLab.attributedText = [Helper multiplicityText:marketStopRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];
                    }
                    
                    
                    marketStopRangeLab.hidden   = NO;
                }
                
            }else
            {
                if ([textLimitedPrice.text isEqualToString:@"--"] || [textLimitedPrice.text isEqualToString:@""] || textLimitedPrice.text == nil || [_priceLabel.text floatValue] == 0)
                {
                    limitedStopRangeLab.hidden = YES;
                }else
                {
                    if (_buyState == 0)//看多  跌停价<限价止损范围<当前价-一个点
                    {
                        limitedStopRangeLab.textColor = K_color_green;
                        textLimitedStop.text         = [NSString stringWithFormat:floatNumStr,[textLimitedPrice.text floatValue] - [textLimitedPrice.text floatValue]*RangeStopLow];
                        
                        //市价涨跌止盈止损较当前幅度（涨：（文本框里的文字-当前价）/当前价*100  跌同涨）
                        limitedStopRangeLab.text     = [NSString stringWithFormat:@"较限价跌-%@％",[NSString stringWithFormat:floatNumStr,fabs(([textLimitedStop.text floatValue] - [textLimitedPrice.text floatValue])/[textLimitedPrice.text floatValue]*100.00)]];
                        limitedStopRangeLab.attributedText = [Helper multiplicityText:limitedStopRangeLab.text from:0 to:4 color:[UIColor lightGrayColor]];
                    }else if(_buyState == 1)//看空 当前价 + 1个点<限价止损范围<涨停价
                    {
                        limitedStopRangeLab.textColor = Color_red_pink;
                        //限价止盈止损默认
                        textLimitedStop.text         = [NSString stringWithFormat:floatNumStr,[textLimitedPrice.text floatValue] + [textLimitedPrice.text floatValue]*OnePerCent];
                        limitedStopRangeLab.text      = [NSString stringWithFormat:@"较限价涨+%@％",[NSString stringWithFormat:floatNumStr,fabs(([textLimitedStop.text floatValue] - [textLimitedPrice.text floatValue])/[textLimitedPrice.text floatValue]*100.00)]];
                        limitedStopRangeLab.attributedText = [Helper multiplicityText:limitedStopRangeLab.text from:0 to:4 color:[UIColor lightGrayColor]];
                    }
                    
                    limitedStopRangeLab.hidden = NO;
                }
                
            }

        
        

    }else
    {
        //未选中
        if (isSegSelect == 0)
        {
            textMarketStop.text         = @"";
            marketStopRangeLab.text     = @"较当前价-0.00％";
            marketStopRangeLab.hidden   = YES;
        }else
        {
            textLimitedStop.text        = @"";
            limitedStopRangeLab.text    = @"较限价-0.00％";
            limitedStopRangeLab.hidden  = YES;
        }
        
    }
    
}

#pragma mark - 看多价改变的时候，改变止盈止损的范围和数据
- (void)changeIndexStopOrGet
{
    UITextField *textMarketStop     = [showTextView viewWithTag:Tag_marketStop];
    UITextField *textLimitedStop    = [showTextView viewWithTag:Tag_limitedStop];
    
    UILabel *marketStopRangeLab     = [showTextView viewWithTag:Tag_marketStopRange];
    UILabel *limitedStopRangeLab    = [showTextView viewWithTag:Tag_limitedStopRange];
    
    UITextField *textMarketGet      = [showTextView viewWithTag:Tag_marketGet];
    UITextField *textLimitedGet     = [showTextView viewWithTag:Tag_limitedGet];
    
    UILabel *marketGetRangeLab      = [showTextView viewWithTag:Tag_marketGetRange];
    UILabel *limitedGetRangeLab     = [showTextView viewWithTag:Tag_limitedGetRange];

    
    UITextField *textLimitedPrice       = [showTextView viewWithTag:Tag_LimitedPrice];
    
    NSString *priceIndexStr         = _priceLabel.text;

    if (isSegSelect == 0)
    {
        if (isSelectMarketGet == YES)
        {
            //市价止盈止损默认
            textMarketGet.text          = [NSString stringWithFormat:floatNumStr,[priceIndexStr floatValue] + [priceIndexStr floatValue]*OnePerCent];
            //市价涨跌止盈止损较当前幅度（涨：（文本框里的文字-当前价）/当前价*100  跌同涨）
            marketGetRangeLab.text      = [NSString stringWithFormat:@"较当前价涨+%@％",[NSString stringWithFormat:floatNumStr,fabs(([textMarketGet.text floatValue] - [priceIndexStr floatValue])/[priceIndexStr floatValue]*100.00)]];
            marketGetRangeLab.attributedText = [Helper multiplicityText:marketGetRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];
            
            marketGetRangeLab.hidden = NO;
        }
        
        if (isSelectMarketStop == YES)
        {
            textMarketStop.text         = [NSString stringWithFormat:floatNumStr,[priceIndexStr floatValue] - [priceIndexStr floatValue]*RangeStopLow];
            marketStopRangeLab.text     = [NSString stringWithFormat:@"较当前价跌-%@％",[NSString stringWithFormat:floatNumStr,fabs(([textMarketStop.text floatValue] - [priceIndexStr floatValue])/[priceIndexStr floatValue]*100.00)]];
            marketStopRangeLab.attributedText = [Helper multiplicityText:marketStopRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];
            marketStopRangeLab.hidden   = NO;
        }
    }else
    {
        if (isSelectLimitedGet == YES)
        {
            //限价止盈止损默认
            textLimitedGet.text         = [NSString stringWithFormat:floatNumStr,[textLimitedPrice.text floatValue] + [textLimitedPrice.text floatValue]*OnePerCent];
            limitedGetRangeLab.text      = [NSString stringWithFormat:@"较限价涨+%@％",[NSString stringWithFormat:floatNumStr,fabs(([textLimitedGet.text floatValue] - [textLimitedPrice.text floatValue])/[textLimitedPrice.text floatValue]*100.00)]];
            limitedGetRangeLab.attributedText = [Helper multiplicityText:limitedGetRangeLab.text from:0 to:4 color:[UIColor lightGrayColor]];
            limitedGetRangeLab.hidden = NO;
        }
        
        if (isSelectLimitedStop == YES)
        {
            textLimitedStop.text         = [NSString stringWithFormat:floatNumStr,[textLimitedPrice.text floatValue] - [textLimitedPrice.text floatValue]*RangeStopLow];
            
            //市价涨跌止盈止损较当前幅度（涨：（文本框里的文字-当前价）/当前价*100  跌同涨）
            limitedStopRangeLab.text     = [NSString stringWithFormat:@"较限价跌-%@％",[NSString stringWithFormat:floatNumStr,fabs(([textLimitedStop.text floatValue] - [textLimitedPrice.text floatValue])/[textLimitedPrice.text floatValue]*100.00)]];
            limitedStopRangeLab.attributedText = [Helper multiplicityText:limitedStopRangeLab.text from:0 to:4 color:[UIColor lightGrayColor]];
            limitedStopRangeLab.hidden = NO;
        }
    }
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSString * toBeingString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    
//    NSRange rage = [textField.text rangeOfString:@"¥"];
//    if (rage.length != 0 && ![[toBeingString substringToIndex:1] isEqualToString:@"¥"]) {
//        return NO;
//    }
//    
//    toBeingString = [toBeingString stringByReplacingOccurrencesOfString:@"¥" withString:@""];
//    toBeingString = [toBeingString stringByReplacingOccurrencesOfString:@"," withString:@""];
//    //先转换成 钱的逗号格式
//    toBeingString = [self countNumAndChangeformat:toBeingString];
//    
//    //然后在加上钱的符号
//    if ([toBeingString isEqualToString:@"¥"] || [toBeingString isEqualToString:@""]) {
//        
//        resultStr = @"";
//        return YES;
//    }
//    else
//    {
//        resultStr = [NSString stringWithFormat:@"¥%@",toBeingString];
//    }
//    return YES;
//}

//把钱转成逗号格式
-(NSString *)countNumAndChangeformat:(NSString *)num
{
    NSString * oldString = [NSString stringWithString:num];
    num = [[oldString componentsSeparatedByString:@"."] objectAtIndex:0];
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3)
    {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    
    if([[oldString componentsSeparatedByString:@"."] count] > 1)
        
        return [NSString stringWithFormat:@"%@.%@",newstring,[[oldString componentsSeparatedByString:@"."] objectAtIndex:1]];
    else
        return newstring;
}

#pragma mark -
#pragma mark Responding to keyboard events

// 响应键盘事件 - 显示
- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo]; // 获取通知的用户信息
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue]; // 获取键盘的Rect
    // 获取键盘动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    // 输入框移动位置
    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
}

// 响应键盘事件 - 隐藏
- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo]; // 获取通知的用户信息
    // 获取键盘动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // 输入框移动位置
    [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
}

- (void)moveInputBarWithKeyboardHeight:(CGFloat)height withDuration:(NSTimeInterval)animationDuration
{
    if (height == 0.0) {
        [UIView animateWithDuration:animationDuration animations:^{
            if ([UIScreen mainScreen].bounds.size.height <=568)
            {
                tpkScrollView.frame = CGRectMake(0, 49, ScreenWidth, ScreenHeigth - 49);
            }
        }];
        
        UIButton *button = (UIButton *)[self.view viewWithTag:123];
        [button removeFromSuperview];
    } else {
        
        [UIView animateWithDuration:animationDuration animations:^{
            if ([UIScreen mainScreen].bounds.size.height <=568)
            {
                tpkScrollView.frame = CGRectMake(0, 10, ScreenWidth, ScreenHeigth - 49);
            }
            
        }];
        
    }
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
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
