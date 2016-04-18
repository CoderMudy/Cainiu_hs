//
//  FoyerTableView.m
//  hs
//
//  Created by PXJ on 15/9/11.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "FoyerTableView.h"
#import "SDCycleScrollView.h"
#import "FoyerTableViewCell.h"
#import "FoyerProductModel.h"
#define cellHeight 65

@interface FoyerTableView ()<SDCycleScrollViewDelegate>
{
    //大厅广告图点击链接数组
    NSMutableArray * _adHtmlArray;
    NSMutableArray * _productDataArray;
    NSString * _IP;
    NSString * _port;
    NSMutableArray * _positionNumArray;
    NSMutableArray * _positionCashNumArray;
    NSMutableArray * _reportArray;
    CGPoint          _tableViewOffSet;
    
    NSTimer *_dataTimer;
    BOOL _isLoadTable;
    
}
//头部广告滑动视图
@property (nonatomic,strong) SDCycleScrollView * cycleView;
@end
@implementation FoyerTableView

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
    if (self) {
        [self initdata];
        _tableViewOffSet = CGPointMake(0, 0);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth-143) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        [_tableView registerClass:[FoyerTableViewCell class] forCellReuseIdentifier:@"foyerCell"];
        [self addSubview:_tableView];
        [self initTableHeaderView];
        
    }
    return self;
}

- (void)viewAppearLoadData
{
    [self getpositionNum];
    _isLoadTable = YES;
    CacheModel * cachemodel =[ CacheEngine getCacheInfo];
    _tableView.contentOffset = _tableViewOffSet;
    switch (self.backStyle) {
        case BackStyleDefault:
        {
            if (cachemodel.productListArray)
            {
                _productDataArray = cachemodel.productListArray;//刷新产品列表
                [_tableView reloadData];
            }
            if (cachemodel.bannerArray)
            {
                if (cachemodel.bannerArray.count>0)
                {
                    if (_imageUrlArray.count>0)
                    {
                        [_imageUrlArray removeAllObjects];
                    }
                    if (_adHtmlArray.count>0)
                    {
                        [_adHtmlArray removeAllObjects];
                    }
                    for (NSDictionary * dic in cachemodel.bannerArray)
                    {
                        NSString * image    = dic[@"middleBanner"];
                        image               = [NSString stringWithFormat:@"%@%@",K_MGLASS_URL,image];
                        [_imageUrlArray addObject:image];
                        NSString * htmlUrl     = dic[@"url"]==nil?@"":dic[@"url"];
                        htmlUrl =[NSString stringWithFormat:@"%@%@",K_MGLASS_URL,htmlUrl];
                        NSString * titleName = dic[@"title"]==nil?@"活动":dic[@"title"];
                        NSDictionary * dic = @{@"titleName":titleName,@"html":htmlUrl};
                        [_adHtmlArray addObject:dic];
                    }
                    [self loadBaner];//刷新banner

                }
            }
            
            [self requestBannerData];//加载banner
        }
            break;
        case OtherPageBackStyle:
        {
            if (cachemodel.bannerArray)
            {
                if (cachemodel.bannerArray.count>0)
                {
                }else
                {
                    [self requestBannerData];//加载banner
                }
            }else
            {
                [self requestBannerData];//加载banner
            }
            [self requestBannerData];
            self.backStyle = BackStyleDefault;
        }
            break;
        case SubViewBackStyle:
        {
            self.backStyle = BackStyleDefault;
        }
            break;
        default:
            break;
    }
    [self requestProductData];//加载产品列表

}

