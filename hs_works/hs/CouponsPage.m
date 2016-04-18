//
//  CouponsPage.m
//  hs
//
//  Created by PXJ on 15/11/16.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "CouponsPage.h"
#import "CouponsCell.h"
#import "CouponsExchangePage.h"
#import "H5LinkPage.h"
#import "NetRequest.h"

@interface CouponsPage ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *couponArray;
    
    NSInteger page;
    NSInteger pageSize;
    
    NSInteger isNeedOrNot;//判断是可用优惠券列表还是已经过期的优惠券列表(4是可使用的优惠券列表)
    NSString *isCouPon;
    
    UIView *guizeView;
    UIButton * getHistoryBtn;

}
@property (strong,nonatomic)UITableView * tableView;
@property (strong,nonatomic)UIView * noDataView;
@property (strong,nonatomic)UIView *noHistoryView;
@property (strong,nonatomic)UIView *noUserView;

@end

@implementation CouponsPage

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self getCouponsData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    page = 1;
    pageSize = 10;
    isNeedOrNot = 4;
    isCouPon = @"couPon";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNav];

    [self initTableView];
    [self initNoUseDataView];
    
//    [self initNoDataView];
//    
//    [self initNoHistoryView];
    
    self.couponsListStyle = couponsStyleEnable;
}

- (void)initNav
{
    NavView * nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [nav.leftControl addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    [nav.rightControl addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    nav.titleLab.text = @"我的优惠";
    nav.rightLab.text = @"兑换";
    [self.view addSubview:nav];

}

- (void)initNoDataView
{
    _noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64)];
    _noDataView.backgroundColor = [UIColor whiteColor];
//    _noDataView.hidden = YES;
    [self.view addSubview:_noDataView];
    
    UIImageView * noDataImgV = [[UIImageView alloc] init];
    noDataImgV.center = CGPointMake(ScreenWidth/2, ScreenWidth*2/5);
    noDataImgV.bounds = CGRectMake(0, 0, 51, 35);
    noDataImgV.image = [UIImage imageNamed:@"coupon_5"];
    [_noDataView addSubview:noDataImgV];
    UILabel * remarkLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(noDataImgV.frame)+20, ScreenWidth-40, 20)];
    remarkLab.text = @"您还没有获得优惠券";
    remarkLab.textColor = K_color_gray;
    remarkLab.textAlignment = NSTextAlignmentCenter;
    remarkLab.font = [UIFont systemFontOfSize:15];
    [_noDataView addSubview:remarkLab];
    
    //暂时隐藏这个按钮
//    UIButton * getCouponsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    getCouponsBtn.center = CGPointMake(ScreenWidth/2, CGRectGetMaxY(remarkLab.frame)+30);
//    getCouponsBtn.bounds = CGRectMake(0, 0, ScreenWidth*2/5, 30);
//    getCouponsBtn.layer.cornerRadius = 5;
//    getCouponsBtn.layer.masksToBounds = YES;
//    getCouponsBtn.layer.borderWidth = 1;
//    getCouponsBtn.layer.borderColor = K_color_red.CGColor;
//    [getCouponsBtn setTitle:@"获得更多优惠" forState:UIControlStateNormal];
//    [getCouponsBtn setTitleColor:K_color_red forState:UIControlStateNormal];
//    [getCouponsBtn.titleLabel setFont: [UIFont systemFontOfSize:15]];
//    [getCouponsBtn addTarget:self action:@selector(getCoupons) forControlEvents:UIControlEventTouchUpInside];
//    [_noDataView addSubview:getCouponsBtn];
    
}

