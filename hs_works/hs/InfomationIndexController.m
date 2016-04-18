//
//  InfomationIndexController.m
//  hs
//
//  Created by RGZ on 15/12/29.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "InfomationIndexController.h"
#import "InformationViewController.h"
#import "InformationIndexCell.h"
#import "MJRefresh.h"
#import "News.h"

@interface InfomationIndexController ()
{
    UITableView     *_tableView;
    NSMutableArray  *_dataArray;
    UILabel         *_titleLab;
    UIImageView     *_refreshImage;
    NSTimer         *_refreshTimer;
    double          angle;
    int     page;
}
@end

@implementation InfomationIndexController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.rdv_tabBarController.tabBarHidden = NO;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNav];
    
    [self loadData];
    
    [self loadTable];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeTimer];
}

-(void)loadNav{
    Self_AddNavBGGround;
    Self_AddNavTitle(@"资讯");
    _titleLab = titleLab;
    float width = [DataUsedEngine getStringRectWithString:titleLab.text Font:16 Width:100 Height:_titleLab.frame.size.height].width;
    _titleLab.frame = CGRectMake(0, 20, width, _titleLab.frame.size.height);
    _titleLab.center = CGPointMake(self.view.center.x, _titleLab.center.y);
    
    _refreshImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    _refreshImage.image = [UIImage imageNamed:@"information_refresh"];
    _refreshImage.center = CGPointMake(_titleLab.frame.origin.x + _titleLab.frame.size.width + 24/2 + 3, _titleLab.center.y);
    _refreshImage.userInteractionEnabled = YES;
    [self.view addSubview:_refreshImage];
    
    UITapGestureRecognizer *refreshTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(refreshTap)];
    [_refreshImage addGestureRecognizer:refreshTap];
}

-(void)refreshTap{
    
    if (_refreshTimer == nil) {
        angle   = 0;
        _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(refreshTimer) userInfo:nil repeats:YES];
        
        [_tableView.header beginRefreshing];
    }
}

-(void)refreshTimer{
    angle += 10;
    _refreshImage.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0));
}

-(void)removeTimer{
    [_refreshTimer invalidate];
    _refreshTimer = nil;
    _refreshImage.transform = CGAffineTransformMakeRotation(2 * M_PI);
}

-(void)loadData{
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableArray  *cacheArray = [CacheEngine getInfoWithNews];
    
    if (cacheArray != nil) {
        _dataArray = [NSMutableArray arrayWithArray:cacheArray];
    }
    
    page    = 1;
}

-(void)loadTable{
    self.view.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:0.3];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth - 64 - 50) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self loadRefresh];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dataArray != nil) {
        return _dataArray.count;
    }
    else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor clearColor];
    if (section != 0) {
        
        News *news = _dataArray[section];
        News *oldNews = _dataArray[section-1];
        if ([DataUsedEngine nullTrim:news.createDate] && [DataUsedEngine nullTrim:oldNews.createDate]) {
            if (news.createDate.length >= 10 && oldNews.createDate.length >= 10) {
                if (![[news.createDate substringToIndex:10] isEqualToString:[oldNews.createDate substringToIndex:10]]) {
                    NSString *dateStr = [[news.createDate substringToIndex:10] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                    UIView *lineView = [[UIView alloc]init];
                    lineView.frame = CGRectMake(57, 8, (ScreenWidth - 57 - 15), 0.7);
                    lineView.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1];
                    [bgView addSubview:lineView];
                    
                    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(57 + (ScreenWidth - 57 - 15)/2 - 75/2, 0, 75, 16)];
                    dateLabel.font = [UIFont systemFontOfSize:11];
                    dateLabel.textColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1];
                    dateLabel.backgroundColor = _tableView.backgroundColor;
                    dateLabel.textAlignment = NSTextAlignmentCenter;
                    dateLabel.text = dateStr;
                    [bgView addSubview:dateLabel];
                }
            }
        }
    }
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    News    *news = nil;
    
    if (indexPath.section < _dataArray.count) {
        news = _dataArray[indexPath.section];
    }
    
    if (news != nil) {
        CGSize size = [DataUsedEngine getStringRectWithString:news.summary Font:13 Width:ScreenWidth - 57 - 15 - 20 Height:MAXFLOAT];
        float  imageHeight = 0;
        //限制3行文字
        if (size.height >= 50) {
            size.height = 60;
        }
        //图片
        if (![news.bannerUrl isEqualToString:@""] && news.bannerUrl.length > 4) {
            imageHeight = 120 + 5;
        }
        float   titleHeight = 30;
        if ([news.section isEqualToString:@"57"]) {
            titleHeight = 8;
        }
        return size.height+titleHeight+5+25+5+imageHeight+4;
    }
    else{
        return 0;
    }
}

