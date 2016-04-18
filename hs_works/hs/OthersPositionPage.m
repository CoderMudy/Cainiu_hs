//
//  OthersPosiPage.m
//  hs
//
//  Created by PXJ on 15/7/13.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "OthersPositionPage.h"
#import "OthersPosiCell.h"
#import "TopOtherPositionView.h"
#import "h5DataCenterMgr.h"
#import "SearchViewController.h"
#import "NetRequest.h"
#import "StockDetailViewController.h"
#import "HsRealtime.h"
#import "OtherPositionBaseClass.h"
#import "SSNavView.h"
#import "ELDataModels.h"



@interface OthersPositionPage ()<UITableViewDataSource,UITableViewDelegate>
{
    
    BOOL _switchOn;
    H5DataCenter * _dataCenter;
    NSTimer * _timer;
    
    NSMutableArray * _orderListArray;
    NSMutableArray * _newPriceArray;
    TopOtherPositionView * _positionView;
    
    float _buyValue;
    float _buyLossFund;
    float _curValue;
    SSNavView * _ssNavView;
    UIImageView * _backImageView;
}
@property (strong, nonatomic)  UITableView *tableView;

@end

@implementation OthersPositionPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // 存储背景图片
    [[CMStoreManager sharedInstance] setbackgroundimage];
    
    self.tableView.autoresizesSubviews = NO;
    _dataCenter=[h5DataCenterMgr sharedInstance].dataCenter;
    _orderListArray = [NSMutableArray array];
    _newPriceArray = [NSMutableArray array];
    
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _backImageView.image = [UIImage imageNamed:@"background_nav_05"];
    [self.view addSubview:_backImageView];
    
    _ssNavView = [[SSNavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _ssNavView.segControl.hidden = YES;
    [self.view addSubview:_ssNavView];
    
    _ssNavView.titleLab.text = _elDataModel.nickName;
    _ssNavView.titleLab.textColor = [UIColor whiteColor];
    
    
    
    _positionView = [[TopOtherPositionView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 170)];
    [_ssNavView addSubview:_ssNavView.backBtn];
    [_ssNavView.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [_ssNavView.searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * personalView = [[UIView alloc] initWithFrame:CGRectMake(0, _positionView.frame.size.height -34, ScreenWidth, 34)];
    personalView.backgroundColor = K_COLOR_CUSTEM(248, 248, 248, 1);
    [_positionView addSubview:personalView];
    
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(20 , 2, ScreenWidth-100, 10)];
    lab.text = @"个性签名";
    lab.font = [UIFont systemFontOfSize:10];
    [personalView addSubview:lab];
    
    UILabel * personalSignLab = [[UILabel alloc] initWithFrame:CGRectMake(20 , 12, ScreenWidth-120, 20)];
    personalSignLab .text = _elDataModel.personalSign;
    personalSignLab.font = [UIFont systemFontOfSize:12];
    [personalView addSubview:personalSignLab];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(ScreenWidth-140, 0, 120, 34);
    [button setTitleColor:K_COLOR_CUSTEM(250, 67, 0, 1) forState:UIControlStateNormal];
    [button addTarget:self  action:@selector(expected:) forControlEvents:UIControlEventTouchUpInside];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button setTitle:@"查看战绩" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"button_02"] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.frame.size.width-20, 0, 0)];
    [personalView addSubview:button];
    
    
    
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeigth-113);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = _positionView;
    self.tableView.backgroundColor = K_COLOR_CUSTEM(248,248,248,1);
    [self.tableView registerClass:[OthersPosiCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellStyleDefault;
    
    NSArray  * titleImageName = [NSArray arrayWithObjects:@"敬请期待",@"点评",@"关注", nil];
    
    
    
    
    for (int i = 0; i<3; i++) {
        
        
        UIButton  * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        float btnHeight =(ScreenWidth-4)/3.0*88/247;
        button.frame = CGRectMake(i*((ScreenWidth-4)/3.0+2), ScreenHeigth-btnHeight, (ScreenWidth-4)/3.0, btnHeight);
        
        
        
        
        [button  setImage:[UIImage imageNamed:titleImageName[i]] forState:UIControlStateNormal];
        button.tag = 600000+i;
        if(i==1||i==2){
            [button addTarget:self action:@selector(expected:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.view addSubview:button];
        
    }
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"他人持仓"];
    _switchOn = YES;
    _orderListArray =  _elDataModel.orderList;;
    
    [self getStockNewPriceList];
    [self.tableView reloadData];
    [self loadBackView];
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"他人持仓"];
    _switchOn = NO;
    
    [_timer invalidate];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)search
{
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    searchVC.dataCenter = [h5DataCenterMgr sharedInstance].dataCenter;
    [self.navigationController pushViewController:searchVC animated:YES];
}
- (void)expected:(UIButton*)sender
{
    if (sender.tag==600000) {
        return;
    }
    [[UIEngine sharedInstance] showAlertWithTitle:@"敬请期待" ButtonNumber:1 FirstButtonTitle:@"确定" SecondButtonTitle:@""];
    [UIEngine sharedInstance].alertClick = ^(int aIndex){
    };
    
    
}
//获取一组股票快照

- (void)getStockNewPriceList
{
    if (_switchOn) {
        
        _dataCenter = [h5DataCenterMgr sharedInstance].dataCenter;
        __block    NSMutableArray *array = [NSMutableArray array];
        
        for (ELOrderList * orderList in _orderListArray) {
            HsStock * stock = [[HsStock alloc] init];
            stock.stockName = orderList.stockName ;
            stock.stockCode = orderList.stockCode ;
            stock.codeType  = orderList.typeCode ;
            [array addObject:stock];
        }
        
        [_dataCenter loadRealtimeList:array withHandleBlock:^(id data) {
            
            if ((NSNull*)data == [NSNull null] || data == nil )
            {
                //            NSLog(@"得到股票最新数据---%@ %@",data ,[data class]);
            }
            else
            {
                //        NSLog(@"%@",data);
                if (_newPriceArray) {
                    
                    [_newPriceArray removeAllObjects];
                }
                for (HsRealtime * realtime in data) {
                    
                    if (realtime.newPrice==0) {
                        realtime.newPrice = realtime.preClosePrice;
                    }
                    
                    
                    [_newPriceArray addObject:realtime];
                    
                    
                }
                for (int i= 0; i<array.count; i++) {
                    HsRealtime * realTime = _newPriceArray[i];
                    ELOrderList * orderList = _orderListArray[i];
                    orderList.newPrice = realTime.newPrice;
                    orderList.stockName = realTime.name;
                    [_orderListArray replaceObjectAtIndex:i withObject:orderList];
                }
                [self getearn];
                [_tableView reloadData];
                
            }
            
            [self performSelector:@selector(getStockNewPriceList) withObject:nil afterDelay:3];
        }];
    }
}
- (void)loadBackView
{
    NSString * earnLabText;
    if (_buyValue==0) {
        
        return;
        
    }else{
        
        
        float earn =(_curValue -_buyValue)*1.0/_buyLossFund;
        earnLabText =[NSString stringWithFormat:@"%.2f%%",earn*100] ;
        
        if (_curValue-_buyValue>0) {
            _backImageView.image = K_setImage(@"background_nav_06");
            _positionView.backView.image =K_setImage(@"background_header_06");
            _positionView.markll.text = @"+";
            
            
        }else if(_curValue-_buyValue<0) {
            earnLabText = [earnLabText stringByReplacingOccurrencesOfString:@"-" withString:@""];
            _positionView.markll.text = @"-";
            _backImageView.image = K_setImage(@"background_nav_07");
            _positionView.backView.image = K_setImage(@"background_header_07");
            
        }
        if ((_buyLossFund == 0)||(_curValue-_buyValue==0)) {
            _backImageView.image = K_setImage(@"background_nav_05");
            _positionView.backView.image =K_setImage(@"background_header_05");
            _positionView.markll.text = @"-";
            
            
        }
    }
    float width = [Helper calculateTheHightOfText:earnLabText height:40 font:[UIFont systemFontOfSize:40]];
    _positionView.markll.frame = CGRectMake(ScreenWidth/2-width/2-8, _positionView.inteEarnLab.frame.origin.y, 15, 15);
    int fromLength = (int)earnLabText.length;
    NSMutableAttributedString * earnstr = [Helper multiplicityText:earnLabText from:fromLength-1 to:1  font:30];
    _positionView.inteEarnLab.attributedText = earnstr;
    
}

- (void)getearn
{
    _buyValue = 0;
    _curValue = 0;
    _buyLossFund = 0;
    
    for (int i = 0; i<_orderListArray.count; i++) {
        
        ELOrderList * otherModel = _orderListArray[i];
        
        
        
        float buyPrice = 0;
        float newPrice = 0;
        
        buyPrice = otherModel.buyPrice;
        newPrice = otherModel.newPrice;
        if (!newPrice) {
            newPrice = buyPrice;
        }else{
            
            _curValue = _curValue +newPrice *otherModel.factBuyCount;
            _buyValue = _buyValue + buyPrice * otherModel.factBuyCount;
            _buyLossFund = _buyLossFund + otherModel.cashFund;
            
        }
    }
    
    [self loadBackView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 48;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _orderListArray.count;
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OthersPosiCell * cell= [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    ELOrderList * orderList = _orderListArray[(int)indexPath.row];
    cell.storkTitlelab.text= orderList.stockName;
    cell.szDetailLab.text = orderList.stockCode;
//    NSString * curPriceStr;
    float incomeRate = 0.0;
    
    cell.storkTitlelab.text = orderList.stockName;
    // 当前价
    for (HsRealtime * realtime in _newPriceArray) {
        
        if([realtime.code isEqualToString:orderList.stockCode]){
            
            
            if (realtime.tradeStatus==7||realtime.tradeStatus ==8||realtime.tradeStatus==21) {
                cell.storkTitlelab.text = orderList.stockName;
                cell.szDetailLab.text = orderList.stockCode;
                cell.priceLab.text = [NSString stringWithFormat:@"%.2f",realtime.preClosePrice];
                cell.addLab.text = @"停牌";
                [cell.addView setBackgroundColor:[UIColor grayColor]];
                return cell;
                
                
            }
        };
    }

    // 收益率
    if (!orderList.newPrice) {
        
        incomeRate = 0.00;
        cell.priceLab.text = [NSString stringWithFormat:@" --"];
        cell.priceLab.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
        [cell.addView setBackgroundColor:[UIColor grayColor]];
        
    }else{
        
        incomeRate = (orderList.newPrice - orderList.buyPrice)*orderList.factBuyCount*100.0/ orderList.cashFund;
        cell.priceLab.text = [NSString stringWithFormat:@"%.2f",orderList.newPrice];
    }
    
    
    cell.addLab.text = [NSString stringWithFormat:@"%.2f%%",incomeRate];
    
    
    
    //买入价，当前价
    if (orderList.newPrice) {
        //买入价，当前价
        
        
        if (orderList.buyPrice > orderList.newPrice) {
            
            cell.priceLab.textColor =RGBCOLOR(8, 168, 66);
            [cell.addView setBackgroundColor:RGBCOLOR(8, 168, 66)];
            
        }else if(orderList.buyPrice == orderList.newPrice){
            cell.priceLab.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
            [cell.addView setBackgroundColor:[UIColor grayColor]];
            
        }else{
            
            cell.priceLab.textColor =RGBCOLOR(242, 41, 59);
            [cell.addView setBackgroundColor:RGBCOLOR(242, 41, 59)];
            
        }
    }
    
    cell.priceLab.textAlignment = NSTextAlignmentRight;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELOrderList * orderList = _orderListArray[indexPath.row];
    
    HsStock * stock = [HsStock alloc];
    stock.codeType = (NSNull*)orderList.typeCode ==[NSNull null]?@"":orderList.typeCode;
    stock.stockCode = (NSNull*)orderList.stockCode ==[NSNull null]?@"":orderList.stockCode;
    stock.stockName = (NSNull*)orderList.stockName==[NSNull null]?@"":orderList.stockName;
    
    StockDetailViewController * stockDetailVC = [[StockDetailViewController alloc] init];
    stockDetailVC.stock = stock;
    stockDetailVC.isbuy = NO;
    stockDetailVC.source = @"other";
    stockDetailVC.isPosition = YES;
    stockDetailVC.stockIndex = indexPath.row;
    stockDetailVC.otherOrderList = orderList;
    if (_newPriceArray.count>=indexPath.row+1) {
        stockDetailVC.realtime = _newPriceArray[indexPath.row];
    }
    
    
    [self.navigationController pushViewController:stockDetailVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * sectionHeaderView = [[UIView alloc] init];
    sectionHeaderView.backgroundColor = K_COLOR_CUSTEM(248,248,248,1);
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
    backView.backgroundColor = [UIColor whiteColor];
    [sectionHeaderView addSubview:backView];
    
    UILabel * shareLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 90,20)];
    shareLab.text = @"订单分享";
    shareLab.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
    shareLab.font = [UIFont systemFontOfSize:13];
    shareLab.textAlignment = NSTextAlignmentLeft;
    [sectionHeaderView addSubview:shareLab];
    
    
    UILabel * upListLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-207, 13, 90,20)];
    upListLab.text = @"当前价";
    upListLab.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
    upListLab.font = [UIFont systemFontOfSize:13];
    upListLab.textAlignment = NSTextAlignmentRight;
    [sectionHeaderView addSubview:upListLab];
    
    UILabel * downListLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-97, 13, 70,20)];
    downListLab.text = @"收益率";
    downListLab.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
    downListLab.font = [UIFont systemFontOfSize:13];
    downListLab.textAlignment = NSTextAlignmentRight;
    [sectionHeaderView addSubview:downListLab];
    
    UILabel * lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 34-0.8, ScreenWidth, 0.8)];
    [lineLab setBackgroundColor:K_COLOR_CUSTEM(200, 200, 200, 1)];
    [sectionHeaderView addSubview:lineLab];
    
    return sectionHeaderView;
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
