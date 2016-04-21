//
//  LoginViewController.m
//  hs
//
//  Created by hzl on 15-4-22.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import "LoginViewController.h"
#import "AFMInfoBanner.h"
#import "Helper.h"
#import "NetRequest.h"
#import "NSString+MD5.h"
#import "RegViewController.h"
#import "HSInputView.h"
#import "TiXianListViewController.h"
#import "CollectFeetStanderViewController.h"
#import "SpotIndexViewController.h"
#import "StopProfitViewController.h"
#import "ClosePositionViewController.h"
#import "Alert.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    UIImageView *backImg;
    UITextField *phoneTextFiled;
    UITextField *passWordText;
    
    UILabel *phoneLab;
    UILabel *passWordLab;
    
    UIButton *pWordCancelBtn;//密码的删除按钮
    UIButton *phoneCancelBtn;//手机号码的删除按钮
    
    UIButton *loginBtn;//d登录按钮;
    UIButton *registBtn;//注册按钮
    
    UILabel *phoneLabel;
    UIImageView *iconImg;
    UIImageView *phoneImg;
    UIView *phoneLineView;
    UIImageView *passWordImg;
    UIView *passWordLineView;
    UIImageView * loginImageV;
    
    BOOL isShow;
    
}
@property (nonatomic, strong)NSNotification * notification;

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

    [MobClick beginLogPageView:@"登录"];
    self.rdv_tabBarController.tabBarHidden = YES;

    if ([_isRegister isEqualToString:@"YES"]) {
        phoneLab.hidden = YES;
    }
    
    addTextFieldNotification(textFieldValueChange);
}

