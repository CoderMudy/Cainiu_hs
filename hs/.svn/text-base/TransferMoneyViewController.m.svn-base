//
//  TransferMoneyViewController.m
//  hs
//
//  Created by Xse on 15/11/7.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "TransferMoneyViewController.h"
#import "TransferDetailViewController.h"
#import "NetRequest.h"
@interface TransferMoneyViewController ()<UITextFieldDelegate>
{
    UITextField *bankTextfield;
    UITextField *moneyTextField;
    
    UIButton    *netButton;
}
@end

@implementation TransferMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    [self loadNavi];
    [self loadUI];
    [self requestUserBankData];
    [self setUpForDismissKeyboard];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    removeTextFileNotification;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    if (moneyTextField.text.length > 0) {
        moneyTextField.textColor = [UIColor blackColor];
    }
    addTextFieldNotification(textFieldValueChange);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 导航栏
- (void)loadNavi
{
    [self setNaviTitle:@"转账汇款"];
    [self setNavibarBackGroundColor:K_color_red];
    [self setBackButton];
}

#pragma mark - 界面展示
- (void)loadUI
{
    //第一个背景白色视图
    UIView *accountView = [[UIView alloc]init];
    accountView.backgroundColor = [UIColor whiteColor];
    accountView.frame = CGRectMake(0, 64 + 20, ScreenWidth, 45);
    [self.view addSubview:accountView];
    
    //支付宝账号
    UILabel *accountLab = [[UILabel alloc]init];
    accountLab.text = @"银行卡号";
    accountLab.font = [UIFont systemFontOfSize:15.0];
    accountLab.backgroundColor = [UIColor clearColor];
    accountLab.textColor = [UIColor blackColor];
    accountLab.frame = CGRectMake(20, 12, 80, 21);
    [accountView addSubview:accountLab];
    
    bankTextfield = [[UITextField alloc]init];
    bankTextfield.delegate = self;
    bankTextfield.keyboardType = UIKeyboardTypeNumberPad;
    bankTextfield.font = [UIFont systemFontOfSize:15.0];
    bankTextfield.placeholder = @"请输入银行卡号";
    bankTextfield.clearButtonMode = UITextFieldViewModeAlways;//系统默认的叉
    bankTextfield.textColor = [UIColor lightGrayColor];
    [bankTextfield addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventValueChanged];
    bankTextfield.frame = CGRectMake(CGRectGetMaxX(accountLab.frame) + 5, 5, ScreenWidth - CGRectGetMaxX(accountLab.frame) - 20, 35);
    [accountView addSubview:bankTextfield];
    
    //第二个白色的背景视图
    UIView *moneyView = [[UIView alloc]init];
    moneyView.backgroundColor = [UIColor whiteColor];
    moneyView.frame = CGRectMake(0, CGRectGetMaxY(accountView.frame) + 10, ScreenWidth, accountView.frame.size.height);
    [self.view addSubview:moneyView];
    
    //充值金额
    UILabel *moneyLab = [[UILabel alloc]init];
    moneyLab.text = @"充值金额";
    moneyLab.font = [UIFont systemFontOfSize:15.0];
    moneyLab.backgroundColor = [UIColor clearColor];
    moneyLab.textColor = [UIColor blackColor];
    moneyLab.frame = CGRectMake(CGRectGetMinX(accountLab.frame), CGRectGetMinY(accountLab.frame), accountLab.frame.size.width, 21);
    [moneyView addSubview:moneyLab];
    
    moneyTextField = [[UITextField alloc]init];
    moneyTextField.delegate = self;
    moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    moneyTextField.font = [UIFont systemFontOfSize:15.0];
    moneyTextField.placeholder = @"充值金额≥50";
    moneyTextField.clearButtonMode = UITextFieldViewModeAlways;//系统默认的叉
    moneyTextField.textColor = [UIColor lightGrayColor];
    [moneyTextField addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventValueChanged];
    moneyTextField.frame = CGRectMake(CGRectGetMaxX(moneyLab.frame) + 5, 5, ScreenWidth - CGRectGetMaxX(moneyLab.frame) - 40, 35);
    [moneyView addSubview:moneyTextField];
    
    //单位元
    UILabel *yuanLab = [[UILabel alloc]init];
    yuanLab.text = @"元";
    yuanLab.font = [UIFont systemFontOfSize:15.0];
    yuanLab.textColor = [UIColor blackColor];
    yuanLab.frame = CGRectMake(ScreenWidth - 40, CGRectGetMinY(moneyLab.frame), 20, 20);
    yuanLab.textAlignment = NSTextAlignmentRight;
    [moneyView addSubview:yuanLab];
    
    
    UILabel * showLab = [[UILabel alloc] init];
    showLab.text = @"该记录用于财务校验，以便及时为您账户充值。请确保您输入的银行卡号和充值金额与实际一致。";
    CGSize labSize = [Helper sizeWithText:showLab.text font:[UIFont systemFontOfSize:14.0] maxSize:CGSizeMake(ScreenWidth - 15*2, 200)];
    showLab.frame = CGRectMake(15, CGRectGetMaxY(moneyView.frame) + 10, ScreenWidth - 15*2,labSize.height);
    showLab.numberOfLines = 0;
    showLab.font = [UIFont systemFontOfSize:14.0];
    showLab.textColor = [UIColor lightGrayColor];
    [self.view addSubview:showLab];
    
    
    
    
    
    netButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [netButton setTitle:@"下一步" forState:UIControlStateNormal];
    netButton.frame = CGRectMake(15, CGRectGetMaxY(showLab.frame) + 20, ScreenWidth - 15*2, 40*ScreenWidth/320);
    [netButton addTarget:self action:@selector(clickNextAction:) forControlEvents:UIControlEventTouchUpInside];
    netButton.layer.cornerRadius = 5;
    netButton.layer.masksToBounds = YES;
    [self.view addSubview:netButton];
    
    [self updateUIbutton:NO];
    
    //温馨提示
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text = @"温馨提示:";
    titleLab.textColor = K_color_red;
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.font = [UIFont systemFontOfSize:14.0];
    titleLab.frame = CGRectMake(15, CGRectGetMaxY(netButton.frame) + 30, ScreenWidth - 15*2, 20);
    [self.view addSubview:titleLab];
    
    UILabel *tishiLab = [[UILabel alloc]init];
    NSString *labText = @"由于银行转账不是及时到账,我们需要一定的处理时间,如需即时到账,建议使用“快捷支付”或“支付宝转账”";
    
    tishiLab.font = [UIFont systemFontOfSize:14];
    tishiLab.numberOfLines = 0;
    tishiLab.textColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:labText];
    //创建NSMutableParagraphStyle实例
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    //设置行距
    [style setLineSpacing:5.0f];
    //根据给定长度与style设置attStr式样
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attStr.mutableString.length)];
    tishiLab.attributedText = attStr;
    tishiLab.frame = CGRectMake(15, CGRectGetMaxY(titleLab.frame), ScreenWidth - 15*2, 70);
    [self.view addSubview:tishiLab];
}

