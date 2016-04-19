//
//  TacticPage.m
//  hs
//
//  Created by PXJ on 16/3/14.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "TacticPage.h"
#import "TacticPageCell.h"
#import "MJRefresh.h"
#import "NewsDetailPage.h"


@interface TacticPage()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray  *_dataArray;
    int     page;
    int     _pageSize;
    
}
@property (nonatomic,strong)UITableView * tableView;

@end

@implementation TacticPage

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _pageSize = 10;
        [self loadData];//加载缓存
        [self initTable];
    }
    return self;
}
-(void)loadData{
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableArray  *cacheArray = [CacheEngine getTacticInfoWithTactic];
    
    if (cacheArray != nil) {
        _dataArray = [NSMutableArray arrayWithArray:cacheArray];
    }
    page    = 1;
}


- (void)initTable
{
    
    self.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth - 64 - 50) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
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
    
    CGFloat headerHeight = 0.5;
    if (section != 0) {
        
        News *news = _dataArray[section];
        News *oldNews = _dataArray[section-1];
        if ([DataUsedEngine nullTrim:news.createDate] && [DataUsedEngine nullTrim:oldNews.createDate]) {
            if (news.createDate.length >= 10 && oldNews.createDate.length >= 10) {
                if (![[news.createDate substringToIndex:10] isEqualToString:[oldNews.createDate substringToIndex:10]]) {
                    headerHeight = 20;
                }
            }
        }
    }else{
        headerHeight = 20;
    }
    return headerHeight;

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    CGFloat headerHeight = 0.5;

    UIView * verticalLine = [[UIView alloc] init ];
    verticalLine.frame = CGRectMake(20, 0, 1, headerHeight);
    [bgView addSubview:verticalLine];
    if (section != 0) {
        News *news = _dataArray[section];
        News *oldNews = _dataArray[section-1];
        if ([DataUsedEngine nullTrim:news.createDate] && [DataUsedEngine nullTrim:oldNews.createDate])
        {
            if (news.createDate.length >= 10 && oldNews.createDate.length >= 10)
            {
                if (![[news.createDate substringToIndex:10] isEqualToString:[oldNews.createDate substringToIndex:10]])
                {
                    headerHeight = 20;
                    
                    NSString *dateStr = [news.createDate substringToIndex:10];
                    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 75, 15)];
                    dateLabel.font = [UIFont systemFontOfSize:11];
                    dateLabel.textColor = K_color_orangeLine;
                    dateLabel.backgroundColor = [UIColor whiteColor];
                    dateLabel.text = dateStr;
                    [bgView addSubview:dateLabel];
                    verticalLine.frame = CGRectMake(20, 5, 1, headerHeight-5);
                }
            }
        }
    }else{
        News *news = _dataArray[section];
        if ([DataUsedEngine nullTrim:news.createDate])
        {
            if (news.createDate.length >= 10 )
            {
                headerHeight = 20;
                NSString *dateStr = [news.createDate substringToIndex:10];
                UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 75, 15)];
                dateLabel.font = [UIFont systemFontOfSize:11];
                dateLabel.textColor = K_color_orangeLine;
                dateLabel.backgroundColor = [UIColor whiteColor];
                dateLabel.text = dateStr;
                [bgView addSubview:dateLabel];
                verticalLine.frame = CGRectMake(20, 5, 1, headerHeight-5);
            }
        }
    }
    verticalLine.backgroundColor = K_color_orangeLine;
    return bgView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    bgView.backgroundColor = [UIColor whiteColor];
    UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 1, 0.5)];
    lineV.backgroundColor = K_color_orangeLine;
    [bgView addSubview:lineV];
    return bgView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    News    *news = nil;
    if (_dataArray.count > indexPath.section)
    {
        news = _dataArray[indexPath.section];
    }
    if (news != nil)
    {
        CGSize size = [DataUsedEngine getStringRectWithString:news.summary Font:13 Width:ScreenWidth - 60 Height:MAXFLOAT];
        //限制3行文字
        CGFloat sizeHeight = size.height;
        if (size.height >= 50)
        {
            sizeHeight = 60;
        }
        //图片
        float  imageHeight = 0;
        if (![news.bannerUrl isEqualToString:@""] && news.bannerUrl.length > 4)
        {
            imageHeight = 120 + 5;
        }
        float   titleHeight = 30;
        return sizeHeight+titleHeight+5+25+5+imageHeight+4+30;
    }
    else
    {
        return 0;
    }
}

