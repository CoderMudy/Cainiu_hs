//
//  FoyrerTableViewCell.m
//  hs
//
//  Created by PXJ on 15/9/11.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "FoyerTableViewCell.h"
#import "FoyerProductModel.h"
#import "UIImageView+WebCache.h"
#import "FoyerProductModel.h"
#define nameFont 15
#define detailFont 11
#define cellHeight 65
#define posiImgLength 32

@interface FoyerTableViewCell ()


@end
@implementation FoyerTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        [self initUI];
    }
    
    return self;
}
- (void)initUI
{
    
    
    _productNameL               = [[UILabel alloc] initWithFrame:CGRectMake(20,14, cellHeight, 19)];
    _productNameL.textColor     = [UIColor blackColor];
    _productNameL.textAlignment = NSTextAlignmentLeft;
    _productNameL.font          = FontSize(nameFont);
    [self addSubview:_productNameL];
    
    _hotImg                     = [[UIImageView alloc] init];
    _hotImg.bounds              = CGRectMake(0, 0, 33, 14);
    [self addSubview:_hotImg];
    
    _showLab = [[UILabel alloc] init];
    
    _showLab.center = CGPointMake(ScreenWidth-35-20, _productNameL.center.y);
    _showLab.bounds = CGRectMake(0, 0, 70, 22);
    _showLab.backgroundColor = K_color_backView;
    _showLab.font = FontSize(13);
    _showLab.text = @"立即操盘";
    _showLab.textAlignment = NSTextAlignmentCenter;
    _showLab.layer.cornerRadius = 3;
    _showLab.layer.masksToBounds = YES;
    _showLab.layer.borderWidth = 0.5;
    _showLab.layer.borderColor = K_color_line.CGColor;
    [self addSubview:_showLab];
   
    _priceLab                   = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_productNameL.frame), ScreenWidth/2, cellHeight/3)];
    _priceLab.textAlignment = NSTextAlignmentLeft;
    _priceLab.font              = FontSize(13);
    _priceLab.text              = @"--";
    _priceLab.textColor         = K_color_grayBlack;
    [self addSubview:_priceLab];
    _productAdL                 = [[UILabel alloc] init];
    _productAdL.center = CGPointMake(ScreenWidth-ScreenWidth/4-20, _priceLab.center.y);
    _productAdL.bounds = CGRectMake(0, 0, ScreenWidth-ScreenWidth/2, 20);
    _productAdL.textColor       = K_color_grayBlack;
    _productAdL.textAlignment   = NSTextAlignmentRight;
    _productAdL.font            = FontSize(detailFont);
    [self addSubview:_productAdL];
    
    

    _lineView                   = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight-1, ScreenWidth, 0.5)];
    _lineView.backgroundColor   = K_color_line;
    [self addSubview:_lineView];
}

- (void)setFoyertableViewCellWithModel:(id)model
{
    
    float iconbackLength = cellHeight*5/9;
    FoyerProductModel * productModel = (FoyerProductModel*)model;
    if ([productModel.vendibility intValue]==1) {
        _productNameL.textColor         =[UIColor blackColor];
        _productAdL.textColor           =K_color_grayBlack;

        
    }else{
        _productNameL.textColor         =K_COLOR_CUSTEM(186, 186, 186, 1);
        _productAdL.textColor           =K_COLOR_CUSTEM(186, 186, 186, 1);
        
    }
    _productNameL.text                  = productModel.commodityName;
    _productAdL.text                    = productModel.advertisement;
    CGFloat nameLength          = [Helper calculateTheHightOfText:productModel.commodityName height:iconbackLength*4/11 font:FontSize(nameFont)];
    _hotImg.center              = CGPointMake(20+iconbackLength+10+nameLength+5+posiImgLength/2, _productNameL.center.y-2);
    _hotImg.hidden = YES;
    if (self.isPositionNum) {
        _hotImg.hidden = NO;
        _hotImg.image = [UIImage imageNamed:@"foyer_6"];
    }
    
    [self requestCacheData:productModel];
    [NSThread detachNewThreadSelector:@selector(requestCacheData:) toTarget:self withObject:productModel];
    
}
#pragma mark 请求单个类的行情价及涨跌幅
-(void)requestCacheData:(FoyerProductModel*)model
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
        [self performSelectorOnMainThread:@selector(loadText:) withObject:@{@"percentage":percentage,@"lastPrice":lastPrice,@"showColor":showColor} waitUntilDone:NO];
    }];
}
- (void)loadText:(NSDictionary*)dic
{
    _priceLab.text = [NSString stringWithFormat:@"%@ %@",dic[@"lastPrice"],dic[@"percentage"]];

    _priceLab.textColor = (UIColor *)dic[@"showColor"];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
