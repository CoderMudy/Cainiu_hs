
//
//  SearchViewController.m
//  hs
//
//  Created by PXJ on 15/4/29.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import "SearchViewController.h"
#import "StockDetailViewController.h"
#import "SearchTableViewCell.h"
#import "HsSessionManager.h"
#import "HsStock.h"
#import "h5DataCenterMgr.h"
#import "NSArray+FirstLetterArray.h"
#import "NSString+FirstLetter.h"
#import "NetRequest.h"
#define K_SELF_BOUNDS self.view.bounds.size

@interface SearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>


{
    UITextField * _searchTextField;
    UIButton * _concelBtn;
    
    UITableView * _tableView;
    NSMutableArray * _searchDataArray;//搜索记录数组
    NSMutableArray * _optionalStockArray;//自选股票数组
    NSMutableArray * _isChooseArray;//是否为选中的数组
    NSMutableArray * _historyDataArray;//历史数据数组
    NSMutableArray * _hotStockArray;//推荐股票列表
    
}
@end

@implementation SearchViewController

#pragma mark 监听textField清空操作
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (_searchDataArray.count>0) {
        [_searchDataArray removeAllObjects];

    }
    if (_historyDataArray.count>0) {
        if (_isChooseArray.count>0) {
            [_isChooseArray removeAllObjects];
        }
        for (int i=0; i<_historyDataArray.count; i++) {
            [_isChooseArray addObject:@"0"];
        }
        
        
        self.searchListStyle = SearchListStyleHistoryStock;
        [_tableView reloadData];
        [self loadFootView];

    }else{
    
        if (_hotStockArray.count>0) {
            if (_isChooseArray.count>0) {
                [_isChooseArray removeAllObjects];
            }
            for (int i=0; i<_hotStockArray.count; i++) {
                [_isChooseArray addObject:@"0"];
            }

            self.searchListStyle = SearchListStyleHotStock;
            [_tableView reloadData];
            [self loadFootView];

        }else{
        
            [self getHotListStock];

        }
    }
    
    return YES;
}


#pragma mark 搜索－监听textField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
    NSString * searchText = [NSString stringWithFormat:@"%@%@",textField.text,string];
    searchText = [searchText firstLetters];
    [self searchStock:searchText];
    return YES;
}

