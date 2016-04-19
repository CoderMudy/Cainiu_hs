//
//  RegViewController.m
//  hs
//
//  Created by hzl on 15-4-16.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import "RegViewController.h"
#import "CheckRegViewController.h"
#import "LoginViewController.h"
#import "AFMInfoBanner.h"
#import "NetRequest.h"
#import "Helper.h"
#import "DetailViewController.h"
#import "NSString+MD5.h"

@interface RegViewController ()

//下一步按钮
@property (strong, nonatomic) UIButton *nextbut;
//放大
@property (strong, nonatomic) UILabel *showPhoneLab;
//勾选
@property (strong, nonatomic) UIButton *didReadBtn;
//协议
@property (strong, nonatomic) UIButton *readDetailLab;
//协议底层的view
@property (strong, nonatomic) UIView *hidenView;
//财牛不会泄露
@property (strong, nonatomic) UILabel *hidenLab;
//icon
@property (strong, nonatomic) UIImageView *phoneIcon;

@property (strong, nonatomic) UIView *redLineTop;

@property (strong, nonatomic) UIView *redLineBottom;


@end

@implementation RegViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"注册"];
    [[UIEngine sharedInstance] hideProgress];
    self.navigationController.navigationBarHidden = NO;
    removeTextFileNotification;
}

- (void)btnPressed:(id)sender {
    [self   checkIphone];
    
    [UIEngine sharedInstance].progressStyle=1;
    [[UIEngine sharedInstance] showProgress];
    
    NSString * strIphone = self.regIphoneTextField.text;
    NSString * tele =[strIphone stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * sign =[NSString stringWithFormat:@"%@luckin",tele];

    NSDictionary * dic = @{@"tele":tele,
                           @"version":VERSION,
                           @"sign":[sign MD5Digest]
                         };
    NSString * addUrl = @"/user/sms/getRegCode";
    if ([self.sourceStr isEqualToString:@"验证账号"]) {
        
//忘记密码的URL
        
        addUrl = @"/user/sms/findLoginPwdCode";
        
    }
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",K_MGLASS_URL,addUrl];
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        [[UIEngine sharedInstance] hideProgress];
        if ([dictionary[@"code"] integerValue] == 200)
        {
            NSLog(@"%@",dictionary);
            CheckRegViewController * checkVC = [[CheckRegViewController alloc] init];
            checkVC.regPhone = tele;
            checkVC.checkNum = dictionary[@"data"];
            checkVC.sourceStr = _sourceStr;
            [self.navigationController pushViewController:checkVC animated:YES];
        }else
        {
            
            NSString * message = dictionary[@"msg"];
            
            if ([dictionary[@"code"] floatValue] == 407) {

                [[UIEngine sharedInstance] showAlertWithTitle:@"您输入的手机号已被注册" ButtonNumber:2 FirstButtonTitle:@"忘记密码" SecondButtonTitle:@"登录"];
                [UIEngine sharedInstance].alertClick=^(int aIndex)
                {
                    if (aIndex==10086) {
                        RegViewController *reg=[[RegViewController alloc]init];
                        reg.sourceStr=@"验证账号";
                        reg.logPhone = self.regIphoneTextField.text;
                        [self.navigationController pushViewController:reg animated:YES];
                    }
                    else
                    {
                        [[CMStoreManager sharedInstance] storeUserName:self.regIphoneTextField.text];
                        LoginViewController * loginVC = [[LoginViewController alloc]init];
                        loginVC.isRegInto = YES;
                        loginVC.isRegister = @"YES";
                        loginVC.regPhone = self.regIphoneTextField.text;
                        [self.navigationController pushViewController:loginVC animated:YES];
                    }
                };

            }
            else if ([dictionary[@"code"] floatValue] == 408)
            {
                [[UIEngine sharedInstance] showAlertWithTitle:message ButtonNumber:2 FirstButtonTitle:@"确定" SecondButtonTitle:@"注册"];
                [UIEngine sharedInstance].alertClick = ^(int aIndex){
                    if (aIndex == 10087) {
                        RegViewController *reg=[[RegViewController alloc]init];
                        reg.sourceStr=@"注册";
                        reg.logPhone = self.regIphoneTextField.text;
                        [self.navigationController pushViewController:reg animated:YES];
                    }
                };
            }
            else if ([dictionary[@"code"] floatValue] == 400)
            {
                PersionShowAlert(message);
            }
            else
            {
                [UIEngine showShadowPrompt:message];
            }
            
            
        }
        
        
    } failureBlock:^(NSError *error) {
        
        [[UIEngine sharedInstance] hideProgress];
    }];
    
}

