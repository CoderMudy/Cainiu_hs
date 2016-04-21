//
//  FoyerScorePage.m
//  hs
//
//  Created by PXJ on 16/1/15.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "FoyerScorePage.h"
#import "IndexViewController.h"
#import "PositionViewController.h"
#import "LoginAndRegistView.h"
#import "RegViewController.h"
#import "LoginViewController.h"
#import "UserPointViewController.h"
#import "FoyerScoreCell.h"
#define ScoreTitle_Font 10
#define Score_Font 24
#define logAndRigView_Tag 20000
#define tableView_Tag 20001

@interface FoyerScorePage ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * _productDataArray;
    
    NSString * _IP;
    NSString * _port;
    NSMutableArray * _positionNumArray;
    NSMutableArray * _positionCashNumArray;
    NSString * _enableScore;
    NSString * _curCashScore;
    NSTimer * _dataTimer;
}
@end

@implementation FoyerScorePage

- (void)dealloc
{
    _IP = nil;
    _port = nil;
    _positionCashNumArray = nil;
    _positionNumArray = nil;
    _enableScore = nil;
    _curCashScore = nil;
    [_dataTimer invalidate];
    _dataTimer = nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self requestProductData];
    if ([[CMStoreManager sharedInstance] isLogin]) {
        [self getpositionNum];
        [self requestCainiuUserScore];
        [self updateUI:YES];
    }else{
        [self updateUI:NO];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.rdv_tabBarController.tabBarHidden = NO;
    [_dataTimer invalidate];
    _dataTimer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initNav];
    [self initUI];
    [self initLoginView];
}
- (void)initData
{
    _productDataArray = [NSMutableArray array];
    _enableScore = @"0";
    _curCashScore = @"0";
}
- (void)initNav
{
    NavView * navView = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    navView.titleLab.text = @"模拟练习场";
    [navView.leftControl addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navView.rightControl addTarget:self action:@selector(rightControl) forControlEvents:UIControlEventTouchUpInside];
    navView.rightLab.text = @"商城";
    UIImageView * rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(navView.rightLab.frame)+27, 41-17/2.0, 20, 17)];
    rightImg.image = [UIImage imageNamed:@"foyer_7"];
    [navView addSubview:rightImg];
    
    [self.view addSubview:navView];
}
- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64) style:UITableViewStyleGrouped];
    tableView.tag = tableView_Tag;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.bounces = NO;
    [tableView registerClass:[FoyerScoreCell class] forCellReuseIdentifier:@"scoreCell"];
    [self.view addSubview:tableView];
}
- (void)initLoginView
{
    __weak typeof(self) weakSelf = self;

    UIView * logRegView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth)];
    logRegView.tag = logAndRigView_Tag;
    [logRegView setBackgroundColor:RGBACOLOR(0, 0, 0, 0.5)];
    [self.view addSubview:logRegView];
    LoginAndRegistView * unloginStartView = [[LoginAndRegistView alloc] initWithFrame:CGRectMake(20, 75*ScreenHeigth/667, ScreenWidth - 40, ScreenHeigth - 172*ScreenHeigth/667 - 55*ScreenHeigth/667)];
    unloginStartView.backgroundColor = [UIColor clearColor];
    unloginStartView.userInteractionEnabled = YES;
    [unloginStartView.loginBtn setTitleColor:K_COLOR_CUSTEM(210, 210, 210, 1) forState:UIControlStateNormal];
    
    unloginStartView.block = ^(UIButton * btn){
        if (btn.tag==20001) {
            [weakSelf logBtnClick:nil];
        }else{
            
            [weakSelf regBtnClick:nil];
        }
    };
    [logRegView addSubview:unloginStartView];
}

