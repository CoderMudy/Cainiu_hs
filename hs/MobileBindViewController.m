//
//  MobileBindViewController.m
//  hs
//
//  Created by RGZ on 15/6/2.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "MobileBindViewController.h"
#import "CheckRegViewController.h"
#import "LoginViewController.h"

@interface MobileBindViewController ()
{
    UIScrollView    *_scrollView;
    
    //上下红线
    UIView          *_topLine;
    UIView          *_bottomLine;
    //手机icon
    UIImageView     *_phoneIcon;
    
    UITextField     *_phoneTF;
    //放大手机号显示
    UILabel         *_phonePro;
    
    UIButton        *_nextBtn;
    
}
@end

@implementation MobileBindViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"手机绑定"];
    if ([_privateUserInfo.statusMobile isEqualToString:@"1"])
    {
        self.isBind = YES;
    }
    
    if (_scrollView!=nil) {
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        [self loadNav];
        [self loadUI];
    }
    
    addTextFieldNotification(textFieldValueChange);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNav];
    
    [self loadData];
    
    [self loadUI];
}

-(void)loadNav
{
    if (self.isBind) {
        NavTitle(@"手机号绑定");
    }
    else
    {
        NavTitle(@"绑定手机");
    }
}

-(void)loadData
{
    //改变PrivateUserInfo通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePrivateUserInfo:) name:uPrivateUserInfo object:nil];
}

-(void)changePrivateUserInfo:(NSNotification *)notify
{
    NSString    *phoneNumberStr = [notify.userInfo objectForKey:@"PhoneNumber"];
    
    self.privateUserInfo.statusMobile = @"1";
    self.privateUserInfo.mobile = phoneNumberStr;
    self.block(self.privateUserInfo);
}

-(void)loadUI
{
    self.view.backgroundColor=RGBACOLOR(245, 245, 245, 1);
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
    _scrollView.backgroundColor =  RGBACOLOR(239, 239, 244, 1);
    _scrollView.indicatorStyle=UIScrollViewIndicatorStyleDefault;
    _scrollView.contentSize=CGSizeMake(ScreenWidth, ScreenHeigth+2);
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.userInteractionEnabled=YES;
    _scrollView.delegate=self;
    [self.view addSubview:_scrollView];
    
    [self loadTextField];
}

-(void)loadTextField
{
    //输入框底层view
    UIView  *coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, ScreenWidth, 50)];
    [_scrollView addSubview:coverView];
    
    //上下红线
    _topLine = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    _topLine.backgroundColor=[UIColor redColor];
    [coverView addSubview:_topLine];
    
    _bottomLine = [[UIView  alloc]initWithFrame:CGRectMake(0, coverView.frame.size.height-1, ScreenWidth, 1)];
    _bottomLine.backgroundColor=[UIColor redColor];
    [coverView addSubview:_bottomLine];
    
    //手机icon
    _phoneIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, coverView.frame.size.height/2-25/2-2, 25, 25)];
    _phoneIcon.image = [UIImage imageNamed:@"icon_03"];
    [coverView addSubview:_phoneIcon];
        
    //输入框
    
    _phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(_phoneIcon.frame.size.width+_phoneIcon.frame.origin.x+10, 0,ScreenWidth - _phoneTF.frame.origin.x - 20, coverView.frame.size.height)];
    _phoneTF.placeholder = @"请输入手机号";
    _phoneTF.returnKeyType = UIReturnKeyDone;
    _phoneTF.delegate = self;
    _phoneTF.font = [UIFont systemFontOfSize:14];
    _phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [_phoneTF addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventValueChanged];
    [coverView addSubview:_phoneTF];
    [_phoneTF becomeFirstResponder];
    
    //放大显示手机号
    _phonePro = [[UILabel alloc]initWithFrame:CGRectMake(0, coverView.frame.origin.y+coverView.frame.size.height, ScreenWidth, 60)];
    _phonePro.textColor = [UIColor redColor];
    _phonePro.backgroundColor = RGBACOLOR(220, 220, 220, 0.9);
    _phonePro.textAlignment = NSTextAlignmentCenter;
    _phonePro.font = [UIFont systemFontOfSize:28];
    _phonePro.alpha = 0;
    [_scrollView addSubview:_phonePro];
    
    if (self.isBind) {
        
        _phoneTF.enabled = NO;
        _phoneTF.textAlignment = NSTextAlignmentCenter;
        _phoneTF.textColor = [UIColor grayColor];
        _phoneTF.text = [NSString stringWithFormat:@"%@****%@",[_privateUserInfo.mobile substringToIndex:3],[_privateUserInfo.mobile substringFromIndex:_privateUserInfo.mobile.length-4]];
        
        int pointX =ScreenWidth/4+15;
        
        if (ScreenWidth > 320) {
            pointX =ScreenWidth/2 -_phoneIcon.frame.size.width - 40;
        }
        
        _phoneIcon.frame = CGRectMake(pointX, _phoneIcon.frame.origin.y, _phoneIcon.frame.size.width, _phoneIcon.frame.size.height);
        _phoneIcon.image = [UIImage imageNamed:@"icon_01"];
        
        coverView.backgroundColor = RGBACOLOR(225, 225, 225, 1);
        
        _topLine.backgroundColor = [UIColor lightGrayColor];
        _bottomLine.backgroundColor = [UIColor lightGrayColor];
        
        
        UILabel *proLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _phonePro.frame.origin.y+15, ScreenWidth, 18)];
        proLabel.textColor = [UIColor grayColor];
        proLabel.font = [UIFont systemFontOfSize:12];
        proLabel.textAlignment = NSTextAlignmentCenter;
        proLabel.text = @"您已成功绑定手机号";
        [_scrollView addSubview:proLabel];
    }
    else
    {
        //下一步按钮
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.frame = CGRectMake(20, _phonePro.frame.origin.y+15, ScreenWidth-40, 44);
        [_nextBtn setBackgroundColor:[UIColor lightGrayColor]];
        [_nextBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextBtn.clipsToBounds = YES;
        _nextBtn.layer.cornerRadius = 6;
        [_scrollView addSubview:_nextBtn];
    }
    
    
    
    
    
}

