//
//  MyOrderCell.m
//  hs
//
//  Created by PXJ on 15/11/24.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "MyCashOrderCell.h"
#import "CashOrderSucModel.h"
#import "CashPositionListModel.h"
#define Key_DecimalPlaces productModel.decimalPlaces.intValue

#define DecimalNumStr(a) [Helper rangeNumString:a withDecimalPlaces:Key_DecimalPlaces]


#define cellHeight 80
#define fontText 12*ScreenWidth/375

@implementation MyCashOrderCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = Color_black;
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(20, cellHeight-1, ScreenWidth-40, 0.5)];
    line.backgroundColor = K_color_grayLine;
    [self addSubview:line];
    _cancelLab = [[UILabel alloc] initWithFrame:CGRectMake(25, cellHeight/2+10, 45, 16)];
    _cancelLab.hidden = YES;
    [self addSubview:_cancelLab];
    
    
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.center = _cancelLab.center;
    _cancelBtn.bounds = CGRectMake(0, 0, 50, 40);
    [_cancelBtn addTarget:self action:@selector(revokeOrder) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelBtn];

    
    _timeLab = [[UILabel alloc] init];
    _timeLab.numberOfLines = 0;
    [self addSubview:_timeLab];
    _markOneLab = [[UILabel alloc] init];
    [self addSubview:_markOneLab];
    _markTwoLab = [[UILabel alloc] init];
    [self addSubview:_markTwoLab];
    _detailOne = [[UILabel alloc] init];
    [self addSubview:_detailOne];
    _detailTwo = [[UILabel alloc] init];
    [self addSubview:_detailTwo];
    _detailThree = [[UILabel alloc] init];
    [self addSubview:_detailThree];
    _detailFour = [[UILabel alloc] init];
    [self addSubview:_detailFour];
    
    _timeLab.font = _markOneLab.font = _markTwoLab.font = _detailOne.font = _detailTwo.font = _detailThree.font = _detailFour.font = FontSize(fontText);
    _timeLab.textColor =_markOneLab.textColor = _markTwoLab.textColor = _detailOne.textColor = _detailTwo.textColor = _detailThree.textColor = _detailFour.textColor = K_color_lightGray;
    
    

}

