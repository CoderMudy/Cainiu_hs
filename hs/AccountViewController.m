//
//  AccountViewController.m
//  hs
//
//  Created by RGZ on 16/4/19.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "AccountViewController.h"
#import "SettingViewController.h"
#import "AccountViewCell.h"
#import "PersonInfoPage.h"
#import "RegViewController.h"
#import "AccountH5Page.h"
#import "AccountRechargeViewController.h"
#import "SubmitViewController.h"
#import "BankCardViewController.h"
#import "RealNameViewController.h"
#import "CouponsPage.h"
#import "UserPointViewController.h"
#import "PersionInfoViewController.h"


@interface AccountViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray         *_titleArray;
    NSArray         *_imageArray;
    NSMutableArray  *_detailArray;
    PrivateUserInfo *_privateUserInfo;
    NSString        *_usedMoney;//可用余额
    NSString        *_freezeMoney;//冻结资金
    int             _userCouponsNum;//优惠券数量
    NSString        *_integral;
}

typedef NS_ENUM(NSInteger, ActionType) {
    AtcionTypeDrawMoney = 0,
    ActionTypeRechargeMoney,
};
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AccountViewController

#define Color_drawmoney  [UIColor colorWithRed:235/255.0 green:200/255.0 blue:144/255.0 alpha:1]

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadDefaultData];
    [self loadTableViewConfiger];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self loadTableHeaderView];
    if ([CMStoreManager sharedInstance].isLogin) {
        [self getUseMoney];
        [self getUseUserCoupons];
    }
    else{
        [self loadDefaultData];
        [self.tableView reloadData];
    }
}

-(void)loadTableViewConfiger{
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = K_color_line;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)loadDefaultData{
    _titleArray = @[@"总积分",@"抵用券",@"收支明细"];
    _imageArray = @[@"Account_totalintegral",@"Account_coupon",@"Account_detail"];
    _detailArray = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    _usedMoney = @"0.00";
    _freezeMoney = @"0";
    _userCouponsNum = 0;
    _integral = @"0";
}

#pragma mark Header

-(void)loadTableHeaderView{
    if ([CMStoreManager sharedInstance].isLogin) {
        self.tableView.tableHeaderView = [self logInHeaderView];
    }
    else{
        self.tableView.tableHeaderView = [self logOutHeaderView];
    }
}


//显示登录UI
-(UIView *)logOutHeaderView{
    UIView *bgView = [[UIView    alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 120.0/667.0*ScreenHeigth)];
    
    UILabel *titleLabel = [[UILabel  alloc]initWithFrame:CGRectMake(20, 20/667.0*ScreenHeigth, bgView.frame.size.width - 40, (bgView.frame.size.height - 40/667.0*ScreenHeigth)/2 )];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text =  @"金融社交平台，只为更简单";
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [UIColor redColor];
    [bgView addSubview:titleLabel];
    
    UIButton    *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(20, CGRectGetMaxY(titleLabel.frame) + 5, (bgView.frame.size.width)/2 - 7 - 20, titleLabel.frame.size.height - 5);
    loginButton.backgroundColor = Color_drawmoney;
    loginButton.clipsToBounds = YES;
    loginButton.layer.cornerRadius = 3;
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:loginButton];
    
    UIButton    *registeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registeButton.frame = CGRectMake(CGRectGetMaxX(loginButton.frame) + 14, loginButton.frame.origin.y, loginButton.frame.size.width, loginButton.frame.size.height);
    registeButton.backgroundColor = [UIColor redColor];
    registeButton.clipsToBounds = YES;
    registeButton.layer.cornerRadius = 3;
    [registeButton setTitle:@"注册" forState:UIControlStateNormal];
    registeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [registeButton addTarget:self action:@selector(registeClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:registeButton];
    
    return bgView;
}

-(void)loginClick{
    LoginViewController * logVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:logVC animated:YES];
}

-(void)registeClick{
    RegViewController * regVC = [[RegViewController alloc] init];
    [self.navigationController pushViewController:regVC animated:YES];
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
}

#define userHeaderbounds 65/667.0*ScreenHeigth
UIImageView *_userHeaderImgV;
UIImageView *_headerEditImgV;
UIButton    *_userHeaderBtn;
UIButton    *_userNickBtn;
UILabel     *_canUsemoneyLabel;
UILabel     *_unUseMoneyLabel;

