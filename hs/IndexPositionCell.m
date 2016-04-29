//
//  IndexPositionCell.m
//  hs
//
//  Created by PXJ on 15/7/28.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "IndexPositionCell.h"
#import "IndexPositionDataModels.h"
#import "NetRequest.h"
#import <math.h>

#define cellHeight 80//ScreenWidth*80/375
#define textFont 13
#define SALERECORE_TEXTCOLOR_GRAY K_color_grayBlack

@implementation IndexPositionCell

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = k_color_whiteBack;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCell];
        
    }
    
    return self;
    
}
- (void)initCell
{
    
    float tradeTypeFont = cellHeight/8;
    _tradeTypeLab = [[UILabel alloc] initWithFrame:CGRectMake(20, cellHeight/5 , tradeTypeFont*2+2, tradeTypeFont+2)];
    _tradeTypeLab.textAlignment = NSTextAlignmentCenter;
    _tradeTypeLab.textColor = [UIColor whiteColor];
    _tradeTypeLab.font = [UIFont systemFontOfSize:tradeTypeFont];
    _tradeTypeLab.layer.cornerRadius = 1;
    _tradeTypeLab.layer.masksToBounds = YES;
    [self addSubview:_tradeTypeLab];
    
    _endLossLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_tradeTypeLab.frame),CGRectGetMaxY(_tradeTypeLab.frame) + cellHeight/20, ScreenWidth/4, cellHeight/5)];
    _endLossLab.textColor = SALERECORE_TEXTCOLOR_GRAY;
    _endLossLab.font = [UIFont systemFontOfSize:textFont];
    [self addSubview:_endLossLab];
    
    _endEarnLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_tradeTypeLab.frame), _endLossLab.frame.origin.y+_endLossLab.frame.size.height, ScreenWidth/4, cellHeight*2/11)];
    _endEarnLab.textColor = SALERECORE_TEXTCOLOR_GRAY;
    _endEarnLab.textAlignment = NSTextAlignmentLeft;
    _endEarnLab.font = [UIFont systemFontOfSize:textFont];
    [self addSubview:_endEarnLab];
    
    

    
    
    float saleBtnWidth = ScreenWidth *60 /375;
    _saleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saleBtn.frame = CGRectMake(ScreenWidth-20-saleBtnWidth, 3*cellHeight/50,saleBtnWidth, 44*cellHeight/50);
    [_saleBtn addTarget:self action:@selector(saleClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saleBtn];
    
    _saleLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-20-saleBtnWidth, 10+(cellHeight-50)/2, saleBtnWidth, saleBtnWidth/2)];
    _saleLab.backgroundColor =Color_Gold;
    _saleLab.textAlignment = NSTextAlignmentCenter;
    _saleLab.text = @"平仓";
    _saleLab.textColor = [UIColor whiteColor];
    _saleLab.layer.cornerRadius = 3;
    _saleLab.layer.masksToBounds = YES;
    _saleLab.font = [UIFont systemFontOfSize:11];
    [self addSubview:_saleLab];
    
    
    float profit_X = ScreenWidth-20-saleBtnWidth-ScreenWidth*8/375 -ScreenWidth/2;
    _profitLab = [[UILabel alloc] initWithFrame:CGRectMake(profit_X,cellHeight*17/72, ScreenWidth/2, cellHeight/3)];
    _profitLab.font = [UIFont systemFontOfSize:cellHeight*5/15];
    _profitLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_profitLab];
    
    
    _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(profit_X, _profitLab.frame.origin.y+_profitLab.frame.size.height, ScreenWidth/2,cellHeight*13/50)];
    _priceLab.textColor = SALERECORE_TEXTCOLOR_GRAY;
    _priceLab.textAlignment = NSTextAlignmentRight;
    _priceLab.font = [UIFont systemFontOfSize:textFont];
    [self addSubview:_priceLab];
 
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(20, cellHeight-1, ScreenWidth-40, 0.6)];
    lineView.backgroundColor = K_color_line;
    [self addSubview:lineView];
    
    
}
- (void)saleClick:(UIButton *)button
{
    
    NSDictionary * dictionary = @{@"saleBtn":button,@"saleLab":_saleLab,@"profitLab":_profitLab,@"priceLab":_priceLab};
    
    self.block(dictionary);
    
//    NSLog(@"点击平仓");
}
- (void)setPositionCellWithModel:(IndexPositionList*)model
                        newPrice:(NSString *)newPrice
                        multiPle:(int)multiple
                   decimalplaces:(int)decimalplaces
                    productModel:(FoyerProductModel*)productModel
{
    NSString * unit;
    if (model.fundType==0) {
        unit = productModel.currencyUnit;
   }else{
        unit = @"积分";
   }
    
    
    float profit;
    int status = model.status;
    switch (status) {
        case 0:{
            _saleBtn.enabled =NO;
            _saleLab.text = @"买待处理";
            _priceLab.hidden = NO;
            _profitLab.hidden = NO;
            _saleLab.backgroundColor = K_COLOR_CUSTEM(89,89, 89, 1);
        }
            break;
        case 1:{
            _saleBtn.enabled =NO;
            _saleLab.text = @"买处理中";
            _priceLab.hidden = NO;
            _profitLab.hidden = NO;
            _saleLab.backgroundColor = K_COLOR_CUSTEM(89,89, 89, 1);
        }
            break;
        case 2:{
            _saleBtn.enabled =NO;
            _saleLab.text = @"买已申报";
            _priceLab.hidden = NO;
            _profitLab.hidden = NO;
            _saleLab.backgroundColor = K_COLOR_CUSTEM(89,89, 89, 1);

        }
            break;
        case 3:{
            _saleBtn.enabled =YES;
            _saleLab.text = @"平仓";
            _priceLab.hidden = NO;
            _profitLab.hidden = NO;
            _saleLab.backgroundColor = Color_Gold;
        }
            break;
        case 4:{
            _saleBtn.enabled =NO;
            _saleLab.text = @"卖处理中";
            _priceLab.hidden = NO;
            _profitLab.hidden = NO;
            _saleLab.backgroundColor = K_COLOR_CUSTEM(89,89, 89, 1);
        }
            break;
       case 5:{
            _saleBtn.enabled =NO;
            _saleLab.text = @"卖已申报";
            _priceLab.hidden = NO;
            _profitLab.hidden = NO;
            _saleLab.backgroundColor = K_COLOR_CUSTEM(89,89, 89, 1);
        }
            break;
        case 6:{
            _saleBtn.enabled =NO;
            _saleLab.text = @"平仓成功";
            _priceLab.hidden = YES;
            _profitLab.hidden = YES;
            _saleLab.backgroundColor = K_COLOR_CUSTEM(89,89, 89, 1);
        }
            break;
        case 7:{
            _saleBtn.enabled =NO;
            _saleLab.text = @"止盈平仓";
            _priceLab.hidden = YES;
            _profitLab.hidden = YES;
            _saleLab.backgroundColor = K_COLOR_CUSTEM(89,89, 89, 1);
        }break;
        case 8:{
            _saleBtn.enabled =NO;
            _saleLab.text = @"止损平仓";
            _priceLab.hidden = YES;
            _profitLab.hidden = YES;
            _saleLab.backgroundColor = K_COLOR_CUSTEM(89,89, 89, 1);
        }break;

        default:
            break;
    }
    
 
    //止损金额
    NSString * endLossLab   = [DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",model.stopLoss]] ;
    NSString * endearnLab   = [DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",model.stopProfit]] ;
    _endLossLab.text        = [NSString stringWithFormat:@"止损 -%@",endLossLab];
    _endEarnLab.text        = [NSString stringWithFormat:@"止盈 +%@",endearnLab];
    
    CGFloat endLossWidth    = [Helper calculateTheHightOfText:_endLossLab.text height:textFont font:[UIFont systemFontOfSize:textFont]];
    CGFloat endEarnWidth    = [Helper calculateTheHightOfText:_endEarnLab.text height:textFont font:[UIFont systemFontOfSize:textFont]];
    _endLossLab.frame       = CGRectMake(20, CGRectGetMaxY(_tradeTypeLab.frame)+cellHeight/20, endLossWidth+10, cellHeight/5);
    _endEarnLab.frame       = CGRectMake(_endLossLab.frame.origin.x, _endLossLab.frame.origin.y+_endLossLab.frame.size.height, endEarnWidth+10, cellHeight*2/11);

    
    float buyP = model.buyPrice.floatValue;
    float newP = newPrice.floatValue;
    
    switch (productModel.decimalPlaces.intValue) {
        case 0:{
            _priceLab.text = [NSString stringWithFormat:@"%.0f→%.0f",buyP,newP];
        }
            break;
        case 1:{
            _priceLab.text = [NSString stringWithFormat:@"%.1f→%.1f",buyP,newP];
        }
            break;
        case 2:{
            _priceLab.text = [NSString stringWithFormat:@"%.2f→%.2f",buyP,newP];
        }
            break;
        default:
            break;
    }
    //计算收益
    if (model.tradeType == 0) {
        _tradeTypeLab.text = @"看多";
        _tradeTypeLab.backgroundColor = K_color_red;
        if(model.status==3||model.status==4||model.status==5){
            if (newPrice.floatValue==0) {
                profit = 0;
            }else{
                profit = (newPrice.doubleValue-model.buyPrice.doubleValue)*multiple;
            }
        }else{
            profit = 0;
        }
    }else{
        _tradeTypeLab.text = @"看空";
        _tradeTypeLab.backgroundColor = K_color_green;
        if(model.status==3||model.status==4||model.status==5){
            
            if (newPrice.floatValue==0) {
                
                profit = 0;
            }else{
                profit = (model.buyPrice.doubleValue-newPrice.doubleValue)*multiple;
            }
        }else{
            profit = 0;
        }
    }
    
    int profitD =round(profit);
    NSString * profitStr = [DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%d",profitD]];
    if ([productModel.instrumentID rangeOfString:@"CN"].location !=NSNotFound) {
     
        profitStr = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",profit]];
        profitStr = [profitStr substringToIndex:profitStr.length-1];
    }
    if (profitD>=0) {
        profitStr = [NSString stringWithFormat:@"+%@%@",profitStr,unit];
        _profitLab.textColor = K_color_red;
    }else{
        profitStr = [NSString stringWithFormat:@"%@%@",profitStr,unit];;
        _profitLab.textColor = K_color_green;
    }
    NSMutableAttributedString * profitAtrStr = [Helper mutableFontAndColorText:profitStr from:(int)profitStr.length-(int)unit.length to:(int)unit.length font:textFont from:(int)profitStr.length-(int)unit.length to:(int)unit.length color:SALERECORE_TEXTCOLOR_GRAY];
    
    _profitLab.attributedText = profitAtrStr;
        if (profitD>=model.stopProfit&&profitD>0&&model.status==3) {
            [self searchOrderState:model saleStyle:7];
        }
        if (profitD<=model.stopLoss*(-1)&&profitD<0&&model.status==3) {
            [self searchOrderState:model saleStyle:8];
        }
}
- (void)searchOrderState:(IndexPositionList*)orderModel saleStyle:(int)saleStyle//saleStyle(7:止盈，8:止损)
{
    __block int saleStyles = saleStyle;
    NSString * str = [Helper toJSON:[NSArray arrayWithObject:[NSNumber numberWithInt:orderModel.listIdentifier]]];
    NSString * fundType = [NSString stringWithFormat:@"%.0f"
                           ,orderModel.fundType];
    [RequestDataModel requestOrderStateWithfundType:fundType orderId:str SuccessBlock:^(BOOL success, NSArray *dataArray) {
        if (dataArray.count>0) {
            NSDictionary * stateIdDic = dataArray.lastObject;
            int status = [stateIdDic[@"status"] intValue];
            if (status==6) {
                [self modifyCellShowStatus:saleStyles];
            }
        }
    }];
}
- (void)modifyCellShowStatus:(int)state
{

    NSString * str  = [NSString stringWithFormat:@"%d",state];
    self.ourBlock(str);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