- (void)viewDisAppearLoadData
{
    [ManagerHUD hidenHUD];
    _isLoadTable = NO;
    if (self.backStyle==SubViewBackStyle)
    {
    }else{
        self.backStyle = OtherPageBackStyle;
    }
    _tableViewOffSet = _tableView.contentOffset;
    [_dataTimer invalidate];
    _dataTimer = nil;
    _positionCashNumArray = [NSMutableArray array];
    _positionNumArray = [NSMutableArray array];
    
}
- (void)initdata
{
    _productDataArray = [NSMutableArray array];
    _positionNumArray = [NSMutableArray array];
    _positionCashNumArray = [NSMutableArray array];
    _reportArray      = [NSMutableArray array];
}
- (void)initTableHeaderView
{
    UIView * tabHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*ADScale+90*ScreenWidth/375)];
    UIView * subHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenWidth*ADScale, ScreenWidth, 89*ScreenWidth/375)];
    subHeaderView.tag = 8870;
    subHeaderView.backgroundColor = [UIColor whiteColor];
    [tabHeaderView addSubview:subHeaderView];
    
    
    NSArray * array = @[@{@"name":@"模拟练习场",@"detail":@"免费练手成大牛",@"imgName":@"foyer_3"},
                        @{@"name":@"免费领现金",@"detail":@"轻点指尖秒进账",@"imgName":@"foyer_4"},
                        @{@"name":@"节假日历史盘",@"detail":@"怒上排行奖现金",@"imgName":@"foyer_5"}];
    float subLength = (ScreenWidth-20-2)/3;
    for (int i=0; i<3; i++) {
        
        UIView * subSubView = [[UIView alloc] initWithFrame:CGRectMake(10+(subLength+1)*i, 0, subLength, 89*ScreenWidth/375-1)];
        subSubView.tag = 8880+i;
        subSubView.backgroundColor =[UIColor whiteColor];
        [subHeaderView addSubview:subSubView];
        UILabel * name = [[UILabel alloc] init];
        name.center = CGPointMake(subLength/2, 15*ScreenWidth/375);
        name.bounds = CGRectMake(0, 0, subLength, 15);
        name.font = FontSize(13);
        name.text = array[i][@"name"];
        name.textAlignment = NSTextAlignmentCenter;
        [subSubView addSubview:name];
        
        UILabel * detail = [[UILabel alloc] init];
        detail.center = CGPointMake(subLength/2, 29*ScreenWidth/375);
        detail.bounds = CGRectMake(0, 0, subLength, 12);
        detail.font = FontSize(9);
        detail.text = array[i][@"detail"];
        detail.textColor = K_color_grayBlack;
        detail.textAlignment = NSTextAlignmentCenter;
        [subSubView addSubview:detail];
        
        UIImageView * imgV = [[UIImageView alloc] init];
        imgV.center = CGPointMake(subLength/2, 60*ScreenWidth/375);
        imgV.bounds = CGRectMake(0, 0, 40*ScreenWidth/375, 40*ScreenWidth/375);
        imgV.image = [UIImage imageNamed:array[i][@"imgName"]];
        [subSubView addSubview:imgV];
        
        UIControl * control = [[UIControl alloc] init];
        control.frame = CGRectMake(0, 0, subLength, 90*ScreenWidth/375-1);
        control.tag = 8888+i;
        [control addTarget:self action:@selector(goPage:) forControlEvents:UIControlEventTouchUpInside];
        [subSubView addSubview:control];
        if (i<2)
        {
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(subSubView.frame), 10, 1, 89*ScreenWidth/375-20)];
            line.backgroundColor = K_color_line;
            [subHeaderView addSubview:line];
        }
    }
    tabHeaderView .backgroundColor  = K_color_line;
    _tableView.tableHeaderView = tabHeaderView;
    
}

#pragma mark - 获取用户持仓订单数量

