//
//  RecordDetailController.m
//  hs
//
//  Created by RGZ on 15/7/14.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "RecordDetailController.h"
#import "RecordDetailCellOne.h"
#import "RecordDetailCellTwo.h"

@interface RecordDetailController ()
{
    //订单信息
    NSMutableArray *_orderInfoArray;
    //成交记录
    NSMutableArray *_recordInfoArray;
    
    BOOL           isAverage;
}

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation RecordDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNav];
    
    [self loadData];
    
    [self loadUI];
}

#pragma mark Nav

-(void)loadNav{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavTitle:@"订单详情"];
    [self setNavLeftBut:NSPushMode];
}

#pragma mark Data

-(void)loadData{
    _orderInfoArray = [NSMutableArray arrayWithCapacity:0];
    _recordInfoArray = [NSMutableArray arrayWithCapacity:0];
    
    //name
    if (self.infoDic[@"stockName"] != nil && ![self.infoDic[@"stockName"] isKindOfClass:[NSNull class]]&& ![self.infoDic[@"stockName"] isEqual:[NSNull null]]) {
        [_orderInfoArray addObject:[NSString stringWithFormat:@"%@",self.infoDic[@"stockName"]]];
    }
    else{
        [_orderInfoArray addObject:@" "];
    }
    //配资额度
    if (self.infoDic[@"financyAllocation"] != nil && ![self.infoDic[@"financyAllocation"] isKindOfClass:[NSNull class]]&& ![self.infoDic[@"financyAllocation"] isEqual:[NSNull null]]) {
        NSString *money = nil;
        
        if (self.isScore) {
            money = [DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",[self.infoDic[@"financyAllocation"] floatValue]]];
            money = [money stringByAppendingString:@"积分"];
        }
        else{
            money = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[self.infoDic[@"financyAllocation"] floatValue]]];
            money = [money stringByAppendingString:@"元"];
        }
        
        [_orderInfoArray addObject:money];
    }
    else{
        [_orderInfoArray addObject:@" "];
    }
    //配资比例
    if (self.infoDic[@"multiple"] != nil && ![self.infoDic[@"multiple"] isKindOfClass:[NSNull class]] && ![self.infoDic[@"multiple"] isEqual:[NSNull null]]) {
        [_orderInfoArray addObject:[NSString stringWithFormat:@"1:%@",self.infoDic[@"multiple"]]];
    }
    else{
        [_orderInfoArray addObject:@" "];
    }
    //保证金
    if (self.infoDic[@"cashFund"] != nil && ![self.infoDic[@"cashFund"] isKindOfClass:[NSNull class]] && ![self.infoDic[@"cashFund"] isEqual:[NSNull null]]) {
        
        NSString *money = nil;
        
        if (self.isScore) {
            money = [DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",[self.infoDic[@"cashFund"] floatValue]]];
            money = [money stringByAppendingString:@"积分"];
        }
        else{
            money = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[self.infoDic[@"cashFund"] floatValue]]];
            money = [money stringByAppendingString:@"元"];
        }
        
        [_orderInfoArray addObject:money];
    }
    else{
        [_orderInfoArray addObject:@" "];
    }
    //交易综合费
    if (self.infoDic[@"counterFee"] != nil && ![self.infoDic[@"counterFee"] isKindOfClass:[NSNull class]] && ![self.infoDic[@"counterFee"] isEqual:[NSNull null]]) {
        
        NSString *money = nil;
        
        if (self.isScore) {
            money = [DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",[self.infoDic[@"counterFee"] floatValue]]];
            money = [money stringByAppendingString:@"积分"];
        }
        else{
            money = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[self.infoDic[@"counterFee"] floatValue]]];
            money = [money stringByAppendingString:@"元"];
        }
        
        [_orderInfoArray addObject:money];
    }
    else{
        [_orderInfoArray addObject:@" "];
    }
    //服务费
    if (self.infoDic[@"totalInterest"] != nil && ![self.infoDic[@"totalInterest"] isKindOfClass:[NSNull class]] && ![self.infoDic[@"totalInterest"] isEqual:[NSNull null]]) {
        
        NSString *money = nil;
        
        if (self.isScore) {
            money = [DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",[self.infoDic[@"totalInterest"] floatValue]]];
            money = [money stringByAppendingString:@"积分"];
        }
        else{
            money = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[self.infoDic[@"totalInterest"] floatValue]]];
            money = [money stringByAppendingString:@"元"];
        }
        [_orderInfoArray addObject:money];
    }
    else{
        [_orderInfoArray addObject:@" "];
    }
    //预警金额
    if (self.infoDic[@"warnAmt"] != nil && ![self.infoDic[@"warnAmt"] isKindOfClass:[NSNull class]] && ![self.infoDic[@"warnAmt"] isEqual:[NSNull null]]) {
        NSString *money = nil;
        
        if (self.isScore) {
            money = [DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",[self.infoDic[@"warnAmt"] floatValue]]];
            money = [money stringByAppendingString:@"积分"];
        }
        else{
            money = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[self.infoDic[@"warnAmt"] floatValue]]];
            money = [money stringByAppendingString:@"元"];
        }
        [_orderInfoArray addObject:money];
    }
    else{
        [_orderInfoArray addObject:@" "];
    }
    //平仓金额
    if (self.infoDic[@"maxLoss"] != nil && ![self.infoDic[@"maxLoss"] isKindOfClass:[NSNull class]] && ![self.infoDic[@"maxLoss"] isEqual:[NSNull null]]) {
        NSString *money = nil;
        
        if (self.isScore) {
            money = [DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",[self.infoDic[@"maxLoss"] floatValue]]];
            money = [money stringByAppendingString:@"积分"];
        }
        else{
            money = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[self.infoDic[@"maxLoss"] floatValue]]];
            money = [money stringByAppendingString:@"元"];
        }
        [_orderInfoArray addObject:money];
    }
    else{
        [_orderInfoArray addObject:@" "];
    }
    //合约到期时间
    if (self.infoDic[@"sysSetSaleDate"] != nil && ![self.infoDic[@"sysSetSaleDate"] isKindOfClass:[NSNull class]] && ![self.infoDic[@"sysSetSaleDate"] isEqual:[NSNull null]]) {
        [_orderInfoArray addObject:[NSString stringWithFormat:@"%@",self.infoDic[@"sysSetSaleDate"]]];
    }
    else{
        [_orderInfoArray addObject:@" "];
    }
    
    
    //买入价
    if (self.infoDic[@"buyPrice"] != nil && ![self.infoDic[@"buyPrice"] isKindOfClass:[NSNull class]] && ![self.infoDic[@"buyPrice"] isEqual:[NSNull null]]) {
        NSString *money = nil;
        money = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[self.infoDic[@"buyPrice"] floatValue]]];
        money = [money stringByAppendingString:@"元"];
        [_recordInfoArray addObject:money];
    }
    else{
        [_recordInfoArray addObject:@" "];
    }
    //买入股数
    if (self.infoDic[@"factBuyCount"] != nil && ![self.infoDic[@"factBuyCount"] isKindOfClass:[NSNull class]] && ![self.infoDic[@"factBuyCount"] isEqual:[NSNull null]]) {
        [_recordInfoArray addObject:[[NSString stringWithFormat:@"%@",self.infoDic[@"factBuyCount"]] stringByAppendingString:@"股"]];
    }
    else{
        [_recordInfoArray addObject:@" "];
    }
    //买入时间
    if (self.infoDic[@"buyDate"] != nil && ![self.infoDic[@"buyDate"] isKindOfClass:[NSNull class]] && ![self.infoDic[@"buyDate"] isEqual:[NSNull null]]) {
        [_recordInfoArray addObject:[NSString stringWithFormat:@"%@",self.infoDic[@"buyDate"]]];
    }
    else{
        [_recordInfoArray addObject:@" "];
    }
    //卖出价
    if (self.infoDic[@"salePrice"] != nil && ![self.infoDic[@"salePrice"] isKindOfClass:[NSNull class]] && ![self.infoDic[@"salePrice"] isEqual:[NSNull null]]) {
        NSString *money = nil;
        money = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",[self.infoDic[@"salePrice"] floatValue]]];
        money = [money stringByAppendingString:@"元"];
        [_recordInfoArray addObject:money];
    }
    else{
        [_recordInfoArray addObject:@" "];
    }
    //卖出股数
    if (self.infoDic[@"factSaleCount"] != nil && ![self.infoDic[@"factSaleCount"] isKindOfClass:[NSNull class]] && ![self.infoDic[@"factSaleCount"] isEqual:[NSNull null]]) {
        [_recordInfoArray addObject:[[NSString stringWithFormat:@"%@",self.infoDic[@"factSaleCount"]] stringByAppendingString:@"股"]];
    }
    else{
        [_recordInfoArray addObject:@" "];
    }
    //卖出时间
    if (self.infoDic[@"saleDate"] != nil && ![self.infoDic[@"saleDate"] isKindOfClass:[NSNull class]] && ![self.infoDic[@"saleDate"] isEqual:[NSNull null]]) {
        [_recordInfoArray addObject:[NSString stringWithFormat:@"%@",self.infoDic[@"saleDate"]]];
    }
    else{
        [_recordInfoArray addObject:@" "];
    }
    //订单单号
    if (self.infoDic[@"displayId"] != nil && ![self.infoDic[@"displayId"] isKindOfClass:[NSNull class]] && ![self.infoDic[@"displayId"] isEqual:[NSNull null]]) {
        [_recordInfoArray addObject:[NSString stringWithFormat:@"%@",self.infoDic[@"displayId"]]];
    }
    else{
        [_recordInfoArray addObject:@" "];
    }
}

