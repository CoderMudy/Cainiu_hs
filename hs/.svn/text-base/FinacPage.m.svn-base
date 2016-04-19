//
//  FinacPage.m
//  hs
//
//  Created by 杨永刚 on 15/5/12.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "FInacTableViewCell.h"
#import "FinacPage.h"
#import "HotViewController.h"
#import "StockTypePage.h"
#import "OthersPositionPage.h"
#import "SearchViewController.h"
#import "StockDetailViewController.h"
#import "NetRequest.h"
#import "HotListDataModels.h"
#import "TodayView.h"
#import "h5DataCenterMgr.h"
#import "MJRefresh.h"

@interface FinacPage ()<UITableViewDelegate,UITableViewDataSource>
{
    H5DataCenter * _dataCenter;
    HotListBaseClass * _hotListBaseModel;
    NSArray * _todayListArray;
    NSMutableArray * _hotAddArray;
    NSMutableArray * _hotLoadAddArray;
    UIView *_progressView;
    NSDate * _loadTime;
    int startLine;
    int limitLine;
    
    UIImageView * _loadImg;
    NSTimer * _loadTimer;
    UILabel * _amtLab;
    UIImageView * _amtImg;
    UILabel * _amtValueLab;
    
    
    UILabel * _profitLab;
    UIImageView * _profitImg;
    UILabel * _profitValueLab;
    
    
}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)CALayer * mylayer;

@end

@implementation FinacPage


//-(instancetype)initWithStyle:(UITableViewStyle)style
//{
//    self                                          = [super initWithStyle:UITableViewStylePlain];
//    if (self) {
//        
//    }
//    return self;
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"融资购买首页"];
    
    UIView * tabbarLine = [self.rdv_tabBarController.view viewWithTag:55555];
    [tabbarLine removeFromSuperview];
    


    
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    if (cacheModel.financeIndex==nil) {
        
        PageFinanceModel * financeIndex = [[PageFinanceModel alloc] init];
        cacheModel.financeIndex = financeIndex;
        
    }
    cacheModel.financeIndex.hotArray =[NSMutableArray arrayWithArray:_todayListArray] ;
//    cacheModel.financeIndex.earnListArray = [NSMutableArray arrayWithArray:_hotAddArray];
    [CacheEngine setCacheInfo:cacheModel];
    self.rdv_tabBarController.tabBarHidden = YES;
   
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"融资购买首页"];
    
    [self requesTodaylead];
    self.navigationController.navigationBarHidden = NO;
    self.rdv_tabBarController.tabBarHidden        = NO;
    self.automaticallyAdjustsScrollViewInsets     = NO;
    startLine                                     = 1;
    [self requestURLData:NO];
    
    if (self.tableView.header.subviews.count<=0) {
        [self initPullRefreshView];
        
    }
    
    UIView  * view = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeigth-49, ScreenWidth, 0.5)];
    view.backgroundColor = K_COLOR_CUSTEM(200, 200, 200, 1);
    view.tag = 55555;
    [self.rdv_tabBarController.view addSubview:view];
}

