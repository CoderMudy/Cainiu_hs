//
//  PositionViewController.m
//  hs
//
//  Created by PXJ on 15/4/28.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import "PositionViewController.h"
#import "PositionTableViewCell.h"
#import "PositionModels.h"
#import "StockDetailViewController.h"
#import "TopPositionView.h"
#import "SSView.h"
#import "SearchViewController.h"
#import "LoginViewController.h"
#import "NetRequest.h"
#import "Helper.h"
#import "h5DataCenterMgr.h"
#import "RealTimeStockModel.h"
#import "UnloginPositionView.h"
#import "MJRefresh.h"

#import "SaveStock.h"



#define K_SELF_BOUNDS self.view.bounds.size

@interface PositionViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    //列表中
    
    UIImageView * _upDownImageV;
    BOOL _isLogin;
    //持仓
    //表
    UITableView * _tableView;
    TopPositionView * _positionView;
    BOOL  _haveOrder;
    NSMutableArray * _dataArray;
    SSView * _szView;
    SSView * _shView;
    UnloginPositionView * _positionRollView;
    UIImage * _posiNavBackImage;
    int _positionState;
    int _ssNavState;
    PositionDModel * _positionDModel;
    
    //自选
    UITableView * _optionalTableView;
    UIView * _optionalTopView;
    SSView * _szViewP;
    SSView * _shViewP;
    NSMutableArray * _optionalDataArray;
    NSMutableArray * _newPriceOptArray;
    UIView * _addoptionalView;
    
    
    
    H5DataCenter * _dataCenter;
    RealTimeStockModel * _realtimeSH;
    RealTimeStockModel * _realtimeSZ;
    
    
    NSString * _odid;
    NSMutableArray * _newPriceArray;
    
    NSTimer * _rollTimer;
    int _rollNum;
    NSArray * _rollDataArray;
    
    UIImageView * _backImageView;
    
    
    
    NSTimer * _timer;
    float _curCashProfit;
    float _curScoreProfit;
    UILabel * _lineLab;
    
    
    UIScrollView * _backScrollView;//持仓与自选的滑动背景
    
    int _startLine;//刷新数据开始值
    int _loadNum;//每次加载的数量
    BOOL _loadMore;//判断是否为加载更多
    
}
@property (strong, nonatomic)  UIButton *loginBtn;
@property (strong, nonatomic)  UIImageView *backAdImageView;
@property (strong, nonatomic)  UIView *headerView;

@end

@implementation PositionViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"持仓"];
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
    _dataCenter = [h5DataCenterMgr sharedInstance].dataCenter;
    [self viewAppearLoadData];
    //    [self setTimer:YES];
    //    NSMutableArray * array =  [SaveStock getAllStockDetail];
    
    
}

#pragma mark - 判断是否登录
- (void)viewAppearLoadData
{
    if ([[CMStoreManager sharedInstance] isLogin])
    {
        _isLogin = YES;
        
        //判断显示持x与自选
        if ((_dataArray.count<=0&&!_isOptionalPage)||(_optionalDataArray.count<=0&&_isOptionalPage)) {
        }
        [self loadHeader];
        
    }else{
        [self setTimer:YES];
        _isLogin = NO;
        [_dataArray removeAllObjects];
        [_newPriceArray removeAllObjects];
        [_optionalDataArray removeAllObjects];
        [_newPriceOptArray removeAllObjects];
        _positionRollView.hidden = YES;
        
        [self getFinancyValueReport:YES];
    }
    //    [self loadTopView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"持仓"];
    [self setTimer:NO];
    
    [self saveData:_isOptionalPage];
    
    [self stopreport];
}

//停止播报
- (void)stopreport
{
    [_positionRollView reportViewStopReport];
//    UIView * headerView = _tableView.tableHeaderView;
//    _positionRollView = (UnloginPositionView*)[headerView viewWithTag:200000];
//    [_positionRollView reportViewStopReport];
    
}

- (void)saveData:(BOOL)isFromOption
{
    
    
    
    
    //    存储：
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    
    if (cacheModel.positionPrivateIndex==nil) {
        
        PagePositionModel * positionPrivateIndex = [[PagePositionModel alloc] init];
        cacheModel.positionPrivateIndex = positionPrivateIndex;
        
    }
    if (isFromOption) {
        
        cacheModel.positionPrivateIndex.realtimeSH = _realtimeSH;
        cacheModel.positionPrivateIndex.realtimeSZ = _realtimeSZ;
        //       [SaveStock saveMulData:_newPriceOptArray];
        
    }else{
        
//        cacheModel.positionPrivateIndex.dataArray = [NSMutableArray arrayWithArray:_dataArray];
//        cacheModel.positionPrivateIndex.dataDetailArray = [NSMutableArray arrayWithArray:_newPriceArray];
        //        [SaveStock saveMulData:_newPriceArray];
        cacheModel.positionPrivateIndex.positionDmodel = _positionDModel;

    }
    //存入缓存
    [CacheEngine setCacheInfo:cacheModel];
    
    
    
}

#pragma mark 设置定时器－开／关
- (void)setTimer:(BOOL)on
{
    
    
    if (on) {
        if (!_timer) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
            [_timer fire];
        }
        
        
    }else{
        
        [_timer invalidate];
        _timer = nil;
        
    }
    
}
#pragma mark - xx
-(void)startTimer{
    
    if (!_isOptionalPage) {
        
        if (_dataArray.count>0) {
            [self getStockDetailList];
        }else{
            [self getssViewData];
            [self loadTopView];
            [_tableView reloadData];
        }
        
    }else{
        
        [self getssViewData];
        
        if (_optionalDataArray.count>0) {
            [self getStockDetailList];
            
        }else{
            [_optionalTableView reloadData];
            [self loadTopView];
            
        }
        
    }
    
}

