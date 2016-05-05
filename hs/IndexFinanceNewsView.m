//
//  IndexFinanceNewsView.m
//  hs
//
//  Created by PXJ on 16/5/5.
//  Copyright © 2016年 luckin. All rights reserved.
//
#import "IndexFinanceNewsView.h"

@implementation IndexFinanceNewsView
{

    CGFloat _webViewHeight;
}
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Color_black;
        float  spPercent = 5;
        if (ScreenHeigth <= 568 && ScreenHeigth > 480) {
            spPercent = 4.5;
        }
        else if (ScreenHeigth <= 480){
            spPercent = 4.0;
        }
        float startHeight = ScreenHeigth/spPercent ;

        _webViewHeight = ScreenHeigth-startHeight-40;
        [self initUI];
        [self initTitleView];
    }
    return self;
}

- (void)initUI
{
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _webViewHeight)];
    NSString * urlStr = [NSString stringWithFormat:@"http://stock.luckin.cn/mobi/news_jin10.html"];
    [self addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    
}
- (void)initTitleView
{
    UIView  *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1.5)];
    lineView.backgroundColor = Color_Gold;
    [self addSubview:lineView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 5, 36, 13);
    [closeButton setImage:[UIImage imageNamed:@"tactics_Close"] forState:UIControlStateNormal];
    closeButton.center = CGPointMake(self.frame.size.width/2, closeButton.frame.size.height/2);
    [closeButton addTarget:self action:@selector(closeFinanceNewsView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    
    UIButton *closeButton_enlargeClick = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton_enlargeClick.frame = CGRectMake(0, 0, self.frame.size.width/3, 30);
    closeButton_enlargeClick.center = CGPointMake(self.frame.size.width/2, closeButton_enlargeClick.frame.size.height/2);
    [closeButton_enlargeClick addTarget:self action:@selector(closeFinanceNewsView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton_enlargeClick];
    
    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(closeFinanceNewsView)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionDown;
    [closeButton_enlargeClick addGestureRecognizer: swipeGes];
}
- (void)closeFinanceNewsView
{
    self.close();
}
@end
