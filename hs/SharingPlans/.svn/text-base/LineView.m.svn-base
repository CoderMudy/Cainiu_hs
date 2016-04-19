//
//  LineView.m
//  TableTest
//
//  Created by RGZ on 15/7/23.
//  Copyright (c) 2015年 RGZ. All rights reserved.
//

#import "LineView.h"

//线间距
#define LineDistanceWidth 2

//线显示的部分占屏幕的百分比，超过后开始推线
#define LineWidthPercent 0.75

//金色
#define Color_Gold [UIColor colorWithRed:234/255.0 green:194/255.0 blue:129/255.0 alpha:1]

//黑色
#define Color_black [UIColor colorWithRed:3/255.0 green:0/255.0 blue:20/255.0 alpha:1]

@implementation LineView

{
    UIColor *_lineColor;
    
    //右侧label
    UILabel *_showLabel;
    
    float    priceUpper;
    float    priceMiddle;
    float    priceLower;
    
    UIImageView     *_imageView;
}

-(instancetype)initWithFrame:(CGRect)frame LineArray:(NSMutableArray *)aLineArray{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(-10, 0, 5, 5)];
        _imageView.image = [UIImage imageNamed:@"dian_table"];
        [self addSubview:_imageView];
                
        if(aLineArray == nil){
            self.pointArray = [NSMutableArray arrayWithCapacity:0];
        }
        else{
            self.pointArray = [NSMutableArray arrayWithArray:aLineArray];
        }
        _lineColor = [UIColor colorWithRed:234/255.0 green:194/255.0 blue:129/255.0 alpha:1];
        
        self.contentSize = CGSizeMake((LineDistanceWidth+2)*100, self.frame.size.height);
        self.userInteractionEnabled = NO;
        
    }
    
    return self;
    
}

-(void)animationStart{
    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _imageView.bounds = CGRectMake(0, 0, 8, 8);
    } completion:^(BOOL finished) {
        [self animationEnd];
    }];
}

-(void)animationEnd{
    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _imageView.bounds = CGRectMake(0, 0, 5, 5);
    } completion:^(BOOL finished) {
        [self animationStart];
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
    if (self.pointArray.count<10) {
        //归位
        [self setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    if (self.pointArray.count * LineDistanceWidth  > self.frame.size.width * LineWidthPercent) {
        [self setContentOffset:CGPointMake(self.pointArray.count * LineDistanceWidth - self.frame.size.width * LineWidthPercent, self.contentOffset.y) animated:NO];
    }
    
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
    
    if (self.pointArray.count>1) {
        NSString * point = [NSString stringWithString:self.pointArray[1]];
        [self.pointArray removeObjectAtIndex:0];
        [self.pointArray insertObject:point atIndex:1];
    }
    
    
    UIColor *color = _lineColor;
    [color set]; //设置线条颜色
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 1;
    
    aPath.lineCapStyle = kCGLineCapRound;
    aPath.lineJoinStyle = kCGLineCapRound;
    
    if (self.pointArray.count>0) {
        CGPoint beginPoint = CGPointFromString(self.pointArray[0]);
        [aPath moveToPoint:beginPoint];
        
        for (int i = 0; i<self.pointArray.count; i++) {
            if (i!=0) {
                CGPoint point = CGPointFromString(self.pointArray[i]);
                [aPath addLineToPoint:point];
            }
            
            if (i == self.pointArray.count-1) {
                CGPoint point = CGPointFromString(self.pointArray[i]);
                
                CGPoint pointLine ;
                
                if (self.contentOffset.x != 0) {
                    pointLine = CGPointMake(self.frame.size.width + self.contentOffset.x , point.y);
                }
                else{
                    pointLine = CGPointMake(self.frame.size.width , point.y);
                }
                
                [aPath addLineToPoint:pointLine];
                
                _imageView.center = point;
            }
        }
        
        _showLabel.center = CGPointMake(_showLabel.center.x, _imageView.center.y);
        
        [aPath stroke];
    }
    else{
        _imageView.center = CGPointMake(0, _imageView.center.y);
    }
    
    
}



@end