#pragma mark 获取个人持仓数据 //个人自选股数据；
- (void)getData
{
    
    [self setTimer:NO];
    NSString * token = [[CMStoreManager sharedInstance] getUserToken];
    PositionViewController * safeSelf = self;
    if (!self.isOptionalPage)
    {   NSDictionary * dic = @{@"version":VERSION,
                               @"token":token};
        NSString * urlStr = K_ORDER_STOCKPOSI;
        [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
            
            if ((NSNull*)dictionary != [NSNull null] && dictionary != nil&&dictionary!=NULL )
            {
                
                if([dictionary[@"code"] intValue]==200){
                   
                    [self stopreport];
                    _positionRollView.hidden = YES;

                    _positionDModel  = [PositionDModel modelObjectWithDictionary:dictionary];
                    NSMutableArray * array= (NSMutableArray*)_positionDModel.data.orderList;
                    
                    if (array.count>0) {
                        if (_dataArray.count>0) {
                            [_dataArray removeAllObjects];
                            
                        }
                        NSMutableArray * mulArray = [NSMutableArray array];
                        
                        
                        for (PositionOrderList * positionList in array) {
                            [mulArray addObject:positionList];
                        }
                        _dataArray = mulArray;
                        
                        [self getStockDetailList];
                    }else{
                        if (_dataArray.count>0) {
                            [_dataArray removeAllObjects];
                            
                        }else{
                            
                            [_newPriceArray removeAllObjects];
                        }
                        [_tableView reloadData];
                        [self loadTopView];
                        
                        
                    }

                }
            }
            
            if (_dataArray.count<=0) {
                [self getFinancyValueReport:YES];

            }
            [self endLoading];
        } failureBlock:^(NSError *error) {
            [self endLoading];
//            [_dataArray removeAllObjects];
//            [_newPriceArray removeAllObjects];
//            [_tableView reloadData];
            [self loadTopView];
            [self getFinancyValueReport:YES];
            
        }];
    }else {
        if (_loadMore) {
            _startLine ++;
            
        }
        NSDictionary * dic = @{
                               @"token":token,
                               @"pageNo":[NSNumber numberWithInt:_startLine],
                               @"pageSize":[NSNumber numberWithInt:_loadNum],
                               @"version":@"0.01"
                               
                               };
        
        [NetRequest postRequestWithNSDictionary:dic url:K_FAVORITESLIST successBlock:^(NSDictionary *dictionary) {
            if ((NSNull*)dictionary != [NSNull null] && dictionary != nil&&dictionary!=NULL )
            {
                if ([dictionary[@"code"] intValue] == 200) {
                    
                    
                    NSMutableArray * array = [NSMutableArray arrayWithArray:dictionary[@"data"]] ;
                    
                    if (_loadMore) {
                        
                        [_optionalDataArray  addObjectsFromArray:array];
                    }else{
                        
                        [_optionalDataArray removeAllObjects];
                        _optionalDataArray = array;
                    }
                    
                    
                    
                    if (_optionalDataArray.count>0) {
                        _addoptionalView.hidden = YES;
                        [self getStockDetailList];
                    }else {
                        
                        [_optionalDataArray removeAllObjects];
                        [_newPriceOptArray removeAllObjects];
                        [_optionalTableView reloadData];
                        [safeSelf loadTopView];
                        
                    }
                    
                }
            }
            [self endLoading];
            
        } failureBlock:^(NSError *error) {
            
            [safeSelf loadTopView];
            [self endLoading];

        }];
        
    }
}

#pragma mark - 获取未持仓状态播报

- (void)getFinancyValueReport:(BOOL)report
{
    [self stopreport];

    //获取平仓累计持仓，盈利

    [NetRequest postRequestWithNSDictionary:nil url:K_FINANCY_STATISTICS successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200) {
            
            float profit = [dictionary[@"data"][@"profit"] floatValue];
            
            [_positionRollView setMoneyLabText:profit];
        }
        
    } failureBlock:^(NSError *error) {
        
        
    }];
    
    if (!report) {
        return;
    }
    
    //获取页面播报数据
    
    PositionViewController * positionVC = self;
    [NetRequest postRequestWithNSDictionary:nil url:K_FINANCY_ROLL successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200) {
            
            _rollDataArray = dictionary[@"data"];
            [positionVC timerInit];
            
        }
        
        
    } failureBlock:^(NSError *error) {
        
        
    }];
    [self loadTopView];
    
}

#pragma mark - 初始化播报的定时器
- (void)timerInit
{
    [_positionRollView setRollViewDictionary:_rollDataArray];
    
}



#pragma mark 刷新持仓头部