- (void)sendNotification
{
    [[NSNotificationCenter defaultCenter]postNotification:_notification];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [MobClick endLogPageView:@"登录"];
    [[UIEngine sharedInstance] hideProgress];
    removeTextFileNotification;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


-(void)popEvent{
    if (self.isBackLastPage) {
        [self.navigationController popViewControllerAnimated:YES];
        self.navigationController.navigationBarHidden = NO;
        return;
    }
    //沪金沪银期指进入
    if (self.isOtherFutures) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    if ([self.source isEqualToString:@"orderBuy"]) {
        [self.navigationController popViewControllerAnimated:NO];
        
    }
    
    if (self.isRegInto) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if(self.isNeedPopRootController)
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    else
    {
        //被踢掉重新登录回账户页
        self.rdv_tabBarController.selectedIndex = 3;
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    self.navigationController.navigationBarHidden = NO;
}

// 监听清除按钮，按钮灰色

- (BOOL)textFieldShouldClear:(UITextField *)textField;
{
    [self updateUIbutton:YES];
    phoneLab.hidden = NO;
    passWordLab.hidden = NO;
    
    if ([textField isEqual:phoneTextFiled] || [textField isEqual:passWordText]) {
        phoneCancelBtn.hidden = YES;
        pWordCancelBtn.hidden = YES;
    }
    
    return  YES;
}

-(void)textFieldValueChange
{
    if ([self.navigationController.viewControllers.lastObject isKindOfClass:[self class]]) {
        if (passWordText.text.length>20) {
            passWordText.text = [passWordText.text substringToIndex:20];
        }
        
        if (phoneTextFiled.text.length == 11 && ![[phoneTextFiled.text substringToIndex:1] isEqualToString:@"1"]) {
            [UIEngine showShadowPrompt:@"您输入的手机号码格式有误"];
            return;
        }
        
        if (phoneTextFiled.text.length>11) {
            phoneTextFiled.text = [phoneTextFiled.text substringToIndex:11];
            
        }
        
        if (phoneTextFiled.text.length >0) {
            phoneLab.hidden = YES;
            
            //判断。如果是已经登录过的情况
            if ([getUserDefaults(@"FirstLogin") isEqualToString:@"YES"])
            {
                phoneCancelBtn.hidden = YES;
                
            }
        }else
        {
            phoneLab.hidden = NO;
        }
        
        
        if (passWordText.text.length >0) {
            passWordLab.hidden = YES;
        }else
        {
            passWordLab.hidden = NO;
        }
        
        if (phoneTextFiled.text.length!=11||passWordText.text.length<6) {
            [self updateUIbutton:NO];
        }
        else
        {
            [self updateUIbutton:YES];
        }
        
        if (phoneTextFiled.text.length <=0) {
            phoneCancelBtn.hidden = YES;
        }
        
        if (passWordText.text.length <=0) {
            pWordCancelBtn.hidden = YES;
        }
        
        if (isShow == YES && phoneTextFiled.text.length > 0) {
            phoneCancelBtn.hidden = NO;
        }else if(isShow == NO && passWordText.text.length > 0)
        {
            pWordCancelBtn.hidden = NO;
        }
    }
    
    
}

- (void)textFieldShouldEnd
{
    [UIView animateWithDuration:0.2 animations:^{
        
        if ([UIScreen mainScreen].bounds.size.height <=568 ||[UIScreen mainScreen].bounds.size.height <= 480)
        {
            backImg.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
            phoneCancelBtn.frame = CGRectMake(ScreenWidth - 55, CGRectGetMinY(phoneImg.frame), 50, 35);
            pWordCancelBtn.frame = CGRectMake(ScreenWidth - 55, CGRectGetMinY(passWordImg.frame), 50, 35);
        }
    }];
    
    phoneCancelBtn.hidden = YES;
}

- (void)textFieldShouldBegin
{
    [UIView animateWithDuration:0.2 animations:^{
        if ([UIScreen mainScreen].bounds.size.height ==568)
        {
            backImg.frame = CGRectMake(0, -65, ScreenWidth, ScreenHeigth);
            phoneCancelBtn.frame = CGRectMake(ScreenWidth - 55, CGRectGetMinY(phoneImg.frame) - 65, 50, 35);
            pWordCancelBtn.frame = CGRectMake(ScreenWidth - 55, CGRectGetMinY(passWordImg.frame) - 65, 50, 35);
        }else if ([UIScreen mainScreen].bounds.size.height == 480)
        {
            backImg.frame = CGRectMake(0, -130, ScreenWidth, ScreenHeigth);
            phoneCancelBtn.frame = CGRectMake(ScreenWidth - 55, CGRectGetMinY(phoneImg.frame) - 130, 50, 35);
            pWordCancelBtn.frame = CGRectMake(ScreenWidth - 55, CGRectGetMinY(passWordImg.frame) - 130, 50, 35);
            
        }
        
    }];
    
    isShow = YES;
    if (phoneTextFiled.text.length > 0) {
        phoneCancelBtn.hidden = NO;
        
    }


}

- (void)textFieldPWordShouldBegin
{
    [UIView animateWithDuration:0.2 animations:^{
        if ([UIScreen mainScreen].bounds.size.height ==568)
        {
            backImg.frame = CGRectMake(0, -65, ScreenWidth, ScreenHeigth);
            phoneCancelBtn.frame = CGRectMake(ScreenWidth - 55, CGRectGetMinY(phoneImg.frame) - 65, 50, 35);
            pWordCancelBtn.frame = CGRectMake(ScreenWidth - 55, CGRectGetMinY(passWordImg.frame) - 65, 50, 35);
        }else if ([UIScreen mainScreen].bounds.size.height == 480)
        {
            backImg.frame = CGRectMake(0, -130, ScreenWidth, ScreenHeigth);
            phoneCancelBtn.frame = CGRectMake(ScreenWidth - 55, CGRectGetMinY(phoneImg.frame) - 130, 50, 35);
            pWordCancelBtn.frame = CGRectMake(ScreenWidth - 55, CGRectGetMinY(passWordImg.frame) - 130, 50, 35);
            
        }
        
    }];
    
    isShow = NO;

    if (passWordText.text.length > 0) {
        pWordCancelBtn.hidden = NO;
    }

    
}

- (void)textFieldPWordShouldEnd
{
    [UIView animateWithDuration:0.2 animations:^{
        
        if ([UIScreen mainScreen].bounds.size.height <=568 ||[UIScreen mainScreen].bounds.size.height <= 480)
        {
            backImg.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
            phoneCancelBtn.frame = CGRectMake(ScreenWidth - 55, CGRectGetMinY(phoneImg.frame), 50, 35);
            pWordCancelBtn.frame = CGRectMake(ScreenWidth - 55, CGRectGetMinY(passWordImg.frame), 50, 35);
        }
    }];
    
    
    pWordCancelBtn.hidden = YES;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 987)
    {
        
    }
}

// 监听文本输入
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([textField isEqual:phoneTextFiled]) {
        // 手机三或四位加空格，最多输入11位的手机号码
        NSString   * tmpphone = textField.text;
        if (string.length == 0)
        {
            return YES;
        }
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        
        if ((existedLength - selectedLength + replaceLength >= 11) && replaceLength >0)
        {
            //判断输入的手机号码格式是否正确
            NSString * tmpphoneNum = [NSString stringWithFormat:@"%@%@",tmpphone,string];
            NSString *loginUserNum = [tmpphoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            BOOL  telFormat = [Helper checkTel:loginUserNum];
            if (telFormat == NO)
            {}
            else {
                [self performSelector:@selector(inputPwd) withObject:nil afterDelay:1];
            }
        }
    }else{
        return YES;
    }
    
    return  YES;
}

-(void)inputPwd
{
    [passWordText becomeFirstResponder];
}

- (void)removeLab:(UILabel*)lab
{
    
    [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionOverrideInheritedDuration animations:^{
        [lab removeFromSuperview];
        
    } completion:nil];
    
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [passWordText resignFirstResponder];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    //给视图添加一个背景图片
    backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
    backImg.image = [UIImage imageNamed:@"log_backGroud"];
    backImg.userInteractionEnabled = YES;
    [self.view addSubview:backImg];
    
    
    [self drawLogView];
    
    _notification= [NSNotification notificationWithName:@"changePagePosition" object:self userInfo:nil];

    if ([[CMStoreManager sharedInstance] getUserName].length==11)
    {
        if (![getUserDefaults(@"FirstLogin") isEqualToString:@"YES"]) {
            [[CMStoreManager sharedInstance] deleteUserName];
        }
    }

    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    [self loadNav];
    
    if (self.isRegInto) {
        phoneTextFiled.text = self.regPhone;
    }
    [self setUpForDismissKeyboard];
}


-(void)loadNav{
    //无返回按钮
    if (self.isNoBackBtn) {
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        leftButton.titleLabel.shadowColor = RGBACOLOR(117,38,0,1.0f);
        leftButton.titleLabel.shadowOffset= CGSizeMake(0, -1);
        leftButton.titleLabel.textColor = [UIColor whiteColor];
        
        UIBarButtonItem *leftbtn =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftbtn;
    }
}

-(void)changeUserName
{
    UILabel *phoneTextLabel = (UILabel *)[self.view viewWithTag:101];
    [phoneTextLabel removeFromSuperview];
    phoneTextFiled.text = @"";
    passWordText.text = @"";
    [phoneTextFiled becomeFirstResponder];
    
    saveUserDefaults(@"NO", @"FirstLogin");
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view.window endEditing:YES];
}

