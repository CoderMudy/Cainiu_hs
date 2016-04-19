//
//  NewsPage.m
//  hs
//
//  Created by PXJ on 16/3/14.
//  Copyright © 2016年 luckin. All rights reserved.
//
#define textStyleTextNum 50
#define newsContentFont 14
#define titleFont 17
#define lineSpace 6
#define textLengthSpace @0.2
#import "NewsPage.h"
#import "NewsPageCell.h"
#import "MJRefresh.h"
#import "NewsDetailPage.h"

@interface NewsPage()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray  *_dataArray;
    NSMutableSet * _readedNewIdSet;
    int     page;
    int     _pageSize;
    int     _lastMaxID;
    
    
}
@property (nonatomic,strong)UITableView * tableView;

@end

@implementation NewsPage

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
        [self loadData];//加载缓存
        [self initTable];
    }
    return self;
}
-(void)loadData{
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableArray  *cacheArray = [CacheEngine getNewsInfoWithNews];
    
    if (cacheArray != nil) {
        _dataArray = [NSMutableArray arrayWithArray:cacheArray];
        _lastMaxID = 0;
        for (News * news in _dataArray) {
            if (news.newsID.intValue>_lastMaxID) {
                _lastMaxID = news.newsID.intValue;
            }
        }
    }
    
    
    NSMutableSet * readedNewIdCacheSet = [CacheEngine getNewsReadedID];
    if (readedNewIdCacheSet !=nil) {
        _readedNewIdSet = readedNewIdCacheSet;
    }
    
    page    = 1;
}


- (void)initTable
{
    
    self.backgroundColor = K_color_line;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth - 64 - 50) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    [self loadRefresh];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArray != nil) {
        return _dataArray.count;
    }
    else{
        return 0;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    News    *news = nil;
    
    if (indexPath.row < _dataArray.count) {
        news = _dataArray[indexPath.row];
    }
    
    if (news != nil) {
        
        CGFloat sizeHeight = 0;
        CGFloat cellHeight = 0;
        CGFloat titleHeight = 30;
        CGFloat imageHeight = (ScreenWidth-40)*0.56;
        if ([news.picFlag isEqualToString:@"0"])//纯文字
        {
            NSString * summary = news.summary;
            if(summary.length>textStyleTextNum){
                summary = [NSString stringWithFormat:@"%@...",[summary substringToIndex:textStyleTextNum]];
            }
            sizeHeight = [Helper getSpaceLabelHeight:summary withFont:FontSize(newsContentFont) withLineSpace:lineSpace size:CGSizeMake(ScreenWidth-40, 1000) textlengthSpace:textLengthSpace paragraphSpacing:10];

            cellHeight = 10 + titleHeight +sizeHeight;
        }else if([news.picFlag isEqualToString:@"1"])//图文详情
        {
            cellHeight = 10+80*ScreenWidth/375;
        }else if([news.picFlag isEqualToString:@"2"])//纯图片
        {
            if ([DataUsedEngine nullTrim:news.bannerUrl]&&news.bannerUrl.length>0) {
                cellHeight = 10+titleHeight +imageHeight;
 
            }else{
                cellHeight = 10+titleHeight;

            }
        }else
        {
            NSString * summary = news.summary;
            if(summary.length>textStyleTextNum){
                summary = [NSString stringWithFormat:@"%@...",[summary substringToIndex:textStyleTextNum]];
            }
            sizeHeight = [Helper getSpaceLabelHeight:summary withFont:FontSize(newsContentFont) withLineSpace:lineSpace size:CGSizeMake(ScreenWidth-40, 1000) textlengthSpace:textLengthSpace paragraphSpacing:10];
            
            cellHeight = 10 + titleHeight +sizeHeight;
            
        
        }
        cellHeight = cellHeight +19+10;
        return cellHeight;
    }
    else{
        return 0;
    }
}