- (void)loadTopView
{
    
    int posiState = 5;
    
    CGRect earnRect = _positionView.earnLab.frame;
    
    [_positionView.earnLab removeFromSuperview];
    _positionView.earnLab = nil;
    
    _positionView.earnLab = [[UILabel alloc] initWithFrame:earnRect];
    _positionView.earnLab.font = [UIFont systemFontOfSize:50];
    _positionView.earnLab.textColor = [UIColor whiteColor];
    [_positionView addSubview:_positionView.earnLab];
    
    if (self.isOptionalPage) {
        
        if (_optionalDataArray.count>0) {
            _addoptionalView.hidden = YES;
            _optionalTopView.frame = CGRectMake(0, 0, ScreenWidth, 80);
        }else{
            
            _addoptionalView.hidden = NO;
            _optionalTopView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth-64);
            
        }
        
        _optionalTableView.tableHeaderView = _optionalTopView;
        
    }else{
        
        NSArray * array =_dataArray;
        
        if (array.count>0) {
            _positionView.markll.hidden = NO;
            [self stopreport];
            _positionRollView.hidden = YES;

            _positionView.inteEarnTitleLab.hidden = YES;
            
            _positionView.frame = CGRectMake(0, 0, ScreenWidth, 200-64);
            _headerView.frame = CGRectMake(0, 0, ScreenWidth, 200-64);
            _positionView.backView.frame = _positionView.frame;
            _tableView.tableHeaderView = _headerView;
            
            if (_curCashProfit>0||(_curCashProfit==0&&_curScoreProfit>0)) {
                posiState = 6;
                _ssNavState = 6;
                _positionView.markll.text = @"+";
                
            }else if(_curCashProfit<0||(_curCashProfit==0&&_curScoreProfit<0)){
                posiState = 7;
                _ssNavState = 7;
                
                _positionView.markll.text = @"-";
                
            }else{
                posiState = 5;
                _ssNavState = 5;
                
            }
            
            
            _positionView.earnTitleLab.text = @"持仓收益";
            NSString * earnStr;
            if (_curCashProfit>100000||_curCashProfit<-100000) {
                float curCashProfit = _curCashProfit/10000;
                earnStr = [NSString stringWithFormat:@"%.2f万元",curCashProfit];
                _positionView.markll.text = @"+";
                
            }else{
                
                
                earnStr = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",_curCashProfit]];
                earnStr = [NSString stringWithFormat:@"%@元",earnStr];
                _positionView.markll.text = @"+";
                
            }
            if (_curCashProfit<0) {
                _positionView.markll.text= @"-";
                earnStr = [earnStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
            }
            
            
            NSAttributedString * earnstr = [Helper multiplicityText:earnStr from:(int)earnStr.length-1 to:1 font:14];
            
            _positionView.earnLab.text = @"";
            
            _positionView.earnLab.attributedText = nil;
            
            _positionView.earnLab.attributedText = earnstr;
            
            NSString * inteEarnStr;
            if(_curScoreProfit==0)
            {
                inteEarnStr = @"0";
            }else
            {
                
                inteEarnStr = [DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",_curScoreProfit]];
                
                
            }
            
            if(_curScoreProfit>=0){
                
                inteEarnStr = [NSString stringWithFormat:@"+%@",inteEarnStr];
                
            }
            inteEarnStr = [NSString stringWithFormat:@"%@积分",inteEarnStr];
            NSAttributedString* attributeInteEarn = [Helper multiplicityText:inteEarnStr from:(int)inteEarnStr.length-2 to:2 font:14];
            _positionView.inteEarnLab.attributedText =attributeInteEarn;
            _shView.hidden = YES;
            _szView.hidden = YES;
            _lineLab.hidden = YES;
            _tableView.scrollEnabled =YES;
            
            _positionView.earnTitleLab.frame =CGRectMake(20, 20, ScreenWidth, 10);
            _positionView.earnLab.frame =CGRectMake(35, _positionView.earnTitleLab.frame.origin.y+_positionView.earnTitleLab.frame.size.height+5, ScreenWidth, 40);
            _positionView.markll.frame = CGRectMake(20, _positionView.earnTitleLab.frame.origin.y+_positionView.earnTitleLab.frame.size.height, 20, 20);
            _positionView.inteEarnLab.frame = CGRectMake(20, _positionView.earnLab.frame.origin.y+_positionView.earnLab.frame.size.height+10, ScreenWidth, 20);
            
        }else {
            _ssNavState = 5;
            _positionView.frame = CGRectMake(0, 0, ScreenWidth, 240-64);
            _positionView.backView.frame = _positionView.frame;
            _positionView.backView.image = K_setImage(@"background_header_05");
            
            _backImageView.image = K_setImage(@"background_nav_05");
            _headerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth-40);
            _positionRollView.hidden = NO;
            [_headerView bringSubviewToFront:_positionView];
            _shView.hidden = NO;
            _szView.hidden = NO;
            _lineLab.hidden = NO;
            _positionRollView.frame = CGRectMake(0, _positionView.frame.size.height, ScreenWidth, ScreenHeigth - _positionView.frame.size.height-64);
            _positionView.inteEarnTitleLab.hidden = NO;
            _positionView.earnTitleLab.text = @"可用现金";
            _positionView.inteEarnTitleLab.text =@"可用积分";
            _tableView.tableHeaderView = _headerView;
            NSString * earnStr = _positionDModel.data.usedAmt;
            if (!_isLogin) {
                earnStr = @"0.00";
            }
            
            NSString * earntext ;
            
            
            int unit = 0;
            
            if ((NSNull*)earnStr != [NSNull null] && earnStr != nil&&earnStr!=NULL )
            {
                
                
                if (earnStr.floatValue >= 10000.0||earnStr.floatValue <= -10000.0 ) {
                    
                    earntext = [NSString stringWithFormat:@"%.2f万元",earnStr.floatValue/10000];
                    unit = 2;
                    
                }else{
                    
                    earntext = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",earnStr.floatValue]];
                    earntext = [NSString stringWithFormat:@"%@元",earntext];
                    unit = 1;
                }
                
                
                
            }else if(!earntext)
            {
                earntext =@"0.00元";
                unit = 1;
                
            }
            
            _positionView.markll.hidden = YES;
            
            NSAttributedString * mulearnstr = [Helper multiplicityText:earntext from:(int)earntext.length-unit to:unit  font:14];
            
            _positionView.earnLab.text = @"";
            
            _positionView.earnLab.attributedText = nil;
            
            _positionView.earnLab.attributedText = mulearnstr;
            if ((NSNull*)_positionDModel.data.score != [NSNull null] && _positionDModel.data.score != nil )
            {
                NSString * earnStr =_positionDModel.data.score;
                if (!_isLogin) {
                    earnStr = @"0";
                }
                _positionView.inteEarnLab.text = [DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",earnStr.floatValue]];
                
            }else
            {
                _positionView.inteEarnLab.text = @"0";
            }
            //            [self getssViewData];
            _positionRollView.hidden = NO;
            _positionView.earnTitleLab.frame =CGRectMake(20, 10, ScreenWidth, 10);
            _positionView.earnLab.frame =CGRectMake(20, _positionView.earnTitleLab.frame.origin.y+_positionView.earnTitleLab.frame.size.height, ScreenWidth, 40);
            _positionView.inteEarnTitleLab.frame =CGRectMake(20, _positionView.earnLab.frame.origin.y+_positionView.earnLab.frame.size.height+10, ScreenWidth, 10);
            _positionView.inteEarnLab.frame = CGRectMake(20, _positionView.inteEarnTitleLab.frame.origin.y+_positionView.inteEarnTitleLab.frame.size.height, ScreenWidth, 20);
        }
    }
    
    if (_isOptionalPage) {
        if (_ssNavState!=5) {
            _backImageView.image = K_setImage(@"background_nav_05");
            
        }
        
    }else {
        if (_ssNavState != 5) {
            
            NSString * navImageName = [NSString stringWithFormat:@"background_nav_0%d",_ssNavState];
            _backImageView.image = K_setImage(navImageName);
            
        }else{
            
            _backImageView.image = K_setImage(@"background_nav_05");
            
            
        }
        
        if (posiState!=_positionState) {
            
            
            _positionState = posiState;
            switch (_positionState) {
                case 5:
                {
                    
                    _positionView.backView.image = K_setImage(@"background_header_05");
                    
                    
                }
                    break;
                case 6:
                {
                    _positionView.backView.image = K_setImage(@"background_header_06");
                }
                    break;
                case 7:
                {
                    _positionView.backView.image = K_setImage(@"background_header_07");
                }
                    break;
                    
                default:
                    break;
            }
            
        }
    }
    
}

#pragma mark - 获取指数
- (void)getssViewData
{
    //上证指数、深圳指数获取、板块数据、股票数据
    HsStock *stockSH = [[HsStock alloc] init];
    stockSH.stockCode = @"1A0001";//上证指数
    stockSH.codeType = @"XSHG.MRI";
    [_dataCenter loadRealtime:stockSH withHandleBlock:^(id result){
        if ((NSNull*)result == [NSNull null] || result == nil )
        {
            
        }else{
            HsRealtime * realTime = result;
            
            if (!_realtimeSH) {
                _realtimeSH = [[RealTimeStockModel alloc] init];
            }
            _realtimeSH.name = realTime.name;
            _realtimeSH.price = realTime.newPrice;
            _realtimeSH.priceChange = realTime.priceChange;
            _realtimeSH.priceChangePerCent = realTime.priceChangePercent;
            [_shView setViewValue:_realtimeSH];
            [_shViewP setSSViewValue:_realtimeSH];
        }
    }];
    
    //上证指数、深圳指数获取、板块数据、股票数据
    HsStock *stockSZ = [[HsStock alloc] init];
    stockSZ.stockCode = @"2A01";//深圳指数
    stockSZ.codeType = @"XSHE.MRI";
    
    [_dataCenter loadRealtime:stockSZ withHandleBlock:^(id result){
        if ((NSNull*)result == [NSNull null] || result == nil )
        {
            
        }else{
            HsRealtime * realTime = result;
            
            if (!_realtimeSZ) {
                _realtimeSZ = [[RealTimeStockModel alloc] init];
            }
            _realtimeSZ.name = realTime.name;
            _realtimeSZ.price = realTime.newPrice;
            _realtimeSZ.priceChange = realTime.priceChange;
            _realtimeSZ.priceChangePerCent = realTime.priceChangePercent;
            [_szView setViewValue:_realtimeSZ];
            [_szViewP setSSViewValue:_realtimeSZ];
        }
    }];
    
    
}
#pragma mark 跳转至融资1
- (void)goFinacPage
{
    self.rdv_tabBarController.selectedIndex = 1;
}

#pragma mark - 选择持仓与自选
- (void)changeScroll:(UISegmentedControl*)sender
{
    if (!_posiNavBackImage) {
        _posiNavBackImage = [[UIImage alloc] init];
    }
    if (sender.selectedSegmentIndex==0) {
        self.isOptionalPage = NO;
        _backImageView.image = _posiNavBackImage;
        
    }else{
        self.isOptionalPage = YES;
        _posiNavBackImage = _backImageView.image;
        _backImageView.image = K_setImage(@"background_nav_05");
    }
    
    
    
    [_backScrollView setContentOffset:CGPointMake(_backScrollView.frame.size.width*sender.selectedSegmentIndex, 0) animated:NO];
    [self loadHeader];
}

//#pragma mark - scrollView滑动 代理方法
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if ([scrollView isEqual:_backScrollView]) {
//        float contentOffset = _backScrollView.contentOffset.x;
//        if (contentOffset<10) {
//            _ssNavView.segControl.selectedSegmentIndex = 0;
//            self.isOptionalPage = NO;
//        }else{
//            _ssNavView.segControl.selectedSegmentIndex = 1;
//            self.isOptionalPage = YES;
//        }
//        [self changeScrollViewPage];
//
//    }
//}

//#pragma mark - 切换持仓自选
//
//- (void)changeScrollViewPage
//{
//
//    [self loadHeader];
//}

- (void)loadOptionalData
{
    
    [self getssViewData];
    
    
}
#pragma mark - 初始化UI界面
- (void)initUI
{
    
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _backImageView.image =K_setImage(@"background_nav_05");
    [self.view addSubview:_backImageView];
    
    //导航条
    _ssNavView = [[SSNavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [self.view addSubview:_ssNavView];
    _ssNavView.segControl.selectedSegmentIndex = 0;
    _isOptionalPage = NO;
    [_ssNavView.segControl addTarget:self action:@selector(changeScroll:) forControlEvents:UIControlEventValueChanged];
    [_ssNavView.searchBtn addTarget:self action:@selector(positionSearch) forControlEvents:UIControlEventTouchUpInside];
    [_ssNavView.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [_ssNavView addSubview:_ssNavView.backBtn];
    
    
    //已登陆
    
    //持仓与自选股滑动背景
    _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64)];
    _backScrollView.pagingEnabled = YES;
    _backScrollView.delegate = self;
    _backScrollView.scrollEnabled = NO;
    _backScrollView.contentSize = CGSizeMake(ScreenWidth*2, ScreenHeigth-64);
    [self.view addSubview:_backScrollView];
    
    
    // 持仓列表
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.autoresizesSubviews = NO;
    _tableView.alwaysBounceVertical = YES;
    _tableView.backgroundColor = K_COLOR_CUSTEM(248, 248, 248, 1);
    [_backScrollView addSubview:_tableView];
    
    
    //自选列表
    
    _optionalTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeigth-64) style:UITableViewStylePlain];
    _optionalTableView.dataSource = self;
    _optionalTableView.delegate = self;
    _optionalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _optionalTableView.autoresizesSubviews = NO;
    _optionalTableView.alwaysBounceVertical = YES;
    _optionalTableView.backgroundColor = K_COLOR_CUSTEM(248, 248, 248, 1);
    [_backScrollView addSubview:_optionalTableView];
    
    
    
    
    
    // 持仓头部
    if (_positionView != nil) {
        [_positionView removeFromSuperview];
        _positionView = nil;
    }
    _positionView = [[TopPositionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 175-64)];
    _positionView.backView.image = K_setImage(@"background_header_05");
    CGRect rect = _positionView.inteEarnLab.frame;
    
    _lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, rect.size.height+rect.origin.y+10,ScreenWidth, 1)];
    _lineLab.backgroundColor = K_COLOR_CUSTEM(191,191,191,1);
    [_positionView addSubview:_lineLab];
    PositionViewController * safeSelf = self;
    _shView = [[SSView alloc] initWithFrame:CGRectMake(10, _lineLab.frame.origin.y +7,self.view.frame.size.width/2-10, 50)];
    _shView.goDetail = ^(__strong id sender){
        
        
        HsStock *stockSH = [[HsStock alloc] init];
        stockSH.stockCode = @"1A0001";//上证指数
        stockSH.codeType = @"XSHG.MRI";
        [safeSelf goSSDetailView:stockSH];
        
        
    };
    _szView = [[SSView alloc] initWithFrame:CGRectMake(_shView.frame.origin.x+_shView.frame.size.width, _lineLab.frame.origin.y +7,_shView.frame.size.width, _shView.frame.size.height)];
    _szView.goDetail = ^(__strong id sender){
        
        HsStock *stockSZ = [[HsStock alloc] init];
        stockSZ.stockCode = @"2A01";//深圳指数
        stockSZ.codeType = @"XSHE.MRI";
        
        [safeSelf goSSDetailView:stockSZ];
        
    };
    [_positionView addSubview:_szView];
    [_positionView addSubview:_shView];
    
    //自选头部
    _optionalTopView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    
    UIImageView * optionalImageView = [[UIImageView alloc] initWithFrame:_optionalTopView.frame];
    optionalImageView.image = K_setImage(@"background_header_05");
    [_optionalTopView addSubview:optionalImageView];
    
    _shViewP = [[SSView alloc] initSSViewWithFrame:CGRectMake(20, 10,self.view.frame.size.width/2-10, 70)];
    _shViewP.goDetail= ^(__strong id sender){
        
        
        HsStock *stockSH = [[HsStock alloc] init];
        stockSH.stockCode = @"1A0001";//上证指数
        stockSH.codeType = @"XSHG.MRI";
        [safeSelf goSSDetailView:stockSH];
        
        
    };
    _szViewP = [[SSView alloc] initSSViewWithFrame:CGRectMake(_shViewP.frame.origin.x+_shViewP.frame.size.width, 10,_shViewP.frame.size.width, _shViewP.frame.size.height)];
    _szViewP.goDetail = ^(__strong id sender){
        
        HsStock *stockSZ = [[HsStock alloc] init];
        stockSZ.stockCode = @"2A01";//深圳指数
        stockSZ.codeType = @"XSHE.MRI";
        
        [safeSelf goSSDetailView:stockSZ];
        
    };
    [_optionalTopView addSubview:_shViewP];
    [_optionalTopView addSubview:_szViewP];
    
    
    //没有自选股时
    _addoptionalView = [[UIView alloc] initWithFrame: CGRectMake(0, _optionalTopView.frame.size.height, ScreenWidth, ScreenHeigth - _optionalTopView.frame.size.height)];
    _addoptionalView.userInteractionEnabled = YES;
    
    
    UIButton * addOptionalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addOptionalBtn.center = CGPointMake(ScreenWidth/2, 150);
    addOptionalBtn.bounds = CGRectMake(0, 0, 50, 50);
    addOptionalBtn.layer.cornerRadius = 25;
    addOptionalBtn.layer.masksToBounds = YES;
    [addOptionalBtn setImage:[UIImage imageNamed:@"Button_19"] forState:UIControlStateNormal];
    [addOptionalBtn addTarget:self action:@selector(positionSearch) forControlEvents:UIControlEventTouchUpInside];
    [_addoptionalView addSubview:addOptionalBtn];
    
    
    UILabel * addpotionalLab = [[UILabel alloc] init];
    addpotionalLab.center = CGPointMake(ScreenWidth/2, addOptionalBtn.frame.origin.y+addOptionalBtn.frame.size.height +10);
    addpotionalLab.bounds = CGRectMake(0, 0, ScreenWidth, 15);
    addpotionalLab.font = [UIFont systemFontOfSize:15];
    addpotionalLab.text = @"添加自选股";
    addpotionalLab.textColor = K_COLOR_CUSTEM(178, 178, 178, 1);
    addpotionalLab.textAlignment = NSTextAlignmentCenter;
    [_addoptionalView addSubview:addpotionalLab];
    [_optionalTopView addSubview:_addoptionalView];
    _optionalTableView.tableHeaderView = _optionalTopView;
    
    
    //已登录但没有订单——滚动播报
    
    _positionRollView = [[UnloginPositionView alloc] initWithFrame: CGRectMake(0, _positionView.frame.size.height, ScreenWidth, ScreenHeigth - _positionView.frame.size.height)];
    _positionRollView.tag = 200000;
    [_positionRollView.goFinacBtn addTarget:self action:@selector(goFinacPage) forControlEvents:UIControlEventTouchUpInside];
    _headerView = [[UIView alloc] initWithFrame:_positionView.frame];
    [_headerView addSubview:_positionRollView];
    [_headerView addSubview:_positionView];
    _tableView.tableHeaderView = _headerView;
    [self initRefresh];
}

