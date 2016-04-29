//
//  IndexPositionTopView.m
//  hs
//
//  Created by PXJ on 15/7/29.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "IndexPositionTopView.h"
#import "IndexPositionDataModels.h"
#import "FoyerProductModel.h"
#import "HandlePosiData.h"
#define textFont 13
#define keySale_minNum 2
#define saleBtnLength ScreenWidth * 60/375
#define newHeight 40*ScreenWidth/375
@interface IndexPositionTopView()
@property (nonatomic,strong)FoyerProductModel*productModel;
@end
@implementation IndexPositionTopView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (id)initWithFrame:(CGRect)frame withItemProductModel:(FoyerProductModel*)productModel
{
    self = [super initWithFrame:frame];
    if (self) {
        _productModel = productModel;
        [self initPositionViewState:productModel.commodityName];
    }
    return self;
}


//初始化持仓header视图
- (void)initPositionViewState:(NSString *)commodityName
{
    
//    float height = ScreenWidth*3/8;
//    _titleLab  = [[UILabel alloc] init];
//    _titleLab.center = CGPointMake(ScreenWidth/2, 25*ScreenWidth/375);
//    _titleLab.bounds = CGRectMake(0, 0, ScreenWidth-40, 20);
//    _titleLab.textAlignment = NSTextAlignmentLeft;
//    _titleLab.font = FontSize(12);
//    _titleLab.textColor = K_color_gray;
//    _titleLab.text = [NSString stringWithFormat:@"持仓总收益（%@）",[_productModel.loddyType isEqualToString:@"1"]?_productModel.currencyUnit:@"积分"];
//    [self addSubview:_titleLab];
    
//    //可用余额／持仓现金收益
//    _cashProfitLab = [[UILabel alloc] init];
//    _cashProfitLab.text = @"0";
//    _cashProfitLab.center = CGPointMake(ScreenWidth/2+10, 60*ScreenWidth/375);
//    _cashProfitLab.bounds = CGRectMake(0, 0, ScreenWidth-40, 60);
//    _cashProfitLab.font = [UIFont systemFontOfSize:height/3];
//    _cashProfitLab.textColor = K_color_red;
//    [self addSubview:_cashProfitLab];
//
//    _signLab = [[UILabel alloc] initWithFrame:CGRectMake(20, _cashProfitLab.frame.origin.y+5, 20, 20)];
//    _signLab.text = @"+";
//    _signLab.font = [UIFont systemFontOfSize:20];
//    _signLab.hidden = NO;
//    _signLab.textColor = K_color_red;
//    [self addSubview:_signLab];
//
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, newHeight-1, ScreenWidth, 1)];
    _lineView.backgroundColor  = K_color_line;
    [self addSubview:_lineView];
//
    _goBuyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _goBuyBtn.frame = CGRectMake(0, newHeight, ScreenWidth, ScreenHeigth-64-newHeight);
    [_goBuyBtn addTarget:self action:@selector(buyIndex) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_goBuyBtn];
    
    
    UIImageView * goBuyBtnImage = [[UIImageView alloc] init];
    goBuyBtnImage.center = CGPointMake(ScreenWidth/2, ScreenWidth/3);
    goBuyBtnImage.bounds = CGRectMake(0, 0, ScreenWidth/7, ScreenWidth*43/(7*50));
    goBuyBtnImage.image = [UIImage imageNamed:@"Icon_16"];
    [_goBuyBtn addSubview:goBuyBtnImage];
//
    UILabel * goBuyLab = [[UILabel alloc] initWithFrame:CGRectMake(0, goBuyBtnImage.frame.origin.y+goBuyBtnImage.frame.size.height+10, ScreenWidth, 15)];
    NSString * goState = commodityName;
//
    goBuyLab.text = [NSString stringWithFormat:@"尚未购买订单，点击%@买入",goState];
    goBuyLab.textAlignment = NSTextAlignmentCenter;
    goBuyLab.textColor = Color_Gold;
    goBuyLab.font = [UIFont systemFontOfSize:12];
    [_goBuyBtn addSubview:goBuyLab];
    
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~ 平仓价UILabel ～～～～～～～～～～～～～～～～  */
    
    _priceMoreLab               = [[UILabel alloc] initWithFrame:CGRectMake(20, newHeight-25, 80, 20)];
    _priceMoreLab.text          = @"平多价";
    _priceMoreLab.hidden        = YES;
    _priceMoreLab.textColor     = K_color_red;
    _priceMoreLab.font          = [UIFont boldSystemFontOfSize:10];
    [self addSubview:_priceMoreLab];
    
    _priceEmptyLab              = [[UILabel alloc] initWithFrame:CGRectMake(_priceMoreLab.frame.size.width+_priceMoreLab.frame.origin.x, newHeight-25 , 80, 20)];
    _priceEmptyLab.text         = @"平空价";
    _priceEmptyLab.hidden       = YES;
    _priceEmptyLab.textColor    = K_color_green;
    _priceEmptyLab.font         = [UIFont boldSystemFontOfSize:10];
    [self addSubview:_priceEmptyLab];
                                                              
