//
//  AliPayViewController.m
//  hs
//
//  Created by Xse on 15/11/5.
//  Copyright © 2015年 luckin. All rights reserved.
//  ======支付宝转账

#import "AliPayViewController.h"
#import "AilPayDetailViewController.h"
#import "NetRequest.h"

@interface AliPayViewController ()<UITextFieldDelegate>
{
    UITextField *accountTextField;
    UITextField *moneyTextField;
    
    UIButton *netButton;
}
@end

@implementation AliPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    
    [self loadNavi];
    [self loadUI];
    [self requestUserZfbData];
    
    [self setUpForDismissKeyboard];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    if (moneyTextField.text.length >0) {
        moneyTextField.textColor = [UIColor blackColor];
    }
    addTextFieldNotification(textFieldValueChange);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    removeTextFileNotification;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - 导航栏
- (void)loadNavi
{
    [self setNaviTitle:@"支付宝转账"];
    [self setNavibarBackGroundColor:K_color_NavColor];
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
    accountLab.text = @"支付宝账号";
    accountLab.font = [UIFont systemFontOfSize:15.0];
    accountLab.backgroundColor = [UIColor clearColor];
    accountLab.textColor = [UIColor blackColor];
    accountLab.frame = CGRectMake(20, 12, 80, 21);
    [accountView addSubview:accountLab];
    
    accountTextField = [[UITextField alloc]init];
    accountTextField.delegate = self;
    accountTextField.font = [UIFont systemFontOfSize:15.0];
    accountTextField.placeholder = @"请输入本人支付宝账号";
    accountTextField.clearButtonMode = UITextFieldViewModeAlways;//系统默认的叉
    accountTextField.textColor = [UIColor lightGrayColor];
    [accountTextField addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventValueChanged];
    accountTextField.frame = CGRectMake(CGRectGetMaxX(accountLab.frame) + 5, 5, ScreenWidth - CGRectGetMaxX(accountLab.frame) - 20, 35);
    [accountView addSubview:accountTextField];
    
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
    
    UILabel *describLab = [[UILabel alloc]init];
    describLab.text = @"该记录用于财务校验，以便及时为您账户充值。请确保您输入的支付宝账号和充值金额与实际一致。";
    describLab.numberOfLines = 0;
    describLab.textColor = [UIColor lightGrayColor];
    describLab.font = [UIFont systemFontOfSize:14.0];
    CGSize labSize = [Helper sizeWithText:describLab.text font:[UIFont systemFontOfSize:14.0] maxSize:CGSizeMake(ScreenWidth - 15*2, 200)];
    describLab.frame = CGRectMake(15, CGRectGetMaxY(moneyView.frame) + 10, ScreenWidth - 15*2, labSize.height);
    [self.view addSubview:describLab];
    
    netButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [netButton setTitle:@"下一步" forState:UIControlStateNormal];
    netButton.frame = CGRectMake(15, CGRectGetMaxY(describLab.frame) + 20, ScreenWidth - 15*2, 40*ScreenWidth/320);
    [netButton addTarget:self action:@selector(clickNextAction:) forControlEvents:UIControlEventTouchUpInside];
    netButton.layer.cornerRadius = 5;
    netButton.layer.masksToBounds = YES;
    [self.view addSubview:netButton];
    
    [self updateUIbutton:NO];
    
    //到账时间
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text = @"到账时间";
    titleLab.textColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:14.0];
    titleLab.frame = CGRectMake(0, CGRectGetMaxY(netButton.frame) + 30, ScreenWidth, 20);
    [self.view addSubview:titleLab];
    
    UILabel *timeOneLab = [[UILabel alloc]init];
    timeOneLab.text = @"工作日9:00-22:00 (15分钟内到账)";
    timeOneLab.textColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1];
    timeOneLab.backgroundColor = [UIColor clearColor];
    timeOneLab.textAlignment = NSTextAlignmentCenter;
    timeOneLab.font = [UIFont systemFontOfSize:14.0];
    timeOneLab.frame = CGRectMake(0, CGRectGetMaxY(titleLab.frame) + 10, ScreenWidth, 20);
    [self.view addSubview:timeOneLab];
    
    UILabel *timeTwoLab = [[UILabel alloc]init];
    timeTwoLab.text = @"工作日22:30以后 (次日9:00前到账)";
    timeTwoLab.textColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1];
    timeTwoLab.backgroundColor = [UIColor clearColor];
    timeTwoLab.textAlignment = NSTextAlignmentCenter;
    timeTwoLab.font = [UIFont systemFontOfSize:14.0];
    timeTwoLab.frame = CGRectMake(0, CGRectGetMaxY(timeOneLab.frame) + 10, ScreenWidth, 20);
    [self.view addSubview:timeTwoLab];

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
        [accountTextField resignFirstResponder];
        
        [self requestListData];
        
        AilPayDetailViewController *detailCtrl = [[AilPayDetailViewController alloc]init];
        [self.navigationController pushViewController:detailCtrl animated:YES];
        
    }
}

#pragma mark - 获取用户支付宝信息
- (void)requestUserZfbData
{
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token};
    [NetRequest postRequestWithNSDictionary:dic url:K_User_ZfbAndBanckNumber successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            accountTextField.text = dictionary[@"data"][@"zfb"];
            if (accountTextField.text.length > 0) {
                accountTextField.textColor = [UIColor blackColor];
            }
        }
    } failureBlock:^(NSError *error) {
    }];

}

#pragma mark - 支付宝转账接口
- (void)requestListData
{
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token,@"money":moneyTextField.text,@"zfbNumber":accountTextField.text};
    [NetRequest postRequestWithNSDictionary:dic url:K_User_ZfbNumber successBlock:^(NSDictionary *dictionary) {
        
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
    
    if (accountTextField.text.length > 0) {
        accountTextField.textColor = [UIColor blackColor];
        
    }

    if ([moneyTextField.text isEqualToString:@""] || [accountTextField.text isEqualToString:@""]) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