- (void)goSSDetailView:(HsStock*)stock
{
    
    StockDetailViewController *stockDetailVC= [[StockDetailViewController alloc] init];
    stockDetailVC.isExponent = YES;
    stockDetailVC.stock = stock;
    [self.navigationController pushViewController:stockDetailVC animated:YES];
    
    
}
#pragma mark - 获取行情列表
- (void)getStockDetailList
{
    
    _dataCenter = [h5DataCenterMgr sharedInstance].dataCenter;
    NSMutableArray *array = [NSMutableArray array];
    
    if (!self.isOptionalPage) {
        
        for (PositionOrderList * posibolist in _dataArray) {
            
            if((NSNull*)posibolist.stockCode!=[NSNull null]&& posibolist.stockCode!=nil){
                
                HsStock * stock = [[HsStock alloc] init];
                stock.stockName = posibolist.stockName;
                stock.stockCode = posibolist.stockCode;
                stock.codeType = posibolist.typeCode;
                [array addObject:stock];
                
            }
        }
        
        //        NSMutableSet * set = [NSMutableSet setWithArray:array];
        [_dataCenter loadRealtimeList:array withHandleBlock:^(id data) {
            
            NSMutableArray * array = [NSMutableArray arrayWithArray:data];
            if ((NSNull*)data == [NSNull null] || data == nil )
            {
                
            }else {
                if (_newPriceArray.count>0) {
                    [_newPriceArray removeAllObjects];
                }
                
                
                _newPriceArray = array;
                
                
                
                for (int i = 0; i<_dataArray.count; i++) {
                    
                    PositionOrderList * posibolist = _dataArray[i];
                    
                    
                    
                    if (_newPriceArray.count>0) {
                        for (HsRealtime * realtime in _newPriceArray) {
                            
                            
                            if([realtime.code isEqualToString:posibolist.stockCode]){
                                
                                // 当前价
                                NSString *curPriceStr = [NSString stringWithFormat:@"%.2f",realtime.newPrice];
                                //
                                posibolist.stockName = realtime.name;
                                posibolist.curPrice = [curPriceStr doubleValue];
                                if (posibolist.curPrice==0) {
                                    posibolist.curPrice = realtime.preClosePrice;
                                }
                                posibolist.preClosePrice = realtime.preClosePrice;
                                [_dataArray replaceObjectAtIndex:i withObject:posibolist];
                                break;
                                
                            };
                        }
                    }else {
                        
                        
                        return;
                    }
                    
                    
                }
                
                
                [self getearn];
                
                if (!_isOptionalPage) {
                    [_tableView reloadData];
                }
            }
        }];
        
    }else{
        for (NSDictionary * dictionary in _optionalDataArray) {
            
            HsStock * stock = [[HsStock alloc] init];
            stock.stockName = dictionary[@"stockName"];
            stock.stockCode = dictionary[@"stockCode"];
            stock.codeType = dictionary[@"stockCodeType"];
            [array addObject:stock];
            
            
        }
        
        
        if (_optionalDataArray.count<=0) {
            
            
        }else{
            
            //            NSMutableSet * set = [NSMutableSet setWithArray:array];
            [_dataCenter loadRealtimeList:array withHandleBlock:^(id data) {
                
                NSMutableArray * array = [NSMutableArray arrayWithArray:data];
                if ((NSNull*)data == [NSNull null] || data == nil )
                {
                    
                }else {
                    
                    _newPriceOptArray = array;
                    if (_isOptionalPage) {
                        
                        [_optionalTableView reloadData];

                    }
                    
                    [self loadTopView];
                    
                }
            }];
            
        }
        
    }
    
}
#pragma mark - 计算收益
- (void)getearn
{
    _curScoreProfit = 0;
    _curCashProfit = 0;
    
    
    for (int i = 0; i<_dataArray.count; i++) {
        
        PositionOrderList * posibolist = _dataArray[i];
        
        if (posibolist.status==3||posibolist.status==4||posibolist.status==5) {
            
            
            NSString *buyStr = [NSString stringWithFormat:@"%.2f",posibolist.buyPrice];
            NSString *curPriceStr = [NSString stringWithFormat:@"%.2f",posibolist.curPrice];
            
            if (!curPriceStr) {
                curPriceStr = @"0.00";
                
            }
            //收益、积分收益
            if (posibolist.fundType == 0) {
                
                if (curPriceStr.doubleValue != 0) {
                    _curCashProfit = _curCashProfit +(curPriceStr.doubleValue-buyStr.doubleValue)*posibolist.factBuyCount;
                }
                
            }else{
                if (curPriceStr.doubleValue != 0) {
                    _curScoreProfit = _curScoreProfit +(curPriceStr.doubleValue -buyStr.doubleValue)*posibolist.factBuyCount;
                }
                
                
            }
            
            
            
        }
        
        
    }
    
    
    [self loadTopView];
}
#pragma mark - 搜索
- (void)positionSearch
{
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    searchVC.dataCenter = [h5DataCenterMgr sharedInstance].dataCenter;
    [self.navigationController pushViewController:searchVC animated:YES];
}
#pragma mark - 返回
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 去登录
- (void)goLogIn:(id)sender {
    
    self.rdv_tabBarController.selectedIndex = 2;
}

