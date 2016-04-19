//
//  Alert.m
//  hs
//
//  Created by RGZ on 15/12/17.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "Alert.h"
#import "IndexOrderChooseView.h"

@implementation Alert
{
    UIView  *_coverView;
    UIView  *_alertView;
    UILabel *_linelab;
    
    int     buttonNum;
    int     font;
    
    NSString    *firstTitle;
    NSString    *secondTitle;
    
    NSString    *message;
    
    AlertType   alertType;
    AlertErrorType  alertErrorTyle;
    NSString        *errorMessage;
    NSString        *errorMoney;
    NSString        *errorIntegral;
    NSString        *errorMoneyUnit;
    NSString        *errorTitleMessage;
}

-(instancetype)initWithButtonNum:(int)aButtonNum
                      FirstTitle:(NSString *)aFirstTitle
                     SecondTitle:(NSString *)aSecondTitle
                         Message:(NSString *)aMessage
                       AlertType:(AlertType)aAlertTyle
                  AlertErrorType:(AlertErrorType)anAlertErrorType//行情异常所需
               ErrorTitleMessage:(NSString *)aErrorTitleMessage//行情异常标题信息
                    ErrorMessage:(NSString *)aErrorMessage//行情异常信息
                      ErrorMoney:(NSString *)aErrorMoney//行情异常金额
                   ErrorIntegral:(NSString *)aErrorIntegral//行情异常积分
                  ErrorMoneyUnit:(NSString *)aErrorMoneyUnit//行情异常金额单位（元，美元）
{
    self = [super init];
    if (self) {
        self.backgroundColor    = [UIColor clearColor];
        self.frame              = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
        buttonNum               = aButtonNum;
        firstTitle              = aFirstTitle;
        secondTitle             = aSecondTitle;
        message                 = aMessage;
        alertType               = aAlertTyle;
        alertErrorTyle          = anAlertErrorType;
        errorMessage            = aErrorMessage;
        errorMoney              = aErrorMoney;
        errorIntegral           = aErrorIntegral;
        errorMoneyUnit          = aErrorMoneyUnit;
        errorTitleMessage       = aErrorTitleMessage;
        
        [self fontConfiger];
        [self loadUI];
        switch (alertType) {
            case AlertCommon:
                [self commonAlert];
                break;
            case AlertError:
                [self errorAlert];
                break;
            case AlertDelegateOrderMore:
                [self delegateOrderMore];
                break;
            case AlertDelegateOrderLess:
                [self delegateOrderLess];
                break;
            default:
                break;
        }
    }
    
    return self;
}

-(void)loadUI{
    
    
    _coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
    _coverView.backgroundColor=[UIColor blackColor];
    _coverView.alpha=0.7;
    [self addSubview:_coverView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keybordDown)];
    [_coverView addGestureRecognizer:tap];
    
    _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _coverView.bounds.size.width-60, ScreenHeigth/4-5-40)];
    _alertView.center=CGPointMake(ScreenWidth/2, ScreenHeigth/2-30);
    _alertView.backgroundColor = [UIColor whiteColor];
    _alertView.layer.cornerRadius = 8;
    _alertView.alpha=1;
    _alertView.layer.masksToBounds = YES;
    
    _linelab = [[UILabel alloc] initWithFrame:CGRectMake(0, _alertView.frame.size.height+_alertView.frame.origin.y-20, _alertView.bounds.size.width, 20+40)];
    _linelab.center = CGPointMake(ScreenWidth/2, _linelab.center.y);
    _linelab.backgroundColor = AlertColor;
    _linelab.layer.cornerRadius = 8;
    _linelab.clipsToBounds = YES;
    _linelab.userInteractionEnabled = YES;
    [self addSubview:_linelab];
    
    if (buttonNum == 1) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 20, _alertView.frame.size.width, 40);
        button.backgroundColor=[UIColor clearColor];
        button.tag=10086;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:firstTitle forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:font];
        [button addTarget:self action:@selector(alertClick:) forControlEvents:UIControlEventTouchUpInside];
        [_linelab addSubview:button];
    }
    else if (buttonNum == 2){
        UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
        leftButton.frame =CGRectMake(0, 20, _alertView.frame.size.width/2, 40);
        leftButton.tag = 10086;
        leftButton.backgroundColor = [UIColor clearColor];
        leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftButton setTitle:firstTitle forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(alertClick:) forControlEvents:UIControlEventTouchUpInside];
        [_linelab addSubview:leftButton];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(_alertView.frame.size.width/2-1, 20, 1, 40)];
        lineView.backgroundColor=RGBACOLOR(210, 0, 11, 1);
        lineView.alpha=0.5;
        [_linelab addSubview:lineView];
        
        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        rightButton.frame =CGRectMake(_alertView.frame.size.width/2, 20, _alertView.bounds.size.width/2, 40);
        rightButton.tag = 10087;
        rightButton.backgroundColor =[UIColor clearColor];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [rightButton setTitle:secondTitle forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(alertClick:) forControlEvents:UIControlEventTouchUpInside];
        [_linelab addSubview:rightButton];
    }
    [self addSubview:_alertView];
}

-(void)keybordDown{
    [[DataUsedEngine getWindow] endEditing:YES];
}

