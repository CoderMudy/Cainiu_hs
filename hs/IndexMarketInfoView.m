//
//  IndexMarketInfoView.m
//  hs
//
//  Created by RGZ on 16/1/11.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "IndexMarketInfoView.h"

@implementation IndexMarketInfoView
{
    float               allHeight;
    NSArray             *_titleArray;
    NSMutableArray      *_dataArray;
    FoyerProductModel   *_productModel;
    NSTimer             *_reloadMarketInfoTimer;
    IndexMarketInfoModel   *_marketInfoModel;
}

#define One_One_Tag 10
#define One_Two_Tag 11
#define Two_One_Tag 12
#define Two_Two_Tag 13
#define Three_One_Tag 14
#define Three_Two_tag 15
#define Four_One_tag 16
#define Four_Two_tag 17
#define Five_One_tag 18
#define Five_Two_tag 19
#define Six_One_tag 20
#define Six_Two_tag 21
#define Seven_One_tag 22
#define Seven_Two_tag 23

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame ProductModel:(FoyerProductModel *)productModel{
    self = [super initWithFrame:frame];
    if (self) {
        _productModel = productModel;
        [self loadData];
        [self loadUI];
    }
    return self;
}

-(void)loadData{
    allHeight = ((217.0-25)/480)*ScreenHeigth;
    
    _titleArray = @[@"涨跌",@"涨幅",@"最高",@"最低",@"开盘",@"昨收",@"持仓",@"昨持仓",@"今结",@"昨结",@"总手",@"金额",@"涨停",@"跌停"];
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0 ; i < 14; i++) {
        [_dataArray addObject:@"--"];
    }
}

-(void)openTimer{
    if (_reloadMarketInfoTimer == nil) {
        _reloadMarketInfoTimer = [NSTimer scheduledTimerWithTimeInterval:5.2 target:self selector:@selector(requestTogetMarketInfoData) userInfo:nil repeats:YES];
        [_reloadMarketInfoTimer fire];
    }
}

-(void)closeTimer{
    [_reloadMarketInfoTimer invalidate];
    _reloadMarketInfoTimer = nil;
}

-(void)loadUI{
    for (int i = 0; i < 7; i++) {
        for (int j = 0; j < 2; j++) {
            if (_titleArray.count >= 2*i+(j+1)) {
                UIView  *view = [self factoryViewWithFrame:CGRectMake(15+((self.frame.size.width-45)/2+15)*j, allHeight/7*i, (self.frame.size.width-45)/2, allHeight/7) Title:_titleArray[2*i+(j+1)-1] Tag:2*i+(j+1)+9];
                [self addSubview:view];
            }
        }
    }
}

-(UIView *)factoryViewWithFrame:(CGRect)aFrame Title:(NSString *)aTitle Tag:(NSInteger)aTag{
    
    int font = 13;
    if (ScreenHeigth <= 568) {
        font = 11;
    }
    else if (ScreenHeigth <= 667 && ScreenHeigth > 568){
        font = 13;
    }
    else{
        font = 14;
    }
    
    UIView  *view = [[UIView alloc]initWithFrame:aFrame];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width/3, view.frame.size.height - 1 )];
    titleLabel.text = aTitle;
    titleLabel.font = [UIFont systemFontOfSize:font];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    [view addSubview:titleLabel];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width, 0, view.frame.size.width/3*2-5, view.frame.size.height - 1 )];
    detailLabel.tag = aTag;
    detailLabel.text = _dataArray[aTag-10];
    detailLabel.numberOfLines = 0;
    detailLabel.font = [UIFont systemFontOfSize:font];
    detailLabel.textAlignment = NSTextAlignmentRight;
    detailLabel.textColor = [UIColor blackColor];
    [view addSubview:detailLabel];
    
    UIView  *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height-1, view.frame.size.width, 1)];
    lineView.backgroundColor = Color_gray;
    [view addSubview:lineView];
    
    return view;
}

