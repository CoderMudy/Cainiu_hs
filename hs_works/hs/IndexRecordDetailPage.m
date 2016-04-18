//
//  RecordDetailPage.m
//  hs
//
//  Created by PXJ on 15/7/28.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "IndexRecordDetailPage.h"
#import "IndexRecordDetailCell.h"
#import "IndexRecordModel.h"
#import "FoyerProductModel.h"

@interface IndexRecordDetailPage ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIView * headerView;
@property (nonatomic,strong)IndexRecordModel * detailModel;
@property (nonatomic,strong)UILabel * marktitleLab;
@property (nonatomic,strong)UILabel * profitLab;

@end

@implementation IndexRecordDetailPage

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"订单详情"];
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
    
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"订单详情"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color_Gold;
    if (!_detailDic) {
        _detailDic = [NSDictionary dictionary];
    }
    _detailModel = [IndexRecordModel modelObjectWithDictionary:_detailDic];
    
    [self loadNav];
    [self initTableView];
}
#pragma mark Nav

-(void)loadNav{
    self.view.backgroundColor = Color_black;
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    
    [self.view addSubview:navView];
    
    //Left Button
    
    UIImage *leftButtonImage = [UIImage imageNamed:@"return_1.png"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 59, 44)];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchDown];
    [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    leftButton.titleLabel.shadowColor = RGBACOLOR(117,38,0,1.0f);
    leftButton.titleLabel.shadowOffset= CGSizeMake(0, -1);
    leftButton.titleLabel.textColor = [UIColor whiteColor];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(15, 44/2-leftButtonImage.size.height/2, leftButtonImage.size.width, leftButtonImage.size.height)];
    image.image = [UIImage imageNamed:@"return_1"];
    image.userInteractionEnabled = YES;
    [leftButton addSubview:image];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftButtonClick)];
    [image addGestureRecognizer:tap];
    
    [navView addSubview:leftButton];
    
    
    UILabel * titleLab = [[UILabel alloc] init];
    titleLab.center = CGPointMake(ScreenWidth/2, 22);
    titleLab.bounds = CGRectMake(0, 0, 100, 20);
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textColor = K_color_gray;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = @"订单详情";
    [navView addSubview:titleLab];
    
    
}