- (void)getpositionNum
{
    if ([[CMStoreManager sharedInstance] isLogin])
    {
        //期货持仓
        [RequestDataModel requestPosiOrderNum:NO successBlock:^(BOOL success, NSArray *dataArray)
         {
             if (dataArray.count>0)
             {
                 _positionNumArray = [NSMutableArray arrayWithArray:dataArray];
             }else
             {
             }
             [_tableView reloadData];
         }];
        //现货持仓
        if (![[SpotgoodsAccount sharedInstance] isNeedLogin])//南交所用户登录后需要请求现货持仓数量
        {
            [RequestDataModel requestPosiOrderNum:YES successBlock:^(BOOL success, NSArray *dataArray)
             {
                 if (dataArray.count>0)
                 {
                     _positionCashNumArray = [NSMutableArray arrayWithArray:dataArray];
                 }else
                 {
                 }
                 [_tableView reloadData];
             }];
        }
        
    }
}
#pragma mark - 请求Banner数据
- (void)requestBannerData//加载banner
{
    
    if (!_imageUrlArray)
    {
        _imageUrlArray = [NSMutableArray array];
    }
    if(!_adHtmlArray)
    {
        _adHtmlArray = [NSMutableArray array];
    }
    [RequestDataModel requestBanerDataSuccessBlock:^(BOOL success, NSArray *dataArray)
     {
         if (success) {
             if (dataArray.count>0)
             {
                 CacheModel * cacheModel = [CacheEngine getCacheInfo];
                 cacheModel.bannerArray  = [NSMutableArray arrayWithArray:dataArray];
                 [CacheEngine setCacheInfo:cacheModel];
                 if (_imageUrlArray.count>0)
                 {
                     [_imageUrlArray removeAllObjects];
                 }
                 if (_adHtmlArray.count>0)
                 {
                     [_adHtmlArray removeAllObjects];
                 }
                 for (NSDictionary * dic in dataArray)
                 {
                     NSString * image    = dic[@"middleBanner"];
                     image               = [NSString stringWithFormat:@"%@%@",K_MGLASS_URL,image];
                     [_imageUrlArray addObject:image];
                     NSString * htmlUrl     = dic[@"url"]==nil?@"":dic[@"url"];
                     htmlUrl =[NSString stringWithFormat:@"%@%@",K_MGLASS_URL,htmlUrl];
                     NSString * titleName = dic[@"title"]==nil?@"活动":dic[@"title"];
                     NSDictionary * dic = @{@"titleName":titleName,@"html":htmlUrl};
                     [_adHtmlArray addObject:dic];
                 }
             }
             [self loadBaner];
         }else
         {
             [self performSelector:@selector(requestBannerData) withObject:nil afterDelay:30];
         }
     }];
}
#pragma mark 刷新banner
- (void)loadBaner
{
    if (_cycleView !=nil)
    {
        _cycleView = nil;
        [_cycleView removeFromSuperview];
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*ADScale) imageURLsGroup:_imageUrlArray];
        if (_imageUrlArray.count==1)
        {
            _cycleView.canMove = NO;
            _cycleView.pageControlDotSize = CGSizeMake(0.1, 0.1);
        }else{
            _cycleView.canMove = YES;
            _cycleView.pageControlDotSize = CGSizeMake(5, 5);
        }
        _cycleView.delegate = self;
        _cycleView.autoScrollTimeInterval = 3.0;
        
        UIView * tableHeaderView = _tableView.tableHeaderView;
        [tableHeaderView addSubview:_cycleView];
        _tableView.tableHeaderView = tableHeaderView;
    }else{
        
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*ADScale) imageURLsGroup:_imageUrlArray];
        
        if (_imageUrlArray.count==1)
        {
            _cycleView.canMove = NO;
            _cycleView.pageControlDotSize = CGSizeMake(0.1, 0.1);
        }else
        {
            _cycleView.canMove = YES;
            _cycleView.pageControlDotSize = CGSizeMake(5, 5);
        }
        _cycleView.delegate = self;
        _cycleView.autoScrollTimeInterval = 3.0;
        
        UIView * tableHeaderView = _tableView.tableHeaderView;
        [tableHeaderView addSubview:_cycleView];
        _tableView.tableHeaderView = tableHeaderView;
    }
}