//    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~ 一键平仓Button ～～～～～～～～～～～～～～～～  */
//
//    //一键平多
//    _saleMoreBtn                = [UIButton buttonWithType:UIButtonTypeCustom];
//    _saleMoreBtn.hidden         = YES;
//    _saleMoreBtn.tag            = 1000001;
//    _saleMoreBtn.bounds         = CGRectMake(0, 0, saleBtnLength, saleBtnLength);
//    _saleMoreBtn.center         = CGPointMake(ScreenWidth-20-saleBtnLength*3/2-10, newHeight-10-saleBtnLength/2);
//    [_saleMoreBtn setImage:[UIImage imageNamed:@"yjpd"] forState:UIControlStateNormal];
//    [_saleMoreBtn addTarget:self action:@selector(akeySaleClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_saleMoreBtn];
//    //一键平空
//    _saleEmptyBtn               = [UIButton buttonWithType:UIButtonTypeCustom];
//    _saleEmptyBtn.hidden        = YES;
//    _saleEmptyBtn.tag           = 1000002;
//    _saleEmptyBtn.bounds        = CGRectMake(0, 0, saleBtnLength,saleBtnLength);
//    _saleEmptyBtn.center        = CGPointMake(ScreenWidth-20-saleBtnLength/2, newHeight-10-saleBtnLength/2);
//    [_saleEmptyBtn setImage:[UIImage imageNamed:@"yjpk"] forState:UIControlStateNormal];
//    [_saleEmptyBtn addTarget:self action:@selector(akeySaleClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_saleEmptyBtn];
//    
    
    
}
//
- (void)buyIndex
{
    
    self.buyBlock();
    
}
- (IndexPositionTopView*)loadUnPosiTopViewWithUserFund:(NSString *)userFund
{
//    NSString * headerTitleText;
//    if ([_productModel.loddyType isEqualToString:@"1"]) {
//        headerTitleText = [NSString stringWithFormat:@"可用余额（元）"];
//    }else{
//        headerTitleText = [NSString stringWithFormat:@"可用余额（积分）"];
//    }
//    
//
//    _saleEmptyBtn.hidden    = YES;
//    _saleMoreBtn.hidden     = YES;
//    _signLab.hidden         = YES;
    _goBuyBtn.hidden        = NO;
    _lineView.hidden        = YES;
    _priceMoreLab.hidden    = YES;
    _priceEmptyLab.hidden = YES;
//    _cashProfitLab.frame =CGRectMake(20, _titleLab.frame.size.height+_titleLab.frame.origin.y, ScreenWidth, ScreenWidth/8);
//    _cashProfitLab.text = userFund;
//    _cashProfitLab.textColor = Color_Gold;
//    _titleLab.text = headerTitleText;
//
    return self;
}
- (IndexPositionTopView*)loadPosiTopViewWithProfit:(NSString *)profitStr
                                         textColor:(UIColor *)textColor
                                      keySaleStyle:(NSInteger)keSaleStyle
                                              sign:(NSString*)sign
                                     salePriceMore:(NSString *)salePriceMore
                                         salePrice:(NSString*)salePriceEmpty
{
    _goBuyBtn.hidden = YES;
//    _signLab.hidden = NO;
//    _titleLab.text = [NSString stringWithFormat:@"持仓总收益（%@）",_productModel.currencyUnit];
//    switch (keSaleStyle)
//    {
//        case 0:
//        {
//            _saleMoreBtn.hidden     = YES;
//            _saleEmptyBtn.hidden    = YES;
//        }
//            break;
//        case 1:
//        {
//            _saleMoreBtn.center     = CGPointMake(ScreenWidth-20-saleBtnLength/2, newHeight-10-saleBtnLength/2);
//            _saleMoreBtn.hidden     = NO;
//            _saleEmptyBtn.hidden    = YES;
//        }
//            break;
//        case 2:
//        {
//            _saleEmptyBtn.center    = CGPointMake(ScreenWidth-20-saleBtnLength/2, newHeight-10-saleBtnLength/2);
//            _saleEmptyBtn.hidden    = NO;
//            _saleMoreBtn.hidden     = YES;
//        }
//            break;
//        case 3:
//        {
//            _saleEmptyBtn.center    = CGPointMake(ScreenWidth-20-saleBtnLength/2, newHeight-10-saleBtnLength/2);
//            _saleMoreBtn.center     = CGPointMake(ScreenWidth-20-saleBtnLength*3/2-10, newHeight-10-saleBtnLength/2);
//            _saleEmptyBtn.hidden    = NO;
//            _saleMoreBtn.hidden     = NO;
//        }
//            break;
//        default:
//            break;
//    }
//    _signLab.text = sign;
//    _signLab.textColor = _cashProfitLab.textColor = textColor;
//    NSString * scoreUnit = @"";
//    if (![_productModel.loddyType isEqualToString:@"1"]) {
//        scoreUnit = @"积分";
//    }
//    profitStr = [NSString stringWithFormat:@"%@%@",profitStr,scoreUnit];
//    _cashProfitLab.attributedText = [Helper mutableFontAndColorText:profitStr from:(int)profitStr.length-(int)scoreUnit.length to:(int)scoreUnit.length font:12 from:(int)profitStr.length-(int)scoreUnit.length to:(int)scoreUnit.length color:K_color_gray];
//    _cashProfitLab.frame =CGRectMake(30, _titleLab.frame.size.height+_titleLab.frame.origin.y, ScreenWidth, ScreenWidth/8);
    [self updataTopViewWithPosi:YES salePriceMore:salePriceMore salePrice:salePriceEmpty];

    return self;
}

