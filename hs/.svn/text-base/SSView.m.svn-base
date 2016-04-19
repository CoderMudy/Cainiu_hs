//
//  SSView.m
//  hs
//
//  Created by PXJ on 15/5/16.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "SSView.h"

@implementation SSView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width-20, 15)];
        
        _nameLab.font = [UIFont systemFontOfSize:12];
        _nameLab.textColor = [UIColor whiteColor];
        [self addSubview:_nameLab];
        
        _numLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 20,  self.frame.size.width-20, 15)];
        _numLab.font = [UIFont systemFontOfSize:10];
        _numLab.textColor = [UIColor whiteColor];
        [self addSubview:_numLab];
        
        _lineLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 38, self.frame.size.width-20, 2)];
        [self addSubview:_lineLab];
        
        _goDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _goDetailBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [_goDetailBtn addTarget:self action:@selector(goSSDetailView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_goDetailBtn];
    }

    return self;
}

- (void)setViewValue:(RealTimeStockModel *)realtime
{
    _nameLab.text = realtime.name;
    
    if (realtime.priceChange>0) {
        _lineLab.backgroundColor = K_COLOR_CUSTEM(242, 40, 57, 1);
        _numLab.text = [NSString stringWithFormat:@"%.2f +%.2f +%.2f%%",realtime.price/1.0,realtime.priceChange,realtime.priceChangePerCent*100];
    }else if(realtime.priceChange<0){
    
        _lineLab.backgroundColor = K_COLOR_CUSTEM(7, 186, 67, 1);
        _numLab.text = [NSString stringWithFormat:@"%.2f %.2f %.2f%%",realtime.price/1.0,realtime.priceChange,realtime.priceChangePerCent*100];
    }else{
    
        _lineLab.backgroundColor = K_COLOR_CUSTEM(110, 110, 110, 1);
        _numLab.text = [NSString stringWithFormat:@"%.2f %.2f %.2f%%",realtime.price/1.0,realtime.priceChange,realtime.priceChangePerCent*100];
    }

}

- (id)initSSViewWithFrame:(CGRect)rect
{
    self = [super init];
    if (self) {
        self.frame = rect;
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-20, 20)];
        
        _nameLab.font = [UIFont systemFontOfSize:12];
        _nameLab.textColor = [UIColor whiteColor];
        [self addSubview:_nameLab];
        
        _numLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20,  self.frame.size.width-20, 20)];
        _numLab.font = [UIFont systemFontOfSize:20];
        _numLab.textColor = [UIColor whiteColor];
        [self addSubview:_numLab];
        
        _changeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width-20, 15)];
        _changeLab.font = [UIFont systemFontOfSize:12];
        _changeLab.textColor = [UIColor whiteColor];
        [self addSubview:_changeLab];
        
        _lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 57, self.frame.size.width-20, 2)];
        [self addSubview:_lineLab];
        
        _goDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _goDetailBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [_goDetailBtn addTarget:self action:@selector(goSSDetailView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_goDetailBtn];
        
    }
    return self;
}
- (void)setSSViewValue:(RealTimeStockModel *)realtime
{
    _nameLab.text = realtime.name;
    _numLab.text =[NSString stringWithFormat:@"%.2f",realtime.price];

    if (realtime.priceChange>0) {
        _lineLab.backgroundColor = K_COLOR_CUSTEM(242, 40, 57, 1);
        _changeLab.text = [NSString stringWithFormat:@"+%.2f +%.2f%%",realtime.priceChange,realtime.priceChangePerCent*100];
    }else if(realtime.priceChange<0){
        
        _lineLab.backgroundColor = K_COLOR_CUSTEM(7, 186, 67, 1);
        _changeLab.text = [NSString stringWithFormat:@"%.2f %.2f%%",realtime.priceChange,realtime.priceChangePerCent*100];
    }else{
        _lineLab.backgroundColor = K_COLOR_CUSTEM(110, 110, 110, 1);

        _changeLab.text = [NSString stringWithFormat:@"%.2f %.2f%%",realtime.priceChange,realtime.priceChangePerCent*100];

    }
    
}
- (void)goSSDetailView:(UIButton *)button
{


    self.goDetail(button);





}
@end
