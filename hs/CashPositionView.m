
//
//  CashPositionView.m
//  hs
//
//  Created by PXJ on 15/11/24.
//  Copyright © 2015年 luckin. All rights reserved.
//

#define tableHeaderHeight  300*ScreenWidth/375
#define bottomHeight  65*ScreenWidth/375
#define tableViewHeight (ScreenHeigth-64-bottomHeight)

#define control_GoBuyView 60000
#define control_KeySale 60001
#define control_SetRise 60002
#define control_GoSale 60003
#define fontText 11*ScreenWidth/375
#define bigFontText 15*ScreenWidth/375
#define Bottom_enable_Tag 61000
#define Bottom_freeze_Tag  61001
#define Bottom_assetnet_Tag 61002
#define RiskWarn_riskLab_Tag 61100
#define RiskWarn_detailLab_Tag 61101

#define Bottom_enable @"ENABLEMONEY" //可用资金
#define Bottom_freeze @"FREEZEMONEY" //冻结资金
#define Bottom_assetnet @"ASSETNETVALUE" //资产净值
#define Bottom_assettotal @"ASSETTOTALVALUE" //资产总值
#define Bottom_saferate  @"SAFERATE"  //风险率
#define Key_DecimalPlaces _productModel.decimalPlaces.intValue


#import "CashPositionView.h"
#import "CashPositonHeaderView.h"
#import "CashPositionCell.h"
#import "IndexViewController.h"
#import "IndexBuyView.h"
#import "MyCashOrderPage.h"
#import "CashPositionDataModel.h"
#import "CashPositionListModel.h"
#import "ClosePositionViewController.h"
#import "StopProfitViewController.h"
#import "CashKeySalePopView.h"
#import "CashKeySaleModel.h"
#import "SpotgoodsWebController.h"
#import "HandlePosiData.h"

@interface CashPositionView()<UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray * _orderDataArray;
    NSString * _askPrice; //看多价
    NSString * _bidPrice; //看空价
    NSString * _newPrice; //最新价
    BOOL _selectUnShowPopView; //闪电平仓时勾选不再显示弹窗
    NSDictionary * _userFundDic;
    
    NSString * upDownData; //涨幅
    BOOL _isSelf_On;//是否继续查询 是否在当前现货行情持仓页面
    
    
}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIView * bottomView;
@property (nonatomic,strong)CashPositionDataModel * positionDataModel;
@property (nonatomic,strong)UIView * riskWaringView;


@end
@implementation CashPositionView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark 初始化视图