#pragma mark 控制未登录页面的显示
-(void )updateUI:(BOOL)bhide
{
    UIView * logRegView = [self.view viewWithTag:logAndRigView_Tag];
    logRegView.hidden = bhide;
}
#pragma mark 刷新tableView
- (void)reloadTableView
{
    UITableView * tableView  = (UITableView *)[self.view viewWithTag:tableView_Tag];
    [tableView reloadData];
}
#pragma mark 点击事件
- (void)logBtnClick:(id)sender {
    LoginViewController * logVC = [[LoginViewController alloc] init];
    logVC.isBackLastPage = YES;
    [self.navigationController pushViewController:logVC animated:YES];
    //    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
    
}

- (void)regBtnClick:(id)sender {
    RegViewController * regVC = [[RegViewController alloc] init];
    [self.navigationController pushViewController:regVC animated:YES];
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
}

- (void)goScorePage
{
    UserPointViewController *userPoint = [[UserPointViewController alloc] init];
    userPoint.userScore = [_enableScore isEqualToString:@"0"]?@"0":_enableScore;
    [self.navigationController pushViewController:userPoint animated:YES];
    
}
-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightControl
{
    [UIEngine showShadowPrompt:@"更多功能暂未开放，敬请期待"];
}
#pragma mark 请求__积分产品列表
- (void)requestProductData
{        __weak typeof(self) weakSelf = self;

    [RequestDataModel requestProductDataWithType:@"2" SuccessBlock:^(BOOL success, NSMutableArray *mutableArray)
     {
         if (success) {
             [_productDataArray removeAllObjects];
             for (NSDictionary * dictionary in mutableArray) {
                 FoyerProductModel * productModel = [FoyerProductModel productModelWithDictionary:dictionary];
                 [_productDataArray addObject:productModel];
             }
             _dataTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:weakSelf selector:@selector(reloadTableView) userInfo:nil repeats:YES];
             [_dataTimer fire];
             
         }else{
         }
     }];
}
#pragma mark - 获取用户持仓订单数量
- (void)getpositionNum{
    if ([[CMStoreManager sharedInstance] isLogin]) {
        
        __weak typeof(self) weakSelf = self;
        [RequestDataModel requestPosiOrderNum:NO successBlock:^(BOOL success, NSArray *dataArray) {
            if (dataArray.count>0) {
                _positionNumArray = [NSMutableArray arrayWithArray:dataArray];
            }else{
            }
            [weakSelf reloadTableView];
        }];
        
        
        if (![[SpotgoodsAccount sharedInstance] isNeedLogin])//南交所用户登录后需要请求现货持仓数量
        {
            [RequestDataModel requestPosiOrderNum:YES successBlock:^(BOOL success, NSArray *dataArray)
             {
                 if (dataArray.count>0) {
                     _positionCashNumArray = [NSMutableArray arrayWithArray:dataArray];
                 }else{
                 }
                 [weakSelf reloadTableView];
             }];
        }
    }
}
#pragma mark -请求用户积分
- (void)requestCainiuUserScore
{
    __weak typeof(self) weakSelf = self;

    [DataEngine requestToGetAllMoneyWithComplete:^(BOOL success, NSMutableArray *scoreArray) {
        if (success)
        {
            _enableScore = [NSString stringWithFormat:@"%d",[scoreArray[1] intValue]];
            _curCashScore = [NSString stringWithFormat:@"%d",[scoreArray[4] intValue]];
        }
        [weakSelf reloadTableView];
    }];
}

