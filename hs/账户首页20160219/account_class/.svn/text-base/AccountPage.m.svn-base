//
//  AccountPage.m
//  hs
//
//  Created by PXJ on 16/2/19.
//  Copyright © 2016年 luckin. All rights reserved.
//
//账户主页
#define button_tag 100001
#define textLab_tag 100002
#define centerImg_tag 100003
#define sectionHeaderHeight 46
#define mainTextFont 15
#define isLogin [[CMStoreManager sharedInstance] isLogin]


#import "AccountPage.h"
#import "AccountUserView.h"
#import "LoginAndRegistView.h"
#import "RegViewController.h"
#import "SettingViewController.h"
#import "PersonInfoPage.h"
#import "AccountModel.h"
#import "AccountPageCell.h"
#import "AccountH5Page.h"
#import "UserPointViewController.h"
#import "SpotgoodsWebController.h"
#import "RegistRedBagView.h"

@interface AccountPage ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString * _userShareUrl;
    NSMutableArray * _sectionArray;
    NSInteger _tableVStyle;
}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIImageView * qRCodeImgv;
@property (nonatomic,strong)UIButton * qrBackBtn;
@property (nonatomic,strong)UIView * qrView;
@end

@implementation AccountPage

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    AccountUserView * tabHeaderView = (AccountUserView*)_tableView.tableHeaderView;
    [tabHeaderView updateUserViewWithDetail:nil];
    [self chickLogin];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getPromotionLink];
    [self initUI];
}
- (void)initUI
{
    self.view.backgroundColor = K_color_line;
    __weak typeof(self) weakSelf = self;
    AccountUserView * userHeaderView = [[AccountUserView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*200/375)];
    userHeaderView.userclickBlock = ^(UIButton * button){
        switch (button.tag) {
            case 77770://设置
            {
                [weakSelf setMessage];
            }
                break;
            case 77771://登录
            {
                [weakSelf logBtnClick:button];
            }
                break;
            case 77772://注册
            {
                [weakSelf regBtnClick:button];
            }
                break;
            case 77773://进入个人资料
            {
                [weakSelf goPersionInfoPage];
            }
                break;
            case 77774://点击二维码
            {
                [weakSelf userQRcodeShow];
            }
                break;
            default:
                break;
        }
        
        
    };
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth-50) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = RGBACOLOR(239, 239, 244, 1);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = userHeaderView;
    [self.tableView registerClass:[AccountPageCell class] forCellReuseIdentifier:@"accountCell"];
    [self.tableView registerClass:[AccountPageCell class] forCellReuseIdentifier:@"connectAccountCell"];
    
    [self.view addSubview:self.tableView];
    
}
- (void)chickLogin
{
    _sectionArray = [[NSMutableArray alloc] init];
    if (isLogin) {
        [self getUserAccout];
    }else{
        _sectionArray = [[NSMutableArray alloc] init];
        [_sectionArray  addObject:@[@{@"showName":@"开启模拟交易",@"imageName":@"accountScore",@"detail":@"华尔街风控模型"},@{@"showName":@"绑定实盘账户",@"imageName":@"accountReal",@"detail":@"可绑定期货、现货账户"}]];
        _tableVStyle = 0;
        [_tableView reloadData];
        
    }
}

