//
//  TiXianListViewController.m
//  hs
//
//  Created by Xse on 15/10/19.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "TiXianListViewController.h"
#import "TiXianDetailViewController.h"
#import "TiXianListCell.h"
#import "TiXianFrameModel.h"
#import "TiXianListModel.h"
#import "NetRequest.h"
#import "MJRefresh.h"

@interface TiXianListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger page;
    BOOL isHiddle;
    
    NSDictionary *CancelStatusDic;
    
    UIImageView *imageView;
    UILabel *noListLab;
}
@property(nonatomic,strong) UITableView *listTableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *dataFrameArray;

@end

@implementation TiXianListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isHiddle = NO;
    page = 1;
    
    _dataArray = [[NSMutableArray alloc]init];
    _dataFrameArray = [[NSMutableArray alloc]init];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self initWithTableView];
    
    //导航栏
    [self setNaviTitle:@"提现列表"];
    [self setBackButton];
    [self setNavibarBackGroundColor:K_color_NavColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [self requestListData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - 从服务器获取数据
- (void)requestListData
{
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token,@"pageNo":@(page),@"pageSize":@(10)};
    [NetRequest postRequestWithNSDictionary:dic url:K_User_TixianRecord successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            if (page == 1) {
                _dataArray = [[NSMutableArray alloc]init];
                _dataFrameArray = [[NSMutableArray alloc]init];
            }

            NSArray *array = dictionary[@"data"];
            
            if (array.count <= 0 && page == 1) {
                [self recoderNOView];
            }else
            {
                imageView.hidden = YES;
                noListLab.hidden = YES;
            }
            
            if (array.count > 0) {
                for (NSDictionary *dic in array)
                {
                    TiXianListModel *listModel = [[TiXianListModel alloc]initWithDic:dic];
                    [_dataArray addObject:listModel];
                    TiXianFrameModel *frameModel = [[TiXianFrameModel alloc]initWithData:listModel];
                    [_dataFrameArray addObject:frameModel];
                
                }
                
            }else
            {
                //没有提现记录的时候，显示一张图片tixian_record_no@2x
                if (page != 1) {
                    page -- ;
                }
            }
            
        }else
        {
            if (page != 1) {
                page -- ;
            }

        }
        
        [_listTableView reloadData];
        [_listTableView.footer endRefreshing];
    } failureBlock:^(NSError *error) {
        [_listTableView.footer endRefreshing];

        if (page != 1) {
            page -- ;
        }

    }];
}

#pragma mark - 初始化表格
- (void)initWithTableView
{
    _listTableView = [[UITableView alloc]init];
    _listTableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeigth - 64);
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.backgroundColor = RGBCOLOR(244, 244, 244);
    [self.view addSubview:_listTableView];
    
     _listTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    _listTableView.tableHeaderView = [self drawHeadView];
    
    //当数据很少在表格里显示不全的时候，去掉表格下面还显示的线条
    UIView *va = [[UIView alloc] initWithFrame:CGRectZero];
    [_listTableView setTableFooterView:va];}

#pragma mark - 绘制表格头视图
- (UIView *)drawHeadView
{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor whiteColor];
    headView.frame = CGRectMake(0, 0, ScreenWidth, 55 + 20 + 5);
    
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"tixian_list_liucheng"];
    imageV.frame = CGRectMake(20, 15, ScreenWidth - 20*2, 35*ScreenWidth/320);
    [headView addSubview:imageV];
    
    UIView *grayView = [[UIView alloc]init];
    grayView.frame = CGRectMake(0, CGRectGetMaxY(imageV.frame) + 15, ScreenWidth, 15);
    grayView.backgroundColor = RGBCOLOR(244, 244, 244);
    [headView addSubview:grayView];
    
    return headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataFrameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleIdentify = @"SimpleIdentify";
    
    TiXianListCell *cell = (TiXianListCell *)[tableView dequeueReusableCellWithIdentifier:simpleIdentify];
    if (!cell) {
        cell = [[TiXianListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleIdentify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置自定义单元格不能点击
    cell.row = indexPath.row;
    
    if (isHiddle == YES) {
        cell.tiXianCancelBtn.hidden = NO;
    }else
    {
        cell.tiXianCancelBtn.hidden = YES;
    }
    
    [cell fillWithData:_dataFrameArray[indexPath.row]];
    
    cell.clickCancelAction = ^(TiXianListModel *model,NSInteger row)
    {
        [self requestTixianCancel:model];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [_dataFrameArray[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TiXianDetailViewController *tixianDetail = [[TiXianDetailViewController alloc]init];
//    NSLog(@"fuck：%@",[_dataArray[indexPath.row] recodeId]);
//    NSLog(@"dd%d:",[_dataArray [indexPath.row] examineStatus]);
    tixianDetail.tiXianId = [_dataArray[indexPath.row] recodeId];
    [self.navigationController pushViewController:tixianDetail animated:YES];
}

#pragma mark - 提现撤回的接口调用
- (void)requestTixianCancel:(TiXianListModel *)model
{
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token,@"ioId":model.recodeId};
    [NetRequest postRequestWithNSDictionary:dic url:K_User_TixianCancel successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            if ([dictionary[@"msg"]isEqualToString:@"撤销成功"])
            {
                [self updataTable:model];
            }else
            {
                [UIEngine showShadowPrompt:@"已审核，不能撤销"];
            }
            
        }
        
        [_listTableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];
    
}

- (void)updataTable:(TiXianListModel *)model
{
    for (NSInteger i = 0; i<_dataArray.count; i++) {
        if ([[_dataArray[i] recodeId] isEqualToString:model.recodeId]) {
            model.examineStatus = 21;
            [_dataArray removeObjectAtIndex:i];
        }
    }
    
    [_listTableView reloadData];
}

#pragma mark - 没有提现记录的时候，显示一张图片
- (void)recoderNOView
{
    imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"tixian_record_no"];
    imageView.frame = CGRectMake(ScreenWidth/2 - 38*ScreenWidth/320/2, (ScreenHeigth - [self drawHeadView].frame.size.height)/2 - 41*ScreenWidth/320/2, 38*ScreenWidth/320, 41*ScreenWidth/320);
    [_listTableView addSubview:imageView];
    
    noListLab = [[UILabel alloc]init];
    noListLab.text = @"没有提现记录";
    noListLab.textColor = [UIColor colorWithRed:213/255.0 green:212/255.0 blue:212/255.0 alpha:1];
    noListLab.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10, ScreenWidth, 30);
    noListLab.textAlignment = NSTextAlignmentCenter;
    noListLab.font = [UIFont systemFontOfSize:18.0];
    [_listTableView addSubview:noListLab];
}

#pragma mark - Refresh
-(void)loadMore
{
    page ++;
    [self requestListData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