- (BOOL)isPositionWithProductModel:(FoyerProductModel*)productModel
{
    BOOL isPosition=NO;

    if ([productModel.marketCode rangeOfString:@"SRPME"].location != NSNotFound )
    {
        for (NSDictionary * dic in _positionCashNumArray)
        {
            if ([dic[@"instrumentCode"] rangeOfString:productModel.instrumentCode].location !=NSNotFound)
            {
                float num                   = [dic[@"score"]intValue];
                if (num>0) {
                    isPosition = YES;
                }
                break;
            }
        }
    }else {
        for (NSDictionary * dic in _positionNumArray)
        {
            if ([dic[@"instrumentCode"] rangeOfString:productModel.instrumentCode].location !=NSNotFound)
            {
                float num                   = [dic[@"score"]intValue];
                if (num>0)
                {
                    isPosition = YES;
                }
                break;
            }
        }
    }
    return isPosition;
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;

    FoyerScoreCell * cell = [tableView dequeueReusableCellWithIdentifier:@"scoreCell" forIndexPath:indexPath];
    cell.controlBlock = ^(UIControl * control){
        switch (control.tag) {
            case 1111:
            {
                FoyerProductModel * productModel = _productDataArray[indexPath.row*2];
                [weakSelf getClickEnableWithProductModel:productModel indexPath:indexPath];
            }
                break;
            case 1112:
            {
                if (_productDataArray.count%2==1&&indexPath.row==_productDataArray.count/2) {
                    return ;
                }else
                {
                    FoyerProductModel * productModel = _productDataArray[indexPath.row*2+1];
                    [weakSelf getClickEnableWithProductModel:productModel indexPath:indexPath];
                }
            }
                break;
            default:
                break;
        }
        
    };
    cell.positionImg.hidden = YES;
    cell.positionImg_D.hidden = YES;
    if (_productDataArray.count%2==1&&indexPath.row==_productDataArray.count/2) {
        FoyerProductModel * productModel =_productDataArray[indexPath.row*2];
        cell.positionImg.hidden = ![self isPositionWithProductModel:productModel];
        cell.spreateLine.hidden = NO;
        cell.spreateLine_D.hidden = YES;
        cell.arrowImg.hidden = NO;
        cell.arrowImg_D.hidden = YES;
        [cell setCellWithProductArray:@[productModel]];
    }else {
        FoyerProductModel * productModel =_productDataArray[indexPath.row*2];
        FoyerProductModel * productModel_D =_productDataArray[indexPath.row*2+1];
        cell.positionImg.hidden = ![self isPositionWithProductModel:productModel];
        cell.positionImg_D.hidden = ![self isPositionWithProductModel:productModel_D];
        [cell setCellWithProductArray:@[productModel,productModel_D]];
        cell.spreateLine.hidden = NO;
        cell.spreateLine_D.hidden = NO;
        cell.arrowImg.hidden = NO;
        cell.arrowImg_D.hidden = NO;
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_productDataArray.count%2==0) {
        return _productDataArray.count/2;
    }else{
        return _productDataArray.count/2+1;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 105;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 105)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel * usefulLab = [[UILabel alloc] init];
    usefulLab.center = CGPointMake(ScreenWidth/2+5, 32);
    
    UIButton * usefulScore = [UIButton buttonWithType:UIButtonTypeCustom];
    usefulScore.center = CGPointMake(ScreenWidth/2, 32);
    usefulScore.bounds = CGRectMake(0, 0, ScreenWidth/2, 20);
    
    [usefulScore setTitle:@" 可用积分" forState:UIControlStateNormal];
    [usefulScore setImage:[UIImage imageNamed:@"foyer_14"] forState:UIControlStateNormal];
    [usefulScore.titleLabel setFont:FontSize(ScoreTitle_Font)];
    [usefulScore setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [headerView addSubview:usefulScore];
    
    UILabel * scoreLab = [[UILabel alloc] init];
    scoreLab.center = CGPointMake(ScreenWidth/2, 55);
    scoreLab.bounds = CGRectMake(0, 0, ScreenWidth, 30);
    scoreLab.font = FontSize(Score_Font);
    scoreLab.text = [_enableScore isEqualToString:@"0"]?@"0":[Helper addSign:_enableScore num:0];
    scoreLab.textAlignment = NSTextAlignmentCenter;
    scoreLab.textColor = K_color_red;
    [headerView addSubview:scoreLab];
    
    
    UILabel *  freezeScoreLab = [[UILabel alloc] init];
    freezeScoreLab.center = CGPointMake(ScreenWidth/2, 78);
    freezeScoreLab.bounds = CGRectMake(0, 0, ScreenWidth, 15);
    freezeScoreLab.font = FontSize(ScoreTitle_Font);
    freezeScoreLab.text = [NSString stringWithFormat:@"冻结积分（%@）", [_curCashScore isEqualToString:@"0"]?@"0":[Helper addSign:_curCashScore num:0]];
    freezeScoreLab.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:freezeScoreLab];
    
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 104, ScreenWidth, 1)];
    line.backgroundColor = K_color_lightGray;
    [headerView addSubview:line];
    
    UIControl * headerControl = [[UIControl alloc] init];
    headerControl.center = scoreLab.center;
    headerControl.bounds = CGRectMake(0, 0, ScreenWidth/2, 100);
    [headerControl addTarget:self action:@selector(goScorePage) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:headerControl];
    return headerView;
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [ManagerHUD showHUD:self.view  animated:YES andAutoHide:10];
//    FoyerProductModel * productModel = _productDataArray[indexPath.row];
//    [self getClickEnableWithProductModel:productModel indexPath:indexPath];
// 
//}

