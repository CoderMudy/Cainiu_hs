//
//  MoneyDetaillViewController.m
//  hs
//
//  Created by 杨永刚 on 15/5/24.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "NetRequest.h"
#import "MoneyDetailCell.h"
#import "MoneyDetaillViewController.h"
#import "RealNameViewController.h"
#import "BankCardViewController.h"
#import "AccountRechargeViewController.h"
#import "SubmitViewController.h"
#import "PrivateUserInfo.h"
#import "MobileBindViewController.h"
#import "PrivateUserInfo.h"
#import "FinishDrawMoneyViewController.h"
#import "MJRefresh.h"
#import "ChooseChargeWayController.h"
#import "NetRequest.h"
#import "NSString+MD5.h"
#import "LoginViewController.h"
#import "ShengfenRenZhengViewController.h"


@interface MoneyDetaillViewController ()
{
    PrivateUserInfo   *_privateUserInfo;
    NSMutableArray * _hotAddArray;
    NIAttributedLabel *_freezeMoneyLabel;
    NIAttributedLabel *_avMoneyLabel;
    UIButton          *_drawMoneyBut;
    
    int startLine;
    int limitLine;
    int oldLine;
    
    int switchNum;
    
    NSDictionary *submitDic;
    
    NSMutableArray *imageDetailArray;
    
    NSString *failinfoMsg;
    NSString *infoShenHeStatus;
}
@property (nonatomic, strong)NSNotification * notification;

@property (nonatomic,strong)UITableView *tableView;
@end


@implementation MoneyDetaillViewController



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"充值提现"];
    
    self.navigationController.navigationBarHidden = NO;
    self.rdv_tabBarController.tabBarHidden        = YES;
    self.automaticallyAdjustsScrollViewInsets     = NO;
//    startLine                                     = 0;
    
    switchNum = 0;
    
    UserInfo *userInfo = getUser_Info;
    if (userInfo == nil) {
        return;
    }
    
    startLine = 1;
    [UIEngine sharedInstance].progressStyle = 1;
    [[UIEngine sharedInstance] showProgress];
    [self requestURLData:NO];
    [self getUseMoney];
    [self getSystemDate];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"充值提现"];
    [[UIEngine sharedInstance] hideProgress];
    self.navigationController.navigationBarHidden = NO;
    
}

-(void)dismissProgress
{
    switchNum += 1;
    
    if (switchNum == 3)
    {
        [[UIEngine sharedInstance] hideProgress];
    }
}

- (void)requestURLData:(BOOL)moreFlag
{
    NSString * hotListUrl =[NSString stringWithFormat:@"%@/financy/financy/apiFinancyFlowList",K_MGLASS_URL];
    NSDictionary * dic                            = @{
                                                      @"token":[[CMStoreManager sharedInstance] getUserToken],
                                                      @"pageNo":[NSString stringWithFormat:@"%d",startLine],
                                                      @"pageSize":[NSString stringWithFormat:@"%d",limitLine],
                                                      @"version":VERSION
                                                      };
    
    [NetRequest postRequestWithNSDictionary:dic
                                        url:hotListUrl
                               successBlock:^(NSDictionary *dictionary) {
                                   if (moreFlag) {
                                       
                                       if ([dictionary[@"data"] count]!=0) {
                                           startLine += 1;
                                       }
                                       
                                       [_hotAddArray addObjectsFromArray:dictionary[@"data"]];
                                   }else{
                                       [_hotAddArray removeAllObjects];
                                       if ([dictionary[@"data"] isKindOfClass:[NSArray class]]||[dictionary[@"data"] isKindOfClass:[NSMutableArray class]]) {
                                           
                                           startLine += 1;
                                           
                                           [_hotAddArray addObjectsFromArray:dictionary[@"data"]];
                                       }
                                       
                                   }
                                   
                                   [self endLoading];
                                   
                                   //缓存
                                   CacheModel *cacheModel = [CacheEngine getCacheInfo];
                                   cacheModel.accountModel.accountDetailModel.accountDetailArray = [NSMutableArray arrayWithArray:_hotAddArray];
                                   [CacheEngine setCacheInfo:cacheModel];
                                   
                                   
                                   [self dismissProgress];
                                   
                                   [self.tableView reloadData];
                                   
                               } failureBlock:^(NSError *error) {
                                   NSLog(@"%@",error.localizedDescription);
                                   [self dismissProgress];
                                   [self endLoading];
                               }];
}

