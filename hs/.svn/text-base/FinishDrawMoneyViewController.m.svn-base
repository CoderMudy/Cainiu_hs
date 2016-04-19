//
//  FinishDrawMoneyViewController.m
//  hs
//
//  Created by 杨永刚 on 15/5/27.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "FinishDrawMoneyViewController.h"

@interface FinishDrawMoneyViewController ()

@end

@implementation FinishDrawMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavLeftBut:NSPushRootMode];
    
    self.isChargeMoney == YES ? [self setNavTitle:@"充值结果"]:[self setNavTitle:@"申请成功"];
    [self initUI];
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *image = [UIImage imageNamed:@"background_05.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth, (ScreenHeigth-64-10)/2-5)];
    imageView.image = image;
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH(imageView), 40)];
    [label setTextColor:[UIColor whiteColor]];
    self.isChargeMoney == YES ? [label setText:[NSString stringWithFormat:@"您已成功充值%@元",self.moneyStr]]:[label setText:[NSString stringWithFormat:@"成功申请提现%@元",self.moneyStr]];
    [label setFont:[UIFont boldSystemFontOfSize:22]];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.center = CGPointMake(imageView.center.x, imageView.center.y-22);
    [imageView addSubview:label];
    
    NSString *niu = @"";
    
#if defined (CAINIUA)
    niu = NIUA;
    
#elif defined (NIUAAPPSTORE)
    niu = NIUA;
#else
    niu = CAINIU;
#endif
    
    UILabel *predictLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Y(label)+HEIGHT(label), WIDTH(imageView), 20)];
    [predictLabel setTextColor:[UIColor whiteColor]];
    self.isChargeMoney == YES ? [predictLabel setText:[NSString stringWithFormat:@"%@助力，最低200元即可玩转股市",niu]]:[predictLabel setText:@"预计1到2个工作日内到账"];
    [predictLabel setTextAlignment:NSTextAlignmentCenter];
    [predictLabel setFont:[UIFont systemFontOfSize:15]];
    [imageView addSubview:predictLabel];
    
    UIButton *bottomBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBut setFrame:CGRectMake(20, Y(imageView)+HEIGHT(imageView)+20, WIDTH(self.view)-40, 44)];
    [bottomBut setBackgroundColor:CanSelectButBackColor];
    [bottomBut.titleLabel setFont:[UIFont systemFontOfSize:18]];
    self.isChargeMoney == YES ? [bottomBut setTitle:@"返回" forState:UIControlStateNormal]:[bottomBut setTitle:@"完成申请" forState:UIControlStateNormal];
    bottomBut.layer.cornerRadius = 5.0;
    [self.view addSubview:bottomBut];
    bottomBut.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return [RACSignal empty];
    }];
    
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
