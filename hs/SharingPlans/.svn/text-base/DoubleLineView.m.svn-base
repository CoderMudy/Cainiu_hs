//
//  DoubleLineView.m
//  hs
//
//  Created by RGZ on 15/9/22.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "DoubleLineView.h"

//线间距
#define LineDistanceWidth 1.5

//线显示的部分占屏幕的百分比，超过后开始推线
#define LineWidthPercent 0.75

//金色
#define Color_Gold [UIColor colorWithRed:234/255.0 green:194/255.0 blue:129/255.0 alpha:1]

//黑色
#define Color_black [UIColor colorWithRed:3/255.0 green:0/255.0 blue:20/255.0 alpha:1]

@implementation DoubleLineView
{
    UIColor *_lineColor;
    
    
    
    float    priceUpper;
    float    priceMiddle;
    float    priceLower;
    
    UIImageView     *_imageUpperView;
    UIImageView     *_imageLowerView;
}

-(instancetype)initWithFrame:(CGRect)frame UpperLineArray:(NSMutableArray *)aUpperArray LowerLineArray:(NSMutableArray *)aLowerArray{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _imageUpperView = [[UIImageView alloc]initWithFrame:CGRectMake(-10, 0, 5, 5)];
        _imageUpperView.layer.cornerRadius = 5/2;
        _imageUpperView.clipsToBounds = YES;
        _imageUpperView.backgroundColor = Color_Gold;
        [self addSubview:_imageUpperView];
        
        _imageLowerView = [[UIImageView alloc]initWithFrame:CGRectMake(-10, 0, 5, 5)];
        _imageLowerView.layer.cornerRadius = 5/2;
        _imageLowerView.clipsToBounds = YES;
        _imageLowerView.backgroundColor = Color_Gold;
        [self addSubview:_imageLowerView];
        
        if(aUpperArray == nil){
            self.upperPointArray = [NSMutableArray arrayWithCapacity:0];
        }
        else{
            self.upperPointArray = [NSMutableArray arrayWithArray:aUpperArray];
        }
        
        if(aLowerArray == nil){
            self.lowerPointArray = [NSMutableArray arrayWithCapacity:0];
        }
        else{
            self.lowerPointArray = [NSMutableArray arrayWithArray:aLowerArray];
        }
        
        _lineColor = [UIColor colorWithRed:234/255.0 green:194/255.0 blue:129/255.0 alpha:1];
        
        self.contentSize = CGSizeMake((LineDistanceWidth+2)*100, self.frame.size.height);
        self.userInteractionEnabled = NO;
        
    }
    
    return self;
    
}

-(void)setUpperAndLowerLimitsWithUpper:(float)aUpper Middle:(float)aMiddle Lower:(float)aLower{
    
    priceUpper = aUpper;
    priceMiddle = aMiddle;
    priceLower = aLower;
    
    [self setNeedsDisplay];
}

-(void)addLine:(NSMutableArray *)aUpperArray AndLowerArray:(NSMutableArray *)aLowerArray{
    
    self.upperPointArray = [NSMutableArray arrayWithArray:aUpperArray];
    self.lowerPointArray = [NSMutableArray arrayWithArray:aLowerArray];
    
    [self.layer setNeedsDisplay];
    
    [self moveContentOff];
    
}

-(void)moveContentOff{
    if (self.upperPointArray.count<10) {
        //归位
        [self setContentOffset:CGPointMake(0, 0) animated:NO];
    }
        
    if (self.upperPointArray.count * LineDistanceWidth  > self.frame.size.width * LineWidthPercent) {
        
        [self setContentOffset:CGPointMake(self.upperPointArray.count * LineDistanceWidth - self.frame.size.width * LineWidthPercent, self.contentOffset.y) animated:NO];
    }
    
    for (int i = 0; i<self.upperPointArray.count; i++) {
        
        if (i == self.upperPointArray.count-1) {
            CGPoint point = CGPointFromString(self.upperPointArray[i]);
            
            _imageUpperView.center = point;
        }
    }
    for (int i = 0; i<self.lowerPointArray.count; i++) {
        
        if (i == self.lowerPointArray.count-1) {
            CGPoint point = CGPointFromString(self.lowerPointArray[i]);
            
            _imageLowerView.center = point;
        }
    }
}

