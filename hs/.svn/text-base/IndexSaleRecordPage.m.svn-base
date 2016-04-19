//
//  IndexSaleRecordPage.m
//  hs
//
//  Created by PXJ on 15/7/28.
//  Copyright (c) 2015年 luckin. All rights reserved.
//
#define itemNum 3

#define  listView_Tag 13000 //13000~12003
#define  Btn_Tag 99900 //99900~99902
#define  Btn_Length (ScreenWidth-40)/itemNum
#define  markLine_Tag 98000

#import "IndexSaleRecordPage.h"
#import "IndexRecordView.h"
#import "NetRequest.h"
#import "FoyerProductModel.h"
#import "IndexRecordDetailPage.h"

@interface IndexSaleRecordPage ()<UIScrollViewDelegate>
{

    int _pageNocush;// 现金加载数据的起始页
    int _pageNoScore;// 积分加载数据的起始页
    
    BOOL _loadMorecush;//现金是否加载更多
    BOOL _loadMareScore;//积分是否加载更多
    
    BOOL _iscushSalePage;//判断当前显示页面（Yes现金，No积分）
    
    NSMutableArray * _cushListArray; //现金结算列表
    NSMutableArray * _scoreListArray; //积分结算列表
    
    int _tableNo; // 当前显示tableView （0现金，1积分）
    

}
@property (nonatomic,strong)UIButton * lastBtn;
@property (nonatomic,strong)UILabel * markLineLab;
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)UIView * controlView;
@end

@implementation IndexSaleRecordPage
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"订单结算"];
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;

}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"订单结算"];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = Color_black;
    [ManagerHUD showHUD:self.view animated:YES];
    
    [self loadNav];
    [self loadControlView];
    [self initScrollView];
    
//    [self initTestBtn];
    
}
//- (void)initTestBtn
//{
//    UIButton * button= [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(100, 20, 50, 40);
//    button.backgroundColor= K_color_orangeBack;
//    [button setTitle:@"下单" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//}
//- (void)clickBtn
//{
//    
//    NSDictionary * orderData =@{@"futuresCode":@"CL1605",
//                                @"fundType":@"1",
//                                @"count":@"1",
//                                @"sizeSymbol":@"1",
//                                @"tradeType":@"1",
//                                @"conditionPrice":@"40.41",
//                                @"stopProfit":@"1000",
//                                @"stopLoss":@"1000"
//                                };
//    
//    NSDictionary * dic = @{@"orderData":[Helper toJSON:orderData],
//                           @"token":[[CMStoreManager sharedInstance]getUserToken],
//                           @"version":@"0.0.1"
//                           };
//    
//    NSString * urlStr = [NSString stringWithFormat:@"http://stock.luckin.cn/order/condition/conditionBuy"];
//    [NetRequest postRequestWithNSDictionary:dic url:urlStr successBlock:^(NSDictionary *dictionary) {
//        NSLog(@"%@",dictionary);
//    } failureBlock:^(NSError *error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
//
//}
#pragma mark Nav

-(void)loadNav{
    NavView * nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [nav.leftControl addTarget:self action:@selector(leftControl) forControlEvents:UIControlEventTouchUpInside];
    nav.titleLab.text = @"我的订单";
    nav.titleLab.textColor = K_color_lightGray;
    nav.backgroundColor = Color_black;
    [self.view addSubview:nav];
}
- (void)leftControl
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -topView
-(void)loadControlView
{
    _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 33)];
    [self.view addSubview:_controlView];
    UILabel * markLine = [[UILabel alloc] initWithFrame:CGRectMake(20+(ScreenWidth-40)/3, 26, Btn_Length, 2)];
    markLine.tag = markLine_Tag;
    markLine.backgroundColor = Color_Gold;
    [_controlView addSubview:markLine];
    NSArray * btnTitleArray = @[@"委托记录",@"委托单",@"结算单"];
    for (int i=0; i<3; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20+i*(ScreenWidth-40)/3, 0, Btn_Length, 33);
        button.tag = 99900+i;
