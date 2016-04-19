//
//  ClosePositionViewController.m
//  hs
//
//  Created by Xse on 15/11/25.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "ClosePositionViewController.h"
#import "FiveMarketView.h"
#import "HJCAjustNumButton.h"
#import "EntrustView.h"
#import "MyCashOrderPage.h"
#import "MarketIsStatusAlert.h"

#define Tag_marketNum            101010
#define Tag_limitedNum           101011
#define Tag_limitedPrice         101012

#define PounDageNum               0.0008//万分之八（手续费和计算可买手数的时候用到）
#define PounMoneyNum              10 //10倍杠杆

@interface ClosePositionViewController ()
{
    UIView *showTextView;
    UIView *fiveBackView;
    
    NSInteger isSegSelect;
    NSInteger positonMarketIsStatus;//9闭市 0 可售
    
    UIButton *closePositionBtn;
    
    NSString *floatNumStr;
    UILabel *tishiLab;
    
}

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *closePriceLab;
@property (nonatomic,strong) UISegmentedControl *seg;

@property (nonatomic,strong) NSString *highestPrice;
@property (nonatomic,strong) NSString *lowestPrice;

@property (nonatomic,strong) UILabel *upsAndDownsLab;
@end

@implementation ClosePositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor blackColor];
    
    [self requestCotsLowOrHighPriceData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSocketInfo:) name:kPositionBosomPage object:nil];
    
     floatNumStr = [NSString stringWithFormat:@"%@%@f",@"%",[NSString stringWithFormat:@".%d",[_productModel.decimalPlaces intValue]]];
    
    [self loadNav];
    [self loadUIView];
    [self loadNowPrice];
    
    [self loadUpView];
    
    [self setUpForDismissKeyboard];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self requestMarketIsStatus];
}

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
    self.titleLabel.text = [NSString stringWithFormat:@"%@\n%@",_productModel.commodityName,_productModel.instrumentID];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.center = CGPointMake(self.view.center.x, 20+22);
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.attributedText = [Helper multiplicityText:self.titleLabel.text from:0 to:(int)[_productModel.commodityName length] font:15];
    [self.view addSubview:self.titleLabel];
    
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadUIView
{
    _seg = [[UISegmentedControl alloc]initWithItems:@[@"市价",@"限价"]];
    _seg.frame = CGRectMake(ScreenWidth/2-ScreenWidth/5*2/2-10, CGRectGetMaxY(self.titleLabel.frame) + 5, ScreenWidth/5*2+20, 32.0/667*ScreenHeigth);
    _seg.selectedSegmentIndex = 0;
    [_seg addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventValueChanged];
    _seg.tintColor = [UIColor colorWithRed:234/255.0 green:194/255.0 blue:129/255.0 alpha:1];
    [self.view addSubview:_seg];
    
}

-(void)segClick:(UISegmentedControl *)seg
{
    if (seg.selectedSegmentIndex == 0) {
        isSegSelect = 0;
        [showTextView removeFromSuperview];
        [self loadUpView];
        
    }else
    {
        isSegSelect = 1;
        [showTextView removeFromSuperview];
        [self loadUpView];
    }
    [self requestCotsLowOrHighPriceData];
}

#pragma mark - 当前价
- (void)loadNowPrice
{
    UILabel *proLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_seg.frame) + 20*ScreenWidth/320, ScreenWidth, 14)];
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
    [self.view addSubview:proLabel];
    
    _closePriceLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(proLabel.frame), ScreenWidth, 20)];
    _closePriceLab.text = [NSString stringWithFormat:@"%.2f",_price.floatValue];
    _closePriceLab.font = [UIFont systemFontOfSize:17];
    _closePriceLab.textColor = Color_Gold;
    _closePriceLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_closePriceLab];
    
    _upsAndDownsLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_closePriceLab.frame), ScreenWidth, 18)];
    _upsAndDownsLab.text = [NSString stringWithFormat:@"%@",_updownData];
    _upsAndDownsLab.font = [UIFont systemFontOfSize:13.0];
    _upsAndDownsLab.textColor = Color_Gold;
    _upsAndDownsLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_upsAndDownsLab];

    tishiLab = [[UILabel alloc]init];
    tishiLab.text = @"卖出价格以成交时市价为准";
    tishiLab.font = [UIFont systemFontOfSize:12.0];
    tishiLab.textColor = K_color_red;
    tishiLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tishiLab];
    

    closePositionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closePositionBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [closePositionBtn setTitle:@"平仓" forState:UIControlStateNormal];
    closePositionBtn.backgroundColor = Color_red_pink;
    [closePositionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closePositionBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    closePositionBtn.layer.cornerRadius = 3;
    closePositionBtn.layer.masksToBounds = YES;
    [self.view addSubview:closePositionBtn];
}