- (void)searchStock:(NSString*)searchText
{

    _dataCenter = [h5DataCenterMgr sharedInstance].dataCenter;
    [_dataCenter queryStocks:searchText type:0 withHandleBlock:^(id sender) {
        NSArray *array = (NSArray *)sender;
        if ((NSNull*)sender != [NSNull null] && sender != nil &&array.count>0)
        {
            _searchListStyle = SearchListStyleSearchStock;
            _searchDataArray = (NSMutableArray*)sender;
            [_isChooseArray removeAllObjects];

            for (int i= 0 ; i< _searchDataArray.count; i++) {
                [_isChooseArray addObject:@"0"];
            }
            [_tableView reloadData];
            [self loadFootView];

            
        }
        
        
    }];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
    
    
}
- (void)concelBtnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    //    [self.navigationController popViewControllerAnimated:YES];
    
    
}
#pragma mark TableView方法
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (void)initSearchResultTableView
{
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeigth-20)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UIView * searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 4, ScreenWidth, 44)];
    searchView.backgroundColor = K_COLOR_CUSTEM(248, 248, 248, 1);
    [backView addSubview:searchView];
    
    UITextField * lineTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 7, K_SELF_BOUNDS.width-90, 30)];
    lineTF.backgroundColor = [UIColor whiteColor];
    lineTF.borderStyle = UITextBorderStyleRoundedRect;
    lineTF.placeholder = @"";
    lineTF.enabled = NO;
    [searchView addSubview:lineTF];
    
    UIImageView * searchImageV = [[UIImageView alloc] initWithFrame:CGRectMake(30, 13, 20, 18)];
    searchImageV.image = [UIImage imageNamed:@"search_02"];
    [searchView addSubview:searchImageV];
    
    
    _searchTextField  = [[UITextField alloc] initWithFrame:CGRectMake(60, 8, K_SELF_BOUNDS.width-135, 28)];
    _searchTextField.backgroundColor = [UIColor whiteColor];
    _searchTextField.borderStyle = UITextBorderStyleNone;
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTextField.font = [UIFont systemFontOfSize:14];
    _searchTextField.placeholder = @"股票代码／首字母／名称";
    _searchTextField.delegate = self;
    [_searchTextField becomeFirstResponder];
    [searchView addSubview:_searchTextField];
    
    
    _concelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _concelBtn.frame = CGRectMake(K_SELF_BOUNDS.width-80, 0, 80, 44);
    [_concelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_concelBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_concelBtn setTitleColor:K_COLOR_CUSTEM(250, 67, 0, 1) forState:UIControlStateNormal];
    [_concelBtn addTarget:self action:@selector(concelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:_concelBtn];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 52,K_SELF_BOUNDS.width,K_SELF_BOUNDS.height-72) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[SearchTableViewCell class] forCellReuseIdentifier:@"cell"];
    [backView addSubview:_tableView];
    [self loadFootView];

}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.searchListStyle) {
        case (SearchListStyleHistoryStock):
        {
           return  _historyDataArray.count;
        
        }
            break;
        case (SearchListStyleHotStock):
        {
            return _hotStockArray.count;
        }
            break;
        case (SearchListStyleSearchStock):
        {
            return _searchDataArray.count;
        }
            break;
        default:
            break;
    }
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * stockDic;
    HsStock * stock = [[HsStock alloc] init];
    
    switch (self.searchListStyle) {
        case (SearchListStyleHistoryStock):
        {
            stockDic  =[NSDictionary dictionaryWithDictionary:_historyDataArray[indexPath.row]] ;
            stock.stockCode = stockDic[@"stockCode"]==nil?@"":stockDic[@"stockCode"];
            stock.stockName = stockDic[@"stockName"]==nil?@"":stockDic[@"stockName"];
            stock.codeType  = stockDic[@"codeType"]==nil?@"":stockDic[@"codeType"];

            
        }
            break;
            
        case (SearchListStyleHotStock):
        {
            stockDic  =[NSDictionary dictionaryWithDictionary:_hotStockArray[indexPath.row]] ;
            stock.stockCode = stockDic[@"stockCode"]==nil?@"":stockDic[@"stockCode"];
            stock.stockName = stockDic[@"stockName"]==nil?@"":stockDic[@"stockName"];
            stock.codeType  = stockDic[@"codeType"]==nil?@"":stockDic[@"codeType"];

        }
            break;
        case (SearchListStyleSearchStock):
        {
            stock = _searchDataArray[indexPath.row];
        }
            break;
        default:
            break;
    }
    NSLog(@"%@",stock);

    SearchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.labNum.text = stock.stockCode;
    cell.labName.text = stock.stockName;
    cell.optionalBtn.tag = (indexPath.row +1) *100;
    [cell.optionalBtn addTarget:self action:@selector(clickOptionalBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_isChooseArray replaceObjectAtIndex:indexPath.row withObject:@"0"];

    for (NSDictionary * dic in _optionalStockArray) {
        
        NSString * opStockCode = dic[@"stockCode"];
        NSLog(@"%@,,,,,%@",stock.stockCode,opStockCode);
        if ([opStockCode isEqualToString:cell.labNum.text]) {
            [_isChooseArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
            break;
        }
        
    }
    
    if ([_isChooseArray[indexPath.row] isEqualToString:@"1"]) {
    
        NSLog(@"1");
        [cell.optionalBtn setImage:[UIImage imageNamed:@"Button_18"] forState:UIControlStateNormal];

    }else{
        NSLog(@"0");

        [cell.optionalBtn setImage:[UIImage imageNamed:@"Button_17"] forState:UIControlStateNormal];

    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}



//添加与取消自选
- (void)clickOptionalBtnClick:( UIButton *)sender
{
  
    if (![[CMStoreManager sharedInstance] isLogin]) {
        
        
        PopUpView * alertLoginView = [[PopUpView alloc] initShowAlertWithShowText:@"尚未登录，无法添加自选股" setBtnTitleArray:@[@"返回",@"登录"]];
        
        alertLoginView.confirmClick = ^(UIButton *button){
            if (button.tag==66666) {
                
            }else{
            
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                loginVC.source = @"orderBuy";
                [self.navigationController pushViewController:loginVC animated:YES];
            
            }
            
            
            
            
        };
        [self.navigationController.view addSubview:alertLoginView];
        [_searchTextField endEditing:YES];

        
        

    } else {
        
        
    
    
    
    int tagIndex = (int)sender.tag/100-1;
    __block   UIButton * btn = (UIButton*)sender;
        
     __block   HsStock * stock = [[HsStock alloc] init];
        switch (self.searchListStyle) {
            case (SearchListStyleHistoryStock):
            {
                NSDictionary *stockDic  =[NSDictionary dictionaryWithDictionary:_historyDataArray[tagIndex]] ;
                stock.stockCode = stockDic[@"stockCode"]==nil?@"":stockDic[@"stockCode"];
                stock.stockName = stockDic[@"stockName"]==nil?@"":stockDic[@"stockName"];
                stock.codeType  = stockDic[@"codeType"]==nil?@"":stockDic[@"codeType"];
                
                
            }
                break;
            case (SearchListStyleHotStock):
            {
                NSDictionary *stockDic  =[NSDictionary dictionaryWithDictionary:_hotStockArray[tagIndex]] ;
                
                stock.stockCode = stockDic[@"stockCode"]==nil?@"":stockDic[@"stockCode"];
                stock.stockName = stockDic[@"stockName"]==nil?@"":stockDic[@"stockName"];
                stock.codeType  = stockDic[@"codeType"]==nil?@"":stockDic[@"codeType"];
                
            }
                break;
            case (SearchListStyleSearchStock):
            {
                stock = _searchDataArray[tagIndex];
            }
                break;
            default:
                break;
        }
        
        
        
    NSString * token = [[CMStoreManager sharedInstance] getUserToken];
    if ([_isChooseArray[tagIndex] isEqualToString:@"1"]) {
        NSString * optionalId;
        for (NSDictionary * dictionary in _optionalStockArray) {
            if ([stock.stockCode isEqualToString:dictionary[@"stockCode"]]) {
                optionalId = dictionary[@"id"];
            }
            
        }
        
        NSDictionary  *dic = @{@"token":token,
                               @"id":optionalId,
                               @"version":VERSION};
        
        [NetRequest postRequestWithNSDictionary:dic url:K_DELETE_FAVORITES successBlock:^(NSDictionary *dictionary) {
            
            if ([dictionary[@"code"] intValue]==200) {
                
                [_isChooseArray replaceObjectAtIndex:tagIndex withObject:@"0"];
//                [_optionalStockArray removeObjectAtIndex:tagIndex];
                for (NSDictionary * dictionary in _optionalStockArray) {
                    if ([stock.stockCode isEqualToString:dictionary[@"stockCode"]]) {
                        [_optionalStockArray removeObject:dictionary];
                        break;
                    }
                    
                }
                [btn setImage:[UIImage imageNamed:@"Button_17"] forState:UIControlStateNormal];
                
            }
        } failureBlock:^(NSError *error) {
            
            
            
            
        }];
        
        
        
    }else{
    
    
    
    
        NSDictionary * dic = @{@"token":token,
                               @"stockName":stock.stockName,
                               @"stockCode":stock.stockCode,
                               @"stockCodeType":stock.codeType,
                               @"version":VERSION
                               };
        [NetRequest postRequestWithNSDictionary:dic url:K_ADD_FAVORITES successBlock:^(NSDictionary *dictionary) {
            
            if ([dictionary[@"code"] intValue]==200) {
                [_isChooseArray replaceObjectAtIndex:tagIndex withObject:@"1"];
                [btn setImage:[UIImage imageNamed:@"Button_18"] forState:UIControlStateNormal];
                [_optionalStockArray addObject:dictionary[@"data"]];
                
            }
        } failureBlock:^(NSError *error) {
            
        }];

    
    
    }
    
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (self.searchListStyle) {
        case (SearchListStyleHistoryStock):
        {
            return 40;
        }
            break;
        case (SearchListStyleHotStock):
        {
            return 40;
        }
            break;
        case (SearchListStyleSearchStock):
        {
            return 0;
        }
            break;
        default:
            break;
    }
    
    
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    
    UILabel * headLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, ScreenWidth-40, 20)];
    headLab.textColor = K_COLOR_CUSTEM(152,151,149, 1);
    headLab.font = [UIFont systemFontOfSize:15];
    headView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:headLab];

    switch (self.searchListStyle) {
        case (SearchListStyleHistoryStock):
        {
            headLab.text = @"最近搜索记录：";
            return headView;
        }
            break;
        case (SearchListStyleHotStock):
        {
            headLab.text = @"以下为今日热门股票";
            return headView;

        }
            break;
        case (SearchListStyleSearchStock):
        {
            return nil;
        }
            break;
        default:
            break;
    }
    

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HsStock  * stock = [[HsStock alloc] init];
    NSDictionary * stockDic;
    switch (self.searchListStyle) {
        case (SearchListStyleHistoryStock):
        {
            stockDic = _historyDataArray[indexPath.row];
            stock.stockCode = stockDic[@"stockCode"]==nil?@"":stockDic[@"stockCode"];
            stock.stockName = stockDic[@"stockName"]==nil?@"":stockDic[@"stockName"];
            stock.codeType  = stockDic[@"codeType"]==nil?@"":stockDic[@"codeType"];
        }
            break;
        case (SearchListStyleHotStock):
        {
            stockDic = _hotStockArray[indexPath.row];
            stock.stockCode = stockDic[@"stockCode"]==nil?@"":stockDic[@"stockCode"];
            stock.stockName = stockDic[@"stockName"]==nil?@"":stockDic[@"stockName"];
            stock.codeType  = stockDic[@"codeType"]==nil?@"":stockDic[@"codeType"];
        }
            break;
        case (SearchListStyleSearchStock):
        {
            stock = _searchDataArray[indexPath.row];
            
            stockDic = @{@"stockCode":stock.stockCode,
                         @"stockName":stock.stockName,
                         @"codeType":stock.codeType};
            
            
        }
            break;
        default:
            break;
    }
    if ([[CMStoreManager sharedInstance] isLogin]) {
        [self saveHistory:stockDic];

    }

    StockDetailViewController * stockDetailVC = [[StockDetailViewController alloc] init];
    stockDetailVC.stock = stock;
    stockDetailVC.isbuy = NO;
    stockDetailVC.source = @"search";
    [self.navigationController pushViewController:stockDetailVC animated:YES];
    
}

