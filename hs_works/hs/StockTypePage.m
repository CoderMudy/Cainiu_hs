//
//  StockTypePage.m
//  hs
//
//  Created by PXJ on 15/5/14.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "StockTypePage.h"
#import "h5DataCenterMgr.h"
#import "StockTypeCell.h"
#import "SearchViewController.h"
#import "StockDetailViewController.h"
#import "StockTypeHeaderView.h"
#import "MJRefresh.h"

@interface StockTypePage ()<UITableViewDataSource,UITableViewDelegate>
{
    H5DataCenter * _dataCenter;
    NSMutableArray * _stockListArray;
    
    UILabel * _linelab;
    int _orderType;
    
    int _startLine;
    int _limitLine;
}
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation StockTypePage
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"板块个股"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"板块个股"];
     _startLine = 0;
    _limitLine = 15;
    [self getlistData:nil];
    
    self.navigationController.navigationBarHidden = NO;
    self.rdv_tabBarController.tabBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //请求热门收益排行
}

- (void)setNavTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 165,44)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:NavigationTitleFont];
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = title;
    self.navigationItem.titleView = label;
}

- (void)setNavLeftBut
{
    UIImage *leftButtonImage = [UIImage imageNamed:@"return_1.png"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, leftButtonImage.size.width, leftButtonImage.size.height)];
    [leftButton setBackgroundImage:leftButtonImage forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"return_2.png"] forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchDown];
    [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    leftButton.titleLabel.shadowColor = RGBACOLOR(117,38,0,1.0f);
    leftButton.titleLabel.shadowOffset= CGSizeMake(0, -1);
    leftButton.titleLabel.textColor = [UIColor whiteColor];
    UIBarButtonItem *leftbtn =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbtn;
}
- (void)setNavRigthBut:(NSString *)titleStr butImage:(UIImage *)butImage butHeigthImage:(UIImage *)heigtLigthImage select:(SEL)selector
{
    UIButton *rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBut.titleLabel setFont:[UIFont systemFontOfSize:14]];
    CGSize strSize = [titleStr sizeWithAttributes: @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}];
    [rightBut setFrame:CGRectMake(0, 0, strSize.width+10, 30)];
    if(butImage)[rightBut setFrame:CGRectMake(0, 0, butImage.size.width, butImage.size.height)];
    if(butImage)[rightBut setImage:butImage forState:UIControlStateNormal];
    if(heigtLigthImage)[rightBut setImage:heigtLigthImage forState:UIControlStateHighlighted];
    if(titleStr)[rightBut setTitle:titleStr forState:UIControlStateNormal];
    [rightBut addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBut];
}

- (void)leftButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestURLData:(BOOL)moreFlag orderType:(int)orderType
{
//    if (_limitLine==0&&moreFlag) {
//        [self loadMoreFinish];
//
//        return;
//    }

    [ManagerHUD showHUD:self.navigationController.view animated:YES andAutoHide:3];

    HsStock * stock = [[HsStock alloc] init];
    stock.stockCode = _stocktypeDic[@"strProdCode"];
    stock.codeType =_stocktypeDic[@"strTypeCode"];
    stock.stockName = _stocktypeDic[@"strProdName"];
 __block StockTypePage * safeSelf = self;

    [_dataCenter loadBlocksStocks4Sort:stock
                                  From:_startLine
                                 Count:_limitLine
                             orderType:_orderType
                       withHandleBlock:^(id result) {
                           [ManagerHUD hidenHUD];

                           [safeSelf endLoading];
                           if (moreFlag) {
                               
                               
                               
                               if ((NSNull*)result != [NSNull null] && result != nil&&result!=NULL )
                               {
                                   [_stockListArray addObjectsFromArray:result];
                               }

                               if (_stockListArray.count <_limitLine+_startLine) {
                                   _limitLine = 0;
                               }
                               _startLine = _startLine +_limitLine;

                           }else{
                               
                               if ((NSNull*)result != [NSNull null] && result != nil&&result!=NULL )
                               {
                                   [_stockListArray removeAllObjects];
                                   
                                   [_stockListArray addObjectsFromArray:result];                               }
                               
                               
                               if (_stockListArray.count <_limitLine) {
                                   _limitLine = 0;
                               }
                               _startLine = _startLine +_limitLine;

                           }
                           [_tableView reloadData];
                      }
     ];

}


