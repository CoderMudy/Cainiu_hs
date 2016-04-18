//
//  StopProfitViewController.m
//  hs
//
//  Created by Xse on 15/11/25.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "StopProfitViewController.h"
#import "HJCAjustNumButton.h"
#import "UIEngine.h"
#import "MarketIsStatusAlert.h"

#define Tag_priceStop            99990
#define Tag_priceGet             99991
#define Tag_num                  99992

#define Tag_isSelectStop         99993
#define Tag_isSelectGet          99994

#define Tag_GetRange             99995
#define Tag_StopRange            99996

#define OnePerCent               0.01//止盈默认值 = 当前价+当前价*0.01
#define RangeStopLow             0.005//止损默认值= 当前价-当前价*0.005

#define K_green_color            [UIColor colorWithRed:51/255.0 green:177/255.0 blue:51/255.0 alpha:1]

@interface StopProfitViewController ()<UITextFieldDelegate>
{
    NSString *floatNumStr;//小数位数
    
    NSString *currentPrice;//当前最新价
    
    BOOL isStopSelect;
    BOOL isGetSelect;
    
    UIView *fiveBackView;
}

@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *stopTitleLab;
@property (nonatomic,strong) UILabel *upsAndDownsLab;//涨跌幅
@property (nonatomic,strong) UIView *downView;

@property (nonatomic,strong) NSString *highestProfitPrice;//涨停价
@property (nonatomic,strong) NSString *lowestProfitPrice;//跌停价


@end

@implementation StopProfitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    isStopSelect = NO;
    isGetSelect  = NO;
    
    [self requestMarketIsStatus];
    [self requestCotsLowOrHighPriceData];//获取涨停价跌停价
    
    floatNumStr = [NSString stringWithFormat:@"%@%@f",@"%",[NSString stringWithFormat:@".%d",[_productModel.decimalPlaces intValue]]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSocketInfo:) name:kPositionBosomPage object:nil];
    
    [self loadNowPrice];
    [self loadUIView];
    [self loadNav];
    
    [self setUpForDismissKeyboard];
    
    // 键盘显示通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [self requestStopProfitNum];
    addTextFieldNotification(textFieldValueChange);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPositionBosomPage object:self];
    removeTextFileNotification;
}

-(void)loadNav{
    UIImage *leftButtonImage = [UIImage imageNamed:@"return_1.png"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [leftButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchDown];
    [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    leftButton.titleLabel.shadowColor = RGBACOLOR(117,38,0,1.0f);
    leftButton.titleLabel.shadowOffset= CGSizeMake(0, -1);
    leftButton.titleLabel.textColor = [UIColor whiteColor];
    leftButton.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44/2-leftButtonImage.size.height/2, leftButtonImage.size.width, leftButtonImage.size.height)];
    imageView.image = [UIImage imageNamed:@"return_1"];
    imageView.center = leftButton.center;
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backClick)];
    [imageView addGestureRecognizer:tap];
    
    [self.view addSubview:leftButton];
    
    
    self.stopTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    self.stopTitleLab.backgroundColor = [UIColor blackColor];
    self.stopTitleLab.font = [UIFont systemFontOfSize:11];
    self.stopTitleLab.text = [NSString stringWithFormat:@"%@\n%@",_productModel.commodityName,_productModel.instrumentID];
    self.stopTitleLab.numberOfLines = 0;
    self.stopTitleLab.center = CGPointMake(self.view.center.x, 20+22);
    self.stopTitleLab.textColor = [UIColor whiteColor];
    self.stopTitleLab.textAlignment = NSTextAlignmentCenter;
    self.stopTitleLab.attributedText = [Helper multiplicityText:self.stopTitleLab.text from:0 to:(int)[_productModel.commodityName length] font:15];
    [self.view addSubview:self.stopTitleLab];
    
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 当前价
- (void)loadNowPrice
{
    _downView = [[UIView alloc]init];
    _downView.backgroundColor = [UIColor blackColor];
    _downView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeigth - 64);
    [self.view addSubview:_downView];
    
    UILabel *proLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10*ScreenWidth/320, ScreenWidth, 14)];
    if ([_buyOrSal isEqualToString:@"B"])
    {
        proLabel.text  = @"平多价";
    }else
    {
        proLabel.text  = @"平空价";
    }
    
    proLabel.textAlignment = NSTextAlignmentCenter;
    proLabel.font = [UIFont systemFontOfSize:10];
    proLabel.textColor = [UIColor lightGrayColor];
    [_downView addSubview:proLabel];
    
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(proLabel.frame), ScreenWidth, 20)];
    _priceLabel.text = [NSString stringWithFormat:@"%.2f",_price.floatValue] ;
    _priceLabel.font = [UIFont systemFontOfSize:17];
    _priceLabel.textColor = Color_Gold;
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [_downView addSubview:_priceLabel];
    
    _upsAndDownsLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_priceLabel.frame), ScreenWidth, 18)];
    _upsAndDownsLab.text = [NSString stringWithFormat:@"%@",_updownData];
    _upsAndDownsLab.font = [UIFont systemFontOfSize:13.0];
    _upsAndDownsLab.textColor = Color_Gold;
    _upsAndDownsLab.textAlignment = NSTextAlignmentCenter;
    [_downView addSubview:_upsAndDownsLab];
}

