//
//  TransferDetailViewController.m
//  hs
//
//  Created by Xse on 15/11/7.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "TransferDetailViewController.h"

@interface TransferDetailViewController ()

@property(nonatomic,strong) UIScrollView *tranScrollView;

@end

@implementation TransferDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadNavi];
    [self setRightBtnWithTitle:@"转账说明"];
    [self loadTransferDetailUI];
    
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

- (void)loadNavi
{
    [self setNaviTitle:@"转账汇款"];
    [self setNavibarBackGroundColor:K_color_red];
    [self setBackButton];
}

- (void)rightButtonAction
{
    [self tishiView];
}

- (void)loadTransferDetailUI
{
    _tranScrollView = [[UIScrollView alloc]init];
    _tranScrollView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeigth - 64);
    [self.view addSubview:_tranScrollView];
    
    UILabel *labText = [[UILabel alloc]init];
    labText.text = [NSString stringWithFormat:@"您可以通过网上银行或银行柜台向%@投资转账",App_appShortName];
    labText.adjustsFontSizeToFitWidth = YES;
    labText.frame = CGRectMake(10, 25, ScreenWidth - 10*2, 20);
    labText.textColor = [UIColor blackColor];
//    labText.font = [UIFont systemFontOfSize:15.0];
    [_tranScrollView addSubview:labText];
    
    UILabel *labTwoText = [[UILabel alloc]init];
    labTwoText.text = @"请复制或牢记我们的银行卡号";
    labTwoText.frame = CGRectMake(CGRectGetMinX(labText.frame), CGRectGetMaxY(labText.frame), ScreenWidth - 10*2, 20);
    labTwoText.textColor = [UIColor blackColor];
//    labTwoText.font = [UIFont systemFontOfSize:15.0];
    [_tranScrollView addSubview:labTwoText];
    
    UILabel *labthreeText = [[UILabel alloc]init];
    labthreeText.text = @"(手续费一笔最多50元)";
    labthreeText.frame = CGRectMake(CGRectGetMinX(labTwoText.frame), CGRectGetMaxY(labTwoText.frame), ScreenWidth - 15*2, 20);
    labthreeText.textColor = [UIColor lightGrayColor];
//    labthreeText.font = [UIFont systemFontOfSize:12.0];
    [_tranScrollView addSubview:labthreeText];
    
    if ([UIScreen mainScreen].bounds.size.height <=568)
    {
        labText.font = [UIFont systemFontOfSize:14.0];
        labTwoText.font = [UIFont systemFontOfSize:14.0];
        labthreeText.font = [UIFont systemFontOfSize:12.0];
    }else
    {
        labText.font = [UIFont systemFontOfSize:15.0];
        labTwoText.font = [UIFont systemFontOfSize:15.0];
        labthreeText.font = [UIFont systemFontOfSize:13.0];
    }
    
    UIView *redView = [[UIView alloc]init];
    redView.backgroundColor = [UIColor colorWithRed:207/255.0 green:62/255.0 blue:86/255.0 alpha:1];
    redView.frame = CGRectMake(CGRectGetMinX(labText.frame), CGRectGetMaxY(labthreeText.frame) + 15, ScreenWidth - 10*2, 100*ScreenWidth/320*0.9);
    redView.layer.cornerRadius = 5;
    redView.layer.masksToBounds = YES;
    [_tranScrollView addSubview:redView];

    //招商银行的图标
    UIImageView *iconImg = [[UIImageView alloc]init];
    iconImg.image = [UIImage imageNamed:@"bank_icon"];
    iconImg.frame = CGRectMake(20, 10, 30*ScreenWidth/320, 30*ScreenWidth/320);
    [redView addSubview:iconImg];
    
    UILabel *bankLab = [[UILabel alloc]init];
    bankLab.text = App_payBankName;
    bankLab.textColor = [UIColor whiteColor];
    bankLab.font = [UIFont systemFontOfSize:13.0];
    bankLab.frame = CGRectMake(CGRectGetMaxX(iconImg.frame) + 10, CGRectGetMinY(iconImg.frame), redView.frame.size.width - CGRectGetMaxX(iconImg.frame) - 10 - 32*ScreenWidth/320*0.9, 20);
    [redView addSubview:bankLab];
    
    UILabel *companyLab = [[UILabel alloc]init];
    companyLab.text = App_payCompanyName;
    companyLab.textColor = [UIColor whiteColor];
    companyLab.font = [UIFont systemFontOfSize:13.0];
    companyLab.frame = CGRectMake(CGRectGetMinX(bankLab.frame), CGRectGetMaxY(bankLab.frame), bankLab.frame.size.width, 20);
    [redView addSubview:companyLab];

    UILabel *bankCardLab = [[UILabel alloc]init];
    bankCardLab.text = App_payBankShowNumber;
    bankCardLab.textColor = [UIColor whiteColor];
    bankCardLab.font = [UIFont systemFontOfSize:20.0];
    if ([UIScreen mainScreen].bounds.size.height <=568) {
        bankCardLab.frame = CGRectMake(CGRectGetMinX(bankLab.frame), CGRectGetMaxY(companyLab.frame) + 2, bankLab.frame.size.width, 30);

    }else
    {
        bankCardLab.frame = CGRectMake(CGRectGetMinX(bankLab.frame), CGRectGetMaxY(companyLab.frame) + 10*ScreenWidth/320, bankLab.frame.size.width, 30);

    }
        [redView addSubview:bankCardLab];

    
    UIImageView *copyImg = [[UIImageView alloc]init];
    copyImg.frame = CGRectMake(redView.frame.size.width - 32*ScreenWidth/320*0.8 - 10, 0, 32*ScreenWidth/320*0.8, redView.frame.size.height);
    copyImg.userInteractionEnabled = YES;
    copyImg.image = [UIImage imageNamed:@"transfer_copy"];
    [redView addSubview:copyImg];
    
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    copyBtn.frame = CGRectMake(0, 0, redView.frame.size.width, redView.frame.size.height);
    [copyBtn addTarget:self action:@selector(clickCopyAction:) forControlEvents:UIControlEventTouchUpInside];
    [redView addSubview:copyBtn];
    
    UILabel *zhuanLab = [[UILabel alloc]init];
    zhuanLab.text = @"转账时:  \n请务必把您的手机号码填写在转账备注或用途里,以便我们充值到您的对应账户";
    zhuanLab.frame = CGRectMake(15, CGRectGetMaxY(redView.frame) + 10, ScreenWidth - 15*2, 60);
    zhuanLab.textColor = [UIColor blackColor];
    zhuanLab.numberOfLines = 0;