-(void)alertClick:(UIButton *)btn{
    self.alertClick(btn);
    [self removeFromSuperview];
}

-(void)fontConfiger{
    font=0;
    if (ScreenHeigth==480) {
        font=14;
    }
    else if (ScreenHeigth==568)
    {
        font=15;
    }
    else if (ScreenHeigth==667)
    {
        font=15;
    }
    else if (ScreenHeigth==736)
    {
        font=16;
    }
}

#pragma mark 普通

-(void)commonAlert{
    UILabel * infolab       = [[UILabel alloc] initWithFrame:CGRectMake(17, 0, _alertView.bounds.size.width-17*2, _alertView.frame.size.height/3*2)];
    infolab.numberOfLines   = 0;
    infolab.center          = CGPointMake(_alertView.bounds.size.width/2, _alertView.bounds.size.height/2);
    infolab.textAlignment   = NSTextAlignmentCenter;
    infolab.font            = [UIFont systemFontOfSize:font];
    infolab.backgroundColor = [UIColor clearColor];
    infolab.text            = message;
    infolab.textColor       = [UIColor blackColor];
    [_alertView addSubview:infolab];
    
    float messageHeight = [DataUsedEngine getStringRectWithString:message Font:font Width:infolab.frame.size.width+8 Height:MAXFLOAT].height;
    if (messageHeight > infolab.frame.size.height) {
        _alertView.frame = CGRectMake(_alertView.frame.origin.x, _alertView.frame.origin.y, _alertView.frame.size.width, _alertView.frame.size.height + (messageHeight - infolab.frame.size.height));
        _alertView.center=CGPointMake(ScreenWidth/2, ScreenHeigth/2-30);
        infolab.frame = CGRectMake(infolab.frame.origin.x, infolab.frame.origin.y, infolab.frame.size.width, messageHeight);
        _linelab.frame = CGRectMake(_linelab.frame.origin.x, _alertView.frame.size.height+_alertView.frame.origin.y-20, _alertView.bounds.size.width, 20+40);
    }
}

#pragma mark 条件单

#define Tag_greaterThanColorView 766
#define Tag_greaterThanLabelView 767
#define Tag_lessThanColorView    768
#define Tag_lessThanLabelView    769
#define Tag_greateThanChooseView 770
#define Tag_lessThanChooseView   771