#pragma mark - 手数/止盈/止损
- (void)loadUIView
{
    NSString *titleNumStr = [NSString stringWithFormat:@"可设置0手"];
    
    NSArray * arrayTitle = @[@"设置手数",@"止盈",@"止损"];
    NSArray * arrayDetail = @[titleNumStr,@"触发价",@"触发价"];
    
    for (NSInteger i = 0; i < arrayTitle.count; i++)
    {
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.text = arrayTitle[i];
        titleLab.frame = CGRectMake(20*ScreenWidth/320,CGRectGetMaxY(_upsAndDownsLab.frame) + 22*ScreenWidth/320 + i*12 + 45 *i, 60, 20);
        titleLab.textColor = [UIColor lightGrayColor];
        titleLab.backgroundColor = [UIColor blackColor];
        titleLab.font = [UIFont systemFontOfSize:12.0];
        [_downView addSubview:titleLab];
        
        UILabel *groupLab = [[UILabel alloc]init];
        groupLab.text = arrayDetail[i];
        groupLab.adjustsFontSizeToFitWidth = YES;
        groupLab.frame = CGRectMake(CGRectGetMinX(titleLab.frame), CGRectGetMaxY(titleLab.frame) -2, 90*ScreenWidth/320, 20);
        groupLab.textColor = [UIColor colorWithRed:234/255.0 green:194/255.0 blue:129/255.0 alpha:1];
        groupLab.backgroundColor = [UIColor blackColor];
        groupLab.font = [UIFont systemFontOfSize:11.0];
        [_downView addSubview:groupLab];
        
        HJCAjustNumButton *btn = [[HJCAjustNumButton alloc]init];
//        UITextRange *selectRange = [btn.textField selectedTextRange];
//        btn.textField.selectedTextRange = selectRange;
        btn.textField.delegate = self;
        btn.textField.font = [UIFont systemFontOfSize:13.0];
        //        btn.textField.assistantHeight = 50;
        [ btn.textField addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventValueChanged];
        
        btn.frame = CGRectMake(ScreenWidth - 20*ScreenWidth/320 - 160*ScreenWidth/320, CGRectGetMinY(titleLab.frame), 160*ScreenWidth/320, 35);
        btn.lineColor = [UIColor lightGrayColor];
        btn.callBack = ^(NSString *currentNum,UITextField *textField)
        {
            [self reloadStopOrGetOrder:textField];
            [self reloadDownKeyboardData:textField];
        };
        
        btn.callDecreaseBack = ^(NSString *cureentNum,UITextField *textFiled)
        {
//            [self reloadChangeStopData:textFiled];
            [self reloadStopOrGetOrder:textFiled];
            [self reloadDownKeyboardData:textFiled];
        };
        
        [_downView addSubview:btn];
        
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i != 0)
        {
            groupLab.textColor = [UIColor lightGrayColor];
            [selectBtn addTarget:self action:@selector(clickGetOrStopAction:) forControlEvents:UIControlEventTouchUpInside];
            [selectBtn setImage:[UIImage imageNamed:@"spotIndex_normal"] forState:UIControlStateNormal];
            [_downView addSubview:selectBtn];
            
            selectBtn.frame     = CGRectMake(10, CGRectGetMaxY(_upsAndDownsLab.frame) + 18*ScreenWidth/320 + i*12 + 50 *i, 40, 35);
            titleLab.frame = CGRectMake(CGRectGetMaxX(selectBtn.frame),CGRectGetMaxY(_upsAndDownsLab.frame) + 18*ScreenWidth/320 + i*12 + 50 *i, 30, 20);
            groupLab.frame = CGRectMake(CGRectGetMinX(titleLab.frame), CGRectGetMaxY(titleLab.frame) -2, 90*ScreenWidth/320, 20);
            
            //======
            UILabel *stopLab = [[UILabel alloc]init];
            stopLab.hidden = YES;
            if (i == 1)
            {
                stopLab.text = @"较当前价涨+％";
                stopLab.tag = Tag_GetRange;
                stopLab.textColor = Color_red_pink;
            }else
            {
                stopLab.text = @"较当前价跌-％";
                stopLab.tag = Tag_StopRange;
                stopLab.textColor = K_color_green;
            }
            stopLab.font = [UIFont systemFontOfSize:11.0];
            stopLab.frame = CGRectMake(ScreenWidth - 20*ScreenWidth/320 - 160*ScreenWidth/320, CGRectGetMaxY(btn.frame), 160*ScreenWidth/320, 20);
            stopLab.textAlignment = NSTextAlignmentCenter;
            [_downView addSubview:stopLab];
        }
        
        if (i == 2)
        {
            UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            sureBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
            sureBtn.tag = 212121;
            [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
            [sureBtn addTarget:self action:@selector(clickSureAction:) forControlEvents:UIControlEventTouchUpInside];
            sureBtn.backgroundColor = Color_red_pink;
            [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            sureBtn.frame = CGRectMake(20*ScreenWidth/320, CGRectGetMaxY(groupLab.frame) + 40*ScreenWidth/320, ScreenWidth - 20*2*ScreenWidth/320, 40.0/667*ScreenHeigth);
            sureBtn.layer.cornerRadius = 3;
            sureBtn.layer.masksToBounds = YES;
            [_downView addSubview:sureBtn];
        }
        
        switch (i) {
            case 0:
                groupLab.tag = 10086;
                btn.textField.tag = Tag_num;
                btn.textField.text = 0;
                btn.textField.keyboardType = UIKeyboardTypeNumberPad;
                break;
            case 1:
            {
                groupLab.tag = 10087;
                selectBtn.tag = Tag_isSelectGet;
                btn.textField.tag = Tag_priceGet;
                btn.textField.placeholder = @"未设置";
                btn.floatNumStr = _productModel.decimalPlaces;
                btn.isIntOrFloat = 1;
                btn.textField.keyboardType = UIKeyboardTypeDecimalPad;
            }
                break;
            case 2:
                groupLab.tag = 10088;
                selectBtn.tag = Tag_isSelectStop;
                btn.textField.tag = Tag_priceStop;
                btn.isIntOrFloat = 1;
                btn.textField.placeholder = @"未设置";
                btn.floatNumStr = _productModel.decimalPlaces;
                btn.textField.keyboardType = UIKeyboardTypeDecimalPad;
                break;
                
            default:
                break;
        }
        
        [btn.textField setValue:[UIColor colorWithRed:222/255.0 green:224/255.0 blue:216/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    }
    
}

- (void)clickSureAction:(UIButton *)sender
{
    UITextField *textStop = [_downView viewWithTag:Tag_priceStop];
    UITextField *textGet = [_downView viewWithTag:Tag_priceGet];
    
    if ([_priceLabel.text isEqualToString:@"--"] || [_priceLabel.text floatValue] ==0)
    {
        [UIEngine showShadowPrompt:@"服务器繁忙，请稍后再试"];
        return;
    }
    
    if (textStop.text.length <= 0 || textGet.text.length <=0)
    {
        [UIEngine showShadowPrompt:@"止盈止损必须输入"];
        return;
    }
    
    if ([_buyOrSal isEqualToString:@"B"])
    {
        if ([textGet.text floatValue] < [textStop.text floatValue])
        {
            [UIEngine showShadowPrompt:@"买时止盈大于止损"];
            return;
        }
    }else
    {
        if ([textGet.text floatValue] > [textStop.text floatValue])
        {
            [UIEngine showShadowPrompt:@"卖时止盈小于止损"];
            return;
        }
        
    }
    
//    if ([textGet.text floatValue] < [currentPrice floatValue])
//    {
//        [UIEngine showShadowPrompt:@"止盈价必须大于当前价"];
//        return;
//    }
//    
//    if ([textStop.text floatValue] > [currentPrice floatValue])
//    {
//        [UIEngine showShadowPrompt:@"止损价必须小于当前价"];
//        return;
//    }
//

    [self requestMarketOrder];
}

#pragma mark 获取行情数据

-(void)getSocketInfo:(NSNotification *)notify{
    NSDictionary    * infoDic = notify.object;
    
    if ([_buyOrSal isEqualToString:@"B"])
    {
        //看多取的价
        _priceLabel.text = infoDic[@"askPrice"];
    }else if ([_buyOrSal isEqualToString:@"S"])
    {
        //看空取的价
        _priceLabel.text = infoDic[@"bidPrice"];
    
    }
    
    _upsAndDownsLab.text = infoDic[@"changePercent"];
    currentPrice = infoDic[@"lastPrice"];
    
//    [self changeProfitStopOrGetPrice];
}

#pragma mark - 是否选中止盈止损
- (void)clickGetOrStopAction:(UIButton *)sender
{
    UIButton *SelectStop = (UIButton *)[_downView viewWithTag:Tag_isSelectStop];
    UIButton *SelectGet = (UIButton *)[_downView viewWithTag:Tag_isSelectGet];
    
    switch (sender.tag)
    {
        case Tag_isSelectStop:
        {
            if ([SelectStop isSelected])
            {
                //未选中
                [SelectStop setImage:[UIImage imageNamed:@"spotIndex_normal"] forState:UIControlStateNormal];
                [SelectStop setSelected:NO];
                isStopSelect = NO;
                [self changeProFitSelectStop:NO];
                
                //止损未选中的时候，止盈也不让选中
                //未选中
                [SelectGet setImage:[UIImage imageNamed:@"spotIndex_normal"] forState:UIControlStateNormal];
                [SelectGet setSelected:NO];
                isGetSelect = NO;
                [self changeProFitSelectGet:NO];
                
            }else{
                //选中
                [SelectStop setImage:[UIImage imageNamed:@"spotIndex_select"] forState:UIControlStateNormal];
                [SelectStop setSelected:YES];
                isStopSelect = YES;
                [self changeProFitSelectStop:YES];
                
                //止损选中的时候同时选中止盈
                //选中
                [SelectGet setImage:[UIImage imageNamed:@"spotIndex_select"] forState:UIControlStateNormal];
                [SelectGet setSelected:YES];
                isGetSelect = YES;
                [self changeProFitSelectGet:YES];

            }
        }
            break;
        case Tag_isSelectGet:
        {
            if ([SelectGet isSelected])
            {
                //未选中
                [SelectGet setImage:[UIImage imageNamed:@"spotIndex_normal"] forState:UIControlStateNormal];
                [SelectGet setSelected:NO];
                isGetSelect = NO;
                [self changeProFitSelectGet:NO];
                
                //止盈未选中的时候，止损也不选中
                [SelectStop setImage:[UIImage imageNamed:@"spotIndex_normal"] forState:UIControlStateNormal];
                [SelectStop setSelected:NO];
                isStopSelect = NO;
                [self changeProFitSelectStop:NO];

            }else{
                //选中
                [SelectGet setImage:[UIImage imageNamed:@"spotIndex_select"] forState:UIControlStateNormal];
                [SelectGet setSelected:YES];
                isGetSelect = YES;
                [self changeProFitSelectGet:YES];
                
                //止盈选中的时候，止损同时选中
                [SelectStop setImage:[UIImage imageNamed:@"spotIndex_select"] forState:UIControlStateNormal];
                [SelectStop setSelected:YES];
                isStopSelect = YES;
                [self changeProFitSelectStop:YES];

            }
        }
            break;
    }
}

#pragma mark - 刷新止盈止损数据
- (void)reloadStopOrGetOrder:(UITextField *)textField
{
    UITextField *textStop = [_downView viewWithTag:Tag_priceStop];
    UITextField *texGet = [_downView viewWithTag:Tag_priceGet];
    
    UIButton *SelectStop = (UIButton *)[_downView viewWithTag:Tag_isSelectStop];
    UIButton *SelectGet = (UIButton *)[_downView viewWithTag:Tag_isSelectGet];
    
    UILabel *getRange  = [_downView viewWithTag:Tag_GetRange];
    UILabel *stopRange = [_downView viewWithTag:Tag_StopRange];
    
    UITextField *textNum = [_downView viewWithTag:Tag_num];
    if ([textNum.text intValue] > [_num intValue])
    {
        textNum.text = _num;
    }
    
    if (textStop.text.length > 0)
    {
        //选中
        [SelectStop setImage:[UIImage imageNamed:@"spotIndex_select"] forState:UIControlStateNormal];
        [SelectStop setSelected:YES];
        isStopSelect = YES;
        
        if ([_priceLabel.text floatValue] != 0 || ![_priceLabel.text isEqualToString:@"--"])
        {
            float stopText = ([textStop.text floatValue] - [_priceLabel.text floatValue])/[_priceLabel.text floatValue]*100.00;
            
            if ([_buyOrSal isEqualToString:@"B"])
            {
                if (stopText > 0)//如果计算出来值是正数，就加一个加号。如果是负数就不用做其他操作
                {
                    stopRange.text =[NSString stringWithFormat:@"较当前价跌+%@％", [NSString stringWithFormat:floatNumStr,stopText]];
                }else
                {
                    stopRange.text =[NSString stringWithFormat:@"较当前价跌%@％", [NSString stringWithFormat:floatNumStr,stopText]];
                }
                
                stopRange.attributedText = [Helper multiplicityText:stopRange.text from:0 to:5 color:[UIColor lightGrayColor]];
                
            }else
            {
                if (stopText > 0)//如果计算出来值是正数，就加一个加号。如果是负数就不用做其他操作
                {
                    stopRange.text =[NSString stringWithFormat:@"较当前价涨+%@％", [NSString stringWithFormat:floatNumStr,([textStop.text floatValue] - [_priceLabel.text floatValue])/[_priceLabel.text floatValue]*100.00]];
                }else
                {
                    stopRange.text =[NSString stringWithFormat:@"较当前价涨%@％", [NSString stringWithFormat:floatNumStr,([textStop.text floatValue] - [_priceLabel.text floatValue])/[_priceLabel.text floatValue]*100.00]];
                }
                
                stopRange.attributedText = [Helper multiplicityText:stopRange.text from:0 to:5 color:[UIColor lightGrayColor]];
                
            }
            
            stopRange.hidden = NO;
        }
        
    }else
    {
        //未选中
        [SelectStop setImage:[UIImage imageNamed:@"spotIndex_normal"] forState:UIControlStateNormal];
        [SelectStop setSelected:NO];
        stopRange.hidden = YES;
        isStopSelect = NO;
        
        
    }
    
    if (texGet.text.length > 0)
    {
        //选中
        [SelectGet setImage:[UIImage imageNamed:@"spotIndex_select"] forState:UIControlStateNormal];
        [SelectGet setSelected:YES];
        isGetSelect = YES;
        
        if ([_priceLabel.text floatValue] != 0 || ![_priceLabel.text isEqualToString:@"--"])
        {
            float getTextRange = ([texGet.text floatValue] - [_priceLabel.text floatValue])/[_priceLabel.text floatValue]*100.00;
            
            if ([_buyOrSal isEqualToString:@"B"])
            {
                if (getTextRange > 0)
                {
                    getRange.text = [NSString stringWithFormat:@"较当前价涨+%@％",[NSString stringWithFormat:floatNumStr,getTextRange]];
                }else
                {
                    getRange.text = [NSString stringWithFormat:@"较当前价涨%@％",[NSString stringWithFormat:floatNumStr,getTextRange]];
                }
                
                getRange.attributedText = [Helper multiplicityText:getRange.text from:0 to:5 color:[UIColor lightGrayColor]];
            }else
            {
                if (getTextRange > 0)
                {
                    getRange.text = [NSString stringWithFormat:@"较当前价跌+%@％",[NSString stringWithFormat:floatNumStr,getTextRange]];
                }else
                {
                    getRange.text = [NSString stringWithFormat:@"较当前价跌%@％",[NSString stringWithFormat:floatNumStr,getTextRange]];
                }
                
                getRange.attributedText = [Helper multiplicityText:getRange.text from:0 to:5 color:[UIColor lightGrayColor]];
            }
            getRange.hidden = NO;

        }
        
    }else
    {
        //未选中
        [SelectGet setImage:[UIImage imageNamed:@"spotIndex_normal"] forState:UIControlStateNormal];
        [SelectGet setSelected:NO];
        getRange.hidden = YES;
        isGetSelect = NO;
    }
}

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
            _highestProfitPrice = [array[0][0] objectForKey:@"LIMITUP"];
            _lowestProfitPrice  = [array[0][0] objectForKey:@"LIMITDOWN"];;
            
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
                 
                 UIButton *bottomBtn = [_downView viewWithTag:212121];
                 [bottomBtn setTitle:@"已闭市" forState:UIControlStateNormal];
                 bottomBtn.backgroundColor = [UIColor grayColor];
                 bottomBtn.enabled = NO;
             }else
             {
                 UIButton *bottomBtn = [_downView viewWithTag:212121];
                 [bottomBtn setTitle:@"确定" forState:UIControlStateNormal];
                 bottomBtn.backgroundColor = Color_red_pink;
                 bottomBtn.enabled = YES;

             }
         }
     }];
}

