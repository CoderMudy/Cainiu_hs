//
//  RecordCell.m
//  hs
//
//  Created by PXJ on 15/7/28.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "IndexRecordCell.h"
#import "IndexRecordModel.h"

#define Key_DecimalPlaces productModel.decimalPlaces.intValue
#define DecimalNumStr(a) [Helper rangeNumString:a withDecimalPlaces:Key_DecimalPlaces]
#define fontText 13*ScreenWidth/375

@implementation IndexRecordCell

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        if ([reuseIdentifier isEqualToString:@"Entrusted"])
        {
            [self initEntrustedUI];
        }else if([reuseIdentifier isEqualToString:@"RecordCell"])
        {
            [self initRecordUI];
        }
   }
    return self;
}
- (void)initRecordUI
{

    float cellHeight = 73*ScreenWidth/375;
    
    self.timeLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 70*ScreenWidth/320, cellHeight-1)];
    self.timeLab.textColor = [UIColor lightGrayColor];
    self.timeLab.font = [UIFont systemFontOfSize:10];
    self.timeLab.numberOfLines = 0;
    [self addSubview:self.timeLab];
    
    self.buyTypeLab  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_timeLab.frame), cellHeight/2-10, 40, 20)];
    self.buyTypeLab.textAlignment = NSTextAlignmentCenter;
    self.buyTypeLab.layer.cornerRadius = 2;
    self.buyTypeLab.layer.masksToBounds = YES;
    self.buyTypeLab.font = [UIFont systemFontOfSize:13];
    self.buyTypeLab.textColor = [UIColor whiteColor];
    [self addSubview:self.buyTypeLab];
    
    CGFloat saleTypeLength = ScreenWidth/6;
    self.saleTypeLab = [[UILabel alloc] init];
    self.saleTypeLab.center = CGPointMake(CGRectGetMaxX(self.buyTypeLab.frame) + saleTypeLength/2 +20 , self.buyTypeLab.center.y);
    self.saleTypeLab.bounds = CGRectMake(0, 0, ScreenWidth/6, 20);
    self.saleTypeLab.font = FontSize(13);
    self.saleTypeLab.textColor = [UIColor lightGrayColor];
    self.saleTypeLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.saleTypeLab];
    
    self.addLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_saleTypeLab.frame), cellHeight/2-20, ScreenWidth-CGRectGetMaxX(_saleTypeLab.frame)-15, 20)];
    self.addLab.font = [UIFont systemFontOfSize:16];
    self.addLab.textAlignment = NSTextAlignmentRight;
    self.addLab.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.addLab];
    
    self.riseLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_saleTypeLab.frame), cellHeight/2, ScreenWidth-CGRectGetMaxX(_saleTypeLab.frame)-15, 15)];
    self.riseLab.font = FontSize(10);
    self.riseLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.riseLab];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(20, cellHeight-1, ScreenWidth-40, 0.5)];
    lineView.backgroundColor = K_color_black;
    [self addSubview:lineView];

}

