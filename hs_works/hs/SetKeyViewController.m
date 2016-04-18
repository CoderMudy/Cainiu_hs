//
//  SetKeyViewController.m
//  hs
//
//  Created by PXJ on 15/4/25.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import "SetKeyViewController.h"
#import "NetRequest.h"
#import "Helper.h"
#import "NSString+MD5.h"
#import "AccountRechargeViewController.h"
#import "PersionInfoViewController.h"
#import "IndexViewController.h"
@interface SetKeyViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (nonatomic, strong)NSNotification * notification;

@end







@implementation SetKeyViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIEngine sharedInstance] hideProgress];
    removeTextFileNotification;
}


- (void)sendNotification
{
    [[NSNotificationCenter defaultCenter]postNotification:_notification];
}

- (IBAction)registBtnClick:(id)sender {

    NSString  * password = self.passWordTextField.text;
    
    
    NSDictionary * dic = nil;
    
    //判断是牛A还是财牛
    NSString *stype = @"1";
    NSString * niu = @"";
//    #if defined (CAINIUA)
//        stype = @"1";
//        niu = RegSourceCaiNiuA;
//    #elif defined (NIUAAPPSTORE)
//        stype = @"1";
//        niu = RegSourceCaiNiuA;
//    #else
//        stype = @"0";
//        niu = RegSourceCaiNiu;
//    #endif
    
    niu = App_regSource;
    dic = @{@"tele":self.regPhone,
            @"password":password,
            @"authCode":self.checkNum,
            @"version":VERSION,
            @"deviceModel":[[UIDevice currentDevice] model],
            @"deviceImei":UDID,
            @"deviceVersion":[[UIDevice currentDevice] systemVersion],
            @"clientVersion":VERSION,
            @"regSource":niu,
            @"operator":[DataEngine getCellularProviderName],
            @"stype":stype,
            @"systemName":@"2",
            @"promoteCode":ExtendID,
            };
    
    if (self.isBindMobile) {
        dic = @{
                @"token":[[CMStoreManager sharedInstance] getUserToken],
                @"tele" :self.regPhone,
                @"password" :[[password MD5Digest] uppercaseString],
                };
    }
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",K_MGLASS_URL,@"/user/register"];
    
    if ([self.sourceStr isEqualToString:@"验证账号"]) {
        urlStr = [NSString stringWithFormat:@"%@/user/user/findLoginPwd",K_MGLASS_URL];
    }
    
    if (self.isBindMobile) {
        urlStr = [NSString stringWithFormat:@"%@/user/user/bindTele",K_MGLASS_URL];
    }
    
    [UIEngine sharedInstance].progressStyle=1;
    [[UIEngine sharedInstance] showProgress];
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        [[UIEngine sharedInstance] hideProgress];
        if ([dictionary[@"code"] intValue]==200) {
            
            if ([self.sourceStr isEqualToString:@"验证账号"]) {
                [[UIEngine sharedInstance] showAlertWithTitle:@"设置成功，请妥善保管" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
                [UIEngine sharedInstance].alertClick = ^(int aIndex){};
            }
            
            NSDictionary * dic = @{@"PhoneNumber":self.regPhone};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:uPrivateUserInfo object:nil userInfo:dic];
            
            saveUserDefaults(@"YES", @"FirstLogin");
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.regPhone];
            
            CUserData * cuserdata = [CUserData sharedInstance];
            cuserdata.userBaseClass = [UserBaseClass modelObjectWithDictionary:dictionary];
        
            //存储用户信息
            [DataEngine saveUserInfo:dictionary];
            
            //昵称修改状态
            [[NSUserDefaults standardUserDefaults] setObject:dictionary[@"data"][@"nickStatus"] forKey:uUserInfoNickStatus];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[CMStoreManager sharedInstance] setUSerHeaderAddress:cuserdata.userBaseClass.data.userInfo.headPic];
            [[CMStoreManager sharedInstance] setUserNick:cuserdata.userBaseClass.data.userInfo.nick];
            [[CMStoreManager sharedInstance] setUserSign:cuserdata.userBaseClass.data.userInfo.personSign];
            [[CMStoreManager sharedInstance] storeUserToken:  cuserdata.userBaseClass.data.tokenInfo.token];
            [[CMStoreManager sharedInstance] storeUserTokenSecret:cuserdata.userBaseClass.data.tokenInfo.userSecret];
            [[CMStoreManager sharedInstance] setuseIsStaff:cuserdata.userBaseClass.data.userInfo.isStaff];
            [[CMStoreManager sharedInstance] storeUserName:cuserdata.userBaseClass.data.userInfo.tele];
            [self requestToGetAccount];
            [DataEngine requestUpdateUMDevicesWithBlock:^(BOOL SUCCESS) {
                //绑定手机不提醒设置手势密码
                if(self.isBindMobile){
                    [self bindMobile];
                }
                else{
                    
                    //提醒是否设置手势密码
                    if (![CacheEngine isSetPwd]) {
                        [[UIEngine sharedInstance] showAlertWithTitle:dictionary[@"msg"] ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:nil];
                        [UIEngine sharedInstance ] .alertClick = ^(int aIndex){
                            if (self.navigationController.viewControllers.count > 1 && [self.navigationController.viewControllers[1] isKindOfClass:[IndexViewController class]]) {
                                UIViewController   *viewController = self.navigationController.viewControllers[1];
                                [self.navigationController popToViewController:viewController animated:YES];
                            }
                            else{
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }
                        };
                        
                    }
                    else{
                        [self bindMobile];
                    }
                }
            }];
            
        }else{
            [UIEngine showShadowPrompt:dictionary[@"msg"]];
        }
        
        [self sendNotification];
        
    } failureBlock:^(NSError *error) {
        [[UIEngine sharedInstance] hideProgress];
    }];
    
}

