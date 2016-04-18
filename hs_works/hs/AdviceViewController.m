//
//  AdviceViewController.m
//  hs
//
//  Created by RGZ on 15/5/21.
//  Copyright (c) 2015年 luckin. All rights reserved.
//
#define  max_length 500
#import "AdviceViewController.h"
#import "AdviceRecordPage.h"
#import "NetRequest.h"

@interface AdviceViewController ()
{
    UIScrollView    *_scrollView;
    UIButton *rightButton;
}
@property   (nonatomic,strong)NavView *  nav;
@property   (nonatomic,strong)UITextView    *textView;
@property   (nonatomic,strong)UILabel       *adviceLabel;
@property   (nonatomic,strong)UIButton      *saveButton;
@property   (nonatomic,strong)UILabel       *showNumLab;

@end

@implementation AdviceViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self requestAnswerIsRead];//调用是否有未读回复消息接口
    
    [self requestListData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNav];
    
    [self loadUI];
    
}
#pragma mark Nav

-(void)loadNav{
    
    _nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _nav.titleLab.text = @"意见反馈";
    [_nav.leftControl  addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];
    
    [_nav.rightControl addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _nav.rightLab.text = @"回复记录";
    
    
    
//    self.title = @"意见反馈";
//    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_1"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClick)];
//    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.frame = CGRectMake(ScreenWidth-60, 0, 60, 44);
//    [rightButton setTitle:@"回复记录" forState:UIControlStateNormal];
//    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    
    //添加小红点
    UIView *redView = [[UIView alloc]init];
    redView.tag = 10000;
    redView.backgroundColor = [UIColor redColor];
    redView.frame  = CGRectMake(ScreenWidth-13,31,8,8);
    redView.hidden = YES;
    redView.layer.cornerRadius = 4;
    redView.layer.masksToBounds = YES;
    redView.layer.borderWidth = 1;//边框宽度
    redView.layer.borderColor = [[UIColor whiteColor]CGColor];//边框颜色
    [_nav addSubview:redView];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    [self.navigationItem.rightBarButtonItem.customView setAlpha:0.0];//隐藏导航栏右侧的按钮
}

-(void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)rightButtonClick{
    
    AdviceRecordPage * adviceRecordVC = [[AdviceRecordPage alloc] init];
    [self.navigationController pushViewController:adviceRecordVC animated:YES];
    
}

-(void)loadUI
{
    self.view.backgroundColor=RGBACOLOR(245, 245, 245, 1);
    [self loadTextView];
}

-(void)loadTextView
{
    
    
    UILabel * remindLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 64, ScreenWidth-30, 40)];
    remindLab.text      = @"一旦你的建议被采纳,将会有意外惊喜等着你！";
    remindLab.font      = [UIFont systemFontOfSize:13];
    remindLab.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
    [self.view addSubview:remindLab];
    
    UIView *backGroundView=[[UIView alloc]initWithFrame:CGRectMake(0, remindLab.frame.size.height+remindLab.frame.origin.y, ScreenWidth, ScreenWidth*2/5)];
    
    backGroundView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backGroundView];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 5, ScreenWidth-30,  ScreenWidth*2/5-25)];
    self.textView.textColor = [UIColor blackColor];
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _textView.hidden = NO;
    _textView.delegate = self;
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.scrollEnabled = YES;
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [backGroundView addSubview: self.textView];
    
    _showNumLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-60, _textView.frame.size.height+_textView.frame.origin.y, 40, 16)];
    _showNumLab.backgroundColor = K_color_red;
    _showNumLab.textColor = [UIColor whiteColor];
    _showNumLab.layer.cornerRadius = 8;
    _showNumLab.layer.masksToBounds = YES;
    _showNumLab.hidden = YES;
    _showNumLab.textAlignment = NSTextAlignmentCenter;
    [backGroundView addSubview:_showNumLab];
    
    NSString *niu = @"";
    