-(void )updateUIbutton:(BOOL) bEnable
{
    if (self.nextbut.enabled == bEnable)
        return ;
    
    self.nextbut.enabled = bEnable;
    [self.nextbut setBackgroundColor:(bEnable ? RGBACOLOR(255, 62, 27, 1):[UIColor lightGrayColor])];
    
}

// 监听清除按钮，按钮灰色

- (BOOL)textFieldShouldClear:(UITextField *)textField;
{
    [self updateUIbutton:FALSE];
    return  YES;
}
// 监听文本输入
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
    
    // 手机三或四位加空格，最多输入11位的手机号码
    NSString   * tmpphone = textField.text;
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    
    if ((existedLength - selectedLength + replaceLength > 11) && replaceLength >0)
    {
        //        [self updateUIbutton:FALSE];
        return NO;
    }
    else if ((existedLength - selectedLength + replaceLength >= 11) && replaceLength >0)
    {
        //判断输入的手机号码格式是否正确
        NSString * tmpphoneNum = [NSString stringWithFormat:@"%@%@",tmpphone,string];
        NSString *loginUserNum = [tmpphoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        BOOL  telFormat = [Helper checkTel:loginUserNum];
        if (telFormat == NO)
        {

        }
        else {
            
        }
    }
    else
    {
    }
    
    return  YES;
}

- (void)removeLab:(UILabel*)lab
{
    
    [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionOverrideInheritedDuration animations:^{
        [lab removeFromSuperview];
        
    } completion:nil];
    
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.regIphoneTextField resignFirstResponder];
}

-(void )viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"注册"];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;

    [self.regIphoneTextField becomeFirstResponder];
    addTextFieldNotification(textFieldValueChange);
}

- (void)readAgreement:(UIButton *)sender
{
    if (sender.selected==YES) {
        sender.selected=NO;
        self.nextbut.enabled=NO;
        self.nextbut.backgroundColor=[UIColor lightGrayColor];
        
    }
    else
    {
        sender.selected=YES;
        if (self.regIphoneTextField.text.length>0) {
            self.nextbut.enabled=YES;
            self.nextbut.backgroundColor=RGBACOLOR(255, 62, 27, 1);
        }
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadUI];
    
    self.regIphoneTextField.delegate=self;
    [self.regIphoneTextField addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventValueChanged];
    self.regIphoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.didReadBtn setBackgroundImage:[UIImage imageNamed:@"button_09"] forState:UIControlStateSelected];
    [self.didReadBtn setBackgroundImage:[UIImage imageNamed:@"button_10"] forState:UIControlStateNormal];
    self.didReadBtn.selected=YES;
    
    [self.nextbut setBackgroundColor:[UIColor lightGrayColor]];
    self.nextbut.enabled = NO;
    
    self.nextbut.layer.cornerRadius = 6;
    self.nextbut.layer.masksToBounds = YES;
    
    if (self.logPhone.length > 0) {
        self.regIphoneTextField.text = self.logPhone;
        [self.nextbut setBackgroundColor:RGBACOLOR(255, 62, 27, 1)];
        [self.nextbut setEnabled:YES];
        [self textFieldValueChange];
    }
    
    //导航
    
    [self setBackButton];
    [self setNavibarBackGroundColor:K_color_red];

    if ([self.sourceStr length]>0) {
        [self setNaviTitle:self.sourceStr];
        if ([self.sourceStr isEqualToString:@"验证账号"]) {
            [self setBackButton];
//            self.customLeft = YES;
//            
//            RegViewController *regVC = self;
//            
//            self.leftClick = ^(void){
//                [regVC.navigationController popViewControllerAnimated:YES];
//            };
        }
    }else{
        [self setNaviTitle:@"注册"];
    }
    
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    if ([self.sourceStr isEqualToString:@"验证账号"]) {
        self.hidenLab.hidden = YES;
        self.hidenView.hidden = YES;
        
        
        
        self.nextbut = [UIButton buttonWithType:UIButtonTypeCustom];
        if(self.regIphoneTextField.text.length==0)
        {
            self.nextbut.enabled = NO;
            self.nextbut.frame = CGRectMake(20, 10+50+15 + 64, ScreenWidth-40, 44);
            self.nextbut.backgroundColor=[UIColor lightGrayColor];
        }
        else
        {
            self.showPhoneLab.text = self.logPhone;
            self.nextbut.frame = CGRectMake(20, self.showPhoneLab.frame.origin.y+self.showPhoneLab.frame.size.height+15, ScreenWidth-40, 44);
            self.nextbut.backgroundColor=RGBACOLOR(255, 62, 27, 1);
        }
        
        
        self.nextbut.clipsToBounds=YES;
        self.nextbut.layer.cornerRadius=6;
        
        [self.nextbut setTitle:@"下一步" forState:UIControlStateNormal];
        [self.nextbut addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.nextbut];
    }
    
    // Do any additional setup after loading the view.
}