#pragma mark 点击banner

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSDictionary * dic = _adHtmlArray[(int)index];
    self.backStyle = SubViewBackStyle;
    self.pushBlock(@"ActivityPage",dic,nil);
}
#pragma mark 点击模拟。。。
- (void)goPage:(UIControl*)control
{
    UIView * subHeader = [_tableView.tableHeaderView viewWithTag:8870];
    UIView * subSubView = [subHeader viewWithTag:control.tag-8];
    subSubView.backgroundColor = K_COLOR_CUSTEM(210, 210, 210, 1);
    [self performSelector:@selector(clickTabHeaderSubView:) withObject:subSubView afterDelay:0.1];
    switch (control.tag)
    {
        case 8888:
        {
            //    //积分模拟
            self.pushBlock(@"FoyerScorePage",nil,nil);
        }
            break;
        case 8889:
        {
            if ([[CMStoreManager sharedInstance] isLogin])
            {
                    //任务中心
                    self.pushBlock(@"TaskCenterH5Page",nil,nil);
            }else{
                [self goLogin];
            }
        }
            break;
        case 8890:
        {
            //假期盘
            self.pushBlock(@"FoyerHolidayPage",nil,nil);
        }
            break;
        default:
            break;
    }
}
- (void)clickTabHeaderSubView:(UIView*)subSubView
{
    subSubView.backgroundColor = [UIColor whiteColor];
}


