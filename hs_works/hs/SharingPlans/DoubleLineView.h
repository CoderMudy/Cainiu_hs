//
//  DoubleLineView.h
//  hs
//
//  Created by RGZ on 15/9/22.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoubleLineView : UIScrollView

@property (nonatomic,strong)NSMutableArray *upperPointArray;
@property (nonatomic,strong)NSMutableArray *lowerPointArray;

@property (nonatomic,strong)UILabel     *upperShowLabel;
@property (nonatomic,strong)UILabel     *lowerShowLabel;

-(instancetype)initWithFrame:(CGRect)frame UpperLineArray:(NSMutableArray *)aUpperArray LowerLineArray:(NSMutableArray *)aLowerArray;

-(void)setUpperAndLowerLimitsWithUpper:(float)aUpper Middle:(float)aMiddle Lower:(float)aLower;

-(void)addLine:(NSMutableArray *)aUpperArray AndLowerArray:(NSMutableArray *)aLowerArray;

-(void)setLineColor:(UIColor *)aColor;

@end