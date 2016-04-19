//
//  HotViewController.m
//  hs
//
//  Created by PXJ on 15/5/13.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "HotViewController.h"
#import "h5DataCenterMgr.h"
#import "SearchViewController.h"
#import "HotTableViewCell.h"
#import "StockTypePage.h"
#import "SSView.h"
#import "QwCNStockInfoView.h"
#import "RealTimeStockModel.h"
#import "MJRefresh.h"
#import "StockDetailViewController.h"

@interface HotViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    H5DataCenter * _dataCenter;
    NSMutableArray * _hotListArray;
    SSView * _szView;
    SSView * _shView;
    
    int startLine;
    int limitLine;
    
    RealTimeStockModel * _realtimeSH;
    RealTimeStockModel * _realtimeSZ;
}
@property (nonatomic,strong)UITableView * tableView;

@end

@implementation HotViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"行业板块主页"];
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"行业板块主页"];
//     NSLog(@"hotviewcontroller viewWillAppear");
    
    _dataCenter = [h5DataCenterMgr sharedInstance].dataCenter;
    
    // 请求板块数据按涨幅排序
     startLine = 0;
    [self requestURLData:NO];
    
    self.navigationController.navigationBarHidden = NO;
    self.rdv_tabBarController.tabBarHidden = YES;
    //请求热门收益排行
    //上证指数、深圳指数获取、板块数据、股票数据
    HsStock *stockSH = [[HsStock alloc] init];
    stockSH.stockCode = @"1A0001";//上证指数
    stockSH.codeType = @"XSHG.MRI";
    
    
    
    [_dataCenter loadRealtime:stockSH withHandleBlock:^(id result){
        if ((NSNull*)result == [NSNull null] || result == nil )
        {
            
        }else{
            HsRealtime * realTime = result;
            
            if (!_realtimeSH) {
                _realtimeSH = [[RealTimeStockModel alloc] init];
            }
            _realtimeSH.name = realTime.name;
            _realtimeSH.price = realTime.newPrice;
            _realtimeSH.priceChange = realTime.priceChange;
            _realtimeSH.priceChangePerCent = realTime.priceChangePercent;
            [_shView setViewValue:_realtimeSH];

        }
    }];
    
    //上证指数、深圳指数获取、板块数据、股票数据
    HsStock *stockSZ = [[HsStock alloc] init];
    stockSZ.stockCode = @"2A01";//深圳指数
    stockSZ.codeType = @"XSHE.MRI";
    
    [_dataCenter loadRealtime:stockSZ withHandleBlock:^(id result){
        if ((NSNull*)result == [NSNull null] || result == nil )
        {
            
        }else{
            HsRealtime * realTime = result;
            
            if (!_realtimeSZ) {
                _realtimeSZ = [[RealTimeStockModel alloc] init];
            }
            _realtimeSZ.name = realTime.name;
            _realtimeSZ.price = realTime.newPrice;
            _realtimeSZ.priceChange = realTime.priceChange;
            _realtimeSZ.priceChangePerCent = realTime.priceChangePercent;
            [_szView setViewValue:_realtimeSZ];
            
        }
    }];
}

- (void)requestURLData:(BOOL)moreFlag
{
      [ManagerHUD showHUD:self.navigationController.view animated:YES andAutoHide:3];
    __weak id safeSelf = self;
    [_dataCenter loadBlocks:@"XBHS.HY"
                       From:startLine
                      Count:limitLine
            withHandleBlock:^(id result) {
                
                [ManagerHUD hidenHUD];
                
                [safeSelf endLoading];


                startLine += limitLine;

                if (moreFlag) {
                    
                    if ((NSNull*)result != [NSNull null] && result != nil&&result!=NULL )
                    {
                        [_hotListArray addObjectsFromArray:result];
                    }

                    
                }else{
                    if ((NSNull*)result != [NSNull null] && result != nil&&result!=NULL )
                    {
                        [_hotListArray removeAllObjects];
                        [_hotListArray addObjectsFromArray:result];
                    }
                }
                [_tableView reloadData];
                
                
        }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"hotviewcontroller viewdidload");
    self.title = @"热门行业";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavLeftBut];
    [self setNavRigthBut:nil butImage:[UIImage imageNamed:@"search_01"] butHeigthImage:nil select:@selector(search)];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = K_COLOR_CUSTEM(248, 248, 248, 1);
    [_tableView registerClass:[HotTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    [self initRefresh];

    limitLine = 15;
    
    _hotListArray = [NSMutableArray array];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, ScreenWidth, 52)];
    
    imageView.image = [UIImage imageNamed:@"background_02"];
    [view addSubview:imageView];
    
    self.tableView.tableHeaderView = view;
    
    
    HotViewController * safeSelf = self;
    _shView = [[SSView alloc] initWithFrame:CGRectMake(0, 5,self.view.frame.size.width/2, 50)];
    [view addSubview:_shView];
    _shView.goDetail = ^(__strong id sender){
        
        
        HsStock *stockSH = [[HsStock alloc] init];
        stockSH.stockCode = @"1A0001";//上证指数
        stockSH.codeType = @"XSHG.MRI";
        [safeSelf goSSDetailView:stockSH];
        
        
    };
    _szView = [[SSView alloc] initWithFrame:CGRectMake(_shView.frame.origin.x+_shView.frame.size.width, 5,_shView.frame.size.width, _shView.frame.size.height)];
    _szView.goDetail = ^(__strong id sender){
        
        HsStock *stockSZ = [[HsStock alloc] init];
        stockSZ.stockCode = @"2A01";//深圳指数
        stockSZ.codeType = @"XSHE.MRI";
        
        [safeSelf goSSDetailView:stockSZ];
        
    };
    [view addSubview:_szView];
    
}

- (void)goSSDetailView:(HsStock*)stock
{
    StockDetailViewController * stockDetailVC = [[StockDetailViewController alloc] init];
    stockDetailVC.isExponent = YES;
    stockDetailVC.stock = stock;
    [self.navigationController pushViewController:stockDetailVC animated:YES];


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


- (void)search
{
    SearchViewController  *searchVC = [[SearchViewController alloc] init];
    searchVC.dataCenter = [h5DataCenterMgr sharedInstance].dataCenter;
    [self.navigationController pushViewController:searchVC animated:YES];
    
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

- (void)leftButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _hotListArray.count;

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    HotTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary * dic = _hotListArray[indexPath.row];
    [cell setDict:dic];


    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    StockTypePage * VC = [[StockTypePage alloc] init];
    VC.stocktypeDic = _hotListArray[indexPath.row];
    [self.navigationController pushViewController:VC animated:YES];
    


}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * sectionHeaderView = [[UIView alloc] init];
    sectionHeaderView.backgroundColor = [UIColor whiteColor];
    
    UILabel * upListLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-172, 10,70 ,17)];
    upListLab.text = @"涨幅榜";
    upListLab.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
    upListLab.font = [UIFont systemFontOfSize:13];
    upListLab.textAlignment = NSTextAlignmentRight;
    [sectionHeaderView addSubview:upListLab];
    
    UILabel * downListLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-92, 10, 70,17)];
    downListLab.text = @"领涨股";
    downListLab.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);

    downListLab.font = [UIFont systemFontOfSize:13];
    downListLab.textAlignment = NSTextAlignmentRight;
    [sectionHeaderView addSubview:downListLab];
    
    return sectionHeaderView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMoreData
{
    [self requestURLData:YES];
}

- (void)refreshData
{
    startLine = 0;
    [self requestURLData:NO];
}

#pragma mark Refresh

-(void)initRefresh{
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    
}


-(void)endLoading{
    
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];

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
