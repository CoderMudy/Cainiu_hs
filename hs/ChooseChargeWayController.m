//
//  ChooseChargeWayController.m
//  hs
//
//  Created by RGZ on 15/7/3.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "ChooseChargeWayController.h"
#import "ChooseWayCell.h"
#import "MobileBindViewController.h"
#import "RealNameViewController.h"
#import "NetRequest.h"
#import "AccountRechargeViewController.h"
#import "SubmitViewController.h"
#import "BankCardViewController.h"
#import "AliPayViewController.h"
#import "TransferMoneyViewController.h"
#import "CMStoreManager.h"

@interface ChooseChargeWayController ()
{
    PrivateUserInfo   *_privateUserInfo;
    int             _rechargeWay;
    NSMutableArray  *imageNameArray;
    
    NSMutableArray  *detailInfoArray;
}


@property (nonatomic,strong)UITableView *tableView;

@end

@implementation ChooseChargeWayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadNav];
    
    [self loadData];
    
    [self loadUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark Nav

-(void)loadNav{
    
    [self setNaviTitle:@"账户充值"];
    [self setNavibarBackGroundColor:K_color_NavColor];
    [self setBackButton];
}

-(void)loadUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64)];
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    [self.view addSubview:self.tableView];
    
    //当数据很少在表格里显示不全的时候，去掉表格下面还显示的线条
    UIView *va = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:va];
}

#pragma mark Data

-(void)loadData{
//    imageNameArray = [NSMutableArray arrayWithObjects:@"",@"", nil];
//    detailInfoArray = [NSMutableArray arrayWithObjects:@"0手续费，安全便捷",@"0手续费，安全便捷", nil];
    
    if(AppStyle_SAlE)
    {
    
        detailInfoArray = [@[
                             @{@"name":@"支付宝",@"detail":@"手机支付, 免手续费",@"imageName":@"way_alipay"},
                             @{@"name":@"转账汇款",@"detail":@"资金安全有保障",@"imageName":@"way_transfer"},
//                             @{@"name":@"易联支付",@"detail":@"资金安全有保障",@"imageName":@"way_transfer"},
                             ]mutableCopy];
    }else{
        //是否开启支付宝支付
        if ([[ControlCenter sharedInstance] isShowAlipay])
        {
            detailInfoArray = [@[
                                 @{@"name":@"支付宝",@"detail":@"手机支付, 免手续费",@"imageName":@"way_alipay"},
                                 @{@"name":@"银行卡支付",@"detail":@"无需开通网银",@"imageName":@"way_bank"},
                                 @{@"name":@"转账汇款",@"detail":@"资金安全有保障",@"imageName":@"way_transfer"},
//                                 @{@"name":@"易联支付",@"detail":@"资金安全有保障",@"imageName":@"way_transfer"},
                                 ]mutableCopy];
        }else
        {
            detailInfoArray = [@[
                                 @{@"name":@"银行卡支付",@"detail":@"无需开通网银",@"imageName":@"way_bank"},
                                 @{@"name":@"转账汇款",@"detail":@"资金安全有保障",@"imageName":@"way_transfer"},
//                                 @{@"name":@"易联支付",@"detail":@"资金安全有保障",@"imageName":@"way_transfer"},
                                 ]mutableCopy];
        }
    }

}

#pragma mark UITableView


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return detailInfoArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 106;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleIdentify = @"SimpleIdentify";
    
    ChooseWayCell *cell = (ChooseWayCell *)[tableView dequeueReusableCellWithIdentifier:simpleIdentify];
    if (!cell) {
        cell = [[ChooseWayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleIdentify];
    }
    
    NSDictionary *dic = [detailInfoArray objectAtIndex:indexPath.row];
    [cell fillWithWayData:dic];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([[ControlCenter sharedInstance] isShowAlipay]) {
        switch (indexPath.row) {
            case 0:[self goAlipay];
                break;
            case 1:[self goBankCardPay];
                break;
            case 2:[self goChangePay];
                break;
            case 3:[self goYiLian];
            default:
                break;
        }
    }
    else{
        switch (indexPath.row) {
            case 0:[self goBankCardPay];
                break;
            case 1:[self goChangePay];
                break;
            case 2:[self goYiLian];
            default:
                break;
        }
    }


}
/**
 *  支付宝
 */
