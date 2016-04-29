//
//  IndexQuickOrderController.m
//  hs
//
//  Created by RGZ on 15/9/23.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "IndexQuickOrderController.h"
#import "MarketModel.h"
#import "NetRequest.h"

#define SALERECORE_TEXTCOLOR_GRAY K_color_grayBlack

#define Tag_agreeButton     708
#define Tag_timeLabel       709
@interface IndexQuickOrderController ()
{
    UIImageView     *guide_OneImg;
    UIImageView     *guide_TwoImg;
    
    UIView          *guideView ;
}

@property (nonatomic,strong)UIView * hiddenView;

@end

@implementation IndexQuickOrderController
@synthesize isOrderQuickCouPon,isAutoBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isOrderQuickCouPon = @"YES";
    
    [self loadQuickUI];
    [self getMarketEndTime];
}

#pragma mark - 快速下单引导页
- (void)orderQuickGuideView
{
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    if ([cacheModel.isQuickOrderOrLogin isEqualToString:@"YES"])
    {
        guideView = [[UIView alloc]init];
        guideView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
        guideView.backgroundColor = [UIColor blackColor];
        guideView.alpha = 0.7;
        [self.view addSubview:guideView];
        
        UITapGestureRecognizer *portraitTapTWo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [guideView addGestureRecognizer:portraitTapTWo];
        
        guide_OneImg = [[UIImageView alloc]init];
        guide_OneImg.image = [UIImage imageNamed:@"order_guide_6"];
        [self.view addSubview:guide_OneImg];
        UITapGestureRecognizer *portr_one = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [guide_OneImg addGestureRecognizer:portr_one];
        
        guide_TwoImg = [[UIImageView alloc]init];
        guide_TwoImg.userInteractionEnabled = YES;
        guide_TwoImg.image = [UIImage imageNamed:@"order_guide_1"];
        
        [self.view addSubview:guide_TwoImg];
        
        if ([UIScreen mainScreen].bounds.size.height <=480) {
            guide_OneImg.frame = CGRectMake(10, 64,  ScreenWidth - 20 , 267*0.9*ScreenWidth/320);
            guide_TwoImg.frame = CGRectMake(ScreenWidth/2 - 55*0.9*ScreenWidth/320/2, CGRectGetMaxY(guide_OneImg.frame) + 50, 55*0.9*ScreenWidth/320 , 74*0.9*ScreenWidth/320);
        }else
        {
            guide_OneImg.frame = CGRectMake(10, 95*ScreenWidth/320,  ScreenWidth - 20 , 267*0.9*ScreenWidth/320);
            guide_TwoImg.frame = CGRectMake(ScreenWidth/2 - 55*0.9*ScreenWidth/320/2, CGRectGetMaxY(guide_OneImg.frame) + 75*ScreenWidth/320, 55*0.9*ScreenWidth/320 , 74*0.9*ScreenWidth/320);
        }
        
        UITapGestureRecognizer *portr_two = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [guide_TwoImg addGestureRecognizer:portr_two];
        
    }
}


- (void)editPortrait
{
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    cacheModel.isQuickOrderOrLogin = @"NO";
    [CacheEngine setCacheInfo:cacheModel];
    
    [guide_OneImg removeFromSuperview];
    [guide_TwoImg removeFromSuperview];
    [guideView removeFromSuperview];
}


-(void)loadQuickUI{
   
    self.seg.hidden = YES;
    UIButton * btn = (UIButton *)[self.view viewWithTag:Tag_agreeButton];
    [btn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.selected = YES;
    _hiddenView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bottomBtn.frame.size.height+self.bottomBtn.frame.origin.y, ScreenWidth, ScreenHeigth-self.bottomBtn.frame.size.height-self.bottomBtn.frame.origin.y)];
    _hiddenView.backgroundColor = k_color_whiteBack;
    
    UILabel *timeLabel = (UILabel *)[self.view viewWithTag:Tag_timeLabel];
    timeLabel.hidden = NO;
    
    
    [self.view addSubview:_hiddenView];
    [self initBottomBtn];
    
}

//重写当前价方法
-(void)loadCurrentPriceLabel{
    UILabel *titleNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 65*ScreenHeigth/568, ScreenWidth, 20)];
    titleNameLabel.text = @"VIP快速通道设置";
    titleNameLabel.font = [UIFont systemFontOfSize:17*ScreenWidth/375];
    titleNameLabel.numberOfLines = 0;
    titleNameLabel.textColor = k_color_blueColor;
    titleNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleNameLabel];
    self.stopAndGetFrontHeight = titleNameLabel.frame.size.height+titleNameLabel.frame.origin.y+20/568.0*ScreenHeigth;
    self.otherMoneyFrontHeight = (140.0/568*ScreenHeigth + (28.0/568*ScreenHeigth) * 3 +17.0/568*ScreenHeigth);
}

