//
//  CommissionPage.m
//  hs
//
//  Created by PXJ on 15/10/26.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "CommissionPage.h"
#import "MJRefresh.h"


@interface CommissionPage ()<UITableViewDataSource,UITableViewDelegate>
{

    NSMutableArray * _commissionArray;
    int _pageNo;
    int _pageSize;
    NSString * _systemTime;
    
    
    UIImageView * _pigImgV;
    UILabel * _remindLab;
}
@property(nonatomic,strong)UITableView * tableView;
@end

@implementation CommissionPage
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    [self requestData:NO];

}
- (void)viewWillDisappear:(BOOL)animated

{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self initNav];
    [self initUI];
    
}

- (void)initData
{
    _commissionArray = [NSMutableArray array];
    _pageNo = 1;
    _pageSize = 10;
}
- (void)requestData:(BOOL)isLoadMore
{
    [RequestDataModel requestPromoteComissionPageNo:_pageNo pageSize:_pageSize successBlock:^(BOOL success, id sender)
    {    [self endLoading];
        if (success)
        {
            if (isLoadMore)
            {
                [_commissionArray addObjectsFromArray:(NSArray*)sender];
            }else
            {
                if (_commissionArray.count>0)
                {
                    [_commissionArray removeAllObjects];
                }
                [_commissionArray addObjectsFromArray:(NSArray*)sender];
            }
           

        }else{
        }
        
        if (_commissionArray.count>0) {
            [self loadNewData];
            _pigImgV.hidden = YES;
            _remindLab.hidden = YES;
            _tableView.hidden = NO;
        }else{
            _pigImgV.hidden = NO;
            _remindLab.hidden = NO;
            _tableView.hidden = YES;
            
        }
    }];
}

- (void)loadNewData
{
    
    [DataEngine requestToGetSystemDateWithComplete:^(BOOL SUCCESS, NSString *data , NSString *timeInterval) {
        if (SUCCESS) {
            _systemTime = data;
        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            
            _systemTime = [dateFormatter stringFromDate:[NSDate date]];
        }
        [_tableView reloadData];
    }];
    
    
    
}
- (void)initNav
{
    NavView * nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    nav.titleLab.text = @"佣金流水";
    [nav.leftControl  addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
}

- (void)initUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self initRefresh];
    [self.view addSubview:_tableView];
    
    _pigImgV = [[UIImageView alloc] init ];
    _pigImgV.center = CGPointMake(ScreenWidth/2, (ScreenHeigth-64)*2/5);
    _pigImgV.bounds = CGRectMake(0, 0, 38*ScreenWidth/375.0, 41*ScreenWidth/375.0);
    _pigImgV.image = [UIImage imageNamed:@"tixian_record_no"];
    _pigImgV.hidden = YES;
    [self.view addSubview:_pigImgV];
    _remindLab = [[UILabel alloc] init];
    _remindLab.center = CGPointMake(ScreenWidth/2, _pigImgV.center.y+_pigImgV.frame.size.height/2+20);
    _remindLab.bounds = CGRectMake(0, 0, ScreenWidth, 30);
    _remindLab.text = @"没有佣金流水";
    _remindLab.font = [UIFont systemFontOfSize:15];
    _remindLab.textColor = K_COLOR_CUSTEM(198, 198, 198, 1);
    _remindLab.textAlignment = NSTextAlignmentCenter;
    _remindLab.hidden = YES;
    [self.view addSubview:_remindLab];
}

- (void)leftClick
{

    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commissionArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    for (UIView * subv in cell.contentView.subviews) {
        [subv removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dic = _commissionArray[indexPath.row];
    CGFloat labLength = ScreenWidth/2;
    
    UILabel * moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, labLength, 20)];
    NSString * moneyStr = [NSString stringWithFormat:@"%.2f元",dic[@"inOutCommissions"]==nil?0.00:[dic[@"inOutCommissions"] floatValue]];
    moneyStr = [DataEngine addSign:moneyStr];
    moneyLab.text = moneyStr;
    moneyLab.textColor =  K_color_black;
    moneyLab.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [cell.contentView addSubview:moneyLab];
    
    UILabel * timeLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 30,labLength, 20)];
    NSString * time = [NSString stringWithFormat:@"%@",dic[@"createDate"]];
    timeLab.text = [self timetransform:time];
    timeLab.numberOfLines = 0;
    timeLab.textColor = K_color_grayBlack;
    timeLab.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    [cell.contentView addSubview:timeLab];
    
    int status = dic[@"status"]==nil?0:[dic[@"status"] intValue];
    
    UILabel * statusLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 20, labLength-20, 20)];
    statusLab.text = status==0?@"审核中":(status==1?@"成功":@"失败");
    statusLab.textColor = K_color_grayBlack;
    statusLab.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    statusLab.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:statusLab];
    
    UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, ScreenWidth, 0.5)];
    line.backgroundColor = K_color_line;
    [cell.contentView addSubview:line];
    

    return cell;
}

- (NSString *)timetransform:(NSString*)time
{
    NSArray * dateArray =[time componentsSeparatedByString:@" "];
    NSArray * systemArray = [_systemTime componentsSeparatedByString:@" "];
    NSString * timeStr;
//    int date= [Helper timeSysTime:_systemTime createTime:time];
    int date = [Helper timeSysDateStr:systemArray[0] createDateStr:dateArray[0]];
    switch (date) {
        case 0:
            timeStr = @"今天";
            break;
        case 1:
            timeStr = @"昨天";
            break;
        default:
            timeStr = dateArray[0];
            break;
    }
    
    NSDateFormatter * timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    NSDateFormatter * strFormatter = [[NSDateFormatter alloc] init];
    [strFormatter setDateFormat:@"HH:mm"];
    NSDate * timeDate = [timeFormatter dateFromString:dateArray[1]];
    NSString * timeString = [strFormatter stringFromDate:timeDate];
    
    NSString * showTime = [NSString stringWithFormat:@"%@ %@",timeStr,timeString];
    return showTime;
}

//禁止列表下拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if (scrollView.contentOffset.y<=0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
}
#pragma mark Refresh 初始化下拉刷新

-(void)initRefresh{
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}
-(void)loadMore{
    
    _pageNo += 1;
    [self requestData:YES];
    
    
}

-(void)endLoading{
    [_tableView.footer endRefreshing];
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
