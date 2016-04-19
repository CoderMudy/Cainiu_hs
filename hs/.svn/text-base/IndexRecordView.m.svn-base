//
//  RecordView.m
//  hs
//
//  Created by PXJ on 15/7/28.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "IndexRecordView.h"
#import "IndexRecordCell.h"
#import "IndexRecordDetailPage.h"
#import "IndexSaleRecordPage.h"
#import "MJRefresh.h"
#import "FoyerProductModel.h"
#import "IndexRecordModel.h"
@interface IndexRecordView()<UITableViewDataSource,UITableViewDelegate>
{
    NSString * _urlStr;
    NSString * _wareId;
    NSInteger _pageSize;
    NSInteger _pageNo;
    NSMutableArray * _sectionArray;

    
}
@property (nonatomic,strong)UIView * showBackV;
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation IndexRecordView

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    [_showBackV removeFromSuperview];
    [_tableView removeFromSuperview];
    
}

- (id)initWithFrame:(CGRect)frame orderListStyle:(IndexRecordType)listStyle;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.indexRecordType = listStyle;
        self.backgroundColor = Color_black;
        [self initData];
        [self initUI];
        
    }
    return self;
}
- (void)initData
{
    _recordArray = [NSMutableArray array];
}
- (void)initUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = Color_black;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[IndexRecordCell class] forCellReuseIdentifier:@"RecordCell"];
    [_tableView registerClass:[IndexRecordCell class] forCellReuseIdentifier:@"Entrusted"];
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
//获取最新时间
- (void)loadNewData
{
    [DataEngine requestToGetSystemDateWithComplete:^(BOOL SUCCESS, NSString *data , NSString *timeInterval) {
        if (SUCCESS)
        {
            _systemTime = data;
        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            
            _systemTime = [dateFormatter stringFromDate:[NSDate date]];
        }

        switch (self.indexRecordType)
        {
            case IndexRecordTypeEntrustedRecordStyle :
            {
                NSString * time = @"";
                NSMutableArray * mulArray = [NSMutableArray array];
                if (_pageNo==1)
                {
                    _sectionArray = [NSMutableArray array];
                }else
                {
                    NSDictionary * dic = [[_sectionArray lastObject] lastObject];
                    IndexRecordModel * model = [IndexRecordModel modelObjectWithDictionary:dic];
                    time = [Helper timeTransform:model.buyDate intFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"yyyy年MM月dd日"];;
                    mulArray = _sectionArray.lastObject;
                    [_sectionArray removeLastObject];
                }
                for (int i=0; i<_recordArray.count; i++)
                {
                    NSDictionary * dic = _recordArray[i];
                    IndexRecordModel * model = [IndexRecordModel modelObjectWithDictionary:dic];
                    NSString * dateTime = [Helper timeTransform:model.buyDate intFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"yyyy年MM月dd日"];
                    if ([time isEqualToString:@""])
                    {
                        time =  dateTime;
                        [mulArray addObject:dic];
                    }else if ([dateTime isEqualToString:time])
                    {
                        [mulArray addObject:dic];
                    }else
                    {
                        time = dateTime;
                        [_sectionArray addObject:mulArray];
                        mulArray = [NSMutableArray array];
                        [mulArray addObject:dic];
                    }
                }
                if (mulArray.count>0)
                {
                    [_sectionArray addObject:mulArray];
                }
            }break;
            case IndexRecordTypeConditionsStyle:
            {
                NSString * time = @"";
                NSMutableArray * mulArray = [NSMutableArray array];
                if (_pageNo==1)
                {
                    _sectionArray = [NSMutableArray array];
                }else
                {
                    NSDictionary * dic = [[_sectionArray lastObject] lastObject];
                    IndexRecordModel * model = [IndexRecordModel modelObjectWithDictionary:dic];
                    time = [Helper timeTransform:model.createDate intFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"yyyy年MM月dd日"];
                    mulArray = _sectionArray.lastObject;
                    [_sectionArray removeLastObject];
                }
                for (int i=0; i<_recordArray.count; i++)
                {
                    NSDictionary * dic = _recordArray[i];
                    IndexRecordModel * model = [IndexRecordModel modelObjectWithDictionary:dic];
                    NSString * dateTime = [Helper timeTransform:model.createDate intFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"yyyy年MM月dd日"];
                    if ([time isEqualToString:@""])
                    {
                        time =  dateTime;
                        [mulArray addObject:dic];
                    }else if ([dateTime isEqualToString:time])
                    {
                        [mulArray addObject:dic];
                    }else
                    {
                        time = dateTime;
                        [_sectionArray addObject:mulArray];
                        mulArray = [NSMutableArray array];
                        [mulArray addObject:dic];
                    }
                }
                if (mulArray.count>0)
                {
                    [_sectionArray addObject:mulArray];
                }
            }break;
            case IndexRecordTypeEndStyle :
            {

            }break;

            default:
                break;
        }
        [_tableView reloadData];
    }];
}
- (void)pageControl:(NSString * )urlStr wareId:(NSString*)wareId
{
    _wareId = _productModel.instrumentCode;
    _urlStr = urlStr;
    _pageSize = 10;
    _pageNo = 1;
    [self requestSaleListData];
}
-(void)requestSaleListData
{
    NSString * fundType = [_productModel.loddyType isEqualToString:@"1"]?@"0":@"1";
    NSString * futuresType = [_productModel.productID isEqualToString:@""]?@"1":_productModel.productID;
    
    NSDictionary * dic =@{@"token":[[CMStoreManager sharedInstance] getUserToken],
                          @"fundType":fundType,
                          @"pageNo":[NSNumber numberWithInteger:_pageNo],
                          @"pageSize":[NSNumber numberWithInteger:_pageSize],
                          @"futuresType":futuresType};
    [NetRequest postRequestWithNSDictionary:dic url:_urlStr successBlock:^(NSDictionary *dictionary)
     {
         [ManagerHUD hidenHUD];
         [self endLoading];
         if ([dictionary[@"code"] intValue]==200)
         {
             switch (self.indexRecordType)
             {
                 case IndexRecordTypeEntrustedRecordStyle: case IndexRecordTypeConditionsStyle:
                 {
                     _recordArray = [NSMutableArray arrayWithArray:dictionary[@"data"]];

                 }
                     break;
                 case IndexRecordTypeEndStyle:
                 {
                     if(_pageNo==1)
                     {
                         _recordArray = [NSMutableArray arrayWithArray:dictionary[@"data"]];
                         
                     }else{
                         [_recordArray addObjectsFromArray:dictionary[@"data"]];
                     }
                 }
                 default:
                     
                     break;
             }
             
         }
         [self loadNewData];
     } failureBlock:^(NSError *error)
     {
         [ManagerHUD hidenHUD];
         [self endLoading];
     }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (self.indexRecordType)
    {
        case IndexRecordTypeEntrustedRecordStyle: case IndexRecordTypeConditionsStyle:
        {
          return _sectionArray.count;
        }
            break;
        case IndexRecordTypeEndStyle:
        {
            return 1;
        }
        default:
            break;
    }
    return 1;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (self.indexRecordType)
    {
        case IndexRecordTypeEntrustedRecordStyle: case IndexRecordTypeConditionsStyle:
        {
            NSArray * array = _sectionArray[section];
            return array.count;
        }
            break;
        case IndexRecordTypeEndStyle:
        {
            return _recordArray.count;
        }
        default:
            break;
    }
    return _recordArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = @"";
    NSDictionary * dic = [NSDictionary dictionary];

    switch (self.indexRecordType)
    {
        case IndexRecordTypeEntrustedRecordStyle: case IndexRecordTypeConditionsStyle:
        {
            identifier = @"Entrusted";
            dic = _sectionArray[indexPath.section][indexPath.row];
        }
            break;
        case IndexRecordTypeEndStyle:
        {
            identifier = @"RecordCell";
            dic = _recordArray[indexPath.row];
        }
        default:
            break;
    }

    IndexRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = Color_black;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    if ([identifier isEqualToString:@"RecordCell"])
    {
        [cell setCellWithDictionary:dic withSystemTime:_systemTime productModel:_productModel];
    }else{
        cell.cancelOrderBlock = ^(){
            //撤单
            [self cancelOrderWithIndexPath:indexPath];
        };
        [cell setEntrustedCellWithDictionary:dic withSystemTime:_systemTime productModel:_productModel cellStyle:(int)self.indexRecordType];
    }
    
    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    IndexRecordCell * cell = (IndexRecordCell *)[tableView cellForRowAtIndexPath:indexPath];
    [UIView animateWithDuration:0.2 animations:^{
        cell.backgroundColor = K_color_black;
    } completion:^(BOOL finished) {
        cell.backgroundColor = Color_black;
        if (self.indexRecordType == IndexRecordTypeEndStyle)
        {
            self.pageChangeBlock(_productModel,_recordArray[indexPath.row]);
        }
    }];
    
    
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    CGFloat rowHeight = 0.1;
    switch (self.indexRecordType)
    {
        case IndexRecordTypeEntrustedRecordStyle: case IndexRecordTypeConditionsStyle:
        {
            rowHeight = 80;
        }
            break;
        case IndexRecordTypeEndStyle:
        {
            rowHeight = 73*ScreenWidth/375;
        }
        default:
        
            break;
    }
    return rowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight =0.5;
    switch (self.indexRecordType)
    {
        case IndexRecordTypeEntrustedRecordStyle: case IndexRecordTypeConditionsStyle:
        {
            headerHeight = 40;
        }
            break;
        case IndexRecordTypeEndStyle:
        {
            headerHeight = 0.5;
        }
        default:
            
            break;
    }
    return headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] init];
    CGFloat headerHeight;
    switch (self.indexRecordType)
    {
        case IndexRecordTypeEndStyle:
        {
            headerHeight = 1;
        }break;
        case IndexRecordTypeEntrustedRecordStyle:
        {
            IndexRecordModel * model =  [IndexRecordModel modelObjectWithDictionary:_sectionArray[section][0]];
            headerHeight = 40;
            UILabel * dateLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, ScreenWidth, 15)];
            dateLab.textColor = K_color_lightGray;
            dateLab.font = FontSize(11*ScreenWidth/375);
            dateLab.text= [Helper timeTransform:model.buyDate intFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"yyyy年MM月dd日"];
            [view addSubview:dateLab];
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(20, headerHeight-1, ScreenWidth-40, 1)];
            line.backgroundColor = K_color_black;
            [view addSubview:line];
        }break;
        case IndexRecordTypeConditionsStyle:
        {
            IndexRecordModel * model =  [IndexRecordModel modelObjectWithDictionary:_sectionArray[section][0]];
            headerHeight = 40;
            UILabel * dateLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, ScreenWidth, 15)];
            dateLab.textColor = K_color_lightGray;
            dateLab.font = FontSize(11*ScreenWidth/375);
            dateLab.text= [Helper timeTransform:model.createDate intFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"yyyy年MM月dd日"];
            [view addSubview:dateLab];
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(20, headerHeight-1, ScreenWidth-40, 1)];
            line.backgroundColor = K_color_black;
            [view addSubview:line];
            
        }break;
      
        default:
            break;
    }
    view.frame = CGRectMake(0, 0, ScreenWidth, headerHeight);
    return view;
}
#pragma mark Refresh 初始化下拉刷新

