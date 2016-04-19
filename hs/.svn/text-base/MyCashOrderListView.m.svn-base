
//
//  MyCashOrderListView.m
//  hs
//
//  Created by PXJ on 15/11/24.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "MyCashOrderListView.h"
#import "MyCashOrderCell.h"
#import "CashOrderSucModel.h"
#import "CashPositionListModel.h"
#import "MJRefresh.h"

#define cellHeight 80

@interface MyCashOrderListView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString * _urlStr;
    NSString * _wareId;
    
}
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * sectionArray;
@property (nonatomic,strong)UIView * showBackV;

@end
@implementation MyCashOrderListView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        self.backgroundColor = Color_black;
        [self initData];
        [self initUI];
    }
    return self;
}
- (void)initData
{
    _dataArray = [NSMutableArray array];
    _sectionArray = [NSMutableArray array];
}
- (void)initUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = Color_black;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[MyCashOrderCell class] forCellReuseIdentifier:@"cashCell"];
    [self addSubview:_tableView];
    [self initRefresh];
    _showBackV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height)];
    _showBackV.backgroundColor = Color_black;
    _showBackV.hidden = YES;
    [self addSubview:_showBackV];
    UILabel * showLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)/3, ScreenWidth, 20)];
    showLab.text = @"暂无订单";
    showLab.backgroundColor = Color_black;
    showLab.textColor = K_color_lightGray;
    showLab.textAlignment = NSTextAlignmentCenter;
    showLab.font = FontSize(15);
    [_showBackV addSubview:showLab];
}
- (void)pageControl:(NSString * )urlStr wareId:(NSString*)wareId
{
    _wareId = wareId;
    _urlStr = urlStr;
    _pageSize = 10;
    _pageNo = 1;
    [self requestCashOrderListData];
}
- (void)requestCashOrderListData
{
    [RequestDataModel requestCashOrderListWithWareId:_wareId url:_urlStr pageNo:_pageNo pageSize:_pageSize successBlock:^(BOOL success, NSArray *array)
    {
        [self endLoading];
        if (success)
        {
            switch (self.myCashOrderListStyle)
            {
                case MyCashOrderListSuccess:
                {
                    NSString * time = @"";
                    NSMutableArray * mulArray = [NSMutableArray array];
                    if (_pageNo==1)
                    {
                        _sectionArray = [NSMutableArray array];
                    }else
                    {
                        CashOrderSucModel * model = [[_sectionArray lastObject] lastObject];
                        time = model.date;
                        mulArray = _sectionArray.lastObject;
                        [_sectionArray removeObjectAtIndex:_sectionArray.count-1];
                    }
                    for (int i=0; i<array.count; i++)
                    {
                        NSDictionary * dic = array[i];
                        CashOrderSucModel * model = [[CashOrderSucModel alloc] initWithDic:dic];
                        NSString * dateTime = model.date;
                        if ([time isEqualToString:@""])
                        {
                            time =  dateTime;
                            [mulArray addObject:model];
                        }else if ([dateTime isEqualToString:time])
                        {
                            [mulArray addObject:model];
                        }else
                        {
                            time = dateTime;
                            [_sectionArray addObject:mulArray];
                            mulArray = [NSMutableArray array];
                            [mulArray addObject:model];
                        }
                    }
                    if (mulArray.count>0)
                    {
                        [_sectionArray addObject:mulArray];
                    }
                }break;
                case MyCashOrderListSign:
                {
                    NSString * time = @"";
                    NSMutableArray * mulArray = [NSMutableArray array];
                    if (_pageNo==1)
                    {
                        _sectionArray = [NSMutableArray array];
                    }else {
                        CashPositionListModel * model = [[_sectionArray lastObject] lastObject];
                        time = [Helper timeTransform:model.createTime intFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"yyyy年MM月dd日"];
                        mulArray = _sectionArray.lastObject;
                        [_sectionArray removeObjectAtIndex:_sectionArray.count-1];
                    }
                    for (int i=0; i<array.count; i++)
                    {
                        NSDictionary * dic = array[i];
                        CashPositionListModel * model = [[CashPositionListModel alloc] initWithDic:dic];
                        NSString * dateTime = [Helper timeTransform:model.createTime intFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"yyyy年MM月dd日"];
                        if ([time isEqualToString:@""])
                        {
                            time =  dateTime;
                            [mulArray addObject:model];
                        }else if ([dateTime isEqualToString:time])
                        {
                            [mulArray addObject:model];
                        }else
                        {
                            time = dateTime;
                            [_sectionArray addObject:mulArray];
                            mulArray = [NSMutableArray array];
                            [mulArray addObject:model];
                        }
                    }
                    if (mulArray.count>0)
                    {
                        [_sectionArray addObject:mulArray];
                    }
                }break;
                case MyCashOrderListSet:
                {
                    NSString * time = @"";
                    NSMutableArray * mulArray = [NSMutableArray array];
                    if (_pageNo!=1)
                    {
                        CashPositionListModel * model = [[_sectionArray lastObject] lastObject];
                        time = [Helper timeTransform:model.createTime intFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"yyyy年MM月dd日"];
                        mulArray = _sectionArray.lastObject;
                        [_sectionArray removeObjectAtIndex:_sectionArray.count-1];
                    }else{
                        _sectionArray = [NSMutableArray array];
                    }
                    for (int i=0; i<array.count; i++)
                    {
                        NSDictionary * dic = array[i];
                        CashPositionListModel * model = [[CashPositionListModel alloc] initWithDic:dic];
                        NSString * dateTime = [Helper timeTransform:model.createTime intFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"yyyy年MM月dd日"];
                        if ([time isEqualToString:@""])
                        {
                            time =  dateTime;
                            [mulArray addObject:model];
                        }else if ([dateTime isEqualToString:time])
                        {
                            [mulArray addObject:model];
                        }else
                        {
                            time = dateTime;
                            [_sectionArray addObject:mulArray];
                            mulArray = [NSMutableArray array];
                            [mulArray addObject:model];
                        }
                    }
                    if (mulArray.count>0)
                    {
                        [_sectionArray addObject:mulArray];
                    }
                }break;
                case MyCashOrderListEnd:
                {
                    NSMutableArray * mulArray = [NSMutableArray array];
                    if (_pageNo!=1)
                    {
                        mulArray = _sectionArray.lastObject;
                        _sectionArray = [NSMutableArray array];
                    }
                    for (int i=0; i<array.count; i++)
                    {
                        NSDictionary * dic = array[i];
                        CashPositionListModel * model = [[CashPositionListModel alloc] initWithDic:dic];
                        [mulArray addObject:model];
                    }
                    if (mulArray.count>0)
                    {
                        [_sectionArray addObject:mulArray];
                    }
                }break;
                default:
                    break;
            }
            [_tableView reloadData];
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionNum;
    switch (self.myCashOrderListStyle)
    {
        case MyCashOrderListSuccess:  case MyCashOrderListSign: case MyCashOrderListSet:
        {
            sectionNum = _sectionArray.count;
        }
            break;
            
        default:
            sectionNum = 1;
            break;
    }
    if (sectionNum >0)
    {
        _showBackV.hidden = YES;
    }else
    {
        _showBackV.hidden = NO;
    }
    return sectionNum;
}
#pragma mark UITableViewDataSource,UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] init];
    CGFloat headerHeight;
    switch (self.myCashOrderListStyle)
    {
        case MyCashOrderListEnd:
        {
            headerHeight = 1;
        }break;
        case MyCashOrderListSuccess:
        {
            CashOrderSucModel * model = _sectionArray[section][0];
            headerHeight = 40;
            UILabel * dateLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, ScreenWidth, 15)];
            dateLab.textColor = K_color_lightGray;
            dateLab.font = FontSize(11*ScreenWidth/375);
            dateLab.text= [Helper timeTransform:model.date intFormat:@"yyyyMMdd" toFormat:@"yyyy年MM月dd日"];
            [view addSubview:dateLab];
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(20, headerHeight-1, ScreenWidth-40, 1)];
            line.backgroundColor = K_color_grayLine;
            [view addSubview:line];
            
        }break;
            
        case MyCashOrderListSign:case MyCashOrderListSet:
        {
            CashPositionListModel * model = _sectionArray[section][0];
            headerHeight = 40;
            UILabel * dateLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, ScreenWidth, 15)];
            dateLab.textColor = K_color_lightGray;
            dateLab.font = FontSize(11*ScreenWidth/375);
            dateLab.text= [Helper timeTransform:model.createTime intFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"yyyy年MM月dd日"];
            [view addSubview:dateLab];
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(20, headerHeight-1, ScreenWidth-40, 1)];
            line.backgroundColor = K_color_grayLine;
            [view addSubview:line];
        }break;
        default:
            break;
    }
    view.frame = CGRectMake(0, 0, ScreenWidth, headerHeight);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight;
    switch (self.myCashOrderListStyle)
    {
        case MyCashOrderListEnd:
        {
            headerHeight = 1;
        }break;
        default:
        {
            headerHeight = 40;
        }
            break;
    }
    return headerHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCashOrderCell * orderCell = [tableView dequeueReusableCellWithIdentifier:@"cashCell" forIndexPath:indexPath];
    orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    orderCell.myOrderCellStyle = (MyOrderCellStyle)self.myCashOrderListStyle;
    orderCell.myOrderBlock = ^(){
        [self concelOrderIndex:indexPath];
    };
    switch (self.myCashOrderListStyle)
    {
        case MyCashOrderListSuccess:  case MyCashOrderListSign: case MyCashOrderListSet:
        {
            [orderCell setCashOrderListCellDetail:_sectionArray[indexPath.section][indexPath.row] productModel:self.productModel];
        }
            break;
      
        case MyCashOrderListEnd:
        {
            [orderCell setCashOrderListCellDetail:nil productModel:self.productModel];
        }
            break;
        default:
            break;
    }
    return orderCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    switch (self.myCashOrderListStyle)
    {
        case MyCashOrderListSuccess:  case MyCashOrderListSign: case MyCashOrderListSet:
            num = [_sectionArray[section] count];
            break;
        default:
            num = _dataArray.count;
            break;
    }
    return num;
}
#pragma mark 撤单
- (void)concelOrderIndex:(NSIndexPath*)index
{
    __block CashPositionListModel * model =_sectionArray[index.section][index.row];
    NSString * urlStr;
    NSString * serialNo;
    if ([model.orderType isEqualToString:@"2"])
    {
        urlStr = K_Cash_revokeSet;//止盈止损撤单
        serialNo = model.billNo;
    }else
    {
        urlStr = K_Cash_revokeEntrust;// 委托撤单
        serialNo = model.serialNo;
    }
    [RequestDataModel requestCashRevokeOrderUrl:urlStr seriaNo:serialNo wareId:self.productModel.instrumentID orderId:model.orderId fDate:model.fDate  successBlock:^(BOOL success, NSDictionary *dictionary)
     {
        if (success)
        {
            model.orderStatus = @"2";
            [_sectionArray[index.section] replaceObjectAtIndex:index.row withObject:model];
            [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}
#pragma mark Refresh 初始化下拉刷新

-(void)initRefresh
{
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

-(void)loadMore{
    if (_sectionArray.count>0) {
        _pageNo +=1;
    }else{
        _pageNo = 1;
    }
    [self requestCashOrderListData];
}
-(void)endLoading{
    [_tableView.footer endRefreshing];
}

@end
