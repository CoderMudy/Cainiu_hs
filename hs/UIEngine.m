//
//  UIEngine.m
//  hs
//
//  Created by RGZ on 15/5/18.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "UIEngine.h"

@implementation UIEngine
{
    //alertview的遮挡物
    UIView      *_coverView;
    UIView      * alertView;
    double      _angle;
    UIImageView *_imageView;
    NSTimer     *_progressTimer;
    UITextField *_textField;
    UILabel     *_linelab;
    
    int         selectMoneyIndex;
}
DEF_SINGLETON(UIEngine)

-(void)showProgress
{
    [UIView setAnimationsEnabled:YES];
    
    @autoreleasepool {
        _angle=0;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        NSArray * array = [[UIApplication sharedApplication] windows];
        
        if (array.count >= 2) {
            
            window = [array objectAtIndex:1];
            
        }
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64)];
        view.backgroundColor=RGBACOLOR(0, 0, 0, 1);
        view.alpha=0.3;
        view.tag=10000000001;
        [window addSubview:view];
        
        _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        _imageView.image=[UIImage imageNamed:@"loding_01"];
        
        
        
        
        if (self.progressStyle==1) {
            view.backgroundColor=[UIColor clearColor];
            
            
            UIView  *smallCoverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 60)];
            smallCoverView.backgroundColor=[UIColor blackColor];
            smallCoverView.alpha = 0.6;
            smallCoverView.clipsToBounds=YES;
            smallCoverView.layer.cornerRadius=6;
            smallCoverView.tag = 10000000002;
            smallCoverView.center=CGPointMake(window.center.x, window.center.y-50);
            [window addSubview:smallCoverView];
            
            _imageView.frame = CGRectMake(smallCoverView.frame.size.width/2-_imageView.frame.size.width/2, smallCoverView.frame.size.height/2-_imageView.frame.size.height/2, 30, 30);
            
            [smallCoverView addSubview:_imageView];
            
            _progressTimer=[NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(startAnimation) userInfo:nil repeats:YES];
            [_progressTimer fire];
        }
        
        else if (self.progressStyle == 2){
            view.backgroundColor = [UIColor whiteColor];
            view.frame = window.frame;
            
            UIActivityIndicatorView* activityIndicatorView = [ [ UIActivityIndicatorView alloc ]
                                                              initWithFrame:CGRectMake(0,0,60.0,60.0)];
            activityIndicatorView.center = view.center;
            activityIndicatorView.color = [UIColor redColor];
            activityIndicatorView.hidesWhenStopped = NO;
            activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleWhiteLarge;
            [window addSubview:activityIndicatorView];
            [activityIndicatorView startAnimating];
            
        }
        
        else
        {
            _imageView.center=window.center;
            [window addSubview:_imageView];
            
            _progressTimer=[NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(startAnimation) userInfo:nil repeats:YES];
            [_progressTimer fire];
        }
    }
}


-(void) startAnimation
{
    if(_angle>=360)
    {
        _angle=0;
    }
    _angle+=1;
    _imageView.transform = CGAffineTransformMakeRotation(_angle * (M_PI / 180.0f));
}

-(void)hideProgress
{
    [_progressTimer invalidate];
    
    _progressTimer=nil;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    NSArray * array = [[UIApplication sharedApplication] windows];
    
    if (array.count >= 2) {
        
        window = [array objectAtIndex:1];
        
    }
    
    UIView  *coverView = [window viewWithTag:(NSInteger)10000000001];
    UIView  *smallCoverView = [window viewWithTag:(NSInteger)10000000002];
    [coverView removeFromSuperview];
    [smallCoverView removeFromSuperview];
    smallCoverView = nil;
    coverView = nil;
    
    [_imageView removeFromSuperview];
    
    _angle=0;
    
    for (int i = 0; i<window.subviews.count; i++) {
        if ([window.subviews[i] isKindOfClass:[UIActivityIndicatorView class]]) {
            [window.subviews[i] removeFromSuperview];
            break;
        }
    }
    
}