#pragma mark - 通知－切换持仓／自选
-(void)changePagePosition:(NSNotification*)notify
{
    if (_isOptionalPage) {
        _isOptionalPage = NO;
        _ssNavView.segControl.selectedSegmentIndex = 0;
        [_backScrollView setContentOffset:CGPointMake(_backScrollView.frame.size.width*_ssNavView.segControl.selectedSegmentIndex, 0) animated:YES];
        
        
    }else{
        return;
    }
    
}
- (void)loginSuc{
    [_dataArray  removeAllObjects];
    [_optionalDataArray removeAllObjects];
    [_newPriceArray removeAllObjects];
    [_newPriceOptArray removeAllObjects];
    
    [_tableView reloadData];
    [_optionalTableView reloadData];
    
    
}
- (void)getHistoryData

{
    
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    
    
    _positionDModel = cacheModel.positionPrivateIndex.positionDmodel;
    _dataArray=_dataArray.count==0? cacheModel.positionPrivateIndex.dataArray:_dataArray;
    _newPriceArray = _newPriceArray.count==0?cacheModel.positionPrivateIndex.dataDetailArray:_newPriceArray;
    _realtimeSZ = _realtimeSZ==nil?cacheModel.positionPrivateIndex.realtimeSZ:_realtimeSZ;
    _realtimeSH = _realtimeSH==nil?cacheModel.positionPrivateIndex.realtimeSH:_realtimeSH;
    if (_realtimeSH) {
        [_shView setViewValue:_realtimeSH];
        [_shViewP setSSViewValue:_realtimeSH];
    }
    if (_realtimeSZ) {
        [_szView setViewValue:_realtimeSZ];
        [_szViewP setSSViewValue:_realtimeSZ];
    }
    
    
    [self loadTopView];
    
    if (_isOptionalPage) {
        [_optionalTableView reloadData];
        
    }else{
        [_tableView reloadData];
        
        
    }
    
    
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (!self.isOptionalPage) {
        return _dataArray.count;
        
    }else{
        if (_newPriceOptArray.count>0) {
            return _newPriceOptArray.count ;
        }else{
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    PositionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PositionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    //自选股
    if (self.isOptionalPage) {
        cell.sourceMarkLab.hidden = YES;
        
        if (_newPriceOptArray.count>0&&_optionalDataArray.count>0) {
            
            
            NSDictionary * ortionalStockDic = _optionalDataArray[indexPath.row];
            __block float changePercent = 0.0;
            for (HsRealtime * realtime in _newPriceOptArray) {
                
                
                if([realtime.code isEqualToString:ortionalStockDic[@"stockCode"]]){
                    
                    cell.storkTitlelab.text =realtime.name;
                    cell.szDetailLab.text   = realtime.code;
                    // 当前价
                    
                    
                    if (realtime.tradeStatus==7||realtime.tradeStatus ==8||realtime.tradeStatus==21) {
                        cell.priceLab.text = [NSString stringWithFormat:@"%.2f",realtime.preClosePrice];
                        cell.priceLab.textColor = [UIColor grayColor];
                        cell.addLab.text = @"停牌";
                        [cell.addView setBackgroundColor:[UIColor grayColor]];
                        return cell;
                        
                        
                    }
                    
                    cell.priceLab.text = [NSString stringWithFormat:@"%.2f",realtime.newPrice];
                    //涨跌幅
                    cell.addLab.text = [NSString stringWithFormat:@"%.2f%%",realtime.priceChangePercent*100];
                    
                    
                    
                    changePercent = realtime.priceChangePercent;
                    break;
                    
                };
            }
            
            if (changePercent>0) {
                cell.priceLab.textColor =  RGBCOLOR(242, 41, 59);
                cell.addView.backgroundColor =  RGBCOLOR(242, 41, 59);
            }else if (changePercent==0){
                cell.priceLab.textColor =  RGBCOLOR(110, 110, 110);
                [cell.addView setBackgroundColor:[UIColor grayColor]];
            }else{
                cell.priceLab.textColor =  RGBCOLOR(8, 168, 66);
                cell.addView.backgroundColor =RGBCOLOR(8, 168, 66);
                
            }
            
            
        }
        
    }else{
        //持仓
        
        PositionOrderList * posibolist = _dataArray[indexPath.row];
        
        if (posibolist.fundType ==0) {
            cell.sourceMarkLab.hidden = YES;
        }else {
            cell.sourceMarkLab.hidden = NO;
        }
        
        cell.szDetailLab.text = posibolist.stockCode;
        NSString *buyStr = [NSString stringWithFormat:@"%.2f",posibolist.buyPrice];
        NSString *curPriceStr;
        float curCashProfit  = 0;
        for (HsRealtime * realtime in _newPriceArray) {
            
            if([realtime.code isEqualToString:posibolist.stockCode]){
                
                
                if (realtime.tradeStatus==7||realtime.tradeStatus ==8||realtime.tradeStatus==21) {
                    cell.storkTitlelab.text = posibolist.stockName;
                    cell.szDetailLab.text = posibolist.stockCode;
                    cell.priceLab.text = [NSString stringWithFormat:@" %.2f /%.2f",posibolist.buyPrice,posibolist.curPrice];
                    cell.addLab.text = @"停牌";
                    [cell.addView setBackgroundColor:[UIColor grayColor]];
                    return cell;
                }
            }
        }
        
        switch ((int)posibolist.status) {
            case 2:
            {
                
                
                cell.storkTitlelab.text = posibolist.stockName;
                cell.szDetailLab.text = posibolist.stockCode;
                cell.priceLab.text = [NSString stringWithFormat:@" -- /%.2f",posibolist.curPrice];
                cell.addLab.text = @"买已申报";
                [cell.addView setBackgroundColor:[UIColor grayColor]];
            }
                break;
            case 4:case 5:
            {
                
                cell.storkTitlelab.text = posibolist.stockName;
                cell.szDetailLab.text = posibolist.stockCode;
                cell.priceLab.text = [NSString stringWithFormat:@" %.2f/%.2f",posibolist.buyPrice,posibolist.curPrice];
                cell.addLab.text = @"卖已申报";
                [cell.addView setBackgroundColor:[UIColor grayColor]];
            }
                break;
            case 3:
            {
                
                
                //                if (_newPriceArray.count>0) {
                //                    for (HsRealtime * realtime in _newPriceArray) {
                //
                
                //                        if([realtime.code isEqualToString:posibolist.stockCode]){
                
                // 当前价
//                curPriceStr = [NSString stringWithFormat:@"%.2f",posibolist.curPrice];
//                cell.storkTitlelab.text =posibolist.stockName;
//                
//                // 收益
//                curCashProfit = (posibolist.curPrice - posibolist.buyPrice)*posibolist.factBuyCount;
                //                            break;
                
                //                        };
                //                    }
                //                }
                //                else{
                
                cell.storkTitlelab.text =posibolist.stockName;
                
                // 当前价
                curPriceStr = [NSString stringWithFormat:@"%.2f",posibolist.curPrice];
                // 收益
                curCashProfit =(posibolist.curPrice-posibolist.buyPrice)*posibolist.factBuyCount;
                //                }
                if (!curPriceStr) {
                    curPriceStr = @"0.00";
                    curCashProfit = 0.00;
                    
                    
                }
                
                if (curCashProfit>=10000||curCashProfit<= -10000)
                {
                    cell.addLab.text = [[DataEngine addSign:[NSString stringWithFormat:@"%.2f",curCashProfit/10000]] stringByAppendingString:@"万"];
                }
                else
                {
                    cell.addLab.text = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",curCashProfit]];
                }
                
                NSString *tempStr = [NSString stringWithFormat:@"%@ / %@",buyStr,curPriceStr];
                cell.priceLab.text = tempStr;
                cell.priceLab.textAlignment = NSTextAlignmentRight;
                [cell.priceLab setTextColor:RGBCOLOR(110, 110, 110)];
                
                
                
                
                //买入价，当前价
                if (curCashProfit<0)
                {
                    
                    cell.priceLab.attributedText = [Helper multiplicityText:cell.priceLab.text from:((int)cell.priceLab.text.length -(int)curPriceStr.length) to:(int)curPriceStr.length color:RGBCOLOR(8, 168, 66)];
                    cell.priceLab.attributedText = [Helper multableText:cell.priceLab.attributedText from:0 to:(int)cell.priceLab.attributedText.length-(int)curPriceStr.length color:K_COLOR_CUSTEM(110, 110, 110, 1)];
                    
                    [cell.addView setBackgroundColor:RGBCOLOR(8, 168, 66)];
                }else
                    
                    if (curCashProfit==0) {
                        
                        [cell.addView setBackgroundColor:[UIColor grayColor]];
                        
                    }
                    else
                    {
                        
                        if (curCashProfit>=10000)
                        {
                            cell.addLab.text = [[NSString stringWithFormat:@"+%@",[DataEngine addSign:[NSString stringWithFormat:@"%.2f",curCashProfit/10000]]] stringByAppendingString:@"万"];
                        }
                        else
                        {
                            cell.addLab.text = [NSString stringWithFormat:@"+%@",[DataEngine addSign:[NSString stringWithFormat:@"%.2f",curCashProfit]]];
                        }
                        
                        cell.priceLab.attributedText = [Helper multiplicityText:cell.priceLab.text from:(int)(cell.priceLab.text.length) -(int)(curPriceStr.length) to:(int)(curPriceStr.length) color:RGBCOLOR(242, 41, 59)];
                        cell.priceLab.attributedText = [Helper multableText:cell.priceLab.attributedText from:0 to:(int)(cell.priceLab.attributedText.length)-(int)(curPriceStr.length) color:K_COLOR_CUSTEM(110, 110, 110, 1)];
                        [cell.addView setBackgroundColor:RGBCOLOR(242, 41, 59)];
                    }
                cell.priceLab.attributedText = [Helper mulFontText:cell.priceLab.attributedText from:0 to:(int)cell.priceLab.attributedText.length font:14];
                cell.priceLab.textAlignment  = NSTextAlignmentRight;
//                
//                if ([curPriceStr isEqualToString:@"0.00"]) {
//                    NSString *tempStr;
//                    if (posibolist.preClosePrice !=0) {
//                        tempStr = [NSString stringWithFormat:@"%@ / %.2f",buyStr,posibolist.preClosePrice];
//                    }else{
//                        
//                        tempStr = [NSString stringWithFormat:@"%@ / --",buyStr];
//                        
//                    }
//                    
//                    
//                    cell.priceLab.attributedText = [Helper multiplicityText:tempStr from:0 to:(int)tempStr.length color:K_COLOR_CUSTEM(110, 110, 110, 1)];
//                    cell.addLab.text = @"停牌";
//                    cell.addView.backgroundColor = [UIColor grayColor];
//                    
//                }
            }
                break;
                
            default:
                break;
        }
        
    }
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (!_isOptionalPage) {
        if (_dataArray==nil||_dataArray.count<=0) {
            return nil;
        }
        
    }
    
    float  width = tableView.bounds.size.width;
    
    
    UIView * headerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 34)];
    UILabel * lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 4)];
    lineLab.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:lineLab];
    
    if (_dataArray.count>0&&!self.isOptionalPage) {
        headerView.backgroundColor = K_COLOR_CUSTEM(248, 248, 248, 1);
        
        UILabel * priceLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-210, 13, 90, 20)];
        priceLab.font = [UIFont systemFontOfSize:12.f];
        priceLab.textAlignment = NSTextAlignmentRight;
        priceLab.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
        [headerView addSubview:priceLab];
        
        
        
        UIButton  * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame =CGRectMake(ScreenWidth-80, 13, 80, 20);
        [addBtn setTitleColor:K_COLOR_CUSTEM(110, 110, 110, 1) forState:UIControlStateNormal];
        [addBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [headerView addSubview:addBtn];
        
        
        
        UILabel  *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height-0.8, ScreenWidth, 0.8)];
        [lineLabel setBackgroundColor:RGBCOLOR(191, 191, 191)];
        [headerView addSubview:lineLabel];
        
        priceLab.text = @"买入价/当前价";
        [addBtn setTitle:@"收益" forState:UIControlStateNormal];
        
        
    }else if(_optionalDataArray.count>0&&self.isOptionalPage){
        
        
        
        headerView.backgroundColor = K_COLOR_CUSTEM(248, 248, 248, 1);
        
        UILabel * priceLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-210, 13, 90, 20)];
        priceLab.font = [UIFont systemFontOfSize:12.f];
        priceLab.textAlignment = NSTextAlignmentRight;
        priceLab.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
        [headerView addSubview:priceLab];
        
        
        
        UIButton  * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame =CGRectMake(ScreenWidth-80, 13, 80, 20);
        [addBtn setTitleColor:K_COLOR_CUSTEM(110, 110, 110, 1) forState:UIControlStateNormal];
        [addBtn.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
        [headerView addSubview:addBtn];
        
        
        UILabel  *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height-0.8, ScreenWidth, 0.8)];
        [lineLabel setBackgroundColor:RGBCOLOR(191, 191, 191)];
        [headerView addSubview:lineLabel];
        
        priceLab.text = @"当前价";
        [addBtn setTitle:@"涨跌幅" forState:UIControlStateNormal];
        
        
    }
    
    
    return headerView;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_optionalTableView]&&_isOptionalPage) {
            return YES;
    }else{
        return NO;
        
        
        
    }
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *) indexPath
{
    [self setTimer:NO];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self deleteOptionalStock:_optionalDataArray[indexPath.row] forIndex:(int)indexPath.row];
        
    }
    
}
#pragma mark - 滑动删除自选股
-(void)deleteOptionalStock:(NSDictionary*)dict forIndex:(int)index
{
    NSString * token = [[CMStoreManager sharedInstance] getUserToken];
    
    
    
    
    __block  NSDictionary * dic = @{@"token":token,
                                    @"id":dict[@"id"],
                                    @"version":VERSION
                                    };
    [NetRequest postRequestWithNSDictionary:dic url:K_DELETE_FAVORITES successBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"code"] intValue] == 200) {
            NSDictionary * dic = _optionalDataArray[index];
            if (_optionalDataArray.count>=index+1) {
                
                [_optionalDataArray removeObjectAtIndex:index];
                
            }

            for (HsRealtime * realtime in _newPriceOptArray) {
                if ([realtime.code isEqualToString:dic[@"stockCode"]]) {
                    [_newPriceOptArray removeObject:realtime];
                    break;
                }
            }
            if (_optionalDataArray.count<10) {
                _loadMore = NO;
                _startLine = 1;
                [self getData];
            }else{
                
                [_optionalTableView reloadData];
            }
            
            
            
        }
        
    } failureBlock:^(NSError *error) {
        [self setTimer:YES];
        
    }];
    
    
}
-(UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOptionalPage) {
        return UITableViewCellEditingStyleDelete;
    }else{
        
        return UITableViewCellEditingStyleNone;
        
    }
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ((_isOptionalPage&&(_optionalDataArray.count<=0||_optionalDataArray==nil))||(!_isOptionalPage&&(_dataArray.count<=0||_dataArray==nil))) {
        return 0;
    }
    return 34;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    StockDetailViewController * stockDetailVC = [[StockDetailViewController alloc] init];
    HsStock * stock = [[HsStock alloc] init];
    
    if (!self.isOptionalPage) {
        
        PositionOrderList * posibolist = _dataArray[indexPath.row];
        int i = 0;
        if (posibolist.status ==3) {
            for (HsRealtime * realtime in _newPriceArray) {
                if([realtime.code isEqualToString:posibolist.stockCode]){
                    
                    stock.stockName = posibolist.stockName==nil?@"":posibolist.stockName;
                    stock.stockCode = posibolist.stockCode==nil?@"":posibolist.stockCode;
                    stock.codeType = posibolist.typeCode==nil?@"":posibolist.typeCode;
                    stockDetailVC.realtime = realtime;
                    stockDetailVC.isbuy = YES;
                    stockDetailVC.isPosition = YES;
                    stockDetailVC.source = @"position";
                    stockDetailVC.stockDetailStyle = stockDetailStylePosition;
                    stockDetailVC.userOrderList = _dataArray[indexPath.row];
                    stockDetailVC.odid =[NSString stringWithFormat:@"%.0f", posibolist.orderListIdentifier];
                    break;
                }
                i++;
                
            }
            if (i>=_newPriceArray.count) {
                
                return;
            }
        }else{
            return;
            
        }
        
    }else{
        NSDictionary *dictionary = _optionalDataArray[indexPath.row];
        stock.stockName = dictionary[@"stockName"] ==nil?@"":dictionary[@"stockName"];
        stock.stockCode = dictionary[@"stockCode"]==nil?@"":dictionary[@"stockCode"];
        stock.codeType =dictionary[@"stockCodeType"]==nil?@"":dictionary[@"stockCodeType"];
        for (HsRealtime * realtime in _newPriceArray) {
            if([realtime.code isEqualToString:stock.stockCode]){
                stockDetailVC.realtime = realtime;
            }
            break;
        }
        stockDetailVC.stockDetailStyle =  stockDetailStyleDefault;

        stockDetailVC.isbuy = NO;
        stockDetailVC.isPosition = NO;
        stockDetailVC.source = @"search";
        
        
    }
    stockDetailVC.stock = stock;
    stockDetailVC.stockIndex = indexPath.row;
    [self.navigationController pushViewController:stockDetailVC animated:YES];
    
    
}