- (void)getUserAccout
{
    [RequestDataModel requestUserAccountsInfoSuccessBlock:^(BOOL success, id Info) {
        NSDictionary * dic = [NSDictionary dictionaryWithDictionary:Info];
        NSLog(@"%@",dic);
        if (success) {
            [self loadUserAccountData:dic[@"data"]];
        }else{
            _tableVStyle  = 0;
            [self loadTableWithAccountArray:nil];
            
        }
    }];
}
- (void)loadUserAccountData:(NSArray *)array
{
    NSInteger simAccountNum = 0;
    NSInteger realAccountNum = 0;
    
    NSInteger unSimNum = 0;
    NSInteger unRealNum = 0;
    
    NSMutableArray * accountArray = [[NSMutableArray alloc] init];
    for (int i=0; i<array.count; i++) {
        AccountModel * model = [AccountModel accountModelWithDictionary:array[i]];
        if (model.status.integerValue ==1) {
            if (model.type.integerValue ==1) {
                realAccountNum +=1;
            }else {
                simAccountNum +=1;
            }
            [accountArray addObject:model];
        }else{
            if (model.type.integerValue ==1) {
                unRealNum +=1;
            }else{
                unSimNum +=1;
            }
        }
    }
    if (simAccountNum==0&&realAccountNum==0)
    {
        //从未开过账户
        _tableVStyle = 0;
        
    }else   if (simAccountNum>0&&realAccountNum==0)
    {
        //只有模拟，没有实盘
        _tableVStyle = 1;
    }else   if (simAccountNum==0&&unRealNum==0)
    {
        //只有实盘 实盘全部开启
        _tableVStyle = 2;
    }else   if (simAccountNum==0&&unRealNum>0)
    {
        //只有实盘 实盘没有全部开启
        _tableVStyle = 3;
    }else if (simAccountNum>0&&unRealNum==0)
    {
        //模拟实盘都有，实盘全部开启
        _tableVStyle = 4;
    }else
    {
        //模拟实盘都有，实盘部分开启
        _tableVStyle = 5;
    }
    [self loadTableWithAccountArray:accountArray];
}
- (void)loadTableWithAccountArray:(NSMutableArray *)accountArray
{
    _sectionArray = [[NSMutableArray alloc] init];
    switch (_tableVStyle) {
        case 0:
        {
            //从未开过账户
            
            [_sectionArray  addObject:@[@{@"showName":@"开启模拟交易",@"imageName":@"accountScore",@"detail":@"华尔街风控模型"},@{@"showName":@"绑定实盘账户",@"imageName":@"accountReal",@"detail":@"可绑定期货、现货账户"}]];
            [_tableView reloadData];
        }
            break;
        case 1:
        {
            //只有模拟，没有实盘
            
            [_sectionArray addObject:accountArray];
            [_sectionArray addObject:@[@{@"showName":@"绑定实盘账户",@"imageName":@"accountReal",@"detail":@"可绑定期货、现货账户"}]];
            [_tableView reloadData];
            
        }
            break;
        case 2:
        {
            //只有实盘 实盘全部开启
            [_sectionArray addObject:accountArray];
            [_sectionArray addObject:@[@{@"showName":@"开启模拟交易",@"imageName":@"accountScore",@"detail":@"华尔街风控模型"}]];
            [_tableView reloadData];
        }
            break;
        case 3:
        {
            //只有实盘 实盘没有全部开启
            [_sectionArray addObject:accountArray];
            [_sectionArray addObject:@[@{@"showName":@"开启模拟交易",@"imageName":@"accountScore",@"detail":@"华尔街风控模型"},@{@"showName":@"绑定实盘账户",@"imageName":@"accountReal",@"detail":@"可绑定期货、现货账户"}]];
            [_tableView reloadData];
            
        }
            break;
        case 4:
        {
            //模拟实盘都有，实盘全部开启
            [_sectionArray addObject:accountArray];
            [_tableView reloadData];
            
        }
            break;
        case 5:
        {
            
            //模拟实盘都有，实盘部分开启
            [_sectionArray addObject:accountArray];
            [_sectionArray addObject:@[@{@"showName":@"绑定实盘账户",@"imageName":@"accountReal",@"detail":@"可绑定期货、现货账户"}]];
            [_tableView reloadData];
            
            
        }
            
        default:
            break;
    }
    
}
#pragma mark - 获取分享链接地址
- (void)getPromotionLink
{
    [RequestDataModel requestUserQRSuccessBlock:^(BOOL success, BOOL clickStatus, NSString *msg) {
        if (success) {
            _userShareUrl = msg;
        }
    }];
    
}

