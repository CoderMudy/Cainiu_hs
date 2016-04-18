//
//  UnLoginView.m
//  Test
//
//  Created by RGZ on 15/7/13.
//  Copyright (c) 2015年 RGZ. All rights reserved.
//

#import "UnLoginView.h"
#import "UIImageView+WebCache.h"


#define exitImgLength 29.0
#define lineHeight ScreenWidth * 29/375.0

#define adImgWidth  (ScreenWidth-40)
#define adImgHeight (ScreenWidth-40)*1218.00/916

#define ImageUrl1 @"广告1"
#define ImageUrl2 @"广告2"
#define UpdateMark @"middleBanner"
#define AdUrlMark @"url"
#define AdTitle @"title"
#define scrollImgV1_Tag 1000
#define lineView_Tag    1100

#define imgControl_Tag 1200
#define lineTag 99997
#define exitTag 99996
#define UnloginAD  [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/UnloginAD.plist"]]

@implementation UnLoginView
{
    UIScrollView *_scrollView;
    UIView       *_backgroundView;
    UIView       *_pageControlView;
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

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self loadUI];
    }
    
    return self;
}

-(void)loadUI
{
    _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeigth)];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0.7;
    [self addSubview:_backgroundView];
    UIImageView *exitImg = [[UIImageView alloc]init];
    exitImg.center = CGPointMake(ScreenWidth-27, 42);
    exitImg.bounds = CGRectMake(0, 0, exitImgLength, exitImgLength);
    exitImg.image = [UIImage imageNamed:@"ad_close"];
    exitImg.alpha = 1;
    exitImg.userInteractionEnabled = YES;
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    exitButton.center = exitImg.center;
    exitButton.bounds = CGRectMake(0, 0, 44, 44);
    [exitButton addTarget:self action:@selector(closeAdView) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc]init ];
    lineView.tag = lineView_Tag;
    lineView.center = CGPointMake(exitImg.center.x,exitImg.frame.origin.y+exitImgLength);
    lineView.bounds = CGRectMake(0, 0, 1, lineHeight);
    lineView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:exitImg];
    [self addSubview:exitButton];
    [self addSubview:lineView];
    
    
    _coverView = [[UIView alloc] initWithFrame:CGRectMake(20, lineView.frame.origin.y+lineHeight, adImgWidth, adImgHeight+20)];
    [self addSubview:_coverView];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, adImgWidth, adImgHeight)];
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.layer.masksToBounds = YES;
    _scrollView.layer.cornerRadius = 5;
    _scrollView.bounces = NO;
    [_coverView addSubview:_scrollView];
    
    _pageControlView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, adImgWidth, 6)];
    _pageControlView.center = CGPointMake(_scrollView.center.x, _scrollView.frame.size.height +10);
    [_coverView addSubview:_pageControlView];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for (int i = 0; i<scrollView.contentSize.width/scrollView.frame.size.width; i++)
    {
        UIView *view = [_pageControlView viewWithTag:99998+i];
        view.backgroundColor = [UIColor lightGrayColor];
    }
    NSString * num = [NSString stringWithFormat:@"%.0f",scrollView.contentOffset.x/adImgWidth];
    UIView *view = [_pageControlView viewWithTag:99998+num.intValue];
    view.backgroundColor = [UIColor whiteColor];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;      // called when scroll view grinds to a halt
{
    
}
-(void)loadAnimation
{
    UIView *exitView = [_coverView viewWithTag:exitTag];
    UIView *lineView = [_coverView viewWithTag:lineTag];
    _animationView.bounds = CGRectMake(0, 0, _animationView.frame.size.width, 20);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _animationView.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-80, ([UIScreen mainScreen].bounds.size.width-80)/(916.0/1218)+70);
    } completion:^(BOOL finished)
     {
        exitView.alpha = 1;
        lineView.alpha = 1;
    }];
}

