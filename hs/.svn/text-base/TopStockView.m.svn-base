//
//  TopStockView.m
//  hs
//
//  Created by PXJ on 15/4/30.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import "TopStockView.h"

@implementation TopStockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.backView.image = [UIImage imageNamed:@"background_04"];
        [self addSubview:self.backView];
        
        self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backBtn.frame = CGRectMake(0, 20, 44, 44);
        [self.backBtn setImage:[UIImage imageNamed:@"return_1"] forState:UIControlStateNormal];
        [self addSubview:self.backBtn];
        
        self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.searchBtn.frame = CGRectMake(ScreenWidth-44, 20, 44, 44);
        [self.searchBtn setImage:[UIImage imageNamed:@"search_01"] forState:UIControlStateNormal];
        [self addSubview:self.searchBtn];

        self.stockNameLab = [[UILabel alloc]init];
        self.stockNameLab.textAlignment = NSTextAlignmentCenter;
        self.stockNameLab.font = [UIFont systemFontOfSize:14];
        self.stockNameLab.center = CGPointMake(ScreenWidth/2, 37);
        self.stockNameLab.bounds = CGRectMake(0, 0, 100, 20);
        self.stockNameLab.textColor = [UIColor blackColor];
        [self addSubview:self.stockNameLab];
        
        self.goStockPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.goStockPageBtn.frame=self.stockNameLab.frame;
        [self.goStockPageBtn addTarget:self action:@selector(goStockPage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.goStockPageBtn];
        
        _btnMessageImgV = [[UIImageView alloc] init];
        _btnMessageImgV.image = [UIImage imageNamed:@"button_11"];
        [self addSubview:_btnMessageImgV];
 
        self.stockNumLab = [[UILabel alloc]init];
        self.stockNumLab.textAlignment = NSTextAlignmentCenter;
        self.stockNumLab.font = [UIFont systemFontOfSize:10];
        self.stockNumLab.center = CGPointMake(self.bounds.size.width/2, 52);
        self.stockNumLab.bounds = CGRectMake(0, 0, 60, 10);
        self.stockNumLab.textColor = [UIColor grayColor];
        [self addSubview:self.stockNumLab];
        
        self.nePriceMarkLab = [[UILabel alloc]init];
        self.nePriceMarkLab.textAlignment = NSTextAlignmentCenter;
        self.nePriceMarkLab.center = CGPointMake(self.bounds.size.width/2, 82);
        self.nePriceMarkLab.bounds = CGRectMake(0, 0, 40, 10);
        self.nePriceMarkLab.textColor = [UIColor whiteColor];
        self.nePriceMarkLab.font = [UIFont systemFontOfSize:9];
        self.nePriceMarkLab.layer.cornerRadius = 2;
        self.nePriceMarkLab.layer.masksToBounds = YES;
        [self addSubview:self.nePriceMarkLab];
        
        self.nePriceLab = [[UILabel alloc]init];
        self.nePriceLab.textAlignment = NSTextAlignmentCenter;
        self.nePriceLab.center = CGPointMake(self.bounds.size.width/2, 110);
        self.nePriceLab.bounds = CGRectMake(0,0 , 200, 40);
        self.nePriceLab.font = [UIFont systemFontOfSize:35];
        self.nePriceLab.textColor = K_COLOR_CUSTEM(250, 67, 0, 1);
        [self addSubview:self.nePriceLab];
        
        _markll = [[UILabel alloc] initWithFrame:CGRectMake(self.nePriceLab.frame.origin.x-15, self.nePriceLab.frame.origin.y, 15, 15)];
        _markll.textColor = [UIColor whiteColor];
        _markll.font = [UIFont systemFontOfSize:25];
        [self addSubview:_markll];
        
        self.changeSaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.changeSaleBtn.frame=self.nePriceLab.frame;
        [self.changeSaleBtn addTarget:self action:@selector(goDetailPage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.changeSaleBtn];
        
        _btnMarkImageView = [[UIImageView alloc] init];
        _btnMarkImageView.image = [UIImage imageNamed:@"button_11"];
        [self addSubview:_btnMarkImageView];
        
        
        self.detailLab = [[UILabel alloc]init];
        self.detailLab.textAlignment = NSTextAlignmentCenter;
        self.detailLab.font = [UIFont systemFontOfSize:12];
        self.detailLab.textColor = K_COLOR_CUSTEM(250, 67, 0, 1);
        self.detailLab.frame = CGRectMake(0, self.nePriceLab.frame.origin.y +self.nePriceLab.frame.size.height, self.bounds.size.width, 10);
        self.detailLab.textColor = [UIColor whiteColor];
        [self addSubview:self.detailLab];
        
        self.updateTimeLab = [[UILabel alloc]init];
        self.updateTimeLab.textAlignment = NSTextAlignmentCenter;
        self.updateTimeLab.font = [UIFont systemFontOfSize:11];
        self.updateTimeLab.frame = CGRectMake(0, self.detailLab.frame.origin.y+self.detailLab.frame.size.height, self.bounds.size.width, 20);
        self.updateTimeLab.textColor =  K_COLOR_CUSTEM(110, 110, 110, 1);
        [self addSubview:self.updateTimeLab];
        
        
        
  
        
        self.lineLab = [[UILabel alloc]init];
        self.lineLab.textAlignment = NSTextAlignmentCenter;
        self.lineLab.backgroundColor = K_COLOR_CUSTEM(250, 67, 0, 1);
        self.lineLab.frame = CGRectMake(0, self.bounds.size.height-2, self.bounds.size.width/2, 2);
        [self addSubview:self.lineLab];
        
        self.trendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.trendBtn.frame = CGRectMake(0, self.bounds.size.height-32, self.bounds.size.width/2, 44);
        [self.trendBtn setTitle:@"分时图" forState:UIControlStateNormal];
        self.trendBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.trendBtn setTitleColor:K_COLOR_CUSTEM(153,153,153, 1) forState:UIControlStateNormal];
        [self addSubview:self.trendBtn];
        
        self.klineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.klineBtn.frame = CGRectMake(self.bounds.size.width/2, self.bounds.size.height-32, self.bounds.size.width/2, 44);
        [self.klineBtn setTitle:@"日K线" forState:UIControlStateNormal];
        self.klineBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.klineBtn setTitleColor:K_COLOR_CUSTEM(153,153,153, 1) forState:UIControlStateNormal];
        [self addSubview:self.klineBtn];
        
   }
    return self;
}

- (void)setTopStockViewValue:(id)sender
{




}
- (void)goStockPage
{
    
    self.goStockPageClick();

}
- (void)goDetailPage
{

    self.changeSaleBtnClick();

}
@end