#pragma mark 设置
- (void)setMessage
{
    NSString * isStaff = [[CMStoreManager sharedInstance] getUserIsStaff];
    __block SettingViewController *settingVC=[[SettingViewController alloc]init];
    settingVC.gologinBlock = ^(){
        [self logBtnClick:nil];
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
            NSLog(@"%d",userPower);
        }];
    }
}
#pragma mark 登录
- (void)logBtnClick:(id)sender {
    LoginViewController * logVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:logVC animated:YES];
    //    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
    
}
#pragma mark 注册
- (void)regBtnClick:(id)sender {
    RegViewController * regVC = [[RegViewController alloc] init];
    [self.navigationController pushViewController:regVC animated:YES];
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
}
#pragma mark 个人资料
- (void)goPersionInfoPage
{
    PersonInfoPage *persionVC=[[PersonInfoPage alloc]init];
    [self.navigationController pushViewController:persionVC animated:YES];
}
#pragma mark 二维码
- (void)userQRcodeShow
{
    [self loadZBarUI];
    if (_userShareUrl.length>0) {
        [self updateImage:YES];
    }else{
        [self updateImage:NO];
    }
}
- (void)closeQRcode
{
    //    [_qrBackBtn removeFromSuperview];
    //    [_qRCodeImgv removeFromSuperview];
    //    [[self.view viewWithTag:centerImg_tag] removeFromSuperview];
    //    [[self.view viewWithTag:button_tag] removeFromSuperview];
    //    [[self.view viewWithTag:textLab_tag] removeFromSuperview];
    [_qrView removeFromSuperview];
    
}
#pragma mark 初始化二维码的UI
- (void)loadZBarUI
{
    _qrView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
    [self.rdv_tabBarController.view addSubview:_qrView];
    _qrBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _qrBackBtn.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
    _qrBackBtn.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);
    [_qrBackBtn addTarget:self action:@selector(closeQRcode) forControlEvents:UIControlEventTouchUpInside];
    [_qrView addSubview:_qrBackBtn];
    
    _qRCodeImgv = [[UIImageView alloc]init];
    _qRCodeImgv.frame = CGRectMake(50*ScreenWidth/375, 140*ScreenWidth/375-20+64, ScreenWidth-100*ScreenWidth/375, ScreenWidth-100*ScreenWidth/375);
    [_qrView addSubview:_qRCodeImgv];
    
    CGFloat centerLength = (ScreenWidth-100*ScreenWidth/375)/4;
    UIImageView * centerImage = [[UIImageView alloc] init];
    centerImage.tag = centerImg_tag;
    centerImage.center = _qRCodeImgv.center;
    centerImage.bounds = CGRectMake(0, 0, centerLength, centerLength);
    [_qrView addSubview:centerImage];
    _qRCodeImgv.userInteractionEnabled = YES;
    
    UIButton * button = [[UIButton alloc] init ];
    button.center = _qRCodeImgv.center;
    button.bounds = CGRectMake(0, 0, 44*ScreenWidth/375, 50*ScreenWidth/375);
    button.hidden = YES;
    button.tag = button_tag;
    [button addTarget:self action:@selector(getPromotionLink) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"findPage_update"] forState:UIControlStateNormal];
    [_qrView addSubview:button];
    
    UILabel *textLab = [[UILabel alloc]init];
    textLab.frame = CGRectMake(0, _qRCodeImgv.frame.size.height+_qRCodeImgv.frame.origin.y+10, ScreenWidth, 20);
    textLab.font = [UIFont systemFontOfSize:13.0];
    textLab.tag = textLab_tag;
    textLab.textColor = [UIColor whiteColor];
    textLab.textAlignment = NSTextAlignmentCenter;
    [_qrView addSubview:textLab];
    
    
}

