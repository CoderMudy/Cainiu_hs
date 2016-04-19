//
//  CheckRegViewController.m
//  hs
//
//  Created by hzl on 15-4-22.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import "CheckRegViewController.h"
#import "SetKeyViewController.h"
#import "NetRequest.h"
#import "NSString+MD5.h"

@interface CheckRegViewController ()
{
    NSTimer * _timer;

    int _endTime;
    
    NSString    *_proStr;
    
    int     time;
}
@property (weak, nonatomic) IBOutlet UILabel *proNextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

@property (weak, nonatomic) IBOutlet UIButton *reCheckNumBtn;

@property (weak, nonatomic) IBOutlet UITextField *checkTextField;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end



@implementation CheckRegViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)reGetCheckNum:(id)sender {
  
    self.checkTextField.text = @"";
    [self.checkTextField becomeFirstResponder];
    
    _proStr = @"again";
    NSString * sign = [NSString stringWithFormat:@"%@luckin",self.regPhone];
    NSDictionary * dic =@{@"tele":self.regPhone,
                          @"version":@"0.01",
                          @"sign":[sign MD5Digest]
                          };
    
    
    NSString * addUrl = @"/user/sms/getRegCode";
    if ([self.sourceStr isEqualToString:@"验证账号"]) {
        //忘记密码的URL
        addUrl = @"/user/sms/findLoginPwdCode";
        
    }
    
   __block CheckRegViewController * checkVC =self;
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",K_MGLASS_URL,addUrl];
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        checkVC.checkNum = dictionary[@"data"];
//        NSLog(@"%@",dictionary);
//        checkVC.checkTextField.text = checkVC.checkNum;
        
    } failureBlock:^(NSError *error) {
        
        [[UIEngine sharedInstance] hideProgress];
    }];
    
    self.timeLab.hidden = NO;
    self.reCheckNumBtn.hidden = YES;
    [self startTiming];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIEngine sharedInstance] hideProgress];
    [_timer invalidate];
    [self.view.window endEditing:YES];
    removeTextFileNotification;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    addTextFieldNotification(textFieldValueChange);
}

- (IBAction)confirmBtnClick:(id)sender {
  
//    if ([self.checkTextField.text isEqualToString:self.checkNum]) {
        NSDictionary * dic = nil;
        
        dic = @{@"tele":self.regPhone,
                @"code":self.checkTextField.text,
                @"version":VERSION,
                };
        
        NSString * addUrl = @"/user/sms/authRegCode";
        if ([self.sourceStr isEqualToString:@"验证账号"]) {
        //忘记密码的URL
            addUrl = @"/user/sms/authLoginPwdCode";
        }
        //绑定手机验证
        if (self.isBindMobile) {
            dic = @{@"tele":self.regPhone,
                    @"authCode":self.checkTextField.text,
                    @"token":[[CMStoreManager sharedInstance] getUserToken],
                    };
            addUrl = @"/user/user/checkBindTeleCode";
        }
        
        NSString * urlStr = [NSString stringWithFormat:@"%@%@",K_MGLASS_URL,addUrl];
        CheckRegViewController * checkVC = self;
        [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
            
            if ([dictionary[@"code"] intValue]==200)
            {
                SetKeyViewController * setKeyVC = [[SetKeyViewController alloc] init];
                setKeyVC.regPhone = checkVC.regPhone;
                setKeyVC.checkNum = checkVC.checkNum;
                setKeyVC.sourceStr = checkVC.sourceStr;
                setKeyVC.isBindMobile = self.isBindMobile;
                setKeyVC.isCharge = self.isCharge;
                [self.navigationController pushViewController:setKeyVC animated:YES];
                
            }
            else if ([dictionary[@"code"] intValue]==400)
            {
                [[UIEngine sharedInstance] showAlertWithTitle:dictionary[@"msg"] ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
                [UIEngine sharedInstance].alertClick = ^(int aIndex){};
            }
            else
            {
                
                [UIEngine showShadowPrompt:dictionary[@"msg"]];
            }
        } failureBlock:^(NSError *error) {
            [[UIEngine sharedInstance] hideProgress];
            
        }];
}