- (void)loadFootView
{

    switch (self.searchListStyle) {
        case (SearchListStyleHistoryStock):
        {
            
            UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
            UIButton * clearHistoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            clearHistoryBtn.frame = CGRectMake(20, 20, ScreenWidth-40, 40);
            clearHistoryBtn.backgroundColor = K_COLOR_CUSTEM(217, 217, 217, 1);
            clearHistoryBtn.layer.cornerRadius = 5;
            clearHistoryBtn.layer.masksToBounds = YES;
            [clearHistoryBtn setTitle:@"清除搜索记录" forState:UIControlStateNormal];
            [clearHistoryBtn setTitleColor:K_COLOR_CUSTEM(110, 110, 110, 1) forState:UIControlStateNormal];
            [clearHistoryBtn addTarget:self action:@selector(ClearHistory) forControlEvents:UIControlEventTouchUpInside];
            [footView addSubview:clearHistoryBtn];
            
            _tableView.tableFooterView = footView;
            
            
        }
            break;
        case (SearchListStyleHotStock):
        {
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            _tableView.tableFooterView = view;
        
        }
            break;
        case (SearchListStyleSearchStock):
        {
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            _tableView.tableFooterView = view;
            
        }
            break;
        default:
            break;
    }
    

}

#pragma mark - 获取用户的自选股数据
- (void)getOptionalStockList
{
    
    
    
    NSString * token = [[CMStoreManager sharedInstance] getUserToken];
    NSDictionary * dic = @{@"version":VERSION,
                           @"token":token};
    
    [NetRequest postRequestWithNSDictionary:dic url:K_FAVORITESLIST successBlock:^(NSDictionary *dictionary) {
        
        NSLog(@"%@",dictionary);
        if ((NSNull*)dictionary != [NSNull null] && dictionary != nil&&dictionary!=NULL )
        {
            if ([dictionary[@"code"] intValue] == 200) {
                
                _optionalStockArray =[NSMutableArray arrayWithArray:dictionary[@"data"]] ;
                
//                [self searchStock:[_searchTextField.text firstLetters]];
                
                
                [_tableView reloadData];
                [self loadFootView];

                
            }
        }
    } failureBlock:^(NSError *error) {
        
        
    }];
   
    
}
- (void)getHistoryList
{
   
    
     //获取缓存信息
     CacheModel *cacheModel = [CacheEngine getCacheInfo];
    if( cacheModel.searchArray.count>0) {
        
        _historyDataArray = cacheModel.searchArray;

        if (_isChooseArray.count>0) {
            [_isChooseArray removeAllObjects];
        }
        for (int i= 0 ; i< _historyDataArray.count; i++) {
            [_isChooseArray addObject:@"0"];
        }

        self.searchListStyle = SearchListStyleHistoryStock;
        [_tableView reloadData];
        [self loadFootView];

    }else{
        [self getHotListStock];
    }
}
- (void)ClearHistory
{
    if (_historyDataArray.count>0) {
        [_historyDataArray removeAllObjects];

    }
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    cacheModel.searchArray = _historyDataArray;
    [CacheEngine setCacheInfo:cacheModel];
    self.searchListStyle = SearchListStyleHotStock;
    [self getHotListStock];
}
- (void)getHotListStock
{
    self.searchListStyle = SearchListStyleHotStock;

    NSString * textPath = @"http://cainiu.oss-cn-hangzhou.aliyuncs.com/cainiu/stock.txt";
    NSString * text = [NSString stringWithContentsOfURL:[NSURL URLWithString:textPath] encoding:NSUTF8StringEncoding error:nil];
    if (!text) {
        return;
    }
    NSArray * stockArray = [NSArray arrayWithArray:[text componentsSeparatedByString:@"\n"]];
  
    
    NSLog(@"%@",text);
    NSLog(@"%@",stockArray);
    NSLog(@"%lu",(unsigned long)stockArray.count);
    
    if (_isChooseArray.count>0) {
        [_isChooseArray removeAllObjects];

    }
    if (_hotStockArray.count>0) {
        [_hotStockArray removeAllObjects];
    }
    for (NSString *string in stockArray) {
        
        NSArray * array = [string componentsSeparatedByString:@","];
        NSDictionary * dic = [NSDictionary dictionary];
        if (array.count==1) {
           dic = @{@"stockCode":array[0]==nil?@"":array[0],
                                   
                                   };
        }else if(array.count==2){
          dic = @{@"stockCode":array[0]==nil?@"":array[0],
                  @"stockName":array[1]==nil?@"":array[1],
                                   };
        
        }else if(array.count==3){
        
           dic = @{@"stockCode":array[0]==nil?@"":array[0],
                   @"stockName":array[1]==nil?@"":array[1],
                   @"codeType":array[2]==nil?@"":array[2]
                                   };
        }
        
        [_hotStockArray addObject:dic];
        [_isChooseArray addObject:@"0"];

    }
    if (_hotStockArray.count>0) {
        
        [_tableView reloadData];
        [self loadFootView];
        

        
    }
    


}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"搜索"];
    self.view.backgroundColor = K_COLOR_CUSTEM(250, 67, 0, 1);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
    
    if (_searchTextField.text==nil || [_searchTextField.text isEqualToString:@""]) {
        
        [self getHistoryList];
        [self getOptionalStockList];//获取自选股数据

    }
    
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"搜索"];
}
- (void)saveHistory:(NSDictionary*)dictionary
{
    
    for (NSDictionary * indexSearchDic in _historyDataArray) {
        if ([indexSearchDic[@"stockCode"] isEqualToString:dictionary[@"stockCode"]]) {
            
            [_historyDataArray removeObject:indexSearchDic];
            break;
        }
        
        
    }
    
    
    [_historyDataArray insertObject:dictionary atIndex:0];

    
    

    if (_historyDataArray.count>10) {
    
        [_historyDataArray removeObjectAtIndex:(_historyDataArray.count-1)];
    
    }
    
    
    
    
    CacheModel *cacheModel = [CacheEngine getCacheInfo];
    //设置属性
    cacheModel.searchArray = _historyDataArray;
    // 存入缓存
    [CacheEngine setCacheInfo:cacheModel];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    _isChooseArray = [NSMutableArray array];
    _optionalStockArray = [NSMutableArray array];
    _historyDataArray  = [NSMutableArray array];
    _hotStockArray = [NSMutableArray array];
    [self initSearchResultTableView];
    [self getHistoryList];//获取历史数据
    [self getOptionalStockList];//获取自选股数据


    
    
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