- (void)setCashOrderListCellDetail:(id)sender productModel:(FoyerProductModel*)productModel
{
    
    
    NSString * time;
    NSString * markOne;
    NSString * markTwo;
    NSString * detailOne;
    NSString * detailTwo;
    NSString * detailThree;
    NSString * detailFour;
    
    _detailOne.textAlignment = _detailTwo.textAlignment = _detailThree.textAlignment = _detailFour.textAlignment = NSTextAlignmentLeft;
    _timeLab.textColor = K_color_lightGray;
    _cancelBtn.hidden = _cancelLab.hidden = YES;
    switch (self.myOrderCellStyle)
    {
        case MyOrderCellStyleSuccess:
        {
            CashOrderSucModel * sucModel = (CashOrderSucModel*)sender;
            time = [sucModel.bargainTime componentsSeparatedByString:@" "][1];

            time = [NSString stringWithFormat:@"成交时间\n%@",time];
            if ([sucModel.buyOrSal isEqualToString:@"B"]) {
                markOne = @"多";
                _markOneLab.backgroundColor = K_color_red;

            }else {
                markOne = @"空";
                _markOneLab.backgroundColor = K_color_green;
            }

            markTwo = productModel.commodityName;
            detailOne = [NSString stringWithFormat:@"成交价 %@",DecimalNumStr(sucModel.conPrice)] ;
            detailTwo = [NSString stringWithFormat:@"成交额 %@",DecimalNumStr(sucModel.contQty)];
            detailThree = [NSString stringWithFormat:@"成交量 %d手",[sucModel.contNum intValue]];;
            detailFour = [NSString stringWithFormat:@"手续费 %@",DecimalNumStr(sucModel.tmpMoney)];;
            _timeLab.text = time;
            _markOneLab.text = markOne;
            _markTwoLab.text = markTwo;
            _detailOne.text = detailOne;
            _detailTwo.text = detailTwo;
            _detailThree.text = detailThree;
            _detailFour.text = detailFour;
            _markOneLab.textAlignment = NSTextAlignmentCenter;
            _markOneLab.textColor = [UIColor whiteColor];
            CGFloat markOnelength = [Helper calculateTheHightOfText:markOne height:15 font:FontSize(fontText)];
            _timeLab.frame = CGRectMake(25, 10, ScreenWidth/4, cellHeight-20);
            _markOneLab.frame = CGRectMake(ScreenWidth*3/7, 12, markOnelength*2, 12);
            _markTwoLab.frame = CGRectMake(CGRectGetMaxX(_markOneLab.frame)+10, CGRectGetMinY(_markOneLab.frame), ScreenWidth/4, CGRectGetHeight(_markOneLab.frame));
            _detailOne.frame = CGRectMake(CGRectGetMinX(_markOneLab.frame), CGRectGetMaxY(_markOneLab.frame)+5, ScreenWidth/4, 20);
            _detailTwo.frame = CGRectMake(CGRectGetMaxX(_detailOne.frame)+5, CGRectGetMinY(_detailOne.frame), ScreenWidth/4, 20);
            _detailThree.frame = CGRectMake(CGRectGetMinX(_markOneLab.frame), CGRectGetMaxY(_detailOne.frame), ScreenWidth/4, 20);
            _detailFour.frame = CGRectMake(CGRectGetMaxX(_detailThree.frame)+5, CGRectGetMinY(_detailThree.frame), ScreenWidth/4, 20);
        }
            break;
        case MyOrderCellStyleSign:
        {
            CashPositionListModel * signModel = (CashPositionListModel*)sender;
            time = [signModel.createTime componentsSeparatedByString:@" "][1];
            if ([signModel.buyOrSal isEqualToString:@"B"])
            {
                markOne = @"多";
                _markOneLab.backgroundColor = K_color_red;
            }else
            {
                markOne = @"空";
                _markOneLab.backgroundColor = K_color_green;
            }
            markTwo = productModel.commodityName;
            detailOne = [NSString stringWithFormat:@"委托量 %d手",[signModel.num intValue]] ;
            detailTwo = [NSString stringWithFormat:@"委托价 %@",DecimalNumStr(signModel.price)];
            detailThree = [NSString stringWithFormat:@"成交量 %d手",[signModel.contNum intValue]];;
            _timeLab.text = [NSString stringWithFormat:@"委托时间\n%@",time];
            _markOneLab.text = markOne;
            _markTwoLab.text = markTwo;
            _detailOne.text = detailOne;
            _detailTwo.text = detailTwo;
            _detailThree.text = detailThree;
            _markOneLab.textColor = [UIColor whiteColor];
            _markTwoLab.textColor = K_color_lightGray;
            _markOneLab.textAlignment = NSTextAlignmentCenter;
            CGFloat markOnelength = [Helper calculateTheHightOfText:markOne height:15 font:FontSize(fontText)];
            
            _timeLab.frame = CGRectMake(25, 5, ScreenWidth/4, cellHeight/2-5);
            _markOneLab.frame = CGRectMake(ScreenWidth*3/7, 12, markOnelength*2, 12);
            _markTwoLab.frame = CGRectMake(CGRectGetMaxX(_markOneLab.frame)+10, CGRectGetMinY(_markOneLab.frame), ScreenWidth/4, CGRectGetHeight(_markOneLab.frame));
            _detailOne.frame = CGRectMake(CGRectGetMinX(_markOneLab.frame), CGRectGetMaxY(_markOneLab.frame)+5, ScreenWidth/4, 20);
            _detailTwo.frame = CGRectMake(CGRectGetMaxX(_detailOne.frame)+5, CGRectGetMinY(_detailOne.frame), ScreenWidth/4, 20);
            _detailThree.frame = CGRectMake(CGRectGetMinX(_markOneLab.frame), CGRectGetMaxY(_detailOne.frame), ScreenWidth/4, 20);
            _detailFour.frame = CGRectMake(CGRectGetMaxX(_detailThree.frame)+5, CGRectGetMinY(_detailThree.frame), ScreenWidth/4, 20);
            _cancelLab.hidden = NO;
            _cancelBtn.hidden = YES;
            _cancelLab.textColor = K_color_lightGray;
            _cancelLab.textAlignment = NSTextAlignmentLeft;
            _cancelLab.layer.borderWidth = 0;
            _cancelLab.layer.masksToBounds = NO;
            _cancelLab.font = FontSize(fontText+2*ScreenWidth/375);
            _cancelLab.frame = CGRectMake(25, cellHeight/2+8, 70, 20);
            _detailFour.text = @"";
            switch (signModel.orderStatus.intValue) {
                case -2:case -3:case -4:case 2:
                {
                    _cancelLab.text = @"已撤单";
                
                }
                    break;
                case -1:
                {
                    _cancelLab.text = @"委托失败";
                }
                    break;
                case 6:
                {
                    _cancelLab.frame = CGRectMake(25, cellHeight/2+8, 45, 20);
                    
                    _timeLab.textColor = Color_Gold;
                    _cancelLab.hidden = _cancelBtn.hidden = NO;
                    _cancelLab.text = @"撤单";
                    _cancelLab.textColor = Color_Gold;
                    _cancelLab.textAlignment = NSTextAlignmentCenter;
                    _cancelLab.layer.borderColor = Color_Gold.CGColor;
                    _cancelLab.layer.borderWidth = 1;
                    _cancelLab.layer.cornerRadius = 2;
                    _cancelLab.layer.masksToBounds = YES;
                    _cancelLab.font = FontSize(fontText+1*ScreenWidth/375);
//                    CGFloat pprice;//当前价
//                    CGFloat withHoldMoney = [signModel.price floatValue] *[signModel.num intValue]*0.1 +signModel.price.floatValue * [signModel.num intValue]*8/10000 *10;
                   CGFloat withHoldMoney = [signModel.price floatValue] *[signModel.num intValue]*0.1;
                    NSString * withHoldMoneyF = [NSString stringWithFormat:@"%f",withHoldMoney];
                    _detailFour.text = [NSString stringWithFormat:@"预扣金 %@",DecimalNumStr(withHoldMoneyF)];

                }
                    break;
                case 7:
                {
                    _cancelLab.text = @"已成交";
                    if([signModel.orderType isEqualToString:@"1"])
                    {
                        NSString * price = [NSString stringWithFormat:@"%f",signModel.price.floatValue];
                        _detailTwo.text = [NSString stringWithFormat:@"委托价 %@",DecimalNumStr(price)];

                    }else
                    {
                        _detailTwo.text = [NSString stringWithFormat:@"委托价 市价"];
                    }

                }
                    break;
                case 8:
                {
                    _cancelLab.text = @"部分成交";
                    _cancelLab.frame = CGRectMake(25, cellHeight/2+10, 60, 16);
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case MyOrderCellStyleSet:
        {
            CashPositionListModel * setModel = (CashPositionListModel*)sender;
            time = [setModel.createTime componentsSeparatedByString:@" "][1];
            _timeLab.text = [NSString stringWithFormat:@"委托时间\n%@",time];
            detailOne = [NSString stringWithFormat:@"委托量 %d手",[setModel.num intValue]] ;
            detailTwo = [NSString stringWithFormat:@"止盈价 %@", DecimalNumStr(setModel.upPrice)];
            detailThree = [NSString stringWithFormat:@"成交量 %d手",[setModel.contNum intValue]];;
            detailFour = [NSString stringWithFormat:@"止损价 %@",DecimalNumStr(setModel.downPrice)];;
            markOne = @"触发价 未触发";
            _detailOne.text = detailOne;
            _detailTwo.text = detailTwo;
            _detailThree.text = detailThree;
            _detailFour.text = detailFour;
            _markOneLab.textAlignment = NSTextAlignmentLeft;
            _markOneLab.textColor = _markTwoLab.textColor = Color_Gold;
            _markOneLab.backgroundColor = Color_black;
            CGFloat markOnelength = [Helper calculateTheHightOfText:markOne height:15 font:FontSize(fontText)];
            _timeLab.frame = CGRectMake(25, 5, ScreenWidth/4, cellHeight/2-5);
            _markOneLab.frame = CGRectMake(ScreenWidth*3/7, 12, markOnelength, 12);
            _markTwoLab.frame = CGRectMake(CGRectGetMaxX(_markOneLab.frame) +10, CGRectGetMinY(_markOneLab.frame), ScreenWidth/4, CGRectGetHeight(_markOneLab.frame));
            _detailOne.frame = CGRectMake(CGRectGetMinX(_markOneLab.frame), CGRectGetMaxY(_markOneLab.frame)+5, ScreenWidth/4, 20);
            _detailTwo.frame = CGRectMake(CGRectGetMaxX(_detailOne.frame)+5, CGRectGetMinY(_detailOne.frame), ScreenWidth/4, 20);
            _detailThree.frame = CGRectMake(CGRectGetMinX(_markOneLab.frame), CGRectGetMaxY(_detailOne.frame), ScreenWidth/4, 20);
            _detailFour.frame = CGRectMake(CGRectGetMaxX(_detailThree.frame)+5, CGRectGetMinY(_detailThree.frame), ScreenWidth/4, 20);
            _cancelLab.hidden = NO;
            _cancelBtn.hidden = YES;
            _cancelLab.textColor = K_color_lightGray;
            _cancelLab.textAlignment = NSTextAlignmentLeft;
            _cancelLab.layer.borderWidth = 0;
            _cancelLab.layer.masksToBounds = NO;
            _cancelLab.font = FontSize(fontText+2*ScreenWidth/375);
            _cancelLab.frame = CGRectMake(25, cellHeight/2+8, 70, 20);
            switch (setModel.orderStatus.intValue) {
                case -2:case -3:case -4:
                {
                    
                    _cancelLab.text = @"已撤单";
                }
                    break;
                case -1:
                {
                    _cancelLab.text = @"委托失败";
                }
                    break;
                case 2:
                {
                    _cancelLab.text = @"已撤单";
                }
                    break;
                case 6:
                {
                    if ([setModel.state isEqualToString:@"A"]) {
                        _timeLab.textColor = Color_Gold;
                        _cancelLab.hidden = _cancelBtn.hidden = NO;
                        _cancelLab.text = @"撤单";
                        _cancelLab.frame = CGRectMake(25, cellHeight/2+9, 45, 18);
                        _cancelLab.textColor = Color_Gold;
                        _cancelLab.textAlignment = NSTextAlignmentCenter;
                        _cancelLab.layer.borderColor = Color_Gold.CGColor;
                        _cancelLab.layer.borderWidth = 1;
                        _cancelLab.layer.cornerRadius = 2;
                        _cancelLab.layer.masksToBounds = YES;
                        _cancelLab.font = FontSize(fontText+1*ScreenWidth/375);
                    }else if([setModel.state isEqualToString:@"B"])
                    {
                        _cancelLab.text = @"废单";
                    }else if([setModel.state isEqualToString:@"C"])
                    {
                        _cancelLab.text = @"已触发";
                        markOne =[NSString stringWithFormat:@"触发价 %@",[setModel.conPrice floatValue]==0?@"0.00":[NSString stringWithFormat:@"%@",DecimalNumStr(setModel.conPrice)]];
                    }else
                    {
                        _cancelLab.text = @"已撤单";
                    }
                }
                    break;
                case 7:
                {
                    _cancelLab.text = @"已成交";
                    markOne =[NSString stringWithFormat:@"触发价 %@",[setModel.conPrice floatValue]==0?@"0.00":[NSString stringWithFormat:@"%@",DecimalNumStr(setModel.conPrice)]];
                }
                    break;
                default:
                    break;
            }
            _markOneLab.text = markOne;
        }
            break;
        case MyOrderCellStyleEnd:
        {
            float profit =0;
            time = @"2015年11月12日\n16:47:23";
            markOne = @"委托量 568手";
            markTwo = @"成交量 399手";
            detailOne = @"结算盈亏";
            detailTwo = @"+148,478.90 元";
            detailThree = @"可用资金";
            detailFour = @"68,345.23 元";
            _timeLab.frame = CGRectMake(25, 5, (ScreenWidth-40)/2, cellHeight/2-5);
            _markOneLab.frame = CGRectMake(25, 45, (ScreenWidth-40)/2, 15);
            _markTwoLab.frame = CGRectMake(25, CGRectGetMaxY(_markOneLab.frame), (ScreenWidth-20)/2, 15);
            _detailOne.frame = CGRectMake(ScreenWidth/2, 15, (ScreenWidth-40)/2, 15);
            _detailTwo.frame = CGRectMake(ScreenWidth/2, CGRectGetMaxY(_detailOne.frame), (ScreenWidth-40)/2, 15);
            _detailThree.frame = CGRectMake(ScreenWidth/2, CGRectGetMaxY(_detailTwo.frame), (ScreenWidth-40)/2, 15);
            _detailFour.frame = CGRectMake(ScreenWidth/2, CGRectGetMaxY(_detailThree.frame), (ScreenWidth-40)/2, 15);
            _detailOne.textAlignment = _detailTwo.textAlignment = _detailThree.textAlignment = _detailFour.textAlignment = NSTextAlignmentRight;
            _timeLab.text = time;
            _markOneLab.text = markOne;
            _markTwoLab.text = markTwo;
            _detailOne.text = detailOne;
            _detailThree.text = detailThree;
            UIColor * textColor;
            if (profit>=0)
            {
                textColor = K_color_red;
            }else{
                textColor = K_color_green;
            }
            NSMutableAttributedString * mulTwoStr = [Helper mutableFontAndColorText:detailTwo from:0 to:(int)detailTwo.length-1 font:14*ScreenWidth/375 from:0 to:(int)detailTwo.length-1 color:textColor];
            NSMutableAttributedString * mulFourStr = [Helper multiplicityText:detailFour from:0 to:(int)detailFour.length-1 font:13*ScreenWidth/375];
            _detailTwo.attributedText = mulTwoStr;
            _detailFour.attributedText = mulFourStr;

        }
           break;
        default:
            break;
   }
}
- (void)revokeOrder
{
    self.myOrderBlock();

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