//    zhuanLab.font = [UIFont systemFontOfSize:15.0];
    [_tranScrollView addSubview:zhuanLab];
    
    if ([UIScreen mainScreen].bounds.size.height <=568)
    {
        zhuanLab.font = [UIFont systemFontOfSize:14.0];
    }else
    {
        zhuanLab.font = [UIFont systemFontOfSize:15.0];
    }

    
    UIImageView *tableImg = [[UIImageView alloc]init];
    tableImg.image = [UIImage imageNamed:@"transfer_detail_table"];
    tableImg.frame = CGRectMake(0, CGRectGetMaxY(zhuanLab.frame) + 15, ScreenWidth, 156*ScreenWidth/320);
    [_tranScrollView addSubview:tableImg];
    UILabel *successLab = [[UILabel alloc]init];
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (!AppStyle_SAlE) {
        successLab.adjustsFontSizeToFitWidth = YES;
        successLab.text = @"转账成功后，请电话联系我们的客服，以便更快到账";
        successLab.font = [UIFont systemFontOfSize:15.0];
        successLab.textAlignment = NSTextAlignmentCenter;
        successLab.frame = CGRectMake(0, CGRectGetMaxY(tableImg.frame) + 25, ScreenWidth, 20);
        [_tranScrollView addSubview:successLab];
        NSString * tel;
#if defined (YQB)
        tel = @"客服热线: 400-8915-690";
        
#else
        tel = @"客服热线: 400-6666-801";
        
#endif

        phoneBtn.frame = CGRectMake(15, CGRectGetMaxY(successLab.frame) + 20 , ScreenWidth - 15*2, 40*ScreenWidth/320);
        [phoneBtn setTitle:tel forState:UIControlStateNormal];
        [phoneBtn addTarget:self action:@selector(clickPhoneAction) forControlEvents:UIControlEventTouchUpInside];
        phoneBtn.backgroundColor = RGBACOLOR(255, 62, 27, 1);
        [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        phoneBtn.layer.cornerRadius = 5;
        phoneBtn.layer.masksToBounds = YES;
        [_tranScrollView addSubview:phoneBtn];
        
    }
  
    if ([UIScreen mainScreen].bounds.size.height <=568) {
        _tranScrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(phoneBtn.frame) + 50);

    }
}

- (void)clickCopyAction:(UIButton *)sender
{
    [UIEngine showShadowPrompt:@"已经复制到剪贴板"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = App_payBankNumber;

}

#pragma mark - 点击拨打客服电话
- (void)clickPhoneAction
{
    NSString * tel;
#if defined (YQB)
    tel = @"您是否要拨打客服电话 400-8915-690?";
    
#else
    tel = @"您是否要拨打客服电话 400-6666-801?";
    
#endif

    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"系统提示" message:tel delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString * tel;
#if defined (YQB)
        
        tel = @"tel://400-8915-690";
        
#else
        tel = @"tel://400-6666-801";
        
#endif
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:tel]];
    }
}

#pragma mark - 转账说明提示框
- (void)tishiView
{
    UIView *backView = [[UIView alloc]init];
    backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    backView.tag = 10001;
    [self.view addSubview:backView];
    
    UIView *redView = [[UIView alloc]init];
    redView.tag = 10002;
    redView.frame = CGRectMake(30, ScreenHeigth/2 -(40*ScreenWidth/320 + 120)/2 , ScreenWidth - 30*2, 40*ScreenWidth/320 + 140);
    redView.backgroundColor = K_color_red;
    redView.layer.cornerRadius = 5;
    redView.layer.masksToBounds = YES;
    [self.view addSubview:redView];
    
    UIView *whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.frame = CGRectMake(0, 0, redView.frame.size.width, 140);
    whiteView.layer.cornerRadius = 5;
    whiteView.layer.masksToBounds = YES;
    [redView addSubview:whiteView];
    
    UILabel *tishiLab = [[UILabel alloc]init];
    tishiLab.text = @"由于银行转账不是及时到账，我们需要一定的处理时间。如需即时到账，建议使用“快捷支付“ 或 ”支付宝转账“";
    tishiLab.font = [UIFont systemFontOfSize:14.0];
    tishiLab.numberOfLines = 0;
    tishiLab.frame = CGRectMake(20, 30, whiteView.frame.size.width - 20*2, 80);
    [whiteView addSubview:tishiLab];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0, CGRectGetMaxY(whiteView.frame), whiteView.frame.size.width, 40*ScreenWidth/320);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.backgroundColor = K_color_red;
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(clickSureAction:) forControlEvents:UIControlEventTouchUpInside];
    [redView addSubview:sureBtn];
}

- (void)clickSureAction:(UIButton *)sender
{
    UIView *view = [self.view viewWithTag:10001];
    [view removeFromSuperview];
    
    UIView *redView = [self.view viewWithTag:10002];
    [redView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
