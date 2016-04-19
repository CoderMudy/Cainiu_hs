//
//  SubmitViewController.m
//  hs
//
//  Created by 杨永刚 on 15/5/27.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "SubmitViewController.h"
#import "HSInputView.h"
#import "FinishDrawMoneyViewController.h"
#import "TiXianFinishViewController.h"
#import "TiXianListViewController.h"
#import "ShengfenRenZhengViewController.h"
#import "NetRequest.h"
#import "UIImageView+WebCache.h"

@interface SubmitViewController ()<UITextFieldDelegate>
{
    UILabel *_bankNameLabel;
    UILabel *_bankCardLabel;
    UITextField *_moneyInput;
    UIButton *_bottomBut;
    UILabel *alert2Label;
    
    NSDictionary *finishfinancyDic;
    
    NSMutableArray *imageDetailArray;
    
    NSString *failinfoMsg;
    NSString *infoShenHeStatus;

}

@end

@implementation SubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviTitle:@"账户提现"];
    self.navigationController.navigationBarHidden = YES;
    [self setNavibarBackGroundColor:K_color_NavColor];
    [self setBackButton];
    [self setRightBtnWithTitle:@"提现列表"];
    
    [self.view setBackgroundColor:RGBCOLOR(244, 244, 244)];
    self.usedMoney = @"0";
    
    [self getBankCardList];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    removeTextFileNotification;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self getUseMoney];
    addTextFieldNotification(textFieldChange);
}

- (void)leftButtonAction
{
    
    SubmitViewController *subVC = self;
    UIViewController *vc = (UIViewController *)subVC.navigationController.viewControllers[1];
    [subVC.navigationController popToViewController:vc animated:YES];



}

- (void)rightButtonAction
{
    TiXianListViewController *listCtrl = [[TiXianListViewController alloc]init];
    [self.navigationController pushViewController:listCtrl animated:YES];
}

//可提现余额
-(void)getUseMoney
{
    [UIEngine sharedInstance].progressStyle = 1;
    [[UIEngine sharedInstance] showProgress];
    [DataEngine requestToGetAllMoneyWithComplete:^(BOOL SUCCESS, NSMutableArray *infoArray) {
        [[UIEngine sharedInstance] hideProgress];
        if (SUCCESS) {
            self.usedMoney = infoArray[0];
//            alert2Label.text = [NSString stringWithFormat:@"可提现%@元",self.usedMoney];
            NSString *userMoney = @"可提现:元";
            
            NSString *dataStr = [DataEngine addSign:[NSString stringWithFormat:@"%.2lf",[self.usedMoney doubleValue]]];
            NSString *textStr = [NSString stringWithFormat:@"可提现:%@元",dataStr];
            
            alert2Label.attributedText = [Helper multiplicityText:textStr from:4 to:(int)textStr.length - (int)userMoney.length color:K_color_red];
            //暂时注释
            if ([infoArray[0] floatValue]<10) {
//                [UIEngine showShadowPrompt:@"账户可提现余额不足"];
//                UIViewController *vc = (UIViewController *)self.navigationController.viewControllers[1];
//                [self.navigationController popToViewController:vc animated:YES];
            }
            
        }
        else
        {
            if ([infoArray[0] length]>0) {
                [UIEngine showShadowPrompt:infoArray[0]];
            }
        }
    }];
}

