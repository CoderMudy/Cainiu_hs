//
//  SpreadApplyPage.m
//  hs
//
//  Created by PXJ on 15/10/22.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "SpreadApplyPage.h"
#import "ApplyReasonPage.h"

#define applyColor K_COLOR_CUSTEM(176, 0, 14, 1)
#define ImageV_1_height 248.5*ScreenHeigth/667
#define ImageV_1_width (ImageV_1_height)*534/497

#define ImageV_2_height 222.5*ScreenHeigth/667
#define ImageV_2_width (ImageV_2_height)*600/445

#define applyBtn_height 45.5*ScreenHeigth/667
#define applyBtn_width (applyBtn_height)*670/90

#define applyBtn_Tag 20000
#define remindLab_Tag 25000

@interface SpreadApplyPage ()

@end

@implementation SpreadApplyPage

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self loadButtonTitle];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
- (void)initUI
{
    
    self.view.backgroundColor = applyColor;
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 44, 44)];
    [leftButton addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchDown];
    [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    leftButton.titleLabel.shadowColor = RGBACOLOR(117,38,0,1.0f);
    leftButton.titleLabel.shadowOffset= CGSizeMake(0, -1);
    leftButton.titleLabel.textColor = [UIColor whiteColor];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"return_1.png"] forState:UIControlStateNormal];
    [self.view addSubview:leftButton];

    UIImageView * imageV_1 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-ImageV_1_width)/2, 44, ImageV_1_width, ImageV_1_height)];
    imageV_1.image = [UIImage imageNamed:@"spread_1"];
    [self.view addSubview:imageV_1];
    
    UIImageView * imageV_2 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-ImageV_2_width)/2, imageV_1.frame.size.height+imageV_1.frame.origin.y+35*ScreenHeigth/667, ImageV_2_width, ImageV_2_height)];
    imageV_2.image = [UIImage imageNamed:@"spread_2"];
    [self.view addSubview:imageV_2];
    
    
    UIImageView * imageV_btn = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-applyBtn_width)/2, imageV_2.frame.origin.y+imageV_2.frame.size.height+30*ScreenHeigth/667, applyBtn_width, applyBtn_height)];
    
    imageV_btn.image = [UIImage imageNamed:@"spread_3"];
    [self.view addSubview:imageV_btn];
    
    UIButton * applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    applyBtn.tag = applyBtn_Tag;
    applyBtn.frame = CGRectMake((ScreenWidth-applyBtn_width)/2, imageV_2.frame.origin.y+imageV_2.frame.size.height+30*ScreenHeigth/667, applyBtn_width, applyBtn_height);
    [applyBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [applyBtn setBackgroundImage:[UIImage imageNamed:@"spread_3"] forState:UIControlStateNormal];
    [applyBtn setTitleColor:K_COLOR_CUSTEM(63, 63, 63, 1) forState:UIControlStateNormal];
    [applyBtn addTarget:self action:@selector(applySpread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyBtn];
    
    
    UILabel * remindLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(applyBtn.frame), ScreenWidth, 20)];
    remindLab.textColor = [UIColor whiteColor];
    remindLab.hidden = YES;
    remindLab.tag = remindLab_Tag;
    remindLab.text = @"审核未通过，如有疑问请联系客服";
    remindLab.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    remindLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:remindLab];
    
}
- (void)loadButtonTitle
{
    UIButton * applyBtn = (UIButton*)[self.view viewWithTag:applyBtn_Tag];
    UILabel * remindLab = (UILabel*)[self.view viewWithTag:remindLab_Tag];
    remindLab.hidden = YES;
    switch (self.userSpreadStyle) {
        case UserSpreadUnableApply:case UserSpreadGetMoney:
        {
            [applyBtn setTitle:@"申请成为合伙人" forState:UIControlStateNormal];
            applyBtn.enabled = YES;
        }
            
            break;
        case UserSpreadApply:
        {
            [applyBtn setTitle:@"申请成为合伙人" forState:UIControlStateNormal];
            applyBtn.enabled = YES;
        }
        
            break;
        case UserSpreadChecking:
        {
            [applyBtn setTitle:[NSString stringWithFormat:@"%@合伙人审核中",App_appShortName] forState:UIControlStateNormal];
            applyBtn.enabled = NO;
        }
            
            break;
        case UserSpreadUnAgree:
        {
            [applyBtn setTitle:@"重新申请成为合伙人" forState:UIControlStateNormal];
            applyBtn.enabled = YES;
            remindLab.hidden = NO;

        }
            
            break;
        case  userSpread:
        {
            [applyBtn setTitle:@"申请推广员成功" forState:UIControlStateNormal];
            applyBtn.enabled = NO;
        }break;
        default:
        {
            [applyBtn setTitle:@"" forState:UIControlStateNormal];
            applyBtn.enabled = NO;
        }
            break;
    }

}
- (void)applySpread
{
    switch (self.userSpreadStyle) {
        case UserSpreadUnableApply:
        {
            PopUpView * popView = [[PopUpView alloc] initShowAlertWithShowText:@"尚未满足申请条件" setBtnTitleArray:@[@"确定"]];
            popView.confirmClick = ^(UIButton * button){
                
            };
            [self.navigationController.view addSubview:popView];
            
        }
            break;
        case UserSpreadGetMoney:
        {
        
            PopUpView * popView = [[PopUpView alloc] initShowAlertWithShowText:@"您还有奖励未领取\n请领完奖励再来申请吧！" setBtnTitleArray:@[@"确定"]];
            popView.confirmClick = ^(UIButton * button){
                [self.navigationController popViewControllerAnimated:YES];
            };
            [self.navigationController.view addSubview:popView];
            
        }
            break;
        case UserSpreadApply:case UserSpreadUnAgree:
//满足条件可以直接申请,被拒绝后重新申请
        {
            
            ApplyReasonPage * VC = [[ApplyReasonPage alloc] init];
            VC.superVC = self;
            [self.navigationController pushViewController:VC animated:YES];
        
        
        }
            break;
        
        default:
            break;
    }
    
    

}
- (void)leftButtonPressed
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
