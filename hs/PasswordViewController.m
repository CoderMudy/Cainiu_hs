//
//  PasswordViewController.m
//  hs
//
//  Created by RGZ on 15/5/21.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "PasswordViewController.h"
#import "LoginViewController.h"
@interface PasswordViewController ()
{
    UIScrollView    *_scrollView;
    UITextField     *_oldPwdTF;
    UITextField     *_newPwdTF;
    UIButton        *_commitButton;
    
    UIButton        *_eyesOld;
    UIButton        *_eyesNew;
}
@end

@implementation PasswordViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"修改密码"];
    if (![[CMStoreManager sharedInstance] isLogin]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    [[UIEngine sharedInstance] hideProgress];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEdit) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"修改密码"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[UIEngine sharedInstance] hideProgress];
    UIView *lineHeader = [_scrollView viewWithTag:101];
    UIView *lineFooter = [_scrollView viewWithTag:102];
    UIView *lineLaster = [_scrollView viewWithTag:103];
    
    lineHeader.backgroundColor = [UIColor lightGrayColor];
    lineFooter.backgroundColor = [UIColor lightGrayColor];
    lineLaster.backgroundColor = [UIColor lightGrayColor];
    [self.view.window endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNav];
    
    [self loadUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)loadNav
{
    NavTitle(@"修改密码");
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view.window endEditing:YES];
    UIView *lineHeader = [_scrollView viewWithTag:101];
    UIView *lineFooter = [_scrollView viewWithTag:102];
    UIView *lineLaster = [_scrollView viewWithTag:103];
    
    lineHeader.backgroundColor = [UIColor lightGrayColor];
    lineFooter.backgroundColor = [UIColor lightGrayColor];
    lineLaster.backgroundColor = [UIColor lightGrayColor];
}

-(void)loadUI
{
    self.view.backgroundColor = RGBACOLOR(239, 239, 244, 1);
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
    _scrollView.backgroundColor = RGBACOLOR(239, 239, 244, 1);
    _scrollView.indicatorStyle=UIScrollViewIndicatorStyleDefault;
    _scrollView.contentSize=CGSizeMake(ScreenWidth, ScreenHeigth+2);
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.userInteractionEnabled=YES;
    _scrollView.delegate=self;
    [self.view addSubview:_scrollView];
    
    
    UIView *backGroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 100)];
    backGroundView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:backGroundView];
    
    UIView *lineHeader=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    lineHeader.tag = 101;
    lineHeader.backgroundColor=[UIColor redColor];
    [backGroundView addSubview:lineHeader];
    
    UIView *lineFooter=[[UIView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, 0.5)];
    lineFooter.tag = 102;
    lineFooter.backgroundColor=[UIColor redColor];
    [backGroundView addSubview:lineFooter];
    
    UIView *lineLast=[[UIView alloc]initWithFrame:CGRectMake(0, 100, ScreenWidth, 0.5)];
    lineLast.tag = 103;
    lineLast.backgroundColor=[UIColor lightGrayColor];
    [backGroundView addSubview:lineLast];
    
    _oldPwdTF=[[UITextField alloc]initWithFrame:CGRectMake(20, 0, ScreenWidth-40-50, 50)];
    _oldPwdTF.delegate=self;
    _oldPwdTF.tag=10010;
    _oldPwdTF.font = [UIFont systemFontOfSize:14];
    _oldPwdTF.secureTextEntry=YES;
    _oldPwdTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _oldPwdTF.placeholder=@"输入旧密码";
    _oldPwdTF.returnKeyType=UIReturnKeyDone;
    [_oldPwdTF becomeFirstResponder];
    [_oldPwdTF addTarget:self action:@selector(textFieldEdit) forControlEvents:UIControlEventValueChanged];
    [backGroundView addSubview:_oldPwdTF];
    
    _eyesOld=[UIButton buttonWithType:UIButtonTypeCustom];
    _eyesOld.tag=999;
    _eyesOld.frame=CGRectMake(ScreenWidth-20-40, _oldPwdTF.frame.origin.y+15, 30, 20);
    [_eyesOld setBackgroundImage:[UIImage imageNamed:@"button_04"] forState:UIControlStateNormal];
    [_eyesOld setBackgroundImage:[UIImage imageNamed:@"button_05"] forState:UIControlStateSelected];
    [_eyesOld addTarget:self action:@selector(showPwd:) forControlEvents:UIControlEventTouchUpInside];
    _eyesOld.selected=NO;
    [backGroundView addSubview:_eyesOld];
    
    _newPwdTF=[[UITextField alloc]initWithFrame:CGRectMake(20, 50, ScreenWidth-40-50, 50)];
    _newPwdTF.delegate=self;
    _newPwdTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _newPwdTF.placeholder=@"输入新密码";
    _newPwdTF.secureTextEntry=YES;
    _newPwdTF.font = [UIFont systemFontOfSize:14];
    _newPwdTF.returnKeyType=UIReturnKeyDone;
    _newPwdTF.tag=10086;
    [_newPwdTF addTarget:self action:@selector(textFieldEdit) forControlEvents:UIControlEventValueChanged];
    [backGroundView addSubview:_newPwdTF];
    
    _eyesNew=[UIButton buttonWithType:UIButtonTypeCustom];
    _eyesNew.tag=9999;
    _eyesNew.frame=CGRectMake(ScreenWidth-20-40, _newPwdTF.frame.origin.y+15, 30, 20);
    [_eyesNew setBackgroundImage:[UIImage imageNamed:@"button_04"] forState:UIControlStateNormal];
    [_eyesNew setBackgroundImage:[UIImage imageNamed:@"button_05"] forState:UIControlStateSelected];
    [_eyesNew addTarget:self action:@selector(showPwd:) forControlEvents:UIControlEventTouchUpInside];
    _eyesNew.selected=NO;
    [backGroundView addSubview:_eyesNew];
    
    
    UILabel *proLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, backGroundView.frame.size.height+backGroundView.frame.origin.y+8, ScreenWidth, 18)];
    proLabel.text=@"6-20位数字、字母组合（特殊字符除外）";
    proLabel.textColor=RGBACOLOR(188, 188, 188, 1);
    proLabel.textAlignment=NSTextAlignmentCenter;
    proLabel.font=[UIFont systemFontOfSize:13];
    [_scrollView addSubview:proLabel];
    
    _commitButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _commitButton.frame=CGRectMake(20, proLabel.frame.size.height+proLabel.frame.origin.y+8, ScreenWidth-40, 44);
    [_commitButton setTitle:@"提交" forState:UIControlStateNormal];
    _commitButton.backgroundColor=RGBACOLOR(188, 188, 188, 1);
    _commitButton.clipsToBounds=YES;
    _commitButton.enabled=NO;
    _commitButton.layer.cornerRadius=6;
    [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_commitButton addTarget:self action:@selector(commitAlter) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_commitButton];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!textField.window.isKeyWindow) {
        [textField.window makeKeyAndVisible];
    }
    UIView *lineHeader = [_scrollView viewWithTag:101];
    UIView *lineFooter = [_scrollView viewWithTag:102];
    UIView *lineLaster = [_scrollView viewWithTag:103];
    if (textField.tag == 10010)
    {
        lineHeader.backgroundColor = [UIColor redColor];
        lineFooter.backgroundColor = [UIColor redColor];
        
        lineLaster.backgroundColor = [UIColor lightGrayColor];
    }
    else
    {
        lineFooter.backgroundColor = [UIColor redColor];
        lineLaster.backgroundColor = [UIColor redColor];
        
        lineHeader.backgroundColor = [UIColor lightGrayColor];
    }
}