- (IndexPositionTopView *)loadTopView:(IndexPositionData*)posiDataModel withNewPriceEmpty:(NSString*)newPriceEmpty withNewPriceMore:(NSString*)newPriceMore productModel:(FoyerProductModel*)productModel posiArray:(NSArray*)posiArray;
{
    
    NSString * headerTitleText;
    NSAttributedString * cushText= [[NSAttributedString alloc] init];
    NSAttributedString * scoreText= [[NSAttributedString alloc] init];
    NSString * unit;//单位1:元／美元
    unit = productModel.currencyUnit;
    
    if (posiArray.count==0) {
//        _saleEmptyBtn.hidden    = YES;
//        _saleMoreBtn.hidden     = YES;
//        _signLab.hidden         = YES;
        _goBuyBtn.hidden        = NO;
        _lineView.hidden        = YES;
        _priceMoreLab.hidden    = YES;
        _priceEmptyLab.hidden = YES;
//        _cashProfitLab.frame =CGRectMake(20, _titleLab.frame.size.height+_titleLab.frame.origin.y, ScreenWidth, ScreenWidth/8);
//        NSString * usedAmt;
//        if ([posiDataModel.usedAmt floatValue]>=100000||[posiDataModel.usedAmt floatValue]<=-100000) {
//            usedAmt = [NSString stringWithFormat:@"%f",posiDataModel.usedAmt.floatValue/10000];
//            usedAmt = [usedAmt substringToIndex:usedAmt.length-4];
//            usedAmt = [DataEngine addSign:usedAmt];
//            usedAmt = [NSString stringWithFormat:@"%@万",usedAmt];
//        }else
//        {
//            usedAmt = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[posiDataModel.usedAmt floatValue]]];
//            usedAmt = [NSString stringWithFormat:@"%@",usedAmt];
//        }
//        
//        NSString * score = [DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%d",[posiDataModel.score intValue]]];
//        score = [NSString stringWithFormat:@"%@",score];
//        
//        cushText = [Helper multiplicityText:usedAmt from:0 to:(int)usedAmt.length color:Color_Gold];
//        scoreText = [Helper multiplicityText:score from:0 to:(int)score.length color:Color_Gold];
//        if ([productModel.loddyType isEqualToString:@"1"]) {
//            headerTitleText = [NSString stringWithFormat:@"可用余额（元）"];
//            _cashProfitLab.attributedText = cushText;
//        }else{
//            headerTitleText = [NSString stringWithFormat:@"可用余额（积分）"];
//            _cashProfitLab.attributedText = scoreText;
//        }
//        
//        _titleLab.text = headerTitleText;
//        return self;
    }else
    {
        _goBuyBtn.hidden = YES;
//        _signLab.hidden = NO;
//        headerTitleText = [NSString stringWithFormat:@"持仓总收益（%@）",unit];
//
//        
//        [HandlePosiData handlePosiHeaderDataWithModel:productModel posiArray:posiArray emptyPrice:newPriceEmpty morePrice:newPriceMore completion:^(BOOL isposi, NSString *profitStr, UIColor *textColor, NSInteger keSaleStyle, NSString *sign)
//         {
//             switch (keSaleStyle)
//             {
//                 case 0:
//                 {
//                     _saleMoreBtn.hidden     = YES;
//                     _saleEmptyBtn.hidden    = YES;
//                 }
//                     break;
//                 case 1:
//                 {
//                     _saleMoreBtn.center     = CGPointMake(ScreenWidth-20-saleBtnLength/2, newHeight-10-saleBtnLength/2);
//                     _saleMoreBtn.hidden     = NO;
//                     _saleEmptyBtn.hidden    = YES;
//                 }
//                     break;
//                 case 2:
//                 {
//                     _saleEmptyBtn.center    = CGPointMake(ScreenWidth-20-saleBtnLength/2, newHeight-10-saleBtnLength/2);
//                     _saleEmptyBtn.hidden    = NO;
//                     _saleMoreBtn.hidden     = YES;
//                 }
//                     break;
//                 case 3:
//                 {
//                     _saleEmptyBtn.center    = CGPointMake(ScreenWidth-20-saleBtnLength/2, newHeight-10-saleBtnLength/2);
//                     _saleMoreBtn.center     = CGPointMake(ScreenWidth-20-saleBtnLength*3/2-10, newHeight-10-saleBtnLength/2);
//                     _saleEmptyBtn.hidden    = NO;
//                     _saleMoreBtn.hidden     = NO;
//                 }
//                     break;
//                 default:
//                     break;
//             }
//             _signLab.text = sign;
//             _signLab.textColor = _cashProfitLab.textColor = textColor;
//             NSString * scoreUnit = @"";
//             if (![productModel.loddyType isEqualToString:@"1"]) {
//                 scoreUnit = @"积分";
//             }
//             profitStr = [NSString stringWithFormat:@"%@%@",profitStr,scoreUnit];
//             _cashProfitLab.attributedText = [Helper mutableFontAndColorText:profitStr from:profitStr.length-scoreUnit.length to:scoreUnit.length font:12 from:profitStr.length-scoreUnit.length to:scoreUnit.length color:K_color_gray];
//            _cashProfitLab.frame =CGRectMake(30, _titleLab.frame.size.height+_titleLab.frame.origin.y, ScreenWidth, ScreenWidth/8);
//         }];
//
//        _titleLab.text = headerTitleText;
        [self updataTopViewWithPosi:YES salePriceMore:newPriceMore salePrice:newPriceEmpty];
       
    }
    return self;
}

