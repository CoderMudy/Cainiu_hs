//
//  ApplyReasonPage.m
//  hs
//
//  Created by PXJ on 15/10/22.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "ApplyReasonPage.h"
#import "SpreadApplyPage.h"

#define  max_length 20

@interface ApplyReasonPage ()<UIScrollViewDelegate,UITextViewDelegate>

@property   (nonatomic,strong)UITextView    *textView;
@property   (nonatomic,strong)UILabel       *adviceLabel;
@property   (nonatomic,strong)UIButton      *saveButton;

@end

@implementation ApplyReasonPage

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNav];
    [self loadUI];
}
#pragma mark Nav

-(void)loadNav{
    
    NavView * nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    nav.titleLab.text = @"申请理由";
    [nav.leftControl addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
}
-(void)leftButtonClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    self.backBlock();
}
-(void)loadUI
{
    self.view.backgroundColor=RGBACOLOR(245, 245, 245, 1);
    [self loadTextView];
}
-(void)loadTextView
{
    
    
    UILabel * remindLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 64, ScreenWidth-30, 40)];
    remindLab.text      = @"字数不得多于20个字";
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
    

    self.adviceLabel=[[UILabel alloc]init];
    self.adviceLabel.frame =CGRectMake(5, 2, _textView.frame.size.width, 30);
    self.adviceLabel.text = [NSString stringWithFormat:@"请简练的说明您的理由"];
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
    [self.saveButton setTitle:@"提交申请" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveApply) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveButton];
    
    
   
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

    if (textView.text.length == 0) {
        _adviceLabel.text = [NSString stringWithFormat:@"请简练的说明您的理由"];
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
  }];
}

-(void)saveApply
{
    //点击提交意见的时候，让键盘失去第一响应
    [self.textView resignFirstResponder];
    [ManagerHUD showHUD:self.view animated:YES];
    [RequestDataModel requestApplyPromote:self.textView.text SuccessBlock:^(BOOL success, NSString *msg) {
        [ManagerHUD hidenHUD];
        if (success) {
            
                
                PopUpView * popView = [[PopUpView alloc] initShowAlertWithShowText:[NSString stringWithFormat:@"申请已提交\n审核通过后可开启%@合伙人",App_appShortName] setBtnTitleArray:@[@"确定"]];
                popView.confirmClick = ^(UIButton * button){
                    self.superVC.userSpreadStyle = UserSpreadChecking;
                    [self.navigationController popViewControllerAnimated:YES];
                    self.backBlock();
                };
                [self.navigationController.view addSubview:popView];
        }else if (msg.length>0){
        
            PopUpView * popView = [[PopUpView alloc] initShowAlertWithShowText:msg setBtnTitleArray:@[@"确定"]];
            popView.confirmClick = ^(UIButton * button){
            };
            [self.navigationController.view addSubview:popView];
        
        }
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
