//
//  CouponsCell.m
//  hs
//
//  Created by PXJ on 15/11/16.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "CouponsCell.h"

@implementation CouponsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = K_color_backView;
        [self initUI];
        
        
    }

    return  self;
}

- (void)initUI
{
    _backView = [[UIView alloc] initWithFrame:CGRectMake(15, 1, ScreenWidth-30, 98)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backView];

    _couponNameLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, ScreenWidth/2, 20)];
    _couponNameLab.font = [UIFont fontWithName:@"CourierNewPSMT" size:18];
    [_backView addSubview:_couponNameLab];
    
    _ValidDateLab = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_couponNameLab.frame)+5, ScreenWidth/2, 15)];
    _ValidDateLab.font = [UIFont fontWithName:@"STHeitiTC-Light" size:11.0];
    [_backView addSubview:_ValidDateLab];
    

    _remarkLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 98-20, ScreenWidth/2, 15)];
    _remarkLab.textColor= K_color_grayBlack;
//    _remarkLab.text = @"抵扣交易手续费";
    _remarkLab.font = [UIFont systemFontOfSize:12];
    [_backView addSubview:_remarkLab];
    
    
    
    
    _couponStyleImgV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_backView.frame)-99, 0, 99, 98)];
    [_backView addSubview:_couponStyleImgV];
    
    _couponStateImgV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_couponStyleImgV.frame)-60, 98-60, 52, 52)];
    [_backView addSubview:_couponStateImgV];
    
    _couponValueLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_couponStyleImgV.frame) + 5, 0, _couponStyleImgV.frame.size.width, 98)];
//    _couponValueLab.backgroundColor = [UIColor blueColor];
    _couponValueLab.textColor = [UIColor whiteColor];
    _couponValueLab.textAlignment = NSTextAlignmentCenter;
    _couponValueLab.font = [UIFont systemFontOfSize:32];
    _couponValueLab.font = [UIFont fontWithName:@"Helvetica" size:32];
    [_backView addSubview:_couponValueLab];
    
//    UILabel * markLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_backView.frame)-88, 35, 15, 25)];
//    markLab.textColor = [UIColor whiteColor];
//    markLab.text = @"¥";
//    markLab.backgroundColor = [UIColor greenColor];
//    markLab.font = [UIFont systemFontOfSize:22];
//    [_backView addSubview:markLab];
//    markLab.backgroundColor  = [UIColor blackColor];
//    _couponValueLab.backgroundColor = [UIColor magentaColor];

    
}


- (void)setCellDetailWithModel:(id)sender
{
    NSInteger couponState = [sender[@"status"] intValue];
    _couponNameLab.text = [Helper judgeStr:sender[@"couponName"]];
    
    NSString *addtime = [Helper judgeStr:sender[@"endTime"]];
    NSArray *arry=[addtime componentsSeparatedByString:@" "];
    NSArray *arrayTime = [arry[1] componentsSeparatedByString:@":"];

    _ValidDateLab.text = [NSString stringWithFormat:@"有效期至 %@ %@:%@",arry[0],arrayTime[0],arrayTime[1]];
    NSString *textStr = [NSString stringWithFormat:@"￥%@",sender[@"amount"]];
    _remarkLab.text = [Helper judgeStr:sender[@"useTypeName"]];//multiplicityText
     NSMutableAttributedString * atrWarnText = [Helper mutableFontAndColorText:textStr from:0 to:1 font:24.0 from:0 to:1 color:[UIColor whiteColor]];
    _couponValueLab.attributedText = atrWarnText;
    _couponValueLab.adjustsFontSizeToFitWidth = YES;
    switch (couponState) {
        case 4:
        {
            _couponNameLab.textColor = _ValidDateLab.textColor = K_color_red;
            _couponStateImgV.image = [UIImage imageNamed:@""];
            _couponStyleImgV.image = [UIImage imageNamed:@"coupon_2"];
        
        }
            break;
        case 7:
        {
            //已过期
            _couponNameLab.textColor = _ValidDateLab.textColor = K_color_gray;
            _couponStateImgV.image = [UIImage imageNamed:@"coupon_3"];
            _couponStyleImgV.image = [UIImage imageNamed:@"coupon_1"];
            
        }
            break;
        case 5:
        {
            //已使用
            _couponNameLab.textColor = _ValidDateLab.textColor = K_color_gray;
            _couponStateImgV.image = [UIImage imageNamed:@"coupon_4"];
            _couponStyleImgV.image = [UIImage imageNamed:@"coupon_1"];
            
        }
            break;
            
        default:
            break;
    }
    
    

}


@end