+(void)showXianHuoPromptMesg:(NSString*)aMessage
{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    NSArray * array = [[UIApplication sharedApplication] windows];
    
    if (array.count >= 2) {
        
        window = [array objectAtIndex:1];
        
    }
    
    UIView *view = [window viewWithTag:8888];
    UIView *labelView = [window viewWithTag:8889];
    if (view != nil) {
        [view removeFromSuperview];
        view = nil;
    }
    if (labelView != nil) {
        [labelView removeFromSuperview];
        labelView = nil;
    }
    
    UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(10, window.frame.size.height-100*ScreenWidth/320, ScreenWidth-20, 55.0/667.0*ScreenHeigth)];
//    coverView.center = CGPointMake((ScreenWidth)/2, 169/568.0*ScreenHeigth);
    coverView.backgroundColor=RGBACOLOR(20, 20, 20, 1);
    coverView.alpha=0.8;
    coverView.tag=8888;
    coverView.layer.cornerRadius=5;
    coverView.clipsToBounds=YES;
    [window addSubview:coverView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:coverView.frame];
//    label.center=CGPointMake((ScreenWidth)/2, 169/568.0*ScreenHeigth);
    label.text=aMessage;
    label.font=[UIFont systemFontOfSize:13];
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.numberOfLines=0;
    label.tag = 8889;
    label.alpha = 1;
    label.textAlignment=NSTextAlignmentCenter;
    label.layer.cornerRadius=5;
    label.clipsToBounds=YES;
    
    [window addSubview:label];
    
    
    [UIView beginAnimations:@"animation" context:@"context"];
    [UIView setAnimationDelay:1];
    [UIView setAnimationDuration:2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    coverView.alpha = 0;
    label.alpha = 0;
    [UIView commitAnimations];
    
}

+(void)showShadowPrompt:(NSString*)aMessage
{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    NSArray * array = [[UIApplication sharedApplication] windows];
    
    if (array.count >= 2) {
        
        window = [array objectAtIndex:1];
        
    }
    
    UIView *view = [window viewWithTag:8888];
    UIView *labelView = [window viewWithTag:8889];
    if (view != nil) {
        [view removeFromSuperview];
        view = nil;
    }
    if (labelView != nil) {
        [labelView removeFromSuperview];
        labelView = nil;
    }
    
    UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(window.frame.size.width/10, window.frame.size.height-window.frame.size.height/5*3, ScreenWidth-30, 55.0/667.0*ScreenHeigth)];
    coverView.center = CGPointMake((ScreenWidth)/2, 169/568.0*ScreenHeigth);
    coverView.backgroundColor=RGBACOLOR(20, 20, 20, 1);
    coverView.alpha=0.8;
    coverView.tag=8888;
    coverView.layer.cornerRadius=5;
    coverView.clipsToBounds=YES;
    [window addSubview:coverView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:coverView.frame];
    label.center=CGPointMake((ScreenWidth)/2, 169/568.0*ScreenHeigth);
    label.text=aMessage;
    label.font=[UIFont systemFontOfSize:13];
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.numberOfLines=0;
    label.tag = 8889;
    label.alpha = 1;
    label.textAlignment=NSTextAlignmentCenter;
    label.layer.cornerRadius=5;
    label.clipsToBounds=YES;
    
    [window addSubview:label];
    
    
    [UIView beginAnimations:@"animation" context:@"context"];
    [UIView setAnimationDelay:1];
    [UIView setAnimationDuration:2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    coverView.alpha = 0;
    label.alpha = 0;
    [UIView commitAnimations];
    
}