//#if defined (CAINIUA)
//    niu = NIUA;
//    
//#elif defined (NIUAAPPSTORE)
//    niu = NIUA;
//#else
//    niu = CAINIU;
//#endif
    niu = App_appShortName;
    
    self.adviceLabel=[[UILabel alloc]init];
    self.adviceLabel.frame =CGRectMake(5, 2, _textView.frame.size.width, 30);
    self.adviceLabel.text = [NSString stringWithFormat:@"%@带你飞",niu];
    self.adviceLabel.enabled = NO;//lable必须设置为不可用
    self.adviceLabel.font=[UIFont systemFontOfSize:15];
    self.adviceLabel.backgroundColor = [UIColor clearColor];
    [self.textView addSubview:self.adviceLabel];
    
    
    UIView *lineHeader=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    lineHeader.backgroundColor=K_COLOR_CUSTEM(193, 193, 193, 1);
    [backGroundView addSubview:lineHeader];
    
    UIView *lineFooter=[[UIView alloc]initWithFrame:CGRectMake(0, backGroundView.frame.size.height-0.5, ScreenWidth, 0.5)];
    lineFooter.backgroundColor=K_COLOR_CUSTEM(193, 193, 193, 1);
    [backGroundView addSubview:lineFooter];
    
    
    self.saveButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.saveButton.frame=CGRectMake(20, backGroundView.frame.size.height+backGroundView.frame.origin.y+20, ScreenWidth-40, 44);
    self.saveButton.backgroundColor=K_COLOR_CUSTEM(167, 167, 167, 1);
    self.saveButton.clipsToBounds=YES;
    self.saveButton.layer.cornerRadius=6;
    self.saveButton.enabled = NO;
    [self.saveButton setTitle:@"提交意见" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveAdvise) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveButton];
    
    
    if (AppStyle_SAlE) {
        
        return;
    }
    
    NSString * tel = @"";
#if defined (YQB)
    tel = @"客服电话：400-8915-690";

#else
    tel = @"客服电话：400-6666-801";

#endif

    
    UIButton  *phoneButton = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenHeigth-(55.0/667.0*ScreenHeigth), ScreenWidth, (55.0/667.0*ScreenHeigth))];
    phoneButton.backgroundColor = [UIColor whiteColor];
    phoneButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [phoneButton setTitle:tel forState:UIControlStateNormal];
    [phoneButton setTitleColor:[UIColor colorWithRed:234/255.0 green:162/255.0 blue:98/255.0 alpha:1] forState:UIControlStateNormal];
    phoneButton.titleLabel.font = [UIFont systemFontOfSize:19];
    [phoneButton addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneButton];
}
-(void)call{
    NSString * tel = @"";
#if defined (YQB)
    tel = @"您是否要拨打客服电话 400-8915-690 ?";
    
#else
    tel = @"您是否要拨打客服电话 400-6666-801 ?";
    
#endif
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"系统提示" message:tel delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        NSString * tel = @"";
#if defined (YQB)
        tel = @"tel://400-8915-690";
        
#else
        tel = @"tel://400-6666-801";
        
#endif

        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:tel]]];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    NSString * str = [NSString stringWithFormat:@"%@%@",textView.text,text];
    int length = (int)str.length;
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    if (length>max_length||[text isEqualToString:@"\n"]) {
        return NO;
    }else {
        
        return YES;
    }

}