#pragma mark - 初始化刷新View
- (void)initPullRefreshView
{
    MJRefreshNormalHeader * tableHeaderView= [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    MJRefreshAutoNormalFooter * tableFooterView = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.header = tableHeaderView;
    _tableView.footer = tableFooterView;
    
    
    
    
}
#pragma mark - 请求今日领涨板块数据
- (void)requesTodaylead
{
    _dataCenter                                   = [h5DataCenterMgr sharedInstance].dataCenter;
    // 请求板块数据按涨幅排序
    [_dataCenter loadBlocks:@"XBHS.HY"
                       From:0
                      Count:3
            withHandleBlock:^(id result)
     {
         if ((NSNull*)result != [NSNull null] && result != nil&&result!=NULL )
         {
             _todayListArray = (NSArray*)result;
             [self loadTodayData];
             
     }
         
       
     }];
}

#pragma mark -  刷新今日领涨板块数据
- (void)loadTodayData
{
    if (_todayListArray.count>0) {
        for (int i                                    = 0; i<3; i++)
        {
            TodayView * todayView                         = (TodayView *)[_progressView viewWithTag:i+1];
            NSDictionary * dic                            = _todayListArray[i];
            float num =[dic[@"nRATE"] floatValue];
            todayView.numLab.textColor                    = K_COLOR_CUSTEM(250, 67, 0, 1);
            todayView.numLab.text                         = [NSString stringWithFormat:@"+%.2f%%",num*100];
            todayView.progressView.progress               = ABS(num)*10;
            todayView.progressView.progressTintColor      = K_COLOR_CUSTEM(250, 67, 0, 1);
            if (num < 0) {
                todayView.numLab.textColor                = K_COLOR_CUSTEM(8, 186, 66, 1);
                todayView.numLab.text                     = [NSString stringWithFormat:@"%.2f%%",num*100];
                todayView.progressView.progressTintColor  = K_COLOR_CUSTEM(8, 186, 66, 1);
            }
            todayView.nameLab.text                        = dic[@"strProdName"];
        }
    }

}

#pragma mark - 获取热门收益排行数据
- (void)requestURLData:(BOOL)moreFlag
{
    //请求热门收益排行
    if (moreFlag)
    {
        startLine+= 1;
        
    }else{
        
        startLine = 1;
        
        
    }
    NSString * hotListUrl =[NSString stringWithFormat:@"%@/order/order/hotProfitRank",K_MGLASS_URL];
    NSDictionary * dic                              = @{
                                                        @"pageNo":[NSString stringWithFormat:@"%d",startLine],
                                                        @"pageSize":[NSString stringWithFormat:@"%d",limitLine],
                                                        @"version":VERSION
                                                        };
    
    __block FinacPage * safeSelf                    = self;
    [NetRequest postRequestWithNSDictionary:dic url:hotListUrl successBlock:^(NSDictionary *dictionary) {
        //                                   [ManagerHUD hidenHUD];
        [self endLoading];

        if ((NSNull*)dictionary != [NSNull null] && dictionary != nil&&dictionary!=NULL )
        {
            
        _loadTime = [NSDate date];
        
        if (moreFlag) {
            if ((NSNull*)dictionary[@"data"] != [NSNull null] && dictionary[@"data"] != nil&&dictionary[@"data"]!=NULL )
            {
                [_hotAddArray addObjectsFromArray:dictionary[@"data"]];
            }
        }else{
            if (_hotAddArray.count>0) {
                [_hotAddArray removeAllObjects];

            }
            
            if ((NSNull*)dictionary[@"data"] != [NSNull null] && dictionary[@"data"] != nil&&dictionary[@"data"]!=NULL )
            {
                [_hotAddArray addObjectsFromArray:dictionary[@"data"]];
            }
            
        }
        
        [safeSelf loadEarnListData];
            [safeSelf endLoading];
        
        }
    } failureBlock:^(NSError *error) {
        
        
        [self endLoading];
    }];
}

- (void)loadEarnListData
{
    NSMutableArray * array = [NSMutableArray array];


    for (NSDictionary * dic in _hotAddArray) {
        
        
        NSMutableDictionary * mutableDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        NSString * timeStr = [Helper timeDifferNowdate:_loadTime oldTime:mutableDic[@"buyDate"]];
        [mutableDic setValue:timeStr forKey:@"buyDate"];
        [array addObject:mutableDic];
    }
    _hotLoadAddArray = array;
    [self.tableView reloadData];



}



- (void)seach
{
    SearchViewController  *searchVC                 = [[SearchViewController alloc] init];
    searchVC.dataCenter                             = [h5DataCenterMgr sharedInstance].dataCenter;
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title                                      = @"跟买";
    [self setNavRigthBut:nil butImage:[UIImage imageNamed:@"search_01"] butHeigthImage:nil select:@selector(seach)];

    self.automaticallyAdjustsScrollViewInsets = NO;
    startLine                                       = 1;
    limitLine                                       = 20;
    
    
    _hotLoadAddArray                                = [NSMutableArray array];
    _hotAddArray                                    = [NSMutableArray array];
    _todayListArray                                 = [NSArray array];
  
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-113) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.tableView.separatorStyle                   = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = K_COLOR_CUSTEM(248, 248, 248, 1);
    
    
    [self.tableView registerClass:[FInacTableViewCell class] forCellReuseIdentifier:@"cell"];
//    [self setCellClassString:NSStringFromClass([FInacTableViewCell class])];
    [self initHeaderView];
    
    
    _loadTime = [NSDate date];

    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    if (cacheModel.financeIndex.hotArray) {
        _todayListArray = cacheModel.financeIndex.hotArray;
        [self loadTodayData];

    }
    if (cacheModel.financeIndex.earnListArray) {
        _hotAddArray = cacheModel.financeIndex.earnListArray;
        [self loadEarnListData];

    }
    

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

- (void)more
{
    HotViewController * hotVC                       = [[HotViewController alloc] init];
    [self.navigationController pushViewController:hotVC animated:YES];
}

- (void)initHeaderView
{
    
   
    _progressView                                 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 93)];
    
    
    UILabel * whiteLineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 4)];
    whiteLineLab.backgroundColor = [UIColor whiteColor];
    [_progressView addSubview:whiteLineLab];
    
    
    UILabel *titleLabel                           = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, _progressView.frame.size.width, 20)];
    [titleLabel setText:@"今日领涨板块"];
    [titleLabel setTextColor:K_COLOR_CUSTEM(55, 54, 53, 1)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    [titleLabel setBackgroundColor:K_COLOR_CUSTEM(248, 248, 248, 1)];
    [_progressView addSubview:titleLabel];
    
    UIButton *moreBut                             = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBut setFrame:CGRectMake(_progressView.frame.size.width-80, titleLabel.frame.origin.y, 80, 20)];
    [moreBut.titleLabel setTextAlignment:NSTextAlignmentRight];
    [moreBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [moreBut addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    [moreBut.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [moreBut setTitle:@"更多 >" forState:UIControlStateNormal];
    [_progressView addSubview:moreBut];
    
    UILabel * lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.frame.origin.y + titleLabel.frame.size.height, ScreenWidth, 0.5)];
    lineLab.backgroundColor = K_COLOR_CUSTEM(178, 178, 178, 1);
    [_progressView addSubview:lineLab];
    
    _progressView.backgroundColor = K_COLOR_CUSTEM(248, 248, 248, 1);
    
    for (int i                                    = 0; i<3; i++) {
        float width                                   = (self.view.bounds.size.width - 100)/3;
        TodayView * todayView                         = [[TodayView alloc] initWithFrame:CGRectMake(30 +i*(width +20) , 32, width, _progressView.bounds.size.height)];
        todayView.tag                                 = i+1;
        
        UIButton * button                             = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame                                  = todayView.frame;
        button.tag                                    = (i+1)*100;
        
        button.backgroundColor                        = [UIColor clearColor];
        [button addTarget:self action:@selector(goStockType:) forControlEvents:UIControlEventTouchUpInside];
        
        [_progressView addSubview:todayView];
        [_progressView addSubview:button];
        
    }
    self.tableView.tableHeaderView  = _progressView;
    
}