- (id)initWithFrame:(CGRect)frame model:(FoyerProductModel*)productModel;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _productModel = productModel;
        [self registNsnotification];
        [self initData];
        [self initUI];
        //        [self loadTableView];
    }
    return self;
}
- (void)initData
{
    _askPrice = @"0";
    _bidPrice = @"0";
    if (!_orderDataArray)
    {
        _orderDataArray = [NSMutableArray array];
    }
}
- (void)initUI
{
    self.backgroundColor = Color_black;
    [self initTableView];
    [self initBottomView];
    [self initRistWaringVeiw];
}
- (void)initTableView
{
    CashPositonHeaderView * headerView = [[CashPositonHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tableHeaderHeight) model:self.productModel];
    headerView.clickBlock = ^(UIButton * button)
    {
        switch (button.tag)
        {
            case control_GoBuyView:
            {
                //               @"去行情";
                self.goBuyViewBlock();
            }
                break;
            case control_GoSale:
            {
                //               @"平仓";
                [self startSaleOrder];
            }
                break;
            case control_KeySale:
            {
                //               @"闪电平仓";
                [self getMaxSaleNum];
            }
                break;
            case control_SetRise:
            {
                //               @"止盈止损";
                [self setOrderProfitLoss];
            }
                break;
            default:
                break;
        }
    };
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tableViewHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = Color_black;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = headerView;
    [_tableView registerClass:[CashPositionCell class] forCellReuseIdentifier:@"cashPositionCell"];
    [self addSubview:_tableView];
}
#pragma mark - 初始化底部显示
- (void)initBottomView
{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, tableViewHeight, ScreenWidth, bottomHeight)];
    [self addSubview:_bottomView];
    _bottomView.backgroundColor = Color_black;
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    bottomLine.backgroundColor = K_color_grayLine;
    [_bottomView addSubview:bottomLine];
    NSArray * bottomArray = @[@"可用资金",@"持仓保证金",@"资产净值"];
    CGFloat bottomLength = (ScreenWidth-40)/3;
    for (int i=0; i<bottomArray.count; i++)
    {
        UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20 +bottomLength*i, 13*ScreenWidth/375, bottomLength, 16*ScreenWidth/375)];
        titleLab.text = bottomArray[i];
        titleLab.textColor = K_color_lightGray;
        titleLab.font = FontSize(fontText);
        titleLab.textAlignment = NSTextAlignmentCenter;
        [_bottomView addSubview:titleLab];
        
        UILabel  * valueLab = [[UILabel alloc] initWithFrame:CGRectMake(20+bottomLength*i, CGRectGetMaxY(titleLab.frame), bottomLength, 17*ScreenWidth/375)];
        valueLab.text = @"0.00";
        valueLab.tag = Bottom_enable_Tag+i;
        valueLab.textColor = [UIColor whiteColor];
        valueLab.textAlignment = NSTextAlignmentCenter;
        valueLab.font = FontSize(13*ScreenWidth/375);
        [_bottomView addSubview:valueLab];
    }
}
- (void)initRistWaringVeiw
{
    _riskWaringView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(_bottomView.frame)-30, ScreenWidth, 30)];
    _riskWaringView.backgroundColor = K_COLOR_CUSTEM(42, 32, 31, 1);
    _riskWaringView.hidden = YES;
    [self addSubview:_riskWaringView];
    
    UILabel * riskLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 90*ScreenWidth/375, 30)];
    riskLab.text = @"风险率89%";
    riskLab.textColor = K_color_red;
    riskLab.font = FontSize(bigFontText);
    riskLab.tag = RiskWarn_riskLab_Tag;
    [_riskWaringView addSubview:riskLab];
    
    UILabel * detailLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(riskLab.frame), 0, ScreenWidth/3, 30)];
    detailLab.text = @"资产总值 ¥5,234.32\n及时入金可避免强平损失";
    detailLab.textColor = K_color_lightGray;
    detailLab.font = FontSize(fontText);
    detailLab.tag = RiskWarn_detailLab_Tag;
    detailLab.numberOfLines = 0;
    [_riskWaringView addSubview:detailLab];
    
    UIButton * goldenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goldenBtn.frame = CGRectMake(ScreenWidth-80, 0, 60, 30);
    [goldenBtn addTarget:self action:@selector(goldenChange) forControlEvents:UIControlEventTouchUpInside];
    [_riskWaringView addSubview:goldenBtn];
    
    UILabel * goldenLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-75, 4, 55, 22)];
    goldenLab.layer.cornerRadius = 2;
    goldenLab.layer.masksToBounds = YES;
    goldenLab.textAlignment = NSTextAlignmentCenter;
    goldenLab.text = @"入金";
    goldenLab.font = FontSize(bigFontText);
    goldenLab.backgroundColor = K_color_red;
    goldenLab.textColor = [UIColor whiteColor];
    [_riskWaringView addSubview:goldenLab];
    
}

#pragma mark - 视图出现时加载请求
- (void)cashPosionViewAppear;
{
    //    请求成功后
    [self requestCashPositionOrder];
    [self requestUnSuccessOrder];
    [self requestUserFund];
    [self loadCashHeader];
}
#pragma mark 返回上层页面
- (void)close
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSocket_Positon object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPositionBosomPage object:nil];
    _isSelf_On = NO;
}

#pragma mark 视图关闭
- (void)cashPageDisAppear;
{
    _isSelf_On = YES;
}