- (void)removeLab:(UILabel*)lab
{
    
    [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionOverrideInheritedDuration animations:^{
        [lab removeFromSuperview];
        
    } completion:nil];
    
}
-(void )updateUIbutton:(BOOL) bEnable
{
    self.confirmBtn.enabled = bEnable;
    [self.confirmBtn setBackgroundColor:(bEnable ? RGBACOLOR(255, 62, 27, 1):[UIColor lightGrayColor])];
    
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
    if (string.length == 0)
    {
        return YES;
    }
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    
    if ((existedLength - selectedLength + replaceLength > 4) && replaceLength >0)
    {
        return NO;
    }
    else if ((existedLength - selectedLength + replaceLength >= 4) && replaceLength >0)
    {
    }
    else
    {
    }
    
    if (self.checkTextField.text.length!=4) {
        [self updateUIbutton:NO];
    }
    else
    {
        [self updateUIbutton:YES];
    }
    
    return  YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view.window endEditing:YES];
    return YES;
}

//开始倒计时
- (void)startTiming
{
    if([_proStr isEqualToString:@"again"]){
        self.promptLabel.text=[NSString stringWithFormat:@"已再次向%@发送短信",self.regPhone];
    }
    else{
        self.promptLabel.text=[NSString stringWithFormat:@"已向%@发送短信",self.regPhone];
    }
    
    self.reCheckNumBtn.hidden = YES;
    
    self.timeLab.hidden = NO;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [_timer fire];
    
}
- (void)countDown
{
    _endTime = time;
    time--;

    self.timeLab.text = [NSString stringWithFormat:@"%ds",_endTime];
   
    if (time<=0) {
        [_timer invalidate];
        self.timeLab.hidden = YES;
        self.reCheckNumBtn.hidden = NO;
        time = 60;
        
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    time = 60;
    
    [self startTiming];
    
    
    
    _proStr=@"";
    if ([_sourceStr isEqualToString:@"验证账号"])
    {
        [self setTitle:@"验证账号"];
        self.proNextLabel.text = @"请填写验证码完成验证";
    }else{
        if (self.isBindMobile) {
            [self setTitle:@"绑定手机"];
            self.proNextLabel.text = @"请填写验证码完成验证";
        }
        else
        {
            [self setTitle:@"注册"];
            self.proNextLabel.text = @"请填写验证码完成注册";
        }
    }
    
    
    [self setNavLeftBut:NSPushMode];
    
    self.checkTextField.delegate=self;
    [self.checkTextField becomeFirstResponder];
    [self.checkTextField addTarget:self action:@selector(textFieldValueChange) forControlEvents:UIControlEventValueChanged];
    self.checkTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.reCheckNumBtn.hidden = YES;
    self.timeLab.text = [NSString stringWithFormat:@"%ds",_endTime];
//    self.checkTextField.text = self.checkNum;
    self.confirmBtn.clipsToBounds=YES;
    self.confirmBtn.backgroundColor = [UIColor lightGrayColor];
    self.confirmBtn.layer.cornerRadius=6;
    self.confirmBtn.enabled = NO;
    
    
//    NSLog(@"%@",self.regPhone);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textFieldValueChange
{
    if (self.checkTextField.text.length!=4) {
        [self updateUIbutton:NO];
    }
    else
    {
        [self updateUIbutton:YES];
    }
    
//    if(self.checkTextField.text.length<4)
//    {
//        self.confirmBtn.enabled = NO;
//        self.confirmBtn.backgroundColor = [UIColor lightGrayColor];
//    }
//    else
//    {
//        self.confirmBtn.enabled = YES;
//        self.confirmBtn.backgroundColor = RGBACOLOR(255, 62, 27, 1);
//    }
}
@end