-(void)goAlipay{
    //_rechargeWay = 1;
    AliPayViewController *alipayCtrl = [[AliPayViewController alloc]init];
    [self.navigationController pushViewController:alipayCtrl animated:YES];
}
/**
 *  银行卡支付
 */
-(void)goBankCardPay{
    if (AppStyle_SAlE) {
        //_rechargeWay = 2;
        TransferMoneyViewController *tranCtrl = [[TransferMoneyViewController alloc]init];
        [self.navigationController pushViewController:tranCtrl animated:YES];
        
    }else{
        
        //银行卡支付
        //_rechargeWay = 2;
        [self authMobile];
        
    }
}
/**
 *  转账汇款
 */
-(void)goChangePay{
    //转账汇款
    //_rechargeWay = 2;
    TransferMoneyViewController *tranCtrl = [[TransferMoneyViewController alloc]init];
    [self.navigationController pushViewController:tranCtrl animated:YES];
}

/**
 *  易联支付
 */
-(void)goYiLian{
    NSLog(@"易联支付");
}

//验证银行卡
-(void)authBankCard
{
    [DataEngine requestToAuthbindOfBankWithComplete:^(BOOL SUCCESS, NSString * status, NSString * bankName, NSString * bankCard) {
        if (SUCCESS) {
            if ([status isEqualToString:@"1"]||[status isEqualToString:@"2"]) {
                
                _privateUserInfo.statusBankCardBind=status;
                _privateUserInfo.bankCard=bankCard;
                _privateUserInfo.bankName=bankName;
                
            }
            else
            {
                _privateUserInfo.statusBankCardBind = @"0";
            }
            
            
            //缓存
            CacheModel *cacheModel = [CacheEngine getCacheInfo];
            cacheModel.accountModel.accountIndexModel.privateUserInfo.statusBankCardBind = _privateUserInfo.statusBankCardBind;
            cacheModel.accountModel.accountIndexModel.privateUserInfo.bankCard = _privateUserInfo.bankCard;
            cacheModel.accountModel.accountIndexModel.privateUserInfo.bankName = _privateUserInfo.bankName;
            [CacheEngine setCacheInfo:cacheModel];
            
        }
        else
        {
            if (status.length>0) {
                [UIEngine showShadowPrompt:status];
            }
        }
    }];
}

//验证手机号
//验证手机号
-(void)authMobile
{
    [DataEngine requestToAuthbindOfMobileWithComplete:^(BOOL SUCCESS, NSString * status, NSString * tel) {
        if (SUCCESS) {
            if ([status isEqualToString:@"1"]||[status isEqualToString:@"2"]) {
                //                [self authRealName:ActionTypeRechargeMoney];
                AccountRechargeViewController * accountVC = [[AccountRechargeViewController alloc] init];
                accountVC.rechargeWay = 1;
                accountVC.intoStatus = _infoStatus;
                [self.navigationController pushViewController:accountVC animated:YES];
            }
            else
            {
                [[UIEngine sharedInstance] hideProgress];
                [[UIEngine sharedInstance] showAlertWithTitle:@"为了您账户的安全，请先绑定手机号" ButtonNumber:2 FirstButtonTitle:@"取消" SecondButtonTitle:@"绑定手机"];
                [UIEngine sharedInstance].alertClick = ^(int aIndex)
                {
                    if (aIndex == 10087) {
                        MobileBindViewController *mobileVC = [[MobileBindViewController alloc]init];
                        mobileVC.privateUserInfo = _privateUserInfo;
                        mobileVC.isCharge = YES;
                        mobileVC.block = ^(PrivateUserInfo *privateUserInfo){};
                        [self.navigationController pushViewController:mobileVC animated:YES];
                    }
                };
            }
        }
        else
        {
            [[UIEngine sharedInstance] hideProgress];
            if (status.length>0) {
                [UIEngine showShadowPrompt:status];
            }
        }
    }];
}

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
                [self.navigationController pushViewController:realVC animated:YES];
            }
        }
        else
        {
            [[UIEngine sharedInstance] hideProgress];
            if (status.length>0) {
                [UIEngine showShadowPrompt:status];
            }
        }
    }];
}

//验证银行卡
-(void)authBankCard:(ActionType)type
{
    AccountRechargeViewController *rechargePage = [[AccountRechargeViewController alloc] init];
    [rechargePage setNavLeftBut:NSPushMode];
    rechargePage.rechargeWay = _rechargeWay;
    [self.navigationController pushViewController:rechargePage animated:YES];

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
