//
//  WelcomePageView.m
//  hs
//
//  Created by RGZ on 15/6/29.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "WelcomePageView.h"
#import "PageOne.h"
#import "PageTwo.h"
#import "PageThree.h"
#import "PageFour.h"

#define PageOne_Tag  9999
#define PageTwo_Tag  9998
#define PageThree_Tag 9997
#define PageFour_Tag     9996

@implementation WelcomePageView
{
    UIScrollView    *_scrollView ;
    
    UIView          *_pageControlView;
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
        self.backgroundColor = [UIColor whiteColor];
        [self loadUI];
    }
    
    return self;
}

-(void)loadUI{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth - 120*ScreenHeigth/667)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(ScreenWidth*4, ScreenHeigth - 120*ScreenHeigth/667);
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    [self loadPageControl];
    
    [self loadSubViews:LoadPageOne];
    
    UIImageView *loginImageV = [[UIImageView alloc] init];
    loginImageV.userInteractionEnabled =YES;
    loginImageV.image = [UIImage imageNamed:@"log_now_tiyan"];
    loginImageV.frame = CGRectMake(ScreenWidth/2 - 100*ScreenWidth/320/2, CGRectGetMaxY(_scrollView.frame), 100*ScreenWidth/320, 40*ScreenWidth/320);
    [self addSubview:loginImageV];
    
    //立即体验按钮
    UIButton *nowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nowBtn.frame = CGRectMake(ScreenWidth/2 - 100*ScreenWidth/320/2, CGRectGetMaxY(_scrollView.frame), 100*ScreenWidth/320, 40*ScreenWidth/320);
//    [nowBtn setImage:[UIImage imageNamed:@"log_now_tiyan"] forState:UIControlStateNormal];
    [nowBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nowBtn];
}

#pragma mark ScrollView

-(void)loadSubViews:(LoadPage)loadPageType{
    
    switch (loadPageType) {
        case LoadPageOne:
        {
            UIView *view = [_scrollView viewWithTag:PageOne_Tag];
            if (view == nil) {
                PageOne *pageOne = [[PageOne alloc]initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
                pageOne.tag = PageOne_Tag;
                [_scrollView addSubview:pageOne];
            }
        }
            break;
        case LoadPageTwo:
        {
            UIView *view = [_scrollView viewWithTag:PageTwo_Tag];
            if (view == nil) {
                PageTwo *pageTwo = [[PageTwo alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width*1, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
                pageTwo.tag = PageTwo_Tag;
                [_scrollView addSubview:pageTwo];
            }
        }
            break;
        case LoadPageThree:
        {
            UIView *view = [_scrollView viewWithTag:PageThree_Tag];
            if (view == nil) {
                PageThree *pageThree = [[PageThree alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width*2, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
                pageThree.tag = PageThree_Tag;
                [_scrollView addSubview:pageThree];
                
//                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
//                [pageThree addGestureRecognizer:tap];
            }
        }
            break;
        case LoadPageFour:
        {
            [self removeView];
//            UIView *view = [_scrollView viewWithTag:PageFour_Tag];
//            if (view == nil) {
//                PageFour *pageFour = [[PageFour alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width*3, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
//                [pageFour.goMainBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
//                pageFour.tag = PageFour_Tag;
//                [_scrollView addSubview:pageFour];
//            }
        }
            break;
            
        default:
            break;
    }
    
}

- (void)clickAction:(id)sender
{
    [self removeView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //禁止左滑
    if (_scrollView.contentOffset.x<0) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    //禁止右滑
    if (_scrollView.contentOffset.x>_scrollView.frame.size.width*3) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*3, 0) animated:NO];
    }

    //加载滑动到的页面
    if (_scrollView.contentOffset.x == 0 ) {
        [self loadSubViews:LoadPageOne];
    }
    else if (_scrollView.contentOffset.x == _scrollView.frame.size.width){
        [self loadSubViews:LoadPageTwo];
    }
    else if (_scrollView.contentOffset.x == _scrollView.frame.size.width*2){
        [self loadSubViews:LoadPageThree];
    }
    else if (_scrollView.contentOffset.x == _scrollView.frame.size.width*3){
        [self loadSubViews:LoadPageFour];
    }
    
    
    //pageControl的显示问题
//    if (_scrollView.contentOffset.x+_scrollView.frame.size.width-1 >= _scrollView.frame.size.width*3) {
//        _pageControlView.hidden = YES;
//    }else{
//        _pageControlView.hidden = NO;
//    }
    
    
    int page = 10;
    if (_scrollView.contentOffset.x+_scrollView.frame.size.width/2 > 0 && _scrollView.contentOffset.x+_scrollView.frame.size.width/2 < _scrollView.frame.size.width) {
        page = 10;
    }
    else if (_scrollView.contentOffset.x+_scrollView.frame.size.width/2 > _scrollView.frame.size.width && _scrollView.contentOffset.x+_scrollView.frame.size.width/2 < _scrollView.frame.size.width*2){
        page = 11;
    }
    else if (_scrollView.contentOffset.x+_scrollView.frame.size.width/2 > _scrollView.frame.size.width*2 && _scrollView.contentOffset.x+_scrollView.frame.size.width/2 < _scrollView.frame.size.width*3){
        page = 12;
    }
    else if (_scrollView.contentOffset.x+_scrollView.frame.size.width/2 > _scrollView.frame.size.width*3){
        page = 13;
    }
    
    if (page == 13) {
        return;
    }
    
    if (_pageControlView!=nil) {
        for (UIView *view in _pageControlView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)view;
                btn.selected =NO;
            }
        }
        UIButton *pageControlBtn = (UIButton *)[_pageControlView viewWithTag:page];
        pageControlBtn.selected = YES;
    }
    
    
    
}

-(void)removeView{
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
}

#pragma mark PageControl

-(void)loadPageControl{
    _pageControlView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeigth-45.0/568*ScreenHeigth, ScreenWidth, 10)];
    [self addSubview:_pageControlView];
    
    for (int i = 0; i<3; i++) {
        UIButton  *pageControl = [UIButton buttonWithType:UIButtonTypeCustom];
        pageControl.frame = CGRectMake(ScreenWidth/2-26.0/320*ScreenWidth+i*8+15.0/320*ScreenWidth*i, 1, 8, 8);
        [pageControl setImage:[UIImage imageNamed:@"welcome_14"] forState:UIControlStateSelected];
        [pageControl setImage:[UIImage imageNamed:@"welcome_13"] forState:UIControlStateNormal];
        pageControl.clipsToBounds = YES;
        pageControl.layer.cornerRadius = 4;
        pageControl.tag = i+10;
        [_pageControlView addSubview:pageControl];
        
        if (i==0) {
            pageControl.selected = YES;
        }
        else{
            pageControl.selected = NO;
        }
    }
}

@end
