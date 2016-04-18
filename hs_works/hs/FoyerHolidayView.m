//
//  FoyerHolidayView.m
//  hs
//
//  Created by PXJ on 16/1/4.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "FoyerHolidayView.h"

#define viewHeight self.frame.size.height
#define viewWidth self.frame.size.width
#define holiday_yellowColor  K_COLOR_CUSTEM(233, 153, 14, 1)


@implementation FoyerHolidayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame style:(FoyerHolidayViewStyle)style
{
    self=[super initWithFrame:frame];
    if (self) {
        self.style = style;

        [self initUI];
        
     }
    return self;
}
- (void)initUI
{
    switch (self.style) {
        case FoyerHolidayPopViewStyle:
        {
            
            UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
            backView.backgroundColor = K_COLOR_CUSTEM(0, 0, 0, 0.5);
            backView.userInteractionEnabled = NO;
            [self addSubview:backView];
            
            CGFloat showWidth = 290*ScreenWidth/375;
            CGFloat showHeight = 200*ScreenWidth/375;
            
            UIView * showView = [[UIView alloc] init];
            showView.center = CGPointMake(ScreenWidth/2, ScreenHeigth/2);
            showView.bounds = CGRectMake(0, 0, showWidth, showHeight);
            showView.layer.borderWidth = 2;
            showView.layer.borderColor = K_color_red.CGColor;
            showView.layer.cornerRadius  = 10;
            showView.layer.masksToBounds = YES;
            [self addSubview:showView];
            
            showView.backgroundColor = K_color_Purple;
            UILabel * showText = [[UILabel alloc] init];
            showText.center = CGPointMake(showWidth/2, showHeight*2/5);
            showText.bounds = CGRectMake(0, 0, showWidth-20, 20);
            showText.text = @"娱乐场只在节假日期间开放哦";
            showText.font = FontSize(16);
            showText.textColor = [UIColor whiteColor];
            showText.textAlignment = NSTextAlignmentCenter;
            [showView addSubview:showText];
            UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            confirmBtn.center = CGPointMake(showWidth/2, showHeight*4/5);
            confirmBtn.bounds = CGRectMake(0, 0, showWidth-50, 35);
            confirmBtn.backgroundColor = K_color_red;
            confirmBtn.layer.cornerRadius = 5;
            confirmBtn.layer.masksToBounds = YES;
            [confirmBtn.titleLabel setFont:FontSize(15)];
            [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
            [confirmBtn setTintColor:[UIColor whiteColor]];
            [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [showView addSubview:confirmBtn];
        }
            break;
        case FoyerHolidayProductStyle:
        {
            self.layer.borderWidth = 2;
            self.layer.borderColor = K_COLOR_CUSTEM(196, 55, 55, 1).CGColor;
            self.layer.cornerRadius  = 10;
            self.layer.masksToBounds = YES;
            self.backgroundColor = [UIColor whiteColor];
            _productImg = [[UIImageView alloc] init];
            _productImg.center = CGPointMake(viewWidth/2, 48*ScreenWidth/375);
            _productImg.bounds = CGRectMake(0, 0, 50*ScreenWidth/375, 50*ScreenWidth/375);
            _productImg.image = [UIImage imageNamed:@"foyer_12"];
            [self addSubview:_productImg];
            
            _productName = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_productImg.frame), viewWidth, 26*ScreenWidth/375)];
            _productName.text = @"尚未开始";
            _productName.textAlignment = NSTextAlignmentCenter;
            _productName.font = FontSize(15);
            [self addSubview:_productName];
            CGFloat showWidth = [Helper calculateTheHightOfText:@"历史数据模拟" height:15 font:FontSize(8)];
            UILabel * showLab = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth/2-showWidth/2-5*ScreenWidth/375, CGRectGetMaxY(_productName.frame), showWidth+10*ScreenWidth/375, 15*ScreenWidth/375)];
            showLab.textAlignment = NSTextAlignmentCenter;
            showLab.textColor = holiday_yellowColor;
            showLab.text = @"历史数据模拟";
            showLab.font = FontSize(8);
            showLab.layer.cornerRadius = 3;
            showLab.layer.masksToBounds = YES;
            showLab.layer.borderWidth = 1;
            showLab.layer.borderColor = holiday_yellowColor.CGColor;
            [self addSubview:showLab];
            
            _price = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(showLab.frame)+5*ScreenWidth/375, viewWidth-40, 25*ScreenWidth/375)];
            _price.text = @"--";
            _price.textColor = K_color_red;
            _price.textAlignment = NSTextAlignmentCenter;
            _price.font = FontSize(20);
            [self addSubview:_price];
            
            _rise  = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_price.frame), viewWidth-40, 15*ScreenWidth/375)];
            _rise.text = @"-- --%";
            _rise.textColor = K_color_red;
            _rise.textAlignment = NSTextAlignmentCenter;
            _rise.font = FontSize(15);
            [self addSubview:_rise];
            
            _goTrade = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
            [self addSubview:_goTrade];
            _positionImg = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-50*ScreenWidth/375, 0, 50*ScreenWidth/375, 44*ScreenWidth/375)];
            _positionImg.hidden = YES;
            _positionImg.image = [UIImage imageNamed:@"foyer_16"];
            [self addSubview:_positionImg];
        }
            break;
        case FoyerHolidayWarningStyle:{
            CGFloat backWidth = ScreenWidth-20;
            CGFloat backHeight = backWidth*1159/1113;
            
            UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
            backView.backgroundColor = K_COLOR_CUSTEM(0, 0, 0, 0.7);
            [self addSubview:backView];
            
            UIImageView * backImgV = [[UIImageView alloc]init];
            backImgV.center = CGPointMake(ScreenWidth/2, ScreenHeigth*270/735 +64);
            backImgV.bounds = CGRectMake(0, 0, backWidth, backHeight);
            backImgV.image = [UIImage imageNamed:@"foyer_hol_back"];
            backImgV.userInteractionEnabled = YES;
            [self addSubview:backImgV];
            
            UIButton * exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            exitBtn.center = CGPointMake(backWidth*285/342, backHeight*87/352);
            exitBtn.bounds = CGRectMake(0, 0, 30*ScreenWidth/414, 30*ScreenWidth/414);
            [exitBtn setBackgroundImage:[UIImage imageNamed:@"foyer_hol_exit"] forState:UIControlStateNormal];
            [exitBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [backImgV addSubview:exitBtn];
            
            UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            confirmBtn.center = CGPointMake(backWidth/2, backHeight*315/352);
            confirmBtn.bounds = CGRectMake(0, 0, 222*ScreenWidth/414, 39*ScreenWidth/414);
            [confirmBtn.titleLabel setFont:FontSize(15)];
            [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
            [confirmBtn setBackgroundImage:[UIImage imageNamed:@"foyer_hol_btn"] forState:UIControlStateNormal];
            [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [backImgV addSubview:confirmBtn];
            NSArray * textArray = @[@"娱乐场品种行情均为真实历史数据模拟盘！仅供娱乐！",@"仅支持积分交易！",@"仅周末及节假日开放！",[NSString stringWithFormat:@"最终解释权归%@所有！",App_appShortName]];
            CGFloat white_Y = 150*ScreenWidth/414;
            CGFloat white_X = 65*ScreenWidth/414;
            
            for (int i=0; i<textArray.count; i++) {
                UIFont * textFont = FontSize(15*ScreenWidth/414);
                
                UIImageView * star = [[UIImageView alloc] initWithFrame:CGRectMake(white_X, white_Y+5, 15*ScreenWidth/414, 14*ScreenWidth/414)];
                star.image = [UIImage imageNamed:@"foyer_hol_star"];
                [backImgV addSubview:star];
                
                CGSize  textSize = [Helper sizeWithText:textArray[i] font:textFont maxSize:CGSizeMake(230*ScreenWidth/414, 0)];
                UILabel * showTextLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(star.frame)+5, white_Y, textSize.width+5, textSize.height+5)];
                showTextLab.numberOfLines = 0;
                showTextLab.text = textArray[i];
                showTextLab.font = textFont;
                [backImgV addSubview:showTextLab];
                white_Y += textSize.height+20*ScreenWidth/414;
            }
        }
            break;
        default:
            break;
    }
}
- (void)controlClick
{

}
- (void)confirmBtnClick
{
    [self removeFromSuperview];
}
@end
