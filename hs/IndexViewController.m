//
//  IndexViewController.m
//  hs
//
//  Created by RGZ on 15/7/24.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "IndexViewController.h"
#import "IndexBuyView.h"
#import "IndexPositionView.h"
#import "IndexSaleRecordPage.h"
#import "IndexAgreementController.h"
#import "IndexOrderController.h"

@interface IndexViewController ()
{
    UIScrollView        *_indexScrollView;
    UISegmentedControl  *_seg;
}
@property (nonatomic,strong)IndexPositionView *indexPositionV;
@end



@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNav];
    
    [self loadNotification];
    
    [self loadUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
    
    
    
}

-(void)loadNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(segValueChange) name:kSegValueChange object:nil];
}

-(void)segValueChange{
    _seg.selectedSegmentIndex = 1;
    [self segClick:_seg];
}

#pragma mark Nav

-(void)loadNav{
    self.view.backgroundColor = [UIColor colorWithRed:3/255.0 green:0 blue:20/255.0 alpha:1];
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    
    [self.view addSubview:navView];
    
    //Left Button
    
    UIImage *leftButtonImage = [UIImage imageNamed:@"return_1.png"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 44, 44)];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchDown];
    [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    leftButton.titleLabel.shadowColor = RGBACOLOR(117,38,0,1.0f);
    leftButton.titleLabel.shadowOffset= CGSizeMake(0, -1);
    leftButton.titleLabel.textColor = [UIColor whiteColor];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44/2-leftButtonImage.size.height/2, leftButtonImage.size.width, leftButtonImage.size.height)];
    image.image = [UIImage imageNamed:@"return_1"];
    image.userInteractionEnabled = YES;
    [leftButton addSubview:image];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftButtonClick)];
    [image addGestureRecognizer:tap];
    
    [navView addSubview:leftButton];
    
    //Right Button
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(ScreenWidth-60, 0, 60, 44);
    [rightButton setTitle:@"结算" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightNavClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:rightButton];
    
    //Seg
    
    NSString *buyStr = @"沪金买入";
    NSString *positionStr = @"沪金持仓";
    
    if (self.indexState == 1) {
        buyStr = @"沪金买入";
        positionStr = @"沪金持仓";
    }else if (self.indexState == 2){
        buyStr = @"期指买入";
        positionStr = @"期指持仓";
    }
    else if (self.indexState == 3){
        buyStr = @"沪银买入";
        positionStr = @"沪银持仓";
    }
    
    
    
    _seg = [[UISegmentedControl alloc]initWithItems:@[buyStr,positionStr]];
    _seg.frame = CGRectMake(ScreenWidth/2-ScreenWidth/5*2/2-10, 12, ScreenWidth/5*2+20, 20);
    _seg.selectedSegmentIndex = 0;
    [_seg addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventValueChanged];
    _seg.tintColor = [UIColor colorWithRed:234/255.0 green:194/255.0 blue:129/255.0 alpha:1];
    [navView addSubview:_seg];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Helvetica" size:10],NSFontAttributeName,nil];
    
    [_seg setTitleTextAttributes:dic forState:UIControlStateNormal];
    
}