-(void)getSystemDate
{
//    [UIEngine sharedInstance].progressStyle = 1;
//    [[UIEngine sharedInstance] showProgress];
    [DataEngine requestToGetSystemDateWithComplete:^(BOOL SUCCESS, NSString *data , NSString *timeInterval) {
        if (SUCCESS) {
            saveUserDefaults(data, uSystemDate);
        }
        else
        {
//            [UIEngine showShadowPrompt:@"系统时间获取失败"];
        }
//        [[UIEngine sharedInstance] hideProgress];
        [self dismissProgress];
    }];
}

//可提现余额
-(void)getUseMoney
{
    [DataEngine requestToGetAllMoneyWithComplete:^(BOOL SUCCESS, NSMutableArray *infoArray) {
        
        if (SUCCESS) {
            
            
            //可提现金额
            NSString *moneyStr = [NSString stringWithFormat:@"%@ 元",[DataEngine addSign:[NSString stringWithFormat:@"%.2lf",[infoArray[0] doubleValue]] ]];
            
//            //账户可用余额
//            if ([infoArray[0] floatValue]>=100000) {
//                NSString *str =[DataEngine addSign:[NSString stringWithFormat:@"%.3f",[infoArray[0] floatValue]/10000.0]];
//                moneyStr=[[str substringToIndex:str.length-1] stringByAppendingString:@" 万元"];
//            }
//            else
//            {
//                moneyStr=[[DataEngine addSign:[NSString stringWithFormat:@"%.2f",[infoArray[0] floatValue]]] stringByAppendingString:@" 元"];
//            }
            
            //缓存
            CacheModel *cacheModel = [CacheEngine getCacheInfo];
            cacheModel.accountModel.accountDetailModel.drawMoney = moneyStr;
            [CacheEngine setCacheInfo:cacheModel];
            
            
            [_avMoneyLabel setFont:[UIFont systemFontOfSize:18]];
            _avMoneyLabel.text = moneyStr;
            [_avMoneyLabel setTextColor:[UIColor colorWithHexString:@"373635"]];
            [_avMoneyLabel setTextColor:[UIColor colorWithHexString:@"999999"] range:[moneyStr rangeOfString:@"元"]];
            [_avMoneyLabel setFont:[UIFont systemFontOfSize:12] range:[moneyStr rangeOfString:@"元"]];
            
            
            
            self.usedMoney = infoArray[0];
            
//            if ([infoArray[0] floatValue] >= 10) {
                [_drawMoneyBut setBackgroundColor:[UIColor colorWithHexString:@"fe4300"]];
                _drawMoneyBut.enabled = YES;
//            }
//            else{
//                [_drawMoneyBut setBackgroundColor:[UIColor colorWithHexString:@"6e6e6e"]];
//                _drawMoneyBut.enabled = NO;
//            }
            
            
            
            //冻结金额
            
            if([[NSString stringWithFormat:@"%@",infoArray[3]] isEqualToString:@""])
            {
                infoArray[3] = @"0.00";
            }
            NSString *freezeStr = [NSString stringWithFormat:@"%@ 元",[DataEngine addSign:[NSString stringWithFormat:@"%.2lf",[infoArray[3] doubleValue]] ]];
            
            //缓存
            cacheModel.accountModel.accountDetailModel.freezeMoney = freezeStr;
            [CacheEngine setCacheInfo:cacheModel];
            
            
            [_freezeMoneyLabel setFont:[UIFont systemFontOfSize:18]];
            _freezeMoneyLabel.text = freezeStr;
            [_freezeMoneyLabel setTextColor:[UIColor colorWithHexString:@"373635"]];
            [_freezeMoneyLabel setTextColor:[UIColor colorWithHexString:@"999999"] range:[freezeStr rangeOfString:@"元"]];
            [_freezeMoneyLabel setFont:[UIFont systemFontOfSize:12] range:[freezeStr rangeOfString:@"元"]];
        }

        [self dismissProgress];
    }];
}