#pragma mark - tableView
-(void)initTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeigth-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = Color_black;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[IndexRecordDetailCell class] forCellReuseIdentifier:@"recordDetailCell"];
    [self.view addSubview:_tableView];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 110)];
    
    UILabel * headerTitleLab = [[UILabel alloc] init];
    headerTitleLab.center = CGPointMake(ScreenWidth/2-15, 30);
    headerTitleLab.bounds = CGRectMake(0, 0, 60, 15);
    headerTitleLab.text = @"结算盈亏(¥)";
    headerTitleLab.textAlignment = NSTextAlignmentCenter;
    headerTitleLab.textColor = K_color_gray;
    headerTitleLab.font = [UIFont systemFontOfSize:11];
    [_headerView addSubview:headerTitleLab];
    
    _marktitleLab = [[UILabel alloc] init];
    _marktitleLab.center = CGPointMake(ScreenWidth/2+headerTitleLab.frame.size.width/2, headerTitleLab.center.y);
    _marktitleLab.bounds = CGRectMake(0, 0, 30, 12);
    _marktitleLab.textAlignment = NSTextAlignmentCenter;
    _marktitleLab.layer.cornerRadius = 2;
    _marktitleLab.layer.masksToBounds = YES;
    _marktitleLab.textColor = [UIColor whiteColor];
    _marktitleLab.font = [UIFont systemFontOfSize:10];
    [_headerView addSubview:_marktitleLab];
    
    _profitLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _marktitleLab.frame.origin.y+_marktitleLab.frame.size.height+10, ScreenWidth, 30)];
    _profitLab.textColor = K_color_gray;
    _profitLab.textAlignment = NSTextAlignmentCenter;
    _profitLab.font = [UIFont systemFontOfSize:30];
    [_headerView addSubview:_profitLab];
    
    UILabel * rateLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_profitLab.frame), ScreenWidth, 15)];
    rateLab.textAlignment= NSTextAlignmentCenter;
    rateLab.font = [UIFont systemFontOfSize:11];
    [_headerView addSubview:rateLab];
    
    NSAttributedString * atrProfitStr;
    NSString * fundType;
    int unit = 0;//()
    if ([_productModel.instrumentID rangeOfString:@"CN"].location !=NSNotFound) {
        unit = 1;
    }
    if (_detailModel.fundType==0) {
        fundType = @"元";
    }else{
        fundType = @"积分";

    }
    if (_detailModel.rate.floatValue !=1) {
        rateLab.hidden = NO;
         CGFloat rateProfit = _detailModel.lossProfit;
        if (rateProfit<0) {
            rateProfit = rateProfit * (-1);
            rateLab.textColor  = K_color_green;
        }else{
            rateLab.textColor = K_color_red;
        }
        if (_detailModel.fundType==0) {
            
            rateLab.text = [NSString stringWithFormat:@"%@ %.2f (汇率%.2f)",_productModel.currencySign,rateProfit,_detailModel.rate.floatValue];

        }else{
            rateLab.text = [NSString stringWithFormat:@"%@ %.2f积分 (汇率%.2f)",_productModel.currencySign,rateProfit,_detailModel.rate.floatValue];

        }

    }else{
        rateLab.hidden = YES;
    }
    
    
    if (_detailModel.lossProfit>=0) {
        NSString *  profitStr = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",_detailModel.lossProfit*_detailModel.rate.floatValue]];
        
        if (_detailModel.rate.floatValue!=1&&[_productModel.loddyType isEqualToString:@"1"]){
            profitStr = [profitStr substringToIndex:profitStr.length];

        }else{
            profitStr = [profitStr substringToIndex:profitStr.length-3];

        }

        profitStr = [NSString stringWithFormat:@"+%@%@",profitStr,fundType];
        atrProfitStr = [Helper multiplicityText:profitStr from:0 to:(int)profitStr.length-(int)fundType.length color:K_color_red];
        rateLab.textColor = K_color_red;
    }else {
        NSString *  profitStr = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",_detailModel.lossProfit*_detailModel.rate.floatValue]];
        if (_detailModel.rate.floatValue!=1&&[_productModel.loddyType isEqualToString:@"1"]){
            profitStr = [profitStr substringToIndex:profitStr.length-1];
            
        }else{
            profitStr = [profitStr substringToIndex:profitStr.length-3];
            
        }
        profitStr = [NSString stringWithFormat:@"%@%@",profitStr,fundType];
        atrProfitStr = [Helper multiplicityText:profitStr from:0 to:(int)profitStr.length-(int)fundType.length color:K_color_green];
        rateLab.textColor = K_color_green;
    }
    _profitLab.attributedText = [Helper mulFontText:atrProfitStr from:(int)atrProfitStr.length-(int)fundType.length to:(int)fundType.length font:11];
    if (_detailModel.tradeType==0) {
        
        _marktitleLab.text = @"看多";
        _marktitleLab.backgroundColor = K_color_red;
    }else{
        _marktitleLab.text = @"看空";
        _marktitleLab.backgroundColor = K_color_green;
    }
    _tableView.tableHeaderView = _headerView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 3;
    }else{
        return 5;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IndexRecordDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"recordDetailCell" forIndexPath:indexPath];
    cell.backgroundColor = Color_black;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString * fundType = _productModel.currencyUnit;
    NSString * unit;
    if (_detailModel.fundType ==0) {
        unit = fundType;
    }else
    {
        unit = @"积分";
    }
    if (indexPath.section==0) {
        
        switch (indexPath.row) {
            case 0:
            {
                cell.nameLeft.text = @"交易品种";
                cell.nameRight.text = @"交易数量";
                cell.valueLeft.text = [NSString stringWithFormat:@"%@",_detailModel.futuresCode];
                cell.valueRight.text = [NSString stringWithFormat:@"%.0f手",_detailModel.count];
            }
                break;
            case 1:
            {
                cell.nameLeft.text = @"保证金";
                cell.nameRight.text = @"交易综合费";
                NSString * cashFundStr ;
                NSString * counterStr;
                if (_detailModel.fundType==0) {//现金
                    cashFundStr = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",_detailModel.cashFund]];
                    counterStr = [NSString stringWithFormat:@"%.2f%@",_detailModel.counterFee,unit];
                }else{//积分
                    cashFundStr = [DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%@ %.0f",_productModel.currencySign,_detailModel.cashFund]];
                    counterStr = [NSString stringWithFormat:@"%@ %.0f%@",_productModel.currencySign,_detailModel.counterFee,unit];
                }
                cashFundStr = [NSString stringWithFormat:@"%@%@",cashFundStr,unit];
                cell.valueLeft.attributedText = [Helper multiplicityText:cashFundStr from:(int)cashFundStr.length-(int)unit.length to:(int)unit.length font:10];
                cell.valueRight.attributedText = [Helper multiplicityText:counterStr from:(int)counterStr.length-(int)unit.length to:(int)unit.length font:10];
            }
                break;
            case 2:
            {
                cell.nameLeft.text = @"合约到期时间";
                cell.valueRight.text = [NSString stringWithFormat:@"%@",_detailModel.sysSetSaleDate];;
            }
                break;
            default:
                break;
        }
    }else {
        switch (indexPath.row) {
            case 0:
            {
                cell.nameLeft.text = @"买入价";
                cell.nameRight.text = @"卖出价";
                NSString * buyPriceStr;
                NSString * salePriceStr;
                switch (_productModel.decimalPlaces.intValue) {
                    case 0:
                    {
                        buyPriceStr   = [NSString stringWithFormat:@"%.0f%@",_detailModel.buyPrice,fundType];
                        salePriceStr = [NSString stringWithFormat:@"%.0f%@",_detailModel.salePrice,fundType];
                    }
                        break;
                    case 1:
                    {
                        buyPriceStr   = [NSString stringWithFormat:@"%.1f%@",_detailModel.buyPrice,fundType];
                        salePriceStr = [NSString stringWithFormat:@"%.1f%@",_detailModel.salePrice,fundType];
                    }
                        break;
                    case 2:
                    {
                        buyPriceStr   = [NSString stringWithFormat:@"%.2f%@",_detailModel.buyPrice,fundType];
                        salePriceStr = [NSString stringWithFormat:@"%.2f%@",_detailModel.salePrice,fundType];
                    }
                        break;
                        
                    default:
                        break;
                }
               cell.valueLeft.attributedText = [Helper multiplicityText:buyPriceStr from:(int)buyPriceStr.length-(int)fundType.length to:(int)fundType.length font:10];
                
                cell.valueRight.attributedText = [Helper multiplicityText:salePriceStr from:(int)salePriceStr.length-(int)fundType.length to:(int)fundType.length font:10];
            }
                break;
                
            case 1:
            {
                cell.nameLeft.text = @"买入类型";
                cell.nameRight.text = @"卖出类型";
                cell.valueLeft.text = @"市价买入";
                NSString * saleOpSourceText;
                switch (_detailModel.saleOpSource.intValue) {
                    case 2:
                        saleOpSourceText = @"市价卖出";
                        break;
                    case 1:case 3:
                        saleOpSourceText = @"到时中止";
                        break;
                    case 4:
                    {
                        if (_detailModel.lossProfit>0) {
                            saleOpSourceText = @"止盈卖出";
                        }else{
                            saleOpSourceText = @"止损卖出";
                            
                            
                        }
                    }break;
                    default:
                        break;
                }
                
                cell.valueRight.text = saleOpSourceText;
            }
                break;
                
            case 2:
            {
                cell.nameLeft.text = @"买入时间";
                cell.valueRight.text = [NSString stringWithFormat:@"%@",_detailModel.buyDate];;
            }
                break;
            case 3:
            {
                cell.nameLeft.text = @"卖出时间";
                cell.valueRight.text = [NSString stringWithFormat:@"%@",_detailModel.saleDate];;
            }
                break;
            case 4:
            {
                cell.nameLeft.text = @"订单单号";
                cell.valueRight.text = [NSString stringWithFormat:@"%@",_detailModel.displayId];;
            }
                break;
                
            default:
                break;
        }
        
        
    }
    
    
    return cell;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    sectionTitleView.backgroundColor =  Color_black;
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, ScreenWidth, 14)];
    titleLab.font = [UIFont systemFontOfSize:10];
    titleLab.textColor =K_color_gray;
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(20, 39, ScreenWidth-40, 1)];
    line.backgroundColor = K_COLOR_CUSTEM(110, 110, 110, 1);
    [sectionTitleView addSubview:titleLab];
    [sectionTitleView addSubview:line];
    switch (section) {
        case 0:
            titleLab.text = @"合约信息";
            break;
        case 1:
            titleLab.text = @"订单信息";
            break;
        default:
            break;
    }
    
    return sectionTitleView;
}


#pragma mark - Back
-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
