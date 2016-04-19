//
//  HolidayPopView.m
//  hs
//
//  Created by PXJ on 16/1/14.
//  Copyright © 2016年 luckin. All rights reserved.
//
#define exitImgLength 29.0
#define lineHeight ScreenWidth * 29/375.0

#define adImgWidth  (ScreenWidth-40)
#define adImgHeight (ScreenWidth-40)*1218.00/916
#define lineView_Tag    1100


#import "HolidayPopView.h"

@implementation HolidayPopView
{
    UIScrollView *_scrollView;
    UIView       *_backgroundView;
    UIView       *_coverView;
    UIView       *_animationView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    
    
    _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeigth)];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0.7;
    [self addSubview:_backgroundView];
    
    //    UITapGestureRecognizer * tapRecogizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAdView)];
    //    [_backgroundView addGestureRecognizer:tapRecogizer];
    UIImageView *exitImg = [[UIImageView alloc]init];
    
    exitImg.center = CGPointMake(ScreenWidth-27, 42);
    exitImg.bounds = CGRectMake(0, 0, exitImgLength, exitImgLength);
    exitImg.image = [UIImage imageNamed:@"ad_close"];
    exitImg.alpha = 1;
    exitImg.userInteractionEnabled = YES;
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    exitButton.center = exitImg.center;
    exitButton.bounds = CGRectMake(0, 0, 44, 44);
    [exitButton addTarget:self action:@selector(closeHolidayView) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc]init ];
    lineView.tag = lineView_Tag;
    lineView.center = CGPointMake(exitImg.center.x,CGRectGetMaxY(exitButton.frame)+lineHeight/2-5);
    lineView.bounds = CGRectMake(0, 0, 1, lineHeight+5);
    lineView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:exitImg];
    [self addSubview:exitButton];
    [self addSubview:lineView];
    
    
    _coverView = [[UIView alloc] initWithFrame:CGRectMake(20, lineView.frame.origin.y+lineHeight, adImgWidth, adImgHeight)];
    _coverView.layer.masksToBounds = YES;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, adImgWidth, adImgHeight)];
    imageView.image = [UIImage imageNamed:@"foyer_13"];
    [_coverView addSubview:imageView];
    
    UIButton * goHolidayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goHolidayBtn.center = CGPointMake(adImgWidth/2, adImgHeight*9/10);
    goHolidayBtn.bounds = CGRectMake(0, 0, adImgWidth-50, adImgHeight/10);
    goHolidayBtn.backgroundColor = K_color_red;
    goHolidayBtn.layer.masksToBounds = YES;
    goHolidayBtn.layer.cornerRadius  = 5;
    [goHolidayBtn.titleLabel setFont:FontSize(14)];
    [goHolidayBtn setTitle:@"立即参加" forState:UIControlStateNormal];
    [goHolidayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goHolidayBtn addTarget:self action:@selector(goHolidayPage) forControlEvents:UIControlEventTouchUpInside];
    [_coverView addSubview:goHolidayBtn];
    [self addSubview:_coverView];
    
}
- (void)goHolidayPage
{
    self.goHolidayBlock();
}
- (void)showHolidayPopView:(BOOL)show;
{

}
-(void)closeHolidayView{
    
    
    [self unloginViewHidden:YES];
}

- (void)unloginViewHidden:(BOOL)hidden
{
    if (self.hidden==hidden) {
        return;
    }
    if (hidden) {
        //广告隐藏
        
        NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(coverViewHidden:) userInfo:nil repeats:YES];
        [timer fire];
    }
    else
    {
     
        _coverView.alpha = 0;
        self.hidden = NO;
        UIView * lineView = [self viewWithTag:lineView_Tag];
        lineView.frame = CGRectMake(ScreenWidth-28+0.5, 42+exitImgLength/2, 1, 0);
        NSTimer * lineTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(lineShow:) userInfo:nil repeats:YES];
        [lineTimer fire];
        [UIView animateWithDuration:1 animations:^{
            _coverView.alpha = 1;

        }];
       
    }
}

- (void)coverViewHidden:(NSTimer*)timer
{
    CGRect rect = _coverView.frame;
    CGFloat coverHeight = _coverView.frame.size.height;
    if (coverHeight<=10) {
        self.isShow = NO;
        [self removeFromSuperview];
        [timer invalidate];
        timer = nil;
    }else{
        coverHeight-=10;
        _coverView.frame =CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, coverHeight);
    }
}
- (void)lineShow:(NSTimer *)timer
{
    UIView * lineView = [self viewWithTag:lineView_Tag];
    CGFloat lineViewHeight = lineView.frame.size.height;
    lineViewHeight++;
    if (lineViewHeight >lineHeight+1) {
        [timer invalidate];
        [self coverViewShow];
    }else{
        lineView.frame = CGRectMake(ScreenWidth-28+0.5, 42+exitImgLength/2, 1, lineViewHeight);
        
    }
}
- (void)coverViewShow
{
    [UIView animateWithDuration:1 animations:^{
        _coverView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}


@end
