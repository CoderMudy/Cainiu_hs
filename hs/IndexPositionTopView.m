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
    
    float  spPercent = 5;
    if (ScreenHeigth <= 568 && ScreenHeigth > 480) {
        spPercent = 4.5;
    }
    else if (ScreenHeigth <= 480){
        spPercent = 4.0;
    }
    float startHeight = ScreenHeigth/spPercent ;
    float unPosiHeight = ScreenHeigth-startHeight-40;


    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, newHeight-1, ScreenWidth, 1)];
    _lineView.backgroundColor  = K_color_line;
    _lineView.hidden = YES;
    [self addSubview:_lineView];

    _goBuyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _goBuyBtn.frame = CGRectMake(0, newHeight, ScreenWidth,unPosiHeight-newHeight);
    [_goBuyBtn addTarget:self action:@selector(buyIndex) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_goBuyBtn];
    

    UILabel * remindLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/3)];
    remindLab.text = @"您暂无商品持仓";
    remindLab.textColor = Color_Gold;
    remindLab.textAlignment = NSTextAlignmentCenter;
    remindLab.font = FontSize(13);
    [_goBuyBtn addSubview:remindLab];

    
    
    UIImageView * showImgV = [[UIImageView alloc] init];
    showImgV.center  = CGPointMake(ScreenWidth/2,  CGRectGetMaxY(remindLab.frame)+20*ScreenWidth/375);
    showImgV.bounds = CGRectMake(0, 0, 280*ScreenWidth/375, 76*ScreenWidth/375);
    showImgV.image = [UIImage imageNamed:@"CashPosition_7"];
    [_goBuyBtn addSubview:showImgV];

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
                                                              
  
    
}
//
- (void)buyIndex
{
    
    self.buyBlock();
    
}
- (IndexPositionTopView*)loadUnPosiTopViewWithUserFund:(NSString *)userFund
{

    _goBuyBtn.hidden        = NO;
    _lineView.hidden        = YES;
    _priceMoreLab.hidden    = YES;
    _priceEmptyLab.hidden = YES;

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
    [self updataTopViewWithPosi:YES salePriceMore:salePriceMore salePrice:salePriceEmpty];

    return self;
}

- (IndexPositionTopView *)loadTopView:(IndexPositionData*)posiDataModel withNewPriceEmpty:(NSString*)newPriceEmpty withNewPriceMore:(NSString*)newPriceMore productModel:(FoyerProductModel*)productModel posiArray:(NSArray*)posiArray;
{

    if (posiArray.count==0) {

    }else
    {
        _goBuyBtn.hidden = YES;
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

@end
