//
//  RecordController.m
//  hs
//
//  Created by RGZ on 15/7/13.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "RecordController.h"
#import "MJRefresh.h"
#import "RecordViewCell.h"
#import "NetRequest.h"
#import "RecordDetailController.h"

@interface RecordController ()
{
    //表的数据数组
    NSMutableArray      *_dataArray;
    //是否加载更多
    BOOL                isMore;
    //页码
    int                 page;
    //系统时间
    NSString            *_systemTime;
}

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation RecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNav];
    
    [self loadData];
    
    [self loadUI];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    page = 1;
    isMore = NO;
    [self loadRequestData];
}

#pragma mark Nav

-(void)loadNav{
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_isScore) {
        
        [self setTitle:@"积分订单"];

    }else
    {
        [self setTitle:@"结算记录"];
        
    }
    [self setNavLeftBut:NSPushMode];
}

#pragma mark UI

-(void)loadUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self initRefresh];
    
}

#pragma mark Data

-(void)loadData{
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    //缓存
    
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    if (self.isScore) {
        if (cacheModel.accountModel.accountRecordModel.settledArray != nil) {
            _dataArray = [NSMutableArray arrayWithArray:cacheModel.accountModel.accountRecordModel.settledPointArray];
        }
    }
    else {
        if (cacheModel.accountModel.accountRecordModel.settledArray != nil) {
            _dataArray = [NSMutableArray arrayWithArray:cacheModel.accountModel.accountRecordModel.settledArray];
        }
    }
    
    page = 1;
}

-(void)loadRequestData{
    
    
    
    [DataEngine requestToGetRecordIsMoney:!self.isScore pageNo:page completeBlock:^(NSMutableArray *dataArray) {
        if (!isMore) {
            if (_dataArray.count>0) {
                [_dataArray removeAllObjects];
            }
            _dataArray = [NSMutableArray arrayWithArray:dataArray];
        }
        else{
            for (int i = 0; i<dataArray.count; i++) {
                [_dataArray addObject:dataArray[i]];
            }
        }
        if (dataArray.count == 0 && page > 1) {
            page -= 1;
        }
        
        if (self.isScore) {
            CacheModel *cacheModel = [CacheEngine getCacheInfo];
            cacheModel.accountModel.accountRecordModel.settledPointArray = [NSMutableArray arrayWithArray:_dataArray];
        }
        else{
            CacheModel *cacheModel = [CacheEngine getCacheInfo];
            cacheModel.accountModel.accountRecordModel.settledArray = [NSMutableArray arrayWithArray:_dataArray];
        }
        
        [_tableView reloadData];
        [self endLoading];
    } failBlock:^(NSString *msg) {
        [self endLoading];
    } ];
    
}

#pragma mark Refresh

-(void)initRefresh{
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadHeader)];
    
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

-(void)loadHeader{
    
    page = 1;
    
    isMore = NO;
    
    [self loadRequestData];
}

-(void)loadMore{
    isMore = YES;
    
    page += 1;
    
    [self loadRequestData];
    
    
}

-(void)endLoading{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

#pragma mark TableView

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecordViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[RecordViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (_dataArray.count > 0 ) {
        if (_dataArray[indexPath.row][@"saleDate"] == nil || [_dataArray[indexPath.row][@"saleDate"] isKindOfClass:[NSNull class]]) {
            _dataArray[indexPath.row][@"saleDate"] = @"";
        }
        
        //time
        NSString *time = _dataArray[indexPath.row][@"saleDate"];
        
        NSArray * array =[time componentsSeparatedByString:@" "];
        if([array lastObject] && [array count] > 1)
        {
            int days = [Helper timeSysTime:[[SystemSingleton sharedInstance].timeString stringByAppendingString:@" 00:00:00"] createTime:time];
            if (days==0) {
                cell.timeLabel.text = [NSString stringWithFormat:@"%@ \n%@",@"今天",array[1]];
            }else if (days==1){
                cell.timeLabel.text = [NSString stringWithFormat:@"%@ \n%@",@"昨天",array[1]];
            }else{
                cell.timeLabel.text = [NSString stringWithFormat:@"%@ \n%@",array[0],array[1]];
            }
        }
        else {
            if (array.count == 0) {
                cell.timeLabel.text = @"";
            }
            else{
                cell.timeLabel.text = array[0];
            }
            
        }
        
        
        //name
        if (_dataArray[indexPath.row][@"stockName"] == nil || [_dataArray[indexPath.row][@"stockName"] isKindOfClass:[NSNull class]]) {
            _dataArray[indexPath.row][@"stockName"] = @"";
        }
        
        cell.nameLabel.text = _dataArray[indexPath.row][@"stockName"];
        
        
        //money
        if (_dataArray[indexPath.row][@"lossProfit"] == nil || [_dataArray[indexPath.row][@"lossProfit"] isKindOfClass:[NSNull class]]) {
            _dataArray[indexPath.row][@"lossProfit"] = 0;
        }
        
        float money = [_dataArray[indexPath.row][@"lossProfit"] floatValue];
        
        cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f",money];
        
        if (money>0) {
            if ([cell.moneyLabel.text rangeOfString:@"+"].location == NSNotFound) {
                cell.moneyLabel.text = [NSString stringWithFormat:@"%@%@",@"+",cell.moneyLabel.text];
            }
            cell.moneyLabel.textColor = [UIColor redColor];
        }
        else if (money < 0){
            if ([cell.moneyLabel.text rangeOfString:@"-"].location == NSNotFound) {
                cell.moneyLabel.text = [NSString stringWithFormat:@"%@%@",@"-",cell.moneyLabel.text];
            }
            cell.moneyLabel.textColor = K_COLOR_CUSTEM(8, 186, 66, 1);
        }
        else{
            cell.moneyLabel.textColor = [UIColor lightGrayColor];
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    HeaderDividers;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RecordDetailController *recordVC = [[RecordDetailController alloc]init];
    recordVC.isScore = self.isScore;
    recordVC.infoDic = _dataArray[indexPath.row];
    [self.navigationController pushViewController:recordVC animated:YES];
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