- (void)goRegister
{
    RegViewController * regVC = [[RegViewController alloc] init];
    regVC.sourceStr = @"注册";
    [self.navigationController pushViewController:regVC animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void )updateUIbutton:(BOOL) bEnable
{
    loginBtn.enabled = bEnable;
    [loginBtn setAlpha:(bEnable ? 1:0.9)];
    [loginImageV setAlpha:(bEnable ?1:0.4)];
}

#pragma mark - 一键登录，没有登录过的登录
- (void)drawLogView
{
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.tag = 10004;
    cancelBtn.frame = CGRectMake(0 ,10, 50, 44);
    [cancelBtn setImage:[UIImage imageNamed:@"return_1"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [backImg addSubview:cancelBtn];

    //返回按钮
    if (_isNoBackBtn == YES) {
        cancelBtn.hidden = YES;
    }else
    {
        cancelBtn.hidden = NO;
    }
    
    iconImg = [[UIImageView alloc]init];
    iconImg.image = [UIImage imageNamed:@"regist_log"];
    iconImg.frame = CGRectMake(ScreenWidth/2 - 105/2, 85*ScreenHeigth/667, 105, 105);
    [backImg addSubview:iconImg];
    
    phoneImg = [[UIImageView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(iconImg.frame) + 60, 23, 27)];
    phoneImg.image = [UIImage imageNamed:@"phone_num"];
    [backImg addSubview:phoneImg];
    
    //输入手机号码的输入框
    phoneTextFiled = [[UITextField alloc]init];
    phoneTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    phoneTextFiled.delegate = self;
    phoneTextFiled.textColor = [UIColor whiteColor];
    phoneTextFiled.frame = CGRectMake(CGRectGetMaxX(phoneImg.frame) + 15, CGRectGetMinY(phoneImg.frame), ScreenWidth - CGRectGetMaxX(phoneImg.frame) - 70, 35);
    [phoneTextFiled addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventValueChanged];
    [phoneTextFiled addTarget:self action:@selector(textFieldShouldBegin) forControlEvents:UIControlEventEditingDidBegin];
    [phoneTextFiled addTarget:self action:@selector(textFieldShouldEnd) forControlEvents:UIControlEventEditingDidEnd];
    [backImg addSubview:phoneTextFiled];
    
    phoneLab = [[UILabel alloc]init];
    phoneLab.frame = CGRectMake(0, 5, 100 , 20);
    phoneLab.backgroundColor = [UIColor clearColor];
    phoneLab.text = @"请输入手机号码";
    phoneLab.font = [UIFont systemFontOfSize:14.0];
    phoneLab.textColor = [UIColor lightGrayColor];
    [phoneTextFiled addSubview:phoneLab];

    //输入手机号码后面的小圆叉
    phoneCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneCancelBtn.frame = CGRectMake(ScreenWidth - 55, CGRectGetMinY(phoneImg.frame), 50, 35);
    phoneCancelBtn.hidden = YES;
    phoneCancelBtn.tag = 201;
    [phoneCancelBtn setImage:[UIImage imageNamed:@"log_clear"] forState:UIControlStateNormal];
    [phoneCancelBtn addTarget:self action:@selector(clickCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneCancelBtn];
    
    //输入手机号码下面的横线
    phoneLineView = [[UIView alloc]init];
    phoneLineView.backgroundColor = [UIColor lightGrayColor];
    phoneLineView.frame = CGRectMake(15, CGRectGetMaxY(phoneImg.frame) + 8, ScreenWidth - 30, 0.5);
    [backImg addSubview:phoneLineView];
    
    //输入密码
    passWordImg = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(phoneImg.frame), CGRectGetMaxY(phoneLineView.frame) + 30, 23, 27)];
    passWordImg.image = [UIImage imageNamed:@"password"];
    [backImg addSubview:passWordImg];
    
    //输入密码的输入框
    passWordText = [[UITextField alloc]init];
    passWordText.delegate = self;
    passWordText.secureTextEntry = YES;
    passWordText.textColor = [UIColor whiteColor];
    passWordText.frame = CGRectMake(CGRectGetMaxX(passWordImg.frame) + 15, CGRectGetMinY(passWordImg.frame), ScreenWidth - CGRectGetMaxX(phoneImg.frame) - 70, 30);
    [passWordText addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventValueChanged];
    [passWordText addTarget:self action:@selector(textFieldPWordShouldBegin) forControlEvents:UIControlEventEditingDidBegin];
    [passWordText addTarget:self action:@selector(textFieldPWordShouldEnd) forControlEvents:UIControlEventEditingDidEnd];
    [backImg addSubview:passWordText];
    
    passWordLab = [[UILabel alloc]init];
    passWordLab.backgroundColor = [UIColor clearColor];
    passWordLab.text = @"请输入密码";
    passWordLab.font = [UIFont systemFontOfSize:14.0];
    passWordLab.textColor = [UIColor lightGrayColor];
    passWordLab.frame = CGRectMake(0, 5, ScreenWidth - CGRectGetMaxX(phoneImg.frame) - 30 , 20);
    [passWordText addSubview:passWordLab];
    
    //输入密码后面的小圆叉
    pWordCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pWordCancelBtn.hidden = YES;
    pWordCancelBtn.tag = 202;
    [pWordCancelBtn setImage:[UIImage imageNamed:@"log_clear"] forState:UIControlStateNormal];
    [pWordCancelBtn addTarget:self action:@selector(clickCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    pWordCancelBtn.frame = CGRectMake(ScreenWidth - 55, CGRectGetMinY(passWordImg.frame), 50, 35);
    [self.view addSubview:pWordCancelBtn];

    
    //输入密码下面的横线
    passWordLineView = [[UIView alloc]init];
    passWordLineView.backgroundColor = [UIColor lightGrayColor];
    passWordLineView.frame = CGRectMake(15, CGRectGetMaxY(passWordImg.frame) + 8, ScreenWidth - 30, 0.5);
    [backImg addSubview:passWordLineView];
    
    loginImageV = [[UIImageView alloc] init];
    loginImageV.userInteractionEnabled =YES;
    loginImageV.image = [UIImage imageNamed:@"log_btn"];
    loginImageV.frame =CGRectMake(15, CGRectGetMaxY(passWordLineView.frame) + 33, ScreenWidth - 15*2, 40*ScreenWidth/320);
    [backImg addSubview:loginImageV];
    
    //登录按钮
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.tag = 10001;
    loginBtn.frame = CGRectMake(15, CGRectGetMaxY(passWordLineView.frame) + 33, ScreenWidth - 15*2, 44*ScreenWidth/320);
    [loginBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [backImg addSubview:loginBtn];
    
    [self updateUIbutton:NO];
    
    //注册账户
    registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.tag = 10002;
    registBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    registBtn.frame = CGRectMake(5, ScreenHeigth - 40 - 10, 80, 44);
    [registBtn setTitle:@"注册账户" forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [backImg addSubview:registBtn];
    
    
    //忘记密码
    UIButton *forgetPwordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPwordBtn.tag = 10003;
    forgetPwordBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    forgetPwordBtn.frame = CGRectMake(ScreenWidth - 80 - 5, ScreenHeigth - 40 - 10, 80, 44);
    [forgetPwordBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetPwordBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [backImg addSubview:forgetPwordBtn];
    
    //判断。如果是已经登录过的情况
    if ([getUserDefaults(@"FirstLogin") isEqualToString:@"YES"]) {
        
        iconImg.image = [UIImage imageNamed:@"log_password"];
        
        phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImg.frame) + 20*ScreenHeigth/667, ScreenWidth, 50)];
        phoneLabel.textAlignment = NSTextAlignmentCenter;
        if ([[CMStoreManager sharedInstance] getUserName] == nil || [[[CMStoreManager sharedInstance] getUserName] rangeOfString:@"null"].location != NSNotFound) {
            return;
        }
        else{
            phoneLabel.text =  [NSString stringWithFormat:@"%@****%@",[[[CMStoreManager sharedInstance] getUserName] substringToIndex:3],[[[CMStoreManager sharedInstance] getUserName] substringFromIndex:[[CMStoreManager sharedInstance] getUserName].length-4]];
        }
        phoneLabel.textColor=[UIColor whiteColor];
        phoneLabel.tag = 101;
        [backImg addSubview:phoneLabel];
        
        NSLog(@"userName:%@",[[CMStoreManager sharedInstance] getUserName]);
        
        NSLog(@"===:%@===%@",[[[CMStoreManager sharedInstance] getUserName] substringToIndex:3],[[[CMStoreManager sharedInstance] getUserName] substringFromIndex:[[CMStoreManager sharedInstance] getUserName].length-4]);
        
        phoneTextFiled.text = [[CMStoreManager sharedInstance] getUserName];
        
        //把手机号码相关的视图都隐藏掉
        phoneImg.hidden = YES;
        phoneLab.hidden = YES;
        phoneCancelBtn.hidden = YES;
        phoneLineView.hidden = YES;
        phoneTextFiled.hidden = YES;
        
        //将密码相关的视图的位置都移动
        passWordImg.frame = CGRectMake(30, CGRectGetMaxY(phoneLabel.frame) + 40*ScreenHeigth/667, 23, 27);
        passWordText.frame = CGRectMake(CGRectGetMaxX(passWordImg.frame) + 15, CGRectGetMinY(passWordImg.frame), ScreenWidth - CGRectGetMaxX(passWordImg.frame) - 30, 30);
        pWordCancelBtn.frame = CGRectMake(ScreenWidth - 55, CGRectGetMinY(passWordImg.frame), 50, 35);
        passWordLab.frame = CGRectMake(0, 5, ScreenWidth - CGRectGetMaxX(phoneImg.frame) - 40 , 20);
        passWordLineView.frame = CGRectMake(15, CGRectGetMaxY(passWordImg.frame) + 8, ScreenWidth - 30, 0.5);
        loginBtn.frame = CGRectMake(15, CGRectGetMaxY(passWordLineView.frame) + 38, ScreenWidth - 15*2, 44 *ScreenWidth/320);
        loginImageV.frame =  CGRectMake(15, CGRectGetMaxY(passWordLineView.frame) + 38, ScreenWidth - 15*2, 40 *ScreenWidth/320);
        [registBtn setTitle:@"切换账户" forState:UIControlStateNormal];
    }

}

- (void)clickAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    switch (btn.tag) {
        case 10001:
            {
                NSString *loginName = [phoneTextFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSString * passWord = [passWordText.text MD5Digest];
                passWord = [passWord uppercaseString];
                
                NSString * niu = @"";
//#if defined (CAINIUA)
//                niu = RegSourceCaiNiuA;
//                
//#elif defined (NIUAAPPSTORE)
//                niu = RegSourceCaiNiuA;
//                
//#else
//                niu = RegSourceCaiNiu;
//#endif
                niu = App_regSource;
                NSDictionary * dic = @{@"loginName":loginName,
                                       @"password":passWord,
                                       @"version":VERSION,
                                       @"deviceModel":[[UIDevice currentDevice] model],
                                       @"deviceImei":UDID,
                                       @"deviceVersion":[[UIDevice currentDevice] systemVersion],
                                       @"clientVersion":VERSION,
                                       @"regSource":niu,
                                       @"operator":[DataEngine getCellularProviderName],
                                       @"systemName":@"2",
                                       };
                NSString * url = @"/user/login";
                NSString * loginUrl = [NSString stringWithFormat:@"%@%@",K_MGLASS_URL,url];
                //    NSLog(@"%@",loginUrl);
                
                [UIEngine sharedInstance].progressStyle=1;
                [[UIEngine sharedInstance] showProgress];
                
                [NetRequest postRequestWithNSDictionary:dic url:loginUrl successBlock:^(NSDictionary *dictionary) {
                    
                    if ([dictionary[@"code"] intValue]==200) {
                        [self sendNotification];

                        [DataEngine saveUserInfo:dictionary];
                        //第一次登录
                        UserBaseClass * userBaseClass = [UserBaseClass modelObjectWithDictionary:dictionary];
                        CUserData * cuserdata = [CUserData sharedInstance];
                        cuserdata.userBaseClass = userBaseClass;
                        //昵称修改状态
                        saveUserDefaults(dictionary[@"data"][@"nickStatus"], uUserInfoNickStatus);
                        [[CMStoreManager sharedInstance] setUSerHeaderAddress:userBaseClass.data.userInfo.headPic];
                        [[CMStoreManager sharedInstance] setUserNick:userBaseClass.data.userInfo.nick];
                        [[CMStoreManager sharedInstance] setUserSign:userBaseClass.data.userInfo.personSign];
                        [[CMStoreManager sharedInstance] storeUserToken:cuserdata.userBaseClass.data.tokenInfo.token];
                        [[CMStoreManager sharedInstance] storeUserTokenSecret:cuserdata.userBaseClass.data.tokenInfo.userSecret];
                        [[CMStoreManager sharedInstance] storeUserName:phoneTextFiled.text];
                        
                        //获取账户信息(是否开户)
                        [self requestToGetAccount];
                        
                        //判断用户是否登录
                        CacheModel *cacheModel = [CacheEngine getCacheInfo];
                        if (![cacheModel.isOrLogin isEqualToString:@"NO"]) {
                            cacheModel.isOrLogin = @"YES";
                        }
                        
                        if (![cacheModel.isOrderOrLogin isEqualToString:@"NO"]) {
                            cacheModel.isOrderOrLogin = @"YES";
                        }
                        
                        if (![cacheModel.isQuickOrderOrLogin isEqualToString:@"NO"]) {
                            cacheModel.isQuickOrderOrLogin = @"YES";
                        }

                        [CacheEngine setCacheInfo:cacheModel];
                        
                        saveUserDefaults(@"YES", @"FirstLogin");
                        
                       
                        //取得南交所Token
                        SpotgoodsModel *spotgoodsModel  = [[SpotgoodsModel alloc]init];
                        spotgoodsModel.member           = [CacheEngine getSpotgoodsInfoUsername];
                        spotgoodsModel.spotgoodsToken   = [CacheEngine getSpotgoodsInfoToken];
                        spotgoodsModel.httpToken        = [CacheEngine getSpotgoodsHttpToken];
                        spotgoodsModel.password         = [CacheEngine getSpotgoodsInfoPassword];
                        [SpotgoodsAccount sharedInstance].spotgoodsModel = spotgoodsModel;
                        
                        if (![SpotgoodsAccount sharedInstance].isNeedRegist) {
                            //南交所登录
                            if (![SpotgoodsAccount sharedInstance].isNeedLogin) {
                                if ([CacheEngine getSpotgoodsInfoUsername] != nil && [CacheEngine getSpotgoodsInfoPassword] != nil) {
                                    [DataEngine requestSpotgoodsLoginWithUsername:[CacheEngine getSpotgoodsInfoUsername]
                                                                         Password:[CacheEngine getSpotgoodsInfoPassword]];
                                }
                            }
                        }
                        
                        [DataEngine requestUpdateUMDevicesWithBlock:^(BOOL SUCCESS) {
                            [[UIEngine sharedInstance] hideProgress];
                            [self popEvent];
                            
                            //提醒是否设置手势密码
                            if (![CacheEngine isSetPwd]||self.isGesForget == YES) {
                                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                                NSArray * array = [[UIApplication sharedApplication] windows];
                                if (array.count >= 2) {
                                    window = [array objectAtIndex:1];
                                }
                                if (self.isGesForget) {
                                    //直接设置
                                    [CLLockVC showSettingLockVCInVC:window.rootViewController successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                                        [CacheEngine setOpenGes:YES];
                                        [CacheEngine setGesPwd:pwd];
                                        [lockVC dismiss:0.0f];
                                        [self popEvent];
                                    }];
                                }
                                else
                                {
                                    //提醒设置
                                    [[UIEngine sharedInstance] showAlertWithTitle:@"为了您的账号安全\n请您设置手势密码" ButtonNumber:2 FirstButtonTitle:@"取消" SecondButtonTitle:@"设置"];
                                    [UIEngine sharedInstance].alertClick = ^(int aIndex){
                                        if (aIndex == 10087) {
                                            [CLLockVC showSettingLockVCInVC:window.rootViewController successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                                                [CacheEngine setGesPwd:pwd];
                                                [CacheEngine setOpenGes:YES];
                                                [lockVC dismiss:0.0f];
                                                
                                            }];
                                        }
                                        
                                    };
                                }
                            }
                        }];
                        
                        
                        
                    }else{
                        [[UIEngine sharedInstance] hideProgress];
                        if ([[NSString stringWithFormat:@"%@",dictionary[@"code"]] isEqualToString:@"406"]) {
                            
                            if ([dictionary[@"data"] floatValue] ==4) {
                                [[UIEngine sharedInstance] showAlertWithTitle:@"密码有误，请重新输入" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
                                [UIEngine sharedInstance].alertClick=^(int  aIndex){};
                            }
                            else if ([dictionary[@"data"] floatValue] !=4 && [dictionary[@"data"] floatValue] !=0 )
                            {
                                [[UIEngine sharedInstance] showAlertWithTitle:[NSString stringWithFormat:@"密码有误，还能再输入%.0f次",[dictionary[@"data"] floatValue]] ButtonNumber:2 FirstButtonTitle:@"忘记密码" SecondButtonTitle:@"再次输入"];
                                [UIEngine sharedInstance].alertClick=^(int  aIndex)
                                {
                                    if (aIndex == 10086) {
                                        RegViewController * forgetVC = [[RegViewController alloc] init];
                                        forgetVC.sourceStr = @"验证账号";
                                        forgetVC.logPhone = phoneTextFiled.text;
                                        [self.navigationController pushViewController:forgetVC animated:YES];
                                    }
                                    if (aIndex == 10087) {
                                        [passWordText becomeFirstResponder];
                                    }
                                };
                                
                                
                            }
                            else
                            {
                                [[UIEngine sharedInstance] showAlertWithTitle:dictionary[@"msg"] ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
                                [UIEngine sharedInstance].alertClick=^(int  aIndex){};
                            }
                            
                        }
                        
                        else if ([[NSString stringWithFormat:@"%@",dictionary[@"code"]] isEqualToString:@"401"]) {
                            if (getUserDefaults(phoneTextFiled.text)) {
                                if ([getUserDefaults(phoneTextFiled.text) isEqualToString:@"5"]) {
                                    [[UIEngine sharedInstance] showAlertWithTitle:dictionary[@"msg"] ButtonNumber:2 FirstButtonTitle:@"确定" SecondButtonTitle:@"忘记密码"];
                                    [UIEngine sharedInstance].alertClick=^(int  aIndex)
                                    {
                                        if (aIndex == 10087) {
                                            RegViewController * forgetVC = [[RegViewController alloc] init];
                                            forgetVC.sourceStr = @"验证账号";
                                            [self.navigationController pushViewController:forgetVC animated:YES];
                                        }
                                    };
                                    
                                }
                            }
                            else
                            {
                                [[UIEngine sharedInstance] showAlertWithTitle:dictionary[@"msg"] ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
                                [UIEngine sharedInstance].alertClick=^(int  aIndex){};
                            }
                        }
                        else if ([[NSString stringWithFormat:@"%@",dictionary[@"code"]] isEqualToString:@"408"]) {
                            [[UIEngine sharedInstance] showAlertWithTitle:dictionary[@"msg"] ButtonNumber:2 FirstButtonTitle:@"确定" SecondButtonTitle:@"注册"];
                            [UIEngine sharedInstance].alertClick=^(int  aIndex)
                            {
                                if (aIndex == 10087) {
                                    RegViewController * regVC = [[RegViewController alloc] init];
                                    regVC.sourceStr = @"注册";
                                    regVC.logPhone = phoneTextFiled.text;
                                    [self.navigationController pushViewController:regVC animated:YES];
                                }
                            };
                        }
                        else
                        {
                            [[UIEngine sharedInstance] showAlertWithTitle:dictionary[@"msg"] ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
                            [UIEngine sharedInstance].alertClick=^(int  aIndex){};
                        }
                    }
                    
                } failureBlock:^(NSError *error) {
                    [UIEngine showShadowPrompt:@"登录超时，请重试"];
                    [[UIEngine sharedInstance] hideProgress];
                }];

            }
            break;
        case 10002:
            {
                if ([getUserDefaults(@"FirstLogin") isEqualToString:@"YES"])
                {
                    //去掉动画效果
//                    [self transitionWithType:@"suckEffect" WithSubtype:kCATransitionFromTop ForView:self.view];
                    
                    iconImg.image = [UIImage imageNamed:@"regist_log"];
                    //把手机号码相关的视图都隐藏掉
                    phoneImg.hidden = NO;
                    phoneLab.hidden = NO;
                    phoneCancelBtn.hidden = YES;
                    phoneLineView.hidden = NO;
                    phoneTextFiled.hidden = NO;
                    phoneLabel.hidden = YES;
                    
                    phoneTextFiled.text = @"";
                    passWordText.text = @"";
                    passWordLab.hidden = NO;
                    
                    //将密码相关的视图的位置都移动
                    passWordImg.frame = CGRectMake(CGRectGetMinX(phoneImg.frame), CGRectGetMaxY(phoneLineView.frame) + 30, 23, 27);
                    passWordText.frame = CGRectMake(CGRectGetMaxX(passWordImg.frame) + 15, CGRectGetMinY(passWordImg.frame), ScreenWidth - CGRectGetMaxX(phoneImg.frame) - 70, 30);
                    passWordLab.frame = CGRectMake(0, 5, ScreenWidth - CGRectGetMaxX(phoneImg.frame) - 30 , 20);
                    pWordCancelBtn.frame = CGRectMake(ScreenWidth - 55, CGRectGetMinY(passWordImg.frame), 50, 35);
                    passWordLineView.frame = CGRectMake(15, CGRectGetMaxY(passWordImg.frame) + 8, ScreenWidth - 30, 0.5);
                    loginBtn.frame = CGRectMake(15, CGRectGetMaxY(passWordLineView.frame) + 33, ScreenWidth - 15*2, 44*ScreenWidth/320);
                    loginImageV.frame = CGRectMake(15, CGRectGetMaxY(passWordLineView.frame) + 33, ScreenWidth - 15*2, 40*ScreenWidth/320);
                    [registBtn setTitle:@"注册账户" forState:UIControlStateNormal];
                    
                    saveUserDefaults(@"NO", @"FirstLogin");

                }else
                {
                    //注册账户
                    RegViewController * regVC = [[RegViewController alloc] init];
                    regVC.sourceStr = @"注册";
                    [self.navigationController pushViewController:regVC animated:YES];
                    
//                    SpotIndexViewController *spotCtrl = [[SpotIndexViewController alloc]init];
//                    [self.navigationController pushViewController:spotCtrl animated:YES];
////                    StopProfitViewController *stopCtrl = [[StopProfitViewController alloc]init];
//                    ClosePositionViewController *stopCtrl = [[ClosePositionViewController alloc]init];
//                    [self.navigationController pushViewController:stopCtrl animated:YES];
                }
            }
            break;
        case 10003:
            {
//                //忘记密码
                RegViewController * forgetVC = [[RegViewController alloc] init];
                forgetVC.sourceStr = @"验证账号";
                forgetVC.logPhone = phoneTextFiled.text;
                [self.navigationController pushViewController:forgetVC animated:YES];
            }
            break;
        case 10004:
        {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)clickCancelAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 201:
        {
            phoneTextFiled.text = @"";
            phoneCancelBtn.hidden = YES;
            phoneLab.hidden = NO;
            [self updateUIbutton:NO];
        }
            break;
        case 202:
        {
            passWordText.text = @"";
            pWordCancelBtn.hidden = YES;
            [self updateUIbutton:NO];
            passWordLab.hidden = NO;
        }
            break;

            
        default:
            break;
    }
}

#pragma mark 用户账户信息（是否开启财牛、积分、南交所账户）
-(void)requestToGetAccount{
    [RequestDataModel requestUserAccountsInfoSuccessBlock:^(BOOL success, id Info) {
        
    }];
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

#pragma mark - 动画效果
#pragma CATransition动画实现
- (void) transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view
{
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //设置运动时间
    animation.duration = 1;
    
    //设置运动type
    animation.type = type;
    NSLog(@"ce shi :%@",subtype);
    if (subtype != nil) {
        
        //设置子类
        animation.subtype = subtype;
    }
    
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [view.layer addAnimation:animation forKey:@"animation"];
}



@end