-(void)nextClick
{
    if([self checkPhoneNumber])
    {
        
        
        
        [UIEngine sharedInstance].progressStyle = 1;
        [[UIEngine sharedInstance] showProgress];
        [DataEngine requestToSendAuthCode:_phoneTF.text Complete:^(BOOL SUCCESS, NSString *code, NSString *msg,NSString *httpCode)
        {
            if (SUCCESS)
            {
                CheckRegViewController  *checkVC = [[CheckRegViewController alloc]init];
                checkVC.regPhone = _phoneTF.text;
                checkVC.checkNum = code;
                checkVC.isBindMobile = YES;
                checkVC.isCharge = self.isCharge;
                [self.navigationController pushViewController:checkVC animated:YES];
            }
            else if ([[NSString stringWithFormat:@"%@",httpCode] isEqualToString:@"400"] )
            {
                [[UIEngine sharedInstance] showAlertWithTitle:msg ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
                [UIEngine sharedInstance].alertClick = ^(int aIndex){};
            }
            else if ([[NSString stringWithFormat:@"%@",httpCode] isEqualToString:@"407"])
            {
                [[UIEngine sharedInstance] showAlertWithTitle:@"该手机号已被注册，您可以直接登录" ButtonNumber:2 FirstButtonTitle:@"取消" SecondButtonTitle:@"登录"];
                [UIEngine sharedInstance].alertClick = ^(int aIndex)
                {
                    if (aIndex == 10086) {
                        
                    }
                    else if(aIndex == 10087)
                    {
                        LoginViewController  *loginVC = [[LoginViewController alloc]init];
                        loginVC.isRegInto = YES;
                        loginVC.regPhone = _phoneTF.text;
                        loginVC.isNeedPopRootController = YES;
                        [self.navigationController pushViewController:loginVC animated:YES];
                    }
                };
            }
            else
            {
                if (msg.length>0) {
                    [UIEngine showShadowPrompt:msg];
                }
                else
                {
//                    [UIEngine showShadowPrompt:@"！您当前网络不佳，请稍后再试"];
                }
            }
            [[UIEngine sharedInstance] hideProgress];
        }];
    }
    else
    {
        return;
    }
}

-(BOOL)checkPhoneNumber
{
    NSString *loginUserNum = [_phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    BOOL  telFormat = [Helper checkTel:loginUserNum];
    
    if (!telFormat)
    {
        [UIEngine showShadowPrompt:@"您输入的手机号格式有误"];
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)textFieldValueChange
{
    if(_phoneTF.text.length > 11)
    {
        _phoneTF.text = [_phoneTF.text substringToIndex:11];
    }
    
    //下一步按钮
    if(_phoneTF.text.length==11)
    {
        _nextBtn.enabled=YES;
        _nextBtn.backgroundColor=RGBACOLOR(255, 62, 27, 1);
        
        [self checkPhoneNumber];
    }
    else
    {
        _nextBtn.enabled=NO;
        _nextBtn.backgroundColor=[UIColor lightGrayColor];
    }
    
    
    //放大加空格手机号
    NSString *proStr=_phoneTF.text;
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
    _phonePro.text=proStr;
    
    //灰色区域隐藏
    if (_phoneTF.text.length>0) {
        
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _phonePro.alpha=1;
            _nextBtn.frame = CGRectMake(20, _phonePro.frame.size.height+_phonePro.frame.origin.y+15, ScreenWidth-40, 44);
        } completion:nil];
        
        
    }
    else
    {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _phonePro.alpha=0;
            
            _nextBtn.frame = CGRectMake(20, _phonePro.frame.origin.y+15, ScreenWidth-40, 44);
        } completion:nil];
        
    }
    
    
    
    
    
        
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!textField.window.isKeyWindow) {
        [textField.window makeKeyAndVisible];
    }
    _topLine.backgroundColor = [UIColor redColor];
    _bottomLine.backgroundColor = [UIColor redColor];
    _phoneIcon.image = [UIImage imageNamed:@"icon_03"];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _topLine.backgroundColor = [UIColor lightGrayColor];
    _bottomLine.backgroundColor = [UIColor lightGrayColor];
    _phoneIcon.image = [UIImage imageNamed:@"icon_01"];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view.window endEditing:YES];
    _topLine.backgroundColor = [UIColor lightGrayColor];
    _bottomLine.backgroundColor = [UIColor lightGrayColor];
    _phoneIcon.image = [UIImage imageNamed:@"icon_01"];
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"手机绑定"];
    [[UIEngine sharedInstance] hideProgress];
    [self.view.window endEditing:YES];
    removeTextFileNotification;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view.window endEditing:YES];
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
