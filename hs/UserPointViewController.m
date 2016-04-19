//
//  UserPointViewController.m
//  hs
//
//  Created by 杨永刚 on 15/5/20.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "UserPointViewController.h"
#import "NetRequest.h"
#import "SDCycleScrollView.h"
#import "RecordDetailCell.h"
#import "SearchViewController.h"
#import "MJRefresh.h"
#import "RecordController.h"

@interface UserPointViewController ()
{
    NSString * _scoreValue;
    NSString * _frozenScore;
    NSMutableArray  * _scoreDataArray;
    
//    UILabel  * _scoreValueLab;
    UILabel  * _scoreLimitLab;
    UILabel  * _scoreFreeLab;
    
    int        startLine;
}

@property (nonatomic,strong)UITableView *tableView;

@end
@implementation UserPointViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"用户积分"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"用户积分"];
    self.rdv_tabBarController.tabBarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
//    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self loadInfo];

}

-(void)loadInfo{
    startLine  = 1;
    self.title = @"积分详情";
    [self setNavLeftBut:NSPushMode];
//    [self setNavRigthBut:@"股票订单" butImage:nil butHeigthImage:nil select:@selector(clickNavRigthBut)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 75)];
    headerView.backgroundColor = K_COLOR_CUSTEM(225, 225, 225, 0.3);
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
    lineView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:lineView];
    
    UILabel * scoreFreeTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 80, 15)];
    scoreFreeTitle.font = [UIFont systemFontOfSize:10];
    scoreFreeTitle.text = @"可用积分";
    scoreFreeTitle.textColor = [UIColor grayColor];
    [headerView addSubview:scoreFreeTitle];
    
    _scoreFreeLab = [[UILabel alloc] initWithFrame:CGRectMake(20, scoreFreeTitle.frame.origin.y+scoreFreeTitle.frame.size.height, ScreenWidth/2-20, 20)];
    
    _scoreFreeLab.font = [UIFont systemFontOfSize:20];
    _scoreFreeLab.text = [NSString stringWithFormat:@"%.2f", [self.userScore floatValue]];
    [headerView addSubview:_scoreFreeLab];
    
    
    
    UILabel * scoreLimitTitle = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 20, 100, 15)];
    scoreLimitTitle.font = [UIFont systemFontOfSize:10];
    scoreLimitTitle.text = @"冻结积分";
    scoreLimitTitle.textColor = [UIColor grayColor];
    [headerView addSubview:scoreLimitTitle];
    
    
    _scoreLimitLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, scoreLimitTitle.frame.origin.y+scoreLimitTitle.frame.size.height, ScreenWidth/2-20, 20)];
    _scoreLimitLab.font = [UIFont systemFontOfSize:20];
    _scoreLimitLab.text = @"0.00";
    [headerView addSubview:_scoreLimitLab];
    
    [self.view addSubview:headerView];
    
    //获取缓存
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    
    if (cacheModel.accountModel.accountIntegralModel.freezeIntegralMoney != nil) {
        _scoreLimitLab.text = cacheModel.accountModel.accountIntegralModel.freezeIntegralMoney;
    }
    
    if (cacheModel.accountModel.accountIntegralModel.integralDetailArray != nil) {
        _scoreDataArray = [NSMutableArray arrayWithArray:cacheModel.accountModel.accountIntegralModel.integralDetailArray];
    }else{
        _scoreDataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    UIView * sectionHeaderView = [[UIView alloc] init];
    sectionHeaderView.frame = CGRectMake(0, headerView.frame.size.height+headerView.frame.origin.y, ScreenWidth, 30);
    sectionHeaderView.backgroundColor = [UIColor whiteColor];
    
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth, 25)];
    backView.backgroundColor = K_COLOR_CUSTEM(248, 248, 248, 1);
    [sectionHeaderView addSubview:backView];
    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10,ScreenWidth ,17)];
    titleLab.text = @"收支明细";
    titleLab.font = [UIFont systemFontOfSize:13];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [sectionHeaderView addSubview:titleLab];
    
    UILabel  *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, ScreenWidth, 1)];
    [lineLabel setBackgroundColor:RGBCOLOR(191, 191, 191)];
    [sectionHeaderView addSubview:lineLabel];
    
    [self.view addSubview:sectionHeaderView];
    
    [self initTableView:sectionHeaderView.frame.size.height+sectionHeaderView.frame.origin.y];
}