- (void)updataTopViewWithPosi:(BOOL)isPosi salePriceMore:(NSString *)salePriceMore salePrice:(NSString*)salePriceEmpty
{
    
    NSString * priceMore    = salePriceMore ==nil?@"0.00":salePriceMore;
    NSString * priceEmpty   = salePriceEmpty==nil?@"0.00":salePriceEmpty;
    BOOL hidden;
    if (!isPosi) {
    
        hidden  = YES;
    }else{
    
        hidden  = NO;
        switch (_productModel.decimalPlaces.intValue) {
            case 0:
            {
            
                self.priceEmptyLab.text = [NSString stringWithFormat:@"平空价%.0f",priceEmpty.floatValue];
                self.priceMoreLab.text  = [NSString stringWithFormat:@"平多价%.0f",priceMore.floatValue];
            }
                break;
            case 1:
            {
                self.priceEmptyLab.text = [NSString stringWithFormat:@"平空价%.1f",priceEmpty.floatValue];
                self.priceMoreLab.text  = [NSString stringWithFormat:@"平多价%.1f",priceMore.floatValue];
            }
                break;
            case 2:
            {
                self.priceEmptyLab.text = [NSString stringWithFormat:@"平空价%.2f",priceEmpty.floatValue];
                self.priceMoreLab.text  = [NSString stringWithFormat:@"平多价%.2f",priceMore.floatValue];
            }
                break;
                
            default:
                break;
        }
    }
    self.priceEmptyLab.hidden   = hidden;
    self.priceMoreLab.hidden    = hidden;
    self.lineView.hidden        = hidden;
}
- (void)akeySaleClick:(UIButton *)button
{
    self.aKeySaleBlock(button);
}
@end
