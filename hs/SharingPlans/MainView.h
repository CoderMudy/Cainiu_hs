//
//  MainView.h
//  TableTest
//
//  Created by RGZ on 15/7/27.
//  Copyright (c) 2015年 RGZ. All rights reserved.
//

/*
 闪电图
 */

#import <UIKit/UIKit.h>

@interface MainView : UIView

@property (nonatomic,strong)NSMutableArray  *priceArray;

-(instancetype)initWithFrame:(CGRect)frame PriceArray:(NSMutableArray *)aPriceArray FloatNum:(int)aNum BaseLineNum:(int)aBaseLineNum;

-(void)setUpperAndLowerLimitsWithUpper:(float)aUpper Middle:(float)aMiddle Lower:(float)aLower;

-(void)addPrice:(NSString *)aPrice;

-(void)setPriceArray:(NSMutableArray *)aArray;



@end