- (void)updateImage:(BOOL)success
{
    UIButton * button = (UIButton*)[_qrView viewWithTag:button_tag];
    UILabel * textLab = (UILabel*)[_qrView viewWithTag:textLab_tag];
    button.hidden = success;
    _qRCodeImgv.hidden = !success;
    if (success) {
        textLab.frame = CGRectMake(0, _qRCodeImgv.frame.size.height+_qRCodeImgv.frame.origin.y+10, ScreenWidth, 20);
        UIImageView * centerImg = (UIImageView*)[_qrView viewWithTag:centerImg_tag];
        centerImg.image =[UIImage imageNamed:@"findPage_14"];
        UIImage *boundImg = [Helper createNonInterpolatedUIImageFormCIImage:[Helper createQRForString:_userShareUrl] withSize:250.0f];
        _qRCodeImgv.image =boundImg;
        //        [self addImage:centerImg toImage:boundImg];
        textLab.text = @"扫一扫 马上推广赚钱";
    }else{
        textLab.frame = CGRectMake(0, button.frame.size.height+button.frame.origin.y+20, ScreenWidth, 20);
        textLab.text = @"点击重新加载";
    }
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if ((section==0&&_tableVStyle==0)||section==1) {
        return sectionHeaderHeight;
    }else{
        return 10;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==1) {
        return 10;
    }
    
    return 0.5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sectionArray[section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight;
    if (indexPath.section==0)
    {
        if (_tableVStyle==0)
        {
            rowHeight = 100* ScreenWidth/375;
        }else
        {
            rowHeight = 85* ScreenWidth/375;
        }
    }else
    {
        rowHeight = 100* ScreenWidth/375;
    }
    return rowHeight;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionHeader = [[UIView alloc] init];
    if ((section==0&&_tableVStyle==0)||section==1) {
        sectionHeader.frame = CGRectMake(0, 0, ScreenWidth, sectionHeaderHeight);
        UILabel * sectionName = [[UILabel alloc] initWithFrame:CGRectMake(15, sectionHeaderHeight/2-10, ScreenWidth-30, sectionHeaderHeight/2)];
        sectionName.text = @"关联账户";
        sectionName.textColor = K_color_grayBlack;
        sectionName.font = FontSize(mainTextFont);
        [sectionHeader addSubview:sectionName];
    }
    return sectionHeader;
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = @"accountCell";
    NSInteger cellStyle = 0;
    if (_tableVStyle==0 ||indexPath.section==1) {
        identifier  = @"connectAccountCell";
        cellStyle = 1;
    }
    
    AccountPageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (_tableVStyle==0||indexPath.section==1) {
        if (indexPath.row>0) {
            cell.separateLine.hidden = NO;
        }else{
            cell.separateLine.hidden = YES;
        }
    }
    
    if(_sectionArray.count>indexPath.section){
        NSArray * array = _sectionArray[indexPath.section];
        if (array.count >indexPath.row) {
            [cell setCellWithStyle:cellStyle cellDetail:_sectionArray[indexPath.section][indexPath.row]];

        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_tableVStyle==0||indexPath.section==1) {
        NSDictionary * dic = [NSDictionary dictionary];
        NSString * showName = @"";

        if(_sectionArray.count>indexPath.section){
            NSArray * array = _sectionArray[indexPath.section];
            if (array.count>indexPath.row) {
               dic = _sectionArray[indexPath.section][indexPath.row];
                showName =  [NSString stringWithFormat:@"%@",dic[@"showName"]];
            }
        }
        if ([showName isEqualToString:@""]) {
            return;
        }
        if (!isLogin) {
            [self logBtnClick:nil];
        }
        else if ([showName rangeOfString:@"模拟"].location !=NSNotFound) {
            
            [self openScoreAccount];
            
        }else{
            [self openRealAccount];
        }
    }else{
        AccountModel * model = [[AccountModel alloc] init];

        if(_sectionArray.count>indexPath.section){
            NSArray * array = _sectionArray[indexPath.section];
            if (array.count>indexPath.row) {
                model = _sectionArray[indexPath.section][indexPath.row];
            }
        }
        if ([model.code isEqualToString:@"score"]) {
            [self goPointPage:model];
        }else if ([model.code isEqualToString:@"cainiu"]){
            [self goCainiuPage:model];
        }else if ([model.code isEqualToString:@"nanjs"]){
            [self goXHpage:model];
        }
    }
    
    
}
//开启积分账户
- (void)openScoreAccount
{
    [RequestDataModel requestOpenScoreAccountSuccessBlock:^(BOOL success, id Info) {
        if (success) {
            //显示弹窗
            [self showRegRedBag];
        }
    }];
}
- (void)showRegRedBag
{
    RegistRedBagView * regRedView = [[RegistRedBagView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth)];
    regRedView.redBagBlock = ^(){
        [self getUserAccout];
    };
    [self.rdv_tabBarController.view  addSubview:regRedView];
}
//开启实盘账户
- (void)openRealAccount
{
    AccountH5Page  * openPage = [[AccountH5Page alloc] init];
    openPage.url = [NSString stringWithFormat:@"%@/account/bindAccount.html?abc=%@",K_MGLASS_URL,[Helper randomGet]];
    [self.navigationController pushViewController:openPage animated:YES];
}


//进入积分流水页
- (void)goPointPage:(AccountModel *)model
{
    UserPointViewController *userPoint = [[UserPointViewController alloc] init];
    userPoint.userScore = model.amt;
    [self.navigationController pushViewController:userPoint animated:YES];
}
//进入财牛账户页
- (void)goCainiuPage:(AccountModel*)model
{
    AccountH5Page  * openPage = [[AccountH5Page alloc] init];
    openPage.usedMoney = model.amt;
    openPage.url = [NSString stringWithFormat:@"%@?abc=%@",model.url,[Helper randomGet]];
    [self.navigationController pushViewController:openPage animated:YES];
}

- (void)goXHpage:(AccountModel*)model
{
  
    SpotgoodsWebController *spotgoodsController = [[SpotgoodsWebController alloc]init];
    if ([SpotgoodsAccount sharedInstance].isNeedLogin && [SpotgoodsAccount sharedInstance].isNeedRegist)
    {
        spotgoodsController.status = 2;
    }
    [self.navigationController pushViewController:spotgoodsController animated:YES];
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