-(void)showAlertSpecialWithTitle:(NSString  *)aTitle TimeArray:(NSMutableArray *)aArray{
    int titleFont=0;
    if (ScreenHeigth==480) {
        titleFont=14;
    }
    else if (ScreenHeigth==568)
    {
        titleFont=15;
    }
    else if (ScreenHeigth==667)
    {
        titleFont=15;
    }
    else if (ScreenHeigth==736)
    {
        titleFont=16;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    NSArray * array = [[UIApplication sharedApplication] windows];
    
    if (array.count >= 2) {
        
        window = [array objectAtIndex:1];
        
    }
    
    if(_coverView==nil)
    {
        _coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
        _coverView.backgroundColor=[UIColor blackColor];
        _coverView.alpha=0.7;
        [window addSubview:_coverView];
        
        
        alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _coverView.bounds.size.width/3*2, 20+12+20+20*aArray.count+5+10)];
        alertView.center=CGPointMake(ScreenWidth/2, ScreenHeigth/2-30);
        alertView.backgroundColor = [UIColor whiteColor];
        alertView.layer.cornerRadius = 8;
        alertView.alpha=1;
        alertView.layer.masksToBounds = YES;
        
        
        UILabel * titlelab = [[UILabel alloc] initWithFrame:CGRectMake(17, 10, alertView.bounds.size.width-17*2, 20)];
        titlelab.numberOfLines = 1;
        titlelab.textAlignment=NSTextAlignmentCenter;
        titlelab.font = [UIFont systemFontOfSize:titleFont];
        titlelab.backgroundColor = [UIColor clearColor];
        titlelab.text = aTitle;
        titlelab.textColor = AlertColor;
        [alertView addSubview:titlelab];
        
        
        UILabel * prolab = [[UILabel alloc] initWithFrame:CGRectMake(17, titlelab.frame.origin.y+titlelab.frame.size.height+10, alertView.bounds.size.width-17*2, 12)];
        prolab.numberOfLines = 1;
        prolab.textAlignment=NSTextAlignmentCenter;
        prolab.font = [UIFont systemFontOfSize:12];
        prolab.backgroundColor = [UIColor clearColor];
        
        prolab.textColor = [UIColor grayColor];
        [alertView addSubview:prolab];
        if(aArray != nil && aArray.count >= 1 && ([aArray[0] isEqualToString:@"周六、周日和国家规定"] ||
                                                  [aArray[0] isEqualToString:@"周六、周日和国家规定节假日休市"])){
            prolab.text = @"";
        }
        else{
            prolab.text = @"交易时间";
        }
        
        for (int i = 0; i<aArray.count; i++) {
            UILabel * infolab = [[UILabel alloc] initWithFrame:CGRectMake(17, prolab.frame.origin.y+prolab.frame.size.height+5+i*20, alertView.bounds.size.width-17*2, 20)];
            infolab.numberOfLines = 0;
            infolab.textAlignment=NSTextAlignmentCenter;
            infolab.font = [UIFont systemFontOfSize:14];
            if ([aArray[0] isEqualToString:@"周六、周日和国家规定"] ||
                [aArray[0] isEqualToString:@"周六、周日和国家规定节假日休市"]) {
                infolab.font = [UIFont systemFontOfSize:13];
            }
            infolab.backgroundColor = [UIColor clearColor];
            infolab.text = aArray[i];
            infolab.textColor = [UIColor blackColor];
            [alertView addSubview:infolab];
        }
        
        
        _linelab = [[UILabel alloc] initWithFrame:CGRectMake(0, alertView.frame.size.height+alertView.frame.origin.y-20, alertView.bounds.size.width, 20+40)];
        _linelab.center = CGPointMake(ScreenWidth/2, _linelab.center.y);
        _linelab.backgroundColor = AlertColor;
        _linelab.alpha=1;
        _linelab.clipsToBounds = YES;
        _linelab.userInteractionEnabled = YES;
        _linelab.layer.cornerRadius = 8;
        [window addSubview:_linelab];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 20, alertView.frame.size.width, 40);
        button.backgroundColor=[UIColor clearColor];
        button.tag=10086;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:titleFont];
        [button addTarget:self action:@selector(alertClick:) forControlEvents:UIControlEventTouchUpInside];
        [_linelab addSubview:button];
        
        [window addSubview:alertView];
    }
    
}

-(void)showAlertWithTitle:(NSString *)aMessage ButtonNumber:(int)aNum FirstButtonTitle:(NSString *)aFirstTitle SecondButtonTitle:(NSString *)aSecondTitle
{
    UIEngine *engine = self;
    
    if (engine.alert != nil) return;
    _alert = [[Alert alloc]initWithButtonNum:aNum
                                        FirstTitle:aFirstTitle
                                       SecondTitle:aSecondTitle
                                           Message:aMessage
                                         AlertType:AlertCommon
                                    AlertErrorType:AlertErrorTypeSelling
                                 ErrorTitleMessage:nil
                                      ErrorMessage:nil
                                        ErrorMoney:nil
                                     ErrorIntegral:nil
                                    ErrorMoneyUnit:nil];
    _alert.alertClick = ^(UIButton *btn){
        [engine alertClick:btn];
        engine.alert = nil;
    };
    [[DataUsedEngine getWindow] addSubview:_alert];
}

