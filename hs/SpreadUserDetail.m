//
//  SpreadUserDetail.m
//

//
//  Created by PXJ on 15/10/26.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "SpreadUserDetail.h"
#import "MJRefresh.h"
#import "H5LinkPage.h"
#define  grapLength 20
#define  labLength (ScreenWidth-50)/4
#define  textFont [UIFont systemFontOfSize:11*ScreenWidth/375];
#define  colorText     K_color_black;

@interface SpreadUserDetail ()<UITableViewDataSource,UITableViewDelegate>
{

    NSMutableArray * _userDataArray;
    int _pageNo;
    int _pageSize;
    NSString * _systemTime;
}
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation SpreadUserDetail
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initNav];
    [self initUI];
    [self requestData:NO];
}
- (void)initData
{

    _userDataArray = [NSMutableArray array];
    _pageNo = 1;
    _pageSize = 10;

}
- (void)requestData:(BOOL)isLoadMore
{
    [RequestDataModel requestPromoteSubUserPageNo:_pageNo PageSize:_pageSize successBlock:^(BOOL success, id sender) {
       
        [self endLoading];
        if (success) {
            if (isLoadMore) {
                [_userDataArray addObjectsFromArray:(NSArray*)sender];
            }else{
                if (_userDataArray.count>0) {
                    [_userDataArray removeAllObjects];
                }
                [_userDataArray addObjectsFromArray:(NSArray*)sender];
            }
            
            [self loadNewData];
        }else{
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
    nav.titleLab.text = @"用户详情";
    [nav.leftControl  addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
}
- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 41)];
    [self.view addSubview:headerView];
    
    UILabel * timeLab = [[UILabel alloc] initWithFrame:CGRectMake(grapLength, 20,labLength, 20)];
    timeLab.text = @"注册时间";
    timeLab.textColor = K_color_grayBlack;
    timeLab.font = textFont;
    [headerView addSubview:timeLab];
    
    UILabel * nickLab = [[UILabel alloc] initWithFrame:CGRectMake(grapLength+labLength, 20, labLength, 20)];
    nickLab.text = @"昵称";
    nickLab.textColor = K_color_grayBlack;
    nickLab.font = textFont;
    [headerView addSubview:nickLab];
    
    UILabel * firstLab = [[UILabel alloc] initWithFrame:CGRectMake(grapLength+ 2*labLength, 20, labLength, 20)];
    firstLab.text = @"交易手数";
    firstLab.textAlignment = NSTextAlignmentCenter;
    firstLab.textColor = K_color_grayBlack;
    firstLab.font = textFont;
    [headerView addSubview:firstLab];
    
    UILabel * secondLab = [[UILabel alloc] initWithFrame:CGRectMake(grapLength+3*labLength, 20, labLength, 20)];
    secondLab.text = @"二级交易手数";
    secondLab.textAlignment = NSTextAlignmentCenter;
    secondLab.textColor = K_color_grayBlack;
    secondLab.font = textFont;
    [headerView addSubview:secondLab];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 40, ScreenWidth-40, 0.7)];
    lineView.backgroundColor = K_color_gray;
    [headerView addSubview:lineView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 105, ScreenWidth, ScreenHeigth-154) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"spreadUserCell"];
    [self.view addSubview:self.tableView];
    [self initRefresh];
    
    
    NSString * tgAddress = @"";
    
#if defined (YQB)
    tgAddress = @"详情登录商户后台 tg.100zjgl.com";
#else
    tgAddress = @"详情登录商户后台 tg.cainiu.com";
    
#endif
    UIButton * webBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [webBtn setBackgroundColor:[UIColor whiteColor]];
    webBtn.frame = CGRectMake(0, ScreenHeigth-49, ScreenWidth, 49);
    [webBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [webBtn setTitle:tgAddress forState:UIControlStateNormal];
    [webBtn setTitleColor:K_color_red forState:UIControlStateNormal];
    [webBtn addTarget:self action:@selector(goWeb) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:webBtn];
}

- (void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)goWeb
{
    
    NSString * tgAddress = @"";
    
#if defined (YQB)
    tgAddress = @"http://tg.100zjgl.com";
#else
    tgAddress = @"http://tg.cainiu.com";
    
#endif
    H5LinkPage * h5VC = [[H5LinkPage alloc] init];
    h5VC.hiddenNav = NO;
    h5VC.urlStr = tgAddress;
    [self.navigationController pushViewController:h5VC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _userDataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"spreadUserCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    for (UIView * subv in cell.contentView.subviews) {
        [subv removeFromSuperview];
    }
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-40, 40)];
    
    
    if (indexPath.row%2==0) {
        backView.backgroundColor = K_COLOR_CUSTEM(246, 247, 248, 1);
        
    }else{
        backView.backgroundColor = [UIColor whiteColor];
    }
    [cell.contentView addSubview:backView];
    NSDictionary * dic = _userDataArray[indexPath.row];
    
    UILabel * timeLab = [[UILabel alloc] initWithFrame:CGRectMake(grapLength, 0,labLength+20, 40)];
    NSString * time = [NSString stringWithFormat:@"%@",dic[@"createDate"]];
    time = [self timetransform:time];
    timeLab.text = time;
    timeLab.numberOfLines = 0;
    timeLab.textColor = colorText;
    timeLab.font = textFont;
    [cell.contentView addSubview:timeLab];
    
    UILabel * nickLab = [[UILabel alloc] initWithFrame:CGRectMake(grapLength+labLength, 10, labLength+10, 20)];
    nickLab.text = [NSString stringWithFormat:@"%@",dic[@"nickName"]];;
    nickLab.textColor = colorText;
    nickLab.font = textFont;
    [cell.contentView addSubview:nickLab];
    
    UILabel * firstLab = [[UILabel alloc] initWithFrame:CGRectMake(grapLength+ 2*labLength, 10, labLength, 20)];
    firstLab.text = [NSString stringWithFormat:@"%d",[dic[@"consumerHands"] intValue]];
    if ([firstLab.text isEqualToString:@"0"]) {
        firstLab.textColor = K_color_red;
    }else{
        firstLab.textColor = colorText;

    }
    firstLab.font = textFont;
    firstLab.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:firstLab];
    
    UILabel * secondLab = [[UILabel alloc] initWithFrame:CGRectMake(grapLength+3*labLength, 10, labLength, 20)];
    secondLab.text = [NSString stringWithFormat:@"%d",[dic[@"subConsumerHands"]intValue]];
    if ([secondLab.text isEqualToString:@"0"]) {
        secondLab.textColor = K_color_red;
    }else{
        secondLab.textColor = colorText;
    }
    secondLab.font = textFont;
    secondLab.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:secondLab];
    

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
    [timeFormatter setDateFormat:@"HH:mm:ss.S"];
    NSDateFormatter * strFormatter = [[NSDateFormatter alloc] init];
    [strFormatter setDateFormat:@"HH:mm"];
    NSDate * timeDate = [timeFormatter dateFromString:dateArray[1]];
    NSString * timeString = [strFormatter stringFromDate:timeDate];
    NSString * showTime = [NSString stringWithFormat:@"%@\n%@",timeStr,timeString];
    return showTime;
}

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