- (void)clickNavRigthBut
{
    RecordController * recordVC = [[RecordController alloc] init];
    recordVC.isScore = YES;
    [self.navigationController pushViewController:recordVC animated:YES];
    
    NSLog(@"查看订单详情");

    
}
#pragma mark - 数据请求
-(void)requestUserPoint
{
    
    [DataEngine requestToGetAllMoneyWithComplete:^(BOOL SUCCESS, NSMutableArray *infoArray) {
        
        if (SUCCESS) {
            _frozenScore= [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[infoArray[4] floatValue]]];;
            _scoreLimitLab.text = _frozenScore;
            
            //缓存
            CacheModel *cacheModel = [CacheEngine getCacheInfo];
            cacheModel.accountModel.accountIntegralModel.freezeIntegralMoney = _frozenScore;
            [CacheEngine setCacheInfo:cacheModel];
            
        }
        
    }];
    
    

}
#pragma mark 获取收支明细收据
- (void)getScorelist:(BOOL) more
{


    
    NSString * token = [[CMStoreManager sharedInstance] getUserToken];

    NSDictionary *dic1=[NSDictionary dictionaryWithObjectsAndKeys:
                        token,@"token",
                        VERSION,@"version",
                        [NSString stringWithFormat:@"%d",startLine],@"pageNo",
                        @"15",@"pageSize",
                        nil];
    
    [NetRequest postRequestWithNSDictionary:dic1 url:K_FINANCY_SCOREFINANCYFLOWLIST successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] integerValue] == 200) {
            
            
            if (more) {
                
                if ([dictionary[@"data"] count]!=0) {
                    startLine += 1;
                }
                
                [_scoreDataArray addObjectsFromArray:dictionary[@"data"]];
            }else{
                [_scoreDataArray removeAllObjects];
                if ([dictionary[@"data"] isKindOfClass:[NSArray class]]||[dictionary[@"data"] isKindOfClass:[NSMutableArray class]]) {
                    
                    startLine += 1;
                    
                    [_scoreDataArray addObjectsFromArray:dictionary[@"data"]];
                }
                
            }
            
            //缓存
            CacheModel *cacheModel = [CacheEngine getCacheInfo];
            cacheModel.accountModel.accountIntegralModel.integralDetailArray = [NSMutableArray arrayWithArray:_scoreDataArray];
            [CacheEngine setCacheInfo:cacheModel];
            
            [self.tableView reloadData];
        
        }
        [self endLoading];
    } failureBlock:^(NSError *error) {
        NSLog(@"___________%@",error.localizedDescription);
        [self endLoading];
    }];





}


#pragma mark TableVIew

-(void)initTableView:(float)aPointY{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, aPointY, ScreenWidth, ScreenHeigth - aPointY-64) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = K_COLOR_CUSTEM(248, 248, 248, 1);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self initRefresh];
    
    [self requestUserPoint];
    //获取积分
    [self getScorelist:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_scoreDataArray == nil) {
        return 0;
    }
    return _scoreDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecordDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[RecordDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    [cell setDict:_scoreDataArray[indexPath.row]];
    
    return cell;
}

#pragma mark Refresh

-(void)initRefresh{
    
    UserPointViewController *pointVC = self;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        startLine = 1;
        [pointVC getScorelist:NO];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [pointVC getScorelist:YES];
    }];
}

-(void)endLoading{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

@end