- (void)getlistData:(id)sender
{
    
    _dataCenter = [h5DataCenterMgr sharedInstance].dataCenter;

    if (sender) {
        
        UIButton * btn = (UIButton * )sender;
        int tag = (int)btn.tag;
        [btn setTitleColor:K_COLOR_CUSTEM(153, 153, 153, 1)  forState:UIControlStateNormal];
        
        _orderType = (tag -100);
        
    }else
    {
        
        _orderType = 1;
        
    }    // 请求板块数据按涨幅排序
    _startLine = 0;
    _limitLine = 20;
    [self requestURLData:NO orderType:_orderType];
        _linelab.frame = CGRectMake(self.view.frame.size.width/2*(1-_orderType), 28, self.view.frame.size.width/2, 2);
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self setNavLeftBut];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavTitle:[self.stocktypeDic objectForKey:@"strProdName"]];
    
    _stockListArray = [[NSMutableArray alloc] initWithCapacity:0];
    _orderType = 1;
    _startLine = 0;
    _limitLine = 20;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = K_COLOR_CUSTEM(248, 248, 248, 1);
    [self.tableView registerClass:[StockTypeCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    [self initRefresh];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavRigthBut:nil butImage:[UIImage imageNamed:@"search_01"] butHeigthImage:nil select:@selector(seach)];
    
    
    StockTypeHeaderView * headerView = [[StockTypeHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    [headerView setStockTypeViewValue:_stocktypeDic];
    
    self.tableView.tableHeaderView = headerView;
    

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 48;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 30;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _stockListArray.count;


}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    StockTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell setDict:_stockListArray[indexPath.row]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = (int)indexPath.row;
    
     HsStock * stock = [[HsStock alloc] init];
    stock.stockCode = _stockListArray[row][@"strProdCode"];
    stock.codeType =_stockListArray[row][@"strTypeCode"];
    stock.stockName = _stockListArray[row][@"strProdName"];
    
    StockDetailViewController * VC = [[StockDetailViewController alloc] init];
//    VC.dataCenter = [h5DataCenterMgr sharedInstance].dataCenter;
    VC.stock = stock;
    VC.isbuy = NO;
    VC.source = @"hotList";

    [self.navigationController pushViewController:VC animated:YES];
    
}
- (UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIButton * upListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [upListBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    upListBtn.frame =CGRectMake(0, 10,headerView.frame.size.width/2 ,17);
    upListBtn.tag = 101;
    [upListBtn setTitleColor:K_COLOR_CUSTEM(55, 54, 53, 1) forState:UIControlStateNormal];
    [upListBtn setTitle:@"领涨" forState:UIControlStateNormal];
    [upListBtn addTarget:self action:@selector(getlistData:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:upListBtn];
    
    UIButton * downListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [downListBtn setTitleColor:K_COLOR_CUSTEM(153, 153, 153, 1) forState:UIControlStateNormal];
    [downListBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    downListBtn.frame =CGRectMake(headerView.frame.size.width/2, 10,headerView.frame.size.width/2 ,17);
    downListBtn.tag = 100;
    [downListBtn setTitle:@"领跌" forState:UIControlStateNormal];
    [downListBtn addTarget:self action:@selector(getlistData:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:downListBtn];
    
    
    _linelab = [[UILabel alloc] init ];
    _linelab.frame = CGRectMake(self.view.frame.size.width/2*(1-_orderType), 28, self.view.frame.size.width/2, 2);
    _linelab.backgroundColor = K_COLOR_CUSTEM(250, 67, 0, 1);
    [headerView addSubview:_linelab];
    return headerView;
}

- (void)seach
{
    SearchViewController  *searchVC = [[SearchViewController alloc] init];
    searchVC.dataCenter = _dataCenter;
    [self.navigationController pushViewController:searchVC animated:YES];
    
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



#pragma mark Refresh

-(void)initRefresh{
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    
}


-(void)endLoading{
    
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
    
}

- (void)loadMoreData
{
    
    [self requestURLData:YES orderType:_orderType];

    
    
}


- (void)refreshData
{
    _startLine = 0;
    _limitLine = 20;
    [self requestURLData:NO orderType:_orderType];
}

@end