- (void)setCellWithDictionary:(NSDictionary*)dictionary withSystemTime:(NSString*)systemTime productModel:(FoyerProductModel*)productModel
{
    NSString * unit;
    if ([productModel.loddyType isEqualToString:@"1"]) {
//        unit = productModel.currencyUnit;// [Helper unitWithCurrency:productModel.currency];
        unit = [NSString stringWithFormat:@" 元"];
    }else{
        unit = @" 积分";
    }
    IndexRecordModel * model = [IndexRecordModel modelObjectWithDictionary:dictionary];
    NSArray * dateArray =[model.saleDate componentsSeparatedByString:@" "];
    NSString * timeStr;
    int date= [Helper timeSysTime:systemTime createTime:model.saleDate];
    switch (date) {
        case 0:
        timeStr = @"今天";
            break;
        case 1:
        timeStr = @"昨天";
            break;
        default:
            timeStr = dateArray[0];
            break;
    }
    self.timeLab.text = [NSString stringWithFormat:@"%@\n%@",timeStr,dateArray[1]];
    if (model.tradeType==0) {
        self.buyTypeLab.text = @"看多";
        self.buyTypeLab.backgroundColor = K_color_red;
    }else{
        self.buyTypeLab.text = @"看空";
        self.buyTypeLab.backgroundColor = K_color_green;
    }
    NSString * saleOpSourceText;
    switch (model.saleOpSource.intValue) {
        case 2:
            saleOpSourceText = @"市价卖出";
            break;
        case 1:case 3:
            saleOpSourceText = @"到时中止";
            break;
        case 4:
        {
            if (model.lossProfit>0) {
                saleOpSourceText = @"止盈卖出";
            }else{
                saleOpSourceText = @"止损卖出";
            }
        }break;
        default:
            break;
    }
    self.saleTypeLab.text = saleOpSourceText;

    
    NSString * rise = [NSString stringWithFormat:@"%.2f%%",model.lossProfit*100.0/model.cashFund];
    NSString * profitStr;
    CGFloat profit = model.lossProfit * model.rate.floatValue;

   

    if(model.lossProfit>=0)
    {
        NSString * addStr;

        if (model.rate.floatValue !=1 &&[productModel.loddyType isEqualToString:@"1"]){
            addStr = [NSString stringWithFormat:@"+%.2f",profit];
            profitStr = [Helper addSign:addStr num:2];
        }else{
            addStr = [NSString stringWithFormat:@"+%.0f",profit];
            profitStr = [DataEngine countNumAndChangeformat:addStr];
            
        }
        self.riseLab.textColor = self.addLab.textColor =K_color_red;
        self.riseLab.text = [NSString stringWithFormat:@"+%@",rise];
    }else
    {
        NSString * addStr;
        
        if (model.rate.floatValue !=1 &&[productModel.loddyType isEqualToString:@"1"]){
            addStr = [NSString stringWithFormat:@"%.2f",profit];
            profitStr = [Helper addSign:addStr num:2];
        }else{
            addStr = [NSString stringWithFormat:@"%.2f",profit];
            addStr = [addStr substringToIndex:addStr.length-3];

            profitStr = [DataEngine countNumAndChangeformat:addStr];
            
        }
        self.riseLab.textColor = self.addLab.textColor =K_color_green;
        self.riseLab.text = [NSString stringWithFormat:@"%@",rise];

    }
    profitStr = [NSString stringWithFormat:@"%@%@",profitStr,unit];
    self.addLab.attributedText = [Helper mutableFontAndColorText:profitStr from:(int)profitStr.length-(int)unit.length to:(int)unit.length font:10 from:(int)profitStr.length-(int)unit.length to:(int)unit.length color:[UIColor lightGrayColor]];
//    self.addLab.attributedText = [Helper multiplicityText:profitStr from:(int)profitStr.length-(int)unit.length to:(int)unit.length  font:10];
    if(model.rate.floatValue !=1){
        NSString * riseUnit = @"积分)";
        if ([productModel.loddyType isEqualToString:@"1"]) {
            riseUnit = @")";
        }
        CGFloat initProfit = model.lossProfit;
        if(model.lossProfit<0)
        {
            initProfit  = initProfit*(-1);
        }
        
        if ([productModel.instrumentCode rangeOfString:@"CN"].location!=NSNotFound) {
            self.riseLab.text = [NSString stringWithFormat:@"(%@%.1f%@",productModel.currencySign,initProfit,riseUnit];
        }else{
            self.riseLab.text = [NSString stringWithFormat:@"(%@%.0f%@",productModel.currencySign,initProfit,riseUnit];
        }
        

    }
    
}
- (void)initEntrustedUI
{

    float cellHeight = 80 ;

    _timeLab        = [[UILabel alloc] init];
    _buyTypeLab     = [[UILabel alloc] init];
    _nameLab        = [[UILabel alloc] init];
    _orderTypeLab   = [[UILabel alloc] init];
    _priceLab       = [[UILabel alloc] init];
    _stopLossLab    = [[UILabel alloc] init];
    _stopProfitLab  = [[UILabel alloc] init];
    
    [self addSubview:_timeLab];
    [self addSubview:_buyTypeLab];
    [self addSubview:_nameLab];
    [self addSubview:_orderTypeLab];
    [self addSubview:_priceLab];
    [self addSubview:_stopLossLab];
    [self addSubview:_stopProfitLab];
    
    _cancelLab = [[UILabel alloc] initWithFrame:CGRectMake(25, cellHeight/2+6, 45, 20)];
    [self addSubview:_cancelLab];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.center = _cancelLab.center;
    _cancelBtn.hidden = YES;
    _cancelBtn.bounds = CGRectMake(0, 0, 50, 40);
    [_cancelBtn addTarget:self action:@selector(revokeOrder) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelBtn];

  
    _buyTypeLab.frame = CGRectMake(ScreenWidth*3/7, 12, 20, 12);
    _nameLab.frame = CGRectMake(CGRectGetMaxX(_buyTypeLab.frame)+10, CGRectGetMinY(_buyTypeLab.frame), ScreenWidth/4, CGRectGetHeight(_buyTypeLab.frame));
    
    _timeLab.font = _buyTypeLab.font = _nameLab.font = _orderTypeLab.font = _priceLab.font = _stopLossLab.font = _stopProfitLab.font = FontSize(fontText);
    
    _timeLab.adjustsFontSizeToFitWidth = YES;
    _buyTypeLab.adjustsFontSizeToFitWidth =YES;
    _nameLab.adjustsFontSizeToFitWidth =YES;
    _orderTypeLab.adjustsFontSizeToFitWidth =YES;
    _priceLab.adjustsFontSizeToFitWidth =YES;
    _stopLossLab.adjustsFontSizeToFitWidth =YES;
    _stopProfitLab.adjustsFontSizeToFitWidth =YES;

    _timeLab.textColor = _nameLab.textColor = _orderTypeLab.textColor = _priceLab.textColor = _stopLossLab.textColor = _stopProfitLab.textColor = [UIColor lightGrayColor];
    _buyTypeLab.textColor = [UIColor whiteColor];
    _timeLab.numberOfLines = 2;
    _buyTypeLab.textAlignment = NSTextAlignmentCenter;
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(20, cellHeight-1, ScreenWidth-40, 0.5)];
    lineView.backgroundColor = K_color_black;
    [self addSubview:lineView];
}
- (void)setEntrustedCellWithDictionary:(NSDictionary*)dictionary withSystemTime:(NSString*)systemTime productModel:(FoyerProductModel*)productModel cellStyle:(int)cellStyle;
{
    float cellHeight = 80 ;
    NSString * timeString = @"";
    NSString * timeTitle = @"";

    IndexRecordModel * model = [IndexRecordModel modelObjectWithDictionary:dictionary];
    if (model.tradeType==0)
    {
        self.buyTypeLab.text = @"多";
        self.buyTypeLab.backgroundColor = K_color_red;
    }else{
        self.buyTypeLab.text = @"空";
        self.buyTypeLab.backgroundColor = K_color_green;
    }
    
    self.nameLab.text = productModel.commodityName;
    NSString * stopProfit = [NSString stringWithFormat:@"%f",model.stopProfit];
    NSString * stopLoss = [NSString stringWithFormat:@"%f",model.stopLoss];
    
    self.stopProfitLab.text  = [NSString stringWithFormat:@"止盈金额 %@", DecimalNumStr(stopProfit)];
    self.stopLossLab.text = [NSString stringWithFormat:@"止损金额 %@",DecimalNumStr(stopLoss)];
    


    if (cellStyle==0)
    {
        NSString * buyPrice  = [NSString stringWithFormat:@"%f",model.buyPrice];
        self.orderTypeLab.text = [NSString stringWithFormat:@"订单类型 %@", model.conditionId==0?@"市价":@"条件"];
        self.priceLab.text = [NSString stringWithFormat:@"成交价格 %@",DecimalNumStr(buyPrice)];
        self.priceLab.hidden = NO;
        _orderTypeLab.frame = CGRectMake(CGRectGetMinX(_buyTypeLab.frame), CGRectGetMaxY(_buyTypeLab.frame)+5, ScreenWidth/4, 20);
        timeString = model.buyDate;
        timeTitle = @"成交时间";
        _timeLab.frame = CGRectMake(25, 10, ScreenWidth/3, cellHeight-20);

    }else
    {
        _timeLab.frame = CGRectMake(25, 10, ScreenWidth/3, (cellHeight-20)/2);
        self.priceLab.hidden = YES;
        NSString * entrustedPrice = [NSString stringWithFormat:@"%f",model.conditionPrice];
        model.sizeSymbol = 1;
        NSString * orderType = [NSString stringWithFormat:@"%@%@",model.sizeSymbol==1?@"≦":@"≧",DecimalNumStr(entrustedPrice)];
        self.orderTypeLab.text = [NSString stringWithFormat:@"委托条件 看%@价%@",self.buyTypeLab.text,orderType];
        _orderTypeLab.frame = CGRectMake(CGRectGetMinX(_buyTypeLab.frame), CGRectGetMaxY(_buyTypeLab.frame)+5, ScreenWidth/2, 20);
        timeString = model.createDate;
        timeTitle = @"委托时间";
        
        int modelStatus = [[NSString stringWithFormat:@"%.0f",model.status] intValue];
        switch (modelStatus) {/*  *条件单：（-1：已撤单，1：委托中（可撤单），2：已触发）*/
            case -1:
            {
                _timeLab.textColor = [UIColor lightGrayColor];
                _cancelLab.text = @"已撤单";
                _cancelLab.frame = CGRectMake(25, cellHeight/2+6, 70, 20);
                _cancelBtn.hidden = YES;
                _cancelLab.textColor = [UIColor lightGrayColor];
                _cancelLab.textAlignment = NSTextAlignmentLeft;
                _cancelLab.layer.borderWidth = 0;
                _cancelLab.layer.masksToBounds = NO;
                _cancelLab.font = FontSize(15);

            }
                break;
            case 1:
            {
                _timeLab.textColor = Color_Gold;
                _cancelLab.text = @"撤单";
                _cancelLab.frame = CGRectMake(25, cellHeight/2+6, 45, 20);
                _cancelBtn.hidden = NO;
                _cancelLab.textColor = Color_Gold;
                _cancelLab.textAlignment = NSTextAlignmentCenter;
                _cancelLab.layer.borderColor = Color_Gold.CGColor;
                _cancelLab.layer.borderWidth = 0.5;
                _cancelLab.layer.cornerRadius = 2;
                _cancelLab.layer.masksToBounds = YES;
                _cancelLab.font = FontSize(14);
            }
                break;
            case 2://case 6:
            {
                _timeLab.textColor = [UIColor lightGrayColor];
                _cancelLab.text = @"已触发";
                _cancelBtn.hidden = YES;
                _cancelLab.textColor = [UIColor lightGrayColor];;
                _cancelLab.textAlignment = NSTextAlignmentLeft;
                _cancelLab.layer.borderWidth = 0;
                _cancelLab.layer.masksToBounds = NO;
                _cancelLab.font = FontSize(15);
                _cancelLab.frame = CGRectMake(25, cellHeight/2+6, 45, 20);
            }
                break;
            default:
            {
                _cancelLab.text = @"撤单";
                _cancelLab.frame = CGRectMake(25, cellHeight/2+6, 45, 20);
                _timeLab.textColor = Color_Gold;
                _cancelBtn.hidden = NO;
                _cancelLab.textColor = Color_Gold;
                _cancelLab.textAlignment = NSTextAlignmentCenter;
                _cancelLab.layer.borderColor = Color_Gold.CGColor;
                _cancelLab.layer.borderWidth = 0.5;
                _cancelLab.layer.cornerRadius = 2;
                _cancelLab.layer.masksToBounds = YES;
                _cancelLab.font = FontSize(14);
           }
                break;
        }


    }
    
    timeString = [Helper timeTransform:timeString intFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"MM-dd HH:mm:ss"];
    self.timeLab.text = [NSString stringWithFormat:@"%@\n%@",timeTitle,timeString];
    
    _priceLab.frame = CGRectMake(CGRectGetMaxX(_orderTypeLab.frame)+5, CGRectGetMinY(_orderTypeLab.frame), ScreenWidth/4, 20);
    _stopLossLab.frame = CGRectMake(CGRectGetMinX(_buyTypeLab.frame), CGRectGetMaxY(_orderTypeLab.frame), ScreenWidth/4, 20);
    _stopProfitLab.frame = CGRectMake(CGRectGetMaxX(_stopLossLab.frame)+5, CGRectGetMinY(_stopLossLab.frame), ScreenWidth/4, 20);
    

}
/*撤单*/
- (void)revokeOrder
{
    self.cancelOrderBlock();
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