- ( CGSize )getStringRect:( NSString *)aString{
    CGSize  size;
    NSAttributedString * atrString = [[ NSAttributedString alloc ]  initWithString :aString];
    NSRange  range =  NSMakeRange ( 0 , atrString. length );
    NSDictionary * dic = [atrString  attributesAtIndex : 0   effectiveRange :&range];
    size=[aString boundingRectWithSize:CGSizeMake(ScreenWidth-40, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return   size;
}

-(void)showAuthLoginPWD
{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if(_coverView==nil)
    {
        _coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
        _coverView.backgroundColor=[UIColor blackColor];
        _coverView.alpha=0.7;
        [window addSubview:_coverView];
        
        
        alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _coverView.bounds.size.width-60, ScreenHeigth/3-15)];
        alertView.center=CGPointMake(ScreenWidth/2, ScreenHeigth/2-30);
        alertView.backgroundColor = K_COLOR_CUSTEM(250, 67, 0, 1);
        alertView.layer.cornerRadius = 6;
        alertView.alpha=0.3;
        alertView.layer.masksToBounds = YES;
        [window addSubview:alertView];
        
        
        UIView  *backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, alertView.frame.size.width, alertView.frame.size.height/4*3)];
        backGroundView.backgroundColor = RGBACOLOR(246, 246, 246, 1);
        [alertView addSubview:backGroundView];
        
        
        UILabel * infolab = [[UILabel alloc] initWithFrame:CGRectMake(0, 30/568.0*ScreenHeigth, backGroundView.frame.size.width, 20)];
        infolab.textAlignment=NSTextAlignmentCenter;
        infolab.font = [UIFont systemFontOfSize:14];
        infolab.backgroundColor = [UIColor clearColor];
        infolab.text = @"验证登录密码";
        infolab.textColor = [UIColor blackColor];
        [backGroundView addSubview:infolab];
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(15, infolab.frame.origin.y+infolab.frame.size.height+10/568.0*ScreenHeigth, alertView.frame.size.width-30, 38/568.0*ScreenHeigth)];
        _textField.placeholder = @"请输入登录密码";
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.secureTextEntry = YES;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_textField becomeFirstResponder];
        _textField.font = [UIFont systemFontOfSize:14];
        [backGroundView addSubview:_textField];
        
        if (self.authStyle == 1) {
            infolab.text = @"验证管理密码";
            _textField.placeholder = @"请输入管理密码";
            self.authStyle = 0;
        }
        
        
        UILabel * linelab = [[UILabel alloc] initWithFrame:CGRectMake(0, infolab.frame.size.height, alertView.bounds.size.width, 1)];
        linelab.backgroundColor = RGBACOLOR(210, 0, 11, 1);
        linelab.alpha=0;
        [alertView addSubview:linelab];
        
        UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
        leftButton.frame =CGRectMake(0, alertView.frame.size.height-alertView.frame.size.height/4, alertView.frame.size.width/2, alertView.frame.size.height/4);
        leftButton.tag = 10086;
        leftButton.backgroundColor = [UIColor clearColor];
        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(authClick:) forControlEvents:UIControlEventTouchUpInside];
        [alertView addSubview:leftButton];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(alertView.frame.size.width/2-1, alertView.frame.size.height-alertView.frame.size.height/4, 1, alertView.frame.size.height/4+10)];
        lineView.backgroundColor=RGBACOLOR(210, 0, 11, 1);
        lineView.alpha=0.5;
        [alertView addSubview:lineView];
        
        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        rightButton.frame =CGRectMake(alertView.frame.size.width/2, alertView.frame.size.height-alertView.frame.size.height/4, alertView.bounds.size.width/2, alertView.frame.size.height/4);
        rightButton.tag = 10087;
        rightButton.backgroundColor =[UIColor clearColor];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton setTitle:@"验证" forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(authClick:) forControlEvents:UIControlEventTouchUpInside];
        [alertView addSubview:rightButton];
        
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            alertView.alpha=1;
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)showOrderAlertWithTitle:(NSString    *)aTitle   DataArray:(NSMutableArray  *)aArray   isMoney:(BOOL)isMoney  DefaultSelect:(int)aIndex Unit:(NSString *)unit
{
    selectMoneyIndex = aIndex;
    
    NSMutableArray  *aInfoArray = [NSMutableArray arrayWithCapacity:0];
    
    if (isMoney == 0) {
        for (int i = 0; i<aArray.count; i++) {
                [aInfoArray addObject:[NSString stringWithFormat:@"%@%.2f",unit,[aArray[i] floatValue]]];
    }
    }
    else{
        for (int i = 0; i<aArray.count; i++) {
            [aInfoArray addObject:[NSString stringWithFormat:@"%@%.0f积分",unit,[aArray[i] floatValue]]];
        }
    }
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    NSArray * array = [[UIApplication sharedApplication] windows];
    
    if (array.count >= 2) {
        
        window = [array objectAtIndex:1];
        
    }
    
    if(_coverView==nil)
    {
        _coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
        _coverView.backgroundColor=[UIColor blackColor];
        _coverView.alpha=0.7;
        [window addSubview:_coverView];
        
        
        alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _coverView.bounds.size.width-60, 10+15+10+20*6+5+10)];
        alertView.center=CGPointMake(ScreenWidth/2, ScreenHeigth/2-30);
        alertView.backgroundColor = [UIColor whiteColor];
        alertView.layer.cornerRadius = 8;
        alertView.alpha=1;
        alertView.layer.masksToBounds = YES;
        
        
        UILabel * titlelab = [[UILabel alloc] initWithFrame:CGRectMake(17, 7, alertView.bounds.size.width-17*2, 15)];
        titlelab.numberOfLines = 1;
        titlelab.textAlignment=NSTextAlignmentCenter;
        titlelab.font = [UIFont systemFontOfSize:10];
        titlelab.backgroundColor = [UIColor clearColor];
        titlelab.text = aTitle;
        titlelab.textColor = Color_gray;
        [alertView addSubview:titlelab];
        
        
        for (int i = 0 ; i < 3; i++) {
            for (int j = 0; j < 2; j++) {
                if (i*2+j < aInfoArray.count) {
                    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame=CGRectMake((alertView.bounds.size.width-(alertView.frame.size.width/5*2)*2)/3*(j+1)+j*(alertView.frame.size.width/5*2), 44+i*40, (alertView.frame.size.width/5*2), 26);
                    button.backgroundColor=[UIColor clearColor];
                    button.tag=10088+(i*2+j);
                    [button setTitleColor:Color_gray forState:UIControlStateNormal];
                    [button setTitle:aInfoArray[i*2+j] forState:UIControlStateNormal];
                    button.clipsToBounds = YES;
                    button.layer.cornerRadius = 3;
                    button.titleLabel.font = [UIFont systemFontOfSize:15];
                    [button addTarget:self action:@selector(orderChoose:) forControlEvents:UIControlEventTouchUpInside];
                    [alertView addSubview:button];
                    
                    if (aIndex == i*2+j) {
                        button.backgroundColor = AlertColor;
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }
                    
                    if (unit.length > 1) {
                        button.titleLabel.font = [UIFont systemFontOfSize:13];
                    }
                }
            }
        }
        
        
        _linelab = [[UILabel alloc] initWithFrame:CGRectMake(0, alertView.frame.size.height+alertView.frame.origin.y-20, alertView.bounds.size.width, 20+40)];
        _linelab.center = CGPointMake(ScreenWidth/2, _linelab.center.y);
        _linelab.backgroundColor = AlertColor;
        _linelab.alpha=1;
        _linelab.clipsToBounds = YES;
        _linelab.userInteractionEnabled = YES;
        _linelab.layer.cornerRadius = 8;
        [window addSubview:_linelab];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 20, alertView.frame.size.width, 40);
        button.backgroundColor=[UIColor clearColor];
        button.tag=10086;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(orderClick:) forControlEvents:UIControlEventTouchUpInside];
        [_linelab addSubview:button];
        
        [window addSubview:alertView];
    }
}