#pragma mark - 手数/止损/止赢
- (void)loadUpView
{
    showTextView = [[UIView alloc]init];
    
    NSArray *arrayTitle;
    NSArray *arrayDetail;
    NSString *buyNum = [NSString stringWithFormat:@"可卖%@手",_num];
    if (isSegSelect == 0)
    {
        arrayTitle = @[@"设置手数",@"参考手续费"];
        arrayDetail = @[buyNum,@"以成交时对应手续费为准"];
        
    }else
    {
        arrayTitle = @[@"限价卖出",@"设置手数",@"参考手续费"];
        arrayDetail = @[@"查看五档行情",buyNum,@"以成交时对应手续费为准"];
    }
    
    
    showTextView.frame = CGRectMake(0, CGRectGetMaxY(_upsAndDownsLab.frame) + 20*ScreenWidth/320, ScreenWidth,arrayTitle.count*12 + arrayTitle.count*50 - 15);
//    showTextView.backgroundColor = [UIColor redColor];
    [self.view addSubview:showTextView];
    //    }

    for (NSInteger i = 0; i < arrayTitle.count; i++)
    {
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.text = arrayTitle[i];
        titleLab.frame = CGRectMake(20*ScreenWidth/320,i*12 + 50 *i, ScreenWidth/2 - 20, 20);
        titleLab.textColor = [UIColor lightGrayColor];
        titleLab.backgroundColor = [UIColor blackColor];
        titleLab.font = [UIFont systemFontOfSize:12.0];
        [showTextView addSubview:titleLab];
        
        UILabel *groupLab = [[UILabel alloc]init];
        groupLab.text = arrayDetail[i];
        groupLab.frame = CGRectMake(CGRectGetMinX(titleLab.frame), CGRectGetMaxY(titleLab.frame) -2, 100, 20);
        groupLab.textColor = [UIColor colorWithRed:234/255.0 green:194/255.0 blue:129/255.0 alpha:1];
        groupLab.backgroundColor = [UIColor blackColor];
        groupLab.font = [UIFont systemFontOfSize:11.0];
        [showTextView addSubview:groupLab];
        
        UILabel *countFeeLab = [[UILabel alloc]init];
        if (isSegSelect == 0)
        {
            if (i == 1)
            {
                groupLab.frame = CGRectMake(CGRectGetMinX(titleLab.frame), CGRectGetMaxY(titleLab.frame) -2, ScreenWidth/2, 20);
                
                countFeeLab.text = @"￥--";
                countFeeLab.tag = 88888;
                countFeeLab.frame = CGRectMake(CGRectGetMaxX(groupLab.frame), CGRectGetMinY(titleLab.frame) -2, ScreenWidth -CGRectGetMaxX(groupLab.frame) - 20*ScreenWidth/320 , 40);
                countFeeLab.textColor = [UIColor colorWithRed:222/255.0 green:224/255.0 blue:216/255.0 alpha:1];
                countFeeLab.backgroundColor = [UIColor blackColor];
                countFeeLab.font = [UIFont systemFontOfSize:12.0];
                countFeeLab.textAlignment = NSTextAlignmentRight;
                [showTextView addSubview:countFeeLab];
            }else
            {
                groupLab.tag = 121211;
                HJCAjustNumButton *btn = [[HJCAjustNumButton alloc]init];
                btn.frame = CGRectMake(ScreenWidth - 20*ScreenWidth/320 - 160*ScreenWidth/320, CGRectGetMinY(titleLab.frame), 160*ScreenWidth/320, 35);
                [btn.textField addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventValueChanged];
                btn.textField.tag = Tag_marketNum;
                btn.textField.font = [UIFont systemFontOfSize:13.0];
                btn.isIntOrFloat = 0;
                btn.textField.text = _num;
                btn.floatNumStr = _productModel.decimalPlaces;
                btn.lineColor = [UIColor lightGrayColor];
                btn.textField.keyboardType = UIKeyboardTypeNumberPad;
                btn.callBack = ^(NSString *currentNum,UITextField *textField)
                {
                    NSLog(@"打印%@",currentNum);
                    [self reloadPounDageData];
                };
                btn.callDecreaseBack = ^(NSString *cureentNum,UITextField *textFiled)
                {
                    //减号
                    [self reloadPounDageData];
                };
                [showTextView addSubview:btn];
            }
        }else
        {
            if (i == 2) {
                groupLab.frame = CGRectMake(CGRectGetMinX(titleLab.frame), CGRectGetMaxY(titleLab.frame) -2, ScreenWidth/2, 20);
                countFeeLab.text = @"￥--";
                 countFeeLab.tag = 99999;
                countFeeLab.frame = CGRectMake( CGRectGetMaxX(groupLab.frame), CGRectGetMinY(titleLab.frame) -2, ScreenWidth -CGRectGetMaxX(groupLab.frame) - 20*ScreenWidth/320 , 40);
                countFeeLab.textColor = [UIColor colorWithRed:222/255.0 green:224/255.0 blue:216/255.0 alpha:1];
                countFeeLab.font = [UIFont systemFontOfSize:12.0];
                countFeeLab.textAlignment = NSTextAlignmentRight;
                [showTextView addSubview:countFeeLab];

            }else
            {
                HJCAjustNumButton *btn = [[HJCAjustNumButton alloc]init];
                btn.frame = CGRectMake(ScreenWidth - 20*ScreenWidth/320 - 160*ScreenWidth/320, CGRectGetMinY(titleLab.frame), 160*ScreenWidth/320, 35);
                [btn.textField addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventValueChanged];
                btn.lineColor = [UIColor lightGrayColor];
                btn.textField.font = [UIFont systemFontOfSize:13.0];
                btn.floatNumStr = _productModel.decimalPlaces;
                
                btn.callBack = ^(NSString *currentNum,UITextField *textField)
                {
                    NSLog(@"打印%@",currentNum);
                    [self downKeyboardPrice:textField];
                    [self reloadPounDageData];
                };
                btn.callDecreaseBack = ^(NSString *cureentNum,UITextField *textFiled)
                {
                    //减号
                    [self downKeyboardPrice:textFiled];
                    [self reloadPounDageData];
                };
                [showTextView addSubview:btn];
                
                if (i == 0)
                {
                    btn.textField.tag = Tag_limitedPrice;
                    btn.isIntOrFloat = 1;
                    if ([_closePriceLab.text isEqualToString:@"--"])
                    {
                        btn.textField.text = @"";
                    }else
                    {
                        btn.textField.text = _closePriceLab.text;
                    }
                    
                    btn.textField.keyboardType = UIKeyboardTypeNumberPad;
                    
                    //如果是限价，查看五档行情
                    groupLab.userInteractionEnabled = YES;
                    UITapGestureRecognizer *supportBinkTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkCloseMarket)];
                    [groupLab addGestureRecognizer:supportBinkTapGes];
                    
                    CGSize groupSize = [Helper sizeWithText:groupLab.text font:[UIFont systemFontOfSize:11.0] maxSize:CGSizeMake(90*ScreenWidth/320, 20)];
                    groupLab.frame = CGRectMake(CGRectGetMinX(titleLab.frame), CGRectGetMaxY(titleLab.frame) -2, groupSize.width, 20);
                    //限价查看五档行情的小图标
                    UIImageView *limitiedImg = [[UIImageView alloc]init];
                    limitiedImg.userInteractionEnabled = YES;
                    limitiedImg.frame = CGRectMake(CGRectGetMaxX(groupLab.frame) + 2, 0, 10*ScreenWidth/320, 10*ScreenWidth/320);
                    limitiedImg.center = CGPointMake(CGRectGetMaxX(groupLab.frame) + 10, groupLab.center.y);
                    limitiedImg.image = [UIImage imageNamed:@"limitied_icon"];
                    [showTextView addSubview:limitiedImg];
                    
                    UITapGestureRecognizer *supportBinkTapGesTo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkCloseMarket)];
                    [limitiedImg addGestureRecognizer:supportBinkTapGesTo];

                }else
                {
                    groupLab.tag = 121212;
                    btn.textField.text = _num;
                    btn.textField.keyboardType = UIKeyboardTypeDecimalPad;
                    btn.textField.tag = Tag_limitedNum;
                    btn.isIntOrFloat = 0;
                }
            }
        }
    }
    if (isSegSelect == 0)
    {
        tishiLab.hidden = NO;
        tishiLab.frame = CGRectMake(0, CGRectGetMaxY(showTextView.frame) + 30*ScreenWidth/320, ScreenWidth, 20);
        closePositionBtn.frame = CGRectMake(20*ScreenWidth/320, CGRectGetMaxY(tishiLab.frame) + 10, ScreenWidth - 20*2*ScreenWidth/320, 40.0/667*ScreenHeigth);
    }else
    {
        tishiLab.hidden = YES;
        closePositionBtn.frame = CGRectMake(20*ScreenWidth/320, CGRectGetMaxY(showTextView.frame) + 30*ScreenWidth/320, ScreenWidth - 20*2*ScreenWidth/320, 40.0/667*ScreenHeigth);
    }
    
    [self reloadPounDageData];
}