-(void)delegateOrderMore{
    _alertView.frame = CGRectMake(_alertView.frame.origin.x, _alertView.frame.origin.y, _alertView.frame.size.width, _alertView.frame.size.height + 100/667.0*ScreenHeigth);
    _alertView.center=CGPointMake(ScreenWidth/2, ScreenHeigth/2-30/667.0*ScreenHeigth);
    _linelab.frame = CGRectMake(_linelab.frame.origin.x, _alertView.frame.size.height+_alertView.frame.origin.y-20, _alertView.bounds.size.width, (20+40));
    _linelab.backgroundColor = Color_Red;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, _alertView.frame.size.width, 50/667.0*ScreenHeigth)];
    titleLabel.text = @"设置委托条件";
    titleLabel.textColor = Color_gray;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [_alertView addSubview:titleLabel];
    
    /**
     More
     */
    UIView  *greaterThanOrEqualView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLabel.frame), (_alertView.frame.size.width - 40)/3, 40/667.0*ScreenHeigth)];
    [_alertView addSubview:greaterThanOrEqualView];
    UITapGestureRecognizer  *greaterThanOrEqualTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(greaterThanOrEqualTap)];
    [greaterThanOrEqualView addGestureRecognizer:greaterThanOrEqualTap];
    
    //Point
    UIView *greaterThanOrEqualPoint = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15/667.0*ScreenHeigth, 15/667.0*ScreenHeigth)];
    greaterThanOrEqualPoint.backgroundColor = [UIColor whiteColor];
    greaterThanOrEqualPoint.clipsToBounds = YES;
    greaterThanOrEqualPoint.layer.cornerRadius = 15/667.0*ScreenHeigth/2.0;
    greaterThanOrEqualPoint.layer.borderColor = Color_lightGray.CGColor;
    greaterThanOrEqualPoint.layer.borderWidth = 1;
    greaterThanOrEqualPoint.center = CGPointMake(greaterThanOrEqualPoint.center.x, greaterThanOrEqualView.frame.size.height/2);
    [greaterThanOrEqualView addSubview:greaterThanOrEqualPoint];
    
    UIView  *greaterThanOrEqualColorPoint = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8/667.0*ScreenHeigth, 8/667.0*ScreenHeigth)];
    greaterThanOrEqualColorPoint.backgroundColor = Color_Red;
    greaterThanOrEqualColorPoint.clipsToBounds = YES;
    greaterThanOrEqualColorPoint.layer.cornerRadius = 8/667.0*ScreenHeigth/2.0;
    greaterThanOrEqualColorPoint.center = CGPointMake(greaterThanOrEqualPoint.frame.size.width/2, greaterThanOrEqualPoint.frame.size.height/2);
    greaterThanOrEqualColorPoint.tag = Tag_greaterThanColorView;
    [greaterThanOrEqualPoint addSubview:greaterThanOrEqualColorPoint];
    //Label≥
    UILabel *greaterThanOrEqualLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(greaterThanOrEqualPoint.frame) + 7, greaterThanOrEqualPoint.frame.origin.y, greaterThanOrEqualView.frame.size.width - (CGRectGetMaxX(greaterThanOrEqualPoint.frame) + 5), greaterThanOrEqualPoint.frame.size.height)];
    greaterThanOrEqualLabel.text = @"看多价 ≤";
    greaterThanOrEqualLabel.textColor = [UIColor blackColor];
    greaterThanOrEqualLabel.font = [UIFont systemFontOfSize:14];
    greaterThanOrEqualLabel.tag = Tag_greaterThanLabelView;
    [greaterThanOrEqualView addSubview:greaterThanOrEqualLabel];
    
    IndexOrderChooseView *greaterChooseView = [[IndexOrderChooseView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(greaterThanOrEqualView.frame) + 5, greaterThanOrEqualView.frame.origin.y + 3, (_alertView.frame.size.width - 40)/3*2-5, 34/667.0*ScreenHeigth)];
    greaterChooseView.clipsToBounds = YES;
    greaterChooseView.layer.cornerRadius = 3;
    greaterChooseView.layer.borderColor = Color_lightGray.CGColor;
    greaterChooseView.layer.borderWidth = 1;
    [greaterChooseView.minusButton setTitleColor:Color_Red forState:UIControlStateNormal];
    [greaterChooseView.plusButton setTitleColor:Color_Red forState:UIControlStateNormal];
    greaterChooseView.minusLineView.backgroundColor = Color_lightGray;
    greaterChooseView.plusLineView.backgroundColor = Color_lightGray;
    greaterChooseView.textField.textColor = [UIColor blackColor];
    greaterChooseView.tag = Tag_greateThanChooseView;
    /**
     *  Block
     *
     *  @param aChooseView
     *
     *  @return
     */
    greaterChooseView.minusBlock = ^(IndexOrderChooseView *aChooseView){
    };
    greaterChooseView.plusBlock = ^(IndexOrderChooseView *aChooseView){
    };
    greaterChooseView.editEndBlock = ^(IndexOrderChooseView *aChooseView){
    };
    [_alertView addSubview:greaterChooseView];
    
    /**
     Less
     */
    UIView  *lessThanOrEqualView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(greaterThanOrEqualView.frame) + 15/667.0*ScreenHeigth, (_alertView.frame.size.width - 40)/3, 40/667.0*ScreenHeigth)];
    [_alertView addSubview:lessThanOrEqualView];
    UITapGestureRecognizer  *lessThanOrEqualTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lessThanOrEqualTap)];
    [lessThanOrEqualView addGestureRecognizer:lessThanOrEqualTap];
    
    //Point
    UIView *lessThanOrEqualPoint = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15/667.0*ScreenHeigth, 15/667.0*ScreenHeigth)];
    lessThanOrEqualPoint.backgroundColor = [UIColor whiteColor];
    lessThanOrEqualPoint.clipsToBounds = YES;
    lessThanOrEqualPoint.layer.cornerRadius = 15/667.0*ScreenHeigth/2.0;
    lessThanOrEqualPoint.layer.borderColor = Color_lightGray.CGColor;
    lessThanOrEqualPoint.layer.borderWidth = 1;
    lessThanOrEqualPoint.center = CGPointMake(lessThanOrEqualPoint.center.x, lessThanOrEqualView.frame.size.height/2);
    [lessThanOrEqualView addSubview:lessThanOrEqualPoint];
    
    UIView  *lessThanOrEqualColorPoint = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8/667.0*ScreenHeigth, 8/667.0*ScreenHeigth)];
    lessThanOrEqualColorPoint.backgroundColor = Color_Red;
    lessThanOrEqualColorPoint.clipsToBounds = YES;
    lessThanOrEqualColorPoint.layer.cornerRadius = 8/667.0*ScreenHeigth/2.0;
    lessThanOrEqualColorPoint.tag = Tag_lessThanColorView;
    lessThanOrEqualColorPoint.center = CGPointMake(lessThanOrEqualPoint.frame.size.width/2, lessThanOrEqualPoint.frame.size.height/2);
    lessThanOrEqualColorPoint.hidden = YES;
    [lessThanOrEqualPoint addSubview:lessThanOrEqualColorPoint];
    //Label≥≤
    UILabel *lessThanOrEqualLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lessThanOrEqualPoint.frame) + 7, lessThanOrEqualPoint.frame.origin.y, lessThanOrEqualView.frame.size.width - (CGRectGetMaxX(lessThanOrEqualPoint.frame) + 5), lessThanOrEqualPoint.frame.size.height)];
    lessThanOrEqualLabel.text = @"看多价 ≥";
    lessThanOrEqualLabel.textColor = [UIColor lightGrayColor];
    lessThanOrEqualLabel.font = [UIFont systemFontOfSize:14];
    lessThanOrEqualLabel.tag = Tag_lessThanLabelView;
    [lessThanOrEqualView addSubview:lessThanOrEqualLabel];
    
    IndexOrderChooseView *lessChooseView = [[IndexOrderChooseView alloc]initWithFrame:CGRectMake(greaterChooseView.frame.origin.x, lessThanOrEqualView.frame.origin.y + 3, (_alertView.frame.size.width - 40)/3*2-5, 34/667.0*ScreenHeigth)];
    lessChooseView.clipsToBounds = YES;
    lessChooseView.layer.cornerRadius = 3;
    lessChooseView.layer.borderColor = Color_lightGray.CGColor;
    lessChooseView.layer.borderWidth = 1;
    [lessChooseView.minusButton setTitleColor:Color_Red forState:UIControlStateNormal];
    [lessChooseView.plusButton setTitleColor:Color_Red forState:UIControlStateNormal];
    lessChooseView.minusLineView.backgroundColor = Color_lightGray;
    lessChooseView.plusLineView.backgroundColor = Color_lightGray;
    lessChooseView.textField.textColor = [UIColor blackColor];
    lessChooseView.tag = Tag_lessThanChooseView;
    /**
     *  Block
     *
     *  @param aChooseView
     *
     *  @return
     */
    lessChooseView.minusBlock = ^(IndexOrderChooseView *aChooseView){
    };
    lessChooseView.plusBlock = ^(IndexOrderChooseView *aChooseView){
    };
    lessChooseView.editEndBlock = ^(IndexOrderChooseView *aChooseView){
    };
    [_alertView addSubview:lessChooseView];
    
    greaterChooseView.plusButton.enabled = YES;
    greaterChooseView.minusButton.enabled = YES;
    greaterChooseView.textField.enabled = YES;
    
    lessChooseView.plusButton.enabled = NO;
    lessChooseView.minusButton.enabled = NO;
    lessChooseView.textField.enabled = NO;
    
    [greaterChooseView.plusButton setTitleColor:Color_Red forState:UIControlStateNormal];
    [greaterChooseView.minusButton setTitleColor:Color_Red forState:UIControlStateNormal];
    greaterChooseView.textField.textColor = [UIColor blackColor];
    
    [lessChooseView.plusButton setTitleColor:Color_lightGray forState:UIControlStateNormal];
    [lessChooseView.minusButton setTitleColor:Color_lightGray forState:UIControlStateNormal];
    lessChooseView.textField.textColor = Color_lightGray;
    
    [self allBuild:CGRectGetMaxY(lessThanOrEqualView.frame)];
}

