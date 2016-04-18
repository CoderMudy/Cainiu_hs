//
//  TotalLineView.h
//  hs
//
//  Created by RGZ on 15/8/19.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

/*
 分时图
 */

#import <UIKit/UIKit.h>

@interface TotalLineView : UIScrollView

@property (nonatomic,strong)NSMutableArray *pointArray;

@property (nonatomic,strong)UILabel     *showLabel;

-(instancetype)initWithFrame:(CGRect)frame LineArray:(NSMutableArray *)aLineArray NumCount:(int)aNumCount DayOrNight:(BOOL)aDayorNight;

-(void)setUpperAndLowerLimitsWithUpper:(float)aUpper Middle:(float)aMiddle Lower:(float)aLower;

-(void)addLine:(NSMutableArray *)aPointStrArray;

-(void)setLineColor:(UIColor *)aColor;

-(void)setNumCount:(int)aNumCount;
//-(void)setType:(int)aType   DayOrNight:(BOOL)aDayorNight  DataArray:(NSMutableArray *)dataArray;

@end