- (void)initUIWithBankNameArray:(NSMutableArray *)aBankNameArray ImageAddArray:(NSMutableArray *)aImageAddArray
{
    
    
    
    UIView *bankTopView = [[UIView alloc]init];
    bankTopView.backgroundColor = [UIColor whiteColor];
    bankTopView.frame = CGRectMake(0, 64, ScreenWidth, 20 + 20 + 20 + 10);
    [self.view addSubview:bankTopView];
    
    UIImageView *bankIconView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 40/2-12+20 , 24, 24)];
    [bankTopView addSubview:bankIconView];
    
    NSArray * bankIconArray = [NSArray arrayWithArray:aImageAddArray];
    NSArray *bankNameArray = [NSArray arrayWithArray:aBankNameArray];
    for (int i = 0; i<bankNameArray.count; i++) {
        if ([self.bankName isEqualToString:bankNameArray[i]]) {
            [bankIconView sd_setImageWithURL:[NSURL URLWithString:bankIconArray[i]] placeholderImage:nil];
        }
    }
    
    _bankNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bankIconView.frame) + 20, 20, ScreenWidth/2, 20)];
    [_bankNameLabel setTextColor:[UIColor blackColor]];
    _bankNameLabel.text = self.bankName;
    [bankTopView addSubview:_bankNameLabel];
    
    _bankCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bankIconView.frame) + 20,CGRectGetMaxY(_bankNameLabel.frame) , WIDTH(_bankNameLabel)/2, 20)];
    [_bankCardLabel setFont:[UIFont systemFontOfSize:12]];
    [_bankCardLabel setTextColor:SUBTEXTCOLOR];
    _bankCardLabel.text = [NSString stringWithFormat:@"尾号%@",[self.bankCard substringFromIndex:self.bankCard.length-4]];
    [bankTopView addSubview:_bankCardLabel];
    
    alert2Label = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(bankTopView.frame), ScreenWidth - 30, 30)];
    alert2Label.textColor = [UIColor lightGrayColor];
    [alert2Label setBackgroundColor:[UIColor clearColor]];
    [alert2Label setText:[NSString stringWithFormat:@"可提现%@元",self.usedMoney]];
    
    [alert2Label setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:alert2Label];

    //
    UIView *moneyView = [[UIView alloc]init];
    moneyView.backgroundColor = [UIColor whiteColor];
    moneyView.frame   = CGRectMake(0, CGRectGetMaxY(alert2Label.frame), ScreenWidth, 51);
    [self.view addSubview:moneyView];
    
    UILabel *moneyLab = [[UILabel alloc]init];
    moneyLab.font = [UIFont systemFontOfSize:14.0];
    moneyLab.textColor = [UIColor blackColor];
    moneyLab.frame = CGRectMake(30, 15, 70, 21);
    moneyLab.text = @"提现金额";
    [moneyView addSubview:moneyLab];
    
    _moneyInput = [[UITextField alloc]init];
    _moneyInput.frame = CGRectMake(CGRectGetMaxX(moneyLab.frame) + 10, 0, ScreenWidth, 50);
    _moneyInput.placeholder = @"最小提现金额20元";
    _moneyInput.font = [UIFont systemFontOfSize:14.0];
    _moneyInput.keyboardType = UIKeyboardTypeDecimalPad;
    _moneyInput.backgroundColor = [UIColor whiteColor];
    _moneyInput.delegate = self;
    _moneyInput.clearButtonMode = UITextFieldViewModeAlways;//系统默认的叉
    _moneyInput.textColor = [UIColor blackColor];
    [moneyView addSubview:_moneyInput];
    
//    _moneyInput = [[HSInputView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(moneyLab.frame), 0, ScreenWidth, 50) titleText:nil placeholderStr:@"最小提现金额20元"];
//    _moneyInput.downLine.hidden = YES;
//    [_moneyInput setBackgroundColor:[UIColor whiteColor]];
//    [_moneyInput.inputText setReturnKeyType:UIReturnKeyDone];
//    _moneyInput.inputText.keyboardType = UIKeyboardTypeDecimalPad;
//    _moneyInput.inputText.delegate = self;
//    [_moneyInput.inputText addTarget:self action:@selector(textFieldChange) forControlEvents:UIControlEventValueChanged];
//    [moneyView addSubview:_moneyInput];
    
    
    _bottomBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bottomBut setFrame:CGRectMake(20, CGRectGetMaxY(moneyView.frame) + 20, WIDTH(self.view)-40, 44)];
    [_bottomBut setBackgroundColor:[UIColor lightGrayColor]];
    [_bottomBut.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_bottomBut setTitle:@"确定" forState:UIControlStateNormal];
    _bottomBut.layer.cornerRadius = 5.0;
    [self.view addSubview:_bottomBut];
    _bottomBut.enabled = NO;
    _bottomBut.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        if ([_bottomBut.backgroundColor isEqual:CanSelectButBackColor]) {
            if ([UIEngine checkMoney:_moneyInput]) {
//                //======在这里判断用户第几次提现
//                [self requestUserTixianNum];
                if ([self.usedMoney floatValue]<10) {
                    //提示框，提示今天提现次数已经到达上限
                    [[UIEngine sharedInstance] showAlertWithTitle:@"账户可提现余额不足" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
                    [UIEngine sharedInstance].alertClick = ^(int aIndex)
                    {
                        
                    } ;
                }else
                {
                    //======在这里判断用户第几次提现
                    [self requestUserTixianNum];
//                    [self requestURLData];
                }
            }
        }
        return [RACSignal empty];
    }];
    
    
    UILabel *proLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_bottomBut.frame) + 15, ScreenWidth-40, 220)];
    NSString * proText = [NSString stringWithFormat:@"温馨提示： \n\n1、消费用户提款免手续费，为防止恶意提款，每日提款申请次数最多为2次，超过次日处理； \n2、为防止套现和洗钱，单笔充值无消费者提现时需提供身份证和银行卡给风控进行核实。如信息核实无误，%@将会在7-15个工作日内处理，银行收取2%%的手续费自理，最低2元； \n3、周一至周五09:00-17:00的提款申请当天处理，17:00以后的提款申请延至第二天处理。周五17:00后提款，延至下个工作日处理。提现到账时间最快2小时，最晚1个工作日。 \n4、周六周日提款延迟至周一处理，若节假日提款，一律节后第一个工作日处理。",App_appShortName];
    proLabel.text = proText;
    proLabel.textAlignment = NSTextAlignmentLeft;
    proLabel.font = [UIFont systemFontOfSize:12];
    proLabel.numberOfLines = 0;
    proLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.8];
    [self.view addSubview:proLabel];
    
    proLabel.attributedText = [Helper mutableFontAndColorText:proLabel.text from:0 to:5 font:13 from:0 to:5 color:[UIColor redColor]];
    
    if (AppStyle_SAlE) {
        return;
    }
    
    NSString * tel = @"";