-(void)greaterThanOrEqualTap{
    UIView  *greateColorView = [_alertView viewWithTag:Tag_greaterThanColorView];
    UILabel  *greateLabelView = [_alertView viewWithTag:Tag_greaterThanLabelView];
    
    UIView  *lessColorView = [_alertView viewWithTag:Tag_lessThanColorView];
    UILabel  *lessLabelView = [_alertView viewWithTag:Tag_lessThanLabelView];
    
    IndexOrderChooseView *greateChooseView = [_alertView viewWithTag:Tag_greateThanChooseView];
    IndexOrderChooseView *lessChooseView = [_alertView viewWithTag:Tag_lessThanChooseView];
    
    greateLabelView.textColor = [UIColor blackColor];
    lessLabelView.textColor = [UIColor lightGrayColor];
    
    greateColorView.hidden = NO;
    lessColorView.hidden = YES;
    
    UIColor *motifColor = Color_Red;
    if ([greateLabelView.text rangeOfString:@"空"].location != NSNotFound) {
        motifColor = Color_Green;
    }
    
    [greateChooseView.plusButton setTitleColor:motifColor forState:UIControlStateNormal];
    [greateChooseView.minusButton setTitleColor:motifColor forState:UIControlStateNormal];
    greateChooseView.textField.textColor = [UIColor blackColor];
    
    [lessChooseView.plusButton setTitleColor:Color_lightGray forState:UIControlStateNormal];
    [lessChooseView.minusButton setTitleColor:Color_lightGray forState:UIControlStateNormal];
    lessChooseView.textField.textColor = Color_lightGray;
    
    greateChooseView.plusButton.enabled = YES;
    greateChooseView.minusButton.enabled = YES;
    greateChooseView.textField.enabled = YES;
    
    lessChooseView.plusButton.enabled = NO;
    lessChooseView.minusButton.enabled = NO;
    lessChooseView.textField.enabled = NO;
}

-(void)lessThanOrEqualTap{
    UIView  *greateColorView = [_alertView viewWithTag:Tag_greaterThanColorView];
    UILabel  *greateLabelView = [_alertView viewWithTag:Tag_greaterThanLabelView];
    
    UIView  *lessColorView = [_alertView viewWithTag:Tag_lessThanColorView];
    UILabel  *lessLabelView = [_alertView viewWithTag:Tag_lessThanLabelView];
    
    IndexOrderChooseView *greateChooseView = [_alertView viewWithTag:Tag_greateThanChooseView];
    IndexOrderChooseView *lessChooseView = [_alertView viewWithTag:Tag_lessThanChooseView];
    
    lessLabelView.textColor = [UIColor blackColor];
    greateLabelView.textColor = [UIColor lightGrayColor];
    
    lessColorView.hidden = NO;
    greateColorView.hidden = YES;
    
    UIColor *motifColor = Color_Red;
    if ([greateLabelView.text rangeOfString:@"空"].location != NSNotFound) {
        motifColor = Color_Green;
    }
    
    [lessChooseView.plusButton setTitleColor:motifColor forState:UIControlStateNormal];
    [lessChooseView.minusButton setTitleColor:motifColor forState:UIControlStateNormal];
    lessChooseView.textField.textColor = [UIColor blackColor];
    
    [greateChooseView.plusButton setTitleColor:Color_lightGray forState:UIControlStateNormal];
    [greateChooseView.minusButton setTitleColor:Color_lightGray forState:UIControlStateNormal];
    greateChooseView.textField.textColor = Color_lightGray;
    
    greateChooseView.plusButton.enabled = NO;
    greateChooseView.minusButton.enabled = NO;
    greateChooseView.textField.enabled = NO;
    
    lessChooseView.plusButton.enabled = YES;
    lessChooseView.minusButton.enabled = YES;
    lessChooseView.textField.enabled = YES;
}