-(void)setLineColor:(UIColor *)aColor{
    _lineColor = aColor;
}

- (void)drawRect:(CGRect)rect
{
    
    if (self.upperPointArray.count>1) {
        NSString * point = [NSString stringWithString:self.upperPointArray[1]];
        [self.upperPointArray removeObjectAtIndex:0];
        [self.upperPointArray insertObject:point atIndex:1];
    }
    
    if (self.lowerPointArray.count>1) {
        NSString * point = [NSString stringWithString:self.lowerPointArray[1]];
        [self.lowerPointArray removeObjectAtIndex:0];
        [self.lowerPointArray insertObject:point atIndex:1];
    }
    
    
    
    
    
    
    if (self.upperPointArray.count>0) {
        
        UIBezierPath* aPath = [UIBezierPath bezierPath];
        aPath.lineWidth = 1;
        
        aPath.lineCapStyle = kCGLineCapRound;
        aPath.lineJoinStyle = kCGLineCapRound;
        
        UIColor *color = Color_red;
        [color set]; //设置线条颜色
        
        CGPoint beginPoint = CGPointFromString(self.upperPointArray[0]);
        [aPath moveToPoint:beginPoint];
        
        for (int i = 0; i<self.upperPointArray.count; i++) {
            if (i!=0) {
                CGPoint point = CGPointFromString(self.upperPointArray[i]);
                [aPath addLineToPoint:point];
            }
            
            if (i == self.upperPointArray.count-1) {
                CGPoint point = CGPointFromString(self.upperPointArray[i]);
                
                CGPoint pointLine ;
                
                if (self.contentOffset.x != 0) {
                    pointLine = CGPointMake(self.frame.size.width + self.contentOffset.x , point.y);
                }
                else{
                    pointLine = CGPointMake(self.frame.size.width , point.y);
                }
                
                [aPath addLineToPoint:pointLine];
                
                _imageUpperView.center = point;
            }
        }
        
        _upperShowLabel.center = CGPointMake(_upperShowLabel.center.x, _imageUpperView.center.y);
        
        [aPath stroke];
    }
    else{
        _imageUpperView.center = CGPointMake(0, _imageUpperView.center.y);
    }
    
    if (self.lowerPointArray.count>0) {
        
        UIBezierPath* aPath = [UIBezierPath bezierPath];
        aPath.lineWidth = 1;
        
        aPath.lineCapStyle = kCGLineCapRound;
        aPath.lineJoinStyle = kCGLineCapRound;
        
        UIColor *color = Color_green;
        [color set]; //设置线条颜色
        
        CGPoint beginPoint = CGPointFromString(self.lowerPointArray[0]);
        [aPath moveToPoint:beginPoint];
        
        for (int i = 0; i<self.lowerPointArray.count; i++) {
            if (i!=0) {
                CGPoint point = CGPointFromString(self.lowerPointArray[i]);
                [aPath addLineToPoint:point];
            }
            
            if (i == self.lowerPointArray.count-1) {
                CGPoint point = CGPointFromString(self.lowerPointArray[i]);
                
                CGPoint pointLine ;
                
                if (self.contentOffset.x != 0) {
                    pointLine = CGPointMake(self.frame.size.width + self.contentOffset.x , point.y);
                }
                else{
                    pointLine = CGPointMake(self.frame.size.width , point.y);
                }
                
                [aPath addLineToPoint:pointLine];
                
                _imageLowerView.center = point;
            }
        }
        
        _lowerShowLabel.center = CGPointMake(_lowerShowLabel.center.x, _imageLowerView.center.y);
        
        [aPath stroke];
    }
    else{
        _imageLowerView.center = CGPointMake(0, _imageLowerView.center.y);
    }
    
    
    
}




@end
