//
//  RealNameViewController.m
//  hs
//
//  Created by RGZ on 15/5/21.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "RealNameViewController.h"
#import "BankCardViewController.h"

@interface RealNameViewController ()
{
    UIScrollView    *_scrollView;
    UITextField     *_nameTF;
    UITextField     *_cardTF;
    UITextField     *_cardProTF;
    UIButton        *_commitButton;
    UILabel         *_proLabel;
}
@end

@implementation RealNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNav];
    
    [self loadData];
    
    [self loadUI];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"实名认证"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [self.view.window endEditing:YES];
    UIView *lineHeader = [_scrollView viewWithTag:101];
    UIView *lineFooter = [_scrollView viewWithTag:102];
    UIView *lineLaster = [_scrollView viewWithTag:103];
    
    lineHeader.backgroundColor = [UIColor lightGrayColor];
    lineFooter.backgroundColor = [UIColor lightGrayColor];
    lineLaster.backgroundColor = [UIColor lightGrayColor];
    [[UIEngine sharedInstance] hideProgress];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"实名认证"];
//    if (!_commitButton) {
        _commitButton.enabled=YES;
//    }
    if (!_nameTF) {
        _nameTF.enabled=NO;
    }
    
    if (!_cardTF) {
        _cardTF.enabled=NO;
    }
    
    if (_privateUserInfo.statusRealName != nil&&_privateUserInfo.statusRealName.length>0) {
        if ([_privateUserInfo.statusRealName isEqualToString:@"2"]) {
            [self textFieldEdit];
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEdit) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)loadNav
{
    NavTitle(@"实名认证");
}

-(void)loadData
{
    if(_privateUserInfo.realName == nil)
    {
        _privateUserInfo.realName = @"";
    }
    
    if(_privateUserInfo.idCard == nil)
    {
        _privateUserInfo.idCard = @"";
    }
    
    if(_privateUserInfo.bankName == nil)
    {
        _privateUserInfo.bankName = @"";
    }
    
    if(_privateUserInfo.bankCard == nil)
    {
        _privateUserInfo.bankCard = @"";
    }
}

