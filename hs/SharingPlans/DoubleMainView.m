//
//  DoubleMainView.m
//  hs
//
//  Created by RGZ on 15/9/22.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "DoubleMainView.h"
#import <QuartzCore/QuartzCore.h>
#import "DoubleLineView.h"

//横线右侧的长度
#define Line_Horizontal 52
@implementation DoubleMainView
{
    int         timeout;
    DoubleLineView    *_lineV;
    float       pointY;
    
    UILabel     *_upperShowLabel;
    UILabel     *_lowerShowLabel;
    
    //价位
    float       priceUpper;
    float       priceMiddle;
    float       priceLower;
    
    int         floatNum;
    int         baseLineNum;
    
}

-(instancetype)initWithFrame:(CGRect)frame UpperPriceArray:(NSMutableArray *)aUpperArray LowerPriceArray:(NSMutableArray *)aLowerArray FloatNum:(int)aNum BaseLine:(int)aBaseLineNum{
    self = [super initWithFrame:frame];
    if (self) {
        baseLineNum = aBaseLineNum;
        floatNum = aNum;
        self.upperPriceArray = [NSMutableArray arrayWithArray:aUpperArray];
        self.lowerPriceArray = [NSMutableArray arrayWithArray:aLowerArray];
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
    
    _upperShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-Line_Horizontal-5, -50, Line_Horizontal, 15)];
    _upperShowLabel.font = [UIFont systemFontOfSize:11];
    _upperShowLabel.backgroundColor = Color_red;
    _upperShowLabel.layer.cornerRadius = 3;
    _upperShowLabel.textAlignment = NSTextAlignmentCenter;
    _upperShowLabel.clipsToBounds = YES;
    _upperShowLabel.textColor = [UIColor whiteColor];
    
    _lowerShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-Line_Horizontal-5, -50, Line_Horizontal, 15)];
    _lowerShowLabel.font = [UIFont systemFontOfSize:11];
    _lowerShowLabel.backgroundColor = Color_green;
    _lowerShowLabel.layer.cornerRadius = 3;
    _lowerShowLabel.textAlignment = NSTextAlignmentCenter;
    _lowerShowLabel.clipsToBounds = YES;
    _lowerShowLabel.textColor = [UIColor whiteColor];
    
    _upperShowLabel.text = [DataUsedEngine conversionFloatNum:0.0 ExpectFloatNum:floatNum];
    _lowerShowLabel.text = [DataUsedEngine conversionFloatNum:0.0 ExpectFloatNum:floatNum];
    
    if (self.upperPriceArray.count != 0 && self.lowerPriceArray.count != 0) {        
        _upperShowLabel.text = [DataUsedEngine conversionFloatNum:[self.upperPriceArray[0] doubleValue] ExpectFloatNum:floatNum];
        _lowerShowLabel.text = [DataUsedEngine conversionFloatNum:[self.lowerPriceArray[0] doubleValue] ExpectFloatNum:floatNum];
    }
    [self addSubview:_upperShowLabel];
    [self addSubview:_lowerShowLabel];
    [self loadLineView];
}

-(void)loadLineView{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    _lineV = [[DoubleLineView alloc]initWithFrame:CGRectMake(5, 0, self.frame.size.width-Line_Horizontal-10, self.frame.size.height) UpperLineArray:array LowerLineArray:array];
    _lineV.upperShowLabel = _upperShowLabel;
    _lineV.lowerShowLabel = _lowerShowLabel;
    [self addSubview:_lineV];
    
    NSMutableArray *pointArray = [NSMutableArray arrayWithObjects:NSStringFromCGPoint(CGPointMake(0, self.frame.size.height/2)), nil];
    
    [_lineV addLine:pointArray AndLowerArray:pointArray];
    
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
    
    if (self.upperPriceArray.count != 0 && self.lowerPriceArray.count != 0) {
        [self priceToPointWithPriceArray:self.upperPriceArray LowerPriceArray:self.lowerPriceArray];
    }
    
    [_lineV setUpperAndLowerLimitsWithUpper:aUpper Middle:aMiddle Lower:aLower];
}

-(void)addPrice:(NSString *)aPrice LowerPrice:(NSString *)aLowerPrice{
    if (self.upperPriceArray != nil) {
        [self.upperPriceArray addObject:aPrice];
    }
    else{
        self.upperPriceArray = [NSMutableArray arrayWithCapacity:0];
        [self.upperPriceArray addObject:aPrice];
    }
    
    if (self.lowerPriceArray != nil) {
        [self.lowerPriceArray addObject:aPrice];
    }
    else{
        self.lowerPriceArray = [NSMutableArray arrayWithCapacity:0];
        [self.lowerPriceArray addObject:aPrice];
    }
    
    
    [self priceToPointWithPriceArray:self.upperPriceArray LowerPriceArray:self.lowerPriceArray];
}

-(void)setPriceArray:(NSMutableArray *)aArray LowerPriceArray:(NSMutableArray *)aLowerArray{
    if (aArray != nil && aArray.count ==1){
        
        _upperShowLabel.text = [DataUsedEngine conversionFloatNum:[aArray.lastObject doubleValue] ExpectFloatNum:floatNum];
        _lowerShowLabel.text = [DataUsedEngine conversionFloatNum:[aLowerArray.lastObject doubleValue] ExpectFloatNum:floatNum];
    }
    
    [self priceToPointWithPriceArray:aArray LowerPriceArray:aLowerArray];
}

//必须要有价位才可调用计算
-(void)priceToPointWithPriceArray:(NSMutableArray *)aUpperArray LowerPriceArray:(NSMutableArray *)aLowerArray{
    
    NSMutableArray *upperPointArray = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i<aUpperArray.count; i++) {
        float priceCurrent = [aUpperArray[i] floatValue];
        
        float y = (self.frame.size.height-20) * (1 - ((priceCurrent - priceLower)/(priceUpper - priceLower))) + 10;
        
        float x = i * 1.5;
        
        CGPoint point = CGPointMake(x, y);
        
        [upperPointArray addObject:NSStringFromCGPoint(point)];
    }
    
    _upperShowLabel.text = [DataUsedEngine conversionFloatNum:[aUpperArray.lastObject doubleValue] ExpectFloatNum:floatNum];
    
    CGPoint upperPoint = CGPointFromString(upperPointArray.lastObject);
    
    _upperShowLabel.center = CGPointMake(_upperShowLabel.center.x, upperPoint.y);
    
    
    NSMutableArray *lowerPointArray = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i<aLowerArray.count; i++) {
        float priceCurrent = [aLowerArray[i] floatValue];
        
        float y = (self.frame.size.height-20) * (1 - ((priceCurrent - priceLower)/(priceUpper - priceLower))) + 10;
        
        float x = i * 1.5;
        
        CGPoint point = CGPointMake(x, y);
        
        [lowerPointArray addObject:NSStringFromCGPoint(point)];
    }
    
    _lowerShowLabel.text = [DataUsedEngine conversionFloatNum:[aLowerArray.lastObject doubleValue] ExpectFloatNum:floatNum];
    
    CGPoint lowerPoint = CGPointFromString(lowerPointArray.lastObject);
    
    _lowerShowLabel.center = CGPointMake(_lowerShowLabel.center.x, lowerPoint.y);
    
    [_lineV addLine:upperPointArray AndLowerArray:lowerPointArray ];
}

@end
