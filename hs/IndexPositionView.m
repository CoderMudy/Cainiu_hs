//
//  IndexPositionView.m
//  hs
//
//  Created by RGZ on 15/7/24.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "IndexPositionView.h"
#import "IndexViewController.h"
#import "IndexPositionCell.h"
#import "IndexPositionTopView.h"
#import "NetRequest.h"
#import "IndexPositionDataModels.h"
#import "MJRefresh.h"
#import "IndexPositionDetailController.h"
#import "IndexPositionDetailModel.h"
#import "MarketModel.h"
#import "FoyerProductModel.h"
#import "HandlePosiData.h"


#define headerHeight 40*ScreenWidth/375

@interface IndexPositionView ()
{
    
    int _searchRow;
    NSString * _marketStatus;
    FoyerProductModel * _productModel;
    int _saleSearchNum;//平仓时轮询次数
    BOOL _isSelf_On;//是否继续查询
    BOOL _isKeySale;//是否为闪电平仓
    
}
//@property (nonatomic,strong)UIButton * searchBtn;
@end

@implementation IndexPositionView

-(instancetype)initWithFrame:(CGRect)frame withProductModel:(FoyerProductModel*)model
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = k_color_whiteBack;
        _positionListArray = [NSMutableArray array];
        _productModel = model;
        [self initTableView];
        [self registNsnotification];
    }
    
    return self;
}
#pragma mark 闪电平仓
/**
 *闪电平仓
 */
- (void)keySaleOrder
{
    _isKeySale = YES;
 
    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.tag = 1000001;
    [self saleRequestSystemWithSaleOrderArray:_positionListArray saleButton:moreBtn];
    
    [self performSelector:@selector(saleMore) withObject:nil afterDelay:0.5];
}


