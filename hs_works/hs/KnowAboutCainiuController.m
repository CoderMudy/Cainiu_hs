//
//  KnowAboutCainiuController.m
//  hs
//
//  Created by RGZ on 16/1/8.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "KnowAboutCainiuController.h"

@interface KnowAboutCainiuController ()
{
    UILabel     *_titleLab;
}
@end

@implementation KnowAboutCainiuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadNav];
    [self loadWeb];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
}

-(void)loadNav{
    Self_AddNavBGGround;
    NSString *titleStr = [NSString stringWithFormat:@"了解%@",App_appShortName];
    Self_AddNavTitle(titleStr);
    Self_AddNavLeftImg(@"return_1");
    
    _titleLab = titleLab;
}

-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadWeb{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/activity/aboutus.html",HTTP_IP]]];
    [self.webView loadRequest:request];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    _titleLab.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
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