-(TacticPageCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    News    *news = nil;
    if (_dataArray.count > indexPath.section)
    {
        news = _dataArray[indexPath.section];
    }
    if (news != nil)
    {
        CGSize size = [DataUsedEngine getStringRectWithString:news.summary Font:13 Width:ScreenWidth-60 Height:MAXFLOAT];
        //文字限制3行
        CGFloat sizeHeight = size.height;
        if (size.height >= 50)
        {
            sizeHeight = 60;
        }
        //图片
        float  imageHeight = 0;
        if (![news.bannerUrl isEqualToString:@""] && news.bannerUrl.length > 4)
        {
            imageHeight = 120 + 5;
        }
        float   titleHeight = 30;
        CGFloat cellHeight = sizeHeight+titleHeight+5+25+5+imageHeight+4+30;
        TacticPageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TacticCELL"];
        if (!cell)
        {
            cell = [[TacticPageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TacticCELL" CellHeight:cellHeight ContentHeight:sizeHeight News:news];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        BOOL isLastNews = NO;
        if (indexPath.section == _dataArray.count - 1)
        {
            isLastNews = YES;
        }
        [cell setCellHeight:cellHeight ContentHeight:sizeHeight News:news isLastNews:isLastNews];
        return cell;
    }
    else
    {
        return [[TacticPageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"errorcell"];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    News *news = nil;
    if (_dataArray.count > indexPath.section)
    {
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];

        news = _dataArray[indexPath.section];
        NewsDetailPage   *newsDetailVC = [[NewsDetailPage alloc]init];
        newsDetailVC.news = news;
        self.pushBlock(newsDetailVC);
    }
}

-(void)loadRefresh
{
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    [_tableView.header setAutoChangeAlpha:YES];
    [_tableView.footer setAutoChangeAlpha:YES];
    
    [_tableView.header beginRefreshing];
}

-(void)endLoading
{
    [_tableView.footer endRefreshing];
    [_tableView.header endRefreshing];
}

-(void)loadMore
{
    if ([_tableView.footer isRefreshing])
    {
        page++;
        _pageSize = 10;
        [self requestGo];
        
    }
}

-(void)refresh{
    if ([_tableView.header isRefreshing])
    {
        page = 1;
        _pageSize = 10;
        [self requestGo];
    }
}
-(void)requestGo
{
    [self getDataListWithPage:page];
}

#pragma mark 资讯列表数据

-(void)getDataListWithPage:(int)aPage
{
    [DataEngine requestTogetTacticListWithPageNo:aPage PageSize:10 completeBlock:^(BOOL SUCCESS, NSMutableArray *dataArray)
    {
        [self endLoading];
        if (SUCCESS)
        {
            if (page != 1 && page != 0)
            {
                NSMutableArray *tmpDataArray = [NSMutableArray arrayWithCapacity:0];
                for (int i = 0; i < dataArray.count; i++)
                {
                    News *newNews = dataArray[i];
                    BOOL isRepeat = NO;
                    for (int j = 0; j < _dataArray.count; j++)
                    {
                        News *oldNews = _dataArray[j];
                        if ([newNews.newsID isEqualToString:oldNews.newsID])
                        {
                            isRepeat = YES;
                        }
                    }
                    if (isRepeat == NO)
                    {
                        [tmpDataArray addObject:newNews];
                    }
                }
                [_dataArray addObjectsFromArray:tmpDataArray];
            }else{
                _dataArray = [NSMutableArray arrayWithArray:dataArray];
                [CacheEngine setTacticInfoWithCache:_dataArray];
            }
        }
        [_tableView reloadData];
        if (page > 1 && (dataArray == nil || dataArray.count == 0))
        {
            page--;
        }
        
    }];
}

@end
