//
//  DetailViewController.m
//  hs
//
//  Created by RGZ on 15/5/23.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "RulePage.h"

//关于我们
#define URLAboutUs      @"http://www.baidu.com"
@interface RulePage ()
{
    NSString    *_url;
    NSString    *_title;
}
@end

@implementation RulePage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    [self loadNav];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadUI];
}

-(void)loadNav
{
    NavTitle(_title);
}

-(void)loadData
{
    _url=URLAboutUs;
    _title=@"股票T＋1参与规则";
}

-(void)loadUI
{
    [[UIEngine sharedInstance] showProgress];
    [self setNavLeftBut:NSPushMode];
    [self performSelector:@selector(closeProgress) withObject:nil afterDelay:1];
    
    UIWebView   *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
    [self.view addSubview:webView];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [webView loadRequest:request];
}

-(void)closeProgress
{
    [[UIEngine sharedInstance] hideProgress];
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