#pragma mark 用户账户信息（是否开启财牛、积分、南交所账户）
-(void)requestToGetAccount{
    [RequestDataModel requestUserAccountsInfoSuccessBlock:^(BOOL success, id Info) {
        
    }];
}

- (void)bindMobile{
    if (self.isBindMobile)
    {
        if (self.isCharge)
        {
            AccountRechargeViewController * accountVC = [[AccountRechargeViewController alloc] init];
            accountVC.rechargeWay = 1;
            [self.navigationController pushViewController:accountVC animated:YES];
        }
        else
        {
            UIViewController *vc = self.navigationController.viewControllers[2];
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    addTextFieldNotification(textFieldValueChange);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.passWordTextField.delegate=self;
    [self.passWordTextField becomeFirstResponder];
    self.confirmBtn.clipsToBounds=YES;
    self.confirmBtn.layer.cornerRadius=6;
    self.confirmBtn.enabled=NO;
    self.confirmBtn.backgroundColor=[UIColor lightGrayColor];
    
    _notification= [NSNotification notificationWithName:@"changePagePosition" object:self userInfo:nil];

    [self setNavLeftBut:NSPushMode];
    
    [self.eyeBtn setImage:[UIImage imageNamed:@"button_04"] forState:UIControlStateNormal];
    [self.eyeBtn setImage:[UIImage imageNamed:@"button_05"] forState:UIControlStateSelected];
    
    if ([self.sourceStr isEqualToString:@"验证账号"]) {
        [self.confirmBtn setTitle:@"提交" forState:UIControlStateNormal];
        self.title=@"重置密码";
    }
    else
    {
        if (self.isBindMobile) {
            [self.confirmBtn setTitle:@"提交绑定" forState:UIControlStateNormal];
            self.title=@"设置密码";
        }
        else
        {
            [self.confirmBtn setTitle:@"注册" forState:UIControlStateNormal];
            self.title=@"设置密码";
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)eyesClick:(UIButton *)sender
{
    if (sender.selected==YES) {
        sender.selected=NO;
        self.passWordTextField.secureTextEntry=YES;
    }
    else
    {
        sender.selected=YES;
        self.passWordTextField.secureTextEntry=NO;
    }
}
- (IBAction)textFieldValueChange
{
    if (self.passWordTextField.text.length<6)
    {
        self.confirmBtn.enabled=NO;
        self.confirmBtn.backgroundColor=[UIColor lightGrayColor];
    }
    else
    {
        self.confirmBtn.enabled=YES;
        self.confirmBtn.backgroundColor=RGBACOLOR(255, 62, 27, 1);
    }
    
    if(self.passWordTextField.text.length>20)
    {
        self.passWordTextField.text = [self.passWordTextField.text substringToIndex:20];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view.window endEditing:YES];
    return YES;
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
