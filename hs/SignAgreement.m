//
//  SignAgreement.m
//  hs
//
//  Created by PXJ on 15/7/6.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "SignAgreement.h"
#import "SignAgreeCell.h"
#import "orderPage.h"
#import "NetRequest.h"
#import "DetailViewController.h"


@interface SignAgreement ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation SignAgreement


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.rdv_tabBarController.tabBar.hidden = YES;



}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-148) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[SignAgreeCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    [self setNavLeftBut];
    [self setTitle:@"签署协议"];
    
    UIButton * agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeBtn.center = CGPointMake(ScreenWidth/2.0, ScreenHeigth-42);
    agreeBtn.bounds = CGRectMake(0, 0, ScreenWidth-40, 44);
    agreeBtn.layer.cornerRadius = 5;
    agreeBtn.layer.masksToBounds = YES;
    [agreeBtn addTarget:self action:@selector(getStockStatus) forControlEvents:UIControlEventTouchUpInside];
    [agreeBtn setBackgroundColor:K_COLOR_CUSTEM(250, 66, 0, 1)];
    [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    [self.view addSubview:agreeBtn];
    
}

- (void)initData
{
    _dataArray = [NSMutableArray array];
    NSDate * date = [NSDate date];
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString    *strDate            = [dateFormatter stringFromDate:date];

    NSString *niu = @"";
    
//    #if defined (CAINIUA)
//        niu = @"牛A";
//    #elif defined (NIUAAPPSTORE)
//    niu = @"牛A";
//
//    #else
//        niu = @"财牛";
//    #endif
//    
    niu = App_appShortName;
    NSDictionary * dic = @{@"title":[NSString stringWithFormat:@"%@用户参与沪深A股交易合作涉及费用及资费标准",niu],@"date":strDate};
    
    NSDictionary * dict = @{@"title":[NSString stringWithFormat:@"%@投资人与用户参与沪深A股交易合作协议",niu],@"date":strDate};
    
            
    [_dataArray  addObject:dic];
    [_dataArray addObject:dict];


}

- (void)setNavLeftBut
{
    UIImage *leftButtonImage = [UIImage imageNamed:@"return_1.png"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, leftButtonImage.size.width, leftButtonImage.size.height)];
    [leftButton setBackgroundImage:leftButtonImage forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"return_2.png"] forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchDown];
    [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    leftButton.titleLabel.shadowColor = RGBACOLOR(117,38,0,1.0f);
    leftButton.titleLabel.shadowOffset= CGSizeMake(0, -1);
    leftButton.titleLabel.textColor = [UIColor whiteColor];
    UIBarButtonItem *leftbtn =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbtn;
}

- (void)leftButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getStockStatus
{
    __block SignAgreement * safeSelf  = self;

    
    NSDictionary * dic = @{@"stockCode":_orderByModel.stockCode};
    
    [NetRequest postRequestWithNSDictionary:dic url:K_MARKET_STOCKSTATUS successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"]intValue]==200) {
            
            
            NSDictionary * dic =dictionary[@"data"];
            _orderByModel.status = [dic[@"status"] intValue];
            [safeSelf getUser];

        }
    } failureBlock:^(NSError *error) {
        _orderByModel.status = 0;
        [safeSelf getUser];
    }];

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
        [ManagerHUD hidenHUD];
        
        [self goOrderPage];
    }];
    
    
    
}

- (void)goOrderPage
{


    
    orderPage * orderVC = [[orderPage alloc] init];
    orderVC.orderByModel = _orderByModel;
    [self.navigationController pushViewController:orderVC animated:YES];

    //获取缓存信息
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    //设置属性
    cacheModel.isAgree= @"1";
    // 存入缓存
    [CacheEngine setCacheInfo:cacheModel];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 2;



}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;


}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    SignAgreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary * dic = _dataArray[indexPath.row];
    [cell setDict:dic];

    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    int index = (int)indexPath.row +7;
    DetailViewController    *detailVC = [[DetailViewController alloc]init];
    detailVC.index = index;
    [self.navigationController pushViewController:detailVC animated:YES];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