-(void)showOrderAlertWithTitle:(NSString    *)aTitle   DataArray:(NSMutableArray  *)aArray DefaultSelect:(int)aIndex Unit:(NSString *)unit
{
    selectMoneyIndex = aIndex;
    
    NSMutableArray  *aInfoArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<aArray.count; i++) {
            [aInfoArray addObject:[NSString stringWithFormat:@"%.0f%@",[aArray[i] floatValue],unit]];
        }
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    NSArray * array = [[UIApplication sharedApplication] windows];
    
    if (array.count >= 2) {
        
        window = [array objectAtIndex:1];
        
    }
    
    if(_coverView==nil)
    {
        _coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
        _coverView.backgroundColor=[UIColor blackColor];
        _coverView.alpha=0.7;
        [window addSubview:_coverView];
        
        int  lineNum = aArray.count%2==0? (int)aArray.count/2:(int)array.count/2+1;
        CGFloat alertViewHeight = 10+15+10 + lineNum*40 +5+10;
        
        alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _coverView.bounds.size.width-60, alertViewHeight)];
        alertView.center=CGPointMake(ScreenWidth/2, ScreenHeigth/2-30);
        alertView.backgroundColor = [UIColor whiteColor];
        alertView.layer.cornerRadius = 8;
        alertView.alpha=1;
        alertView.layer.masksToBounds = YES;
        
        
        UILabel * titlelab = [[UILabel alloc] initWithFrame:CGRectMake(17, 7, alertView.bounds.size.width-17*2, 15)];
        titlelab.numberOfLines = 1;
        titlelab.textAlignment=NSTextAlignmentCenter;
        titlelab.font = [UIFont systemFontOfSize:10];
        titlelab.backgroundColor = [UIColor clearColor];
        titlelab.text = aTitle;
        titlelab.textColor = Color_gray;
        [alertView addSubview:titlelab];
        
        
        for (int i = 0 ; i < 3; i++) {
            for (int j = 0; j < 2; j++) {
                if (i*2+j < aInfoArray.count) {
                    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame=CGRectMake((alertView.bounds.size.width-(alertView.frame.size.width/5*2)*2)/3*(j+1)+j*(alertView.frame.size.width/5*2), 44+i*40, (alertView.frame.size.width/5*2), 26);
                    button.backgroundColor=[UIColor clearColor];
                    button.tag=10088+(i*2+j);
                    [button setTitleColor:Color_gray forState:UIControlStateNormal];
                    [button setTitle:aInfoArray[i*2+j] forState:UIControlStateNormal];
                    button.clipsToBounds = YES;
                    button.layer.cornerRadius = 3;
                    button.titleLabel.font = [UIFont systemFontOfSize:15];
                    [button addTarget:self action:@selector(orderChoose:) forControlEvents:UIControlEventTouchUpInside];
                    [alertView addSubview:button];
                    
                    if (aIndex == i*2+j) {
                        button.backgroundColor = AlertColor;
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }
                    
                    if (unit.length > 1) {
                        button.titleLabel.font = [UIFont systemFontOfSize:13];
                    }
                }
            }
        }
        
        
        _linelab = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(alertView.frame)-20, alertView.bounds.size.width, 20+40)];
        _linelab.center = CGPointMake(ScreenWidth/2, _linelab.center.y);
        _linelab.backgroundColor = AlertColor;
        _linelab.alpha=1;
        _linelab.clipsToBounds = YES;
        _linelab.userInteractionEnabled = YES;
        _linelab.layer.cornerRadius = 8;
        [window addSubview:_linelab];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 20, alertView.frame.size.width, 40);
        button.backgroundColor=[UIColor clearColor];
        button.tag=10086;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(orderClick:) forControlEvents:UIControlEventTouchUpInside];
        [_linelab addSubview:button];
        
        [window addSubview:alertView];
    }
}


