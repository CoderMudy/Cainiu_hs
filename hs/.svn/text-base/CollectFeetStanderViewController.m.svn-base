//
//  CollectFeetStanderViewController.m
//  hs
//
//  Created by Xse on 15/10/24.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "CollectFeetStanderViewController.h"

@interface CollectFeetStanderViewController ()

@end

@implementation CollectFeetStanderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNaviTitle:@"手续费收费标准"];
    [self setNavibarBackGroundColor:K_color_red];
    [self setBackButton];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_1"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    [self loadUI];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)loadUI
{
    UILabel *statndLab = [[UILabel alloc]init];
    statndLab.text = @"手续费收费标准";
    statndLab.font = [UIFont systemFontOfSize:16.0];
    statndLab.frame = CGRectMake(10, 20 + 64, ScreenWidth, 21);
    statndLab.textColor = [UIColor blackColor];
    [self.view addSubview:statndLab];
    
    UILabel *proLabel = [[UILabel alloc]init];
    proLabel.frame = CGRectMake(15, CGRectGetMaxY(statndLab.frame), ScreenWidth - 15*2, 340);
    NSString *attString = [NSString stringWithFormat:@"1、消费用户提款免手续费； \n2、为防止恶意提款，每日提款申请次数最多为2次，超过次日处理； \n3、为防止套现和洗钱，单笔充值无消费者提现时需提供身份证和银行卡给风控进行核实。如信息核实无误，%@将会在7-15个工作日内处理，银行收取2%%的手续费自理，最低2元; \n4、周一至周五09:00-17:00的提款申请当天处理，17:00以后的提款申请延至第二天处理。周五17:00后提款，延至下个工作日处理。提现到账时间最快2小时，最晚1个工作日。 \n5、周六周日提款延迟到周一处理，若节假日提款，一律节后第一个工作日处理",App_appShortName ];
    
    proLabel.textAlignment = NSTextAlignmentLeft;
    proLabel.font = [UIFont systemFontOfSize:14];
    proLabel.numberOfLines = 0;
//    [proLabel sizeToFit];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:attString];
    //创建NSMutableParagraphStyle实例
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    //设置行距
    [style setLineSpacing:10.0f];
    //根据给定长度与style设置attStr式样
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attStr.mutableString.length)];
    proLabel.attributedText = attStr;
    
    proLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.8];
    [self.view addSubview:proLabel];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
