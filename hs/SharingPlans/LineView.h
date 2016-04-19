//
//  LineView.h
//  TableTest
//
//  Created by RGZ on 15/7/23.
//  Copyright (c) 2015年 RGZ. All rights reserved.
//


/*
 闪电图
 */

#import <UIKit/UIKit.h>

@interface LineView : UIScrollView

@property (nonatomic,strong)NSMutableArray *pointArray;

@property (nonatomic,strong)UILabel     *showLabel;

-(instancetype)initWithFrame:(CGRect)frame LineArray:(NSMutableArray *)aLineArray;

-(void)setUpperAndLowerLimitsWithUpper:(float)aUpper Middle:(float)aMiddle Lower:(float)aLower;

-(void)addLine:(NSMutableArray *)aPointStrArray;

-(void)setLineColor:(UIColor *)aColor;

@end
