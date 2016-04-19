//
//  CashPositonHeaderView.m
//  hs
//
//  Created by PXJ on 15/11/25.
//  Copyright © 2015年 luckin. All rights reserved.
//
#define EarnViewHeight 139*ScreenWidth/375
#define OrderViewHeight 159*ScreenWidth/375
#define control_GoBuyView 60000
#define control_KeySale 60001
#define control_SetRise 60002
#define control_GoSale 60003
#define fontText 12*ScreenWidth/375

#define buyOrSal_tag 60010
#define account_tag 60011
#define newPrice_tag 60012
#define price_tag 60013
#define consultCost_tag 60014
#define Key_DecimalPlaces _productModel.decimalPlaces.intValue
#define DecimalFloatStr(a) [Helper rangeFloatString:a withDecimalPlaces:Key_DecimalPlaces]
#define DecimalNumStr(a) [Helper rangeNumString:a withDecimalPlaces:Key_DecimalPlaces]

#define LoadProfit [self loadProfit:NO profit:0 rise:0];

#import "CashPositonHeaderView.h"
#import "CashPositionDataModel.h"


@interface CashPositonHeaderView()

@property (nonatomic,strong)UIView * noDataView;
@property (nonatomic,strong)UIView * dataView;
@property (nonatomic,strong)FoyerProductModel * productModel;
@end
@implementation CashPositonHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame model:(FoyerProductModel*)model;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.productModel = model;
        [self initUI];

    }
    return self;
}
- (void)initUI
{
    _earnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, EarnViewHeight)];
    _earnView.backgroundColor = Color_black;
    [self addSubview:_earnView];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, EarnViewHeight, ScreenWidth, 1)];
    line.backgroundColor = K_color_grayLine;
    [self addSubview:line];
    
    _orderView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_earnView.frame)+1, ScreenWidth, OrderViewHeight)];
    _orderView.backgroundColor = Color_black;
    [self addSubview:_orderView];
    
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_orderView.frame), ScreenWidth-40, 1)];
    bottomLine.backgroundColor = K_color_grayLine;
    [self addSubview:bottomLine];
    [self initEarnView];
    [self initOrderView];
}

- (void)initEarnView
{
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, ScreenWidth-40, 20*ScreenWidth/375)];
    _titleLab.text = @"浮动盈亏（元）";
    _titleLab.textColor = K_color_lightGray;
    _titleLab.font = FontSize(fontText);
    [_earnView addSubview:_titleLab];
    
    _signLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_titleLab.frame)+5, 20*ScreenWidth/375, 20*ScreenWidth/375)];
    _signLab.font = [UIFont systemFontOfSize:20*ScreenWidth/375];
    [_earnView addSubview:_signLab];
    
    _earnLab = [[UILabel alloc] initWithFrame:CGRectMake(35, CGRectGetMaxY(_titleLab.frame), ScreenWidth-55, 45*ScreenWidth/375)];
    _earnLab.textColor = K_color_red;
    _earnLab.font = FontSize(39);
    [_earnView addSubview:_earnLab];
    
    _riseLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_earnLab.frame), ScreenWidth-40, 20*ScreenWidth/375)];
    _riseLab.font = FontSize(18*ScreenWidth/375);
    [_earnView addSubview:_riseLab];

    _signLab.text = @"+";
    _signLab.textColor = K_color_red;