-(void)changeValue:(NSArray *)aArray{
    for (int i = 2; i < aArray.count; i++) {
        if (![aArray[i] isEqualToString:_dataArray[i]]) {
            [_dataArray replaceObjectAtIndex:i withObject:aArray[i]];
            [self changeValueWithTag:i+10 Info:aArray[i]];
        }
    }
}

-(void)changeValueWithTag:(int)aIndex Info:(NSString *)aInfo{
    UILabel *detailLabel = [self viewWithTag:aIndex];
    detailLabel.text = aInfo;
    switch (aIndex) {
        case One_One_Tag:
        {
            if ([aInfo rangeOfString:@"-"].location != NSNotFound) {
                detailLabel.textColor = Color_green;
            }
            else{
                detailLabel.textColor = Color_red;
            }
        }
            break;
        case One_Two_Tag://涨跌幅
        {
            if ([aInfo rangeOfString:@"-"].location != NSNotFound) {
                detailLabel.textColor = Color_green;
            }
            else{
                detailLabel.textColor = Color_red;
            }
        }
            break;
        case Two_One_Tag://最高
        {
            if ([self isPureFloat:_marketInfoModel.highestPrice] && [self isPureFloat:_marketInfoModel.preSettlementPrice]) {
                if ([_marketInfoModel.highestPrice floatValue] > [_marketInfoModel.preSettlementPrice floatValue] ) {
                    detailLabel.textColor = Color_red;
                }
                else if([_marketInfoModel.highestPrice floatValue] < [_marketInfoModel.preSettlementPrice floatValue]){
                    detailLabel.textColor = Color_green;
                }
                else{
                    detailLabel.textColor = Color_white;
                }
            }
        }
            break;
        case Two_Two_Tag://最低
        {
            if ([self isPureFloat:_marketInfoModel.lowestPrice] && [self isPureFloat:_marketInfoModel.preSettlementPrice]) {
                if ([_marketInfoModel.lowestPrice floatValue] > [_marketInfoModel.preSettlementPrice floatValue] ) {
                    detailLabel.textColor = Color_red;
                }
                else if([_marketInfoModel.lowestPrice floatValue] < [_marketInfoModel.preSettlementPrice floatValue]){
                    detailLabel.textColor = Color_green;
                }
                else{
                    detailLabel.textColor = Color_white;
                }
            }
        }
            break;
        case Three_One_Tag://开盘
        {
            if ([self isPureFloat:_marketInfoModel.openPrice] && [self isPureFloat:_marketInfoModel.preSettlementPrice]) {
                if ([_marketInfoModel.openPrice floatValue] > [_marketInfoModel.preSettlementPrice floatValue] ) {
                    detailLabel.textColor = Color_red;
                }
                else if([_marketInfoModel.openPrice floatValue] < [_marketInfoModel.preSettlementPrice floatValue]){
                    detailLabel.textColor = Color_green;
                }
                else{
                    detailLabel.textColor = Color_white;
                }
            }
        }
            break;
        case Three_Two_tag:
        {
            
        }
            break;
        case Four_One_tag:
        {
            
        }
            break;
        case Four_Two_tag:
        {
            
        }
            break;
        case Five_One_tag://今结
        {
            if ([self isPureFloat:_marketInfoModel.settlementPrice] && [self isPureFloat:_marketInfoModel.preSettlementPrice]) {
                if ([_marketInfoModel.settlementPrice floatValue] > [_marketInfoModel.preSettlementPrice floatValue] ) {
                    detailLabel.textColor = Color_red;
                }
                else if([_marketInfoModel.settlementPrice floatValue] < [_marketInfoModel.preSettlementPrice floatValue]){
                    detailLabel.textColor = Color_green;
                }
                else{
                    detailLabel.textColor = Color_white;
                }
            }
        }
            break;
        case Five_Two_tag:
        {
            
        }
            break;
        case Six_One_tag:
        {
            
        }
            break;
        case Six_Two_tag:
        {
            
        }
            break;
        case Seven_One_tag:
        {
            
        }
            break;
        case Seven_Two_tag:
        {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark Data

-(void)requestTogetMarketInfoData{
    [DataEngine requestToGetMarketInfoDataWithType:_productModel.instrumentID successBlock:^(BOOL SUCCESS, IndexMarketInfoModel *marketInfoModel) {
        if (SUCCESS) {
            _marketInfoModel = marketInfoModel;
            [self changeMarketInfo:marketInfoModel];
        }
    }];
}

-(void)changeMarketInfo:(IndexMarketInfoModel *)marketInfoModel{
    //涨跌(未使用)
    NSString    *changePrice = marketInfoModel.upDropPrice;
    //涨幅(未使用)
    NSString    *changePercent = marketInfoModel.rateOfPriceSpread;
    //最高
    NSString    *highest = marketInfoModel.highestPrice;
    //最低
    NSString    *lowest = marketInfoModel.lowestPrice;
    //开盘
    NSString    *openPrice = marketInfoModel.openPrice;
    //昨收
    NSString    *closePrice = marketInfoModel.preClosePrice;
    //持仓
    NSString    *position = [self stringToInt:marketInfoModel.openInterest];
    //昨持仓
    NSString    *prePosition = [self stringToInt:marketInfoModel.preOpenInterest];
    //今结
    NSString    *todaySettlement = marketInfoModel.settlementPrice;
    if (![self isPureFloat:todaySettlement] || [todaySettlement floatValue] > 1000000000000000) {
        todaySettlement = @"--";
    }
    //昨结
    NSString    *yesterdaySettlement = [self stringToInt:marketInfoModel.preSettlementPrice];
    //总手
    NSString    *totalNum = [self stringToInt:marketInfoModel.volume];
    //金额
    NSString    *totalPrice = [self stringToInt:marketInfoModel.turnover];
    //涨停
    NSString    *increaseStop = marketInfoModel.upperLimitPrice;
    //跌停
    NSString    *decreaseStop = marketInfoModel.lowerLimitPrice;
    NSArray *dataArray = @[changePrice,changePercent,highest,lowest,openPrice,closePrice,position,prePosition,todaySettlement,yesterdaySettlement,totalNum,totalPrice,increaseStop,decreaseStop];
    [self changeValue:dataArray];
}

-(NSString *)stringToInt:(NSString *)string{
    if (![string isEqualToString:@""] && ![string isEqualToString:@"--"]) {
        if ([self isPureFloat:string]) {
            NSString *resultString = string;
            float   stringFloat = [string floatValue];
            if (stringFloat >= 100000000) {
                stringFloat = stringFloat/100000000;
                resultString = [NSString stringWithFormat:@"%.2f亿",stringFloat];
            }
            return resultString;
        }
        else{
            return string;
        }
    }
    else{
        return string;
    }
}
//判断是否浮点型
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

//判断是否为整形：
//- (BOOL)isPureInt:(NSString*)string{
//    NSScanner* scan = [NSScanner scannerWithString:string];
//    intval;
//    return[scan scanInt:&val] && [scan isAtEnd];
//}

-(void)changePercentWithPrice:(NSString *)price Percent:(NSString *)percent{
    if ([price rangeOfString:@"-"].location == NSNotFound) {
        price = [NSString stringWithFormat:@"+%@",price];
    }
    if ([percent rangeOfString:@"-"].location == NSNotFound) {
        percent = [NSString stringWithFormat:@"+%@",percent];
    }
    
    [_dataArray replaceObjectAtIndex:0 withObject:price];
    [_dataArray replaceObjectAtIndex:1 withObject:percent];
    [self changeValueWithTag:10 Info:_dataArray[0]];
    [self changeValueWithTag:11 Info:_dataArray[1]];
}

@end