#pragma mark - 查看五档行情
- (void)checkCloseMarket
{
    fiveBackView = [[UIView alloc]init];
    fiveBackView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
    fiveBackView.backgroundColor = [UIColor blackColor];
    fiveBackView.alpha = 0.7;
    [self.view addSubview:fiveBackView];
    
    if (positonMarketIsStatus == 9)//闭市
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
        fiveView.btnTitle = @"平仓";
        fiveView.instrumentType = _productModel.instrumentCode;
        if ([_buyOrSal isEqualToString:@"B"])
        {
            fiveView.buyState = 0;
            //        fiveView.isShowAskOrBid = @"2";//暂时不传这个值
        }else
        {
            fiveView.buyState = 1;
            //        fiveView.isShowAskOrBid = @"1";
        }
        
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
             [self requestCloseLimitedData:priceStr];
             
         }];
        [self.view addSubview:fiveView];

    }
}

#pragma mark 获取行情数据

-(void)getSocketInfo:(NSNotification *)notify{
    NSDictionary    * infoDic = notify.object;
    
    if ([_buyOrSal isEqualToString:@"B" ]) {
        //看多取的价
        _closePriceLab.text = infoDic[@"askPrice"];
        
    }
    else if ([_buyOrSal isEqualToString:@"S"]){
        //看空取的价
        _closePriceLab.text = infoDic[@"bidPrice"];
    }
    
    _upsAndDownsLab.text = infoDic[@"changePercent"];
    [self reloadPounDageData];
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
            _highestPrice = [array[0][0] objectForKey:@"LIMITUP"];
            _lowestPrice  = [array[0][0] objectForKey:@"LIMITDOWN"];
            
            NSInteger userNum;
            if ([_buyOrSal isEqualToString:@"B"])
            {
                userNum = [[array[0][0] objectForKey:@"MAXBQTY"] intValue];//用户可下单手数
            }else
            {
                userNum = [[array[0][0] objectForKey:@"MAXSQTY"] intValue];//用户可下单手数
            }
            
            UITextField *textMarketNum = [showTextView viewWithTag:Tag_marketNum];
            UITextField *textLimitedNum = [showTextView viewWithTag:Tag_limitedNum];
            
            UILabel *marketLabel = [showTextView viewWithTag:121211];
            UILabel *limitedLab = [showTextView viewWithTag:121212];
            
            if (isSegSelect == 0)
            {
                textMarketNum.text = [NSString stringWithFormat:@"%ld",(long)userNum];
                marketLabel.text = [NSString stringWithFormat:@"可设置%ld手",(long)userNum];
            }else
            {
                textLimitedNum.text = [NSString stringWithFormat:@"%ld",(long)userNum];
                limitedLab.text = [NSString stringWithFormat:@"可设置%ld手",(long)userNum];
            }
            
            [self reloadPounDageData];
        }
    } failureBlock:^(NSError *error) {
        
        NSLog(@"失败");
    }];
    
}