//登录成功UI
-(UIView *)logInHeaderView{
    UIView *bgView = [[UIView    alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 240/667.0*ScreenHeigth)];
    
    _userHeaderImgV = [[UIImageView alloc] init];
    _userHeaderImgV.center = CGPointMake(ScreenWidth/2, 45.0*ScreenHeigth/667);
    _userHeaderImgV.bounds = CGRectMake(0, 0, userHeaderbounds, userHeaderbounds);
    _userHeaderImgV.userInteractionEnabled = YES;
    [Helper imageCutView:_userHeaderImgV cornerRadius:userHeaderbounds/2 borderWidth:2 color:[UIColor whiteColor]];
    [bgView addSubview:_userHeaderImgV];
    
    _headerEditImgV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderImgV.frame)-17*ScreenWidth/375, CGRectGetMinY(_userHeaderImgV.frame)+1, 14*ScreenWidth/375, 14*ScreenWidth/375)];
    _headerEditImgV.image = [UIImage imageNamed:@"Account_pen"];
    _headerEditImgV.userInteractionEnabled = YES;
    [bgView addSubview:_headerEditImgV];
    
    _userHeaderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _userHeaderBtn.center = _userHeaderImgV.center;
    _userHeaderBtn.bounds = _userHeaderImgV.bounds;
    [_userHeaderBtn addTarget:self action:@selector(persionInfoClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_userHeaderBtn];
    
    _userNickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _userNickBtn.center = CGPointMake(ScreenWidth/2, CGRectGetMaxY(_userHeaderImgV.frame)+10/667.0*ScreenHeigth);
    _userNickBtn.bounds = CGRectMake(0, 0, ScreenWidth-60, 20/667.0*ScreenHeigth);
    [_userNickBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_userNickBtn.titleLabel setFont:FontSize(14)];
    [_userNickBtn addTarget:self action:@selector(persionInfoClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_userNickBtn];
    
    [_userHeaderImgV setImage:[[CMStoreManager sharedInstance] getUserHeader]];
    [_userNickBtn setTitle:[[CMStoreManager sharedInstance]getUserNick] forState:UIControlStateNormal];
    
    UILabel *moneyProLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_userNickBtn.frame) + 20/667.0*ScreenHeigth, 70, 15/667.0*ScreenHeigth)];
    moneyProLabel.text = @"可用余额";
    moneyProLabel.font = [UIFont systemFontOfSize:13];
    moneyProLabel.center = CGPointMake(ScreenWidth/2, moneyProLabel.center.y);
    moneyProLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:moneyProLabel];
    
    _canUsemoneyLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(moneyProLabel.frame), ScreenWidth, 25/667.0*ScreenHeigth)];
    _canUsemoneyLabel.textAlignment = NSTextAlignmentCenter;
    _canUsemoneyLabel.textColor = [UIColor redColor];
    if (_usedMoney.length > 3) {
        _canUsemoneyLabel.text = [NSString stringWithFormat:@"￥%@",[DataEngine addSign:_usedMoney pointNum:2]];
    }
    else{
        _canUsemoneyLabel.text = [NSString stringWithFormat:@"￥%@",_usedMoney];
    }
    _canUsemoneyLabel.font = [UIFont systemFontOfSize:20];
    [bgView addSubview:_canUsemoneyLabel];
    
    
    _unUseMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_canUsemoneyLabel.frame), ScreenWidth, 15/667.0*ScreenHeigth)];
    _unUseMoneyLabel.textAlignment = NSTextAlignmentCenter;
    _unUseMoneyLabel.textColor = [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1];
    _unUseMoneyLabel.text = [NSString stringWithFormat:@"冻结金额(%@)",_freezeMoney];
    _unUseMoneyLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:_unUseMoneyLabel];
    
    
    UIButton    *rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rechargeButton.frame = CGRectMake(20, bgView.frame.size.height - 10/667.0*ScreenHeigth - 35/667.0*ScreenHeigth, (bgView.frame.size.width)/2 - 7 - 20, 35/667.0*ScreenHeigth);
    rechargeButton.backgroundColor = [UIColor redColor];
    rechargeButton.clipsToBounds = YES;
    rechargeButton.layer.cornerRadius = 3;
    [rechargeButton setImage:[UIImage imageNamed:@"Account_recharge"] forState:UIControlStateNormal];
    [rechargeButton setTitle:@" 充值" forState:UIControlStateNormal];
    rechargeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rechargeButton addTarget:self action:@selector(rechargeClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:rechargeButton];
    
    UIButton    *drawMoneyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    drawMoneyButton.frame = CGRectMake(CGRectGetMaxX(rechargeButton.frame) + 14, rechargeButton.frame.origin.y, rechargeButton.frame.size.width, rechargeButton.frame.size.height);
    drawMoneyButton.backgroundColor = [UIColor whiteColor];
    drawMoneyButton.clipsToBounds = YES;
    drawMoneyButton.layer.cornerRadius = 3;
    drawMoneyButton.layer.borderWidth = 1;
    drawMoneyButton.layer.borderColor = Color_drawmoney.CGColor;
    [drawMoneyButton setImage:[UIImage imageNamed:@"Account_drawmoney"] forState:UIControlStateNormal];
    [drawMoneyButton setTitle:@" 提现" forState:UIControlStateNormal];
    drawMoneyButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [drawMoneyButton setTitleColor:Color_drawmoney forState:UIControlStateNormal];
    [drawMoneyButton addTarget:self action:@selector(drawMoneyClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:drawMoneyButton];
    
    return bgView;
}