-(void)delegateOrderLess{
    _alertView.frame = CGRectMake(_alertView.frame.origin.x, _alertView.frame.origin.y, _alertView.frame.size.width, _alertView.frame.size.height + 100/667.0*ScreenHeigth);
    _alertView.center=CGPointMake(ScreenWidth/2, ScreenHeigth/2-30/667.0*ScreenHeigth);
    _linelab.frame = CGRectMake(_linelab.frame.origin.x, _alertView.frame.size.height+_alertView.frame.origin.y-20, _alertView.bounds.size.width, (20+40));
    _linelab.backgroundColor = Color_Green;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, _alertView.frame.size.width, 50/667.0*ScreenHeigth)];
    titleLabel.text = @"设置委托条件";
    titleLabel.textColor = Color_gray;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [_alertView addSubview:titleLabel];
    
    /**
     More
     */
    UIView  *greaterThanOrEqualView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLabel.frame), (_alertView.frame.size.width - 40)/3, 40/667.0*ScreenHeigth)];
    [_alertView addSubview:greaterThanOrEqualView];
    UITapGestureRecognizer  *greaterThanOrEqualTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(greaterThanOrEqualTap)];
    [greaterThanOrEqualView addGestureRecognizer:greaterThanOrEqualTap];
    
    //Point
    UIView *greaterThanOrEqualPoint = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15/667.0*ScreenHeigth, 15/667.0*ScreenHeigth)];
    greaterThanOrEqualPoint.backgroundColor = [UIColor whiteColor];
    greaterThanOrEqualPoint.clipsToBounds = YES;
    greaterThanOrEqualPoint.layer.cornerRadius = 15/667.0*ScreenHeigth/2.0;
    greaterThanOrEqualPoint.layer.borderColor = Color_lightGray.CGColor;
    greaterThanOrEqualPoint.layer.borderWidth = 1;
    greaterThanOrEqualPoint.center = CGPointMake(greaterThanOrEqualPoint.center.x, greaterThanOrEqualView.frame.size.height/2);
    [greaterThanOrEqualView addSubview:greaterThanOrEqualPoint];
    
    UIView  *greaterThanOrEqualColorPoint = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8/667.0*ScreenHeigth, 8/667.0*ScreenHeigth)];
    greaterThanOrEqualColorPoint.backgroundColor = Color_Green;
    greaterThanOrEqualColorPoint.clipsToBounds = YES;
    greaterThanOrEqualColorPoint.layer.cornerRadius = 8/667.0*ScreenHeigth/2.0;
    greaterThanOrEqualColorPoint.center = CGPointMake(greaterThanOrEqualPoint.frame.size.width/2, greaterThanOrEqualPoint.frame.size.height/2);
    greaterThanOrEqualColorPoint.tag = Tag_greaterThanColorView;
    [greaterThanOrEqualPoint addSubview:greaterThanOrEqualColorPoint];
    //Label≥
    UILabel *greaterThanOrEqualLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(greaterThanOrEqualPoint.frame) + 7, greaterThanOrEqualPoint.frame.origin.y, greaterThanOrEqualView.frame.size.width - (CGRectGetMaxX(greaterThanOrEqualPoint.frame) + 5), greaterThanOrEqualPoint.frame.size.height)];
    greaterThanOrEqualLabel.text = @"看空价 ≥";
    greaterThanOrEqualLabel.textColor = [UIColor blackColor];
    greaterThanOrEqualLabel.font = [UIFont systemFontOfSize:14];
    greaterThanOrEqualLabel.tag = Tag_greaterThanLabelView;
    [greaterThanOrEqualView addSubview:greaterThanOrEqualLabel];
    
    IndexOrderChooseView *greaterChooseView = [[IndexOrderChooseView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(greaterThanOrEqualView.frame) + 5, greaterThanOrEqualView.frame.origin.y + 3, (_alertView.frame.size.width - 40)/3*2-5, 34/667.0*ScreenHeigth)];
    greaterChooseView.clipsToBounds = YES;
    greaterChooseView.layer.cornerRadius = 3;
    greaterChooseView.layer.borderColor = Color_lightGray.CGColor;
    greaterChooseView.layer.borderWidth = 1;
    [greaterChooseView.minusButton setTitleColor:Color_Green forState:UIControlStateNormal];
    [greaterChooseView.plusButton setTitleColor:Color_Green forState:UIControlStateNormal];
    greaterChooseView.minusLineView.backgroundColor = Color_lightGray;
    greaterChooseView.plusLineView.backgroundColor = Color_lightGray;
    greaterChooseView.textField.textColor = [UIColor blackColor];
    greaterChooseView.tag = Tag_greateThanChooseView;
    /**
     *  Bolck
     *
     *  @param aChooseView
     *
     *  @return
     */
    greaterChooseView.minusBlock = ^(IndexOrderChooseView *aChooseView){
    };
    greaterChooseView.plusBlock = ^(IndexOrderChooseView *aChooseView){
    };
    greaterChooseView.editEndBlock = ^(IndexOrderChooseView *aChooseView){
    };
    [_alertView addSubview:greaterChooseView];
    
    /**
     Less
     */
    UIView  *lessThanOrEqualView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(greaterThanOrEqualView.frame) + 15/667.0*ScreenHeigth, (_alertView.frame.size.width - 40)/3, 40/667.0*ScreenHeigth)];
    [_alertView addSubview:lessThanOrEqualView];
    UITapGestureRecognizer  *lessThanOrEqualTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lessThanOrEqualTap)];
    [lessThanOrEqualView addGestureRecognizer:lessThanOrEqualTap];
    
    //Point
    UIView *lessThanOrEqualPoint = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15/667.0*ScreenHeigth, 15/667.0*ScreenHeigth)];
    lessThanOrEqualPoint.backgroundColor = [UIColor whiteColor];
    lessThanOrEqualPoint.clipsToBounds = YES;
    lessThanOrEqualPoint.layer.cornerRadius = 15/667.0*ScreenHeigth/2.0;
    lessThanOrEqualPoint.layer.borderColor = Color_lightGray.CGColor;
    lessThanOrEqualPoint.layer.borderWidth = 1;
    lessThanOrEqualPoint.center = CGPointMake(lessThanOrEqualPoint.center.x, lessThanOrEqualView.frame.size.height/2);
    [lessThanOrEqualView addSubview:lessThanOrEqualPoint];
    
    UIView  *lessThanOrEqualColorPoint = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8/667.0*ScreenHeigth, 8/667.0*ScreenHeigth)];
    lessThanOrEqualColorPoint.backgroundColor = Color_Green;
    lessThanOrEqualColorPoint.clipsToBounds = YES;
    lessThanOrEqualColorPoint.layer.cornerRadius = 8/667.0*ScreenHeigth/2.0;
    lessThanOrEqualColorPoint.tag = Tag_lessThanColorView;
    lessThanOrEqualColorPoint.center = CGPointMake(lessThanOrEqualPoint.frame.size.width/2, lessThanOrEqualPoint.frame.size.height/2);
    lessThanOrEqualColorPoint.hidden = YES;
    [lessThanOrEqualPoint addSubview:lessThanOrEqualColorPoint];
    //Label≥≤
    UILabel *lessThanOrEqualLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lessThanOrEqualPoint.frame) + 7, lessThanOrEqualPoint.frame.origin.y, lessThanOrEqualView.frame.size.width - (CGRectGetMaxX(lessThanOrEqualPoint.frame) + 5), lessThanOrEqualPoint.frame.size.height)];
    lessThanOrEqualLabel.text = @"看空价 ≤";
    lessThanOrEqualLabel.textColor = [UIColor lightGrayColor];
    lessThanOrEqualLabel.font = [UIFont systemFontOfSize:14];
    lessThanOrEqualLabel.tag = Tag_lessThanLabelView;
    [lessThanOrEqualView addSubview:lessThanOrEqualLabel];
    
    IndexOrderChooseView *lessChooseView = [[IndexOrderChooseView alloc]initWithFrame:CGRectMake(greaterChooseView.frame.origin.x, lessThanOrEqualView.frame.origin.y + 3, (_alertView.frame.size.width - 40)/3*2-5, 34/667.0*ScreenHeigth)];
    lessChooseView.clipsToBounds = YES;
    lessChooseView.layer.cornerRadius = 3;
    lessChooseView.layer.borderColor = Color_lightGray.CGColor;
    lessChooseView.layer.borderWidth = 1;
    [lessChooseView.minusButton setTitleColor:Color_Green forState:UIControlStateNormal];
    [lessChooseView.plusButton setTitleColor:Color_Green forState:UIControlStateNormal];
    lessChooseView.minusLineView.backgroundColor = Color_lightGray;
    lessChooseView.plusLineView.backgroundColor = Color_lightGray;
    lessChooseView.textField.textColor = [UIColor blackColor];
    lessChooseView.tag = Tag_lessThanChooseView;
    /**
     *  Block
     *
     *  @param aChooseView
     *
     *  @return
     */
    lessChooseView.minusBlock = ^(IndexOrderChooseView *aChooseView){
    };
    lessChooseView.plusBlock = ^(IndexOrderChooseView *aChooseView){
    };
    lessChooseView.editEndBlock = ^(IndexOrderChooseView *aChooseView){
    };
    [_alertView addSubview:lessChooseView];
    
    greaterChooseView.plusButton.enabled = YES;
    greaterChooseView.minusButton.enabled = YES;
    greaterChooseView.textField.enabled = YES;
    
    lessChooseView.plusButton.enabled = NO;
    lessChooseView.minusButton.enabled = NO;
    lessChooseView.textField.enabled = NO;
    
    [greaterChooseView.plusButton setTitleColor:Color_Green forState:UIControlStateNormal];
    [greaterChooseView.minusButton setTitleColor:Color_Green forState:UIControlStateNormal];
    greaterChooseView.textField.textColor = [UIColor blackColor];
    
    [lessChooseView.plusButton setTitleColor:Color_lightGray forState:UIControlStateNormal];
    [lessChooseView.minusButton setTitleColor:Color_lightGray forState:UIControlStateNormal];
    lessChooseView.textField.textColor = Color_lightGray;
    
    [self allBuild:CGRectGetMaxY(lessThanOrEqualView.frame)];
}

