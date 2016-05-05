//
//  MainView.m
//  TableTest
//
//  Created by RGZ on 15/7/27.
//  Copyright (c) 2015年 RGZ. All rights reserved.
//

#import "MainView.h"
#import "LineView.h"
#import <QuartzCore/QuartzCore.h>


//横线右侧的长度
#define Line_Horizontal 47
@implementation MainView
{
    int         timeout;
    LineView    *_lineV;
    float       pointY;
    
    UILabel     *_showLabel;
    
    //价位
    float       priceUpper;
    float       priceMiddle;
    float       priceLower;
    
    int         floatNum;
    int         baseLineNum;
    
}
-(instancetype)initWithFrame:(CGRect)frame PriceArray:(NSMutableArray *)aPriceArray FloatNum:(int)aNum BaseLineNum:(int)aBaseLineNum{
    self = [super initWithFrame:frame];
    if (self) {
        
        baseLineNum = aBaseLineNum;
        floatNum = aNum;
        self.priceArray = [NSMutableArray arrayWithArray:aPriceArray];;
        [self loadUI];
        
    }
    
    return self;
}

-(void)loadUI{
    
    self.backgroundColor = Color_grayDeep;
    
    [self drawLineWithFrame:CGRectMake(5, 10, self.frame.size.width-10-Line_Horizontal, 1)];
    [self rightLabelWithTag:100 CenterPointY:10];
    
    for (int i = 1; i < baseLineNum-1; i++) {
        [self drawLineWithFrame:CGRectMake(5, (self.frame.size.height-20)/(baseLineNum-1)*i+10, self.frame.size.width-10-Line_Horizontal, 1)];
        [self rightLabelWithTag:100+i CenterPointY:(self.frame.size.height-20)/(baseLineNum-1)*i+10];
    }
    
    [self drawLineWithFrame:CGRectMake(5, self.frame.size.height-10, self.frame.size.width-10-Line_Horizontal, 1)];
    [self rightLabelWithTag:100+baseLineNum-1 CenterPointY:self.frame.size.height-10];
    
    
    _showLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-Line_Horizontal-5, -50, Line_Horizontal, 15)];
    _showLabel.font = [UIFont systemFontOfSize:11];
    _showLabel.backgroundColor = Color_Gold;
    _showLabel.layer.cornerRadius = 3;
    _showLabel.textAlignment = NSTextAlignmentCenter;
    _showLabel.clipsToBounds = YES;
    _showLabel.text = [DataUsedEngine conversionFloatNum:0.0 ExpectFloatNum:floatNum];
    if (self.priceArray.count != 0) {
        _showLabel.text = self.priceArray[0];
        
        _showLabel.text = [DataUsedEngine conversionFloatNum:[self.priceArray[0] doubleValue] ExpectFloatNum:floatNum];
    }
    [self addSubview:_showLabel];
    [self loadLineView];
}

-(void)loadLineView{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    _lineV = [[LineView alloc]initWithFrame:CGRectMake(5, 0, self.frame.size.width-Line_Horizontal-10, self.frame.size.height) LineArray:array];
    _lineV.showLabel = _showLabel;
    [self addSubview:_lineV];
    
    NSMutableArray *pointArray = [NSMutableArray arrayWithObjects:NSStringFromCGPoint(CGPointMake(0, self.frame.size.height/2)), nil];
    
    [_lineV addLine:pointArray];
    
}


-(void)drawLineWithFrame:(CGRect)aRect{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:aRect];
    [self addSubview:imageView];
    
    
    UIGraphicsBeginImageContext(imageView.frame.size);   //开始画线
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    CGFloat lengths[] = {1,10};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1].CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 1);  //画虚线
    CGContextMoveToPoint(line, 0.0, 0.0);    //开始画线
    CGContextAddLineToPoint(line, aRect.size.width, 0.0);
    CGContextStrokePath(line);
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
}

-(void)rightLabelWithTag:(int)aTag CenterPointY:(CGFloat)aCenterY{
    UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-Line_Horizontal-5, 0, Line_Horizontal, 15)];
    rightLabel.center = CGPointMake(rightLabel.center.x, aCenterY);
    rightLabel.text = [DataUsedEngine conversionFloatNum:0.0 ExpectFloatNum:floatNum];
    rightLabel.font = [UIFont systemFontOfSize:12];
    rightLabel.tag = aTag;
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.textColor = [UIColor blackColor];
    [self addSubview:rightLabel];
}

-(void)setUpperAndLowerLimitsWithUpper:(float)aUpper Middle:(float)aMiddle Lower:(float)aLower{
    int upperTag = 100;
    int lowerTag = 100+baseLineNum-1;
    
    for (int i = 100; i<=lowerTag; i++) {
        UILabel *label = (UILabel *)[self viewWithTag:i];
        
        if (i == upperTag) {
            label.text = [DataUsedEngine conversionFloatNum:aUpper ExpectFloatNum:floatNum];
        }
        else if (i == lowerTag){
            label.text = [DataUsedEngine conversionFloatNum:aLower ExpectFloatNum:floatNum];
        }
        else{
            label.text = [DataUsedEngine conversionFloatNum:((aUpper-aLower)/(baseLineNum-1)*((baseLineNum-1) - (i-100))+aLower) ExpectFloatNum:floatNum];
        }
    }
    
    priceUpper = aUpper;
    priceMiddle = aMiddle;
    priceLower = aLower;
    
    if (self.priceArray.count != 0) {
        [self priceToPointWithPriceArray:self.priceArray];
    }
    
    [_lineV setUpperAndLowerLimitsWithUpper:aUpper Middle:aMiddle Lower:aLower];
}

-(void)addPrice:(NSString *)aPrice{
    if (self.priceArray != nil) {
        [self.priceArray addObject:aPrice];
    }
    else{
        self.priceArray = [NSMutableArray arrayWithCapacity:0];
        [self.priceArray addObject:aPrice];
    }
    [self priceToPointWithPriceArray:self.priceArray];
}

-(void)setPriceArray:(NSMutableArray *)aArray{
    if (aArray != nil && aArray.count ==1){
        _showLabel.text = [DataUsedEngine conversionFloatNum:[aArray.lastObject doubleValue] ExpectFloatNum:floatNum];
    }
    
    [self priceToPointWithPriceArray:aArray];
}

//必须要有价位才可调用计算
-(void)priceToPointWithPriceArray:(NSMutableArray *)aPriceArray{
    
    NSMutableArray *pointArray = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i<aPriceArray.count; i++) {
        float priceCurrent = [aPriceArray[i] floatValue];
        
        float y = (self.frame.size.height-20) * (1 - ((priceCurrent - priceLower)/(priceUpper - priceLower))) + 10;
        
        float x = i * 2;
        
        CGPoint point = CGPointMake(x, y);
        
        [pointArray addObject:NSStringFromCGPoint(point)];
    }
    
    _showLabel.text = [DataUsedEngine conversionFloatNum:[aPriceArray.lastObject doubleValue] ExpectFloatNum:floatNum];
    
    CGPoint point = CGPointFromString(pointArray.lastObject);
    
    _showLabel.center = CGPointMake(_showLabel.center.x, point.y);
    
    [_lineV addLine:pointArray];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