#pragma mark 个人资料
-(void)persionInfoClick{
    [self goPersionInfo];
}

- (void)goPersionInfo
{
//    PersonInfoPage *persionVC=[[PersonInfoPage alloc]init];
//    [self.navigationController pushViewController:persionVC animated:YES];
    
    PersionInfoViewController *persionVC=[[PersionInfoViewController alloc]init];
    [self.navigationController pushViewController:persionVC animated:YES];
}

#pragma mark 充值/提现

-(void)rechargeClick{
    AccountH5Page *h5 = [[AccountH5Page alloc]init];
    h5.url = [NSString stringWithFormat:@"http://%@/account/banks.html?type=original",HTTP_IP];
    h5.isHaveToken = YES;
    [self.navigationController pushViewController:h5 animated:YES];
}

- (void)drawMoneyClick
{
    [self checkLoginPassWord];//继续登录密码认证的流程
}

//弹出验证登录密码的警告框
- (void)checkLoginPassWord
{
    __block PopUpView * inputAlertView = [[PopUpView alloc] initInpuStyleAlertWithTitle:@"验证登录密码" setInputItemArray:@[@"请输入登录密码"] setBtnTitleArray:@[@"取消",@"验证"]];
    inputAlertView.twoObjectblock = ^(UIButton *button,NSArray*array)
    {
        if (button.tag==66666)
        {
            [inputAlertView removeFromSuperview];
            inputAlertView = nil;
            
        }else{
            NSString * passWord = [NSString stringWithFormat:@"%@",array[0]];
            if ([passWord isEqualToString:@""])
            {
                [UIEngine showShadowPrompt:@"密码不能为空"];
            }else if(passWord.length<6)
            {
                [UIEngine showShadowPrompt:@"密码位数不能小于6位"];
            }else
            {
                [self clickCheckpassWord:passWord];
                [inputAlertView removeFromSuperview];
            }
        }
    };
    [self.navigationController.view addSubview:inputAlertView];
}

#pragma mark 获取账户信息
#pragma mark 获取可用余额

//可用余额
-(void)getUseMoney
{
    //获取可用余额
    [DataEngine requestToGetAllMoneyWithComplete:^(BOOL SUCCESS, NSMutableArray *infoArray) {
        if (SUCCESS) {
            //账户可用余额
            _usedMoney = [NSString stringWithFormat:@"%.2f",[infoArray[2] doubleValue]];
            //积分
            [_detailArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%.0f",[infoArray[1] floatValue]]];
            _integral = [NSString stringWithFormat:@"%.0f",[infoArray[1] floatValue]];
            //冻结金额
            _freezeMoney = [NSString stringWithFormat:@"%.2f",[infoArray[5] doubleValue]];
            //刷新表
            [self loadTableHeaderView];
            [self.tableView reloadData];
        }
        else
        {
            if(infoArray != nil && infoArray.count>0){
                [UIEngine showShadowPrompt:infoArray[0]];
            }else
            
            [self.tableView reloadData];
        }
    }];
}
#pragma mark 获取优惠券数量

- (void)getUseUserCoupons
{
    [RequestDataModel requestCouponsNumSuccessBlock:^(BOOL success, int couponsNum) {
        if (success) {
            _userCouponsNum = couponsNum;
            [_detailArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"可用%d张",couponsNum]];
            [_tableView reloadData];
        }
    }];
}