-(void)textViewDidChange:(UITextView *)textView
{
    NSString *niu = App_appShortName;
    
    if (textView.text.length == 0) {
        _adviceLabel.text = [NSString stringWithFormat:@"%@带你飞",niu];
    }else{
        _adviceLabel.text = @"";
        self.saveButton.enabled = YES;
        self.saveButton.backgroundColor = K_color_red;
    }
    
    
    [textView.text enumerateSubstringsInRange:NSMakeRange(0, textView.text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        if ([self stringContainsEmoji:substring]) {
            
//            NSString * str = [substring stringByReplacingPercentEscapesUsingEncoding:NSUTF32StringEncoding];
            textView.text = [textView.text stringByReplacingOccurrencesOfString:substring withString:@""];

        }
        
        if(textView.text.length>max_length)
        {
            
            textView.text = [textView.text substringWithRange:NSMakeRange(0, max_length)];
        }
//        NSString * adviceText = [[UITextInputMode currentInputMode] primaryLanguage];
//        if ([adviceText isEqualToString:@"zh_Hans"]) {
//            
//            UITextRange * selectRange = [textView markedTextRange];
//            UITextPosition * position = [textView positionFromPosition:selectRange.start offset:0];
//            if (!position) {
//                
//                
//                
//            }
//            
//        }
 
        int length = (int)textView.text.length;
        
        if (length>=max_length-50) {
            _showNumLab.hidden  = NO;
            _showNumLab.text    = [NSString stringWithFormat:@"%d",max_length-length];
        }else{
            _showNumLab.hidden = YES;
        }
    }];
}
#pragma mark - 获取回复列表是否已读的状态
- (void)requestAnswerIsRead
{
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token};
    [NetRequest postRequestWithNSDictionary:dic url:K_Answer_AnswerIsRead successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            UIView *readUpdateView = [_nav viewWithTag:10000];
            NSInteger isbool = [dictionary[@"data"][@"isbool"] integerValue];
            if (isbool == 1) {//未读
                
                readUpdateView.hidden = NO;
                //                self.navigationItem.rightBarButtonItem
                
            }else
            {
                readUpdateView.hidden = YES;
                //                UIView *view = [self.rdv_tabBarController.tabBar viewWithTag:888 + 2];
                //                [view removeFromSuperview];
            }
        }
    } failureBlock:^(NSError *error) {
        
    }];
    
}

#pragma mark - 请求回复列表接口
- (void)requestListData
{
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token,@"page":@(1),@"rows":@(20)};
    [NetRequest postRequestWithNSDictionary:dic url:K_Answer_AnswerRecord successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            NSArray *dataArray = dictionary[@"data"][@"onlist"];
            //            NSLog(@"dataArray:%@",dataArray);
            
            if (dataArray.count > 0)
            {
                for (NSDictionary *dic in dataArray)
                {
                    if ( [Helper isNullString:dic[@"message"]] && [Helper isNullString:dic[@"answerTime"]]) {
                        
//                        [self.navigationItem.rightBarButtonItem.customView setAlpha:0.0];
                        _nav.rightControl.alpha = 0.0;
                        _nav.rightLab.alpha = 0.0;
                    }else
                    {
//                        [self.navigationItem.rightBarButtonItem.customView setAlpha:1.0];
                        _nav.rightControl.alpha = 1.0;
                        _nav.rightLab.alpha = 1.0;
                        return ;
                    }
                }
                
            }else
            {
//                [self.navigationItem.rightBarButtonItem.customView setAlpha:0.0];
                _nav.rightControl.alpha = 0.0;
                _nav.rightLab.alpha = 0.0;
            }
        }
        
    } failureBlock:^(NSError *error) {
        //        NSLog(@"%@",error.localizedDescription);
        
    }];
    
}


-(void)saveAdvise
{
    //点击提交意见的时候，让键盘失去第一响应
    [self.textView resignFirstResponder];
    
    
    
    [UIEngine sharedInstance].progressStyle=1;
    [[UIEngine sharedInstance] showProgress];
    [DataEngine requestToCommitAdvice:self.textView.text Complete:^(BOOL SUCCESS, NSString * msg) {
        if (SUCCESS) {
            NSString * showText = [NSString stringWithFormat:@"您的建议已提交\n感谢您对%@的支持!",App_appShortName];
            PopUpView * popView = [[PopUpView alloc] initShowAlertWithShowText:showText setBtnTitleArray:@[@"确定"]];
            popView.confirmClick = ^(UIButton * button){
                [self.navigationController popViewControllerAnimated:YES];
            };
            [self.navigationController.view addSubview:popView];
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


- (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff)
         {
             if (substring.length > 1)
             {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f)
                 {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1)
         {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3)
             {
                 returnValue = YES;
             }
             
         } else
         {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff)
             {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07)
             {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935)
             {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299)
             {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)
             {
                 returnValue = YES;
             }
         }
         
     }];
    return returnValue;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIEngine sharedInstance] hideProgress];
    self.navigationController.navigationBarHidden = NO;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.view.window endEditing:YES];
//}

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