#pragma mark 入金跳转
- (void)goldenChange
{
    SpotgoodsWebController * vc = [[SpotgoodsWebController alloc] init];
    vc.isDeposit = YES;
    [self.superVC.navigationController pushViewController:vc animated:YES];
}
#pragma mark
#pragma mark 通知____添加观察
- (void)registNsnotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUpdown:) name:kPositionBosomPage object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSocketData:) name:kSocket_Buy object:nil];
}
#pragma mark 通知____接收通知获取当前品种的涨幅
- (void)getUpdown:(NSNotification*)Info
{
    NSDictionary * userInfo = Info.object;
    if(Info)
    {
        
        if (userInfo[@"changePercent"]!=nil && ![userInfo[@"changePercent"] isKindOfClass:[NSNull class]])
        {
            upDownData = userInfo[@"changePercent"];
        }
    }
    
}
#pragma mark 通知____接收行情推的信息，最新买卖价
- (void)getSocketData:(NSNotification*)Info
{
    //askPrice :用户买价 市场卖价
    //bidPrice :用户卖价 市场买价
    //
    if(Info)
    {
        NSDictionary * userInfo = Info.userInfo;
        if (userInfo[@"instrumentID"] != nil && ![userInfo[@"instrumentID"] isKindOfClass:[NSNull class]])
        {
            if ([userInfo[@"instrumentID"] isEqualToString:self.productModel.instrumentCode])
            {
                if (userInfo[@"askPrice1"]!=nil && ![userInfo[@"askPrice1"] isKindOfClass:[NSNull class]])
                {
                    if ([userInfo[@"askPrice1"] floatValue]!=0)
                    {
                        _askPrice = userInfo[@"askPrice1"];
                        _positionDataModel.askPrice = _askPrice;
                    }
                }
                if (userInfo[@"bidPrice1"]!=nil && ![userInfo[@"bidPrice1"] isKindOfClass:[NSNull class]])
                {
                    if ([userInfo[@"bidPrice1"] floatValue]!=0)
                    {
                        _bidPrice = userInfo[@"bidPrice1"];
                        _positionDataModel.bidPrice = _bidPrice;
                    }
                }
                if (userInfo[@"lastPrice"]!=nil && ![userInfo[@"lastPrice"] isKindOfClass:[NSNull class]])
                {
                    if ([userInfo[@"lastPrice"] floatValue]!=0)
                    {
                        _newPrice = userInfo[@"lastPrice"];
                        if (_positionDataModel.newprice)
                        {
                            _positionDataModel.newprice = _newPrice;
                        };
                    }
                }
                [self loadCashHeader];
            }
        }
    }
}
#pragma mark 处理最新数据
- (void)loadCashHeader
{
    [HandlePosiData loadPushData:_positionDataModel
                    productModel:_productModel
                      completion:^(BOOL isPosition,
                                   NSString *profitStr,
                                   NSString *rise,
                                   NSString *sign,
                                   UIColor *profitColor)
     {
//         if (self.superVC.isSecondJump)
//         {//刷新现货持仓头部
//             
             CashPositonHeaderView * headerView = (CashPositonHeaderView *)_tableView.tableHeaderView;
             //                        [headerView  loadPushData:_positionDataModel];
             
             [headerView cashViewLoadPushData:isPosition
                                    profitStr:profitStr
                                      riseStr:rise
                                         sign:sign
                                  profitColor:profitColor];
             [self checkEntrustOrder];
//         }else
//         {//刷新现货行情收益
             NSString * enableFund = [NSString stringWithFormat:@"%@",_userFundDic[Bottom_enable]];
             enableFund= [NSString stringWithFormat:@"¥ %@",[Helper rangeFloatString:enableFund withDecimalPlaces:2]];
             NSString * userProfit = [NSString stringWithFormat:@"%@%@",sign,profitStr];
             NSLog(@"刷新现货行情页的收益————————%@,%@",userProfit,enableFund);
             self.fundLoadBlock(isPosition,enableFund,userProfit);
//         }
     }];
    
    
    
}
#pragma mark 委托列表__触发订单成交的条件
- (void)checkEntrustOrder
{
    if (_askPrice.floatValue!=0&&_bidPrice.floatValue!=0)
    {
        for (int i=0; i<_orderDataArray.count; i++)
        {
            CashPositionListModel * model = _orderDataArray[i];
            if ([model.orderType isEqualToString:@"2"])
            {
                //止盈止损单：
                if([model.buyOrSal isEqualToString:@"B"])
                {
                    //看多
                    if (model.upPrice.floatValue<=_bidPrice.floatValue)
                    {
                        [self searchOrderStatus:model index:i];
                    }else if(model.downPrice.floatValue>=_bidPrice.floatValue)
                    {
                        [self searchOrderStatus:model index:i];
                    }
                }else if([model.buyOrSal isEqualToString:@"S"])
                {
                    //看空
                    if (model.upPrice.floatValue>=_askPrice.floatValue)
                    {
                        [self searchOrderStatus:model index:i];
                    }else if(model.downPrice.floatValue<=_askPrice.floatValue)
                    {
                        [self searchOrderStatus:model index:i];
                    }
                }
            }else if([model.orderType isEqualToString:@"1"])
            {
                //限价多空单
                if([model.buyOrSal isEqualToString:@"B"])
                {
                    if (model.price.floatValue>=_askPrice.floatValue)
                    {
                        [self searchOrderStatus:model index:i];
                    }
                }else if([model.buyOrSal isEqualToString:@"S"])
                {
                    if (model.price.floatValue<=_bidPrice.floatValue)
                    {
                        [self searchOrderStatus:model index:i];
                    }
                }
            }else{
                //市价单不处理
            }
        }
    }
}
#pragma mark 查询订单状态
- (void)searchOrderStatus:(CashPositionListModel*)model index:(NSInteger)index
{
    __block CashPositionListModel * cashModel = model;
    __block NSInteger numIndex = index;
    [RequestDataModel requestCashEntrustDetailOrderId:model.orderId successBlock:^(BOOL success, NSDictionary *dictionary)
     {
         if (success)
         {
             CashPositionListModel * model = [[CashPositionListModel alloc] initWithDic:dictionary];
             
             if (model.orderStatus.intValue !=6)
             {
                 switch (model.orderStatus.intValue)
                 {
                     case -2:case -1:case -4://订单已撤销
                     {
                         
                         [self checkIsIndex:numIndex checkOrderId:model.serialNo];
                         [_tableView reloadData];
                         
                     }
                         break;
                     case 7://订单已成交
                     {
                         [self checkIsIndex:numIndex checkOrderId:model.serialNo];
                         [_tableView reloadData];
                         [self requestCashPositionOrder];
                         [self requestUserFund];
                     }
                         break;
                     default:
                         break;
                 }
             }else{
                 int num=0;//
                 if ([cashModel.orderType isEqualToString:@"0"]) {
                     if (cashModel.checkNum<15) {
                         if (cashModel.checkNum<5)
                         {
                             num =1;
                         }else if(cashModel.checkNum<15&&cashModel.checkNum>=5)
                         {
                             num = 2;
                         }
                         cashModel.checkNum +=num;
                         if (_orderDataArray.count>numIndex) {
                             CashPositionListModel * model = _orderDataArray[numIndex];
                             if ([model.serialNo isEqualToString:cashModel.serialNo]) {
                                 [_orderDataArray replaceObjectAtIndex:numIndex withObject:cashModel];
                                 [self performSelector:@selector(searchMarkeyOrderStatus:) withObject:@{@"model":cashModel,@"index":[NSNumber numberWithInteger:numIndex]} afterDelay:num];
                             }
                         }
                     }
                 }else if([cashModel.orderType isEqualToString:@"2"])
                 {//止盈止损单
                     if ([cashModel.state isEqualToString:@"B"]||[cashModel.state isEqualToString:@"D"])
                     {//B:已过期  D:已撤单
                         [self checkIsIndex:index checkOrderId:cashModel.serialNo];
                         [_tableView reloadData];
                         
                     }else if([cashModel.state isEqualToString:@"C"])
                     {//C:已触发
                         [self checkIsIndex:index checkOrderId:cashModel.serialNo];
                         [_tableView reloadData];
                         [self requestCashPositionOrder];
                         [self requestUserFund];
                         //已触发会生成新的市价委托单
                     }
                     //A:待触发 及其他情况不处理
                 }
             }
         }
     }];
}

