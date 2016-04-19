//
//  PositionViewController.m
//  hs
//
//  Created by PXJ on 15/4/28.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import "PositionViewController.h"
#import "PositionTableViewCell.h"
#import "PersonPositionDataModels.h"
#import "StockDetailViewController.h"
#import "TopPositionView.h"
#import "SearchViewController.h"
#import "LoginViewController.h"
#import "NetRequest.h"
#import "Helper.h"

#import "h5DataCenterMgr.h"



#define K_SELF_BOUNDS self.view.bounds.size

@interface PositionViewController ()<UITableViewDataSource,UITableViewDelegate,ISessionReady>
{
    UITableView * _tableView;
    TopPositionView * _positionView;
    BOOL  _haveOrder;
    PersonPositionBaseClass * _personBaseClassModel;
    NSArray * _dataArray;
    
    H5DataCenter * _dataCenter;
    NSString * _odid;
    
}
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backAdImageView;

@end

@implementation PositionViewController

-(void)updateUI:(BOOL)bhide
{
//    [self.view addSubview:_backAdImageView];
//    [self.view addSubview:_loginBtn];
    _backAdImageView.hidden = bhide;
    _loginBtn.hidden        = bhide;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = NO;

    _dataCenter.h5Session = nil;
    [HsSessionManager destroySession:SESSION_KEY];
    [self createSession];
    _dataCenter = [h5DataCenterMgr sharedInstance].dataCenter;
    
    [self getData];
    
    if ([[CMStoreManager sharedInstance] isLogin])
    {
        [self updateUI:YES];
        
//        [self.loginBtn removeFromSuperview];
//        [self.backAdImageView removeFromSuperview];
    }else{
        [_tableView removeFromSuperview];
        _tableView = nil;
        _loginBtn.layer.cornerRadius = 5;
        _loginBtn.layer.masksToBounds = YES;
//        [self.view addSubview:_backAdImageView];
//        [self.view addSubview:_loginBtn];
        
        [self updateUI:NO];
        
    }
}

- (void)initUI
{
    _positionView = [[TopPositionView alloc] initWithFrame:CGRectMake(0, 0, K_SELF_BOUNDS.width, 224)];
    [self.view addSubview:_positionView];
    
    [_positionView.searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    if ( _personBaseClassModel.data.totalCashProfit > 0) {
        _positionView.backView.image = [UIImage imageNamed:@"Background_08"];
    }else{
        _positionView.backView.image = [UIImage imageNamed:@"Background_09"];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = K_COLOR_CUSTEM(225, 225, 225, 1);
    _tableView.tableHeaderView = _positionView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_tableView];
}

- (void)getData
{
    NSString * token = [[CMStoreManager sharedInstance] getUserToken];
    NSDictionary * dic = @{@"version":@"0.1"};
    NSString * urlStr = [NSString stringWithFormat:@"http://121.40.85.43:19084/stock-task/redis/stockposi?token=%@",token];
    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
        
        if([dictionary[@"code"] intValue]==200){
            
            _personBaseClassModel  = [PersonPositionBaseClass modelObjectWithDictionary:dictionary];
            
            _dataArray = _personBaseClassModel.data.posiBoList;
            [_tableView reloadData];
            
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        
    }];
    
}
//搜索
- (void)search
{
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    searchVC.dataCenter = _dataCenter;
    [self.navigationController pushViewController:searchVC animated:YES];
}
- (IBAction)goLogIn:(id)sender {
    
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector: @selector(setEdgesForExtendedLayout:)] ) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataArray = [NSArray array];
    
    [self initUI];
}

<<<<<<< .mine
=======
-(void)createSession
{
    //首先使用工程类创建（获取）指定id的session
    _h5Session = [HsSessionManager createSession:SESSION_KEY];
    
    //指定代理类
    _h5Session.delegate = self;
    HsNetworkAddr *addr = [[HsNetworkAddr alloc] init];
    addr.serverIP   = H5SERVERIP;
    addr.serverPort = H5SERVERPORT;
    //配置session
    IH5SessionSettings *settings = [_h5Session getSessionSettings];
    settings.networkAddr = addr;
    //settings.host = H5SERVERIP;
    //settings.port = H5SERVERPORT;
    //初始化session
    [_h5Session initiate];
    
}
//session状态的回调处理方法
-(void)onReady:(IH5Session *)session Result:(Errors)error
{
    
    //根据session回调状态进行选择操作
    if (error == SUCCESS) {
        _dataCenter = [[H5DataCenter alloc] init];
        
        _dataCenter.h5Session = _h5Session;
       
    }
}

>>>>>>> .r15
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    PositionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PositionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    PersonPositionPosiBoList * posibolist = _dataArray[indexPath.row];
    cell.storkTitlelab.text =posibolist.stockName;
    cell.szDetailLab.text = posibolist.stockCode;
    cell.priceLab.text = [NSString stringWithFormat:@"%.2f/%.2f",posibolist.buyPrice,posibolist.curPrice];
    if (posibolist.buyType == 0) {
        cell.addLab.text = [NSString stringWithFormat:@"%@",posibolist.curCashProfit];
        
    }else{
    
        cell.addLab.text = [NSString stringWithFormat:@"%@",posibolist.curScoreProfit];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float  width = tableView.bounds.size.width;
    
    UIView * headerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
    headerView.backgroundColor = K_COLOR_CUSTEM(225, 225, 225, 0.3);
    if (YES) {
        UILabel * priceLab = [[UILabel alloc] initWithFrame:CGRectMake(width/3, 5, width/3-10, 20)];
        priceLab.font = [UIFont systemFontOfSize:12.f];
        priceLab.text = @"买入价/当前价";
        priceLab.textAlignment = NSTextAlignmentCenter;
        priceLab.textColor = [UIColor grayColor];
        [headerView addSubview:priceLab];
        
        UILabel * addLab = [[UILabel alloc] initWithFrame:CGRectMake(width*2/3, 5, width/3-10, 20)];
        addLab.font = [UIFont systemFontOfSize:12.f];
        addLab.textColor = [UIColor grayColor];
        addLab.text = @"收益";
        addLab.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:addLab];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonPositionPosiBoList * posibolist = _dataArray[indexPath.row];
    HsStock * stock = [[HsStock alloc] init];
    stock.stockName = posibolist.stockName==nil?@"":posibolist.stockName;
    stock.stockCode = posibolist.stockCode==nil?@"":posibolist.stockCode;
    stock.codeType = posibolist.stockCodeType==nil?@"":posibolist.stockCodeType;
    
        StockDetailViewController * stockDetailVC = [[StockDetailViewController alloc] init];
        stockDetailVC.stock = stock;
        stockDetailVC.isbuy = YES;
        stockDetailVC.dataCenter = _dataCenter;
    stockDetailVC.odid =[NSString stringWithFormat:@"%f", posibolist.orderId];
        [self.navigationController pushViewController:stockDetailVC animated:YES];
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