-(NewsPageCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    News    *news = nil;
    if (_dataArray.count > indexPath.row) {
        news = _dataArray[indexPath.row];
        if ([news.bannerUrl rangeOfString:@".jpeg"].location !=NSNotFound) {
            news.bannerUrl = [news.bannerUrl stringByReplacingOccurrencesOfString:@".jpeg" withString:@".png"];
            NSLog(@"%@",news.bannerUrl);
        }
    }
    
    if (news != nil) {
        news.readStatus = @"0";
        for (NSString * newsId in _readedNewIdSet) {
            if ([newsId isEqualToString:news.newsID]) {
                news.readStatus = @"1";
                break;
            }
        }
        //文字限制3行
        CGFloat sizeHeight = 0;
        CGFloat cellHeight = 0;
        CGFloat titleHeight = 30;
        CGFloat imageHeight = (ScreenWidth-40)*0.56;
        if ([news.picFlag isEqualToString:@"0"])//纯文字
        {
            NSString * summary = news.summary;
//            if(summary.length>textStyleTextNum){
//                
//                summary = [NSString stringWithFormat:@"%@...",[summary substringToIndex:textStyleTextNum]];
//            }
//            CGSize size = [DataUsedEngine getStringRectWithString:summary Font:13 Width:ScreenWidth - 40 Height:MAXFLOAT];
//            sizeHeight = size.height;
//            cellHeight = 10 + titleHeight +sizeHeight;
//            
//            
            if(summary.length>textStyleTextNum){
                summary = [NSString stringWithFormat:@"%@...",[summary substringToIndex:textStyleTextNum]];
            }
            sizeHeight = [Helper getSpaceLabelHeight:summary withFont:FontSize(newsContentFont) withLineSpace:lineSpace size:CGSizeMake(ScreenWidth-40, 1000) textlengthSpace:textLengthSpace paragraphSpacing:10];
            
            cellHeight = 10 + titleHeight +sizeHeight;

        }else if([news.picFlag isEqualToString:@"1"])//图文详情(小图)
        {
            cellHeight = 10+80*ScreenWidth/375;
        }else if([news.picFlag isEqualToString:@"2"])//纯图片（大图）
        {
            if ([DataUsedEngine nullTrim:news.bannerUrl]&&news.bannerUrl.length>0) {
                cellHeight = 10+titleHeight +imageHeight;
                
            }else{
                cellHeight = 10+titleHeight;
                
            }
        }else{
            NSString * summary = news.summary;
//            if(summary.length>textStyleTextNum){
//                summary = [NSString stringWithFormat:@"%@...",[summary substringToIndex:textStyleTextNum]];
//            }
//            CGSize size = [DataUsedEngine getStringRectWithString:summary Font:13 Width:ScreenWidth - 40 Height:MAXFLOAT];
//            sizeHeight = size.height;
//            cellHeight = 10 + titleHeight +sizeHeight;
//            
            if(summary.length>textStyleTextNum){
                summary = [NSString stringWithFormat:@"%@...",[summary substringToIndex:textStyleTextNum]];
            }
            sizeHeight = [Helper getSpaceLabelHeight:summary withFont:FontSize(newsContentFont) withLineSpace:lineSpace size:CGSizeMake(ScreenWidth-40, 1000) textlengthSpace:textLengthSpace paragraphSpacing:10];
            
            cellHeight = 10 + titleHeight +sizeHeight;

        }
        cellHeight = cellHeight +19 +10;
        NewsPageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        if (!cell) {
            cell = [[NewsPageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL" CellHeight:cellHeight News:news];
        }else{
            [cell setCellHeight:cellHeight  News:news indexPath:indexPath];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }
    else{
        return [[NewsPageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"errorcell"];
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    News *news = nil;
    if (_dataArray.count > indexPath.row)
    {
        news = _dataArray[indexPath.row];
        NewsDetailPage   *newsDetailVC = [[NewsDetailPage alloc]init];
        newsDetailVC.news = news;
        self.pushBlock(newsDetailVC);
        
        //纪录用户已读
        [_readedNewIdSet addObject:news.newsID];
        [CacheEngine setNewsReadedID:_readedNewIdSet];
        
        //已读新闻至灰
        NewsPageCell * cell = [_tableView cellForRowAtIndexPath:indexPath];
        cell.titleLabel.textColor = cell.contextLabel.textColor = [UIColor lightGrayColor];
        news.readStatus = @"1";
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
    if ([_tableView.footer isRefreshing])
    {
        page++;
        _pageSize = 10;
        
        [self requestGo];
    }
}

-(void)refresh{
    if ([_tableView.header isRefreshing]) {
        page = 1;
        _pageSize = 10;
        [self requestGo];
    }
}
-(void)requestGo{
    [self getDataListWithPage:page];
}

#pragma mark 资讯列表数据

-(void)getDataListWithPage:(int)aPage{
    
    [DataEngine requestTogetNewsListWithPageNo:aPage PageSize:_pageSize completeBlock:^(BOOL SUCCESS, NSMutableArray *dataArray) {
        [self endLoading];
        int maxId = _lastMaxID;
        int newIdNum = 0;
        if (SUCCESS) {
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
                for (News* news in dataArray) {
                    if (news.newsID.intValue > _lastMaxID) {
                        newIdNum ++;
                        if (news.newsID.intValue>maxId) {
                            maxId = news.newsID.intValue;
                        }
                    }
                }
                _lastMaxID = maxId;
                
                _dataArray = [NSMutableArray arrayWithArray:dataArray];
                [CacheEngine setNewsInfoWithCache:_dataArray];
            }
        }
        [_tableView reloadData];
        if (page > 1 && (dataArray == nil || dataArray.count == 0))
        {
            page--;
        }
        if(newIdNum>10){
            newIdNum = 10;
        }
        if (page == 1) {
            __block UILabel * remindLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 28)];
            remindLab.text = newIdNum==0?@"暂无信息更新":[NSString stringWithFormat:@"有%d条信息更新",newIdNum];
            remindLab.alpha = 1;
            remindLab.font = [UIFont systemFontOfSize:12];
            remindLab.textAlignment = NSTextAlignmentCenter;
            remindLab.textColor = K_COLOR_CUSTEM(58, 128, 181, 1);
            remindLab.backgroundColor = K_COLOR_CUSTEM(170, 205, 225, 1);
            [self addSubview:remindLab];
            _tableView.frame = CGRectMake(0, 28, ScreenWidth, ScreenHeigth-92-50);
            [UIView animateWithDuration:1.5 delay:1 options:UIViewAnimationOptionOverrideInheritedDuration animations:^{
                remindLab.alpha = 0.3;
            } completion:^(BOOL finished) {
                [remindLab removeFromSuperview];
                [self tableViewBack];
                remindLab = nil;
            }];
        }
    }];
}
- (void)tableViewBack
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionOverrideInheritedDuration animations:^{
        _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth-64-50);
    } completion:^(BOOL finished) {
    }];
}
@end