- (void)searchMarkeyOrderStatus:(NSDictionary*)dic
{
    CashPositionListModel * model = (CashPositionListModel*)dic[@"model"];
    NSInteger index = [dic[@"index"] integerValue];
    [self searchOrderStatus:model index:index];
}

#pragma mark 点击查看更多 跳转订单 委托列表
- (void)goCashOrderPage
{
    MyCashOrderPage * vc = [[MyCashOrderPage alloc] init];
    vc.productModel = self.productModel;
    vc.myCashOrderStyle = MyCashOrderSign;
    [_superVC.navigationController pushViewController:vc animated:YES];
}
#pragma mark 获取持仓数据
- (void)requestCashPositionOrder
{
    NSString * wareId = self.productModel.instrumentID;
    [RequestDataModel requestCashPositionDataWareId:(NSString*)wareId successBlock:^(BOOL success, NSDictionary *dictionary)
     {
         if (success)
         {
             _positionDataModel = [[CashPositionDataModel alloc] initWithDic:dictionary];
             _positionDataModel.bidPrice = _bidPrice;
             _positionDataModel.askPrice = _askPrice;
             _positionDataModel.orderId  = @"";
             [self loadHeaderView];
         }
     }];
}
#pragma mark 获取未成功委托单
- (void)requestUnSuccessOrder
{
    NSString * wareId = self.productModel.instrumentID;
    [RequestDataModel requestCashUnSuccessSignList:(NSString *)wareId successBlock:^(BOOL success, NSArray *array)
     {
         if(success)
         {
             [_orderDataArray removeAllObjects];
             
             NSMutableArray * upDownArray = [NSMutableArray array];
             NSMutableArray * entrustArray = [NSMutableArray array];
             if (array.count>0) {
                 NSMutableArray * dataArray = [NSMutableArray arrayWithArray:array[0]];
                 BOOL isKeyOrderId = NO;
                 for (int i=0; i<dataArray.count; i++)
                 {
                     NSDictionary* dic  = dataArray[i];
                     CashPositionListModel * model = [[CashPositionListModel alloc] initWithDic:dic];
                     if ([model.orderType isEqualToString:@"2"])
                     {
                         [upDownArray addObject:model];
                     }else{
                         [entrustArray addObject:model];
                         if ([model.orderId isEqualToString:_positionDataModel.orderId])
                         {
                             isKeyOrderId = YES;
                         }
                     }
                 }
                 [_orderDataArray addObjectsFromArray:upDownArray];
                 [_orderDataArray addObjectsFromArray:entrustArray];
                 for ( int i = 0; i<_orderDataArray.count; i++)
                 {
                     CashPositionListModel * model = _orderDataArray[i];
                     if([model.orderType isEqualToString:@"0"])
                     {
                         model.checkNum = 0;
                         [self searchOrderStatus:model index:i];
                     }
                 }
                 if (_positionDataModel.orderId.length>0&&!isKeyOrderId) {
                     [self requestCashPositionOrder];
                     [self requestUserFund];
                 }
                 [_tableView reloadData];
             }
         }
     }];
}
#pragma mark 获取用户资金
- (void)requestUserFund
{
    [RequestDataModel requestCashUserFundSuccessBlock:^(BOOL success, NSDictionary *dictionary)
     {
         if (success)
         {
             _userFundDic = [NSDictionary dictionaryWithDictionary:dictionary];
             [self loadBottom];
             [self loadRiskWarnView];
         }
     }];
}

