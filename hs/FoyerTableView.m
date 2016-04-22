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

#define headerColor K_COLOR_CUSTEM(45, 44, 49, 1)

@interface FoyerTableView ()
{
    //大厅广告图点击链接数组
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth-114) style:UITableViewStyleGrouped];
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
            if (cachemodel.productSectionArray)
            {
                _productDataArray = cachemodel.productSectionArray;//刷新产品列表
                [_tableView reloadData];
            }
        }
            break;
        case OtherPageBackStyle:
        {
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
    UIView * tabHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 105*ScreenWidth/375)];
    tabHeaderView.backgroundColor = headerColor;
    UIView * subHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 104*ScreenWidth/375)];
    subHeaderView.tag = 8870;
    subHeaderView.backgroundColor = headerColor;
    [tabHeaderView addSubview:subHeaderView];
    
    
    NSArray * array = @[@{@"name":@"模拟练习场",@"detail":@"免费练手成大牛",@"imgName":@"foyer_3"},
                        @{@"name":@"免费领现金",@"detail":@"轻点指尖秒进账",@"imgName":@"foyer_4"},
                        @{@"name":@"节假日历史盘",@"detail":@"怒上排行奖现金",@"imgName":@"foyer_5"}];
    float subLength = (ScreenWidth-20-2)/3;
    for (int i=0; i<3; i++) {
        
        UIView * subSubView = [[UIView alloc] initWithFrame:CGRectMake(10+(subLength+1)*i, 0, subLength, 105*ScreenWidth/375-1)];
        subSubView.tag = 8880+i;
        subSubView.backgroundColor =headerColor;
        [subHeaderView addSubview:subSubView];
        

        
        UIImageView * imgV = [[UIImageView alloc] init];
        imgV.image = [UIImage imageNamed:array[i][@"imgName"]];
        imgV.center = CGPointMake(subLength/2, 35*ScreenWidth/375);
//        imgV.bounds = CGRectMake(0, 0, 40*ScreenWidth/375, 40*ScreenWidth/375);
        imgV.bounds = CGRectMake(0, 0, imgV.image.size.width, imgV.image.size.height);
        [subSubView addSubview:imgV];
        
        UILabel * name = [[UILabel alloc] init];
        name.center = CGPointMake(subLength/2, 65*ScreenWidth/375);
        name.bounds = CGRectMake(0, 0, subLength, 15);
        name.font = FontSize(13*ScreenWidth/375);
        name.text = array[i][@"name"];
        name.textAlignment = NSTextAlignmentCenter;
        [subSubView addSubview:name];
        
        UILabel * detail = [[UILabel alloc] init];
        detail.center = CGPointMake(subLength/2, 79*ScreenWidth/375);
        detail.bounds = CGRectMake(0, 0, subLength, 12*ScreenWidth/375);
        detail.font = FontSize(9);
        detail.text = array[i][@"detail"];
        detail.textColor = K_color_grayBlack;
        detail.textAlignment = NSTextAlignmentCenter;
        [subSubView addSubview:detail];
        
        if (i==0)
        {
            name.textColor = detail.textColor = K_COLOR_CUSTEM(8, 143, 224, 1);
        }else if(i==1)
        {
            name.textColor = detail.textColor = K_COLOR_CUSTEM(235, 200, 144, 1);
        }else if(i==2)
        {
            name.textColor = detail.textColor = K_COLOR_CUSTEM(151, 41, 114, 1);
        }
        
        UIControl * control = [[UIControl alloc] init];
        control.frame = CGRectMake(0, 0, subLength, 105*ScreenWidth/375-1);
        control.tag = 8888+i;
        [control addTarget:self action:@selector(goPage:) forControlEvents:UIControlEventTouchUpInside];
        [subSubView addSubview:control];
        if (i<2)
        {
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(subSubView.frame), 10, 1, 104*ScreenWidth/375-20)];
            line.backgroundColor = [UIColor blackColor];
            [subHeaderView addSubview:line];
        }
    }
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
- (void)clickTabHeaderSubView:(UIView*)subSubView
{
    subSubView.backgroundColor = headerColor;
}

#pragma mark 点击模拟。。。
- (void)goPage:(UIControl*)control
{
    UIView * subHeader = [_tableView.tableHeaderView viewWithTag:8870];
    UIView * subSubView = [subHeader viewWithTag:control.tag-8];
    subSubView.backgroundColor = [UIColor blackColor];
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

             NSMutableArray * section_1Arr = [NSMutableArray array];
             NSMutableArray * section_2Arr = [NSMutableArray array];
             for (NSDictionary * dictionary in mutableArray)
             {
                
                 FoyerProductModel * productModel = [FoyerProductModel productModelWithDictionary:dictionary];
                 if([productModel.currency isEqualToString:@"CNY"])
                 {
                     [section_2Arr addObject:productModel];
                 }else {
                     [section_1Arr addObject:productModel];
                 }
             }
             [_productDataArray addObject:section_1Arr];
             [_productDataArray addObject:section_2Arr];
             _dataTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(reloadTableview) userInfo:nil repeats:YES];
             [_dataTimer fire];
             //获取缓存信息
             CacheModel *cacheModel = [CacheEngine getCacheInfo];
             //设置属性
             cacheModel.productSectionArray = _productDataArray;
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section

{
    return 0.5;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_productDataArray.count>0)
    {
        NSArray * array = _productDataArray[section];
        return array.count;
    }else{
        return 0;
    }
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    header.backgroundColor = K_color_backView;
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, ScreenWidth-40, 20)];
    if (section==0) {
        title.text = @"国外品种";
    }else{
        title.text = @"国内品种";
    }
    title.font = FontSize(13);
    title.textColor = K_color_grayBlack;
    title.backgroundColor = K_color_backView;
    [header addSubview:title];
    return header;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FoyerTableViewCell * foyerCell      = [tableView dequeueReusableCellWithIdentifier:@"foyerCell" forIndexPath:indexPath];
    NSMutableArray * productArray = _productDataArray[indexPath.section];
    if (productArray.count<=indexPath.row)
    {
        return foyerCell ;
    }
    foyerCell.selectionStyle = UITableViewCellSelectionStyleDefault;

    FoyerProductModel * productModel    = productArray[indexPath.row];
    
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
    if (indexPath.row==productArray.count-1&&indexPath.section==1)
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
    
    FoyerProductModel * productModel = _productDataArray[indexPath.section][indexPath.row];
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
    
    __block FoyerProductModel * productModel = _productDataArray[indexPath.section][indexPath.row];;
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
//- (void)searchInstrumentCode:(NSString * )code
//{
//    for (int i=0;  i<_productDataArray.count;i++)
//    {
//        FoyerProductModel * productModel = _productDataArray[i];
//        
//        if ([productModel.productID isEqualToString:code])
//        {
//            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//            [self getClickEnableWithProductModel:productModel indexPath:indexPath];
//        }
//    }
//}
@end