#pragma mark 有历史优惠券。但是没有可用优惠券的时候显示
- (void)initNoUseDataView
{
    _noUserView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64)];
    _noUserView.backgroundColor = [UIColor whiteColor];
    //    _noDataView.hidden = YES;
    [self.view addSubview:_noUserView];
    
    UIImageView * noDataImgV = [[UIImageView alloc] init];
    noDataImgV.center = CGPointMake(ScreenWidth/2, ScreenWidth*2/5);
    noDataImgV.bounds = CGRectMake(0, 0, 51, 35);
    noDataImgV.image = [UIImage imageNamed:@"coupon_5"];
    [_noUserView addSubview:noDataImgV];
    UILabel * remarkLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(noDataImgV.frame)+20, ScreenWidth-40, 20)];
    remarkLab.text = @"您还没有可用优惠券";
    remarkLab.textColor = K_color_gray;
    remarkLab.textAlignment = NSTextAlignmentCenter;
    remarkLab.font = [UIFont systemFontOfSize:15];
    [_noUserView addSubview:remarkLab];
    
    //暂时隐藏这个按钮
    getHistoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getHistoryBtn.hidden = YES;
    getHistoryBtn.center = CGPointMake(ScreenWidth/2, CGRectGetMaxY(remarkLab.frame)+30);
    getHistoryBtn.bounds = CGRectMake(0, 0, ScreenWidth*2/5, 30);
    getHistoryBtn.layer.cornerRadius = 5;
    getHistoryBtn.layer.masksToBounds = YES;
    getHistoryBtn.layer.borderWidth = 1;
    getHistoryBtn.layer.borderColor = K_color_red.CGColor;
    [getHistoryBtn setTitle:@"查看历史优惠券" forState:UIControlStateNormal];
    [getHistoryBtn setTitleColor:K_color_red forState:UIControlStateNormal];
    [getHistoryBtn.titleLabel setFont: [UIFont systemFontOfSize:15]];
    [getHistoryBtn addTarget:self action:@selector(getHistoryCouponsData) forControlEvents:UIControlEventTouchUpInside];
    [_noUserView addSubview:getHistoryBtn];

}


- (void)initNoHistoryView
{
    _noHistoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64)];
    _noHistoryView.backgroundColor = [UIColor whiteColor];
//    _noHistoryView.hidden = YES;
    [self.view addSubview:_noHistoryView];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth - (ScreenWidth - 150))/2, 24, ScreenWidth-150, 1)];
    lineView.backgroundColor = K_color_gray;
    [_noHistoryView addSubview:lineView];
    UILabel * guideLab = [[UILabel alloc] init ];
    guideLab.text = @"    使用规则";
    guideLab.font = [UIFont systemFontOfSize:15];
    CGFloat  textLength = [Helper calculateTheHightOfText:guideLab.text height:20 font:[UIFont systemFontOfSize:15]];
    guideLab.center  = lineView.center;
    guideLab.bounds = CGRectMake(20, 0, textLength +20, 20);
    guideLab.textAlignment = NSTextAlignmentCenter;
    guideLab.backgroundColor = [UIColor whiteColor];
    //    guideLab.alpha = 0.7;
    guideLab.textColor = K_color_gray;
    [_noHistoryView addSubview:guideLab];
    
    UIImageView *ruleImg = [[UIImageView alloc]init];
    ruleImg.image = [UIImage imageNamed:@"coupon_rule"];
    //    ruleImg.center = lineView.center;
    ruleImg.frame = CGRectMake(CGRectGetMinX(guideLab.frame) + 7, CGRectGetMinY(lineView.frame) - 6*ScreenWidth/320, 12*ScreenWidth/320, 12*ScreenWidth/320);
    [_noHistoryView addSubview:ruleImg];

    UIControl * control = [[UIControl alloc] init];
    control.center = guideLab.center;
    control.bounds = CGRectMake(0, 0,textLength+10, 44);
    [control addTarget:self action:@selector(ruleGuide) forControlEvents:UIControlEventTouchUpInside];
    [_noHistoryView addSubview:control];

    
    UIImageView * noDataImgV = [[UIImageView alloc] init];
    noDataImgV.center = CGPointMake(ScreenWidth/2, ScreenWidth*2/5);
    noDataImgV.bounds = CGRectMake(0, 0, 51, 35);
    noDataImgV.image = [UIImage imageNamed:@"coupon_5"];
    [_noHistoryView addSubview:noDataImgV];
    UILabel * remarkLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(noDataImgV.frame)+20, ScreenWidth-40, 20)];
    remarkLab.text = @"您还没有历史优惠券";
    remarkLab.textColor = K_color_gray;
    remarkLab.textAlignment = NSTextAlignmentCenter;
    remarkLab.font = [UIFont systemFontOfSize:15];
    [_noHistoryView addSubview:remarkLab];
    UIButton * getCouponsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getCouponsBtn.center = CGPointMake(ScreenWidth/2, CGRectGetMaxY(remarkLab.frame)+30);
    getCouponsBtn.bounds = CGRectMake(0, 0, ScreenWidth*2/5, 30);
    getCouponsBtn.layer.cornerRadius = 5;
    getCouponsBtn.layer.masksToBounds = YES;
    getCouponsBtn.layer.borderWidth = 1;
    getCouponsBtn.layer.borderColor = K_color_red.CGColor;
    [getCouponsBtn setTitle:@"查看可用券" forState:UIControlStateNormal];
    [getCouponsBtn setTitleColor:K_color_red forState:UIControlStateNormal];
    [getCouponsBtn.titleLabel setFont: [UIFont systemFontOfSize:15]];
    [getCouponsBtn addTarget:self action:@selector(getCouponsData) forControlEvents:UIControlEventTouchUpInside];
    [_noHistoryView addSubview:getCouponsBtn];
    
}