- (void)textFieldValueChange
{
    [self reloadPounDageData];
}

#pragma mark - 点击文本框的时候，全选文本框里的文字
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    UITextPosition *beginingOfDoc=textField.beginningOfDocument;
    UITextPosition *startPos = [textField positionFromPosition:beginingOfDoc offset:0];
    
    UITextPosition *endPos = [textField positionFromPosition:beginingOfDoc offset:textField.text.length];
    
    UITextRange *selectionRange= [textField textRangeFromPosition:startPos toPosition:endPos];
    [textField setSelectedTextRange:selectionRange];
}

#pragma mark - 键盘落下的时候
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self downKeyboardPrice:textField];
}

- (void)downKeyboardPrice:(UITextField *)textfield
{
    UITextField *textLImitedPrice = [showTextView viewWithTag:Tag_limitedPrice];
    
    if (isSegSelect == 1)
    {
        if (textfield == textLImitedPrice)
        {
            if ([textLImitedPrice.text floatValue] < [_lowestPrice floatValue])
            {
//                [UIEngine showShadowPrompt:[NSString stringWithFormat:@"限价范围%@~%@",_lowestPrice,_highestPrice]];
                textLImitedPrice.text = _closePriceLab.text;
                return;
            }else if ([textLImitedPrice.text floatValue] >[_highestPrice floatValue] )
            {
//                [UIEngine showShadowPrompt:[NSString stringWithFormat:@"限价范围%@~%@",_lowestPrice,_highestPrice]];
                textLImitedPrice.text = _closePriceLab.text;
                return;
            }
 
        }
    }
}