#pragma mark 验证登录密码
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
                    //                    rechargePage.intoStatus = self.intoStatus;
                    rechargePage.bankCard = dictionary[@"data"][@"bankNum"];
                    [self.navigationController pushViewController:rechargePage animated:YES];
                }
                if (type ==  AtcionTypeDrawMoney) {
                    SubmitViewController *submitPage = [[SubmitViewController alloc] init];
                    submitPage.bankName = (NSString *)dictionary[@"data"][@"bankName"] ;
                    submitPage.bankCard = (NSString *)dictionary[@"data"][@"bankNum"] ;
                    submitPage.branName = (NSString *)dictionary[@"data"][@"branName"] ;
                    submitPage.cityName = (NSString *)dictionary[@"data"][@"cityName"] ;
                    submitPage.provName = (NSString *)dictionary[@"data"][@"provName"] ;
                    submitPage.ID = dictionary[@"data"][@"id"] ;
                    submitPage.usedMoney = _usedMoney;
                    submitPage.privateUserInfo = _privateUserInfo;
                    [self.navigationController pushViewController:submitPage animated:YES];
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
                {};
                [self.navigationController pushViewController:bankVC animated:YES];
            }
        }else{
            [[UIEngine sharedInstance] hideProgress];
            [[[iToast makeText:[dictionary objectForKey:@"msg"]] setGravity:iToastGravityCenter] show];
        }
    } failureBlock:^(NSError *error) {
        [[UIEngine sharedInstance] hideProgress];
    }];
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

- (void)sendNotification
{
    NSNotification *notification= [NSNotification notificationWithName:@"changePagePosition" object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
}
- (void)resetDefault
{
    [[CMStoreManager sharedInstance]exitLoginClearUserData];
}

//验证真实姓名
-(void)authRealName:(int)type
{
    _privateUserInfo = [[PrivateUserInfo alloc] init];
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

#pragma mark Table Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView  *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    if (section != _titleArray.count) {
        view.backgroundColor = Color_lightGray;
    }
    else{
        view.backgroundColor = [UIColor whiteColor];
    }
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AccountViewCell *cell = [[AccountViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.titleLabel.text = _titleArray[indexPath.section];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_imageArray[indexPath.section]]];
    cell.backgroundColor = [UIColor whiteColor];
    cell.titleLabel.font = [UIFont systemFontOfSize:15];
    cell.detailLabel.text = _detailArray[indexPath.section];
    
    HeaderDividers;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([CMStoreManager sharedInstance].isLogin) {
        switch (indexPath.section) {
            case 0:
            {
                UserPointViewController *userPoint = [[UserPointViewController alloc] init];
                userPoint.userScore = _integral;
                [self.navigationController pushViewController:userPoint animated:YES];
            }
                break;
            case 1:
            {
                CouponsPage *couponPage = [[CouponsPage alloc]init];
                couponPage.couponsNum = (int)_userCouponsNum;
                [self.navigationController pushViewController:couponPage animated:YES];
            }
                break;
            case 2:
            {
                AccountH5Page *h5DetailVC = [[AccountH5Page alloc]init];
                h5DetailVC.url = [NSString stringWithFormat:@"http://%@/account/detail.html?type=original",HTTP_IP];
                h5DetailVC.isHaveToken = YES;
                [self.navigationController pushViewController:h5DetailVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    else{
        [self loginClick];
    }
}

- (IBAction)settingClick:(UIButton *)sender {
    NSString * isStaff = [[CMStoreManager sharedInstance] getUserIsStaff];
    __block SettingViewController *settingVC=[[SettingViewController alloc]init];
    settingVC.gologinBlock = ^(){
        [self loginClick];
    };
    //判断当前应用的类型 1销售系统  0财牛应用
    if (AppStyle_SAlE) {
        settingVC.userStyle = 0;
        [self.navigationController pushViewController:settingVC animated:YES];
        return;
    }
    if (isStaff) {
        settingVC.userStyle = [isStaff isEqualToString:@"0"]?0:[isStaff intValue];
        [self.navigationController pushViewController:settingVC animated:YES];
        
    }else{
        [ManagerHUD showHUD:self.view animated:YES];
        [RequestDataModel requestUserPowerSuccessBlock:^(BOOL success, int userPower) {
            [ManagerHUD hidenHUD];
            settingVC.userStyle =userPower;
            [self.navigationController pushViewController:settingVC animated:YES];
        }];
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
