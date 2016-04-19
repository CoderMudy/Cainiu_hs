//
//  PlayDescriptionController.m
//  hs
//
//  Created by RGZ on 15/12/14.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "PlayDescriptionController.h"

@interface PlayDescriptionController ()

@end

@implementation PlayDescriptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadNav];
    
    [self loadWeb];
}

-(void)loadNav{
    self.view.backgroundColor = Color_black;
    
    UILabel *titleLabel         = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    titleLabel.font             = [UIFont systemFontOfSize:15];
    titleLabel.text             = [NSString stringWithFormat:@"%@交易规则",self.name];
    titleLabel.center           = CGPointMake(self.view.center.x, 20+22);
    titleLabel.textColor        = Color_Gold;
    titleLabel.textAlignment    = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    [self.view addSubview:titleLabel];
    
    UIImage *leftButtonImage            = [UIImage imageNamed:@"return_1.png"];
    UIButton *leftButton                = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [leftButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchDown];
    [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    leftButton.titleLabel.shadowColor   = RGBACOLOR(117,38,0,1.0f);
    leftButton.titleLabel.shadowOffset  = CGSizeMake(0, -1);
    leftButton.titleLabel.textColor     = [UIColor whiteColor];
    
    UIImageView *imageView      = [[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                               44/2-leftButtonImage.size.height/2,
                                                                               leftButtonImage.size.width,
                                                                               leftButtonImage.size.height)];
    imageView.image             = [UIImage imageNamed:@"return_1"];
    imageView.center            = leftButton.center;
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backClick)];
    [imageView addGestureRecognizer:tap];
    [self.view addSubview:leftButton];
    
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadWeb{
    UIWebView *webView      = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64)];
    webView.backgroundColor = Color_black;
    [self.view addSubview:webView];
    NSString *urlStr = @"";
    if ([self.productModel.loddyType isEqualToString:@"3"]) {
        urlStr = [NSString stringWithFormat:@"http://%@/activity/entertainmentRule.html",HTTP_IP];
    }
    else{
        urlStr = [NSString stringWithFormat:@"http://%@/activity/%@TradeRule.html",HTTP_IP,self.code];
    }
    NSURLRequest *request   = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [webView loadRequest:request];
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