#pragma mark 数据请求成功 － 刷新页面
#pragma mark 刷新风险
- (void)loadRiskWarnView
{
    NSString * userFund = [NSString stringWithFormat:@"%@",_userFundDic[Bottom_assettotal]];
    userFund = [[DataEngine sharedInstance]trimString:userFund];
    userFund = [Helper rangeFloatString:userFund withDecimalPlaces:2];
    
    NSString * userSafeRate = [NSString stringWithFormat:@"%.2f",[_userFundDic[Bottom_saferate] floatValue]*100];
    userSafeRate = [userSafeRate substringToIndex:userSafeRate.length-3];
    userSafeRate = [NSString stringWithFormat:@"风险率 %@%%",userSafeRate];
    NSString * enableSaleNum = [NSString stringWithFormat:@"%@",_positionDataModel.enableSaleNum];
    if(enableSaleNum.floatValue>=1){
        
        if ([_userFundDic[Bottom_saferate] floatValue]>0.7) {
            _riskWaringView.hidden = NO;
            _tableView.frame = CGRectMake(0, 0, ScreenWidth, tableViewHeight-30);
            UILabel * riskLab = (UILabel *)[_riskWaringView viewWithTag:RiskWarn_riskLab_Tag];
            riskLab.text = [NSString stringWithFormat:@"%@",userSafeRate];
            UILabel * detailLab = (UILabel *)[_riskWaringView viewWithTag:RiskWarn_detailLab_Tag];
            detailLab.text = [NSString stringWithFormat:@"资产总值 ¥%@\n及时入金可避免强平损失",userFund];
        }else{
            _riskWaringView.hidden = YES;
            _tableView.frame = CGRectMake(0, 0, ScreenWidth, tableViewHeight);
        }
    }
}

