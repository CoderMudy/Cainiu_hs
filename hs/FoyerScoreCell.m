//
//  FoyerScoreCell.m
//  hs
//
//  Created by PXJ on 16/1/15.
//  Copyright © 2016年 luckin. All rights reserved.
//
#define ScoreCellHeight 65
#define ProductWidth (ScreenWidth-60)/2
#define nameFont 16
#define detailFont 12
#define arrowLength ScreenWidth*6/375
#define control_tag 1111
#define control_D_tag 1112

#import "FoyerScoreCell.h"

@implementation FoyerScoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    _productName   = [[UILabel alloc] initWithFrame:CGRectMake(25, 20, ProductWidth, 15)];
    _productName_D = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2+5, 20, ProductWidth, 15)];
    _productPrice  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_productName.frame), CGRectGetMaxY(_productName.frame), ProductWidth, 15)];
    _productPrice_D  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_productName_D.frame), CGRectGetMaxY(_productName_D.frame), ProductWidth, 15)];
    _spreateLine   = [[UIView alloc] initWithFrame:CGRectMake(25, ScoreCellHeight-1,ProductWidth, 0.5)];
    _spreateLine_D = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2+5, ScoreCellHeight-1,ProductWidth, 0.5)];
    _positionImg   = [[UIImageView alloc] init];
    _positionImg_D = [[UIImageView alloc] init];
    UIControl * control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2, ScoreCellHeight)];
    control.tag = control_tag;
    [control addTarget:self action:@selector(controlClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
    
    UIControl * control_D = [[UIControl alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, ScoreCellHeight)];
    control_D.tag = control_D_tag;
    [control_D addTarget:self action:@selector(controlClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control_D];

    
    _arrowImg   = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-arrowLength-5,ScoreCellHeight/2-arrowLength*9/10 , arrowLength, arrowLength*9/5)];
    _arrowImg_D = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-25-arrowLength-5,ScoreCellHeight/2-arrowLength*9/10 , arrowLength, arrowLength*9/5)];

    
    [self addSubview:_productName];
    [self addSubview:_productName_D];
    [self addSubview:_productPrice];
    [self addSubview:_productPrice_D];
    [self addSubview:_spreateLine];
    [self addSubview:_spreateLine_D];
    [self addSubview:_positionImg];
    [self addSubview:_positionImg_D];
    [self addSubview:_arrowImg];
    [self addSubview:_arrowImg_D];

    _productName.font    = FontSize(nameFont);
    _productName_D.font  = FontSize(nameFont);
    _productPrice.font   = FontSize(detailFont);
    _productPrice_D.font = FontSize(detailFont);
    _spreateLine.backgroundColor   = K_color_line;
    _spreateLine_D.backgroundColor = K_color_line;
    _spreateLine.hidden   = YES;
    _spreateLine_D.hidden = YES;
    _positionImg.bounds   = CGRectMake(0, 0, 32,14);
    _positionImg_D.bounds = CGRectMake(0, 0, 32,14);
    _positionImg.image    = [UIImage imageNamed:@"foyer_6"];
    _positionImg_D.image  = [UIImage imageNamed:@"foyer_6"];
    _arrowImg.image        = [UIImage imageNamed:@"arrow"];
    _arrowImg_D.image      = [UIImage imageNamed:@"arrow"];
}
- (void)controlClick:(UIControl*)control
{
    self.controlBlock(control);
}
- (void)setCellWithProductArray:(NSArray*)ProductArray;
{
    
    for (int i=0; i<ProductArray.count; i++) {
        
        switch (i) {
            case 0:
            {
                FoyerProductModel * productModel = ProductArray[0];
                _productName.text  = productModel.commodityName;
                CGFloat nameLength = [Helper calculateTheHightOfText:productModel.commodityName height:15 font:[UIFont systemFontOfSize:15]];
                _positionImg.center= CGPointMake(CGRectGetMinX(_productName.frame)+nameLength+10+15,_productName.center.y-2);
                [self requestCacheData:productModel success:^(NSString *priceText, UIColor *color)
                 {
                    _productPrice.text      = priceText;
                    _productPrice.textColor = color;
                }];
            }
                break;
            case 1:
            {
                FoyerProductModel * productModel = ProductArray[1];
                _productName_D.text = productModel.commodityName;
                CGFloat nameLength          = [Helper calculateTheHightOfText:productModel.commodityName height:15 font:[UIFont systemFontOfSize:15]];
                _positionImg_D.center              = CGPointMake(CGRectGetMinX(_productName_D.frame)+nameLength+10+15,_productName_D.center.y-2);
                [self requestCacheData:productModel success:^(NSString *priceText, UIColor *color) {
                    _productPrice_D.text = priceText;
                    _productPrice_D.textColor = color;
                }];
            }
                break;
            default:
                break;
        }
    }
    
}
-(void)requestCacheData:(FoyerProductModel*)model success:(void(^)(NSString * priceText,UIColor * color))successBlock
{
    __block int market = [model.marketStatus intValue];
    __block NSString * lastPrice = @"--";
    __block NSString * percentage = @"-%";
    
    [RequestDataModel requestFoyerCacheData:model.instrumentCode successBlock:^(BOOL success, NSDictionary *dictionary) {
        UIColor * showColor = K_color_grayBlack;
        if (success&&[dictionary class]!=[NSNull class]&& dictionary)
        {
            if (dictionary[@"percentage"])
            {
                percentage = [NSString stringWithFormat:@"%@",dictionary[@"percentage"] ];
            }
            if (dictionary[@"lastPrice"])
            {
                lastPrice  = [NSString stringWithFormat:@"%.2f",[dictionary[@"lastPrice"] floatValue]];
            }
            if (market==1)
            {
                if ([percentage rangeOfString:@"-"].location!=NSNotFound)
                {
                    showColor = K_color_green;
                }else
                {
                    showColor = K_color_red;
                }
            }else
            {
                showColor = K_color_grayBlack;
            }
        }
        NSString * priceText = [NSString stringWithFormat:@"%@ %@",lastPrice,percentage];
        successBlock(priceText,showColor);
    }];
}

- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