//        button.enabled = [btnEnable[i] boolValue];
        [button setTitleColor:K_color_gray forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13*ScreenWidth/375]];
        [button setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(controlClick:) forControlEvents:UIControlEventTouchUpInside];
        [_controlView addSubview:button];
        if (self.indexSaleRecordType==i) {
            [button setTitleColor:Color_Gold forState:UIControlStateNormal];
            _lastBtn = button;
            markLine.frame =  CGRectMake(20+i*Btn_Length, 26, Btn_Length, 2);
        }else{
            [button setTitleColor:K_color_lightGray forState:UIControlStateNormal];
        }
    }
}
#pragma mark - loadTableView
- (void)initScrollView
{
    CGFloat scrollHeight = ScreenHeigth-100;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, ScreenHeigth)];
    _scrollView.scrollEnabled = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(ScreenWidth*itemNum, scrollHeight);
    [self.view addSubview:_scrollView];
    for (int i=0; i<itemNum; i++)
    {
        IndexRecordView * sucListView = [[IndexRecordView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, scrollHeight) orderListStyle:i];
        sucListView.tag = listView_Tag+i;
        sucListView.indexRecordType = i;
        [_scrollView addSubview:sucListView];
        __weak typeof(self) weakSelf = self;
        sucListView.pageChangeBlock= ^(FoyerProductModel* productModel ,NSDictionary *dic){
            IndexRecordDetailPage * recordDetailPage = [[IndexRecordDetailPage alloc] init];
            recordDetailPage.detailDic = dic;
            recordDetailPage.productModel = productModel;
            [weakSelf.navigationController pushViewController:recordDetailPage animated:YES];
        };
    }
    [self controlClick:_lastBtn];
}
- (void)controlClick:(UIButton*)button
{
    int selectNum = (int)button.tag-Btn_Tag;

    NSString * urlStr = @"";
    switch (selectNum)
    {
        case 0:
        {
            [UIEngine showXianHuoPromptMesg:@"更多功能暂未开放，敬请期待"];
            return;
//            urlStr = K_Index_futuresOrderEntrustList;//委托记录列表
        }
            break;
        case 1:
        {
            [UIEngine showXianHuoPromptMesg:@"更多功能暂未开放，敬请期待"];
            return;
//            urlStr = K_Index_conditionOrderList;//条件单列表
        }
            break;
        case 2:
        {
            urlStr = K_Index_balanceList;//获取期货结算列表
        }
            break;

        default:
            break;
    }
    self.indexSaleRecordType = selectNum;
    self.scrollView.contentOffset = CGPointMake(selectNum*ScreenWidth, 0);
    [_lastBtn setTitleColor:K_color_lightGray forState:UIControlStateNormal];
    _lastBtn = button;
    [button setTitleColor:Color_Gold forState:UIControlStateNormal];
    
    UILabel * markLine = (UILabel *)[_controlView viewWithTag:markLine_Tag];
    markLine.center = CGPointMake(button.center.x, markLine.center.y);
    
    
    IndexRecordView * orderListView = (IndexRecordView*)[_scrollView viewWithTag:selectNum +listView_Tag];
    orderListView.productModel = self.productModel;
    orderListView.indexRecordType = self.indexSaleRecordType;
    [orderListView pageControl:urlStr wareId:self.productModel.instrumentID];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger  num = Btn_Tag;
    if (scrollView.contentOffset.x>=ScreenWidth*3-10)
    {
        num = Btn_Tag+3;
    }else if(scrollView.contentOffset.x>=ScreenWidth*2-10)
    {
        num = Btn_Tag+2;
    }else if(scrollView.contentOffset.x>=ScreenWidth-10)
    {
        num = Btn_Tag+1;
    }else
    {
        num = Btn_Tag;
    }
    UIButton * button = (UIButton*)[_controlView viewWithTag:num];
    [self controlClick:button];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIView * markLine = [_controlView viewWithTag:markLine_Tag];
    markLine.center = CGPointMake(Btn_Length*scrollView.contentOffset.x/ScreenWidth+20+Btn_Length/2, 31);
}

- (void)dealloc
{
    [_scrollView removeFromSuperview];
    [_controlView removeFromSuperview];
    [_lastBtn removeFromSuperview];
    [_markLineLab removeFromSuperview];
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
