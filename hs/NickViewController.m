//
//  NickViewController.m
//  hs
//
//  Created by RGZ on 15/5/21.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "NickViewController.h"

@interface NickViewController ()
{
    UIScrollView    *_scrollView;
    UITextField     *_textField;
    UIButton        *_saveButton;
}
@end

@implementation NickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNav];
    
    [self loadUI];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[UIEngine sharedInstance] hideProgress];
    [self.view.window endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEdit) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)loadNav
{
    NavTitle(@"昵称修改");
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view.window endEditing:YES];
    return YES;
}

-(void)loadTextField
{
    UIView *backGroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 5, ScreenWidth, 50)];
    backGroundView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:backGroundView];
    
    UIView *lineHeader=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    lineHeader.backgroundColor=[UIColor redColor];
    [backGroundView addSubview:lineHeader];
    
    UIView *lineFooter=[[UIView alloc]initWithFrame:CGRectMake(0, backGroundView.frame.size.height-0.5, ScreenWidth, 0.5)];
    lineFooter.backgroundColor=[UIColor redColor];
    [backGroundView addSubview:lineFooter];
    
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(20, 0, ScreenWidth-40, backGroundView.frame.size.height)];
    _textField.delegate=self;
    _textField.font = [UIFont systemFontOfSize:14];
    [_textField becomeFirstResponder];
    _textField.returnKeyType=UIReturnKeyDone;
    _textField.placeholder=@"请输入新的昵称";
    [_textField addTarget:self action:@selector(textFieldEdit) forControlEvents:UIControlEventValueChanged];
    [backGroundView addSubview:_textField];
    
    UILabel *proLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, backGroundView.frame.size.height+backGroundView.frame.origin.y+15, ScreenWidth, 18)];
    proLabel.text=@"限4-16个字符，一个汉字为2个字符";
    proLabel.textColor=[UIColor grayColor];
    proLabel.textAlignment=NSTextAlignmentCenter;
    proLabel.font=[UIFont systemFontOfSize:12];
    [_scrollView addSubview:proLabel];
    
    UILabel *redProLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, proLabel.frame.size.height+proLabel.frame.origin.y, ScreenWidth, 18)];
    redProLabel.textColor=[UIColor redColor];
    redProLabel.text=@"只能修改一次";
    redProLabel.font=[UIFont systemFontOfSize:12];
    redProLabel.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:redProLabel];
    
    if (![[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:uUserInfoNickStatus]] isEqualToString:@"1"]) {
        _saveButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.frame=CGRectMake(20, redProLabel.frame.origin.y+redProLabel.frame.size.height+8, ScreenWidth-40, 44);
        _saveButton.backgroundColor=RGBACOLOR(155, 155, 155, 1);
        _saveButton.clipsToBounds=YES;
        _saveButton.layer.cornerRadius=6;
        _saveButton.enabled=NO;
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:_saveButton];
    }
    else
    {
        
        _textField.text=[[CMStoreManager sharedInstance] getUserNick];
        _textField.textAlignment=NSTextAlignmentCenter;
        _textField.textColor=RGBACOLOR(100, 100, 100, 1);
        _textField.enabled=NO;
        
        proLabel.text=@"您已修改过一次昵称，无法再次修改";
        redProLabel.text=@"";
        
        lineHeader.backgroundColor=[UIColor grayColor];
        lineFooter.backgroundColor=[UIColor grayColor];
        
        backGroundView.backgroundColor=RGBACOLOR(225, 225, 225, 1);
    }
    
}


-(void)save
{
    if (_textField.text.length==0)
    {
        PersionShowAlert(@"请输入昵称");
        return;
    }
    [UIEngine sharedInstance].progressStyle=1;
    [[UIEngine sharedInstance] showProgress];
    [DataEngine requestToAlterNick:_textField.text Complete:^(BOOL SUCCESS, NSString * msg)
    {
        if (SUCCESS)
        {
            //存储昵称
            UserInfo    *userInfo = getUser_Info;
            userInfo.userNickStatus = @"1";
            setUser_Info(userInfo);
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:uUserInfoNickStatus];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[CMStoreManager sharedInstance] setUserNick:_textField.text];
            
            
            [[UIEngine sharedInstance] showAlertWithTitle:msg ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
            [UIEngine sharedInstance].alertClick = ^(int aIndex){
                self.block([[CMStoreManager sharedInstance] getUserNick]);
                [self.navigationController popViewControllerAnimated:YES];
            };
            
        }
        else
        {
            if (msg.length>0)
            {
                if ([msg isEqualToString:@"昵称敏感词"]) {
                    msg = @"昵称已被占用";
                }
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


-(void)textFieldEdit
{
    if ([self convertToInt:_textField.text]>=4) {
        _saveButton.backgroundColor=RGBACOLOR(255, 62, 27, 1);
        _saveButton.enabled=YES;
    }
    else
    {
        
        _saveButton.backgroundColor=RGBACOLOR(155, 155, 155, 1);
        _saveButton.enabled=NO;
    }
    
    if (_textField.text.length>=9) {
        [self authStringNum];
    }
    
}

-(void)authStringNum
{
    //限制字符个数为16
    NSMutableArray *strArray = [NSMutableArray arrayWithCapacity:0];
    
    int count = 0;
    
    for(int i =0;i<_textField.text.length;i++)
    {
        int num = 0;
        NSString *str=[[_textField.text substringFromIndex:i] substringToIndex:1];
        if ([self isChinese:str])
        {
            num=2;
        }
        else
        {
            num=1;
        }
        
        
        if ((count + num) > 16)
        {
            NSString *tfStr = @"";
            for (int i = 0; i<strArray.count; i++)
            {
                tfStr = [tfStr stringByAppendingString:strArray[i]];
            }
            
            _textField.text = tfStr;
            
            break;
        }
        else
        {
            count += num;
            [strArray addObject:str];
        }
    }
}

//判断是否有中文
-(BOOL)isChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
        
    }
    return NO;
    
}


//判断字符个数
- (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view.window endEditing:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (!textField.window.isKeyWindow) {
        [textField.window makeKeyAndVisible];
    }
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