- (void)initTableView
{
    guizeView = [[UIView alloc]init];
    guizeView.backgroundColor = K_color_backView;
    guizeView.frame = CGRectMake(0, 64, ScreenWidth, 50);
    [self.view addSubview:guizeView];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth - (ScreenWidth - 150))/2, 24, ScreenWidth-150, 1)];
    lineView.backgroundColor = K_color_gray;
    [guizeView addSubview:lineView];
    UILabel * guideLab = [[UILabel alloc] init ];
    guideLab.text = @"    使用规则";
    guideLab.font = [UIFont systemFontOfSize:15];
    CGFloat  textLength = [Helper calculateTheHightOfText:guideLab.text height:20 font:[UIFont systemFontOfSize:15]];
    guideLab.center  = lineView.center;
    guideLab.bounds = CGRectMake(20, 0, textLength +20, 20);
    guideLab.textAlignment = NSTextAlignmentCenter;
    guideLab.backgroundColor = K_color_backView;
//    guideLab.alpha = 0.7;
    guideLab.textColor = K_color_gray;
    [guizeView addSubview:guideLab];
    
    UIImageView *ruleImg = [[UIImageView alloc]init];
    ruleImg.image = [UIImage imageNamed:@"coupon_rule"];
//    ruleImg.center = lineView.center;
    ruleImg.frame = CGRectMake(CGRectGetMinX(guideLab.frame) + 7, CGRectGetMinY(lineView.frame) - 6*ScreenWidth/320, 12*ScreenWidth/320, 12*ScreenWidth/320);
    [guizeView addSubview:ruleImg];
    
    UIControl * control = [[UIControl alloc] init];
    control.center = guideLab.center;
    control.bounds = CGRectMake(0, 0,textLength+10, 44);
    [control addTarget:self action:@selector(ruleGuide) forControlEvents:UIControlEventTouchUpInside];
    [guizeView addSubview:control];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(guizeView.frame), ScreenWidth, ScreenHeigth-CGRectGetMaxY(guizeView.frame)) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    guizeView.hidden = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = K_color_backView;
    [_tableView registerClass:[CouponsCell class] forCellReuseIdentifier:@"couponsCell"];
    [self.view addSubview:_tableView];
}

#pragma mark - 调用优惠券列表
- (void)requestCouponList
{
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token,@"status":@(isNeedOrNot),@"pageSize":@(pageSize),@"pageNo":@(page)};
    NSLog(@"dic:%@",dic);
    [NetRequest postRequestWithNSDictionary:dic url:K_User_CouponPageList successBlock:^(NSDictionary *dictionary) {
        
        if ([dictionary[@"code"] intValue]==200)
        {
            if (page == 1) {
                couponArray = [[NSMutableArray alloc]init];
            }
            
            if ([dictionary[@"data"] count] != 0)
            {
                for (NSDictionary *dic in dictionary[@"data"]) {
                    [couponArray addObject:dic];
                }
            }else
            {
                if (page != 1) {
                    page -- ;
                }
            }
        }else
        {
            if (page != 1) {
                page -- ;
            }
        }
        
//        [self loadUI];
        if (page == 1 && couponArray.count <= 0) {
            isCouPon = @"couPon";
            [self requestHistoryCouPonList];
        }else
        {
            _tableView.hidden = NO;
            guizeView.hidden  = NO;
            _noUserView.hidden = YES;
            getHistoryBtn.hidden = YES;
            [_noDataView removeFromSuperview];
        }
        [_tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        if (page == 1 && couponArray.count <= 0) {
            [self initNoDataView];
            _tableView.hidden = YES;
            guizeView.hidden  = YES;
        }else
        {
            _tableView.hidden = NO;
            guizeView.hidden  = NO;
            [_noDataView removeFromSuperview];
        }

        [_tableView reloadData];
        if (page != 1) {
            page -- ;
        }
        
        if (page == 1 && couponArray.count <=0) {
            _noDataView.hidden = NO;
        }
    }];
}