- (void)saleMore
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 1000002;
    [self saleRequestSystemWithSaleOrderArray:_positionListArray saleButton:button];


}
//接收通知
- (void)registNsnotification
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSocketData:) name:kSocket_Buy object:nil];
    
}
#pragma mark 接到通知刷新收益
- (void)getSocketData:(NSNotification*)Info
{
    
    if(Info){
        NSDictionary * userInfo = Info.userInfo;
        if (userInfo[@"instrumentID"] != nil && ![userInfo[@"instrumentID"] isKindOfClass:[NSNull class]])
        {
            if ([userInfo[@"instrumentID"] isEqualToString:self.indexCode])
            {
                NSString * lastAskPrice = [NSString stringWithFormat:@"%@",_askPrice];
                NSString * lastBidPrice = [NSString stringWithFormat:@"%@",_bidPrice];
                
                if (userInfo[@"askPrice1"]!=nil && ![userInfo[@"askPrice"] isKindOfClass:[NSNull class]])
                {
                    if ([userInfo[@"askPrice1"] floatValue]!=0)
                    {
                        _askPrice = [NSString stringWithFormat:@"%@", userInfo[@"askPrice1"]];
                    }
                }
                if (userInfo[@"bidPrice1"]!=nil && ![userInfo[@"bidPrice1"] isKindOfClass:[NSNull class]])
                {
                    if ([userInfo[@"bidPrice1"] floatValue]!=0)
                    {
                        _bidPrice = [NSString stringWithFormat:@"%@",userInfo[@"bidPrice1"]];
                    }
                }
                if (_superVC.isSecondJump&&_positionListArray.count>0)
                {
                    if (lastAskPrice !=_askPrice ||lastBidPrice !=_bidPrice)
                    {
                        [self loadSelfView];
                    }
                }else{
                    [self loadPositionData];
                }
            }
        }
    }
}
- (void)initTableView
{
    float  spPercent = 5;
    if (ScreenHeigth <= 568 && ScreenHeigth > 480) {
        spPercent = 4.5;
    }
    else if (ScreenHeigth <= 480){
        spPercent = 4.0;
    }
    float startHeight = ScreenHeigth/spPercent ;
    
    float tabHeight = ScreenHeigth- startHeight-40;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,tabHeight)];
    _tableView.backgroundColor = k_color_whiteBack;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview: _tableView];
    [self initRefresh];
    __weak  typeof(self) weakSelf = self;
    
    __block NSArray * posiListArray = (NSArray*)_positionListArray;
    [_tableView registerClass:[IndexPositionCell class] forCellReuseIdentifier:@"indexCell"];
    _headerView = [[IndexPositionTopView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,headerHeight) withItemProductModel:_productModel];
    _headerView.aKeySaleBlock= ^(UIButton *button){
        [weakSelf saleRequestSystemWithSaleOrderArray:posiListArray saleButton:button];
    };
    _headerView.buyBlock = ^(){
        [weakSelf blockManager];
    };
    _tableView.tableHeaderView = _headerView;
    
    UIView  *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1.5)];
    lineView.backgroundColor = Color_Gold;
    [self addSubview:lineView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 5, 36, 13);
    [closeButton setImage:[UIImage imageNamed:@"tactics_Close"] forState:UIControlStateNormal];
    closeButton.center = CGPointMake(self.frame.size.width/2, closeButton.frame.size.height/2);
    [closeButton addTarget:self action:@selector(closePositionView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    
    UIButton *closeButton_enlargeClick = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton_enlargeClick.frame = CGRectMake(0, 0, self.frame.size.width/3, 30);
    closeButton_enlargeClick.center = CGPointMake(self.frame.size.width/2, closeButton_enlargeClick.frame.size.height/2);
    [closeButton_enlargeClick addTarget:self action:@selector(closePositionView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton_enlargeClick];
    
    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(closePositionView)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionDown;
    [closeButton_enlargeClick addGestureRecognizer: swipeGes];
    

}

#pragma mark 关闭 操作

-(void)closePositionView{

    [self blockManager];
    
}

#pragma mark
#pragma mark 平仓__1__请求平仓时间
- (void)saleRequestSystemWithSaleOrderArray:(NSArray*)saleOrderArray saleButton:(UIButton *)button
{
    
//    NSString * days = [[SystemSingleton sharedInstance].timeString stringByAppendingString:@" 00:00:00"];
    [ManagerHUD showHUD:_superVC.view animated:YES andAutoHide:3];
    __block NSString * systemTime;
    [DataEngine requestToGetSystemDateWithComplete:^(BOOL SUCCESS, NSString *data , NSString *timeInterval)
     {
         [ManagerHUD hidenHUD];
        if (SUCCESS)
        {
            systemTime = data;
        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            systemTime = [dateFormatter stringFromDate:[NSDate date]];
        }
        [self getOrderIdWithClickBtn:button saleOrderArray:saleOrderArray saleDate:systemTime];
    }];
    
    
}

#pragma mark 平仓__2__转换json格式的OrderId

- (void)getOrderIdWithClickBtn:(UIButton*)button saleOrderArray:(NSArray*)saleOrderArray saleDate:(NSString *)saleDate
{
    int tradeType = 0;
    if (button.tag==1000001)//一键平多
    {
        tradeType = 0;
    }else if(button.tag==1000002)//一键平空
    {
        
        tradeType = 1;
    }else if(button.tag==1000003)//闪电平仓
    {
        tradeType =3;
    }else
    {//单个订单平仓
        IndexPositionList * orderModel = saleOrderArray[0];
        tradeType = orderModel.tradeType;
    }
    NSMutableArray * orderIdArray =[NSMutableArray array];
    NSMutableString *cashMutableStr=[[NSMutableString alloc] initWithString:@""] ;
    NSMutableString *scoreMutableStr=[[NSMutableString alloc] initWithString:@""] ;
    NSString  * cashStr= @"";
    NSString  * scoreStr = @"";
    
    if (tradeType==3) {
        for (IndexPositionList * orderModel in saleOrderArray)
        {
            if (orderModel.status>=4) {
                break;
            }
            if (orderModel.fundType==0) {//现金
                if (orderModel.listIdentifier)
                {
                    [cashMutableStr  appendString:[NSString stringWithFormat:@"%.0f,",orderModel.listIdentifier]];
                }
            }else if(orderModel.fundType ==1)
            {//积分
                if (orderModel.listIdentifier)
                {
                    [scoreMutableStr appendString:[NSString stringWithFormat:@"%.0f,",orderModel.listIdentifier]];
                }
            }
        }
        

    }else{
        for (IndexPositionList * orderModel in saleOrderArray)
        {
            if (orderModel.status>=4) {
                break;
            }
            if ((int)orderModel.tradeType ==tradeType)
            {
                if (orderModel.fundType==0) {//现金
                    if (orderModel.listIdentifier)
                    {
                        [cashMutableStr  appendString:[NSString stringWithFormat:@"%.0f,",orderModel.listIdentifier]];
                    }
                }else if(orderModel.fundType ==1)
                {//积分
                    if (orderModel.listIdentifier)
                    {
                        [scoreMutableStr appendString:[NSString stringWithFormat:@"%.0f,",orderModel.listIdentifier]];
                    }
                }
            }
        }
    }
    
    if (cashMutableStr.length>0)
    {
        cashStr  = [cashMutableStr substringToIndex:cashMutableStr.length-1];
    }
    if (scoreMutableStr.length>0)
    {
        scoreStr  = [scoreMutableStr substringToIndex:scoreMutableStr.length-1];
    }
    if (cashMutableStr.length<=0&&scoreMutableStr.length<=0) {
        return;
    }
    
    NSDictionary * cashDic = @{@"fundType":@"0",@"orderId":cashStr};
    [orderIdArray addObject:cashDic];
    
    NSDictionary * scoreDic = @{@"fundType":@"1",@"orderId":scoreStr};
    [orderIdArray addObject:scoreDic];
    
    NSString * saleOrderId = [Helper toJSON:orderIdArray];
    
    [self saleRequestWithDate:saleDate tradeType:tradeType saleOrderId:saleOrderId ischeck:@"true"];
    
}

#pragma mark 平仓__3__发送平仓请求
- (void)saleRequestWithDate:(NSString*)saleDate tradeType:(int)tradeType saleOrderId:(NSString*)saleOrderId ischeck:(NSString*)isCheck
{
    
    NSString * salePrice = tradeType==0?_bidPrice:_askPrice;
    __block NSString * saleDataB = saleDate;
    __block int tradeTypeB = tradeType;
    __block NSString * saleOrderIdB = saleOrderId;
    NSLog(@"%d,%@",tradeType,saleOrderIdB);
    [RequestDataModel requestSaleOrderWithOrderID:saleOrderId salePrice:salePrice saleDate:saleDate shouldCheckPrice:isCheck SuccessBlock:^(BOOL success, NSMutableArray *mutableArray,NSDictionary * errorDic)
     {
        [ManagerHUD hidenHUD];
        if (success)
        {
            _saleSearchNum = 0;
            [self modifiDataWith:mutableArray];
            NSLog(@"成功%d  %@",tradeTypeB,mutableArray);
        }else
        {
            NSLog(@"失败%d  %@",tradeTypeB,[Helper toJSON:errorDic]);
            if (errorDic)
            {
             //行情异常
                if ([errorDic[@"code"] intValue]==44032)
                {
                    NSString * msg = [NSString stringWithFormat:@"%@",errorDic[@"msg"]];
                    NSMutableArray *msgArray = [NSMutableArray arrayWithArray:[msg componentsSeparatedByString:@"|"]];
                    NSString * cashProfit = [NSString stringWithFormat:@"%@",errorDic[@"data"][@"cashLossProfit"]];
                    NSString * scoreProfit =[NSString stringWithFormat:@"%@",errorDic[@"data"][@"scoreLossProfit"]];
                    NSString * unit = _productModel.currencyUnit;//[Helper unitWithCurrency:_productModel.currency];
                    
                    cashProfit = [[DataEngine sharedInstance] trimString:cashProfit];
                    scoreProfit = [[DataEngine sharedInstance] trimString:scoreProfit];
               
                    [[UIEngine sharedInstance] showAlertWithSellingWithTitle:[[DataEngine sharedInstance] trimString:msgArray[0]]  Message:[[DataEngine sharedInstance] trimString:msgArray[1]] Money:cashProfit MoneyUnit:unit Integral:scoreProfit];
                    [UIEngine sharedInstance].alertClick = ^(int aIndex)
                    {
                        switch (aIndex)
                        {
                            case 10087:
                            {
                                //重新发送平仓请求 isNeedCheck ＝ NO；
                                [self saleRequestWithDate:saleDataB tradeType:tradeTypeB saleOrderId:saleOrderIdB ischeck:@"false"];
                            }
                                break;
                                
                            default:
                                _isKeySale = NO;
                                break;
                        }
                    };
                }else {
                    _isKeySale = NO;
                    PopUpView * popView = [[PopUpView alloc] initShowAlertWithShowText:errorDic[@"msg"] setBtnTitleArray:@[@"确定"]];
                    popView.confirmClick = ^(UIButton *button){};
                    [self.superVC.navigationController.view addSubview:popView];
                }
            }
        }
    }];
}
#pragma mark 平仓__4__处理(平仓/轮询)返回数据
- (void)modifiDataWith:(NSMutableArray*)mutableArray
{
    if (!_isSelf_On)
    {
        return;
    }
    int successNum = 0;
    _saleSearchNum++;
    if (_saleSearchNum>=10)
    {
        _enable = NO;
        return;
    }
    
    NSMutableString * unSucScoreOrderId = [[NSMutableString alloc] initWithString:@""];
    NSMutableString * unSucCashOrderId = [[NSMutableString alloc] initWithString:@""];
    
    for (NSDictionary * dic in mutableArray)
    {
        for (int i=0; i<_positionListArray.count; i++)
        {
            IndexPositionList *orderModel  = _positionListArray[i];
            
            if (dic[@"orderId"]&&[[NSString stringWithFormat:@"%@",dic[@"orderId"]] isEqualToString:[NSString stringWithFormat:@"%.0f",orderModel.listIdentifier]])
            {
                orderModel.status = [dic[@"status"] intValue];
                if (orderModel.status==6)
                {
                    successNum++;
                }else{
                    if (orderModel.fundType==0)
                    {
                        if (orderModel.listIdentifier)
                        {
                            [unSucCashOrderId appendString:[NSString stringWithFormat:@"%.0f,",orderModel.listIdentifier]];
                            
                        }
                        
                    }else{
                        if (orderModel.listIdentifier)
                        {
                            [unSucScoreOrderId appendString:[NSString stringWithFormat:@"%.0f,",orderModel.listIdentifier]];
                            
                        }
                        
                    }
                }
            }
            [_positionListArray replaceObjectAtIndex:i withObject:orderModel];
        }
    }
    
    
    if (successNum<mutableArray.count)
    {
        if (_saleSearchNum<15)
        {
            NSString * scoreOrderId = (NSString*)unSucScoreOrderId;
            if (scoreOrderId.length>0)
            {
                scoreOrderId = [scoreOrderId substringToIndex:(int)scoreOrderId.length-1];
                
            }
            NSString * cashOrderId = (NSString*)unSucCashOrderId;
            if (cashOrderId.length>0)
            {
                cashOrderId = [cashOrderId substringToIndex:(int)cashOrderId.length-1];
                
            }
            
            NSDictionary * scoreDic = @{@"fundType":@"1",@"orderId":scoreOrderId};
            NSDictionary * cashDic =@{@"fundType":@"0",@"orderId":cashOrderId};
            NSString * orderId = [Helper toJSON:@[scoreDic,cashDic]];
            
            
            [self searchSaleStatusWithOrderId:orderId mutableArray:mutableArray];
        }
    }else{
        if(_isKeySale)
        {
            _isKeySale = NO;
            if (!self.superVC.isSecondJump) {
                [self requestListData];

            }
        }
    }
    
    
    [self loadSelfView];
}



#pragma mark 平仓__5__轮询平仓结果
- (void)searchSaleStatusWithOrderId:(NSString *)saleOrderId mutableArray:(NSArray*)hisMultableArray
{
    
    [RequestDataModel requestSearchSaleOrderStatusWith:saleOrderId SuccessBlock:^(BOOL success, NSMutableArray *mutableArray, NSString *errorMessage) {
        
        if (success)
        {
            [self performSelector:@selector(modifiDataWith:) withObject:mutableArray afterDelay:_saleSearchNum];
        }else{

            [self performSelector:@selector(modifiDataWith:) withObject:hisMultableArray afterDelay:_saleSearchNum];
        }
    }];
    
}

#pragma mark 视图出现
- (void)pageAppearRequestListData
{
    _isSelf_On = YES;
    [self requestListData];
}
#pragma mark 视图关闭
- (void)pageDisAppear;
{
    _isSelf_On = NO;
}
#pragma mark 请求持仓列表
- (void)requestListData
{

    NSString * futuresType = [_productModel.productID isEqualToString:@""]?@"1":_productModel.productID;
    __block NSInteger requestType;
    __block NSString * listType;
    if ([_productModel.loddyType isEqualToString:@"1"])
    {
        requestType = 0;
        listType = @"futuresCashOrderList";
    }else{
        requestType = 1;
        listType = @"futuresScoreOrderList";

    }
    
    [RequestDataModel requestFuturesListWithFuturesTypeWithFuturesType:[NSString stringWithFormat:@"%ld",(long)futuresType.integerValue] fundType:[NSString stringWithFormat:@"%ld",(long)requestType] successBlock:^(BOOL success, NSDictionary *dictionary)
     {
        if (success)
        {
            if (_positionListArray.count>0)
            {
                [_positionListArray removeAllObjects];
            }
            _indexPositionBaseModel = [IndexPositionBaseClass modelObjectWithDictionary:dictionary];
            for (NSDictionary * listDic in dictionary[@"data"][listType])
            {
                IndexPositionList * listModel = [IndexPositionList modelObjectWithDictionary:listDic];
                [_positionListArray insertObject:listModel atIndex:0];
            }
            _isPosi = _positionListArray.count>0?YES:NO;

        }
        if (_superVC.isSecondJump)
        {
            [self loadSelfView];
            [self endLoading];
            [self getMarketEndTime];
        }else{
            [self loadPositionData];
        }
        
    }];
}
#pragma mark 处理数据
- (void)loadPositionData
{
    IndexPositionData * posiDataModel = _indexPositionBaseModel.data;
    NSString * userFund = @"0.00";
    NSString * userScore = @"0.00";
    __block  NSString * userProfit = @"0.00";
    
    userFund = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[posiDataModel.usedAmt floatValue]]];
    userFund = [NSString stringWithFormat:@"%@",userFund];
    userScore = [DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%d",[posiDataModel.score intValue]]];
    userScore = [NSString stringWithFormat:@"%@",userScore];

    [HandlePosiData handlePosiHeaderDataWithModel:_productModel
                                        posiArray:_positionListArray
                                       emptyPrice:_askPrice
                                        morePrice:_bidPrice
                                       completion:^(BOOL isposi,NSString *profitStr, UIColor *textColor, NSInteger keSaleStyle, NSString *sign)
     {
         userProfit = [NSString stringWithFormat:@"%@%@",sign,profitStr];
         //在持仓页面：
         if (_superVC.isSecondJump)
         {
             _headerView = [_headerView loadPosiTopViewWithProfit:profitStr
                                                        textColor:textColor
                                                     keySaleStyle:keSaleStyle
                                                             sign:sign
                                                    salePriceMore:_askPrice
                                                        salePrice:_bidPrice];
         }
         NSString * userProfit = [NSString stringWithFormat:@"%@%@",sign,profitStr];
         NSString * fund ;
         if ([_productModel.loddyType isEqualToString:@"1"])
         {
             fund = userFund;
         }else{
             fund = userScore;
         }
         if (!_isPosi)
         {

             
             NSString * userProfit = @"0.00";
             _isPosi = NO;
             NSString * fund ;
             if ([_productModel.loddyType isEqualToString:@"1"])
             {
                 fund = userFund;
             }else{
                 fund = userScore;
             }
             if (self.superVC.isSecondJump)
             {
                 _headerView = [_headerView loadUnPosiTopViewWithUserFund:fund];
             }
             self.fundLoadBlock(_isPosi,fund,userProfit);
         }else{
             self.fundLoadBlock(_isPosi,fund,userProfit);
             
         }
     }];
    for (int i=0; i<_positionListArray.count; i++)
    {
        IndexPositionList * positionOrderModel = _positionListArray[i];
        HandlePosiData  * handle = [[HandlePosiData alloc] init];
        handle.orderStatesModifyBlock = ^(NSInteger orderStates,NSInteger row)
        {
            [self modefiState:(int)orderStates atRow:(int)row];
        };
        NSString * newprice;
        if (positionOrderModel.tradeType==0)
        {
            newprice = _bidPrice;
        }else{
            newprice = _askPrice;
        }
        [handle setPositionOrderWithModel:positionOrderModel newPrice:newprice productModel:_productModel row:i];
    }
}
- (void)loadSelfView
{
    _headerView = (IndexPositionTopView*)_tableView.tableHeaderView;
    if (_positionListArray.count>0)
    {
        _headerView.frame = CGRectMake(0, 0, ScreenWidth,headerHeight);
    }else
    {
        _headerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth-64);
        _indexPositionBaseModel.data.list = [NSArray array];
    }
    [self loadSelfFootView];
    [self loadPositionData];
    [_tableView reloadData];
    _tableView.tableHeaderView = _headerView;
}
- (void)loadSelfFootView
{
    
    UIView *  footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    
    if (_positionListArray.count>0) {
        UILabel * marketLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-40, 40)];
        marketLab.text = _marketStatus;
        marketLab.textColor = K_color_red;
        marketLab.font = [UIFont systemFontOfSize:12];
        marketLab.textAlignment = NSTextAlignmentCenter;
        [footView addSubview:marketLab];
        
    }
    _tableView.tableFooterView = footView;
    
}
#pragma mark 
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _positionListArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    IndexPositionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"indexCell" forIndexPath:indexPath];
    if (_positionListArray.count<=indexPath.row)
    {
        return cell ;
    }
    __block IndexPositionList * listModel = _positionListArray[indexPath.row];

    NSString * newprice;
    if (listModel.tradeType==0) {
        
        newprice = _bidPrice;
    }else{
        newprice = _askPrice;
    }
    [cell setPositionCellWithModel:listModel newPrice:newprice multiPle:_productModel.multiple.intValue decimalplaces:_productModel.decimalPlaces.intValue productModel:_productModel];
    cell.block = ^(NSDictionary * dictionary)
    {
        //用户点击平仓按钮执行操作
        UIButton * btn = (UIButton*)dictionary[@"saleBtn"];
        UILabel * lab  = (UILabel *)dictionary[@"saleLab"];
        [btn setTitle:@"买处理中" forState:UIControlStateNormal];
        lab.backgroundColor = K_COLOR_CUSTEM(89,89, 89, 1);
        btn.enabled = NO;
        NSArray * orderArray = @[listModel];
        [self saleRequestSystemWithSaleOrderArray:orderArray saleButton:btn];
    };
    cell.ourBlock = ^(NSString * state)
    {
        //订单达到止盈止损时修改订单状态值和订单显示状态
        [self modefiState:[state intValue] atRow:(int)indexPath.row];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_positionListArray.count>indexPath.row)
    {
        
        IndexPositionList * listModel = _positionListArray[indexPath.row];
        if(listModel.status==3)
        {
            
            IndexPositionDetailController * VC = [[IndexPositionDetailController alloc] init];
            VC.positionList = listModel;
            VC.name = self.indexName;
            VC.code = self.indexCode;
            VC.bidPrice = self.bidPrice;
            VC.askPrice = self.askPrice;
            VC.productModel = _productModel;
            [_superVC.navigationController pushViewController:VC animated:YES];
        }
            
    }
}
#pragma mark 修改订单状态
- (void)modefiState:(int)state atRow:(int)row
{
    if (_positionListArray.count>row) {
        IndexPositionList * listModel = _positionListArray[row];
        listModel.status = state;
        [_positionListArray replaceObjectAtIndex:row withObject:listModel];
    }
}
#pragma mark 获取市场交易时段

-(void)getMarketEndTime{
    _marketStatus = [IndexSingleControl sharedInstance].storaging;
}

-(void)blockManager{
    
    self.block();
}
#pragma mark Refresh 初始化下拉刷新

-(void)initRefresh{
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestListData)];
}

-(void)endLoading{
    [_tableView.header endRefreshing];
}





/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
