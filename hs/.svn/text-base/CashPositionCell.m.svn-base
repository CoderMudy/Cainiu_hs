//
//  CashPositionCell.m
//  hs
//
//  Created by PXJ on 15/11/25.
//  Copyright © 2015年 luckin. All rights reserved.
//
#define labLength (ScreenWidth-15)/6
#define fontText 12*ScreenWidth/375
#define Key_DecimalPlaces productModel.decimalPlaces.intValue
#define DecimalNumStr(a) [Helper rangeNumString:a withDecimalPlaces:Key_DecimalPlaces]

#import "CashPositionCell.h"
#import "CashPositionListModel.h"

@implementation CashPositionCell

- (void)awakeFromNib {
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initCellUI];
    }
    return self;
    
}
- (void)initCellUI
{
    _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, labLength+10, 30)];
    _timeLab.font = FontSize(fontText);
    _timeLab.textAlignment = NSTextAlignmentCenter;
    _timeLab.text = @"00:00:00";
    [self addSubview:_timeLab];
    
    
    _styleLab = [[UILabel alloc] init];
    _styleLab.center = CGPointMake(15+1.5*labLength , 15);
    _styleLab.bounds = CGRectMake(0, 0, labLength, 30);
    _styleLab.font   = FontSize(fontText);
    _styleLab.textColor = Color_Gold;
    _styleLab.textAlignment = NSTextAlignmentCenter;
    _styleLab.text = @"多";
    [self addSubview:_styleLab];
    
    _numLab = [[UILabel alloc] init];
    _numLab.center = CGPointMake(15+2.5*labLength, 15);
    _numLab.bounds = CGRectMake(0, 0, labLength, 30);
    _numLab.font = FontSize(fontText);
    _numLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_numLab];
    
    _priceLab = [[UILabel alloc] init];
    _priceLab.center = CGPointMake(15+4*labLength, 15);
    _priceLab.bounds = CGRectMake(0, 0, labLength*2, 30);
    _priceLab.font = FontSize(fontText);
    _priceLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_priceLab];
    
    _timeLab.textColor = _numLab.textColor = _priceLab.textColor = K_color_lightGray;
    
    UILabel * btnLab = [[UILabel alloc] init];
    btnLab.frame = CGRectMake(ScreenWidth-55, 7, 35, 16);
    btnLab.font = FontSize(fontText);
    btnLab.textColor = Color_Gold;
    btnLab.textAlignment = NSTextAlignmentCenter;
    btnLab.text = @"撤单";
    btnLab.layer.cornerRadius = 3;
    btnLab.layer.masksToBounds = YES;
    btnLab.layer.borderWidth = 1;
    btnLab.layer.borderColor = Color_Gold.CGColor;
    [self addSubview:btnLab];
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.center = btnLab.center;
    _cancelBtn.bounds = CGRectMake(0, 0, CGRectGetWidth(btnLab.frame), 30);
    [_cancelBtn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelBtn];
}
- (void)cancelOrder
{
    self.concelBlock();
    
}
- (void)setCashPositionCell:(id)sender productModel:(FoyerProductModel*)productModel;
{
    CashPositionListModel * model = (CashPositionListModel*)sender;
    _timeLab.text = [NSString stringWithFormat:@"%@",[model.createTime componentsSeparatedByString:@" "][1]];
    if ([model.orderType isEqualToString:@"2"])
    {
        
        //止盈止损单：
        _styleLab.text = @"止盈止损";
        _styleLab.textColor = Color_Gold;
        _styleLab.layer.borderWidth = 0;
        _priceLab.text = [NSString stringWithFormat:@"%@/%@",[model.upPrice floatValue]==0?DecimalNumStr(@"0.00"):DecimalNumStr(model.upPrice) ,[model.downPrice floatValue]==0?DecimalNumStr(@"0.00"):DecimalNumStr(model.downPrice)];
    }else
    {
        //多空单
        if([model.buyOrSal isEqualToString:@"B"])
        {
            _styleLab.text = @"多";
            _styleLab.textColor = K_color_red;
            _styleLab.layer.borderColor = K_color_red.CGColor;
            _styleLab.layer.borderWidth = 0.5;
            _priceLab.text = [model.price floatValue]==0.00 ?DecimalNumStr(@"0.00"):DecimalNumStr(model.price);
        }else if([model.buyOrSal isEqualToString:@"S"])
        {
            _styleLab.text = @"空";
            _styleLab.textColor = K_color_green;
            _styleLab.layer.borderColor = K_color_green.CGColor;
            _styleLab.layer.borderWidth = 0.5;
            _priceLab.text = [model.price floatValue]==0.00 ?DecimalNumStr(@"0.00"):DecimalNumStr(model.price);
        }
    }
    CGFloat styleLength = [Helper calculateTheHightOfText:_styleLab.text height:fontText+1 font:FontSize(fontText)];
    _styleLab.bounds = CGRectMake(0, 0, styleLength+4, fontText+4);
    _numLab.text = [NSString stringWithFormat:@"%d手",[model.num intValue]];
}

#pragma mark 市价单定时轮询
- (void)searOrderTimer:(CashPositionListModel*)model index:(NSInteger)index
{
    model.checkNum +=1;
    if (model.checkNum>15) {
        return;
    }
    if (model.checkNum<5) {
        [self performSelector:@selector(searchOrderStatus:index:) withObject:@{@"model":model,@"index":[NSNumber numberWithInteger:index]} afterDelay:1];
        
    }else{
        
        [self performSelector:@selector(searchOrderStatus:index:) withObject:@{@"model":model,@"index":[NSNumber numberWithInteger:index]} afterDelay:2];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
