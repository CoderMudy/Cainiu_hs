//
//  StockTypeHeaderView.m
//  hs
//
//  Created by PXJ on 15/5/18.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "StockTypeHeaderView.h"

@implementation StockTypeHeaderView
{
    UILabel * _priceLab;
    UILabel * _upDownLab;
    UILabel * _riseLab;
    UILabel * _fallLab;
    UILabel * _flatLab;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView * backimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
        backimageView.image = [UIImage imageNamed:@"background_01"];
        
        [self addSubview:backimageView];
        
        
        
        _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 25)];
        _priceLab.textAlignment = NSTextAlignmentCenter;
        _priceLab.font = [UIFont systemFontOfSize:23];
        [self addSubview: _priceLab];
        
        _upDownLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _priceLab.frame.origin.y + _priceLab.frame.size.height+5, ScreenWidth, 15)];
        _upDownLab.textAlignment = NSTextAlignmentCenter;
        _upDownLab.font = [UIFont systemFontOfSize:15];
        [self addSubview:_upDownLab];
        
        _riseLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _upDownLab.frame.origin.y + _upDownLab.frame.size.height+5, ScreenWidth/2, 15)];
        _riseLab.textAlignment = NSTextAlignmentCenter;
        _riseLab.font = [UIFont systemFontOfSize:15];
        _riseLab.textColor = K_COLOR_CUSTEM(250, 67, 0, 1);
        [self addSubview:_riseLab];
        
        _fallLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, _upDownLab.frame.origin.y + _upDownLab.frame.size.height+5, ScreenWidth/2, 15)];
        _fallLab.textAlignment = NSTextAlignmentCenter;
        _fallLab.font = [UIFont systemFontOfSize:15];
        _fallLab.textColor = K_COLOR_CUSTEM(8, 186, 66, 1);
        [self addSubview:_fallLab];
        
        
    }
    return self;
}

- (void)setStockTypeViewValue:(NSDictionary *)dictionary
{
    
    
    float price = dictionary[@"newPrice"]==nil?0:[dictionary[@"newPrice"] floatValue];

    if (price>0) {
        _priceLab.textColor = _upDownLab.textColor = K_COLOR_CUSTEM(250, 67, 0, 1);
    }else
    {
        _priceLab.textColor = _upDownLab.textColor = K_COLOR_CUSTEM(8, 186, 66, 1);

    
    }
    _priceLab.text =[NSString stringWithFormat:@"%.2f",price*1000];
    
    float nRate = dictionary[@"nRATE"]==nil?0:[dictionary[@"nRATE"] floatValue];
    
    _upDownLab.text = [NSString stringWithFormat:@"%.2f%%",nRate*100];
   
    
    int riseNum = dictionary[@"riseCount"]== nil?0: [dictionary[@"riseCount"] intValue];
    _riseLab.text = [NSString stringWithFormat:@"上涨 %d",riseNum];
    
    int fallNum = dictionary[@"fallCount"]== nil?0: [dictionary[@"fallCount"] intValue];
    _fallLab.text = [NSString stringWithFormat:@"下跌 %d",fallNum];
    
    
}

@end