-(void)explain{
    
    UILabel  *explainLabel = [[UILabel alloc]init];
    explainLabel.frame = CGRectMake(20, self.otherMoneyFrontHeight + (130.0/568*ScreenHeigth) + 40.0/568*ScreenHeigth, ScreenWidth, 60);
    explainLabel.text  = @"说明 \n1.一旦开启，点击即买 \n2.关闭以后才可重新设置，开启生效";
    explainLabel.font = [UIFont systemFontOfSize:11];
    explainLabel.textColor = [UIColor lightGrayColor];
    explainLabel.backgroundColor = [UIColor clearColor];
    explainLabel.numberOfLines = 0;
    [self.view addSubview:explainLabel];
}

- (void)initBottomBtn{
    
    [self.bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.bottomBtn setBackgroundImage:nil forState:UIControlStateNormal];
    self.bottomBtn.backgroundColor = Color_black;
    self.bottomBtn.layer.cornerRadius = 3;
    self.bottomBtn.layer.masksToBounds = YES;
    self.bottomBtn.layer.borderWidth = 1;
    self.bottomBtn.layer.borderColor = Color_Gold.CGColor;
    [self.bottomBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.bottomBtn setBackgroundImage:[UIImage imageNamed:@"color_gold_alpha0.5"] forState:UIControlStateHighlighted];
    [self.bottomBtn setTitleColor:Color_Gold forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(bottomClick:) forControlEvents:UIControlEventTouchUpInside];
    [self loadUIView];
    
    
}
- (void)loadUIView
{
    UIColor * viewColor = [[UIColor alloc] init];
    
    if (self.isOpen) {
        _hiddenView.hidden = NO;
        [self.bottomBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [self.bottomBtn setImage:nil forState:UIControlStateNormal];
        viewColor =Color_gray;
        
    }else{
    
        _hiddenView.hidden = YES;
        [self.bottomBtn setTitle:@"请开启" forState:UIControlStateNormal];
        [self.bottomBtn setImage:[UIImage imageNamed:@"lightning_gold"] forState:UIControlStateNormal];

        viewColor = Color_Gold;
        self.couPonBtn.enabled = YES;
    }
    self.oneLabel.superview.backgroundColor = viewColor;
    self.twoLabel.superview.backgroundColor = viewColor;
    UILabel * lab = (UILabel *)[self.tradeNumView viewWithTag:777+self.selectNum];
    lab.backgroundColor = viewColor;
    
    viewColor = nil;
    [self explain];
}

-(void)bottomClick:(UIButton *)btn
{
    if (self.isOpen) {
        //关闭闪电下单
        [self quickOrderClose];
        self.quickOpen(NO);

        //关闭闪电下单的同时。吧原本的值改为NO，然后把勾选按钮设置为可以点击
        self.couPonBtn.enabled = YES;
        
        [[UIEngine sharedInstance] showAlertWithTitle:@"您已成功关闭闪电下单" ButtonNumber:2 FirstButtonTitle:@"返回行情" SecondButtonTitle:@"重新设置"];
        [UIEngine sharedInstance].alertClick = ^(int aIndex){
            if (aIndex ==10086) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                self.isOpen = NO;
                [self loadUIView];
            }
        };
    }else{
        UIButton * button = (UIButton *)[self.view viewWithTag:Tag_agreeButton];
        
        if (!button.selected) {
            
            
            [[UIEngine sharedInstance] showAlertWithTitle:@"您尚未勾选《合作协议》\n勾选后方能开启" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
            [UIEngine sharedInstance].alertClick = ^(int aIndex){
                UIButton * btn = (UIButton *)[self.view viewWithTag:Tag_agreeButton];
                [self agreeBtnClick:btn];
                
            };
            return;
            
        }
        //开启闪电下单
        if ([self.oneLabel.text rangeOfString:@"选择"].location != NSNotFound || [self.twoLabel.text rangeOfString:@"选择"].location != NSNotFound) {
            [[UIEngine sharedInstance] showAlertWithTitle:@"首次下单需要选择止损、止盈额度 \n下次将会记住您的选择" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
            [UIEngine sharedInstance].alertClick = ^(int aIndex){};
        }
        else{
            [self quickOrderData:isOrderQuickCouPon];
            self.quickOpen(YES);

            [[UIEngine sharedInstance] showAlertWithTitle:@"您已成功开启闪电下单\n（试用期间免费）" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
            [UIEngine sharedInstance].alertClick = ^(int aIndex){
                [self.navigationController popViewControllerAnimated:YES];
                
            };
        }
    }
    
}

-(void)agreeBtnClick:(UIButton *)btn{
    if (btn.selected) {
        btn.selected = NO;
        
    }
    else{
        btn.selected = YES;
        
    }
    
}

#pragma mark - 重写快速下单说明文字
- (void)quickOrderText
{
    self.guide_OneImg.hidden = YES;
    self.guide_TwoImg.hidden = YES;
    self.guide_ThreeImg.hidden = YES;
    self.guideView.hidden = YES;
    
    [self orderQuickGuideView];
}

#pragma mark 获取市场交易时段

-(void)getMarketEndTime{
        UILabel *timeLabel = (UILabel *)[self.view viewWithTag:Tag_timeLabel];
        timeLabel.text = [IndexSingleControl sharedInstance].storaging;
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
