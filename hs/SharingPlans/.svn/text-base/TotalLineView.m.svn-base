//
//  TotalLineView.m
//  hs
//
//  Created by RGZ on 15/8/19.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "TotalLineView.h"

//线间距
//#define LineDistanceWidth 1.5

//线显示的部分占屏幕的百分比，超过后开始推线
#define LineWidthPercent 1

@implementation TotalLineView
{
    UIColor *_lineColor;
    
    //右侧label
    float    priceUpper;
    float    priceMiddle;
    float    priceLower;
    
    UIImageView     *_imageView;
    
    float    lineDistanceWidth;
    
    int     type;
    
    
    BOOL    animationEnd;
}

-(instancetype)initWithFrame:(CGRect)frame LineArray:(NSMutableArray *)aLineArray NumCount:(int)aNumCount DayOrNight:(BOOL)aDayorNight{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.scrollEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(-10, -10, 3, 3)];
        _imageView.image = [UIImage imageNamed:@"dian_table"];
        [self addSubview:_imageView];
        
        //点数
        lineDistanceWidth = frame.size.width*LineWidthPercent/aNumCount;
        
        if(aLineArray == nil){
            self.pointArray = [NSMutableArray arrayWithCapacity:0];
        }
        else{
            self.pointArray = [NSMutableArray arrayWithArray:aLineArray];
        }
        _lineColor = [UIColor colorWithRed:234/255.0 green:194/255.0 blue:129/255.0 alpha:1];
        
        self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        self.userInteractionEnabled = YES;
        
    }
    
    return self;
    
}

-(void)setNumCount:(int)aNumCount{
    
    lineDistanceWidth = self.frame.size.width*LineWidthPercent/aNumCount;
}

//小红点动画
-(void)animationStart{
    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _imageView.bounds = CGRectMake(0, 0, 6, 6);
    } completion:^(BOOL finished) {
        [self animationEnd];
    }];
}

-(void)animationEnd{
    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _imageView.bounds = CGRectMake(0, 0, 5, 5);
    } completion:^(BOOL finished) {
        if (animationEnd == NO) {
            [self animationStart];
        }
    }];
}

-(void)setUpperAndLowerLimitsWithUpper:(float)aUpper Middle:(float)aMiddle Lower:(float)aLower{
    
    priceUpper = aUpper;
    
    priceMiddle = aMiddle;
    priceLower = aLower;
    
    [self setNeedsDisplay];
}

-(void)addLine:(NSMutableArray *)aPointStrArray{
    
    self.pointArray = [NSMutableArray arrayWithArray:aPointStrArray];
    
    [self.layer setNeedsDisplay];
    
    [self moveContentOff];
    
}

-(void)moveContentOff{
    
    for (int i = 0; i<self.pointArray.count; i++) {
        
        if (i == self.pointArray.count-1) {
            CGPoint point = CGPointFromString(self.pointArray[i]);
            
            _imageView.center = point;
        }
    }
}

-(void)setLineColor:(UIColor *)aColor{
    _lineColor = aColor;
}

- (void)drawRect:(CGRect)rect
{
    
    UIColor *color = _lineColor;
    [color set]; //设置线条颜色
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 1;
    
    aPath.lineCapStyle = kCGLineCapRound;
    aPath.lineJoinStyle = kCGLineCapRound;
    
    if (self.pointArray.count>0) {
        _imageView.hidden = NO;
        CGPoint beginPoint = CGPointFromString(self.pointArray[0]);
        [aPath moveToPoint:beginPoint];
        
        for (int i = 0; i<self.pointArray.count; i++) {
            if (i!=0) {
                CGPoint point = CGPointFromString(self.pointArray[i]);
                [aPath addLineToPoint:point];
            }
            
            if (i == self.pointArray.count-1) {
                CGPoint point = CGPointFromString(self.pointArray[i]);
                _imageView.center = point;
            }
        }
        
        [aPath stroke];
    }
    else{
        _imageView.hidden = YES;
        _imageView.center =  CGPointMake(-10, -10);
        [aPath stroke];
    }
    
    
    
}



@end