////验证手机号
//-(void)authMobile
//{
//    [DataEngine requestToAuthbindOfMobileWithComplete:^(BOOL SUCCESS, NSString * status, NSString * tel) {
//        if (SUCCESS) {
//            if ([status isEqualToString:@"1"]||[status isEqualToString:@"2"]) {
////                [self authRealName:ActionTypeRechargeMoney];
//                AccountRechargeViewController * accountVC = [[AccountRechargeViewController alloc] init];
//                accountVC.rechargeWay = 1;
//                accountVC.intoStatus = self.intoStatus;
//                [self.navigationController pushViewController:accountVC animated:YES];
//                
//                
//            }
//            else
//            {
//                [[UIEngine sharedInstance] hideProgress];
//                [[UIEngine sharedInstance] showAlertWithTitle:@"为了您账户的安全，请先绑定手机号" ButtonNumber:2 FirstButtonTitle:@"取消" SecondButtonTitle:@"绑定手机"];
//                [UIEngine sharedInstance].alertClick = ^(int aIndex)
//                {
//                    if (aIndex == 10087) {
//                        MobileBindViewController *mobileVC = [[MobileBindViewController alloc]init];
//                        mobileVC.privateUserInfo = _privateUserInfo;
//                        mobileVC.isCharge = YES;
//                        mobileVC.block = ^(PrivateUserInfo *privateUserInfo){};
//                        [self.navigationController pushViewController:mobileVC animated:YES];
//                    }
//                };
//            }
//        }
//        else
//        {
//            [[UIEngine sharedInstance] hideProgress];
//            if (status.length>0) {
//                [UIEngine showShadowPrompt:status];
//            }
//            else
//            {
//                [UIEngine showShadowPrompt:@"！您当前网络不佳，请稍后重试"];
//            }
//        }
//    }];
//}

//验证真实姓名
-(void)authRealName:(ActionType)type
{
    [DataEngine requestToAuthbindOfRealNameWithComplete:^(BOOL SUCCESS, NSString * status, NSString * realName, NSString * idCard) {
        if (SUCCESS) {
            if ([status isEqualToString:@"1"]||[status isEqualToString:@"2"]) {
                _privateUserInfo.statusRealName=status;
                _privateUserInfo.realName=realName;
                _privateUserInfo.idCard=idCard;
                [self authBankCard:type];
            }else{
                [[UIEngine sharedInstance] hideProgress];
                RealNameViewController *realVC=[[RealNameViewController alloc]init];
                realVC.isAuth=NO;
                realVC.isOtherPage=YES;
                if (type == ActionTypeRechargeMoney) {
                    realVC.isCharge = YES;
                }
                realVC.privateUserInfo=_privateUserInfo;
                realVC.block=^(PrivateUserInfo *privateUserInfo)
                {
                };
                BackButtonHeader;
//                [self presentViewController:realVC animated:YES completion:nil];
                [self.navigationController pushViewController:realVC animated:YES];
            }
        }
        else
        {
            [[UIEngine sharedInstance] hideProgress];
            if (status.length>0) {
                [UIEngine showShadowPrompt:status];
            }
            else
            {
//                [UIEngine showShadowPrompt:@"！您当前网络不佳，请稍后再试"];
            }
        }
    }];
}