-(void)loadUI
{
    self.view.backgroundColor = RGBACOLOR(239, 239, 244, 1);
    
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
    UIView *backGroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 100)];
    backGroundView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:backGroundView];
    
    UIView *lineHeader=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    lineHeader.backgroundColor=[UIColor lightGrayColor];
    lineHeader.tag = 101;
    [backGroundView addSubview:lineHeader];
    
    UIView *lineFooter=[[UIView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, 0.5)];
    lineFooter.backgroundColor=[UIColor lightGrayColor];
    lineFooter.tag = 102;
    [backGroundView addSubview:lineFooter];
    
    UIView *lineLast=[[UIView alloc]initWithFrame:CGRectMake(0, 100, ScreenWidth, 0.5)];
    lineLast.tag = 103;
    lineLast.backgroundColor=[UIColor lightGrayColor];
    [backGroundView addSubview:lineLast];
    
    _nameTF=[[UITextField alloc]initWithFrame:CGRectMake(20, 0, ScreenWidth-40, 50)];
    _nameTF.delegate=self;
    _nameTF.tag=10010;
    _nameTF.font = [UIFont systemFontOfSize:14];
    _nameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _nameTF.placeholder=@"请输入您的姓名";
    _nameTF.returnKeyType=UIReturnKeyDone;
    [_nameTF becomeFirstResponder];
    [_nameTF addTarget:self action:@selector(textFieldEdit) forControlEvents:UIControlEventValueChanged];
    [backGroundView addSubview:_nameTF];
    
    _cardTF=[[UITextField alloc]initWithFrame:CGRectMake(20, 50, ScreenWidth-40, 50)];
    _cardTF.delegate=self;
    _cardTF.font = [UIFont systemFontOfSize:14];
    _cardTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _cardTF.placeholder=@"请输入您的身份证号";
    _cardTF.returnKeyType=UIReturnKeyDone;
    _cardTF.tag=10086;
    [_cardTF addTarget:self action:@selector(textFieldEdit) forControlEvents:UIControlEventValueChanged];
    [backGroundView addSubview:_cardTF];
    
    
    _cardProTF=[[UITextField alloc]initWithFrame:CGRectMake(0, backGroundView.frame.origin.y+backGroundView.frame.size.height, ScreenWidth, 50)];
    _cardProTF.delegate=self;
    _cardProTF.backgroundColor=[UIColor clearColor];
    _cardProTF.tag=10000;
    _cardProTF.textAlignment=NSTextAlignmentCenter;
    _cardProTF.font=[UIFont systemFontOfSize:25];
    _cardProTF.textColor=[UIColor redColor];
    _cardProTF.userInteractionEnabled = NO;
    [_cardProTF addTarget:self action:@selector(textFieldEdit) forControlEvents:UIControlEventValueChanged];
    [_scrollView addSubview:_cardProTF];
    
    _proLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, _cardProTF.frame.origin.y+8, ScreenWidth-40, 40)];
    _proLabel.numberOfLines = 0;
    _proLabel.text=@"一张身份证只能绑定一个账号\n请认真填写本人真实信息，以免影响提现";
    _proLabel.textColor=[UIColor redColor];
    _proLabel.textAlignment=NSTextAlignmentLeft;
    _proLabel.font=[UIFont systemFontOfSize:13];
    [_scrollView addSubview:_proLabel];
    
    
    NSString    *btnTitle = @"提交认证";
    if (self.isOtherPage || self.isRenZheng) btnTitle = @"下一步";
    _commitButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _commitButton.frame=CGRectMake(20, _proLabel.frame.size.height+_proLabel.frame.origin.y+8, ScreenWidth-40, 44);
    [_commitButton setTitle:btnTitle forState:UIControlStateNormal];
    _commitButton.backgroundColor=RGBACOLOR(188, 188, 188, 1);
    _commitButton.clipsToBounds=YES;
    _commitButton.layer.cornerRadius=6;
    [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_commitButton addTarget:self action:@selector(commitAuth) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_commitButton];
    
    if (self.isAuth) {
        [_cardProTF removeFromSuperview];
        
        lineHeader.alpha = 0;
        lineLast.alpha = 0;
        
        _nameTF.enabled=NO;
        _nameTF.textAlignment=NSTextAlignmentCenter;
        _nameTF.textColor=RGBACOLOR(100, 100, 100, 1);
        _nameTF.text=_privateUserInfo.realName;
        
        _cardTF.enabled=NO;
        _cardTF.textAlignment=NSTextAlignmentCenter;
        _cardTF.textColor=RGBACOLOR(100, 100, 100, 1);
        _cardTF.text=_privateUserInfo.idCard;
        
        backGroundView.backgroundColor=RGBACOLOR(225, 225, 225, 1);
        
        lineFooter.backgroundColor=[UIColor grayColor];
        lineHeader.backgroundColor=[UIColor grayColor];
        lineLast.backgroundColor=[UIColor grayColor];
        
        _proLabel.frame=CGRectMake(0, backGroundView.frame.origin.y+backGroundView.frame.size.height+20, ScreenWidth, 18);
        _proLabel.textColor=RGBACOLOR(100, 100, 100, 1);
        _proLabel.textAlignment = NSTextAlignmentCenter;
        _proLabel.text=@"您已成功进行实名认证";
        
        
        _commitButton.hidden=YES;
    }
    else
    {
        if ([_privateUserInfo.statusRealName isEqualToString:@"2"]) {
            _nameTF.text = _privateUserInfo.realName;
            _cardTF.text = _privateUserInfo.idCard;
            _cardProTF.text = _privateUserInfo.realName;
            [self textFieldEdit];
        }
    }
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
    if (_cardTF.text.length>0) {
        _cardProTF.text=_cardTF.text;
        _cardProTF.enabled=NO;
        _cardProTF.backgroundColor=RGBACOLOR(208, 208, 208, 1);
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _proLabel.frame=CGRectMake(20, _cardProTF.frame.size.height+_cardProTF.frame.origin.y+8, ScreenWidth-40, 40);
            _commitButton.frame=CGRectMake(20, _proLabel.frame.size.height+_proLabel.frame.origin.y+8, ScreenWidth-40, 44);
        } completion:nil];
    }
    else
    {
        _cardProTF.backgroundColor=[UIColor clearColor];
        _cardProTF.text=@"";
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _proLabel.frame = CGRectMake(20, _cardProTF.frame.origin.y+8, ScreenWidth-40, 40);
            _commitButton.frame=CGRectMake(20, _proLabel.frame.size.height+_proLabel.frame.origin.y+8, ScreenWidth-40, 44);
        } completion:nil];
    }
    
    if (_nameTF.text.length>1&&_cardTF.text.length>=18) {
        _commitButton.backgroundColor=RGBACOLOR(255, 62, 27, 1);
    }
    else
    {
        _commitButton.backgroundColor=RGBACOLOR(188, 188, 188, 1);
    }
    
    //禁止输入大于18位
    if (_cardTF.text.length>=19) {
        _cardTF.text = [_cardTF.text substringToIndex:18];
    }
    
    if(_nameTF.text.length >=21) {
        _nameTF.text = [_nameTF.text substringToIndex:20];
    }
    
    //放大显示
    if (_cardTF.text.length>0) {
        NSString *proStr=_cardTF.text;
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
        if (proStr.length > 4) {
            int count = 0;
            
            if (proStr.length > 6&&proStr.length < 15) {
                count = 1;
            }
            
            if (proStr.length >= 15) {
                count = 2;
            }
            
            for (int i =0; i<count; i++) {
                if(i==0)
                {
                    [temArray insertObject:@" " atIndex:6];
                }
                else
                {
                    [temArray insertObject:@" " atIndex:15];
                }
            }
        }
        
        proStr=@"";
        for (int i = 0; i<temArray.count; i++) {
            proStr=[proStr stringByAppendingString:temArray[i]];
        }
        
        
        _cardProTF.text=proStr;
    }
    
    
}