- (void)clickNextAction:(UIButton *)sender
{
    if ([moneyTextField.text floatValue] < 50) {
        [[UIEngine sharedInstance] showAlertWithTitle:@"最小充值金额50元" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
        [UIEngine sharedInstance].alertClick =^ (int aIndex){
            
        };
        return ;
    }else
    {
        [moneyTextField resignFirstResponder];
        [bankTextfield resignFirstResponder];
        
        TransferDetailViewController *tranCtrl = [[TransferDetailViewController alloc]init];
        [self.navigationController pushViewController:tranCtrl animated:YES];
        [self requestListData];
    }
}

#pragma mark - 获取用户银行卡信息
- (void)requestUserBankData
{
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token};
    [NetRequest postRequestWithNSDictionary:dic url:K_User_ZfbAndBanckNumber successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            bankTextfield.text = dictionary[@"data"][@"bankNumber"];
            if (bankTextfield.text.length > 0) {
                bankTextfield.textColor = [UIColor blackColor];
            }
        }
    } failureBlock:^(NSError *error) {
    }];
    
}

#pragma mark - 银行卡转账接口
- (void)requestListData
{
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token,@"money":@([moneyTextField.text doubleValue]),@"bankNumber":bankTextfield.text};
    NSLog(@"dic:%@",dic);
    [NetRequest postRequestWithNSDictionary:dic url:K_User_Banktransfer successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            NSLog(@"成功");
        }
    } failureBlock:^(NSError *error) {
       
    }];
}

-(void )updateUIbutton:(BOOL) bEnable
{
    netButton.enabled = bEnable;
    [netButton setBackgroundColor:(bEnable ? RGBACOLOR(255, 62, 27, 1):[UIColor lightGrayColor])];
}

- (void)textFieldValueChange
{
    if (moneyTextField.text.length > 0) {
        moneyTextField.textColor = [UIColor blackColor];
    }
    
    if (bankTextfield.text.length > 0) {
        bankTextfield.textColor = [UIColor blackColor];
        
    }

    if ([moneyTextField.text isEqualToString:@""] || [bankTextfield.text isEqualToString:@""]) {
        [self updateUIbutton:NO];
    }else
    {
        [self updateUIbutton:YES];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField;
{
    [self updateUIbutton:NO];
    
    return  YES;
}


#pragma mark - 点击屏幕任意地方键盘消失
- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}


@end