-(void)orderChoose:(UIButton *)btn{
    for (int i = 0 ; i < 6; i++) {
        UIButton *button = (UIButton *)[alertView viewWithTag:10088+i];
        button.backgroundColor = [UIColor clearColor];
        [button setTitleColor:Color_gray forState:UIControlStateNormal];
    }
    
    btn.backgroundColor = CanSelectButBackColor;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    selectMoneyIndex = (int)btn.tag - 10088;
}

-(void)orderClick:(UIButton *)btn
{
    [alertView removeFromSuperview];
    [_coverView removeFromSuperview];
    [_linelab removeFromSuperview];
    _coverView = nil;
    alertView = nil;
    _linelab = nil;
    self.orderClick((int)selectMoneyIndex);
    
}

-(void)alertClick:(UIButton *)btn
{
    [alertView removeFromSuperview];
    [_coverView removeFromSuperview];
    [_linelab removeFromSuperview];
    _coverView = nil;
    alertView = nil;
    _linelab = nil;
    self.alertClick((int)btn.tag);
}

-(void)authClick :(UIButton *)btn
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    [alertView removeFromSuperview];
    [_coverView removeFromSuperview];
    _coverView=nil;
    alertView=nil;
    self.authClick((int)btn.tag,_textField.text);
    
}

