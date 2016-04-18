//
//  SystemMessagePage.m
//  hs
//
//  Created by PXJ on 15/8/7.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "SystemMessagePage.h"
#import "SystemMessageCell.h"
#import "NetRequest.h"
#import "SysMsgDataModels.h"
#import "SystemMsgDetailPage.h"
#import "MJRefresh.h"



@interface SystemMessagePage ()<UITableViewDataSource,UITableViewDelegate>
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

@implementation SystemMessagePage
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"系统消息"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"系统消息"];
    self.navigationController.navigationBarHidden = NO;

}
- (void)requestSysMsgData
{


    
    NSDictionary * dic = @{@"pageNo":[NSNumber numberWithInt:_pageNum],@"pageSize":[NSNumber numberWithInt:_pageSize]};
    NSString * url =K_sms_sysMsg;
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        [self endLoading];
        if ([dictionary[@"code"] intValue]==200)
        {
            _pageNum += 1;
            _sysBaseModel = [SysMsgBaseClass modelObjectWithDictionary:dictionary];
            if (_loadMore) {
                
                [_sysModelArray addObjectsFromArray:_sysBaseModel.data];
                
                
            }else{
            
                if (_sysModelArray.count>0) {
                    [_sysModelArray removeAllObjects];
                }
            
                _sysModelArray = [NSMutableArray arrayWithArray:_sysBaseModel.data];

            }
            
            [self loadData];
        }
        if (_sysModelArray.count>0) {
            _backLab.hidden = YES;
        }else{
            _backLab.hidden = NO;
            [self.view bringSubviewToFront:_backLab];
        }
    } failureBlock:^(NSError *error) {
        
        [self endLoading];
        if (_sysModelArray.count>0) {
            
            _backLab.hidden = YES;
            
        }else{
            _backLab.hidden = NO;
            [self.view bringSubviewToFront:_backLab];
        }
        
    }];

}
- (void)loadData
{

    [_tableView reloadData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNav];
    [self initTableView];
    [self initData];
    _pageNum = 1;
    _pageSize = 10;
    [self requestSysMsgData];
    
}
- (void) initData
{
    _sysModelArray = [NSMutableArray array];

}
-(void)loadNav{
    
    NavView * nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    nav.titleLab.text = @"系统消息";
    [nav.leftControl addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
//    
//    self.title = @"系统消息";
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_1"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClick)];
}

-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initTableView
{
    _backLab = [[UILabel alloc] init];
    _backLab.center = CGPointMake(ScreenWidth/2, 64+(ScreenHeigth-64)/2);
    _backLab.bounds = CGRectMake(0, 0, ScreenWidth, ScreenHeigth-64);
    _backLab.font = [UIFont systemFontOfSize:16];
    _backLab.backgroundColor = K_COLOR_CUSTEM(245, 246, 247, 1);
    _backLab.text = @"您当前还没有系统消息";
    _backLab.textColor = K_COLOR_CUSTEM(153, 153, 153, 1);
    _backLab.textAlignment = NSTextAlignmentCenter;
    _backLab.hidden =YES;
    [self.view addSubview:_backLab];

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = K_COLOR_CUSTEM(245, 246, 247, 1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[SystemMessageCell class] forCellReuseIdentifier:@"systemMSGCell"];
    [self initRefresh];
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sysModelArray.count;

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    SystemMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"systemMSGCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellWith:_sysModelArray[(int)indexPath.section]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SysMsgData * sysMsgModel =_sysModelArray[(int)indexPath.section];
    
    SystemMsgDetailPage * vc = [[SystemMsgDetailPage alloc] init];
    vc.messageId = [NSString stringWithFormat:@"%.0f",sysMsgModel.dataIdentifier];
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float cellHeight;
    

    SysMsgData * sysMsgModel =_sysModelArray[(int)indexPath.section];
    if (sysMsgModel.content.length<60) {
        CGRect rect = [sysMsgModel.content boundingRectWithSize:CGSizeMake(ScreenWidth-60, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
        cellHeight = ScreenWidth*13/50+rect.size.height +10;

        
    }else{
    
        cellHeight =ScreenWidth *13/50+ScreenWidth/10 +10;
    
    
    }
    
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 1;
    
}
-(void)initRefresh{
    
    
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    

    
}


-(void)loadMore
{

    _loadMore = YES;
    [self requestSysMsgData];

}
- (void)refresh
{
    _pageNum = 1;
    _loadMore = NO;
    [self requestSysMsgData];

}

-(void)endLoading{
    [_tableView.footer endRefreshing];
    [_tableView.header endRefreshing];
}

- (void)didReceiveMemoryarning {
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
