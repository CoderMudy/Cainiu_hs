//
//  BankPositionLIstViewController.m
//  hs
//
//  Created by Xse on 15/11/9.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "BankPositionLIstViewController.h"

@interface BankPositionLIstViewController ()

@property(nonatomic,strong) UIScrollView *scrollview;

@end

@implementation BankPositionLIstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)loadUI
{
    //导航栏
    [self setNaviTitle:@"银行卡额度表"];
    [self setBackButton];
    [self setNavibarBackGroundColor:K_color_NavColor];
    
    _scrollview = [[UIScrollView alloc]init];
    _scrollview.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeigth);
    [self.view addSubview:_scrollview];
    
    UIImageView *img = [[UIImageView alloc]init];
    img.image = [UIImage imageNamed:@"bank_list"];
    img.frame = CGRectMake(0, 0, ScreenWidth, 674*ScreenWidth/320*0.9);
    [_scrollview addSubview:img];
    
    _scrollview.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(img.frame) + 64);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