- (void)goStockType:(UIButton*)btn
{
    if (_todayListArray.count>0) {
        
        int tag                                       = (int)btn.tag;
        NSDictionary * dic                            = _todayListArray[tag/100-1];
        
        StockTypePage * VC                            = [[StockTypePage alloc] init];
        VC.stocktypeDic                               = dic;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    int row                                       = (int)indexPath.row;
    if (_hotAddArray[row]) {
        
        OthersPositionPage * otherVC                  = [[OthersPositionPage alloc] init];
        ELData * orderList                       =  [ELData modelObjectWithDictionary:_hotAddArray[row]];
        otherVC.elDataModel                           = orderList;
        [self.navigationController pushViewController:otherVC animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _hotAddArray.count;

}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FInacTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary * dic = _hotLoadAddArray[indexPath.row];
    
    [cell setDict:dic];
    
    
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 34;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 90;
    
    
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] init];
    headerView.backgroundColor = K_COLOR_CUSTEM(248, 248, 248, 1);
    UILabel * lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 4)];
    lineLab.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:lineLab];
    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 17, ScreenWidth, 14)];
    titleLab.text = @"最新收益排行";
    titleLab.textColor = K_COLOR_CUSTEM(55, 54, 53, 1);
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLab];
    
    UILabel  *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 33, ScreenWidth, 1)];
    [lineLabel setBackgroundColor:RGBCOLOR(191, 191, 191)];
    [headerView addSubview:lineLabel];
    
    
    
    return headerView;
}


- (void)loadMoreData
{
    [self requestURLData:YES];
}

- (void)refreshData
{
    MJRefreshNormalHeader * view =(MJRefreshNormalHeader * )_tableView.header;
    
    view.arrowView.hidden = YES;

    _loadTimer=[NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(startAnimation) userInfo:nil repeats:YES];
    [_loadTimer fire];

    [self requesTodaylead];
    
    startLine     = 1;
    [self requestURLData:NO];
}

-(void)endLoading{
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
    if (_loadTimer) {
        [_loadTimer invalidate];
        
    }
}


- (void)startAnimation
{

    static double angle = 0;
    if(angle>=360)
    {
        angle=0;
    }
    angle+=2;
    
    _loadImg.transform =CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
}
@end