#pragma mark 刷新资金
- (void)loadBottom
{
    NSDictionary * dic = _userFundDic;
    UILabel * enableLab = (UILabel*)[_bottomView viewWithTag:Bottom_enable_Tag];
    UILabel * freezeLab = (UILabel*)[_bottomView viewWithTag:Bottom_freeze_Tag];
    UILabel * assetnetLab = (UILabel*)[_bottomView viewWithTag:Bottom_assetnet_Tag];
    NSString * enableStr = [NSString stringWithFormat:@"%.2f",[dic[Bottom_enable] floatValue]];
    NSString * freezeStr = [NSString stringWithFormat:@"%.2f",_positionDataModel.account.intValue * _positionDataModel.price.floatValue *0.1];
    NSString * assetnetStr =[NSString stringWithFormat:@"%.2f",[dic[Bottom_assetnet] floatValue]];
    enableLab.text = [NSString stringWithFormat:@"¥ %@",[Helper rangeFloatString:enableStr withDecimalPlaces:2]];
    freezeLab.text =[NSString stringWithFormat:@"¥ %@",[Helper rangeFloatString:freezeStr withDecimalPlaces:2]];
    assetnetLab.text =[NSString stringWithFormat:@"¥ %@",[Helper rangeFloatString:assetnetStr withDecimalPlaces:2]];
}
#pragma mark刷新列表头
- (void)loadHeaderView
{
    //    if()
    CashPositonHeaderView * headerView = (CashPositonHeaderView *)_tableView.tableHeaderView;
    [headerView reloadCashPositionData:_positionDataModel ];
    [self loadCashHeader];
}
#pragma mark刷新整个列表
- (void)loadTableView
{
    //    [self loadHeaderView];
    [_tableView reloadData];
}

- (void)keySaleOrder
{
    [self getMaxSaleNum];
}
#pragma mark 获取最大可平仓数量
- (void)getMaxSaleNum
{
    [RequestDataModel requestCashSingleInfoWithWareId:_productModel.instrumentID successBlock:^(BOOL success, NSDictionary *dictionary) {
        NSString * maxSaleNum = _positionDataModel.account;
        
        if (success) {
            if ([_positionDataModel.buyOrSal isEqualToString:@"B"]) {
                maxSaleNum =[NSString stringWithFormat:@"%@", dictionary[@"MAXSQTY"]];
            }else{
                maxSaleNum =[NSString stringWithFormat:@"%@", dictionary[@"MAXBQTY"]];
                
            }
            maxSaleNum = [NSString stringWithFormat:@"%.0f",maxSaleNum.floatValue];
        }
        [self quickSaleOrder:maxSaleNum];
        
    }];
}