//    _earnLab.text = @"0.00";
    _earnLab.textColor = K_color_red;
    _riseLab.hidden = YES;
}
- (void)initOrderView
{
    _noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, OrderViewHeight)];
    _noDataView.backgroundColor = Color_black;
    _noDataView.hidden = NO;
    [_orderView addSubview:_noDataView];
    
    UILabel * remindLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50*ScreenWidth/375)];
    remindLab.text = @"您暂无商品持仓";
    remindLab.textColor = Color_Gold;
    remindLab.textAlignment = NSTextAlignmentCenter;
    remindLab.font = FontSize(13);
    [_noDataView addSubview:remindLab];
    
    UIImageView * showImgV = [[UIImageView alloc] init];
    showImgV.center  = CGPointMake(ScreenWidth/2, CGRectGetMaxY(remindLab.frame)+38*ScreenWidth/375);
    showImgV.bounds = CGRectMake(0, 0, 280*ScreenWidth/375, 76*ScreenWidth/375);
    showImgV.image = [UIImage imageNamed:@"CashPosition_7"];
    [_noDataView addSubview:showImgV];
    
    UIControl * control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, OrderViewHeight)];
    control.tag = control_GoBuyView;
    [control addTarget:self action:@selector(ControlClick:) forControlEvents:UIControlEventTouchUpInside];
    [_noDataView addSubview:control];

    _dataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, OrderViewHeight)];
    _dataView.backgroundColor = Color_black;
    _dataView.hidden = YES;
    [_orderView addSubview:_dataView];
    
    UILabel * buyOrSalLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 17*ScreenWidth/375, 16*ScreenWidth/375, 15*ScreenWidth/375)];
    UILabel * nameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(buyOrSalLab.frame)+5, 17*ScreenWidth/375, ScreenWidth/2, 15*ScreenWidth/375)];
    
    UILabel * accountLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(buyOrSalLab.frame)+5, (ScreenWidth-40)/3, 20*ScreenWidth/375)];
    UILabel * newPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accountLab.frame)+5,CGRectGetMinY(accountLab.frame), (ScreenWidth-40)/3, 20*ScreenWidth/375)];
    UILabel * posiPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(accountLab.frame), (ScreenWidth-40)/3, 20*ScreenWidth/375)];
    UILabel * safePriceLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(posiPriceLab.frame)+5, CGRectGetMinY(posiPriceLab.frame), (ScreenWidth-40)/3, 20*ScreenWidth/375)];
    
    [_dataView addSubview:buyOrSalLab];
    [_dataView addSubview:nameLab];
    [_dataView addSubview:accountLab];
    [_dataView addSubview:newPriceLab];
    [_dataView addSubview:posiPriceLab];
    [_dataView addSubview:safePriceLab];
    
    buyOrSalLab.font = nameLab.font = accountLab.font = newPriceLab.font = posiPriceLab.font = safePriceLab.font = FontSize(fontText);
    buyOrSalLab.backgroundColor = K_color_red;
    buyOrSalLab.textAlignment = NSTextAlignmentCenter;
    nameLab.text = self.productModel.commodityName;
    
    buyOrSalLab.tag = buyOrSal_tag;
    accountLab.tag = account_tag;
    newPriceLab.tag = newPrice_tag;
    posiPriceLab.tag = price_tag;
    safePriceLab.tag = consultCost_tag;
    
    buyOrSalLab.textColor = [UIColor whiteColor];
    nameLab.textColor = accountLab.textColor = posiPriceLab.textColor = newPriceLab.textColor = posiPriceLab.textColor = safePriceLab.textColor = K_color_lightGray;
    
    UIImageView * keSaleImgV = [[UIImageView alloc] init];
    keSaleImgV.center = CGPointMake((ScreenWidth-50*ScreenWidth/375), 50*ScreenWidth/375);
    keSaleImgV.bounds = CGRectMake(0, 0, 55*ScreenWidth/375, 55*ScreenWidth/375);
    keSaleImgV.image = [UIImage imageNamed:@"CashPosition_8"];
    [_dataView addSubview:keSaleImgV];
    
    UIButton * keySaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    keySaleBtn.center = keSaleImgV.center;
    keySaleBtn.bounds = CGRectMake(0, 0, 55*ScreenWidth/375, 55*ScreenWidth/375);
    keySaleBtn.tag = control_KeySale;
    [keySaleBtn addTarget:self action:@selector(ControlClick:) forControlEvents:UIControlEventTouchUpInside];
    [_dataView addSubview:keySaleBtn];
    
    UIButton * setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(20, CGRectGetMaxY(posiPriceLab.frame)+20*ScreenWidth/375, (ScreenWidth-50)/2, 40*ScreenWidth/375);
    setBtn.layer.cornerRadius = 3;
    setBtn.layer.masksToBounds = YES;
    setBtn.layer.borderColor = Color_Gold.CGColor;
    setBtn.layer.borderWidth = 1;
    setBtn.tag = control_SetRise;
    [setBtn setTitle:@"止盈止损" forState:UIControlStateNormal];
    [setBtn setTitleColor:Color_Gold forState:UIControlStateNormal];
    [setBtn.titleLabel setFont:FontSize(14)];
    [setBtn addTarget:self action:@selector(ControlClick:) forControlEvents:UIControlEventTouchUpInside];
    [_dataView addSubview:setBtn];
    
    UIButton * saleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saleBtn.frame = CGRectMake(CGRectGetMaxX(setBtn.frame)+10, CGRectGetMinY(setBtn.frame), (ScreenWidth-50)/2, 40*ScreenWidth/375);
    saleBtn.layer.cornerRadius = 5;
    saleBtn.layer.masksToBounds = YES;
    saleBtn.layer.borderColor = Color_Gold.CGColor;
    saleBtn.layer.borderWidth = 1;
    saleBtn.tag = control_GoSale;
    [saleBtn setTitle:@"平仓" forState:UIControlStateNormal];
    [saleBtn setTitleColor:Color_Gold forState:UIControlStateNormal];
    [saleBtn.titleLabel setFont:FontSize(14)];
    [saleBtn addTarget:self action:@selector(ControlClick:) forControlEvents:UIControlEventTouchUpInside];
    [_dataView addSubview:saleBtn];
}
- (void)ControlClick:(UIButton *)button
{
    self.clickBlock(button);
}
- (void)reloadCashPositionData:(CashPositionDataModel*)model ;
{
    UILabel * buyOrSalLab = (UILabel *)[_dataView viewWithTag:buyOrSal_tag];
    UILabel * accountLab = (UILabel *)[_dataView viewWithTag:account_tag];
    UILabel * newPriceLab = (UILabel *)[_dataView viewWithTag:newPrice_tag];
    UILabel * posiPriceLab = (UILabel *)[_dataView viewWithTag:price_tag];
    UILabel * safePriceLab = (UILabel *)[_dataView viewWithTag:consultCost_tag];
    if (model.account&&model.account.intValue>0)
    {
        _noDataView.hidden = YES;
        _dataView.hidden = NO;
        accountLab.text = [NSString stringWithFormat:@"持仓数量 %d手",model.account.intValue];
        newPriceLab.text = [NSString stringWithFormat:@"最新价 %@元",DecimalNumStr(model.newprice)];
        posiPriceLab.text = [NSString stringWithFormat:@"持仓均价 %@元",DecimalNumStr(model.price)];
        safePriceLab.text = [NSString stringWithFormat:@"保本价 %@元",DecimalNumStr(model.consultCost)];
        if ([model.buyOrSal isEqualToString:@"B"])
        {
            buyOrSalLab.text = @"多";
            buyOrSalLab.backgroundColor = K_color_red;
        }else
        {
            buyOrSalLab.text = @"空";
            buyOrSalLab.backgroundColor = K_color_green;
        }
    }else
    {

        [self cashViewLoadPushData:NO profitStr:nil riseStr:nil sign:nil profitColor:nil];
        _noDataView.hidden = NO;
        _dataView.hidden = YES;
        
    }
}


- (void)cashViewLoadPushData:(BOOL)isPosition
                    profitStr:(NSString*)profitStr
                      riseStr:(NSString*)riseStr
                         sign:(NSString*)sign
                  profitColor:(UIColor*)profitColor;
{
    if (isPosition)
    {
        _signLab.text = sign;
        _earnLab.text = profitStr;
        _riseLab.text = riseStr;
        _riseLab.textColor = _earnLab.textColor = _signLab.textColor = profitColor;
        _riseLab.hidden = NO;
    }else
    {
        _signLab.text = @"+";
        _earnLab.text = @"0.00";
        _earnLab.textColor = _signLab.textColor = K_color_red;
        _riseLab.hidden = YES;
    }
}
@end