-(void)allBuild:(float)aPointY{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, aPointY + 20/667.0*ScreenHeigth, _alertView.frame.size.width - 40, 0.5)] ;
    lineView.backgroundColor = Color_lightGray;
    [_alertView addSubview:lineView];
    
    UILabel *proLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, aPointY + 30/667.0*ScreenHeigth, lineView.frame.size.width, 13/667.0*ScreenHeigth)];
    proLabel.text = @"条件委托是市价下单服务，最终以实际成交价为准";
    proLabel.textColor = Color_gray;
    proLabel.font = [UIFont systemFontOfSize:10];
    proLabel.textAlignment = NSTextAlignmentCenter;
    [_alertView addSubview:proLabel];
}

#pragma mark 行情异常弹窗

-(void)errorAlert{
    _alertView.frame = CGRectMake(_alertView.frame.origin.x, _alertView.frame.origin.y, _alertView.frame.size.width, _alertView.frame.size.height + 30/667.0*ScreenHeigth);
    _alertView.center=CGPointMake(ScreenWidth/2, ScreenHeigth/2-30);
    _linelab.frame = CGRectMake(_linelab.frame.origin.x, _alertView.frame.size.height+_alertView.frame.origin.y-20, _alertView.bounds.size.width, 20+40);
    
    UIImageView *errorImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (68.0 * ((77.0/2.5)/667*ScreenHeigth)) / 77, (77.0/2.5)/667*ScreenHeigth)];
    errorImage.center = CGPointMake(_alertView.frame.size.width/2, 20/667.0*ScreenHeigth+errorImage.frame.size.height/2);
    errorImage.image = [UIImage imageNamed:@"error_image"];
    [_alertView addSubview:errorImage];
    
    UILabel     *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, errorImage.frame.origin.y + errorImage.frame.size.height + 10/667.0*ScreenHeigth, _alertView.frame.size.width, 20/667.0*ScreenHeigth)];
    redLabel.font = [UIFont systemFontOfSize:font+1];
    redLabel.textColor = [UIColor redColor];
    redLabel.numberOfLines = 0;
    redLabel.textAlignment = NSTextAlignmentCenter;
    redLabel.text = errorTitleMessage;
    [_alertView addSubview:redLabel];
    
    if (ScreenHeigth <= 480) {
        _linelab.frame = CGRectMake(_linelab.frame.origin.x, _linelab.frame.origin.y + 10, _linelab.frame.size.width, _linelab.frame.size.height);
    }
    else if (ScreenHeigth <= 568 && ScreenHeigth > 480){
        _linelab.frame = CGRectMake(_linelab.frame.origin.x, _linelab.frame.origin.y + 5, _linelab.frame.size.width, _linelab.frame.size.height);
    }
    
    switch (alertErrorTyle) {
        case AlertErrorTypeOrder:
            [self errorTypeOrder:redLabel];
            break;
        case AlertErrorTypeSelling:
            [self errorTypeSelling:redLabel];
            break;
            
        default:
            break;
    }
}