//验证银行卡
-(void)authBankCard:(ActionType)type
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[CMStoreManager sharedInstance] getUserToken],@"token",
                       VERSION,@"version",
                       nil];
    NSString     *url=[NSString stringWithFormat:@"%@/user/user/checkBankCard",K_MGLASS_URL];
    
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        [[UIEngine sharedInstance] hideProgress];
        if ([dictionary[@"code"] integerValue] == 200) {
    
            if ([[NSString stringWithFormat:@"%@",dictionary[@"data"][@"status"]] isEqualToString:@"1"]||[[NSString stringWithFormat:@"%@",dictionary[@"data"][@"status"]] isEqualToString:@"2"]) {
                
                _privateUserInfo.bankCard = dictionary[@"data"][@"bankNum"];
                if (type == ActionTypeRechargeMoney) {
                    AccountRechargeViewController *rechargePage = [[AccountRechargeViewController alloc] init];
                    [rechargePage setNavLeftBut:NSPushMode];
                    rechargePage.intoStatus = self.intoStatus;
                    rechargePage.bankCard = dictionary[@"data"][@"bankNum"];
                    [self.navigationController pushViewController:rechargePage animated:YES];
                }
                if (type ==  AtcionTypeDrawMoney) {
                    
                    submitDic = dictionary[@"data"];

                    //======在这里判断用户第几次提现
//                    [self requestUserTixianNum];
            
                    //=========
//                    if ([self.usedMoney floatValue]<20) {
//                        [UIEngine showShadowPrompt:@"可提现金额不足"];
//                    }
//                    else
//                    {
                        //
                        SubmitViewController *submitPage = [[SubmitViewController alloc] init];
                        submitPage.bankName = (NSString *)dictionary[@"data"][@"bankName"] ;
                        submitPage.bankCard = (NSString *)dictionary[@"data"][@"bankNum"] ;
                        submitPage.branName = (NSString *)dictionary[@"data"][@"branName"] ;
                        submitPage.cityName = (NSString *)dictionary[@"data"][@"cityName"] ;
                        submitPage.provName = (NSString *)dictionary[@"data"][@"provName"] ;
                        submitPage.ID = dictionary[@"data"][@"id"] ;
                        submitPage.usedMoney = self.usedMoney;
                        submitPage.privateUserInfo = _privateUserInfo;
                        [self.navigationController pushViewController:submitPage animated:YES];
                        
//                    }
                    
                }

            }else{
                [[UIEngine sharedInstance] hideProgress];
                BackButtonHeader
                BankCardViewController *bankVC=[[BankCardViewController alloc]init];
                bankVC.isBinding=NO;
                bankVC.isOtherPage=YES;
                if (type == ActionTypeRechargeMoney) {
                    bankVC.isCharge = YES;
                }
                bankVC.privateUserInfo=_privateUserInfo;
                bankVC.block=^(PrivateUserInfo *privateUserInfo)
                {
                    
                };
                [self.navigationController pushViewController:bankVC animated:YES];
            }
        }else{
            [[UIEngine sharedInstance] hideProgress];
             [[[iToast makeText:[dictionary objectForKey:@"msg"]] setGravity:iToastGravityCenter] show];
            }
    } failureBlock:^(NSError *error) {

//        [UIEngine showShadowPrompt:@"！您当前网络不佳，请稍后再试"];
        [[UIEngine sharedInstance] hideProgress];
    }];
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
//                if ([self.usedMoney floatValue]<20) {
//                    [UIEngine showShadowPrompt:@"可提现金额不足"];
//                }
//                else
//                {
                    //
                    SubmitViewController *submitPage = [[SubmitViewController alloc] init];
                    submitPage.bankName = (NSString *)submitDic[@"bankName"] ;
                    submitPage.bankCard = (NSString *)submitDic[@"bankNum"] ;
                    submitPage.branName = (NSString *)submitDic[@"branName"] ;
                    submitPage.cityName = (NSString *)submitDic[@"cityName"] ;
                    submitPage.provName = (NSString *)submitDic[@"provName"] ;
                    submitPage.ID = submitDic[@"id"] ;
                    submitPage.privateUserInfo = _privateUserInfo;
                    submitPage.usedMoney = self.usedMoney;
                    [self.navigationController pushViewController:submitPage animated:YES];
                    
//                }

            }else
            {
                //如果是第二次提现，判断是否有消费，这里需要调用是否消费的接口
                [self requestIsTradeOrNot];
                
            }
        }
    } failureBlock:^(NSError *error) {
        
    }];

}

