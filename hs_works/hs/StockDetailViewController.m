//
//  StockDetailViewController.m
//  hs
//
//  Created by PXJ on 15/4/29.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import "StockDetailViewController.h"
#import "SearchViewController.h"
#import "orderPage.h"
#import "SignAgreement.h"
#import "StockMessage.h"
#import "StockDetailCell.h"

#import "TopStockView.h"
#import "StockDetailView.h"
#import "QwTrendView.h"
#import "QwKlineView.h"

#import "h5_protocol_tag.h"
#import "h5DataCenterMgr.h"
#import "OtherPositionBaseClass.h"

#import "StockDetailDataModels.h"
#import "NetRequest.h"
#import "OrderByModel.h"
#import "SystemSingleton.h"


#define K_SELF_BOUNDS self.view.bounds.size

@interface StockDetailViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isShowTrendImageView;
    IH5Session *_h5Session;
    NSTimer * _timer;
    NSTimer * _stockTimer;
    //    AlertView * _orderAlertView;
    StockDetailBaseClass * _stockDetailModel;
    StockDetailView * _stockDetailView;
    //个股收益
    NSString * _earnStr;
    
    float _stockDVheight;
    //卖出成功后返回的数据
    NSDictionary * _orderDetailDic;
    //配资额度
    NSMutableArray * _traderArray;
    
    BOOL _loadSwitchOn;
    NSString * _selectAmt;
}
@property (nonatomic,strong)SystemSingleton * systemStatus;
@property (nonatomic,strong)OrderByModel * orderByModel;
@property (nonatomic,strong)UIButton * lastSelectBtn;
@property (nonatomic,strong)H5DataCenter * dataCenter;


//添加手势
//@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
//@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@end

@implementation StockDetailViewController



//获取股票当前状态
-(void)getStatus
{
    
    
    NSDictionary * dic = @{@"stockCode":_realtime.code};
    NSString * url =K_MARKET_STOCKSTATUS;
    [NetRequest postRequestWithNSDictionary:dic url:url successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"]intValue]==200) {
            
            NSDictionary * dict =dictionary[@"data"];
            int status =[dict[@"status"]  intValue];
            [self updateUIbtn:status];
            
            
        }
        
    } failureBlock:^(NSError *error) {
        [self updateUIbtn:0];
        
    }];
    
    
    
    
    
}
//判断股票状态
- (void)updateUIbtn:(int)status
{
    __block  BOOL enable= NO;
    __block  NSString * title;
    __block NSString * systemTime;
    if (status==5) {
        title = [NSString stringWithFormat:@"%@",@"股票停牌"];
        enable = NO;
        [self updateBtn:title enable:enable];
        
    }else{
        [DataEngine requestToGetSystemDateWithComplete:^(BOOL SUCCESS, NSString *data ,NSString * timestamp) {
            if (SUCCESS) {
                systemTime = data;
            }
            else
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                
                systemTime = [dateFormatter stringFromDate:[NSDate date]];
            }
            enable =  [self timeSysTime:systemTime createTime:_userOrderList.buyDate];
            if(enable)
            {
                title = @"市价卖出";
                
            }else{
                title = @"下个交易日可卖";
                
            }
            [self updateBtn:title enable:enable];
        }];
        
    }
    
}