#if defined (YQB)
    tel = @"400-8915-690";
    
#else
    tel = @"400-6666-801";
    
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

-(void)textFieldChange
{
    if (_moneyInput.text.length >0) {
        _bottomBut.enabled = YES;
        [_bottomBut setBackgroundColor:CanSelectButBackColor];
    }
    else{
        _bottomBut.enabled = NO;
        [_bottomBut setBackgroundColor:[UIColor lightGrayColor]];
    }
}

-(void)call{
    
    NSString * tel = @"";
#if defined (YQB)
    tel = @"400-8915-690";
    
#else
    tel = @"400-6666-801";
    
#endif
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"系统提示" message:[NSString  stringWithFormat:@"您是否要拨打客服电话 %@ ?",tel] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)nextPage
{
//    FinishDrawMoneyViewController *submitPage = [[FinishDrawMoneyViewController alloc] init];
//    submitPage.moneyStr = _moneyInput.text;
//    [self.navigationController pushViewController:submitPage animated:YES];
    TiXianFinishViewController *tiXianFinishCtrl = [[TiXianFinishViewController alloc]init];
    tiXianFinishCtrl.finishDic = finishfinancyDic;
    [self.navigationController pushViewController:tiXianFinishCtrl animated:YES];
}

#pragma mark - 用户第几次提现的接口
- (void)requestUserTixianNum
{
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token};
    [NetRequest postRequestWithNSDictionary:dic url:K_Tixian_Num successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            NSLog(@"fuck:%d",[dictionary[@"data"][@"count"] intValue]);
            if ([dictionary[@"data"][@"count"] intValue] == 0) {
                //如果是第一提现。直接走到提现里面
                if ([self.usedMoney floatValue]<20) {
                    [UIEngine showShadowPrompt:@"可提现金额不足"];
                }
                else
                {
                    [self requestURLData];
                }
                
            }else
            {
                //如果是第二次提现，判断是否有消费，这里需要调用是否消费的接口
                [self requestIsTradeOrNot];
                
            }
        }
    } failureBlock:^(NSError *error) {
        
    }];
    
}

#pragma mark - 判断用户是否有交易过
- (void)requestIsTradeOrNot
{
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token};
    [NetRequest postRequestWithNSDictionary:dic url:K_User_IsTradeOrNot successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            if ([dictionary[@"data"][@"count"] intValue] == 0) {
                //没有交易过的时候要进行身份认证,这里需要调用身份认证接口。判断用户是否有审核过身份认证
                [self requestShenHeStatus];
                
            }else
            {//有交易的时候，无需进行身份认证
                
                if ([self.usedMoney floatValue]<20) {
                    [UIEngine showShadowPrompt:@"可提现金额不足"];
                }
                else
                {
                    [self requestURLData];
                    
                }
                
            }
        }else
        {
            //提示框，提示你有一笔交易待审核
            [[UIEngine sharedInstance] showAlertWithTitle:dictionary[@"msg"] ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
            [UIEngine sharedInstance].alertClick = ^(int aIndex)
            {
                
            } ;
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
    
}

#pragma mark - 请求审核状态接口
- (void)requestShenHeStatus
{
    imageDetailArray = [[NSMutableArray alloc]init];
    
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token};
    [NetRequest postRequestWithNSDictionary:dic url:K_ShenHe_Satus successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            NSDictionary *dic = dictionary[@"data"];
            [imageDetailArray addObject:dic[@"image1"]];
            [imageDetailArray addObject:dic[@"image2"]];
            [imageDetailArray addObject:dic[@"image3"]];
            failinfoMsg = dic[@"remark"];
            
            NSString *titleMsg = @"";
            if ([dic[@"status"] intValue] == -1) {
                infoShenHeStatus = @" ";
                titleMsg = @"身份未认证，请先认证身份信息";
            }else if ([dic[@"status"] intValue] == 0)
            {
                infoShenHeStatus = @"审核中";
                titleMsg = @"身份认证审核中";
            }else if ([dic[@"status"] intValue] == 1)
            {
                infoShenHeStatus = @"审核成功";
            }else if ([dic[@"status"] intValue] == 2)
            {
                infoShenHeStatus = @"失败";
                titleMsg = @"身份认证失败";
            }
            
            if ([dic[@"status"] intValue] == -1 || [dic[@"status"] intValue] == 0 || [dic[@"status"] intValue] == 2) {
                [[UIEngine sharedInstance] showAlertWithTitle:titleMsg ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
                [UIEngine sharedInstance].alertClick = ^(int aIndex)
                {
                    ShengfenRenZhengViewController *shenCtrl = [[ShengfenRenZhengViewController alloc]init];
                    shenCtrl.userInfo = _privateUserInfo;
                    shenCtrl.shenHeStatus = infoShenHeStatus;
                    shenCtrl.infoArray = imageDetailArray;
                    shenCtrl.faileMsg  = failinfoMsg;
                    NSLog(@"sha qing kuan :%@==%@==%@",_privateUserInfo.bankCard,_privateUserInfo.realName,_privateUserInfo.idCard);
                    [self.navigationController pushViewController:shenCtrl animated:YES];
                } ;
                
            }else
            {
                //如果身份认证已经成功了的。可直接输入金额
                //如果是第一提现。直接走到提现里面
                if ([self.usedMoney floatValue]<20) {
                    [UIEngine showShadowPrompt:@"可提现金额不足"];
                }
                else
                {
                    [self requestURLData];
                    
                }
                
            }
            
            
        }
    } failureBlock:^(NSError *error) {
        
    }];
    
}