#pragma mark UI

-(void)loadUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeigth-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self.view addSubview:self.tableView];
}

#pragma mrak Table

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        RecordDetailCellOne *oneCell = [[RecordDetailCellOne alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        if (self.infoDic[@"lossProfit"] == nil || [self.infoDic[@"lossProfit"] isKindOfClass:[NSNull class]]) {
            self.infoDic[@"lossProfit"] = [NSNumber numberWithFloat:0];
        }
        
        if (self.isScore) {
            oneCell.moneyLabel.text = [NSString stringWithFormat:@"%.0f",[self.infoDic[@"lossProfit"] floatValue]];
        }
        else{
            oneCell.moneyLabel.text = [NSString stringWithFormat:@"%.2f",[self.infoDic[@"lossProfit"] floatValue]];
        }
        
        UIColor *color = nil;
        if ([oneCell.moneyLabel.text rangeOfString:@"+"].location != NSNotFound) {
            color = [UIColor redColor];
        }else if([oneCell.moneyLabel.text rangeOfString:@"+"].location == NSNotFound){
            if ([oneCell.moneyLabel.text rangeOfString:@"-"].location == NSNotFound) {
                oneCell.moneyLabel.text = [NSString stringWithFormat:@"%@%@",@"+",oneCell.moneyLabel.text];
                color = [UIColor redColor];
            }
            else{
                color = K_COLOR_CUSTEM(8, 186, 66, 1);
            }
        }
        else{
            color = K_COLOR_CUSTEM(8, 186, 66, 1);
        }
        
        if (self.isScore) {
            oneCell.moneyLabel.text = [oneCell.moneyLabel.text stringByAppendingString:@" 积分"];
            oneCell.moneyLabel.attributedText = [self multiplicityColorWithFont:oneCell.moneyLabel.text from:0 to:(int)oneCell.moneyLabel.text.length-2 color:color font:30];
        }
        else{
            oneCell.moneyLabel.text = [oneCell.moneyLabel.text stringByAppendingString:@" 元"];
            oneCell.moneyLabel.attributedText = [self multiplicityColorWithFont:oneCell.moneyLabel.text from:0 to:(int)oneCell.moneyLabel.text.length-1 color:color font:30];
        }
        
        oneCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return oneCell;
    }
    else{
        RecordDetailCellTwo *twoCell = [[RecordDetailCellTwo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        
//        NSMutableArray *infoArray = [NSMutableArray arrayWithObjects:@"财牛股票",@"1万元",@"1:5",@"5000.00元",@"15.00元",@"6.00元",@"500.00元",@"600.00元",@"2015-03-26 14:49:59", nil];
//        
//        NSMutableArray *recordArray = [NSMutableArray arrayWithObjects:@"12.56元",@"2000股",@"2015-03-25 10:21:55",@"12.56元", nil];
        
        [twoCell setInfoArray:_orderInfoArray];
        
        [twoCell setRecordArray:_recordInfoArray];
        
        twoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return twoCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }
    else{
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
    {
        return 100;
    }else{
        return 500;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSMutableAttributedString *)multiplicityColorWithFont:(NSString *)aStr from:(int)aFrom to:(int)aTo color:(UIColor *)aColor font:(float)aFont
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:aStr];
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:aFont] range:NSMakeRange(aFrom, aTo)];
    [str addAttribute:NSForegroundColorAttributeName value:aColor range:NSMakeRange(aFrom,aTo)];
    
    return str;
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
