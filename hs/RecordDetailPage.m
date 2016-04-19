//
//  RecordDetailPage.m
//  hs
//
//  Created by PXJ on 15/7/28.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "RecordDetailPage.h"

@interface RecordDetailPage ()

@end

@implementation RecordDetailPage

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"订单详情"];
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
    
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"订单详情"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color_Gold;
    [self loadNav];
}
#pragma mark Nav

-(void)loadNav{
    self.view.backgroundColor = [UIColor colorWithRed:3/255.0 green:0 blue:20/255.0 alpha:1];
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    
    [self.view addSubview:navView];
    
    //Left Button
    
    UIImage *leftButtonImage = [UIImage imageNamed:@"return_1.png"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 44, 44)];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchDown];
    [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    leftButton.titleLabel.shadowColor = RGBACOLOR(117,38,0,1.0f);
    leftButton.titleLabel.shadowOffset= CGSizeMake(0, -1);
    leftButton.titleLabel.textColor = [UIColor whiteColor];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44/2-leftButtonImage.size.height/2, leftButtonImage.size.width, leftButtonImage.size.height)];
    image.image = [UIImage imageNamed:@"return_1"];
    image.userInteractionEnabled = YES;
    [leftButton addSubview:image];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftButtonClick)];
    [image addGestureRecognizer:tap];
    
    [navView addSubview:leftButton];
    
    
    UILabel * titleLab = [[UILabel alloc] init];
    titleLab.center = CGPointMake(ScreenWidth/2, 22);
    titleLab.bounds = CGRectMake(0, 0, 100, 20);
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = @"订单详情";
    [navView addSubview:titleLab];
    
    
}
-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