#pragma mark - 判断用户当日第几次提现
- (void)requestTodayTixianNum
{
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token};
    [NetRequest postRequestWithNSDictionary:dic url:K_Today_TixianNum successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            if ([dictionary[@"data"][@"count"] intValue]< 2) {
                [self checkLoginPassWord];//继续登录密码认证的流程

            }else
            {//提示框，提示今天提现次数已经到达上限
                [[UIEngine sharedInstance] showAlertWithTitle:@"今天提现次数已到达上限" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
                [UIEngine sharedInstance].alertClick = ^(int aIndex)
                {
                
                } ;
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
                //如果有过交易，直接进入提现
//                if ([self.usedMoney floatValue]<20) {
//                    [UIEngine showShadowPrompt:@"可提现金额不足"];
//                }
//                else
//                {
                    //
                    SubmitViewController *submitPage = [[SubmitViewController alloc] init];
                    submitPage.bankName = (NSString *)submitDic[@"bankName"] ;
                    submitPage.bankCard = (NSString *)submitDic[@"bankNum"] ;
                    submitPage.branName = (NSString *)submitDic[@"branName"] ;
                    submitPage.cityName = (NSString *)submitDic[@"cityName"] ;
                    submitPage.provName = (NSString *)submitDic[@"provName"] ;
                    submitPage.ID = submitDic[@"id"] ;
                    submitPage.privateUserInfo = _privateUserInfo;
                    submitPage.usedMoney = self.usedMoney;
                    [self.navigationController pushViewController:submitPage animated:YES];
                    
//                }

            }
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
//                if ([self.usedMoney floatValue]<20) {
//                    [UIEngine showShadowPrompt:@"可提现金额不足"];
//                }
//                else
//                {
                    //
                    SubmitViewController *submitPage = [[SubmitViewController alloc] init];
                    submitPage.bankName = (NSString *)submitDic[@"bankName"] ;
                    submitPage.bankCard = (NSString *)submitDic[@"bankNum"] ;
                    submitPage.branName = (NSString *)submitDic[@"branName"] ;
                    submitPage.cityName = (NSString *)submitDic[@"cityName"] ;
                    submitPage.provName = (NSString *)submitDic[@"provName"] ;
                    submitPage.ID = submitDic[@"id"] ;
                    submitPage.privateUserInfo = _privateUserInfo;
                    submitPage.usedMoney = self.usedMoney;
                    [self.navigationController pushViewController:submitPage animated:YES];
                    
//                }

            }
            
            
        }
    } failureBlock:^(NSError *error) {
        
    }];
    
}


#pragma mark - 弹出验证登录密码的警告框
- (void)checkLoginPassWord
{

    
    
   __block PopUpView * inputAlertView = [[PopUpView alloc] initInpuStyleAlertWithTitle:@"验证登录密码" setInputItemArray:@[@"请输入登录密码"] setBtnTitleArray:@[@"取消",@"验证"]];
    inputAlertView.twoObjectblock = ^(UIButton *button,NSArray*array){
        if (button.tag==66666) {
            
            
            [inputAlertView removeFromSuperview];
            inputAlertView = nil;

        }else{
            
            
            NSString * passWord = [NSString stringWithFormat:@"%@",array[0]];
            if ([passWord isEqualToString:@""]) {
                
                [UIEngine showShadowPrompt:@"密码不能为空"];

                
            }else if(passWord.length<6){
            
                [UIEngine showShadowPrompt:@"密码位数不能小于6位"];

            
            }else{
            
                
                NSLog(@"%@",passWord);
                
                [self clickCheckpassWord:passWord];
                [inputAlertView removeFromSuperview];
            }
            
        }
   
    };
    
    [self.navigationController.view addSubview:inputAlertView];


   
}
#pragma mark - 验证登录密码
- (void)clickCheckpassWord:(NSString *)passWord
{
    
    passWord = [passWord MD5Digest];
    NSDictionary * reqDic = @{@"token":[[CMStoreManager sharedInstance]getUserToken],
                              @"password":passWord};
    NSString * urlStr = K_user_checkPassWord;
    
    __block int data;
    [NetRequest postRequestWithNSDictionary:reqDic url:urlStr successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"]intValue]==200) {
            
            [UIEngine sharedInstance].progressStyle = 1;
            [[UIEngine sharedInstance] showProgress];
            [self authRealName:AtcionTypeDrawMoney];

        }else{
            if ((NSNull*)dictionary[@"data"] != [NSNull null] && dictionary[@"data"] != nil&&dictionary[@"data"]!=NULL) {
                data  = [dictionary[@"data"]==nil?@"0":dictionary[@"data"] intValue];
            }else{
            
                data = 1;
            }
            if ([dictionary[@"msg"]isEqualToString:@"您输入的密码超过3次错误,请重新登录"]) {
                
                data = 2;
                
            }
            
            PopUpView * showAlert = [[PopUpView alloc] initShowAlertWithShowText:dictionary[@"msg"] setBtnTitleArray:@[@"确定"]];
            showAlert.confirmClick = ^(UIButton* button){
                
                if (data==2) {
                    [self exitLogin];
                    LoginViewController * loginVC = [[LoginViewController alloc] init];
                    [self.navigationController pushViewController:loginVC animated:YES];
                }
            };
            [self.navigationController.view addSubview:showAlert];
        }
    
        
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        
    }];

}
- (void)sendNotification
{
    [[NSNotificationCenter defaultCenter]postNotification:_notification];
}
-(void)exitLogin
{
    
    [self sendNotification];
    NSString    *firstLoginStr = getUserDefaults(@"FirstLogin");
    [self resetDefault];
    [[CMStoreManager sharedInstance] setbackgroundimage];
    [[CMStoreManager sharedInstance] storeUserToken:nil];
    saveUserDefaults(firstLoginStr, @"FirstLogin");
}

