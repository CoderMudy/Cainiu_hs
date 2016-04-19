//
//  MyOrderPage.m
//  hs
//
//  Created by PXJ on 15/11/24.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "MyCashOrderPage.h"
#import "MyCashOrderListView.h"

#define itemNum 3

#define  listView_Tag 12000 //12000~12003
#define  Btn_Tag 11000
#define  Btn_Length (ScreenWidth-40)/itemNum
#define  markLine_Tag 10999


@interface MyCashOrderPage ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIButton * lastSelectBtn;
@property (nonatomic,strong)UIView * controlView;
@property (nonatomic,strong)UIScrollView * scrollView;
@end

@implementation MyCashOrderPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Color_black;
    [self initNav];
    [self initControlView];
    [self initScrollView];

}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)initNav
{
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
- (void)initControlView
{
    
    _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 44)];
    [self.view addSubview:_controlView];
    
    UIView * markLine = [[UIView alloc] init ];
    markLine.backgroundColor = Color_Gold;
    markLine.tag = markLine_Tag;
    [_controlView addSubview:markLine];
    
    NSArray * controlArray = @[@"成交单",@"委托单",@"止盈止损"];

    for (int i=0; i<controlArray.count; i++) {
       
        UIButton * controlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_controlView addSubview:controlBtn];
        controlBtn.frame = CGRectMake(20+i*Btn_Length, 0, Btn_Length, 44);
        controlBtn.tag = Btn_Tag +i;
        [controlBtn setTitle:controlArray[i] forState:UIControlStateNormal];
        [controlBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [controlBtn addTarget:self action:@selector(controlClick:) forControlEvents:UIControlEventTouchUpInside];
        if (self.myCashOrderStyle==i) {
            [controlBtn setTitleColor:Color_Gold forState:UIControlStateNormal];
            _lastSelectBtn = controlBtn;
            markLine.frame = CGRectMake(20+i*Btn_Length, 30, Btn_Length, 2);
        }else{
            [controlBtn setTitleColor:K_color_lightGray forState:UIControlStateNormal];
        }
    }
}
- (void)initScrollView
{
    CGFloat scrollHeight = ScreenHeigth-CGRectGetMaxY(_controlView.frame);
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_controlView.frame), ScreenWidth, scrollHeight)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(ScreenWidth*itemNum, scrollHeight);
    [self.view addSubview:_scrollView];
    for (int i=0; i<4; i++)
    {
        MyCashOrderListView * sucListView = [[MyCashOrderListView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, scrollHeight)];
        sucListView.tag = listView_Tag+i;
        sucListView.myCashOrderListStyle = i;
        [_scrollView addSubview:sucListView];
    }
    [self controlClick:_lastSelectBtn];
}
- (void)controlClick:(UIButton*)button
{
    int selectNum ;
    self.myCashOrderStyle = selectNum = (int)button.tag-Btn_Tag;
    self.scrollView.contentOffset = CGPointMake(selectNum*ScreenWidth, 0);
    [_lastSelectBtn setTitleColor:K_color_lightGray forState:UIControlStateNormal];
    _lastSelectBtn = button;
    [button setTitleColor:Color_Gold forState:UIControlStateNormal];
    NSString * urlStr = @"";
    switch (selectNum)
    {
        case 0:
        {
            urlStr = K_Cash_queryOrderList;
        }
            break;
        case 1:
        {
            urlStr = K_Cash_queryEntrustList;//委托单列表
        }
            break;
        case 2:
        {
            urlStr = K_Cash_querySetOrderList;//止盈止损列表
        }
            break;
        case 3:
        {
            urlStr = K_Cash_queryEndOrderList;
        }
            break;
        default:
            break;
    }
    MyCashOrderListView * orderListView = (MyCashOrderListView*)[_scrollView viewWithTag:selectNum +listView_Tag];
    orderListView.productModel = self.productModel;
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
    __block UIView * markLine = [_controlView viewWithTag:markLine_Tag];
    markLine.center = CGPointMake(Btn_Length*scrollView.contentOffset.x/ScreenWidth+20+Btn_Length/2, 31);
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