#pragma mark - 刷新参考书续费
- (void)reloadPounDageData
{
    UILabel *pounDagetMarketLab = [showTextView viewWithTag:88888];
    UILabel *pounDageLImitedLab = [showTextView viewWithTag:99999];
    
    UITextField *textMarketNum = [showTextView viewWithTag:Tag_marketNum];
    UITextField *textLimitedNum = [showTextView viewWithTag:Tag_limitedNum];
    UITextField *textLImitedPrice = [showTextView viewWithTag:Tag_limitedPrice];
    
    if (isSegSelect == 0)
    {
        NSString *marketPoun = [NSString stringWithFormat:floatNumStr,[textMarketNum.text intValue]*[_closePriceLab.text floatValue]*PounDageNum];
        pounDagetMarketLab.text = [NSString stringWithFormat:@"￥%@",marketPoun];
    }else
    {
        NSString *limtitedPoun = [NSString stringWithFormat:floatNumStr,[textLimitedNum.text intValue]*[textLImitedPrice.text floatValue]*PounDageNum];
        pounDageLImitedLab.text = [NSString stringWithFormat:@"￥%@",limtitedPoun];
    }
}

#pragma mark - 点击平仓
- (void)clickCloseBtn
{
    UITextField *textMarketNum = [showTextView viewWithTag:Tag_marketNum];
    UITextField *textLimitedNum = [showTextView viewWithTag:Tag_limitedNum];
    
    if (isSegSelect == 0)
    {
        if ([textMarketNum.text floatValue] == 0 || [textMarketNum.text isEqualToString:@""])
        {
            [UIEngine showShadowPrompt:@"手数未设置"];
            return;
        }
        //市价
        [self requestCloseMarketOrder];
        
    }else
    {
        if ([textLimitedNum.text floatValue] == 0 || [textLimitedNum.text isEqualToString:@""])
        {
            [UIEngine showShadowPrompt:@"手数未设置"];
            return;
        }
        //限价
        [self requestCloseLimitedData:@"NO"];
    }
}

#pragma mark - 市价委托下单
- (void)requestCloseMarketOrder
{
    UITextField *textMarketNum = [showTextView viewWithTag:Tag_marketNum];
    
    NSString * token = [[SpotgoodsAccount sharedInstance] getSpotgoodsToken];
    NSString *tradeId = [[SpotgoodsAccount sharedInstance] getTradeID];
    
    NSDictionary * dic = @{@"token":token,@"traderId":tradeId,@"buyOrSal":_buyOrSal,@"wareId":_productModel.instrumentID,@"num":@([textMarketNum.text intValue]),@"price":_closePriceLab.text};
    
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
- (void)requestCloseLimitedData:(NSString *)priceStr
{
    UITextField *textLimitedNum = [showTextView viewWithTag:Tag_limitedNum];
    UITextField *textLImitedPrice = [showTextView viewWithTag:Tag_limitedPrice];
    
    NSString * token = [[SpotgoodsAccount sharedInstance] getSpotgoodsToken];
    NSString *tradeId = [[SpotgoodsAccount sharedInstance] getTradeID];
    
    NSString *limitePrice = @"";
    
    if ([priceStr isEqualToString:@"NO"])
    {
        limitePrice = textLImitedPrice.text;
    }else
    {
        limitePrice = _closePriceLab.text;
    }
    
    if ([limitePrice isEqualToString:@"--"])
    {
        [UIEngine showShadowPrompt:@"服务器繁忙，请稍后再试"];
    }
    
    NSDictionary * dic = @{@"token":token,@"traderId":tradeId,@"buyOrSal":_buyOrSal,@"wareId":_productModel.instrumentID,@"price":@([limitePrice doubleValue]),@"num":@([textLimitedNum.text intValue])};
    
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
             positonMarketIsStatus = marketStatus;
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
                 
                 [closePositionBtn setTitle:@"已闭市" forState:UIControlStateNormal];
                 closePositionBtn.backgroundColor = [UIColor grayColor];
                 closePositionBtn.enabled = NO;
             }else
             {
                 [closePositionBtn setTitle:@"平仓" forState:UIControlStateNormal];
                 closePositionBtn.backgroundColor = Color_red_pink;
                 closePositionBtn.enabled = YES;

             }
         }
     }];
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
