//
//  CandleView.m
//  CurveTest
//
//  Created by RGZ on 15/11/4.
//  Copyright © 2015年 cainiu. All rights reserved.
//

#import "CandleView.h"

@implementation CandleView
{
    float   openPointY;
    float   closePointY;
    float   maxPointY;
    float   minPointY;
    float   volumeY;
    float   endY;
    
    CALayer      *_candleLayer;
    CALayer      *_lineLayer;
    CALayer      *_volumeLayer;
    int         style;
    UIColor     *bgColor;
}



-(instancetype)initWithFrame:(CGRect)frame Style:(int)aStyle{
    self = [super initWithFrame:frame];
    if (self) {
        style                = aStyle;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(void)setOpenPo:(float)aOpenPo ClosePo:(float)aClosePo MaxPo:(float)aMaxPo MinPo:(float)aMinPo VolumePo:(float)aVolumePo EndPo:(float)aEndPo{
    openPointY  = aOpenPo;
    closePointY = aClosePo;
    maxPointY   = aMaxPo;
    minPointY   = aMinPo;
    volumeY     = aVolumePo;
    endY        = aEndPo;
    [self loadMainView];
    
}

-(void)changeOpenPo:(float)aOpenPo ClosePo:(float)aClosePo MaxPo:(float)aMaxPo MinPo:(float)aMinPo VolumePo:(float)aVolumePo EndPo:(float)aEndPo{
    @autoreleasepool {
        openPointY  = aOpenPo;
        closePointY = aClosePo;
        maxPointY   = aMaxPo;
        minPointY   = aMinPo;
        volumeY     = aVolumePo;
        endY        = aEndPo;
        
        BOOL isInflation;
        float candlePointY;
        float candleHeight;
        bgColor = nil;
        //红色
        if (openPointY >= closePointY) {
            isInflation = YES;
        }
        //绿色
        else{
            isInflation = NO;
        }
        self.openPo = openPointY;
        
        if (isInflation) {
            candlePointY = closePointY;
            candleHeight = openPointY - closePointY;
            bgColor = Color_Red;
        }
        else{
            candlePointY = openPointY;
            candleHeight = closePointY - openPointY;
            bgColor = Color_Green;
        }
        
        if (candleHeight <= 1) {
            candleHeight = 1;
        }
        if(isnan(volumeY)){
            volumeY = 0;
        }
        if(isnan(endY)){
            endY = 0;
        }
        _candleLayer.frame = CGRectMake(self.frame.size.width/8/2, candlePointY, self.frame.size.width/8*7, candleHeight);
        _candleLayer.backgroundColor = bgColor.CGColor;
        _candleLayer.borderColor = bgColor.CGColor;
        _lineLayer.frame     = CGRectMake(self.frame.size.width/2, maxPointY, 0.5, minPointY-maxPointY);
        _lineLayer.backgroundColor = bgColor.CGColor;
        _volumeLayer.frame = CGRectMake(self.frame.size.width/3/2, volumeY, self.frame.size.width/3*2, endY-volumeY);
        _volumeLayer.backgroundColor = bgColor.CGColor;
        self.voluPo = _volumeLayer.frame.origin.y;
        
        //样式
        [self style:style Color:bgColor];
    }
}

-(void)loadMainView{
    
    BOOL isInflation;
    float pointY;
    float height;
    bgColor = nil;
    //红色
    if (openPointY >= closePointY) {
        isInflation = YES;
    }
    //绿色
    else{
        isInflation = NO;
    }
    
    self.openPo = openPointY;
    
    if (isInflation) {
        pointY = closePointY;
        height = openPointY - closePointY;
        bgColor = Color_Red;
    }
    else{
        pointY = openPointY;
        height = closePointY - openPointY;
        bgColor = Color_Green;
    }
    
//    if (openPointY == closePointY) {
//        bgColor = Color_gray;
//    }
    
    if (height <= 1) {
        height = 1;
    }
    
    _candleLayer = [[CALayer alloc]init];
    _candleLayer.frame = CGRectMake(self.frame.size.width/8/2, pointY, self.frame.size.width/8*7, height);
    _candleLayer.backgroundColor = bgColor.CGColor;
//    _candleLayer.borderColor = bgColor.CGColor;
//    _candleLayer.borderWidth = 1;
    
    if (maxPointY + (minPointY-maxPointY) > self.frame.size.height) {
        minPointY = self.frame.size.height;
    }
    _lineLayer = [[CALayer alloc]init];
    _lineLayer.frame = CGRectMake(self.frame.size.width/2, maxPointY, 0.5, minPointY-maxPointY);
    _lineLayer.backgroundColor = bgColor.CGColor;
    [self.layer addSublayer:_lineLayer];
    [self.layer addSublayer:_candleLayer];
    
    endY -= 1;
    if(isnan(volumeY)){
        volumeY = 0;
    }
    if(isnan(endY)){
        endY = 0;
    }
    
    _volumeLayer = [[CALayer alloc]init];
    _volumeLayer.frame = CGRectMake(self.frame.size.width/3/2, volumeY, self.frame.size.width/3*2, endY-volumeY);
    _volumeLayer.backgroundColor = bgColor.CGColor;
//    _volumeLayer.borderWidth = 1;
    [self.layer addSublayer:_volumeLayer];
    self.voluPo = _volumeLayer.frame.origin.y;
    //样式
    [self style:style Color:bgColor];
}

-(void)setCandleTag:(NSInteger)candleTag{
    _candleTag = candleTag;
}

-(void)changeStyle:(int)aChangeStyle{
    style = aChangeStyle;
    [self style:style Color:bgColor];
}

-(void)style:(int)aStyle Color:(UIColor *)aBgColor{
    switch (aStyle) {
        case KLineStyleDefault:{
            [self style_default:aBgColor];
        }
            break;
        case KLineStyleRedVolume:{//红色空心（包括交易量）
            [self substyle_red:aBgColor];
            [self substyle_volume_red:aBgColor];
        }
            break;
        case KLineStyleGreenVolume:{//绿色空心（包括交易量）
            [self substyle_green:aBgColor];
            [self substyle_volume_green:aBgColor];
        }
            break;
        case KLineStyleRed:{//红色空心（不包括交易量）
            [self substyle_red:aBgColor];
            [self substyle_volume_default:aBgColor];
        }
            break;
        case KLineStyleALL:{//全部空心
            [self substyle_all:aBgColor];
            [self substyle_volume:aBgColor];
        }
            break;
        case KLineStyleGreen:{//绿色空心（不包括交易量）
            [self substyle_green:aBgColor];
            [self substyle_volume_default:aBgColor];
        }
            break;
        default:
            break;
    }
}

-(void)style_default:(UIColor *)aBgColor{
    _candleLayer.backgroundColor = aBgColor.CGColor;
    
    _volumeLayer.backgroundColor = aBgColor.CGColor;
}

-(void)substyle_all:(UIColor *)aBgColor{
//    _candleLayer.borderColor = aBgColor.CGColor;
    _candleLayer.backgroundColor = Color_black.CGColor;
}

//红色空心
-(void)substyle_red:(UIColor *)aBgColor{
    if ([aBgColor isEqual:Color_Red]) {
//        _candleLayer.borderColor = aBgColor.CGColor;
        _candleLayer.backgroundColor = Color_black.CGColor;
    }
    else{
        _candleLayer.backgroundColor = bgColor.CGColor;
    }
}

//绿色空心
-(void)substyle_green:(UIColor *)aBgColor{
    if ([aBgColor isEqual:Color_Green]) {
//        _candleLayer.borderColor = aBgColor.CGColor;
        _candleLayer.backgroundColor = Color_black.CGColor;
    }
    else{
        _candleLayer.backgroundColor = bgColor.CGColor;
    }
}


//交易量空心
-(void)substyle_volume:(UIColor *)aBgColor{
    _volumeLayer.backgroundColor = [UIColor clearColor].CGColor;
//    _volumeLayer.borderColor = aBgColor.CGColor;
}

-(void)substyle_volume_default:(UIColor *)aBgColor{
    _volumeLayer.backgroundColor = bgColor.CGColor;
}

//红色交易量空心
-(void)substyle_volume_red:(UIColor *)aBgColor{
    if ([aBgColor isEqual:Color_Red]) {
        _volumeLayer.backgroundColor = [UIColor clearColor].CGColor;
//        _volumeLayer.borderColor = aBgColor.CGColor;
    }
    else{
        _volumeLayer.backgroundColor = bgColor.CGColor;
    }
}

//绿色交易量空心
-(void)substyle_volume_green:(UIColor *)aBgColor{
    if ([aBgColor isEqual:Color_Green]) {
        _volumeLayer.backgroundColor = [UIColor clearColor].CGColor;
//        _volumeLayer.borderColor = aBgColor.CGColor;
    }
    else{
        _volumeLayer.backgroundColor = bgColor.CGColor;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