#pragma mark Refresh 初始化下拉刷新

-(void)initRefresh{
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadHeader)];
    _optionalTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadHeader)];
    _optionalTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
}

-(void)loadHeader{
    _startLine = 1;
    _loadMore = NO;
    
    
    [self getData];
}

-(void)loadMore{
    _loadMore = YES;
    [self getData];
    
}

-(void)endLoading{
    [self setTimer:YES];
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
    [_optionalTableView.header endRefreshing];
    [_optionalTableView.footer endRefreshing];
}







- (void)viewDidLoad
{
    [super viewDidLoad];
    // 存储背景图片
    [[CMStoreManager sharedInstance] setbackgroundimage];
    
    [self getHistoryData];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    /*
     
     获取手机信息
     
     应用程序的名称和版本号等信息都保存在mainBundle的一个字典中，用下面代码可以取出来
     
     */
    
//    ShowGestureNotification;
//    
//    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
//    
//    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
//    
//    NSString*appName =[infoDict objectForKey:@"CFBundleDisplayName"];
//    
//    NSString*text =[NSString stringWithFormat:@"%@ %@",appName,versionNum];
////    NSLog(@"%@",text);
//    
//    NSString * strModel = [UIDevice currentDevice].model ;
//    
////    NSLog(@"%@",strModel);
//    
//    //手机别名： 用户定义的名称
//    
//    NSString* userPhoneName = [[UIDevice currentDevice] name];
//    
////    NSLog(@"手机别名: %@", userPhoneName);
//    
//    //设备名称
//    
//    NSString* deviceName = [[UIDevice currentDevice] systemName];
//    
////    NSLog(@"设备名称: %@",deviceName );
//    
//    //手机系统版本
//    
//    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
//    
////    NSLog(@"手机系统版本: %@", phoneVersion);
//    
//    //手机型号
//    
//    NSString* phoneModel = [[UIDevice currentDevice] model];
//    
////    NSLog(@"手机型号: %@",phoneModel );
//    
//    //地方型号 （国际化区域名称）
//    
//    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
//    
////    NSLog(@"国际化区域名称: %@",localPhoneModel );
//    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    
//    // 当前应用名称
//    
//    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
//    
////    NSLog(@"当前应用名称：%@",appCurName);
//    
//    // 当前应用软件版本 比如：1.0.1
//    
//    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    
////    NSLog(@"当前应用软件版本:%@",appCurVersion);
//    
//    // 当前应用版本号码 int类型
//    
//    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
//    
////    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
//    
//
    
    //注册通知－－购买股票成功时跳转持仓
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changePagePosition:) name:@"changePagePosition" object:nil];
    
    

    
    if ([self respondsToSelector: @selector(setEdgesForExtendedLayout:)] ) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //数据初始化
    _startLine = 1;
    _loadNum = 10;
    _positionState = 5;
    _dataArray = [NSMutableArray array];
    _newPriceArray = [NSMutableArray array];
    _optionalDataArray = [NSMutableArray array];
    _newPriceOptArray = [NSMutableArray array];
    _curCashProfit = 0;
    _optionalDataArray = [NSMutableArray array];
    [self initUI];
    
    
    
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