#pragma mark 去登录
- (void)goLogin
{
    self.pushBlock(@"LoginViewController",nil,nil);
}
#pragma mark 请求大厅产品列表
- (void)requestProductData
{
    [RequestDataModel requestProductDataWithType:@"1" SuccessBlock:^(BOOL success, NSMutableArray *mutableArray)
     {
         if (success)
         {
           
        
             [_productDataArray removeAllObjects];
             if ( [EnvironmentConfiger sharedInstance].currentSection==1)
             {
//                 NSDictionary * XHdic = @{
//                                          @"marketName" : @"南方稀贵金属交易所",
//                                          @"currencyUnit" : @"元",
//                                          @"marketStatus" : @"1",
//                                          @"interval" : @"0.16",
//                                          @"scale" : @"0.5",
//                                          @"instrumentID" : @"AG",
//                                          @"timeAndNum" : @"09:00\/1260;06:00",
//                                          @"nightTimeAndNum" : @"",
//                                          @"loddyType" : @"1",
//                                          @"baseline" : @"6",
//                                          @"imgs" : @"http:\/\/adminstock.oss-cn-hangzhou.aliyuncs.com\/2016-01-14_marketAGXH.png",
//                                          @"marketId" : @"12",
//                                          @"commodityName" : @"白银现货",
//                                          @"vendibility" : @"1",
//                                          @"tag" : @"2",
//                                          @"timeline" : @"09:00;06:00;",
//                                          @"id" : @"101",
//                                          @"marketCode" : @"SRPME",
//                                          @"instrumentCode" : @"AGXH",
//                                          @"currencyName" : @"人民币",
//                                          @"timeTag" : @"2",
//                                          @"commodityDesc" : @"09:00-次日06:00",
//                                          @"currency" : @"CNY",
//                                          @"advertisement" : @"南交所 | 21小时不间断交易",
//                                          @"currencySign" : @"￥",
//                                          @"multiple" : @"15",
//                                          @"decimalPlaces" : @"2",
//                                          @"isDoule" : @"0"};
//                 
//                 NSDictionary * XHdicCu = @{
//                                          @"marketName" : @"南方稀贵金属交易所",
//                                          @"currencyUnit" : @"元",
//                                          @"marketStatus" : @"1",
//                                          @"interval" : @"0.16",
//                                          @"scale" : @"0.5",
//                                          @"instrumentID" : @"CU",
//                                          @"timeAndNum" : @"09:00\/1260;06:00",
//                                          @"nightTimeAndNum" : @"",
//                                          @"loddyType" : @"1",
//                                          @"baseline" : @"6",
//                                          @"imgs" : @"http:\/\/adminstock.oss-cn-hangzhou.aliyuncs.com\/2016-01-14_marketAGXH.png",
//                                          @"marketId" : @"12",
//                                          @"commodityName" : @"铜现货",
//                                          @"vendibility" : @"1",
//                                          @"tag" : @"2",
//                                          @"timeline" : @"09:00;06:00;",
//                                          @"id" : @"102",
//                                          @"marketCode" : @"SRPME",
//                                          @"instrumentCode" : @"CUXH",
//                                          @"currencyName" : @"人民币",
//                                          @"timeTag" : @"2",
//                                          @"commodityDesc" : @"09:00-次日06:00",
//                                          @"currency" : @"CNY",
//                                          @"advertisement" : @"南交所 | 21小时不间断交易",
//                                          @"currencySign" : @"￥",
//                                          @"multiple" : @"15",
//                                          @"decimalPlaces" : @"2",
//                                          @"isDoule" : @"0"};
//                 NSDictionary * XHdicIN = @{
//                                            @"marketName" : @"南方稀贵金属交易所",
//                                            @"currencyUnit" : @"元",
//                                            @"marketStatus" : @"1",
//                                            @"interval" : @"0.16",
//                                            @"scale" : @"0.5",
//                                            @"instrumentID" : @"IN",
//                                            @"timeAndNum" : @"09:00\/1260;06:00",
//                                            @"nightTimeAndNum" : @"",
//                                            @"loddyType" : @"1",
//                                            @"baseline" : @"6",
//                                            @"imgs" : @"http:\/\/adminstock.oss-cn-hangzhou.aliyuncs.com\/2016-01-14_marketAGXH.png",
//                                            @"marketId" : @"12",
//                                            @"commodityName" : @"铟现货",
//                                            @"vendibility" : @"1",
//                                            @"tag" : @"2",
//                                            @"timeline" : @"09:00;06:00;",
//                                            @"id" : @"103",
//                                            @"marketCode" : @"SRPME",
//                                            @"instrumentCode" : @"INXH",
//                                            @"currencyName" : @"人民币",
//                                            @"timeTag" : @"2",
//                                            @"commodityDesc" : @"09:00-次日06:00",
//                                            @"currency" : @"CNY",
//                                            @"advertisement" : @"南交所 | 21小时不间断交易",
//                                            @"currencySign" : @"￥",
//                                            @"multiple" : @"15",
//                                            @"decimalPlaces" : @"2",
//                                            @"isDoule" : @"0"};
//                 NSLog(@"%@",[Helper toJSON:XHdicCu]);
//                 FoyerProductModel * agModel = [FoyerProductModel productModelWithDictionary:XHdic];
//                 FoyerProductModel * cuModel = [FoyerProductModel productModelWithDictionary:XHdicCu];
//                 FoyerProductModel * inModel = [FoyerProductModel productModelWithDictionary:XHdicIN];
//
//                 [_productDataArray addObject:agModel];
//                 [_productDataArray addObject:cuModel];
//                 [_productDataArray addObject:inModel];
             }
             for (NSDictionary * dictionary in mutableArray)
             {
                 FoyerProductModel * productModel = [FoyerProductModel productModelWithDictionary:dictionary];
                 [_productDataArray addObject:productModel];
             }
             _dataTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(reloadTableview) userInfo:nil repeats:YES];
             [_dataTimer fire];
             //获取缓存信息
             CacheModel *cacheModel = [CacheEngine getCacheInfo];
             //设置属性
             cacheModel.productListArray = _productDataArray;
             // 存入缓存
             [CacheEngine setCacheInfo:cacheModel];
         }
     }];
}
- (void)reloadTableview
{
    if (_isLoadTable) {
        [_tableView reloadData];

    }
}
#pragma mark UITableViewDataSource,UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_productDataArray.count>0)
    {
        return _productDataArray.count;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FoyerTableViewCell * foyerCell      = [tableView dequeueReusableCellWithIdentifier:@"foyerCell" forIndexPath:indexPath];
    if (_productDataArray.count<=indexPath.row)
    {
        return foyerCell ;
    }
    foyerCell.selectionStyle = UITableViewCellSelectionStyleDefault;

    FoyerProductModel * productModel    = _productDataArray[indexPath.row];
    
    foyerCell.isPositionNum      = NO;
    if([[CMStoreManager sharedInstance]isLogin]){
        if ([productModel.marketCode rangeOfString:@"SRPME"].location != NSNotFound )
        {
            if (![[SpotgoodsAccount sharedInstance] isNeedLogin]) {
                for (NSDictionary * dic in _positionCashNumArray)
                {
                    if ([dic[@"instrumentCode"] rangeOfString:productModel.instrumentCode].location !=NSNotFound)
                    {
                        float num                   = [dic[@"cash"]intValue];
                        if (num>0)
                        {
                            foyerCell.isPositionNum        = YES;
                        }
                        break;
                    }
                }
            }
        }else {
            for (NSDictionary * dic in _positionNumArray)
            {
                if ([dic[@"instrumentCode"] rangeOfString:productModel.instrumentCode].location !=NSNotFound)
                {
                    float num                   = [dic[@"cash"]intValue];
                    if (num>0)
                    {
                        foyerCell.isPositionNum        = YES;
                    }
                    break;
                }
            }
        }
    }
    if (indexPath.row==_productDataArray.count-1)
    {
        foyerCell.lineView.hidden = YES;
    }else
    {
        foyerCell.lineView.hidden = NO;
    }
    [foyerCell setFoyertableViewCellWithModel:productModel];
    return foyerCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ManagerHUD showHUD:self  animated:YES andAutoHide:10];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FoyerProductModel * productModel = _productDataArray[indexPath.row];
    [self getClickEnableWithProductModel:productModel indexPath:indexPath];
}