- (void)updateBtn:(NSString *)title enable:(BOOL)enable
{
    
    
    if (![_stockDetailView.amtBtn.titleLabel.text isEqualToString:title]) {
        
        [_stockDetailView.amtBtn setTitle:title forState:UIControlStateNormal];
        [_stockDetailView.amtBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        if (enable) {
            [_stockDetailView.amtBtn setBackgroundColor:K_COLOR_CUSTEM(250, 67, 0, 1)];
            _stockDetailView.amtBtn.enabled = YES;
            
            _stockDetailView.amtBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            
            
        }else{
            
            [_stockDetailView.amtBtn setBackgroundColor:[UIColor lightGrayColor]];
            _stockDetailView.amtBtn.enabled = NO;
        }
        
    }
    
    
    
    
}

//判断市场状态
-(void )updateUIbutton:(int) tradeStatus
{
    NSLog(@"%d",tradeStatus);
    if (_isbuy&&!_isbuyBuy) {
        
        [_stockDetailView.amtBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        switch (tradeStatus) {
            case 22:case 100:
            {
                
                [self getStatus];
                
                _loadSwitchOn = YES;
                
            }
                break;
                
            case 20:
            {
                if (![_stockDetailView.amtBtn.titleLabel.text isEqualToString:@"未开市"]) {
                    
                    [_stockDetailView.amtBtn setTitle:@"未开市" forState:UIControlStateNormal];
                    [_stockDetailView.amtBtn setBackgroundColor:[UIColor lightGrayColor]];
                    _stockDetailView.amtBtn.enabled = NO;
                    
                }
                _loadSwitchOn = NO;
                
            }break;
            case 21:
            {
                if (![_stockDetailView.amtBtn.titleLabel.text isEqualToString:@"集合竞价"]) {
                    
                    [_stockDetailView.amtBtn setTitle:@"集合竞价" forState:UIControlStateNormal];
                    [_stockDetailView.amtBtn setBackgroundColor:[UIColor lightGrayColor]];
                    _stockDetailView.amtBtn.enabled = NO;
                }
                _loadSwitchOn = NO;
                
            }break;
                
            case 23:
            {
                if (![_stockDetailView.amtBtn.titleLabel.text isEqualToString:@"午休市"]) {
                    
                    [_stockDetailView.amtBtn setTitle:@"午休市" forState:UIControlStateNormal];
                    [_stockDetailView.amtBtn setBackgroundColor:[UIColor lightGrayColor]];
                    _stockDetailView.amtBtn.enabled = NO;
                }
                _loadSwitchOn = NO;
                
            }break;
                
            case 24:
            {
                if (![_stockDetailView.amtBtn.titleLabel.text isEqualToString:@"已闭市"]) {
                    
                    [_stockDetailView.amtBtn setTitle:@"已闭市" forState:UIControlStateNormal];
                    [_stockDetailView.amtBtn setBackgroundColor:[UIColor lightGrayColor]];
                    _stockDetailView.amtBtn.enabled = NO;
                }
                _loadSwitchOn = NO;
                
            }break;
                
                
            default:
                //            {
                ////                if (![_stockDetailView.amtBtn.titleLabel.text isEqualToString:@"市价卖出"]) {
                ////
                ////                    [_stockDetailView.amtBtn setTitle:@"市价卖出" forState:UIControlStateNormal];
                ////                    [_stockDetailView.amtBtn setBackgroundColor:[UIColor lightGrayColor]];
                ////                    _stockDetailView.amtBtn.enabled = YES;
                ////
                //                }
                //                _loadSwitchOn = NO;
                //
                //            }
                break;
        }
    }else{
        
        if (tradeStatus==22) {
            _loadSwitchOn = YES;
        }
        
    }
}

- (BOOL)timeSysTime:(NSString *)sysTime createTime:(NSString*)createTime
{
    
    ;
    NSDateFormatter * dm = [[NSDateFormatter alloc]init];
    [dm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    
    NSDateFormatter * ds = [[NSDateFormatter alloc]init];
    [ds setDateFormat:@"yyyy-MM-dd"];
    
    
    NSDate * sysDate = [dm dateFromString:sysTime];
    NSString * sysStr = [ds stringFromDate:sysDate];
    sysStr = [NSString stringWithFormat:@"%@ 00:00:00",sysStr];
    sysDate = [dm dateFromString:sysStr];
    
    NSDate * createDate = [dm dateFromString:createTime];
    NSString * createStr = [ds stringFromDate:createDate];
    createStr = [NSString stringWithFormat:@"%@ 00:00:00",createStr];
    createDate=[dm dateFromString:createStr];
    
    long dd = (long)[sysDate timeIntervalSince1970] - [createDate timeIntervalSince1970];
    if (dd/86400>=1) {
        return YES;
    }else{
        
        return NO;
    }
    
}



#pragma mark - 点击button触发的事件

#pragma mark - 返回
- (void)back
{
    
    if ([self.source isEqualToString:@"search"]) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        if(_timer){
            
            [_timer invalidate];
            _timer = nil;
        }
        if (_stockTimer) {
            [_stockTimer invalidate];
            _stockTimer = nil;
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    
}
#pragma mark - 搜索
- (void)search
{
    if(_timer){
        
        [_timer invalidate];
        _timer = nil;
    }
    if (_stockTimer) {
        [_stockTimer invalidate];
        _stockTimer = nil;
    }
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    searchVC.dataCenter = [h5DataCenterMgr sharedInstance].dataCenter;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:searchVC animated:YES];
}
#pragma mark - 加载分时图
- (void)loadTrendImage:(id)sender
{
    
    if (_isPosition) {
        
        
        
        
        [_stockDetailView.stockTopView.trendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_stockDetailView.stockTopView.klineBtn setTitleColor:K_COLOR_CUSTEM(220,220,220,1) forState:UIControlStateNormal];
        
    }else{
        [_stockDetailView.stockTopView.trendBtn setTitleColor:K_COLOR_CUSTEM(55, 54, 53, 1) forState:UIControlStateNormal];
        [_stockDetailView.stockTopView.klineBtn setTitleColor:K_COLOR_CUSTEM(190,190,190,1) forState:UIControlStateNormal];
        
        
        
    }
    
    _isShowTrendImageView = YES;
    _stockDetailView.stockTopView.lineLab.frame = CGRectMake(0, _stockDetailView.stockTopView.bounds.size.height-2, ScreenWidth/2, 2);
    _stockDetailView.klineView.hidden = YES;
    _stockDetailView.trendView.hidden = NO;
    
    //获取分时数据
    [self.dataCenter loadTrends:self.stock withHandleBlock:^(id result){
        HsStockTrendData *trendData = result;
        //创建对应的Viewmodel
        HsTrendViewModel *viewModel = [[HsTrendViewModel alloc] init];
        //将数据填充到Viewmodel
        viewModel.trendData = trendData;
        viewModel.stock = _stock;
        //使用Viewmodel更新视图
        _stockDetailView.trendView.trendDataPack = viewModel;
    }];
    
}
#pragma mark - 加载K线图
- (void)loadKlineImage:(id)sender
{
    if (_isPosition) {
        [_stockDetailView.stockTopView.klineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_stockDetailView.stockTopView.trendBtn setTitleColor:K_COLOR_CUSTEM(220,220,220,1) forState:UIControlStateNormal];
        
    }else
    {
        [_stockDetailView.stockTopView.klineBtn setTitleColor:K_COLOR_CUSTEM(55, 54, 53, 1) forState:UIControlStateNormal];
        [_stockDetailView.stockTopView.trendBtn setTitleColor:K_COLOR_CUSTEM(190,190,190,1) forState:UIControlStateNormal];
        
    }
    
    
    _isShowTrendImageView = NO;
    _stockDetailView.stockTopView.lineLab.frame = CGRectMake(ScreenWidth/2, _stockDetailView.stockTopView.bounds.size.height-2, ScreenWidth/2, 2);
    _stockDetailView.klineView.hidden = NO;
    _stockDetailView.trendView.hidden = YES;
    
    //获取K线数据(获取日k)
    [self.dataCenter loadKline:self.stock AtDate:0 Count:100 Peroid:H5SDK_ENUM_PEROID_DAY withHandleBlock:^(id object) {
        if (object) {
            //创建对应的Viewmodel
            HsKlineViewModel *kvm = [[HsKlineViewModel alloc] init];
            //将数据填充到Viewmodel
            kvm.stockKline = object;
            kvm.stock = _stock;
            //使用Viewmodel更新视图
            _stockDetailView.klineView.klineDataPack = kvm;
        }
    }];
}

#pragma mark ——————点击选择实盘额度——————市价卖出
-(void)selectAmt
{
    if(_isbuy&&!_isbuyBuy){
        
        
        [_stockTimer invalidate];
        
        __block StockDetailViewController * stockDVC = self;
        
        __block PopUpView * saleAlertView = [[PopUpView alloc] initShowAlertWithShowText:@"是否确认以市价卖出" setBtnTitleArray:@[@"取消",@"确认"]];
        saleAlertView.confirmClick = ^(UIButton * button){
            
            if (button.tag==66666) {
                
            }else{
                
                [stockDVC saleStockOrder];
                
            }
            
        };
        
        
        [self.navigationController.view addSubview:saleAlertView];
        
        
        
        
    }else{
        
        
        if (_traderArray.count<1) {
            [self getStockTraderList];
            
        }
        
        
        _stockDetailView.amtBtn.selected = !_stockDetailView.amtBtn.selected;
        
        [_stockDetailView bringSubviewToFront:_stockDetailView.btnBackView];
        if (  _stockDetailView.amtBtn.selected) {
            
            [_stockDetailView.amtBtn setImage:[UIImage imageNamed:@"directionUp"] forState:UIControlStateNormal];
            
            _stockDetailView.center = CGPointMake(ScreenWidth/2.0, ScreenHeigth/2.0);
            _stockDetailView.bounds = CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
            _tableView.tableHeaderView.bounds =CGRectMake(0, 0, ScreenWidth, ScreenHeigth);
            _tableView.tableHeaderView = _stockDetailView;
            _stockDetailView.btnBackView.center = CGPointMake(ScreenWidth/2.0,_stockDetailView.bounds.size.height-30);
            
            _stockDetailView.AmtView.hidden = NO;
            _stockDetailView.AmtView.alpha = 1;
            
            
        }else{
            
            [_stockDetailView.amtBtn setImage:[UIImage imageNamed:@"directionDown"] forState:UIControlStateNormal];
            
            _stockDetailView.center = CGPointMake(ScreenWidth/2.0, (ScreenHeigth-100)/2.0);
            _stockDetailView.bounds = CGRectMake(0, 0, ScreenWidth, ScreenHeigth-100);
            _tableView.tableHeaderView.bounds = CGRectMake(0, 0, ScreenWidth, ScreenHeigth-100);
            _tableView.tableHeaderView = _stockDetailView;
            _stockDetailView.AmtView.alpha = 0;
            _stockDetailView.AmtView.hidden = YES;
            _stockDetailView.btnBackView.center = CGPointMake(ScreenWidth/2.0,_stockDetailView.bounds.size.height-30);
        }
        [_tableView reloadData];
        
        
        
        
        
    }
    
    
}

#pragma mark ——————市价买入————合约续期
- (void)buyStock{
    CMLog(@"-------------start but");
    if (_isbuy&&!_isbuyBuy){
        

        PopUpView * alertView = [[PopUpView alloc] initShowAlertWithShowText:@"敬请期待" setBtnTitleArray:@[@"确认"]];
        alertView.confirmClick = ^(UIButton *button){
            
        };
        [self.navigationController.view addSubview:alertView];
        
    }else{
        
        if (!_orderByModel.selectAmt) {
            [self  selectAmt];
            return;
        }else{
            
            
            if (![[CMStoreManager sharedInstance] isLogin]) {
                
                
                
                PopUpView * alertView = [[PopUpView alloc] initShowAlertWithShowText:@"尚未登录" setBtnTitleArray:@[@"确认",@"登录"]];
                alertView.confirmClick = ^(UIButton *button){
                    if (button.tag==66666) {
                        
                    }else{
                        
                        
                        LoginViewController *loginVC = [[LoginViewController alloc] init];
                        loginVC.source = @"orderBuy";
                        [self.navigationController pushViewController:loginVC animated:YES];
                        
                    }
                    
                    
                };
                
            } else {
                
                
                
                if ([self getUserAgree]) {
                    [self goOrderPage];
                    
                }else{
                    
                    
                    SignAgreement * signAgreePage = [[SignAgreement alloc] init];
                    
                    int quantt = (int)([_orderByModel.selectAmt intValue]*0.98/_realtime.newPrice);
                    quantt = quantt/100 * 100;
                    _orderByModel.buyCount = quantt;
                    _orderByModel.price = _realtime.newPrice;
                    _orderByModel.stockName = _realtime.name;
                    _orderByModel.stockCode = _realtime.code;
                    _orderByModel.stockCodeType = _realtime.codeType;
                    signAgreePage.orderByModel = _orderByModel;
                    
                    [self.navigationController pushViewController:signAgreePage animated:YES];
                    
                    
                    
                }
                
            }
        }
    }
    
}

//判断是否同意过协议
-(BOOL)getUserAgree
{
    BOOL isAgree;
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    if ([cacheModel.isAgree isEqualToString:@"1"]) {
        isAgree = YES;
    }else{
        
        isAgree = NO;
    }
    
    return isAgree;
}

#pragma mark - 到支付页面
- (void)goOrderPage
{
    
    if (YES) {
        
        [ManagerHUD showHUD:self.navigationController.view animated:YES];
        
        
        NSDictionary * dic = @{@"stockCode":_realtime.code};
        NSLog(@"%@",K_MARKET_STOCKSTATUS);
        [NetRequest postRequestWithNSDictionary:dic url:K_MARKET_STOCKSTATUS successBlock:^(NSDictionary *dictionary) {
            if (dictionary==nil) {
                [ManagerHUD hidenHUD];
                return ;
            }
            if ([dictionary[@"code"]intValue]==200) {
                
                [_stockTimer invalidate];
                
                int quantt = (int)([_orderByModel.selectAmt intValue]*0.98/_realtime.newPrice);
                quantt = quantt/100 * 100;
                NSDictionary * dic =dictionary[@"data"];
                _orderByModel.status = [dic[@"status"] intValue];
                _orderByModel.buyCount = quantt;
                _orderByModel.price = _realtime.newPrice;
                _orderByModel.stockName = _realtime.name;
                _orderByModel.stockCode = _realtime.code;
                _orderByModel.stockCodeType = _realtime.codeType;
                
                [self getUser];
            }
            
            
            
        } failureBlock:^(NSError *error) {
            [ManagerHUD hidenHUD];
        }];
        
    }else{
        
        
        
    }
    
}
//获取用户资金账户
- (void)getUser
{
    
    
    
    [DataEngine requestToGetAllMoneyWithComplete:^(BOOL SUCCESS, NSMutableArray *infoArray) {
        
        
        NSString * userMoney;
        NSString * usedIntegral;
        if (SUCCESS) {
            userMoney = infoArray[2];
            usedIntegral = infoArray[1];
            
        }
        
        
        orderPage * orderVC = [[orderPage alloc] init];
        
        orderVC.orderByModel = _orderByModel;
        orderVC.usedMoney = userMoney;
        orderVC.usedIntegral = usedIntegral;
        [self.navigationController pushViewController:orderVC animated:YES];
        [ManagerHUD hidenHUD];
        
        
    }];
    
    
    
}

//发送卖出请求
-(void)sale:(NSString*)systemTime
{
    
    
    NSString * token = [[CMStoreManager sharedInstance] getUserToken];
    NSString * odid = [NSString stringWithFormat:@"%d",[_odid intValue] ];
    NSDictionary * dic = @{@"orderId":odid,
                           @"token":token,
                           @"userSalePrice":[NSNumber numberWithDouble:_realtime.newPrice],
                           @"userSaleDate":systemTime,
                           @"version":@"0.01"
                           };
    NSString * str =[NSString stringWithFormat:@"%@/order/order/sale",K_MGLASS_URL];
    [NetRequest postRequestWithNSDictionary:dic url:str successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200) {
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(searchStorkOrder) userInfo:nil repeats:YES];
            
        }else{
            [ManagerHUD hidenHUD];

            PopUpView * alertView = [[PopUpView alloc] initShowAlertWithShowText:dictionary[@"msg"] setBtnTitleArray:@[@"确认"]];
            alertView.confirmClick = ^(UIButton *button){
                
            };
            [self.navigationController.view addSubview:alertView];
            
            
        }
        
    } failureBlock:^(NSError *error) {
        [ManagerHUD hidenHUD];

        PopUpView * alertView = [[PopUpView alloc] initShowAlertWithShowText:@"申报失败" setBtnTitleArray:@[@"放弃",@"再次提交"]];
        alertView.confirmClick = ^(UIButton *button){
            
            if (button.tag==66666) {
                
            }else{
                
                [self  saleStockOrder];
                
            }
            
            
            
        };
        [self.navigationController.view addSubview:alertView];
        
        
    }];
    
}

