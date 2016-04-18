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

    float iconbackLength = cellHeight*5/9;
    _iconImgV                   = [[UIImageView alloc] init];
    _iconImgV.center =  CGPointMake(20+iconbackLength/2, cellHeight/2);
    _iconImgV.bounds = CGRectMake(0, 0, iconbackLength, iconbackLength);
    _iconImgV.layer.cornerRadius= 5;
    _iconImgV.layer.masksToBounds= YES;
    [self addSubview:_iconImgV];
    
    _productNameL               = [[UILabel alloc] initWithFrame:CGRectMake(20+iconbackLength+10,15, iconbackLength*2, 19)];
    _productNameL.textColor     = [UIColor blackColor];
    _productNameL.textAlignment = NSTextAlignmentLeft;
    _productNameL.font          = FontSize(nameFont);
    [self addSubview:_productNameL];
    
    _hotImg                     = [[UIImageView alloc] init];
    _hotImg.bounds              = CGRectMake(0, 0, 33, 14);
    [self addSubview:_hotImg];
    
    _productAdL                 = [[UILabel alloc] initWithFrame:CGRectMake(_iconImgV.frame.origin.x+iconbackLength+10, CGRectGetMaxY(_productNameL.frame), ScreenWidth/2, 15)];
    _productAdL.textColor       = [UIColor blackColor];
    _productAdL.textAlignment   = NSTextAlignmentLeft;
    _productAdL.font            = FontSize(detailFont);
    [self addSubview:_productAdL];

    float markLength            = ScreenWidth*6/375;
    _markImg                    = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-20-markLength,cellHeight/2-markLength*9/10 , markLength, markLength*9/5)];
    _markImg.image              = [UIImage imageNamed:@"arrow"];
    [self addSubview:_markImg];
    
    
    _priceLab                   = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_markImg.frame)-cellHeight -10, cellHeight/4, cellHeight, cellHeight/4)];
    _priceLab.textAlignment = NSTextAlignmentRight;
    _priceLab.font              = FontSize(12);
    _priceLab.text              = @"--";
    _priceLab.textColor         = K_color_grayBlack;
    [self addSubview:_priceLab];
    
    _percentage                   = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_markImg.frame)-cellHeight-10, cellHeight/2, cellHeight, cellHeight/4)];
    _percentage.textAlignment = NSTextAlignmentRight;
    _percentage.font              = FontSize(12);
    _percentage.text              = @"-%";
    _percentage.textColor         = K_color_grayBlack;
    [self addSubview:_percentage];
    
    

    _lineView                   = [[UIView alloc] initWithFrame:CGRectMake(20, cellHeight-1, ScreenWidth-40, 0.5)];
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
        [_iconImgV sd_setImageWithURL:[NSURL URLWithString:productModel.imgs]];

        
    }else{
        _productNameL.textColor         =K_COLOR_CUSTEM(186, 186, 186, 1);
        _productAdL.textColor           =K_COLOR_CUSTEM(186, 186, 186, 1);
        [_iconImgV sd_setImageWithURL:[NSURL URLWithString:productModel.imgs] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            _iconImgV.image             = [self getGrayImage:image];
            
        }];
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
//                _percentage.text = percentage;
            }
            if (dictionary[@"lastPrice"])
            {
                lastPrice  = [NSString stringWithFormat:@"%.2f",[dictionary[@"lastPrice"] floatValue]];
//                _priceLab.text = lastPrice;
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
//        _percentage.textColor = _priceLab.textColor  = showColor;
    }];
}
- (void)loadText:(NSDictionary*)dic
{
    _percentage.text = [NSString stringWithFormat:@"%@",dic[@"percentage"]];
    _priceLab.text = [NSString stringWithFormat:@"%@",dic[@"lastPrice"]];
    _percentage.textColor = _priceLab.textColor = (UIColor *)dic[@"showColor"];
}
-(UIImage*)getGrayImage:(UIImage*)sourceImage
{
    
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;   
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