-(InformationIndexCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    News    *news = nil;
    if (_dataArray.count > indexPath.section) {
        news = _dataArray[indexPath.section];
    }
    
    if (news != nil) {
        CGSize size = [DataUsedEngine getStringRectWithString:news.summary Font:13 Width:ScreenWidth - 57 - 15 - 20 Height:MAXFLOAT];
        //文字限制3行
        if (size.height >= 50) {
            size.height = 60;
        }
        //图片
        float  imageHeight = 0;
        if (![news.bannerUrl isEqualToString:@""] && news.bannerUrl.length > 4) {
            imageHeight = 120 + 5;
        }
        float   titleHeight = 30;
        if ([news.section isEqualToString:@"57"]) {
            titleHeight = 8;
        }
        
        InformationIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        if (!cell) {
            
            cell = [[InformationIndexCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL" CellHeight:size.height+titleHeight+25+5+4+imageHeight ContentHeight:size.height News:news];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        BOOL isLastNews = NO;
        if (indexPath.section == _dataArray.count - 1) {
            isLastNews = YES;
        }
        [cell setCellHeight:size.height+titleHeight+25+5+4+imageHeight ContentHeight:size.height News:news isLastNews:isLastNews];
        
        
        return cell;
    }
    else{
        return [[InformationIndexCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"errorcell"];
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    News *news = nil;
    if (_dataArray.count > indexPath.section) {
        news = _dataArray[indexPath.section];
        InformationViewController   *infoDetailVC = [[InformationViewController alloc]init];
        infoDetailVC.news = news;
        [self.navigationController pushViewController:infoDetailVC animated:YES];
    }
}

-(void)loadRefresh{
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    [_tableView.header setAutoChangeAlpha:YES];
    [_tableView.footer setAutoChangeAlpha:YES];
    
    [_tableView.header beginRefreshing];
}

-(void)endLoading{
    [_tableView.footer endRefreshing];
    [_tableView.header endRefreshing];
}

-(void)loadMore{
    if ([_tableView.footer isRefreshing]) {
        page++;
        [self requestGo];
    }
}

-(void)refresh{
    if ([_tableView.header isRefreshing]) {
        page = 1;
        [self requestGo];
    }
}

-(void)requestGo{
    [self getDataListWithPage:page];
}

#pragma mark 资讯列表数据

-(void)getDataListWithPage:(int)aPage{
    
    [DataEngine requestTogetNewsListWithPageNo:aPage PageSize:10 completeBlock:^(BOOL SUCCESS, NSMutableArray *dataArray) {
        [self endLoading];
        if (SUCCESS) {
            if (page != 1 && page != 0) {
                NSMutableArray *tmpDataArray = [NSMutableArray arrayWithCapacity:0];
                for (int i = 0; i < dataArray.count; i++) {
                    News *newNews = dataArray[i];
                    BOOL isRepeat = NO;
                    for (int j = 0; j < _dataArray.count; j++) {
                        News *oldNews = _dataArray[j];
                        if ([newNews.newsID isEqualToString:oldNews.newsID]) {
                            isRepeat = YES;
                        }
                    }
                    if (isRepeat == NO) {
                        [tmpDataArray addObject:newNews];
                    }
                }
                [_dataArray addObjectsFromArray:tmpDataArray];
            }else{
                _dataArray = [NSMutableArray arrayWithArray:dataArray];
                [CacheEngine setNewsInfoWithCache:_dataArray];
            }
            
        }
        
        [_tableView reloadData];
        
        if (page > 1 && (dataArray == nil || dataArray.count == 0)) {
            page--;
        }
        
        [self removeTimer];
    }];
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