#pragma mark 闪电平仓——1
- (void)quickSaleOrder:(NSString*)maxSaleNum
{
    //不需要弹窗
    _positionDataModel.enableSaleNum = maxSaleNum;
    CashKeySaleModel * keySaleModel = [[CashKeySaleModel alloc] init];
    if ([_positionDataModel.buyOrSal isEqualToString:@"B"])
    {
        keySaleModel.nePrice = _bidPrice;
    }else
    {
        keySaleModel.nePrice = _askPrice;
    }
    CGFloat tmpPrice  =  _bidPrice.floatValue * _positionDataModel.account.floatValue *8/10000;
    keySaleModel.buyOrSal = _positionDataModel.buyOrSal;
    keySaleModel.productName = self.productModel.commodityName;
    keySaleModel.wareId = self.productModel.instrumentID;
    keySaleModel.num = maxSaleNum.intValue<_positionDataModel.account.intValue?maxSaleNum:_positionDataModel.account;
    keySaleModel.tmpMoney = [NSString stringWithFormat:@"%f",tmpPrice];
    keySaleModel.partKeySale = maxSaleNum.intValue<_positionDataModel.account.intValue?@"1":@"0";
    NSArray * titleArray = @[@"取消",@"确定"];
    if ([keySaleModel.partKeySale  isEqualToString:@"1"]) {
        titleArray = @[@"取消",@"查看委托单"];
    }
    _selectUnShowPopView = NO;
    CashKeySalePopView * popView = [[CashKeySalePopView alloc] initShowAlertWithInfo:keySaleModel setBtnTitleArray:titleArray productModel:self.productModel];
    popView.confirmClick = ^(UIButton *button)
    {
        switch (button.tag)
        {
            case 66667:
            {
                if ([keySaleModel.partKeySale isEqualToString:@"1"])
                {
                    [self goCashOrderPage];//跳转委托订单
                }else{
                    [self keySale];//闪电平仓
                }
            }break;
            case 66665:
            {
                //部分平仓
                [self partSale];
            }
                break;
            default:
                break;
        }
    };
    popView.selectMarkBlock = ^(BOOL select)
    {
        _selectUnShowPopView  = select;
    };
    [self.superVC.navigationController.view addSubview:popView];
    //    }
}
#pragma mark 闪电平仓——2
- (void)keySale
{
    //    NSString * keySaleName = [NSString stringWithFormat:@"%@%@",K_CashKeySaleCacheMark,self.productModel.instrumentCode];
    //    if (_selectUnShowPopView)
    //    {
    //        CacheModel *cacheModel = [CacheEngine getCacheInfo];
    //        cacheModel.cashSaleDic[keySaleName][K_CashKeySaleCacheMark] = @"1";
    //        [CacheEngine setCacheInfo:cacheModel];
    //    }
    //缓存数据 下次不再出现弹窗
    [ManagerHUD showHUD:self.superVC.view animated:YES];
    [RequestDataModel requestCashKeySaleWareId:self.productModel.instrumentID successBlock:^(BOOL success, NSDictionary *dictionary)
     {
         [ManagerHUD hidenHUD];
         if (success)
         {
             NSArray * array = [NSArray arrayWithObject:dictionary[@"data"][@"DATAS"]];
             NSDictionary * dic;
             NSString * orderId = @" ";
             if (array.count>0) {
                 NSArray * subArray = array[0];
                 if (subArray.count>0) {
                     dic = array[0][0];
                     orderId = [NSString stringWithFormat:@"%@",dic[@"orderId"]];
                 }
             }
             [self showPopViewSuc:orderId];
         }else if(dictionary.count>0)
         {
             [self showPopViewWithMsg:dictionary[@"msg"]];
         }
     }];
}
#pragma mark 部分平仓
- (void)partSale
{
    
    NSString * price;
    NSString * buyOrSal = @" ";
    if ([self.positionDataModel.buyOrSal isEqualToString:@"B"])
    {
        buyOrSal = @"S";
        price  = _bidPrice;
    }else{
        buyOrSal = @"B";
        price = _askPrice;
    }
    [RequestDataModel requestCashPartSaleWareId:self.positionDataModel.wareId buyOrSal:buyOrSal price:price saleNum:self.positionDataModel.enableSaleNum successBlock:^(BOOL success, NSDictionary *dictionary)
     {
         if (success)
         {
             NSArray * array = [NSArray arrayWithObject:dictionary[@"data"][@"DATAS"]];
             NSDictionary * dic;
             NSString * orderId = @" ";
             if (array.count>0)
             {
                 NSArray * subArray = array[0];
                 if (subArray.count>0)
                 {
                     dic = array[0][0];
                     orderId = [NSString stringWithFormat:@"%@",dic[@"orderId"]];
                 }
             }
             [self showPopViewSuc:orderId];
         }else if(dictionary.count>0)
         {
             [self showPopViewWithMsg:dictionary[@"msg"]];
         }
     }];
    
}
#pragma mark 闪电平仓成功
- (void)cashKeySaleSuccess
{
    [self requestUnSuccessOrder];
}
#pragma mark 平仓
- (void)startSaleOrder
{
    ClosePositionViewController * vc = [[ClosePositionViewController alloc] init];
    vc.productModel = self.productModel;
    if([self.positionDataModel.buyOrSal isEqualToString:@"B"])
    {
        vc.buyOrSal = @"S";
        vc.price  = _bidPrice;
    }else
    {
        vc.buyOrSal = @"B";
        vc.price = _askPrice;
    }
    vc.updownData = upDownData;
    vc.num = self.positionDataModel.account;
    [self.superVC.navigationController pushViewController:vc animated:YES];
}
#pragma mark 止盈止损
- (void)setOrderProfitLoss
{
    StopProfitViewController * vc = [[StopProfitViewController alloc] init];
    vc.productModel = self.productModel;
    vc.num = self.positionDataModel.account;
    vc.buyOrSal = self.positionDataModel.buyOrSal;
    if ([vc.buyOrSal isEqualToString:@"B"]) {
        vc.price = _askPrice;
    }else{
        vc.price = _bidPrice;
    }
    vc.updownData = upDownData;
    [self.superVC.navigationController pushViewController:vc animated:YES];
}

