//
//  TraderRemindPage.m
//  hs
//
//  Created by PXJ on 15/8/7.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "TraderRemindPage.h"
#import "TraderRemindCell.h"
#import "NetRequest.h"
#import "SysMsgDataModels.h"
#import "MJRefresh.h"


@interface TraderRemindPage ()<UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray * _sysModelArray;
    int _pageNum;
    int _pageSize;
    BOOL _loadMore;
    
}
@property (nonatomic,strong)SysMsgBaseClass * sysBaseModel;

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UILabel * backLab;

@end

@implementation TraderRemindPage

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"交易提醒"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
    if (_isPush)
    {
    }else
    {
        [self requestTraderRemindData];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"交易提醒"];
    self.navigationController.navigationBarHidden = NO;
}
- (void)requestTraderRemindData
{
    int pageSize = 10;
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    NSDictionary * dic = @{@"token":token,@"pageNo":[NSNumber numberWithInt:_pageNum],@"pageSize":[NSNumber numberWithInt:pageSize]};
    NSString * url =K_sms_TraderMsg;
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary)
    {
        [self endLoading];
        if ([dictionary[@"code"] intValue]==200)
        {
            _pageNum +=1;
            _sysBaseModel = [SysMsgBaseClass modelObjectWithDictionary:dictionary];
            if (_loadMore)
            {
                [_sysModelArray addObjectsFromArray:_sysBaseModel.data];
            }else
            {
                if (_sysModelArray.count>0)
                {
                    [_sysModelArray removeAllObjects];
                }
                _sysModelArray = [NSMutableArray arrayWithArray:_sysBaseModel.data];
            }
            [self loadData];
        }
        if (_sysModelArray.count>0)
        {
            _backLab.hidden = YES;
        }else{
            _backLab.hidden = NO;
            [self.view bringSubviewToFront:_backLab];
        }
    } failureBlock:^(NSError *error)
    {
        [self endLoading];
        if (_sysModelArray.count>0)
        {
            _backLab.hidden = YES;
        }else
        {
            _backLab.hidden = NO;
            [self.view bringSubviewToFront:_backLab];
        }
    }];
}
- (void)loadData
{
    [_tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadNav];
    [self initTableView];
    _pageNum = 1;
    _pageSize = 10;
    if(_isPush)
    {
        self.view.backgroundColor = [UIColor redColor];
    }
}
-(void)loadNav
{
    NavView * nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    nav.titleLab.text = @"交易提醒";
    [nav.leftControl addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
}
-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initTableView
{
    _backLab = [[UILabel alloc] init];
    _backLab.center = CGPointMake(ScreenWidth/2, 64+(ScreenHeigth-64)/2);
    _backLab.bounds = CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64);
    _backLab.font = [UIFont systemFontOfSize:15];
    _backLab.textColor = K_COLOR_CUSTEM(153, 153, 153, 1);
    _backLab.backgroundColor = K_COLOR_CUSTEM(245, 246, 247, 1);
    _backLab.text = @"您当前还没有交易提醒";
    _backLab.textAlignment = NSTextAlignmentCenter;
    _backLab.hidden =YES;
    [self.view addSubview:_backLab];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[TraderRemindCell class] forCellReuseIdentifier:@"traderRCell"];
    [self.view addSubview:_tableView];
    [self initRefresh];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isPush)
    {
        return 1;
    }
    return _sysModelArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TraderRemindCell *cell = [tableView dequeueReusableCellWithIdentifier:@"traderRCell" forIndexPath:indexPath];
    SysMsgData * sysmsgModel = [[SysMsgData alloc]init];
    if (_isPush)
    {
        sysmsgModel.createDate = _createDate;
        sysmsgModel.content    = _contentText;
    }else
    {
        sysmsgModel =_sysModelArray[(int)indexPath.row];
    }
    [cell setTraderCell:sysmsgModel];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * message;
    if (_isPush)
    {
        message  =_contentText;
    }else
    {
        SysMsgData * model = _sysModelArray[indexPath.row];
        message = model.content;
    }
    CGRect rect = [message boundingRectWithSize:CGSizeMake(ScreenWidth*3/5, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    float height = rect.size.height<ScreenWidth/10?ScreenWidth/10+5:rect.size.height;
    return height+ScreenWidth/10;
}
-(void)initRefresh
{
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
}
-(void)loadMore
{
    _loadMore = YES;
    [self requestTraderRemindData];
}
- (void)refresh
{
    _pageNum = 1;
    _loadMore = NO;
    [self requestTraderRemindData];
}
-(void)endLoading
{
    [_tableView.footer endRefreshing];
    [_tableView.header endRefreshing];
}
- (void)didReceiveMemoryWarning
{
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