#pragma mark － 确认卖出
- (void)saleStockOrder
{
    [ManagerHUD showHUD:self.navigationController.view animated:YES];
    
    __block NSString * systemTime;
    [DataEngine requestToGetSystemDateWithComplete:^(BOOL SUCCESS, NSString *data ,NSString * timestamp) {
        if (SUCCESS) {
            systemTime = data;
            
        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            systemTime = [dateFormatter stringFromDate:[NSDate date]];
        }
        [self sale:systemTime];
        
    }];
}


#pragma mark -- 查询是否卖出成功
- (void)searchStorkOrder

{
    static  int num = 0;
    num ++;
    if (num >= 5) {
        [ManagerHUD hidenHUD];
        
//        PopUpView * alertView = [PopUpView alloc] initShowAlertWithShowText:@"申报超时" setBtnTitleArray:@[@"确认"];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        num = 0;
        [_timer invalidate];
        _timer = nil;
    }
    else{
        
        NSString * token = [[CMStoreManager sharedInstance] getUserToken];
        
        NSString * odid = [NSString stringWithFormat:@"%d",[_odid intValue]];
        
        NSDictionary * dic = @{@"orderId":odid,
                               @"token":token,
                               @"version":@"0.1"
                               };
        NSString * str =[NSString stringWithFormat:@"%@/order/order/orderStatus",K_MGLASS_URL];
        ;
        [NetRequest postRequestWithNSDictionary:dic url:str successBlock:^(NSDictionary *dictionary) {
            
            if ([dictionary[@"code"] intValue]==200) {
                [_timer invalidate];
                //            data:
                //                                       -2：买入失败
                //                                       0：买待处理，创建订单默认状态
                //                                       1：买处理中
                //                                       2：买委托成功，即申报成功
                //                                       3：持仓中
                //                                       4：卖处理中
                //                                       5：卖委托成功，即申报成功
                //                                       6：卖出成功
                if ([dictionary[@"data"] floatValue] == 5 || [dictionary[@"data"] floatValue] == 6) {
                    
                    [ManagerHUD hidenHUD];
                    
                    
                    
                    PopUpView * alertView = [[PopUpView alloc] initShowAlertWithShowText:@"已申报成功" setBtnTitleArray:@[@"确认"]];
                    alertView.confirmClick = ^(UIButton *button){
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    };
                    [self.navigationController.view addSubview:alertView];
                }
                else if([dictionary[@"data"] floatValue] == 4){
                    
                }
                else{
                    [_timer invalidate];
                    [ManagerHUD hidenHUD];
                    
                    
                    
                    PopUpView * alertView = [[PopUpView alloc] initShowAlertWithShowText:@"申报失败" setBtnTitleArray:@[@"放弃",@"再次提交"]];
                    alertView.confirmClick = ^(UIButton *button){
                        if(button.tag==66666){
                        }else{
                            [self  saleStockOrder];
                            
                        }
                        
                        
                    };
                    [self.navigationController.view addSubview:alertView];
                }
                
                
                
            }else {
                [_timer invalidate];
                PopUpView * alertView = [[PopUpView alloc] initShowAlertWithShowText:dictionary[@"msg"] setBtnTitleArray:@[@"确认"]];
                alertView.confirmClick = ^(UIButton *button){
                    
                };
                [self.navigationController.view addSubview:alertView];
                
                
                
            }
            
            
        } failureBlock:^(NSError *error) {
            
            //            [self  searchStorkOrder];
            
            
            
            
            
        }];
    }
}