#pragma mark - 获取止盈止损可下单的数量
- (void)requestStopProfitNum
{
    
    NSString * token = [[SpotgoodsAccount sharedInstance] getSpotgoodsToken];
    NSString *tradeId = [[SpotgoodsAccount sharedInstance] getTradeID];//[texGet.text doubleValue]
    
    NSDictionary * dic = @{@"token":token,@"traderId":tradeId,@"wareId":_productModel.instrumentID};
    
    [NetRequest postRequestWithNSDictionary:dic url:K_Cash_StopProfitNum successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            _num = [NSString stringWithFormat:@"%d",[dictionary[@"data"][@"avaAmout"] intValue]];
            
            
        }else
        {
            [[UIEngine sharedInstance] showAlertWithTitle:dictionary[@"msg"] ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
            [UIEngine sharedInstance].alertClick =^ (int aIndex){
                
            };
        }
        
        UILabel *label = [_downView viewWithTag:10086];
        label.text = [NSString stringWithFormat:@"可设置%@手",_num];
        
        UITextField *textField = [_downView viewWithTag:Tag_num];
        textField.text = _num;
        
    } failureBlock:^(NSError *error) {
        NSLog(@"失败");
    }];
}

#pragma mark - 止盈止损下单
- (void)requestMarketOrder
{
    UITextField *textStop = [_downView viewWithTag:Tag_priceStop];
    UITextField *texGet = [_downView viewWithTag:Tag_priceGet];
    UITextField *textNumberHand = [_downView viewWithTag:Tag_num];
    
    NSString * token = [[SpotgoodsAccount sharedInstance] getSpotgoodsToken];
    NSString *tradeId = [[SpotgoodsAccount sharedInstance] getTradeID];//[texGet.text doubleValue]
        
    NSDictionary * dic = @{@"token":token,@"traderId":tradeId,@"wareId":_productModel.instrumentID,@"upPrice":@([texGet.text floatValue]),@"downPrice":@([textStop.text floatValue]),@"num":@([textNumberHand.text intValue])};
    
    [NetRequest postRequestWithNSDictionary:dic url:K_Cash_StopOrGetOrder successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            [[UIEngine sharedInstance] showAlertWithTitle:dictionary[@"msg"] ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
            [UIEngine sharedInstance].alertClick =^ (int aIndex){
                
                //返回到持仓页面
                [[NSNotificationCenter defaultCenter] postNotificationName:kSegValueChange object:nil];
                UIViewController *viewController = self.navigationController.viewControllers[1];
                [self.navigationController popToViewController:viewController animated:YES];
            };
            
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

#pragma mark - 改变减号
- (void)reloadChangeStopData:(UITextField *)textField
{
    UITextField *textStop = [_downView viewWithTag:Tag_priceStop];
    UITextField *textGet = [_downView viewWithTag:Tag_priceGet];

    if (textField == textGet)
    {
        if ([textGet.text floatValue] < [currentPrice floatValue] && ![textGet.text isEqualToString:@""])
        {
            [UIEngine showShadowPrompt:@"止盈价必须大于当前价"];
            textGet.text = currentPrice;
            return;
        }
    }
    
    if (textField == textStop)
    {
        if ([textStop.text floatValue] < 25)//跌停价[lowestPrice floatValue]
        {
            [UIEngine showShadowPrompt:@"止损价必须大于跌停价"];
            textStop.text = currentPrice;
            return;
        }
    }
    
}

#pragma mark - 计算止损涨跌幅默认值
- (void)changeProFitSelectStop:(BOOL)stopText
{
    UITextField *textStop   = [_downView viewWithTag:Tag_priceStop];
    UILabel * stopRangeLab  = [_downView viewWithTag:Tag_StopRange];
    
    if (stopText == YES)
    {
        if ([_priceLabel.text isEqualToString:@"--"] || [_priceLabel.text floatValue] == 0)
        {
            stopRangeLab.hidden = YES;
            [UIEngine showShadowPrompt:@"服务器繁忙，请稍后再试"];
        }else
        {
            if ([_buyOrSal isEqualToString:@"B"])//买（看多）
            {
                stopRangeLab.textColor = K_color_green;
                textStop.text = [NSString stringWithFormat:floatNumStr,[_priceLabel.text floatValue] - [_priceLabel.text floatValue]*RangeStopLow];
                stopRangeLab.text = [NSString stringWithFormat:@"较当前价跌-%@％",[NSString stringWithFormat:floatNumStr,fabs(([textStop.text floatValue] - [_priceLabel.text floatValue])/[_priceLabel.text floatValue]*100.00)]];
                
                stopRangeLab.attributedText = [Helper multiplicityText:stopRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];
                stopRangeLab.hidden = NO;
            }else if ([_buyOrSal isEqualToString:@"S"])//卖（看多）
            {
                stopRangeLab.textColor = Color_red_pink;
                textStop.text = [NSString stringWithFormat:floatNumStr,[_priceLabel.text floatValue] + [_priceLabel.text floatValue]*OnePerCent];
                stopRangeLab.text     = [NSString stringWithFormat:@"较当前价涨+%@％",[NSString stringWithFormat:floatNumStr,fabs(([textStop.text floatValue] - [_priceLabel.text floatValue])/[_priceLabel.text floatValue]*100.00)]];
                stopRangeLab.attributedText = [Helper multiplicityText:stopRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];
                stopRangeLab.hidden = NO;
            }
        }
        
    }else
    {
        textStop.text = @"";
        stopRangeLab.hidden = YES;
    }
}

#pragma mark - 计算止盈涨跌幅度默认值
- (void)changeProFitSelectGet:(BOOL)getText
{
    UITextField *textGet    = [_downView viewWithTag:Tag_priceGet];
    
    UILabel *getRangeLab   = [_downView viewWithTag:Tag_GetRange];
    
    if (getText == YES)//选中的情况
    {
        if ([_priceLabel.text isEqualToString:@"--"] || [_priceLabel.text floatValue] == 0)
        {
            getRangeLab.hidden = YES;
            [UIEngine showShadowPrompt:@"服务器繁忙，请稍后再试"];
        }else
        {
            if ([_buyOrSal isEqualToString:@"B"])
            {
                textGet.text = [NSString stringWithFormat:floatNumStr,[_priceLabel.text floatValue] + [_priceLabel.text floatValue]*OnePerCent];
                getRangeLab.textColor = Color_red_pink;
                getRangeLab.text     = [NSString stringWithFormat:@"较当前价涨+%@％",[NSString stringWithFormat:floatNumStr,fabs(([textGet.text floatValue] - [_priceLabel.text floatValue])/[_priceLabel.text floatValue]*100.00)]];
                getRangeLab.attributedText = [Helper multiplicityText:getRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];
            }else if ([_buyOrSal isEqualToString:@"S"])
            {
                getRangeLab.textColor = K_color_green;
                textGet.text = [NSString stringWithFormat:floatNumStr,[_priceLabel.text floatValue] - [_priceLabel.text floatValue]*RangeStopLow];
                getRangeLab.text = [NSString stringWithFormat:@"较当前价跌-%@％",[NSString stringWithFormat:floatNumStr,fabs(([textGet.text floatValue] - [_priceLabel.text floatValue])/[_priceLabel.text floatValue]*100.00)]];
                
                getRangeLab.attributedText = [Helper multiplicityText:getRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];
            }
        
            getRangeLab.hidden = NO;
        }
        
    }else
    {
        textGet.text = @"";
        getRangeLab.hidden = YES;
    }
}

#pragma mark - 键盘落下的时候判断止盈止损的范围
- (void)reloadDownKeyboardData:(UITextField *)textField
{
    UITextField *textStop = [_downView viewWithTag:Tag_priceStop];
    UITextField *texGet = [_downView viewWithTag:Tag_priceGet];
    
    UILabel *getRange  = [_downView viewWithTag:Tag_GetRange];
    UILabel *stopRange = [_downView viewWithTag:Tag_StopRange];
    
    float incrNum                       = powf(10, [_productModel.decimalPlaces intValue]);
    //当前价+1个点
    NSString *priceGetStr               = [NSString stringWithFormat:floatNumStr,[_priceLabel.text floatValue] + 3/incrNum];
    //当前价-1个点
    NSString *priceStopStr              = [NSString stringWithFormat:floatNumStr,[_priceLabel.text floatValue] - 3/incrNum];
    NSString *hightPriceStr             = _highestProfitPrice;
    
    NSString *lowPriceStr               = [NSString stringWithFormat:floatNumStr,([_lowestProfitPrice floatValue] - [_lowestProfitPrice floatValue]*RangeStopLow)];
    
    if ([_lowestProfitPrice isEqualToString:@""] || _lowestProfitPrice == nil || [_highestProfitPrice isEqualToString:@""] || _highestProfitPrice == nil)
    {
        //                    [UIEngine showShadowPrompt:@"获取数据失败"];
        return;
    }
    
    if (textField == texGet)//止盈的范围（当前价-一个点<止盈<涨停价）  
    {
        if ([_priceLabel.text isEqualToString:@"--"] || [_priceLabel.text floatValue] == 0)
        {
            getRange.hidden = YES;
            [UIEngine showShadowPrompt:@"服务器繁忙，请稍后再试"];
        }else
        {
            if (texGet.text <=0 || [texGet.text isEqualToString:@""])
            {
                return;
            }
            
            if ([_buyOrSal isEqualToString:@"B"])
            {
                if ([texGet.text floatValue] < [priceGetStr floatValue])
                {
//                    [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止盈范围%@~%@",priceGetStr,hightPriceStr]];
                    texGet.text = priceGetStr;
                    
                }else if ([texGet.text floatValue] > [hightPriceStr floatValue])
                {
//                    [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止盈范围%@~%@",priceGetStr,hightPriceStr]];
                    texGet.text = hightPriceStr;
                    
                }
                
                getRange.textColor = Color_red_pink;
                getRange.text = [NSString stringWithFormat:@"较当前价涨+%@％",[NSString stringWithFormat:floatNumStr,fabs(([texGet.text floatValue] - [_priceLabel.text floatValue])/[_priceLabel.text floatValue]*100.00)]];
                getRange.hidden = NO;
                getRange.attributedText = [Helper multiplicityText:getRange.text from:0 to:5 color:[UIColor lightGrayColor]];
            }else if([_buyOrSal isEqualToString:@"S"])
            {
                if ([texGet.text floatValue] < [lowPriceStr floatValue])
                {
//                    [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止盈范围%@~%@",lowPriceStr,priceStopStr]];
                    texGet.text = lowPriceStr;
                    
                }else if ([texGet.text floatValue] > [priceStopStr floatValue])
                {
//                    [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止盈范围%@~%@",lowPriceStr,priceStopStr]];
                    texGet.text = priceStopStr;
                    
                }
                getRange.textColor = K_color_green;
                getRange.hidden = NO;
                getRange.text =[NSString stringWithFormat:@"较当前价跌-%@％", [NSString stringWithFormat:floatNumStr,fabs(([texGet.text floatValue] - [_priceLabel.text floatValue])/[_priceLabel.text floatValue]*100.00)]];
                getRange.attributedText = [Helper multiplicityText:getRange.text from:0 to:5 color:[UIColor lightGrayColor]];
                return;

            }
            
        }
        

    }else if (textField == textStop)//止损范围（跌停价-跌停价*0.5%<止损<当前价-一个点）
    {
        if ([_priceLabel.text isEqualToString:@"--"] || [_priceLabel.text floatValue] == 0)//如果看多价为空
        {
            stopRange.hidden = YES;
            [UIEngine showShadowPrompt:@"服务器繁忙，请稍后再试"];
        }else
        {
            if (textStop.text <=0 || [textStop.text isEqualToString:@""])
            {
                return;
            }
            
            if ([_buyOrSal isEqualToString:@"B"])
            {
                if ([textStop.text floatValue] < [lowPriceStr floatValue])
                {
//                    [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止损范围%@~%@",lowPriceStr,priceStopStr]];
                    textStop.text = lowPriceStr;
                    
                }else if ([textStop.text floatValue] > [priceStopStr floatValue])
                {
//                    [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止损范围%@~%@",lowPriceStr,priceStopStr]];
                    textStop.text = priceStopStr;
                    
                }
                
                stopRange.textColor = K_color_green;
                stopRange.hidden = NO;
                stopRange.text =[NSString stringWithFormat:@"较当前价跌-%@％", [NSString stringWithFormat:floatNumStr,fabs(([textStop.text floatValue] - [_priceLabel.text floatValue])/[_priceLabel.text floatValue]*100.00)]];
                stopRange.attributedText = [Helper multiplicityText:stopRange.text from:0 to:5 color:[UIColor lightGrayColor]];
                return;
            }else if ([_buyOrSal isEqualToString:@"S"])
            {
                if ([textStop.text floatValue] < [priceGetStr floatValue])
                {
//                    [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止损范围%@~%@",priceGetStr,hightPriceStr]];
                    textStop.text = priceGetStr;
                    
                }else if ([textStop.text floatValue] > [hightPriceStr floatValue])
                {
//                    [UIEngine showShadowPrompt:[NSString stringWithFormat:@"止损范围%@~%@",priceGetStr,hightPriceStr]];
                    textStop.text = hightPriceStr;
                    
                }
                
                stopRange.textColor = Color_red_pink;
                stopRange.text = [NSString stringWithFormat:@"较当前价涨+%@％",[NSString stringWithFormat:floatNumStr,fabs(([textStop.text floatValue] - [_priceLabel.text floatValue])/[_priceLabel.text floatValue]*100.00)]];
                stopRange.hidden = NO;
                stopRange.attributedText = [Helper multiplicityText:stopRange.text from:0 to:5 color:[UIColor lightGrayColor]];

            }
        }
        
    }
}

#pragma mark - 看多价改变的时候，止盈止损范围重新计算
- (void)changeProfitStopOrGetPrice
{
    UITextField *textStop = [_downView viewWithTag:Tag_priceStop];
    UITextField *textGet = [_downView viewWithTag:Tag_priceGet];
    
    UILabel *getRangeLab  = [_downView viewWithTag:Tag_GetRange];
    UILabel *stopRangeLab = [_downView viewWithTag:Tag_StopRange];
    
    if (isGetSelect == YES)
    {
        textGet.text = [NSString stringWithFormat:floatNumStr,[_priceLabel.text floatValue] + [_priceLabel.text floatValue]*OnePerCent];
        getRangeLab.text     = [NSString stringWithFormat:@"较当前价涨+%@％",[NSString stringWithFormat:floatNumStr,fabs(([textGet.text floatValue] - [_priceLabel.text floatValue])/[_priceLabel.text floatValue]*100.00)]];
        getRangeLab.attributedText = [Helper multiplicityText:getRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];
        getRangeLab.hidden = NO;
    }
    
    if (isStopSelect == YES)
    {
        textStop.text = [NSString stringWithFormat:floatNumStr,[_priceLabel.text floatValue] - [_priceLabel.text floatValue]*RangeStopLow];
        stopRangeLab.text = [NSString stringWithFormat:@"较当前价跌-%@％",[NSString stringWithFormat:floatNumStr,fabs(([textStop.text floatValue] - [_priceLabel.text floatValue])/[_priceLabel.text floatValue]*100.00)]];
        
        stopRangeLab.attributedText = [Helper multiplicityText:stopRangeLab.text from:0 to:5 color:[UIColor lightGrayColor]];
        stopRangeLab.hidden = NO;
    }
}

- (void)textFieldValueChange
{
    [self reloadStopOrGetOrder:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
       [self reloadDownKeyboardData:textField];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    UITextPosition *beginingOfDoc=textField.beginningOfDocument;
    UITextPosition *startPos = [textField positionFromPosition:beginingOfDoc offset:0];
    
    UITextPosition *endPos = [textField positionFromPosition:beginingOfDoc offset:textField.text.length];
    
    UITextRange *selectionRange= [textField textRangeFromPosition:startPos toPosition:endPos];
    [textField setSelectedTextRange:selectionRange];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UITextPosition *beginingOfDoc=textField.beginningOfDocument;
    UITextPosition *startPos = [textField positionFromPosition:beginingOfDoc offset:0];
    
    UITextPosition *endPos = [textField positionFromPosition:beginingOfDoc offset:textField.text.length];
    
    UITextRange *selectionRange= [textField textRangeFromPosition:startPos toPosition:endPos];
    [textField setSelectedTextRange:selectionRange];
    
    return YES;
}

- (void)selectAll:(id)sender{
    
}

- (NSRange) selectedRange:(UITextField *)textField
{
    UITextPosition* beginning = textField.beginningOfDocument;
    UITextRange* selectedRange = textField.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    const NSInteger location = [textField offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [textField offsetFromPosition:selectionStart toPosition:selectionEnd];
    return NSMakeRange(location, length);
}
- (void) setSelectedRange:(NSRange) range text:(UITextField *)textField
{
    UITextPosition* beginning = textField.beginningOfDocument;
    UITextPosition* startPosition = [textField positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [textField positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [textField textRangeFromPosition:startPosition toPosition:endPosition];
    [textField setSelectedTextRange:selectionRange];
}

//- (void) selectTextAtRange:(NSRange)range
//{
//    UITextField *textStop = [_downView viewWithTag:Tag_priceStop];
//    
//    UITextRange * r = [textStop selectedTextRange];
//    NSString *selectedText = [textStop textInRange:r];
//    
//    NSLog(@"fufufuf%@",selectedText);
//    
//    [textStop setSelectedTextRange:r];
//}
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
            if ([UIScreen mainScreen].bounds.size.height <=480)
            {
                _downView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeigth - 64);
            }
        }];
        
        UIButton *button = (UIButton *)[self.view viewWithTag:123];
        [button removeFromSuperview];
    } else {
        
        [UIView animateWithDuration:animationDuration animations:^{
            if ([UIScreen mainScreen].bounds.size.height <=480)
            {
                 _downView.frame = CGRectMake(0, 20, ScreenWidth, ScreenHeigth - 64);
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