-(void)closeAdView{
    [self unloginViewHidden:YES];
}
- (void)unloginViewHidden:(BOOL)hidden
{
    if (!hidden)
    {
        _scrollView.contentOffset = CGPointMake(0, 0);
        for (UIView *subView in _pageControlView.subviews)
        {
            [subView removeFromSuperview];
        }
        for (UIView *subView in _scrollView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    if (self.hidden==hidden)
    {
        return;
    }
    __block CGRect rect =    CGRectMake(20, 42+exitImgLength/2+lineHeight, ScreenWidth-40, (ScreenWidth-40)*1218/916+20);
    if (hidden)
    {
        //广告隐藏
        _coverView.frame = rect;
        NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(coverViewHidden:) userInfo:nil repeats:YES];
        [timer fire];
    }
    else
    {
        NSDictionary * dic = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:UnloginAD]];
        NSArray * listArray = dic[@"news_notice_list"];
        _adNum = (int)listArray.count;
        if (_adNum<=0)
        {
            self.showBtnHidden(YES);
            return;
        }
        self.showBtnHidden(NO);
        self.hidden = hidden;
        _scrollView.frame = CGRectMake(0, 0, ScreenWidth-40, (ScreenWidth-40)*1218/916);
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*_adNum, _scrollView.frame.size.height);
        for (int i = 0; i < self.adNum; i++)
        {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*adImgWidth, 0, adImgWidth, adImgHeight)];
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 5;
            imageView.tag = scrollImgV1_Tag+i;
            [_scrollView addSubview:imageView];
            UIControl * imgControl = [[UIControl alloc] initWithFrame:imageView.frame];
            imgControl.tag = imgControl_Tag+i;
            [imgControl addTarget:self action:@selector(imgClick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:imgControl];
        }
        for (int i=0; i<self.adNum; i++)
        {
            UIImageView * imageV1 = (UIImageView*)[_scrollView viewWithTag:scrollImgV1_Tag+i];
            NSString * url1 =@"";
            if (listArray.count>0)
            {
                url1 =[NSString stringWithFormat:@"%@%@",K_MGLASS_URL,listArray[i][UpdateMark]];
            }
            [imageV1 sd_setImageWithURL:[NSURL URLWithString:url1] placeholderImage:[UIImage imageNamed:@"AdpalceImg"]];
        }
        CGFloat pageStratlength = (adImgWidth-_adNum*6-(_adNum-1)*8)/2;
        for (int i = 0; i < self.adNum; i++)
        {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(pageStratlength+i*(6+8), 0, 6, 6)];
            view.alpha = 0.8;
            if (i==0)
            {
                view.backgroundColor = [UIColor whiteColor];
            }
            else
            {
                view.backgroundColor = [UIColor lightGrayColor];
            }
            view.tag = 99998+i;
            view.clipsToBounds = YES;
            view.layer.cornerRadius = 3;
            [_pageControlView addSubview:view];
        }
        self.alpha = 0;
        self.hidden = NO;
        _coverView.frame = rect;
        _coverView.alpha = 0;
        UIView * lineView = [self viewWithTag:lineView_Tag];
        lineView.frame = CGRectMake(ScreenWidth-28+0.5, 42+exitImgLength/2, 1, 0);
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished)
         {
             NSTimer * lineTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(lineShow:) userInfo:nil repeats:YES];
             [lineTimer fire];
         }];
    }
}

- (void)imgClick:(UIControl*)control
{
    
    int num = (int)control.tag-imgControl_Tag;
    NSDictionary * dic = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:UnloginAD]];
    
    NSArray * listArray = dic[@"news_notice_list"];
    NSString *  adUrl;
    NSString * adTitle;
    if (listArray.count<num+1)
    {
        adUrl = @" ";
        adTitle = @" ";
    }else
    {
        adUrl = [NSString stringWithFormat:@"%@",listArray[num][AdUrlMark]==nil?@"":listArray[num][AdUrlMark]];
        adUrl =[NSString stringWithFormat:@"%@%@",K_MGLASS_URL,adUrl];
        adTitle = [NSString stringWithFormat:@"%@",listArray[num][AdTitle]==nil?@"":listArray[num][AdTitle]];
    }
    self.imgClickBlock(adTitle,adUrl);
}
- (void)coverViewHidden:(NSTimer*)timer
{
    CGFloat coverHeight = _scrollView.frame.size.height;
    if (coverHeight<=10)
    {
        self.hidden = YES;
        [timer invalidate];
        [_delegate closePopView];
    }else{
        coverHeight-=10;
        _scrollView.frame =CGRectMake(0, 0, ScreenWidth-40, coverHeight);
    }
}
- (void)coverViewShow
{
    [UIView animateWithDuration:1 animations:^{
        _coverView.alpha = 1;
    } completion:^(BOOL finished)
     {
         
     }];
}
- (void)lineShow:(NSTimer *)timer
{
    UIView * lineView = [self viewWithTag:lineView_Tag];
    CGFloat lineViewHeight = lineView.frame.size.height;
    lineViewHeight++;
    if (lineViewHeight >lineHeight+1)
    {
        [timer invalidate];
        [self coverViewShow];
    }else
    {
        lineView.frame = CGRectMake(ScreenWidth-28+0.5, 42+exitImgLength/2, 1, lineViewHeight);
    }
}

- (void)getAdvert:(NSDictionary *)lastMark needTest:(BOOL)isNeed
{
    __block NSDictionary * lastmark = lastMark?lastMark:@{};
    __block BOOL isNeedTest = isNeed;
    [RequestDataModel requestAdvertSuccessBlock:^(BOOL success, id data)
     {
         if (success)
         {
             NSDictionary * dic = [NSDictionary dictionaryWithDictionary:data];
             [self savetime:dic];
             NSArray   * listArray = dic[@"news_notice_list"]==nil?@[@{UpdateMark:@""}]:dic[@"news_notice_list"];
             NSString * str = @"";
             if(listArray.count>0)
             {
                 str = listArray[0][UpdateMark];
             }
             if(([dic isEqual:lastmark] &&![str isEqualToString:@""])||listArray.count<=0)
             {
                 [_delegate isNeedShowUnLogView:NO];
                 [self unloginViewHidden:isNeedTest];
             }else{
                 [self unloginViewHidden:NO];
                 [_delegate isNeedShowUnLogView:YES];
             }
         }else
         {
             [self unloginViewHidden:isNeedTest];
         }
     }];
}
- (void)savetime:(NSDictionary*)dic
{
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:dic];
    [myData writeToFile:UnloginAD atomically:YES];
}

- (NSDictionary *)getLastCloseAdvert
{
    NSData * myData = [NSData dataWithContentsOfFile:UnloginAD];
    NSDictionary *myDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:myData];
    return myDictionary;
}
#pragma mark 广告是否需要显示
- (void)ADShowNeedTest:(BOOL)isNeedTest;
{
    NSDictionary * lastAdvertMark = [self getLastCloseAdvert];
    [self getAdvert:lastAdvertMark  needTest:isNeedTest];
}


@end