#pragma mark - 调用历史优惠券列表
- (void)requestHistoryCouPonList
{
    NSString * token =  [[CMStoreManager sharedInstance]getUserToken]==nil ?@"":[[CMStoreManager sharedInstance]getUserToken];
    
    NSDictionary * dic = @{@"token":token};
    
    [NetRequest postRequestWithNSDictionary:dic url:K_User_CouponHistoryList successBlock:^(NSDictionary *dictionary) {
        

        if ([dictionary[@"code"] intValue]==200)
        {
            if (page == 1) {
                couponArray = [[NSMutableArray alloc]init];
            }
            
            if ([dictionary[@"data"] count] != 0)
            {
                for (NSDictionary *dic in dictionary[@"data"]) {
                    [couponArray addObject:dic];
                }
            }
            
        }
        
        if (page == 1 && [dictionary[@"data"] count] == 0) {
            
            if ( [isCouPon isEqualToString:@"couPon"])
            {
                [self initNoDataView];
                _tableView.hidden = YES;
                guizeView.hidden = YES;
                 _noUserView.hidden = YES;
                getHistoryBtn.hidden = YES;
            }else
            {
                //显示没有历史优惠券
                [self initNoHistoryView];
                _tableView.hidden = YES;
                guizeView.hidden  = YES;
                 _noUserView.hidden = YES;
                getHistoryBtn.hidden = YES;
            }
            
        }else
        {
            if ([isCouPon isEqualToString:@"couPon"])
            {
                //需要可以查看历史优惠券
                _noUserView.hidden = NO;
                getHistoryBtn.hidden = NO;
                _tableView.hidden = YES;
            
            }else
            {
                _noUserView.hidden = YES;
                getHistoryBtn.hidden = YES;
                [_noHistoryView removeFromSuperview];
                _tableView.hidden = NO;
                guizeView.hidden  = NO;

            }
            
        }
//        [self loadUI];
        [_tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        if (page == 1 && couponArray.count <= 0) {
            //显示没有历史优惠券
            [self initNoHistoryView];
            _tableView.hidden = YES;
            guizeView.hidden  = YES;
        }else
        {
            [_noHistoryView removeFromSuperview];
            _tableView.hidden = NO;
            guizeView.hidden  = NO;
        }
        [_tableView reloadData];
    }];

}

- (void)getCouponsData
{
    isCouPon = @"couPon";
    //
    _noHistoryView.hidden = YES;
    [_tableView setContentOffset:CGPointMake(0, 0)];
    page = 1;
    [self requestCouponList];
    self.couponsListStyle = couponsStyleEnable;
    
}

- (void)getHistoryCouponsData
{
    isCouPon = @"history";
    [_tableView setContentOffset:CGPointMake(0, 0)];
    page = 1;
     self.couponsListStyle = couponsStyleUnEnable;
    [self requestHistoryCouPonList];
   
}

- (void)loadUI
{
    
    if (couponArray.count>0) {
        
        _tableView.hidden= NO;
        guizeView.hidden  = NO;
        if ([isCouPon isEqualToString:@"couPon"]) {
            _noDataView.hidden = YES;
            _noHistoryView.hidden = YES;
        }else
        {
            _noDataView.hidden = NO;
            _noHistoryView.hidden = NO;
        }
        
    }else{
        _tableView.hidden= YES;
        guizeView.hidden  = YES;
        
        if ([isCouPon isEqualToString:@"couPon"]) {
            _noDataView.hidden = NO;
            _noHistoryView.hidden = NO;
        }else
        {
            _noDataView.hidden = YES;
            _noHistoryView.hidden = YES;
        }

    }
    [_tableView reloadData];
}
#pragma mark ----- button Click -------

- (void)leftClick:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightClick:(UIButton*)button
{
 
    CouponsExchangePage * vc = [[CouponsExchangePage alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)ruleGuide
{
    H5LinkPage * linkVC = [[H5LinkPage alloc] init];
    linkVC.name = @"使用规则";
    linkVC.urlStr = [NSString stringWithFormat:@"%@/activity/coupon_rules.html",K_MGLASS_URL];
//    linkVC.urlStr = @"http://stock.cainiu.com/activity/coupon_rules.html";
    [self.navigationController pushViewController:linkVC animated:YES];

}
#pragma mark 获得更多优惠
- (void)getCoupons
{
    NSLog(@"获取更多优惠券");
    
}
#pragma mark UITableViewDataSource UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else{
//
        return 0;

    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 40;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return couponArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponsCell * coupons  = [tableView dequeueReusableCellWithIdentifier:@"couponsCell" forIndexPath:indexPath];
    
    coupons.selectionStyle = UITableViewCellSelectionStyleNone;
    [coupons setCellDetailWithModel:couponArray[indexPath.row]];
    
    return coupons;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    //调用通知，跳转到行情
//    self.rdv_tabBarController.selectedIndex = 0;
//    NSString *couponStr = [couponArray[indexPath.row] objectForKey:@"variety"];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"couPon" object:couponStr];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]init];
    return headView;
}

- (UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *footView = [[UIView alloc] init];
    
    UILabel * showLab = [[UILabel alloc] init];
    showLab.center = CGPointMake(ScreenWidth/2, 20);
    showLab.bounds = CGRectMake(0, 0, ScreenWidth-40, 20);
    showLab.textColor = K_color_red;
    showLab.textAlignment = NSTextAlignmentCenter;
    showLab.font = [UIFont systemFontOfSize:12];
    [footView addSubview:showLab];
    
    UIControl * leftClickBtn = [[UIControl alloc] init];
//    leftClickBtn.backgroundColor = [UIColor magentaColor];
    leftClickBtn.alpha = 0.3;
    [footView addSubview:leftClickBtn];

    UIControl * rightClickBtn = [[UIControl alloc] init];
//    rightClickBtn.backgroundColor = [UIColor yellowColor];
    rightClickBtn.alpha = 0.3;
    [footView addSubview:rightClickBtn];
    NSAttributedString * attributeString = [[NSAttributedString alloc] init];
    switch (self.couponsListStyle) {
        case couponsStyleEnable:
        {
            if (couponArray.count<_couponsNum) {
                showLab.attributedText = attributeString;
                showLab.text = @"点击加载更多";
                leftClickBtn.hidden = NO;
                leftClickBtn.frame = CGRectMake(20, 0, ScreenWidth-40, 40);
                [leftClickBtn addTarget:self action:@selector(clickMoreCoupon:) forControlEvents:UIControlEventTouchUpInside];
                
            }else{
                NSString * str = @"没有更多可用券了 查看历史优惠券>>";
                leftClickBtn.hidden = YES;
                rightClickBtn.hidden = NO;
                rightClickBtn.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2-20, 40);
                [rightClickBtn addTarget:self action:@selector(getHistoryCouponsData) forControlEvents:UIControlEventTouchUpInside];
                
                showLab.text = @"";
                showLab.attributedText = [Helper multiplicityText:str from:0 to:(int)[@"没有更多可用券了" length] color:K_color_gray];
            }
        }
            break;
        case couponsStyleUnEnable:
        {
            leftClickBtn.hidden = NO;
            rightClickBtn.hidden = NO;
            NSString *str = @"查看可用券";
            leftClickBtn.frame = CGRectMake(20, 0, ScreenWidth/2-20, 40);
            rightClickBtn.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2-20, 40);
            [leftClickBtn addTarget:self action:@selector(getCouponsData) forControlEvents:UIControlEventTouchUpInside];
//            [rightClickBtn addTarget:self action:@selector(getHistoryCouponsData) forControlEvents:UIControlEventTouchUpInside];
            showLab.text = str;
//            showLab.attributedText = [Helper multiplicityText:str from:(int)[@"查看可用券" length] + 3 to:(int)[@"没有更多过期券了" length] color:K_color_gray];
        }
            break;
        default:
            break;
    }
    return footView;
}

- (void)clickMoreCoupon:(UIButton *)sender
{
    NSLog(@"点击加载更多可用的优惠券");
    page ++;
    [self requestCouponList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