#pragma mark - 初始化股票详情界面

- (void)initView
{
    
    
    
    if (_isExponent) {
        _stockDetailView = [[StockDetailView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth-165)];
        _stockDetailView.AmtView.hidden = YES;
        _stockDetailView.btnBackView.hidden = YES;
        _stockDetailView.stockTopView.nePriceMarkLab.hidden = YES;
    }else{
        
        _stockDetailView = [[StockDetailView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth-100)];
    }
    
    
    [self initBtnStatus];
    [_stockDetailView.stockTopView.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [_stockDetailView.stockTopView.searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [_stockDetailView.stockTopView.trendBtn addTarget:self action:@selector(loadTrendImage:) forControlEvents:UIControlEventTouchUpInside];
    [_stockDetailView.stockTopView.klineBtn addTarget:self action:@selector(loadKlineImage:) forControlEvents:UIControlEventTouchUpInside];
    [_stockDetailView.buyBtn addTarget:self action:@selector(buyStock) forControlEvents:UIControlEventTouchUpInside];
    [_stockDetailView.amtBtn addTarget:self action:@selector(selectAmt) forControlEvents:UIControlEventTouchUpInside];
    
    if (_isbuy) {
        _stockDetailView.stockTopView.nePriceMarkLab.textColor = [UIColor whiteColor];
        _stockDetailView.stockTopView.nePriceLab.textColor = [UIColor whiteColor];
        _stockDetailView.stockTopView.detailLab.textColor = [UIColor whiteColor];
    }
    
    if (_isPosition) {
        StockDetailViewController * safeSelf = self;
        _stockDetailView.stockTopView.changeSaleBtn.enabled = YES;
        _stockDetailView.stockTopView.changeSaleBtnClick = ^(){
            
            [safeSelf changePage];
        };
    }else{
        _stockDetailView.stockTopView.changeSaleBtn.enabled = NO;
        
        
    }
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[StockDetailCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = _stockDetailView;
    
}

- (void)changePage
{
    _isbuyBuy = !_isbuyBuy;
    [self loadStockDetailData];
    [self initBtnStatus];
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    [UIView commitAnimations];
    
    
    
    if (_traderArray==nil||_traderArray.count<=0)
    {
        
        [self getStockTraderList];
        
    }else{
        
        [self loadStockTrader];
        
    }
    if ((!_isbuy||_isbuyBuy)&&!_stockDetailView.amtBtn.selected ) {
        
        [self selectAmt];
    }
    
}
- (void)initBtnStatus
{
    
    _systemStatus = [[SystemSingleton alloc] init];
    NSInteger  integer =  [_systemStatus getMarketStatus];
    [self updateUIbutton:(int)integer];
    
    
    
    
    
    if(!_isbuy||_isbuyBuy){
        if (_isPosition&&!_isbuy) {
            
            
            [_stockDetailView.buyBtn setTitle:@"跟买" forState:UIControlStateNormal];
            
        }else{
            
            //_stockDetailView.stockTopView.changeSaleBtn.hidden = YES;
            [_stockDetailView.buyBtn setTitle:@"市价买入" forState:UIControlStateNormal];
            
        }
        [_stockDetailView.buyBtn setBackgroundColor:K_COLOR_CUSTEM(250, 67, 0, 1)];
        _stockDetailView.buyBtn.enabled = YES;
        [_stockDetailView.amtBtn setTitle:@"选择交易本金" forState:UIControlStateNormal];
        _stockDetailView.amtBtn.enabled = YES;
        [_stockDetailView.amtBtn setBackgroundColor:[UIColor whiteColor]];
        [_stockDetailView.amtBtn.layer setBorderWidth:1.0]; //边框宽度
        [_stockDetailView.amtBtn.layer setBorderColor:[K_COLOR_CUSTEM(250,67,0,1)CGColor]]; //边框颜色
        [_stockDetailView.amtBtn setTitleColor:K_COLOR_CUSTEM(250,67,0,1) forState:UIControlStateNormal];
        [_stockDetailView.amtBtn setImage:[UIImage imageNamed:@"directionDown"] forState:UIControlStateNormal];
        _stockDetailView.amtBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        [_stockDetailView.amtBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _stockDetailView.amtBtn.frame.size.width*20/29, 0, 0)];
        [_stockDetailView.amtBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        
        
        
    }else{
        
        
        [_stockDetailView.buyBtn setTitle:@"合约续期" forState:UIControlStateNormal];
        [_stockDetailView.buyBtn setBackgroundColor:[UIColor lightGrayColor]];
        _stockDetailView.buyBtn.enabled = YES;
        [_stockDetailView.amtBtn.layer setBorderWidth:0]; //边框宽度
        [_stockDetailView.amtBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _stockDetailView.amtBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        
    }
    
    
    
    
}
#pragma mark - 刷新头部信息
- (void)loadStockDetailData
{
    if (_isPosition &&!_isbuyBuy &&!_isbuy) {
        
        _otherOrderList.preClosePrice = _realtime.preClosePrice;
    }
    
    [_stockDetailView setStockDetailViewValueWithSource:_isbuy position:_isPosition isbuyBuy:_isbuyBuy
                                             isexponent:_isExponent stockDetailDataModel:_isbuy?_userOrderList:_otherOrderList realtime:_realtime];
    
    __block StockDetailViewController * stockDVC = self;
    _stockDetailView.stockTopView.goStockPageClick = ^(){
        
        StockMessage * stockMessage = [[StockMessage alloc] init];
        stockMessage.realtime = stockDVC.realtime;
        
        [stockDVC.navigationController pushViewController:stockMessage animated:YES];
        
        
        
    };
    
}

#pragma mark - 初始化定时器
- (void)initTimer
{
    if (_loadSwitchOn) {
        
        _systemStatus = [[SystemSingleton alloc] init];
        NSInteger  integer =  [_systemStatus getMarketStatus];
        if (integer==22) {
            _loadSwitchOn = YES;
            [self timerData];
        }else{
            
            [self performSelector:@selector(initTimer) withObject:nil afterDelay:3];
        }
        
    }
    
    
}

- (void)timerData
{
    
    
    __block  StockDetailViewController * safeSelf = self;
    
    [self.dataCenter loadRealtime:self.stock withHandleBlock:^(id result){
        
        if ((NSNull*)result == [NSNull null] || result == nil )
        {
            
        }
        else
        {
            _realtime = result;
            [safeSelf loadData];
            [_tableView reloadData];
            
            
        }
        [self performSelector:@selector(initTimer) withObject:nil afterDelay:3];
        
    }];
}

#pragma mark - 刷新数据
- (void)loadData
{
    
    _systemStatus = [[SystemSingleton alloc] init];
    NSInteger  integer =  [_systemStatus getMarketStatus];
    if (integer==22&&!_isbuyBuy&&_isbuy) {
        
        [self getStatus];
        
    }
    
    
    [self loadStockDetailData];
    
    if (_isShowTrendImageView) {
        
        [self loadTrendImage:nil];
    }else{
        
        [self loadKlineImage:nil];
        
    }
    
}
#pragma mark - 刷新操盘额度
-(void)loadStockTrader
{
    
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    
    
    if (cacheModel.userAmt) {
        _selectAmt = [NSString stringWithFormat:@"%d",cacheModel.userAmt];
        
        
    }else{
        NSDictionary * traderDict = _traderArray[0];
        
        NSString * seleAmt = [NSString stringWithFormat:@"%@", traderDict[@"financyAllocation"]];
        _selectAmt = seleAmt;
    }
    
    for (int i = 0; i < _traderArray.count; i++) {
        
        UIButton *button = (UIButton *)[_stockDetailView.AmtView viewWithTag:80000+i];
        button.layer.cornerRadius = 2;
        button.layer.masksToBounds = YES;
        NSDictionary * traderDit = _traderArray[i];
        NSString * trader = [NSString stringWithFormat:@"%@", traderDit[@"financyAllocation"]];
        NSString *title =[NSString stringWithFormat:@"%d",trader.intValue];
        BOOL enable = [traderDit[@"status"] boolValue] ;
        button.enabled = enable;
        [button addTarget:self action:@selector(selectTrader:) forControlEvents:UIControlEventTouchUpInside];
        if (_realtime.newPrice==0) {
            
        }else{
            int quantt = (int)([trader intValue]*0.98/_realtime.newPrice);
            quantt = quantt/100 * 100;
            
            if (quantt<100||!enable) {
                
                
                UILabel * lab = (UILabel*)[_stockDetailView.AmtView viewWithTag:90000+i];
                lab.hidden = NO;
                button.enabled = NO;
                button.backgroundColor = [UIColor whiteColor];
                [button setTitleColor:K_COLOR_CUSTEM(110, 110, 110, 1)  forState:UIControlStateNormal];
                
                
            }
            
        }
        
        title = [title stringByReplacingCharactersInRange:NSMakeRange(title.length-3,0) withString:@","];
        [button setTitle:title forState:UIControlStateNormal];
        
        if (trader.intValue==_selectAmt.intValue) {
            
            
            if (button.enabled) {
                
                button.backgroundColor = K_COLOR_CUSTEM(250, 67, 0, 1);
                [button setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
                _lastSelectBtn =  button;
                if (!_isbuy||_isbuyBuy) {
                    [self selectTrader:button];
                    
                }
            }else{//若纪录的额度不可选则选择下一额度
                if (i<_traderArray.count-1) {
                    NSDictionary * traderDict = _traderArray[i+1];
                    NSString * seleAmt = [NSString stringWithFormat:@"%@", traderDict[@"financyAllocation"]];
                    _selectAmt = seleAmt;
                    cacheModel.userAmt = seleAmt.intValue;
                    
                    [CacheEngine setCacheInfo:cacheModel];
                    
                    _orderByModel.selectAmt = seleAmt;
                    
                }
            }
        }
    }
    
}

#pragma mark -  选择实盘额度
- (void)selectTrader:(UIButton*)sender
{
    int tag = (int)sender.tag-80000;
    NSDictionary *dic = _traderArray[tag];
    
    _orderByModel.selectAmt = [NSString stringWithFormat:@"%@", dic[@"financyAllocation"]];
    _orderByModel.status = [dic[@"status"]intValue];
    NSString * title  =[NSString stringWithFormat:@"%d",_orderByModel.selectAmt.intValue];
    title  = [title stringByReplacingCharactersInRange:NSMakeRange(title.length-3,0) withString:@","];
    title = [NSString stringWithFormat:@"本金%@",title];
    
    [_stockDetailView.amtBtn setTitle:title forState:UIControlStateNormal];
    
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    cacheModel.userAmt = _orderByModel.selectAmt.intValue;
    [CacheEngine setCacheInfo:cacheModel];
    
    int quantt = (int)([_orderByModel.selectAmt intValue]*0.98/_realtime.newPrice);
    quantt = quantt/100 * 100;
    
    
    float persont                                 = quantt* _realtime.newPrice /_orderByModel.selectAmt.floatValue;
    NSString *limitDetailText ;
    if (_realtime.newPrice==0&&_realtime.preClosePrice) {
        
        limitDetailText               = [NSString
                                         stringWithFormat:@"可买入0股，资金利用率0"];
    }else{
        if (_realtime.newPrice ==0&&_realtime.preClosePrice) {
            
        }
        limitDetailText                = [NSString
                                          stringWithFormat:@"可买入%d股，资金利用率%.2f%%", quantt, persont*100];
    }
    
    
    
    _stockDetailView.alertLab.text = limitDetailText;
    
    
    if (_lastSelectBtn) {
        
        _lastSelectBtn.backgroundColor = [UIColor whiteColor];
        
        [_lastSelectBtn setTitleColor:K_COLOR_CUSTEM(110, 110, 110, 1) forState:UIControlStateNormal];
        
    }
    sender.backgroundColor = K_COLOR_CUSTEM(250, 67, 0, 1);
    [sender setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    _lastSelectBtn =  sender;
    
    
    
    
}



#pragma mark -UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isPosition) {
        
        return 2;
        
        
    }else{
        
        return 1;
        
    }
    
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    
    
    switch (section) {
            
        case 0:
        {
            if (_isPosition&&_isbuy) {
                num = 5;
            }else if(_isPosition){
                
                num = 2;
            }else{
                if (_isExponent) {
                    num= 3;
                }else{
                    num = 4;
                    
                }
            }
        }
            break;
        case 1:
            num = 4;
            break;
            
            
        default:
            break;
            
    }
    return num;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    
    return 30;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    StockDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    if (indexPath.row%2==0) {
        cell.backgroundColor = K_COLOR_CUSTEM(248, 248, 248, 1);
    }else{
        
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    //订单信息
    if (_isPosition&&indexPath.section==0) {
        if (_isbuy) {
            
            
            switch (indexPath.row) {
                case 0:
                {
                    
                    cell.nameLeft.text = @"买入价";
                    cell.valueLeft.text = [NSString stringWithFormat:@"%.2f",_userOrderList.buyPrice];
                    
                    cell.nameRight.text = @"买入股数";
                    cell.valueRight.text = [DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",_userOrderList.factBuyCount]];
                    
                    
                }
                    break;
                case 1:
                {
                    cell.nameLeft.text = @"保证金";
                    cell.valueLeft.text = [NSString stringWithFormat:@"%.2f",_userOrderList.cashFund];
                    cell.nameRight.text = @"比例";
                    cell.valueRight.text = [NSString stringWithFormat:@"1:%d",_userOrderList.multiple];
                    
                    
                    
                }
                    break;
                case 2:
                {
                    cell.nameLeft.text = @"预警金额";
                    cell.valueLeft.text = [NSString stringWithFormat:@"%.2f",_userOrderList.warnAmt];;
                    cell.nameRight.text = @"平仓金额";
                    cell.valueRight.text = [NSString stringWithFormat:@"%.2f",_userOrderList.maxLoss];;
                    
                    
                }
                    break;
                case 3:
                {
                    
                    cell.nameLeft.text = @"买入时间";
                    cell.valueRight.text = _userOrderList.buyDate;
                    
                    
                }
                    break;
                case 4:
                {
                    
                    cell.nameLeft.text = @"到期时间";
                    cell.valueRight.text = _userOrderList.sysSetSaleDate;
                    
                }
                    break;
                    
                default:
                    break;
            }
        }else{
            if (indexPath.row==0) {
                cell.nameLeft.text = @"买入价";
                cell.valueLeft.text = [NSString stringWithFormat:@"%.2f",_otherOrderList.buyPrice];
                cell.nameRight.text = @"买入股数";
                cell.valueRight.text = [DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",_otherOrderList.factBuyCount]];
                
            }else if(indexPath.row==1){
                
                cell.nameLeft.text = @"买入时间";
                cell.valueRight.text = _otherOrderList.buyDate;
                
                
            }}
    }else
    {
        //股票信息
        switch (indexPath.row) {
            case 0:
            {
                
                cell.nameLeft.text = @"今开";
                cell.valueLeft.text = [NSString stringWithFormat:@"%.2f",_realtime.openPrice];
                cell.nameRight.text = @"昨收";
                cell.valueRight.text = [NSString stringWithFormat:@"%.2f",_realtime.preClosePrice];
                
            }
                break;
            case 1:
            {
                cell.nameLeft.text = @"最高";
                
                cell.valueLeft.text = [NSString stringWithFormat:@"%.2f",_realtime.highPrice];
                cell.nameRight.text = @"最低";
                cell.valueRight.text = [NSString stringWithFormat:@"%.2f",_realtime.lowPrice];
                
                
                
            }
                break;
            case 2:
            {
                
                if (_isExponent) {
                    
                    cell.nameLeft.text = @"成交总量";
                    NSString * num = [NSString stringWithFormat:@"%lld",_realtime.volume];
                    cell.valueRight.text = [NSString stringWithFormat:@"%.2f亿",num.floatValue/100000000];
                    cell.nameRight.hidden = YES;
                    cell.valueLeft.hidden = YES;
                }else{
                    
                    cell.nameLeft.text = @"成交总量";
                    NSString * num = [NSString stringWithFormat:@"%lld",_realtime.volume];
                    cell.valueLeft.text = [NSString stringWithFormat:@"%.2f亿",num.floatValue/100000000];
                    cell.nameRight.hidden = NO;
                    cell.valueLeft.hidden = NO;
                    cell.nameRight.text = @"换手率（％）";
                    cell.valueRight.text =[NSString stringWithFormat:@"%.2f",_realtime.turnoverRation*100];
                    
                    
                }
                
                
            }
                break;
                
            case 3:
            {
                
                cell.nameLeft.text = @"当前价";
                cell.valueLeft.text = [NSString stringWithFormat:@"%.2f",_realtime.newPrice];
                cell.nameRight.text = @"市盈率";
                cell.valueRight.text =[NSString stringWithFormat:@"--"];
                
            }
                break;
                
            default:
                break;
        }
    }
    
    return cell;
    
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    UILabel * headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, ScreenWidth/2.0-20, 10)];
    headerTitle.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
    headerTitle.textAlignment = NSTextAlignmentLeft;
    headerTitle.font = [UIFont systemFontOfSize:10];
    [view addSubview:headerTitle];
    
    UILabel * rightHeaderTitle = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2.0, 15, ScreenWidth/2.0-20, 10)];
    rightHeaderTitle.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
    rightHeaderTitle.textAlignment = NSTextAlignmentRight;
    rightHeaderTitle.font = [UIFont systemFontOfSize:10];
    [view addSubview:rightHeaderTitle];
    
    
    UILabel  *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30-0.8, ScreenWidth, 0.8)];
    [lineLabel setBackgroundColor:RGBCOLOR(191, 191, 191)];
    [view addSubview:lineLabel];
    switch (section) {
        case 0:
        {
            if (_isPosition) {
                if (_isbuy) {
                    rightHeaderTitle.text = [NSString stringWithFormat:@"编号：%@",_userOrderList.displayId];
                }else{
                    rightHeaderTitle.text = [NSString stringWithFormat:@"编号：%@",_otherOrderList.displayId];
                    
                }
                headerTitle.text = @"订单信息";
            }else{
                
                if (_isExponent) {
                    headerTitle.hidden = YES;
                }else{
                    headerTitle.text = @"股票信息";
                }
                rightHeaderTitle.text = [NSString stringWithFormat:@"名称：%@",_realtime.name];
            }
        }
            break;
        case 1:
        {
            if (_isExponent) {
                headerTitle.hidden = YES;
            }else{
                headerTitle.text = @"股票信息";
            }
            
            rightHeaderTitle.text = [NSString stringWithFormat:@"名称：%@",_realtime.name];
            
        }
            break;
            
        default:
            break;
    }
    
    return view;
    
}

#pragma mark - 视图将要出现
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [MobClick beginLogPageView:@"实情分时图"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
    [self loadTrendImage:nil];
    [self timerData] ;
    
    
}
- (void)initSelectAmtView
{
    if (_traderArray==nil||_traderArray.count<=0)
    {
        
        [self getStockTraderList];
        
    }else{
        
        [self loadStockTrader];
        
    }
    if ((!_isbuy||_isbuyBuy)&&!_stockDetailView.amtBtn.selected&&!_isExponent) {
        
        [self selectAmt];
    }
    
    
}
#pragma mark - 获取操盘额度
- (void)getStockTraderList
{
    
    NSDictionary * dic =@{@"traderType":@"0"};
    
    [NetRequest postRequestWithNSDictionary:dic url:K_FINANCY_STOCKTRADER successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200) {
            if ((NSNull*)dictionary[@"data"] != [NSNull null] && dictionary[@"data"] != nil ){
                
                _traderArray = dictionary[@"data"];
                [self loadStockTrader];
                
            }
            
            
        }
        
        
    } failureBlock:^(NSError *error) {
        
        
        //        NSLog(@"%@",error.localizedDescription);
        
    }];
    
}


#pragma mark - 视图将要消失
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"实情分时图"];
    _loadSwitchOn = NO;
    if(_timer){
        
        [_timer invalidate];
        _timer = nil;
        
    }
    if (_stockTimer) {
        [_stockTimer invalidate];
        _stockTimer = nil;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _traderArray = [NSMutableArray array];
    _orderByModel = [[OrderByModel alloc] init];
    _isbuyBuy = NO;
    _dataCenter=[h5DataCenterMgr sharedInstance].dataCenter;
    
    [self initView];
    
    if (_isbuy) {
        
        [self loadData];
        
    }
    [self initSelectAmtView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