-(void)initRefresh{
    
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

-(void)loadMore{
    switch (self.indexRecordType) {
        case IndexRecordTypeEndStyle:
        {
            if (_recordArray.count>0) {
                _pageNo +=1;
            }else{
                _pageNo = 1;
                [self endLoading];
                return;
            }
        }
            break;
        case IndexRecordTypeConditionsStyle:case IndexRecordTypeEntrustedRecordStyle:
        {
        
            if (_recordArray.count>=_pageSize) {
                _pageNo +=1;
            }else{
                [self endLoading];
                return;
            }
        }
        default:
            break;
    }
   
    [self requestSaleListData];
}

-(void)endLoading{
    [_tableView.footer endRefreshing];
}

#pragma mark 撤单
- (void)cancelOrderWithIndexPath:(NSIndexPath*)index
{
    NSDictionary * dic = _sectionArray[index.section][index.row];
    __block IndexRecordModel * model = [IndexRecordModel modelObjectWithDictionary:dic];
    NSString * conditionId = [NSString stringWithFormat:@"%.0f",model.internalBaseClassIdentifier];

    NSLog(@"--点击撤单--");
    NSString * fundType = [_productModel.loddyType isEqualToString:@"1"]?@"0":@"1";

    [RequestDataModel requestFuturesRevokeOrderFundType:fundType conditionId:conditionId successBlock:^(BOOL success, NSDictionary *dictionary) {
        if (success)
        {
            model.status = -1;
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:_sectionArray[index.section][index.row]];
            [dic setObject:[NSNumber numberWithInt:-1] forKey:@"status"];
            [_sectionArray[index.section] replaceObjectAtIndex:index.row withObject:dic];
            [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

@end