#pragma mark 撤单
- (void)concelOrderIndex:(int)index
{
    if (_orderDataArray.count<=index) {
        return;
    }
    __block CashPositionListModel * model = _orderDataArray[index];
    __block  NSString * orderType;
    NSString * urlStr;
    NSString * serialNo;
    if ([model.orderType isEqualToString:@"2"])
    {
        urlStr = K_Cash_revokeSet;//止盈止损撤单
        orderType = @"止盈止损";
        serialNo = model.billNo;
    }else
    {
        urlStr = K_Cash_revokeEntrust;// 委托撤单
        orderType = @"多空委托单";
        serialNo = model.serialNo;
    }
    [RequestDataModel requestCashRevokeOrderUrl:urlStr seriaNo:serialNo wareId:self.productModel.instrumentID orderId:model.orderId fDate:model.fDate successBlock:^(BOOL success, NSDictionary *dictionary)
     {
         if(success)
         {
             [self checkIsIndex:index checkOrderId:model.serialNo];
             [self requestUserFund];
             [_tableView reloadData];
         }else if (dictionary)
         {
             [UIEngine showShadowPrompt:dictionary[@"msg"]];
         }
     }];
}
- (void)checkIsIndex:(NSInteger)index checkOrderId:(NSString *)serialNo
{
    if (_orderDataArray.count>index) {
        CashPositionListModel * model = _orderDataArray[index];
        if ([model.serialNo isEqualToString:serialNo]) {
            [_orderDataArray removeObjectAtIndex:index];
        }
    }
}
#pragma mark  平仓成功弹窗
- (void)showPopViewSuc:(NSString *)orderId
{
    CashKeySalePopView * popView = [[CashKeySalePopView alloc] initShowSucWithTitleArray:@[@"确定"]];
    popView.confirmClick = ^(UIButton * button)
    {
        if (button.tag==66665)
        {
            [self goCashOrderPage];//跳转委托订单
        }else if(button.tag ==66666)
        {
            _positionDataModel.orderId = [[DataEngine sharedInstance] trimString:orderId];
            [self cashKeySaleSuccess];//闪电平仓委托成功
        }
    };
    [self.superVC.navigationController.view addSubview:popView];
    
}
#pragma mark  普通弹窗
- (void)showPopViewWithMsg:(NSString *)msg
{
    PopUpView * popView = [[PopUpView alloc] initShowAlertWithShowText:msg setBtnTitleArray:@[@"确定"]];
    popView.confirmClick = ^(UIButton *button)
    {
    };
    [self.superVC.navigationController.view addSubview:popView];
    
}


#pragma mark UITableViewDataSource,UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_orderDataArray.count==0)
    {
        CGFloat height = tableViewHeight -tableHeaderHeight;
        return height;
    }else
    {
        //        return 50;
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_orderDataArray.count==0)
    {
        return 1;
    }else
    {
        return 40;
    }
}
- (UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = Color_black;
    UIImageView * imgV = [[UIImageView alloc] init];
    [view addSubview:imgV];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:button];
    if (_orderDataArray.count ==0)
    {
        view.frame = CGRectMake(0, 0, ScreenWidth, tableViewHeight -tableHeaderHeight);
        imgV.center = CGPointMake(view.center.x,view.center.y*4/5);
        imgV.bounds = CGRectMake(0, 0, 85, 46);
        imgV.image = [UIImage imageNamed:@"CashPosition_5"];
    }else if(_orderDataArray.count>=10)
    {
        view.frame = CGRectMake(0, 0, ScreenWidth, 0);
        //        view.frame = CGRectMake(0, 0, ScreenWidth, 50);
        //        imgV.center = CGPointMake(view.center.x, view.center.y*6/5);
        //        imgV.bounds = CGRectMake(0, 0, 63*3/2, 9*3/2);
        //        imgV.image = [UIImage imageNamed:@"CashPosition_9"];
        //        [button addTarget:self  action:@selector(goCashOrderPage) forControlEvents:UIControlEventTouchUpInside];
    }
    button.frame = view.frame;
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray * array = @[@"委托时间",@"类型",@"委托量",@"委托价"];
    CGFloat labLength = (ScreenWidth-30)/6;
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = Color_black;
    if (_orderDataArray.count>0)
    {
        view.frame = CGRectMake(0, 0, ScreenWidth, 30);
        for (int i=0; i<array.count; i++)
        {
            UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(20+labLength*i, 10, labLength, 20)];
            lab.font = FontSize(fontText);
            lab.text = array[i];
            lab.textColor = K_color_lightGray;
            lab.textAlignment = NSTextAlignmentCenter;
            lab.backgroundColor = Color_black;
            [view addSubview:lab];
            if (i==3)
            {
                lab.frame = CGRectMake(20 +labLength*i, 10, labLength*2, 20);
            }
        }
    }
    return view;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CashPositionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cashPositionCell"];
    cell.concelBlock = ^()
    {
        [self concelOrderIndex:(int)indexPath.row];
    };
    CashPositionListModel * model = _orderDataArray[indexPath.row];
    model.askPrice = _askPrice;
    model.bidPrice = _bidPrice;
    cell.backgroundColor = Color_black;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCashPositionCell:model productModel:_productModel];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _orderDataArray.count;
}
@end