- (void)resetDefault
{
//    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
//    NSDictionary * dict = [defs dictionaryRepresentation];
//    for (id key in dict) {
//        if ([key isEqualToString:@"Environment"]||[key isEqualToString:@"UmengCode"]) {
//            
//        }else{
//            
//            [defs removeObjectForKey:key];
//        }}
//    [defs synchronize];
    [[CMStoreManager sharedInstance]exitLoginClearUserData];
}

- (BOOL)isNeedPerfect:(NSString *)bankName districtBranName:(NSString *)branName provName:(NSString *)provName
{
    /////////////*****
    return YES;
    /////////////*****
    
    // 返回YES就是可以直接提款了
    
    //return YES;
     if ((NSNull *)provName == [NSNull null])
         return NO;
    return YES;
    /*
     status  1:已绑定，0:未绑定
     id 唯一标示id
     bankName 银行卡名
     bankNum 卡号末四位
     provName开户省
     cityName开户市
     branName开户支行
     */
    BOOL flag = NO;
    if (!provName) {
        return NO;
    }
    
    
//    NSArray *array = @[@"中国工商银行",@"中国建设银行",@"中国农业银行",@"招商银行"];

    NSArray *array = @[@"中国建设银行",@"中国农业银行",@"招商银行"];
    for (NSString *name  in array) {
        if ([name isEqualToString:bankName]) {
            flag = YES;
            break;
        }
    }
    
    if (flag ) {
        return YES;
    }
    if ((NSNull *)branName == [NSNull null])
    {
        branName = @"";
    }
    
    if (!flag && [branName length] <  1) {
        flag = NO;
    }
    return YES;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavLeftBut:NSPushMode];
    [self setNavTitle:@"账户余额"];
    _notification= [NSNotification notificationWithName:@"changePagePosition" object:self userInfo:nil];

    if (self.intoStatus != 1) {
        [self clickRechargeBut];
    }
    
    
    startLine                                     = 1;
    oldLine                                       = 1;
    limitLine                                     = 15;
    self.tableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
    if ([self respondsToSelector: @selector(setEdgesForExtendedLayout:)] ) {
        self.edgesForExtendedLayout                   = UIRectEdgeNone;
    }
    
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    
    if (cacheModel.accountModel.accountDetailModel.accountDetailArray != nil) {
        _hotAddArray = cacheModel.accountModel.accountDetailModel.accountDetailArray;
    }
    else{
        _hotAddArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    //个人信息
    _privateUserInfo = [[PrivateUserInfo alloc]init];
//    [self setCellHeigth:60];
//    [self setCellClassString:NSStringFromClass([MoneyDetailCell class])];
//    [self setCellDisplayData:_hotAddArray];
//    [self setHeaderArray:[NSArray arrayWithObjects:@"收支明细", nil]];
    [self initHeaderView];
    
    
}

