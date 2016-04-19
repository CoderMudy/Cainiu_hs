//
//  DoubleMainView.h
//  hs
//
//  Created by RGZ on 15/9/22.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoubleMainView : UIView

@property (nonatomic,strong)NSMutableArray  *upperPriceArray;
@property (nonatomic,strong)NSMutableArray  *lowerPriceArray;

-(instancetype)initWithFrame:(CGRect)frame UpperPriceArray:(NSMutableArray *)aUpperArray LowerPriceArray:(NSMutableArray *)aLowerArray FloatNum:(int)aNum BaseLine:(int)aBaseLineNum;

-(void)setUpperAndLowerLimitsWithUpper:(float)aUpper Middle:(float)aMiddle Lower:(float)aLower;

-(void)addPrice:(NSString *)aPrice LowerPrice:(NSString *)aLowerPrice;

-(void)setPriceArray:(NSMutableArray *)aArray LowerPriceArray:(NSMutableArray *)aLowerArray;

@end