-(void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 结算

-(void)rightNavClick{
    if ([[CMStoreManager sharedInstance] isLogin]) {
        
        IndexSaleRecordPage * indexSaleRecordVC = [[IndexSaleRecordPage alloc] init];
        [self.navigationController pushViewController:indexSaleRecordVC animated:YES];
        
    }
    else{
        [self login];
        _seg.selectedSegmentIndex = 0;
        _indexScrollView.contentOffset = CGPointMake(0, 0);
    }
    
}

#pragma mark Seg

-(void)segClick:(UISegmentedControl *)seg{
    
    if (![[CMStoreManager sharedInstance] isLogin]) {
        [self login];
        seg.selectedSegmentIndex = 0;
    }
    
    if (seg.selectedSegmentIndex == 0) {
        _indexScrollView.contentOffset = CGPointMake(0, 0);
    }
    else {
        _indexScrollView.contentOffset = CGPointMake(_indexScrollView.frame.size.width, 0);
    }
    
}

#pragma mark UI

-(void)loadUI{
    [self loadScrollView];
}

-(void)login{
    [[UIEngine sharedInstance] showAlertWithTitle:@"请先登录" ButtonNumber:2 FirstButtonTitle:@"返回" SecondButtonTitle:@"登录"];
    [UIEngine sharedInstance].alertClick = ^(int aIndex){
        if (aIndex == 10087) {
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    };
}

-(void)loadScrollView{
    _indexScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64)];
    _indexScrollView.pagingEnabled = YES;
    _indexScrollView.contentSize = CGSizeMake(ScreenWidth*2, ScreenHeigth-64);
    _indexScrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _indexScrollView.showsHorizontalScrollIndicator = NO;
    _indexScrollView.showsVerticalScrollIndicator = NO;
    _indexScrollView.delegate = self;
    _indexScrollView.clipsToBounds = YES;
    [self.view addSubview:_indexScrollView];
    
    
    //买入View
    IndexBuyView *indexBuyV = [[IndexBuyView alloc]initWithFrame:CGRectMake(0, 0, _indexScrollView.frame.size.width, _indexScrollView.frame.size.height)];
    
    indexBuyV.block = ^(IndexBuyModel *buyModel,int buyState , BOOL canUse){
        [self buyPush:buyModel BuyState:buyState canUse:canUse];
    };
    [_indexScrollView addSubview:indexBuyV];
    
    //持仓View
    _indexPositionV = [[IndexPositionView alloc]initWithFrame:CGRectMake(_indexScrollView.frame.size.width, 0, _indexScrollView.frame.size.width, _indexScrollView.frame.size.height)];
//    _indexPositionV.superVC = self;
    switch (_indexState) {
        case 1:
        {
            _indexPositionV.futuresTypes = 1;
        }
            break;
        case 2:
        {
            _indexPositionV.futuresTypes = 3;
        }
            break;
        case 3:
        {
            _indexPositionV.futuresTypes = 2;
        }
            break;
            
        default:
            break;
    }
    
    _indexPositionV.block = ^(){
        [self positionPush];
    };
    [_indexScrollView addSubview:_indexPositionV];

}

#pragma mark ScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_indexScrollView.contentOffset.x >= _indexScrollView.frame.size.width/2) {
        if ([[CMStoreManager sharedInstance] isLogin]) {
            _seg.selectedSegmentIndex = 1;
            [self requestPositionData];
        
        
        }
        else{
            [self login];
            _seg.selectedSegmentIndex = 0;
            _indexScrollView.contentOffset = CGPointMake(0, 0);
        }
    }
    else{
        _seg.selectedSegmentIndex = 0;
    }
}
#pragma mark - positionView请求持仓数据
- (void)requestPositionData
{    
    [_indexPositionV requestListData];

}

#pragma mark 买入

//买入跳转
-(void)buyPush:(IndexBuyModel *)indexBuyModel BuyState:(int)aBuyState canUse:(BOOL)aCanUse{
    if ([[CMStoreManager sharedInstance] isLogin]) {
        
        CacheModel *model = [CacheEngine getCacheInfo];
        //无协议，直接跳转订单
        if (model.isAgreeOfAu != nil && [model.isAgreeOfAu isEqualToString:@"1"]) {
            IndexOrderController    *orderVC = [[IndexOrderController alloc]init];
            orderVC.buyState = aBuyState;
            orderVC.mainState = self.indexState-1;
            orderVC.indexBuyModel = indexBuyModel;
            orderVC.canUse = aCanUse;
            [self.navigationController pushViewController:orderVC animated:YES];
        }
        //有协议
        else{
            IndexAgreementController *agreementVC = [[IndexAgreementController alloc]init];
            agreementVC.buyState = aBuyState;
            agreementVC.mainState = self.indexState-1;
            agreementVC.indexBuyModel = indexBuyModel;
            agreementVC.canUse = aCanUse;
            [self.navigationController pushViewController:agreementVC animated:YES];
        }
    }
    //未登录
    else{
        [self login];
    }
}


#pragma mark 持仓

//持仓跳转
-(void)positionPush{
    
    _seg.selectedSegmentIndex = 0;
    _indexScrollView.contentOffset = CGPointMake(0, 0);

    
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