- (void)getClickEnableWithProductModel:(FoyerProductModel * )productModel indexPath:(NSIndexPath *)indexPath
{
    [ManagerHUD showHUD:self.view  animated:YES andAutoHide:10];
    
    if (productModel.vendibility.intValue==0) {
        [ManagerHUD hidenHUD];
        [ManagerHUD hidenHUD];
        PopUpView * popVIew = [[PopUpView alloc] initShowAlertWithShowText:@"敬请期待" setBtnTitleArray:@[@"确定"]];
        popVIew.confirmClick = ^(UIButton * button){
            
        };
        [self.navigationController.view addSubview:popVIew];
    }else{
        if ([productModel.commodityName rangeOfString:@"股票"].location !=NSNotFound)
        {
            [ManagerHUD hidenHUD];
            PositionViewController * positionVC = [[PositionViewController alloc] init];
            [self.navigationController pushViewController:positionVC animated:YES];
        }else
        {
            [self getIPWithProductModel:productModel];
        }
    }
}

- (void)getIPWithProductModel:(FoyerProductModel*)productModel;
{
    __weak typeof(self) weakSelf = self;

    [DataEngine requestToGetIPAndPortWithBlock:^(BOOL success, NSString * IP, NSString *Port)
     {
         [ManagerHUD hidenHUD];
         _IP = IP;
         _port = Port;
         BOOL isPosition = NO;
         if ([productModel.marketCode rangeOfString:@"SRPME"].location != NSNotFound )
         {
             for (NSDictionary * dic in _positionCashNumArray)
             {
                 if ([dic[@"instrumentCode"] rangeOfString:productModel.instrumentCode].location !=NSNotFound)
                 {
                     float num               = [dic[@"score"]intValue];
                     if (num>0)
                     {
                         isPosition          = YES;
                     }
                     break;
                 }
             }
         }else
         {
             for (NSDictionary * dic in _positionNumArray)
             {
                 if ([dic[@"instrumentCode"] rangeOfString:productModel.instrumentCode].location !=NSNotFound)
                 {
                     float num               = [dic[@"score"]intValue];
                     if (num>0)
                     {
                         isPosition          = YES;
                     }
                     break;
                 }
             }
         }
         IndexViewController * indexVC   = [[IndexViewController alloc] init];
         indexVC.ip                      = IP;
         indexVC.port                    = Port;
         indexVC.name                    = productModel.commodityName;
         indexVC.code                    = productModel.instrumentID;
         indexVC.isPosition              = isPosition;
         indexVC.productModel            = productModel;
         [weakSelf.navigationController pushViewController:indexVC animated:YES];
     }];
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
