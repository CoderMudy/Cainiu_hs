//
//  SignViewController.m
//  hs
//
//  Created by RGZ on 15/5/21.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "SignViewController.h"

#define sign_Num 50


@interface SignViewController ()
{
    UIScrollView    *_scrollView;
}

@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)UILabel *adviceLabel;
@property (nonatomic,strong)UILabel *surplusLabel;
@property (nonatomic,strong)UIButton *saveButton;

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNav];
        
    [self loadUI];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view.window endEditing:YES];
    [[UIEngine sharedInstance] hideProgress];
}

-(void)loadNav
{
    NavTitle(@"个性签名");
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
    
    [self loadTextView];
}

-(void)loadTextView
{
    
    UIView *backGroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 5, ScreenWidth, 88)];
    backGroundView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:backGroundView];
    
    
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 88)];
    self.textView.textColor = [UIColor blackColor];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _textView.hidden = NO;
    _textView.delegate = self;
    _textView.text = [[CMStoreManager sharedInstance] getUserSign];
    [_textView becomeFirstResponder];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.scrollEnabled = YES;
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [backGroundView addSubview: self.textView];
    
    
    self.adviceLabel=[[UILabel alloc]init];
    self.adviceLabel.frame =CGRectMake(5, 2, _textView.frame.size.width, 30);
    if ([[CMStoreManager sharedInstance] getUserSign].length==0) {
        self.adviceLabel.text = @"编辑您的个性签名";
    }
    else
    {
        if ([[[CMStoreManager sharedInstance] getUserSign] isEqualToString:@" "])
        {
            _adviceLabel.text = @"编辑您的个性签名";
            _textView.text = @"";
            
        }
        else
        {
            self.adviceLabel.text = @"";
        }
    }
    
    self.adviceLabel.enabled = NO;//lable必须设置为不可用
    self.adviceLabel.font=[UIFont systemFontOfSize:15];
    self.adviceLabel.backgroundColor = [UIColor clearColor];
    [self.textView addSubview:self.adviceLabel];
    
    
    UIView *lineHeader=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    lineHeader.backgroundColor=[UIColor redColor];
    [backGroundView addSubview:lineHeader];
    
    UIView *lineFooter=[[UIView alloc]initWithFrame:CGRectMake(0, backGroundView.frame.size.height-0.5, ScreenWidth, 0.5)];
    lineFooter.backgroundColor=[UIColor redColor];
    [backGroundView addSubview:lineFooter];
    
    
    
    _surplusLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, backGroundView.frame.size.height+backGroundView.frame.origin.y, ScreenWidth, 25)];
    _surplusLabel.text=[NSString stringWithFormat:@"%d",sign_Num-(int)_textView.text.length];
    _surplusLabel.font=[UIFont systemFontOfSize:15];
    _surplusLabel.textColor=RGBACOLOR(151, 151, 151, 1);
    _surplusLabel.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:_surplusLabel];
    
    self.saveButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.saveButton.frame=CGRectMake(20, _surplusLabel.frame.size.height+_surplusLabel.frame.origin.y+5, ScreenWidth-40, 44);
    self.saveButton.backgroundColor=RGBACOLOR(255, 62, 27, 1);
    self.saveButton.clipsToBounds=YES;
    self.saveButton.layer.cornerRadius=6;
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:self.saveButton];
}

-(void)textViewDidChange:(UITextView *)textView
{
    
    
    if (textView.text.length>sign_Num) {
        _surplusLabel.text=@"0";
        _textView.text=[_textView.text substringToIndex:sign_Num];
    }
    
    
    
    if (textView.text.length == 0) {
        _surplusLabel.text = [NSString stringWithFormat:@"%d",sign_Num];
        _saveButton.enabled = NO;
        _adviceLabel.text = @"编辑您的个性签名";
        _saveButton.backgroundColor = [UIColor lightGrayColor];
    }else{
        _adviceLabel.text = @"";
        _surplusLabel.text=[NSString stringWithFormat:@"%d",sign_Num-(int)self.textView.text.length];
        _saveButton.backgroundColor = CanSelectButBackColor;
        _saveButton.enabled = YES;
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


-(void)save
{
    
    [UIEngine sharedInstance].progressStyle=1;
    [[UIEngine sharedInstance] showProgress];
    [DataEngine requestToAlterSign:self.textView.text Complete:^(BOOL SUCCESS, NSString * msg) {
        if (SUCCESS) {
            
//            [UIEngine showShadowPrompt:msg];
            //存储签名
            UserInfo *userInfo = getUser_Info;
            userInfo.userUserInfoSign = self.textView.text;
            setUser_Info(userInfo);
            [[CMStoreManager sharedInstance] setUserSign:self.textView.text];
            
            [[UIEngine sharedInstance] showAlertWithTitle:msg ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
            [UIEngine sharedInstance].alertClick = ^ (int aIndex){
                self.block([[CMStoreManager sharedInstance] getUserSign]);
                [self.navigationController popViewControllerAnimated:YES];
            };
            
        }
        else
        {
            if (msg.length>0) {
                PersionShowAlert(msg);
            }
            else
            {
//                [UIEngine showShadowPrompt:@"！您当前网络不佳，请稍后再试"];
            }
        }
        [[UIEngine sharedInstance] hideProgress];
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view.window endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    [self.view endEditing:YES];
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