+(BOOL)checkMoney:(UITextField *)tf{
    NSString *str = tf.text;
    int count = 0;
    for(int i = 0 ; i < tf.text.length ; i++){
        if ([[str substringToIndex:1] isEqualToString:@"."]) {
            count ++;
        }
        str = [str substringFromIndex:1];
    }
    
    if (count>1) {
        [[UIEngine sharedInstance] showAlertWithTitle:@"金额输入有误" ButtonNumber:1 FirstButtonTitle:@"确认" SecondButtonTitle:@""];
        [UIEngine sharedInstance].alertClick = ^(int aIndex){
            tf.text = @"";
        };
    }
    if (count>1) {
        return NO;
    }
    else{
        return YES;
    }
}


+(UIViewController *)getCurrentRootViewController {
    
    UIViewController *result;

    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    
    if (topWindow.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows){
            if (topWindow.windowLevel == UIWindowLevelNormal)   break;
        }
    }
    
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    
    id nextResponder = [rootView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) result = nextResponder;
    
    else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil)
        result = topWindow.rootViewController;
    else
        NSAssert(NO, @"ShareKit: Could not find a root view controller. You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");
    
    return result; 
    
}

-(void)showAlertWithType:(int)aType ButtonNum:(int)aButtonNum LeftTitle:(NSString *)aLeftTitle RightTitle:(NSString *)aRightTitle{
    if (_alert != nil) return;
    UIEngine *selfPage = self;
    _alert = [[Alert alloc]initWithButtonNum:aButtonNum
                                  FirstTitle:aLeftTitle
                                 SecondTitle:aRightTitle
                                     Message:nil
                                   AlertType:aType
                              AlertErrorType:AlertErrorTypeOrder
                           ErrorTitleMessage:@""
                                ErrorMessage:@""
                                  ErrorMoney:@""
                               ErrorIntegral:@""
                              ErrorMoneyUnit:@""];
    _alert.alertClick = ^(UIButton *btn){
        selfPage.alertClick((int)btn.tag);
        selfPage.alert = nil;
    };
    [[DataUsedEngine getWindow] addSubview:_alert];
}

#pragma mark 行情异常
//行情异常下单
-(void)showAlertWithOrderWithTitle:(NSString *)aTitle Message:(NSString *)aMessage{
    if (_alert != nil) return;
    UIEngine *selfPage = self;
    _alert = [[Alert alloc]initWithButtonNum:1
                                        FirstTitle:@"确定"
                                       SecondTitle:@""
                                           Message:nil
                                         AlertType:AlertError
                                    AlertErrorType:AlertErrorTypeOrder
                                 ErrorTitleMessage:aTitle
                                      ErrorMessage:aMessage
                                        ErrorMoney:@""
                                     ErrorIntegral:@""
                                    ErrorMoneyUnit:@""];
    _alert.alertClick = ^(UIButton *btn){
        selfPage.alertClick((int)btn.tag);
        selfPage.alert = nil;
    };
    [[DataUsedEngine getWindow] addSubview:_alert];
}
//行情异常平仓
-(void)showAlertWithSellingWithTitle:(NSString *)aTitle Message:(NSString *)aMessage Money:(NSString *)aMoney MoneyUnit:(NSString *)aMoneyUnit Integral:(NSString *)aIntegral{
    if (_alert != nil) return;
    UIEngine *selfPage = self;
    _alert = [[Alert alloc]initWithButtonNum:2
                                        FirstTitle:@"取消"
                                       SecondTitle:@"继续平仓"
                                           Message:nil
                                         AlertType:AlertError
                                    AlertErrorType:AlertErrorTypeSelling
                                 ErrorTitleMessage:aTitle
                                      ErrorMessage:aMessage
                                        ErrorMoney:aMoney
                                     ErrorIntegral:aIntegral
                                    ErrorMoneyUnit:aMoneyUnit];
    _alert.alertClick = ^(UIButton *btn){
        selfPage.alertClick((int)btn.tag);
        selfPage.alert = nil;
    };
    [[DataUsedEngine getWindow] addSubview:_alert];
}



@end