//身份证号
- (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

-(void)commitAuth
{
    if (_nameTF.text.length==0) {
        [UIEngine showShadowPrompt:@"请输入姓名"];
        return;
    }
    
    if (_cardTF.text.length==0) {
        [UIEngine showShadowPrompt:@"请输入身份证号"];
        return;
    }
    
    if(!(_cardTF.text.length==18))
    {
        [UIEngine showShadowPrompt:@"您输入的身份证号有误"];
        return;
    }
    
    if(![self validateIdentityCard:_cardTF.text])
    {
        [UIEngine showShadowPrompt:@"您输入的身份证格式不正确"];
        return;
    }
    
    _cardProTF.backgroundColor=[UIColor clearColor];
    _cardProTF.text=@"";
    
    

    [self authRealName];
}

#pragma mark 绑定银行卡

-(void)goBankBind
{
    BankCardViewController *bankCardVC=[[BankCardViewController alloc]init];
    bankCardVC.privateUserInfo=self.privateUserInfo;
    bankCardVC.isBinding=NO;
    bankCardVC.isCharge =self.isCharge;
    bankCardVC.isOtherPage=self.isOtherPage;
    bankCardVC.isRenZheng = self.isRenZheng;
    bankCardVC.block=^(PrivateUserInfo *privateUserInfo){};
    BackButtonHeader;
    [self.navigationController pushViewController:bankCardVC animated:YES];
}

-(void)authRealName
{
    [UIEngine sharedInstance].progressStyle=1;
    [[UIEngine sharedInstance] showProgress];
    [DataEngine requestToAuthRealName:_nameTF.text IdCard:_cardTF.text Complete:^(BOOL SUCCESS, NSString *msg) {
        if(SUCCESS)
        {
            
            //存储实名认证信息
            saveUserDefaults(_nameTF.text, uUserInfoRealName);
            saveUserDefaults(_cardTF.text, uUserInfoIdCard);
            _privateUserInfo.realName=_nameTF.text;
            _privateUserInfo.statusRealName=@"2";
            _privateUserInfo.idCard=_cardTF.text;
            UserInfo *userInfo = getUser_Info;
            userInfo.userUserInfoName = _nameTF.text;
            setUser_Info(userInfo);
            _commitButton.enabled=NO;
            
            [[UIEngine sharedInstance] showAlertWithTitle:@"成功提交实名信息" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
            [UIEngine sharedInstance].alertClick = ^(int aIndex){
                if (self.isNeedPop) {//只需实名认证，然后就返回
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else if (self.isOtherPage || self.isRenZheng) {//实名认证流程（包括银行卡）
                    [self goBankBind];
                }
                else{//正常返回
                    self.block(_privateUserInfo);
                    [self.navigationController popViewControllerAnimated:YES];
                }
            };
            
            
            
        }
        else
        {
            if(msg.length>0)
            {
                [UIEngine showShadowPrompt:msg];
            }
            else
            {
//                [UIEngine showShadowPrompt:@"！您当前网络不佳，请稍后再试"];
            }
        }
        [self textFieldEdit];
        [[UIEngine sharedInstance] hideProgress];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