#pragma mark UI

-(void)loadUI
{
    UIView  *topBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 74, ScreenWidth, 50)];
    topBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topBackgroundView];
    
    self.redLineTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    self.redLineTop.backgroundColor = [UIColor redColor];
    [topBackgroundView addSubview:self.redLineTop];
    
    self.phoneIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, topBackgroundView.frame.size.height/2-25/2-2, 25, 25)];
    self.phoneIcon.image = [UIImage imageNamed:@"icon_01"];
    [topBackgroundView addSubview:self.phoneIcon];
    
    self.regIphoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(60, 1, ScreenWidth-80, 48)];
    self.regIphoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.regIphoneTextField.delegate=self;
    self.regIphoneTextField.font = [UIFont systemFontOfSize:14];
    self.regIphoneTextField.placeholder = @"请输入手机号";
    [topBackgroundView addSubview:self.regIphoneTextField];
    
    self.redLineBottom = [[UIView alloc]initWithFrame:CGRectMake(0, topBackgroundView.frame.size.height-1, ScreenWidth, 1)];
    self.redLineBottom.backgroundColor=[UIColor redColor];
    [topBackgroundView addSubview:self.redLineBottom];
    
    
    self.showPhoneLab=[[UILabel alloc]initWithFrame:CGRectMake(0, topBackgroundView.frame.size.height+topBackgroundView.frame.origin.y, ScreenWidth, 55)];
    self.showPhoneLab.backgroundColor=RGBACOLOR(220, 220, 220, 0.9);
    self.showPhoneLab.textAlignment=NSTextAlignmentCenter;
    self.showPhoneLab.font=[UIFont systemFontOfSize:28];
    self.showPhoneLab.alpha=0;
    self.showPhoneLab.textColor=[UIColor redColor];
    [self.view addSubview:self.showPhoneLab];
    
    self.hidenView = [[UIView alloc]initWithFrame:CGRectMake(0, self.showPhoneLab.frame.origin.y+10, ScreenWidth, 80)];
    [self.view addSubview:self.hidenView];
    
    NSString *niu = App_appShortName;
    
//#if defined (CAINIUA)
//    niu = NIUA;
//#elif defined (NIUAAPPSTORE)
//    niu = NIUA;
//#else
//    niu = CAINIU;
//#endif
    
    self.hidenLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 18)];
    self.hidenLab.textColor = [UIColor grayColor];
    self.hidenLab.textAlignment = NSTextAlignmentCenter;
    self.hidenLab.font = [UIFont systemFontOfSize:12];
    self.hidenLab.text = [NSString stringWithFormat:@"%@不会在任何地方泄露您的号码",niu];
    [self.hidenView addSubview:self.hidenLab];
    
    self.didReadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.didReadBtn.frame = CGRectMake(ScreenWidth/2-100, self.hidenLab.frame.size.height+1.5, 15, 15);
    [self.didReadBtn setBackgroundImage:[UIImage imageNamed:@"button_09"] forState:UIControlStateNormal];
    [self.didReadBtn setBackgroundImage:[UIImage imageNamed:@"button_10"] forState:UIControlStateSelected];
    self.didReadBtn.selected = YES;
    [self.didReadBtn addTarget:self action:@selector(readAgreement:) forControlEvents:UIControlEventTouchUpInside];
    [self.hidenView addSubview:self.didReadBtn];
    
    UILabel *readLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.didReadBtn.frame.size.width+self.didReadBtn.frame.origin.x+2, self.didReadBtn.frame.origin.y-1.5, 85, 18)];
    readLabel.textColor = [UIColor grayColor];
    readLabel.text = @"我已阅读并同意";
    readLabel.font = [UIFont systemFontOfSize:12];
    [self.hidenView addSubview:readLabel];
    
    self.readDetailLab = [UIButton buttonWithType:UIButtonTypeCustom];
    self.readDetailLab.frame = CGRectMake(readLabel.frame.origin.x+readLabel.frame.size.width-5, readLabel.frame.origin.y, 115, 18);
    NSString * detailText = [NSString stringWithFormat:@"《%@服务协议》",App_appShortName];
    [self.readDetailLab setTitle:detailText forState:UIControlStateNormal];
    [self.readDetailLab setTitleColor:RGBACOLOR(48, 115, 204, 1) forState:UIControlStateNormal];
    self.readDetailLab.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.readDetailLab addTarget:self action:@selector(agreement) forControlEvents:UIControlEventTouchUpInside];
    [self.hidenView addSubview:self.readDetailLab];
    
    self.nextbut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextbut.frame = CGRectMake(20, self.readDetailLab.frame.origin.y+self.readDetailLab.frame.size.height+12, ScreenWidth-40, 44);
    self.nextbut.backgroundColor=RGBACOLOR(255, 62, 27, 1);
    [self.nextbut setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextbut addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.hidenView addSubview:self.nextbut];
    
}