- (void)initHeaderView
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 180)];
    
    UIView *moneyView = [[UIView alloc] initWithFrame:CGRectMake(0, 4, view.frame.size.width,74)];
    moneyView.backgroundColor = K_COLOR_CUSTEM(248, 248, 248, 1);
    [view addSubview:moneyView];
    
    UILabel *availableLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, moneyView.frame.size.width/2-20, 14)];
    [availableLabel setTextColor:[UIColor grayColor]];
    [availableLabel setText:@"可提现余额"];
    [availableLabel setFont:[UIFont systemFontOfSize:12]];
    [moneyView addSubview:availableLabel];
    
    UILabel *freezeLabel = [[UILabel alloc] initWithFrame:CGRectMake(availableLabel.frame.origin.x+availableLabel.frame.size.width, availableLabel.frame.origin.y, availableLabel.frame.size.width , availableLabel.frame.size.height)];
    [freezeLabel setTextColor:[UIColor grayColor]];
    [freezeLabel setText:@"冻结保证金"];
    [freezeLabel setFont:availableLabel.font];
    [moneyView addSubview:freezeLabel];
    
    _avMoneyLabel = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(availableLabel.frame.origin.x, availableLabel.frame.origin.y+availableLabel.frame.size.height+2, availableLabel.frame.size.width, 30)];
    [moneyView addSubview:_avMoneyLabel];
    
    _freezeMoneyLabel = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(freezeLabel.frame.origin.x, freezeLabel.frame.origin.y+freezeLabel.frame.size.height+2, freezeLabel.frame.size.width, 30)];
    [_freezeMoneyLabel setFont:[UIFont systemFontOfSize:18]];
    _freezeMoneyLabel.text = @"0.00 元";
    [_freezeMoneyLabel setTextColor:[UIColor colorWithHexString:@"373635"]];
    [_freezeMoneyLabel setTextColor:[UIColor colorWithHexString:@"999999"] range:[_freezeMoneyLabel.text rangeOfString:@"元"]];
    [_freezeMoneyLabel setFont:[UIFont systemFontOfSize:12] range:[_freezeMoneyLabel.text rangeOfString:@"元"]];
    [moneyView addSubview:_freezeMoneyLabel];
    
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    
    if (cacheModel.accountModel.accountDetailModel.drawMoney != nil) {
        _avMoneyLabel.text = cacheModel.accountModel.accountDetailModel.drawMoney;
    }
    
    if (cacheModel.accountModel.accountDetailModel.freezeMoney != nil) {
        _freezeMoneyLabel.text = cacheModel.accountModel.accountDetailModel.freezeMoney;
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, moneyView.frame.size.height-1, moneyView.frame.size.width, 1)];
    [line setBackgroundColor:K_COLOR_CUSTEM(191, 191, 191, 1)];
    [moneyView addSubview:line];
    
    UIView *butView = [[UIView alloc] initWithFrame:CGRectMake(0, moneyView.frame.origin.y+moneyView.frame.size.height, moneyView.frame.size.width,68)];
    butView.backgroundColor = K_COLOR_CUSTEM(248, 248, 248, 1);
    [view addSubview:butView];
    
    _drawMoneyBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawMoneyBut setFrame:CGRectMake(20, 10, (butView.frame.size.width-50)/2, 40)];
    [_drawMoneyBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_drawMoneyBut setTitle:@"提现" forState:UIControlStateNormal];
    _drawMoneyBut.layer.cornerRadius = 5;
    [_drawMoneyBut.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_drawMoneyBut setBackgroundColor:[UIColor colorWithHexString:@"fe4300"]];
    _drawMoneyBut.enabled = YES;