#pragma mark - 用户提现申请
- (void)requestURLData
{
    
    [UIEngine sharedInstance].progressStyle = 1 ;
    [[UIEngine sharedInstance] showProgress];
    
    NSString * hotListUrl =[NSString stringWithFormat:@"%@/financy/financy/apiWithdraw",K_MGLASS_URL];
    NSDictionary * dic                            = @{
                                                      @"token":[[CMStoreManager sharedInstance] getUserToken],
                                                      @"inoutAmt":[NSNumber numberWithDouble: [_moneyInput.text doubleValue]],
                                                      @"version":VERSION
                                                      };
    
    [NetRequest postRequestWithNSDictionary:dic
                                        url:hotListUrl
                               successBlock:^(NSDictionary *dictionary) {
                                   [[UIEngine sharedInstance] hideProgress];
                                   
                                  if ([[dictionary objectForKey:@"code"] integerValue] == 200) {
                                       finishfinancyDic = dictionary[@"data"];
                                       [self nextPage];
                                  }else if([[dictionary objectForKey:@"code"] integerValue]==43513){
                                  
                                      [[UIEngine sharedInstance] showAlertWithTitle:dictionary[@"msg"] ButtonNumber:1 FirstButtonTitle:@"马上交易" SecondButtonTitle:@""];
                                      [UIEngine sharedInstance].alertClick = ^(int aIndex){
                                          _moneyInput.text = @"";
                                          
                                          self.rdv_tabBarController.selectedIndex = 0;
                                          [self.navigationController popToRootViewControllerAnimated:YES];

                                      };
                                      
                                      
                                  }else{

                                       [[UIEngine sharedInstance] showAlertWithTitle:dictionary[@"msg"] ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
                                       [UIEngine sharedInstance].alertClick = ^(int aIndex){
                                           _moneyInput.text = @"";
                                           [self textFieldChange];
                                       };
                                   }
                                   
                                   
                               } failureBlock:^(NSError *error) {
                                   CMLog(@"%@",error.localizedDescription);
//                                   [UIEngine showShadowPrompt:@"！您当前网络不佳，请稍后再试"];
                                   [[UIEngine sharedInstance] hideProgress];
                               }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self requestURLData];
    [textField resignFirstResponder];
    return YES;
}


-(void)getBankCardList{
    
    [DataEngine requestToGetBankCardList:^(NSMutableArray *bankNameArray, NSMutableArray *imageAddArray) {
        if (bankNameArray != nil && imageAddArray != nil) {
            
        }
        else{
            bankNameArray = [NSMutableArray arrayWithObjects:@"广发银行",@"浦发银行",@"兴业银行",@"招商银行",@"中国银行",
                             @"中国农业银行",@"中国建设银行",@"中国光大银行",@"平安银行",@"中国民生银行",
                             @"华夏银行",@"中国工商银行",@"交通银行",@"中信银行", nil];
  
            imageAddArray= [NSMutableArray arrayWithObjects:@"guangfa",@"pufa",@"xingye",@"zhaoshang",@"zhongguo",
                             @"nongye",@"jianshe",@"guangda",@"pingan",@"minsheng",
                             @"huaxia",@"gongshang",@"jiaotong",@"zhongxin",nil
                             ];
        }
        
        [self initUIWithBankNameArray:bankNameArray ImageAddArray:imageAddArray];
    }];
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