-(void)errorTypeOrder:(UILabel *)redLabel{
    UILabel     *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(20/375.0*ScreenWidth, redLabel.frame.origin.y + redLabel.frame.size.height + 10/667.0*ScreenHeigth, _alertView.frame.size.width - 20/375.0*ScreenWidth*2, 42/667.0*ScreenHeigth)];
    messageLabel.text = errorMessage;
    messageLabel.font = [UIFont systemFontOfSize:font-1];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    [_alertView addSubview:messageLabel];
    
    if (ScreenHeigth <= 480) {
        messageLabel.bounds = CGRectMake(0, 0, messageLabel.frame.size.width, messageLabel.frame.size.height + 20);
        _alertView.bounds = CGRectMake(0, 0, _alertView.frame.size.width, _alertView.frame.size.height + 20);
    }
    else if (ScreenHeigth <= 568 && ScreenHeigth > 480){
        messageLabel.bounds = CGRectMake(0, 0, messageLabel.frame.size.width, messageLabel.frame.size.height + 10);
        _alertView.bounds = CGRectMake(0, 0, _alertView.frame.size.width, _alertView.frame.size.height + 10);
    }
}

-(void)errorTypeSelling:(UILabel *)redLabel{
    
    if (errorMoneyUnit == nil || [errorMoneyUnit isEqualToString:@""]) errorMoneyUnit = @"元";
    if ([errorMoney isEqualToString:@""]) errorMoney = nil;
    if ([errorIntegral isEqualToString:@""]) errorIntegral = nil;
    
    UILabel     *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(20/375.0*ScreenWidth, redLabel.frame.origin.y + redLabel.frame.size.height + 10/667.0*ScreenHeigth, _alertView.frame.size.width - 20/375.0*ScreenWidth*2, 42/667.0*ScreenHeigth)];
    messageLabel.font = [UIFont systemFontOfSize:font-1];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    [_alertView addSubview:messageLabel];
    
    if ((errorMoney != nil && ![errorMoney isKindOfClass:[NSNull class]]) && (errorIntegral != nil && ![errorIntegral isKindOfClass:[NSNull class]])) {
        messageLabel.center = CGPointMake(messageLabel.center.x, messageLabel.center.y - 8);
        messageLabel.text = [NSString stringWithFormat:@"%@",errorMessage];
        
        for (int i = 0; i < 2; i++) {
            UILabel     *incomeLabel = [[UILabel alloc]init];
            incomeLabel.font = [UIFont systemFontOfSize:font-1];
            incomeLabel.textAlignment = NSTextAlignmentCenter;
            incomeLabel.numberOfLines = 0;
            [_alertView addSubview:incomeLabel];
            if (i == 0) {
                incomeLabel.frame = CGRectMake(0, messageLabel.frame.origin.y + messageLabel.frame.size.height - 15/667.0*ScreenHeigth, _alertView.frame.size.width/2/8*7, 42/667.0*ScreenHeigth);
                NSString    *sign = @"+";
                UIColor     *color = Color_red;
                if ([errorMoney floatValue] < 0) {
                    sign = @"";
                    color = Color_green;
                }
                incomeLabel.textAlignment = NSTextAlignmentRight;
                incomeLabel.text = [NSString stringWithFormat:@"%@%@%@",sign,errorMoney,errorMoneyUnit];
                incomeLabel.attributedText = [Helper multiplicityText:incomeLabel.text from:0 to:(int)incomeLabel.text.length - (int)errorMoneyUnit.length color:color];
            }
            else if (i == 1){
                incomeLabel.frame = CGRectMake(_alertView.frame.size.width/2 + _alertView.frame.size.width/2/8, messageLabel.frame.origin.y + messageLabel.frame.size.height - 15/667.0*ScreenHeigth, _alertView.frame.size.width/2/8*7, 42/667.0*ScreenHeigth);
                incomeLabel.textAlignment = NSTextAlignmentRight;
                NSString    *sign = @"+";
                UIColor     *color = Color_red;
                if ([errorIntegral floatValue] < 0) {
                    sign = @"";
                    color = Color_green;
                }
                incomeLabel.textAlignment = NSTextAlignmentLeft;
                incomeLabel.text = [NSString stringWithFormat:@"%@%@积分",sign,errorIntegral];
                incomeLabel.attributedText = [Helper multiplicityText:incomeLabel.text from:0 to:(int)incomeLabel.text.length - 2 color:color];
            }
        }
    }
    //有积分
    else if ((errorMoney == nil || [errorMoney isKindOfClass:[NSNull class]]) && (errorIntegral != nil && ![errorIntegral isKindOfClass:[NSNull class]])){
        NSString    *sign = @"+";
        UIColor     *color = Color_red;
        if ([errorIntegral floatValue] < 0) {
            sign = @"";
            color = Color_green;
        }
        messageLabel.text = [NSString stringWithFormat:@"%@  %@%@积分",errorMessage,sign,errorIntegral];
        messageLabel.attributedText = [Helper multiplicityText:messageLabel.text from:(int)errorMessage.length + 2 to:(int)errorIntegral.length+(int)sign.length color:color];
    }
    //有现金
    else if ((errorMoney != nil && ![errorMoney isKindOfClass:[NSNull class]]) && (errorIntegral == nil || [errorIntegral isKindOfClass:[NSNull class]])){
        NSString    *sign = @"+";
        UIColor     *color = Color_red;
        if ([errorMoney floatValue] < 0) {
            sign = @"";
            color = Color_green;
        }
        messageLabel.text = [NSString stringWithFormat:@"%@  %@%@%@",errorMessage,sign,errorMoney,errorMoneyUnit];
        messageLabel.attributedText = [Helper multiplicityText:messageLabel.text from:(int)errorMessage.length + 2 to:(int)errorMoney.length+(int)sign.length color:color];
    }
    //无积分，无现金
    else{
        
    }
    
    if (ScreenHeigth <= 480) {
        messageLabel.bounds = CGRectMake(0, 0, messageLabel.frame.size.width, messageLabel.frame.size.height + 20);
        _alertView.bounds = CGRectMake(0, 0, _alertView.frame.size.width, _alertView.frame.size.height + 20);
    }
    else if (ScreenHeigth <= 568 && ScreenHeigth > 480){
        messageLabel.bounds = CGRectMake(0, 0, messageLabel.frame.size.width, messageLabel.frame.size.height + 10);
        _alertView.bounds = CGRectMake(0, 0, _alertView.frame.size.width, _alertView.frame.size.height + 10);
    }
    
}

@end