-(void)commitAlter
{
    if (_oldPwdTF.text.length==0) {
        [UIEngine showShadowPrompt:@"请输入旧密码"];
        return;
    }
    
    if (_newPwdTF.text.length==0) {
        [UIEngine showShadowPrompt:@"请输入新密码"];
        return;
    }
    
    if (_oldPwdTF.text.length<6||_oldPwdTF.text.length>20||_newPwdTF.text.length<6||_newPwdTF.text.length>20) {
        [UIEngine showShadowPrompt:@"请您输入正确的密码格式，6-20位字母、数字(特殊符号除外)"];
        return;
    }
    
    [self alterRequest];
    
}

-(void)alterRequest
{
    [UIEngine sharedInstance].progressStyle=1;
    [[UIEngine sharedInstance] showProgress];
    [DataEngine requestToAlterPwdWithOldPwd:_oldPwdTF.text NewPwd:_newPwdTF.text Complete:^(BOOL SUCCESS, NSString *msg) {
        if (SUCCESS) {
            [UIEngine showShadowPrompt:msg];
            
            
            [self goLogin];
            
        }
        else
        {
            if (msg.length>0) {
                [UIEngine showShadowPrompt:msg];
            }
            else
            {
//                [UIEngine showShadowPrompt:@"！您当前网络不佳，请稍后再试"];
            }
        }
        
        [[UIEngine sharedInstance] hideProgress];
    }];
}

-(void)goLogin
{

    [self exit];
    LoginViewController *loginVC=[[LoginViewController alloc]init];
    loginVC.isNeedPopRootController=YES;
    [self.navigationController pushViewController:loginVC animated:YES];
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
}

- (void)resetDefaults {
//    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
//    NSDictionary * dict = [defs dictionaryRepresentation];
//    for (id key in dict) {
//        
//        if ([key isEqualToString:@"Environment"]) {
//            
//        }else{
//        
//            [defs removeObjectForKey:key];
//
//        }
//    }
//    [defs synchronize];
    
    [[CMStoreManager sharedInstance]exitLoginClearUserData];
    
    
}

-(void)exit
{
    [self resetDefaults];
    [[CMStoreManager sharedInstance]storeUserToken:nil];
    [[CMStoreManager sharedInstance] setbackgroundimage];
}

-(void)showPwd:(UIButton *)btn
{
    if (btn.selected) {
        btn.selected=NO;
        if (btn.tag==999) {
            _oldPwdTF.secureTextEntry=YES;
        }
        else if (btn.tag==9999)
        {
            _newPwdTF.secureTextEntry=YES;
        }
    }
    else
    {
        btn.selected=YES;
        if (btn.tag==999) {
            _oldPwdTF.secureTextEntry=NO;
        }
        else if (btn.tag==9999)
        {
            _newPwdTF.secureTextEntry=NO;
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view.window endEditing:YES];
    UIView *lineHeader = [_scrollView viewWithTag:101];
    UIView *lineFooter = [_scrollView viewWithTag:102];
    UIView *lineLaster = [_scrollView viewWithTag:103];
    
    lineHeader.backgroundColor = [UIColor lightGrayColor];
    lineFooter.backgroundColor = [UIColor lightGrayColor];
    lineLaster.backgroundColor = [UIColor lightGrayColor];
    return YES;
}

-(void)textFieldEdit
{
    if (_newPwdTF.text.length>=6&&_oldPwdTF.text.length>=6) {
        _commitButton.enabled=YES;
        _commitButton.backgroundColor=RGBACOLOR(255, 62, 27, 1);
    }
    else
    {
        _commitButton.enabled=NO;
        _commitButton.backgroundColor=RGBACOLOR(188, 188, 188, 1);
    }
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