- (void)getClickEnableWithProductModel:(FoyerProductModel * )productModel indexPath:(NSIndexPath *)indexPath
{
    if (productModel.vendibility.intValue==0)
    {
        [ManagerHUD hidenHUD];
        self.pushBlock(@"PopUpView",@{@"msg":@"敬请期待"},nil);
    }else{
        if ([productModel.commodityName rangeOfString:@"股票"].location !=NSNotFound)
        {
            self.backStyle = SubViewBackStyle;
            self.pushBlock(@"PositionViewController",nil,nil);
            [ManagerHUD hidenHUD];
        }else{
            [self getIPWithIndexPath:indexPath];
        }
    }
}
- (void)getIPWithIndexPath:(NSIndexPath*)indexPath;
{
  __block  FoyerTableViewCell * cell = [_tableView cellForRowAtIndexPath:indexPath];
    
    __block FoyerProductModel * productModel = _productDataArray[indexPath.row];;
    [DataEngine requestToGetIPAndPortWithBlock:^(BOOL success, NSString * IP, NSString *Port)
     {
         [ManagerHUD hidenHUD];
         _IP = IP;
         _port = Port;
         BOOL isPosition = NO;
         isPosition = cell.isPositionNum;

         self.backStyle                  = SubViewBackStyle;
         NSString * position = [NSString stringWithFormat:@"%d",isPosition];
         self.pushBlock(@"IndexViewController",@{@"ip":IP,@"port":Port,@"isPosition":position},productModel);
     }];
    
}
- (void)searchInstrumentCode:(NSString * )code
{
    for (int i=0;  i<_productDataArray.count;i++)
    {
        FoyerProductModel * productModel = _productDataArray[i];
        
        if ([productModel.productID isEqualToString:code])
        {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self getClickEnableWithProductModel:productModel indexPath:indexPath];
        }
    }
}
@end
