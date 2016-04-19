//
//  AboutUsController.m
//  hs
//
//  Created by RGZ on 15/6/10.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "AboutUsController.h"
#import "DetailViewController.h"

#define APPStoreVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]


@interface AboutUsController ()
{
    UIScrollView    *_scrollView;
}
@end

@implementation AboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNav];
    
    [self loadData];
    
    [self loadUI];
}

-(void)loadNav
{
    NavTitle(@"关于我们");
}

-(void)loadData
{
    
}

-(void)loadUI
{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
    _scrollView.backgroundColor =  RGBACOLOR(239, 239, 244, 1);
    _scrollView.indicatorStyle=UIScrollViewIndicatorStyleDefault;
    _scrollView.contentSize=CGSizeMake(ScreenWidth, ScreenHeigth+2);
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.userInteractionEnabled=YES;
    [self.view addSubview:_scrollView];
    
    [self loadContentUI];
}

-(void)loadContentUI
{
    
    //Logo
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 154/5*3, 210/5*3)];
    logoImageView.image = [UIImage imageNamed:@"logo_cainiu"];
    logoImageView.center = CGPointMake(_scrollView.center.x, 40+logoImageView.frame.size.height/2);
    [_scrollView addSubview:logoImageView];
    
    //版本
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, logoImageView.frame.size.height+logoImageView.frame.origin.y+8, ScreenWidth, 22)];
    versionLabel.font = [UIFont systemFontOfSize:15];
    versionLabel.textColor = [UIColor grayColor];
    versionLabel.text = [NSString stringWithFormat:@"版本:%@",APPStoreVersion];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:versionLabel];
    
    //横线
    
    UIView  *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, versionLabel.frame.origin.y+versionLabel.frame.size.height+50, ScreenWidth, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.5;
    [_scrollView addSubview:lineView];
    
    //去AppStore
    UIView  *goAppStoreView = [[UIView alloc]initWithFrame:CGRectMake(0, lineView.frame.origin.y+22, ScreenWidth, 75)];
    goAppStoreView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:goAppStoreView];
    
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 18)];
    headerLabel.font = [UIFont systemFontOfSize:12];
    headerLabel.textColor = RGBACOLOR(240, 81, 40, 1);
    headerLabel.text = @"得到你们的肯定，是我们不断前进的动力。";
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [goAppStoreView addSubview:headerLabel];
    
    UILabel *middleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, headerLabel.frame.origin.y+headerLabel.frame.size.height, ScreenWidth, 25)];
    middleLabel.font = [UIFont systemFontOfSize:18];
    middleLabel.textColor = RGBACOLOR(240, 81, 40, 1);
    middleLabel.text = @"请赏我们一个给力的评分吧~";
    middleLabel.textAlignment = NSTextAlignmentCenter;
    [goAppStoreView addSubview:middleLabel];
    
    UILabel *footerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, middleLabel.frame.origin.y+middleLabel.frame.size.height, ScreenWidth, 15)];
    footerLabel.font = [UIFont systemFontOfSize:11];
    footerLabel.textColor = RGBACOLOR(240, 81, 40, 1);
    footerLabel.text = @"点我点我";
    footerLabel.textAlignment = NSTextAlignmentCenter;
    [goAppStoreView addSubview:footerLabel];
    
    
    //去AppStore
    UITapGestureRecognizer *goAppStoreTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goAppStore)];
    [goAppStoreView addGestureRecognizer:goAppStoreTap];
    
    //版权
    
    NSString *niu = @"";
    NSString *url = @"";
    
    #if defined (CAINIUA)
    niu = NIUA;
    url = @"http://www.luckin.cn";
    
    #elif defined (NIUAAPPSTORE)
    niu = NIUA;
    url = @"http://www.luckin.cn";
   
    #else
    niu = CAINIU;
    url = @"http://www.cainiu.com";
    #endif
    
    UILabel *copyRightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ScreenHeigth-30-64-12, ScreenWidth, 30)];
    copyRightLabel.textColor = [UIColor grayColor];
    copyRightLabel.font = [UIFont systemFontOfSize:10];
    copyRightLabel.textAlignment = NSTextAlignmentCenter;
    copyRightLabel.numberOfLines = 0;
    copyRightLabel.text          = [NSString stringWithFormat:@"版权: %@     官网: %@\n声明: 您通过本软件参加的商业活动，与Apple Inc.无关",niu,url];
    [_scrollView addSubview:copyRightLabel];
}

-(void)goAppStore
{
    NSString *appleID = @"999750777";
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0) {
        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appleID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    } else {
        NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appleID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
