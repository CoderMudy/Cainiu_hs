//
//  TotalMainView.h
//  hs
//
//  Created by RGZ on 15/8/19.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

/*
 分时图
 */

#import <UIKit/UIKit.h>

@interface TotalMainView : UIView

@property (nonatomic,strong)NSMutableArray  *priceArray;

-(instancetype)initWithFrame:(CGRect)frame PriceArray:(NSMutableArray *)aPriceArray FloatNum:(int)aFloatNum InfoDic:(NSMutableDictionary *)aInfoDic DayOrNight:(BOOL)aDayOrNight BaseLine:(int)aBaseLineNum;

-(void)setUpperAndLowerLimitsWithUpper:(float)aUpper Middle:(float)aMiddle Lower:(float)aLower;

-(void)addPrice:(NSString *)aPrice;

-(void)setPriceModelArray:(NSMutableArray *)aModelArray;
//0:au  1:if    2:ag        default:Day:YES
-(void)setDayOrNight:(BOOL)aDayorNight;

-(void)setTimeLine:(NSString *)aTimeLineStr;
//现货9：00-6：00无法解析问题
-(void)setLastTimeLineString:(NSString *)aLastTimeLineString;
@end