//    if (_avMoneyLabel.text != nil && _avMoneyLabel.text.length>0 && [_avMoneyLabel.text floatValue]>=10) {
//        [_drawMoneyBut setBackgroundColor:[UIColor colorWithHexString:@"fe4300"]];
//        _drawMoneyBut.enabled = YES;
//    }else{
//        [_drawMoneyBut setBackgroundColor:[UIColor colorWithHexString:@"6e6e6e"]];
//        _drawMoneyBut.enabled = NO;
//    }
    
    [_drawMoneyBut addTarget:self action:@selector(clickDrawMoneyBut) forControlEvents:UIControlEventTouchUpInside];
    [butView addSubview:_drawMoneyBut];
    
    UIButton *rechargeBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [rechargeBut setFrame:CGRectMake(_drawMoneyBut.frame.origin.x+_drawMoneyBut.frame.size.width+10, _drawMoneyBut.frame.origin.y, _drawMoneyBut.frame.size.width, _drawMoneyBut.frame.size.height)];
    [rechargeBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rechargeBut setTitle:@"充值" forState:UIControlStateNormal];
    rechargeBut.layer.cornerRadius = 5;
    [rechargeBut.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rechargeBut setBackgroundColor:[UIColor colorWithHexString:@"fe4300"]];
    [butView addSubview:rechargeBut];
    
    rechargeBut.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self clickRechargeBut];
        return [RACSignal empty];
    }];
    
    UIView * sectionHeaderView                    = [[UIView alloc] init];
    sectionHeaderView.backgroundColor             = K_COLOR_CUSTEM(248, 248, 248, 1);
    sectionHeaderView.frame                       = CGRectMake(0, butView.frame.size.height+butView.frame.origin.y+5, ScreenWidth, 30);
    
    UILabel * upListLab                           = [[UILabel alloc] initWithFrame:CGRectMake(0, 9,self.view.frame.size.width ,17)];
    upListLab.text                                = @"收支明细";
    upListLab.font                                = [UIFont systemFontOfSize:11];
    upListLab.textAlignment                       = NSTextAlignmentCenter;
    upListLab.textColor                           = SUBCOLOR;
    [sectionHeaderView addSubview:upListLab];
    
    UIView  *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 28, ScreenWidth, 1)];
    lineView.backgroundColor = RGBCOLOR(191, 191, 191);
    [sectionHeaderView addSubview:lineView];
    
    [view addSubview:sectionHeaderView];
    
    [self.view addSubview:view];
    
    [self initTalbeViewWithYPoint:view.frame.origin.y+view.frame.size.height];
}

//充值
- (void)clickRechargeBut
{
//    //选择充值方式
    ChooseChargeWayController *chooseVC = [[ChooseChargeWayController alloc]init];
    chooseVC.infoStatus = self.intoStatus;
    if (self.intoStatus != 1) {
        [self.navigationController pushViewController:chooseVC animated:NO];
    }
    else{
        [self.navigationController pushViewController:chooseVC animated:YES];
    }
//    [self authMobile];
}

#pragma mark - 提款
- (void)clickDrawMoneyBut
{
    //判断用户当天提现次数是否<2,小于2继续登录密码认证，否则弹出对话框提示用户当天提现次数已到达上限
//    [self requestTodayTixianNum];//调用判断用户当天提现次数的接口
    [self checkLoginPassWord];//继续登录密码认证的流程
}

#pragma mark - UITableViewDelegate

- (void)initTalbeViewWithYPoint:(float)aYPoint{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, aYPoint, ScreenWidth, ScreenHeigth-64-aYPoint) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = K_COLOR_CUSTEM(225, 225, 225, 0.2);
    [self.view addSubview:self.tableView];
    
    [self initRefresh];
}
#pragma mark - textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (!textField.window.isKeyWindow) {
        [textField.window makeKeyAndVisible];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_hotAddArray == nil) {
        return 0;
    }
    return _hotAddArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoneyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[MoneyDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    [cell setDict:_hotAddArray[indexPath.row]];
    
    if (indexPath.row == 0) {
        cell.lineLabel.hidden = YES;
    }
    else{
        cell.lineLabel.hidden = NO;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark Refresh

-(void)initRefresh{
    
    MoneyDetaillViewController *moneyVC = self;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        startLine = 1;
        [moneyVC requestURLData:NO];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [moneyVC requestURLData:YES];
    }];
    
    
}

-(void)endLoading{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

@end