-(void)agreement
{
    DetailViewController    *detailVC = [[DetailViewController alloc]init];
    detailVC.index = 5;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)textFieldValueChange
{
    if ([self.navigationController.viewControllers.lastObject isKindOfClass:[self class]]) {
        //下一步按钮
        if(self.didReadBtn.selected&&self.regIphoneTextField.text.length==11)
        {
            self.nextbut.enabled=YES;
            self.nextbut.backgroundColor=RGBACOLOR(255, 62, 27, 1);
        }
        else
        {
            self.nextbut.enabled=NO;
            self.nextbut.backgroundColor=[UIColor lightGrayColor];
        }
        
        
        //放大加空格手机号
        NSString *proStr=self.regIphoneTextField.text;
        NSMutableArray *proArray=[NSMutableArray array];
        for (int i =0; i<proStr.length; i++) {
            NSString *str=@"";
            if (i==0) {
                str=[NSString stringWithFormat:@"%@",[proStr substringToIndex:1]];
            }
            
            else if (i==proStr.length-1) {
                str = [NSString stringWithFormat:@"%@",[[proStr substringFromIndex:i] substringToIndex:1]];
            }
            
            else
            {
                str = [NSString stringWithFormat:@"%@",[[proStr substringFromIndex:i] substringToIndex:1]];
            }
            
            [proArray addObject:str];
        }
        
        NSMutableArray *temArray=[NSMutableArray arrayWithArray:proArray];
        if (proStr.length>3) {
            int count=0;
            if (proArray.count>=3&&proArray.count<=7) {
                count=1;
            }
            
            if (proArray.count>=8) {
                count=2;
            }
            
            for (int i =0; i<count; i++) {
                if(i==0)
                {
                    [temArray insertObject:@" " atIndex:3];
                }
                else if(i==1)
                {
                    [temArray insertObject:@" " atIndex:8];
                }
            }
        }
        
        proStr=@"";
        for (int i = 0; i<temArray.count; i++) {
            proStr=[proStr stringByAppendingString:temArray[i]];
        }
        self.showPhoneLab.text=proStr;
        
        //灰色区域隐藏
        if (_regIphoneTextField.text.length>0) {
            
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.showPhoneLab.alpha=1;
                self.hidenView.frame = CGRectMake(0, self.showPhoneLab.frame.size.height+self.showPhoneLab.frame.origin.y+10, ScreenWidth, 80);
            } completion:nil];
            
            
        }
        else
        {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.showPhoneLab.alpha=0;
                
                self.hidenView.frame = CGRectMake(0, self.showPhoneLab.frame.origin.y+10, ScreenWidth, 80);
            } completion:nil];
            
        }
        
        
        if ([self.sourceStr isEqualToString:@"验证账号"]) {
            self.hidenLab.hidden = YES;
            self.hidenView.hidden = YES;
            
            if (_regIphoneTextField.text.length>0) {
                
                [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.nextbut.frame = CGRectMake(20, 10+50+65 + 64, ScreenWidth-40, 44);
                } completion:nil];
                
                
            }
            else
            {
                [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.nextbut.frame = CGRectMake(20, 10+50+15 + 64, ScreenWidth-40, 44);
                } completion:nil];
                
            }
            
            
        }
    }
    
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!textField.window.isKeyWindow) {
        [textField.window makeKeyAndVisible];
    }
    self.phoneIcon.image=[UIImage imageNamed:@"icon_03"];
    self.redLineTop.backgroundColor=[UIColor redColor];
    self.redLineBottom.backgroundColor=[UIColor redColor];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.phoneIcon.image=[UIImage imageNamed:@"icon_01"];
    self.redLineTop.backgroundColor=[UIColor lightGrayColor];
    self.redLineBottom.backgroundColor=[UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)checkIphone
{
    NSString * strIphone =[self.regIphoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([strIphone length ] == 0)
        return NO;
    
    NSString * first = [strIphone substringToIndex:1];
    
//    NSLog(@"ihpone =%@  first%@" ,strIphone,first);
    
    
    if( ![first isEqualToString:@"1"] )
        return  NO;
    
    return  TRUE;
}


@end
