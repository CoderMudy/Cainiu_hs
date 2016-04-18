//
//  MAView.m
//  hs
//
//  Created by RGZ on 15/11/18.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "MAView.h"

@implementation MAView
{
    NSMutableArray *_pointArray;
    
    NSMutableArray *_firstLineArray;
    NSMutableArray *_middleLineArray;
    NSMutableArray *_lastLineArray;
}

//-(instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        
//    }
//    
//    return self;
//}

-(void)setPointArray:(NSMutableArray *)aPointArray{
    _pointArray = [NSMutableArray arrayWithArray:aPointArray];
    _firstLineArray = [NSMutableArray arrayWithCapacity:0];
    _middleLineArray = [NSMutableArray arrayWithCapacity:0];
    _lastLineArray = [NSMutableArray arrayWithCapacity:0];
    
    if (_pointArray.count >= 3) {
        [self firstArrayData];
        [self middleArrayData];
        [self lastArrayData];
    }
    
    [self resetMALine];
}

-(void)firstArrayData{
    int firstNum = 0;
    NSMutableArray *firstArrayTmp = _pointArray[0];
    for (int i = 0; i < [firstArrayTmp count]; i++) {
        CGPoint point = CGPointFromString(firstArrayTmp[i]);
        
        if (point.x + self.frame.size.width/DefaultShowNum >= self.frame.origin.x) {
            firstNum = i;
            break;
        }
    }
    int allNum = firstNum + DefaultShowNum + 3;
    if (allNum > [firstArrayTmp count]-1) {
        allNum = (int)[firstArrayTmp count]- 1;
    }
    for (int i = firstNum; i <= allNum; i++) {
        if (i < firstArrayTmp.count) {
            [_firstLineArray addObject:firstArrayTmp[i]];
        }
    }
}

-(void)middleArrayData{
    int middleNum = 0;
    NSMutableArray *middleArrayTmp = _pointArray[1];
    for (int i = 0; i < [middleArrayTmp count]; i++) {
        CGPoint point = CGPointFromString(middleArrayTmp[i]);
        if (point.x + self.frame.size.width/DefaultShowNum >= self.frame.origin.x) {
            middleNum = i;
            break;
        }
    }
    
    int allNum = middleNum + DefaultShowNum + 3;
    if (allNum > [middleArrayTmp count]-1) {
        allNum = (int)[middleArrayTmp count]- 1;
    }
    for (int i = middleNum; i <= allNum; i++) {
        if (i < middleArrayTmp.count) {
            [_middleLineArray addObject:middleArrayTmp[i]];
        }
    }
}

-(void)lastArrayData{
    int lastNum = 0;
    NSMutableArray *lastArrayTmp = [NSMutableArray arrayWithArray:_pointArray[2]];
    for (int i = 0; i < [lastArrayTmp count]; i++) {
        CGPoint point = CGPointFromString(lastArrayTmp[i]);
        if (point.x + self.frame.size.width/DefaultShowNum >= self.frame.origin.x) {
            lastNum = i;
            break;
        }
    }
    for (int i = lastNum; i < lastNum + DefaultShowNum + 3; i++) {
        if (i < lastArrayTmp.count) {
            [_lastLineArray addObject:lastArrayTmp[i]];
        }
    }
}

-(void)resetMALine{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (_firstLineArray.count>1) {
        
        UIBezierPath* aPath = [UIBezierPath bezierPath];
        aPath.lineWidth = 1;
        
        aPath.lineCapStyle = kCGLineCapRound;
        aPath.lineJoinStyle = kCGLineCapRound;
        
        UIColor *color = [UIColor colorWithRed:53/255.0 green:136/255.0 blue:221/255.0 alpha:1];
        [color set]; //设置线条颜色
        
        CGPoint beginPoint = CGPointFromString(_firstLineArray[0]);
        [aPath moveToPoint:CGPointMake(beginPoint.x - self.frame.origin.x, beginPoint.y)];
        
        for (int i = 0; i<_firstLineArray.count; i++) {
            if (i!=0) {
                CGPoint point = CGPointFromString(_firstLineArray[i]);
                [aPath addLineToPoint:CGPointMake(point.x - self.frame.origin.x, point.y)];
            }
        }
        [aPath stroke];
    }

    
    if (_middleLineArray.count>1) {
        
        UIBezierPath* aPath = [UIBezierPath bezierPath];
        aPath.lineWidth = 1;
        
        aPath.lineCapStyle = kCGLineCapRound;
        aPath.lineJoinStyle = kCGLineCapRound;
        
        UIColor *color = [UIColor colorWithRed:230/255.0 green:101/255.0 blue:47/255.0 alpha:1];
        [color set]; //设置线条颜色
        
        CGPoint beginPoint = CGPointFromString(_middleLineArray[0]);
        [aPath moveToPoint:CGPointMake(beginPoint.x - self.frame.origin.x, beginPoint.y)];
        
        for (int i = 0; i<_middleLineArray.count; i++) {
            if (i!=0) {
                CGPoint point = CGPointFromString(_middleLineArray[i]);
                [aPath addLineToPoint:CGPointMake(point.x - self.frame.origin.x, point.y)];
            }
        }
        [aPath stroke];
    }
    
    if (_lastLineArray.count>1) {
        
        UIBezierPath* aPath = [UIBezierPath bezierPath];
        aPath.lineWidth = 1;
        
        aPath.lineCapStyle = kCGLineCapRound;
        aPath.lineJoinStyle = kCGLineCapRound;
        
        UIColor *color = [UIColor colorWithRed:156/255.0 green:41/255.0 blue:114/255.0 alpha:1];
        [color set]; //设置线条颜色
        
        CGPoint beginPoint = CGPointFromString(_lastLineArray[0]);
        [aPath moveToPoint:CGPointMake(beginPoint.x - self.frame.origin.x, beginPoint.y)];
        
        for (int i = 0; i<_lastLineArray.count; i++) {
            if (i!=0) {
                CGPoint point = CGPointFromString(_lastLineArray[i]);
                [aPath addLineToPoint:CGPointMake(point.x - self.frame.origin.x, point.y)];
            }
        }
        [aPath stroke];
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
