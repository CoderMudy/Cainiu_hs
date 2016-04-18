//
//  AdviceRecordPage.m
//  hs
//
//  Created by PXJ on 15/9/24.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "AdviceRecordPage.h"
#import "AdviceCell.h"
#import "AdviceModel.h"
#import "AdviceFrameModel.h"
#import "MJRefresh.h"
#import "NetRequest.h"

@interface AdviceRecordPage ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger pageNum;
    NSInteger pageSize;
}
@property (strong,nonatomic)NSMutableArray * recordDataArray;
@property (strong,nonatomic)NSMutableArray * recordDataFrameArray;
@property (strong,nonatomic)UITableView * tableView;

@end

@implementation AdviceRecordPage
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self loadNav];
    [self initUIView];
}
- (void)initData
{
    _recordDataArray = [NSMutableArray array];
    _recordDataFrameArray = [NSMutableArray array];
    
    pageNum = 1;
    pageSize = 20;
    
    [self requestListData];
    [self requestRefreshData];

}

#pragma mark - 请求回复列表接口
- (void)requestListData
{
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token,@"page":@(pageNum),@"rows":@(20)};
    [NetRequest postRequestWithNSDictionary:dic url:K_Answer_AnswerRecord successBlock:^(NSDictionary *dictionary) {
        [self endLoading];
        if ([dictionary[@"code"] intValue]==200)
        {
            if (pageNum == 1) {
                _recordDataArray = [[NSMutableArray alloc]init];
                _recordDataFrameArray = [[NSMutableArray alloc]init];
            }
            
            NSArray *dataArray = dictionary[@"data"][@"onlist"];
//            NSLog(@"ce shi:%@",dataArray);
            if (dataArray > 0) {
                for (NSDictionary *dic in dataArray) {
                    AdviceModel *model = [[AdviceModel alloc]initWithFillDic:dic];
                    [_recordDataArray addObject:model];
                    
                    AdviceFrameModel *frameModel = [[AdviceFrameModel alloc]initFillFrameData:model];
                    [_recordDataFrameArray addObject:frameModel];
                }
            }else
            {
                if (pageNum != 1) {
                    pageNum -- ;
                }
            }
            
        }else
        {
            if (pageNum != 1) {
                pageNum --;
            }
        }
        
        [_tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        //        NSLog(@"%@",error.localizedDescription);
        [self endLoading];
        if (pageNum != 1) {
            pageNum --;
        }
        
    }];

}

#pragma mark - 更新回复已读状态
- (void)requestRefreshData
{
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token};
    [NetRequest postRequestWithNSDictionary:dic url:K_AnsRefresh_AnswerRefresh successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
//            NSLog(@"全部都是已经读过了");
        }
    } failureBlock:^(NSError *error) {
        
    }];

}

-(void)loadNav{
    self.view.backgroundColor=RGBACOLOR(245, 245, 245, 1);
    NavView * nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    nav.titleLab.text =@"回复记录";
    [nav.leftControl addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
    
}
-(void)initUIView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth)];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:250/255.0 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self initRefresh];

}
-(void)leftButtonClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recordDataFrameArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    AdviceCell *cell = (AdviceCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!cell) {
        cell = [[AdviceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    [cell fillWithData:_recordDataFrameArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_recordDataFrameArray[indexPath.row] cellHeight];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - 刷新
-(void)initRefresh{
    
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    
}

-(void)loadMore
{
    pageNum ++;
    [self requestListData];
    
}
- (void)refresh
{
    pageNum = 1;
    [self requestListData];
    
}
-(void)endLoading{
    [_tableView.footer endRefreshing];
    [_tableView.header endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
