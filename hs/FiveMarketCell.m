//
//  FiveMarketCell.m
//  hs
//
//  Created by Xse on 15/11/30.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "FiveMarketCell.h"
#import "FiveMarketModel.h"

@implementation FiveMarketCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _titleLab = [[UILabel alloc]init];
//        _titleLab.backgroundColor = [UIColor redColor];
        _titleLab.textColor = [UIColor colorWithRed:118/255.0 green:123/255.0 blue:117/255.0 alpha:1];
//        _titleLab.text = @"卖价5";
        _titleLab.frame = CGRectMake(28*ScreenWidth/320, 3, 45*ScreenWidth/320, 21);
        _titleLab.font = [UIFont systemFontOfSize:11.0];
        [self.contentView addSubview:_titleLab];
        
        _priceLab = [[UILabel alloc]init];
//        _priceLab.backgroundColor = [UIColor greenColor];
        _priceLab.textColor = [UIColor colorWithRed:238/255.0 green:43/255.0 blue:33/255.0 alpha:1];
        _priceLab.frame = CGRectMake(CGRectGetMaxX(_titleLab.frame) + 25*ScreenWidth/320, CGRectGetMinY(_titleLab.frame), 50*ScreenWidth/320, 21);
        _priceLab.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:_priceLab];
        
        _numLab = [[UILabel alloc]init];
//        _numLab.backgroundColor = [UIColor cyanColor];
        _numLab.textAlignment = NSTextAlignmentRight;
        _numLab.textColor = [UIColor colorWithRed:118/255.0 green:123/255.0 blue:117/255.0 alpha:1];
//        _numLab.text = @"32328";
        _numLab.frame = CGRectMake(CGRectGetMaxX(_priceLab.frame) + 10*ScreenWidth/320, CGRectGetMinY(_titleLab.frame), ScreenWidth - 35*ScreenWidth/320*2 - CGRectGetMaxX(_priceLab.frame) - 35*ScreenWidth/320, 21);
        _numLab.font = [UIFont systemFontOfSize:11.0];
        [self.contentView addSubview:_numLab];
        
    }
    
    return self;
}

- (void)fillSaleWithData:(FiveMarketModel *)saleModel buyDic:(FiveMarketModel *)buyModel
{
    
    if (saleModel != nil)
    {
        _model = saleModel;
        _titleLab.text = saleModel.saleNum;
        _priceLab.text = [NSString stringWithFormat:@"%.2f",[saleModel.salePrice floatValue]];
        
        if ([saleModel.saleVolume intValue] >= 100000)
        {
            _numLab.text = [NSString stringWithFormat:@"%d万",[saleModel.saleVolume intValue]/100000];
        }else
        {
            _numLab.text = [NSString stringWithFormat:@"%d",[saleModel.saleVolume intValue]];
        }
    }
    
    if (buyModel != nil)
    {
        _model = buyModel;
        _titleLab.text = buyModel.buyNum;
        _priceLab.text = [NSString stringWithFormat:@"%.2f",[buyModel.buyPrice floatValue]];

        if ([saleModel.buyVolume intValue] >= 100000)
        {
            _numLab.text = [NSString stringWithFormat:@"%d万",[buyModel.buyVolume intValue]/100000];
        }else
        {
            _numLab.text = [NSString stringWithFormat:@"%d",[buyModel.buyVolume intValue]];
        }

    }
}

//- (void)fillSaleWithData:(NSMutableDictionary *)dataDic buyDic:(NSMutableDictionary *)buydic
//{
//    if (dataDic != nil)
//    {
//        _titleLab.text = dataDic[@"saleNum"];
//        _priceLab.text = dataDic[@"salePrice"];
//        
//        if ([dataDic[@"saleVolume"] intValue] >= 100000)
//        {
//            _numLab.text = [NSString stringWithFormat:@"%d",[dataDic[@"saleVolume"] intValue]/10000];
//        }else
//        {
//            _numLab.text = dataDic[@"saleVolume"];
//        }
//
//    }
//    
//    if (buydic != nil)
//    {
//        _titleLab.text = buydic[@"buyNum"];
//        _priceLab.text = buydic[@"buyPrice"];
//        
//        if ([buydic[@"buyVolume"] intValue]>=100000) {
//            NSString *strNum =[NSString stringWithFormat:@"%d",[buydic[@"buyVolume"] intValue]/10000];
//            _numLab.text = strNum;
//            
//        }else
//        {
//            _numLab.text = buydic[@"buyVolume"];
//        }
//
//    }
//    
//}

//- (void)fillBuyWithData:(NSMutableDictionary *)buyDic
//{
//    _titleLab.text = buyDic[@"buyNum"];
//    _priceLab.text = buyDic[@"buyPrice"];
//    
//    if ([buyDic[@"buyVolume"] intValue]>=100000) {
//        NSString *strNum =[NSString stringWithFormat:@"%d",[buyDic[@"buyVolume"] intValue]/10000];
//        _numLab.text = strNum;
//
//    }else
//    {
//        _numLab.text = buyDic[@"buyVolume"];
//    }
//    
//}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
