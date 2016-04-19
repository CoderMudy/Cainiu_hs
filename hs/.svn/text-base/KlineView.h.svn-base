//
//  KlineView.h
//  CurveTest
//
//  Created by RGZ on 15/11/4.
//  Copyright © 2015年 cainiu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^KLineBlock)(NSMutableArray *);
typedef void(^KLineBeginBlock)(KLineDataModel *);
typedef void(^KLineEndBlock)();
@interface KlineView : UIScrollView

typedef NS_ENUM(NSInteger,MA) {
    MA5 = 5,
    MA10 = 10,
    MA20 = 20
};

typedef NS_ENUM(NSInteger, KLineStyle) {
    KLineStyleRedVolume         = 1,
    KLineStyleGreenVolume       = 2,
    KLineStyleRed               = 3,
    KLineStyleGreen             = 4,
    KLineStyleALL               = 5,
    KLineStyleDefault           = 0,
};

@property (nonatomic,strong)NSMutableArray  *dataArray;
@property (nonatomic,strong)KLineBlock  klineBlock;

//十字线开始/结束
@property (nonatomic,strong)KLineBeginBlock  beginBlock;
@property (nonatomic,strong)KLineEndBlock    endBlock;

@property (nonatomic,strong)UILabel         *maShowLabel;

/*
 *  K线画图层
 *
 */

-(instancetype)initWithFrame:(CGRect)frame FloatNum:(int)aFloatNum WithInstrumentID:(NSString *)aID;

- (void)setUpperAndLowerPointYWithTop_Top:(float)aTop_Top_Y Top_Low:(float)aTop_Low_Y Low_Top:(float)aLow_Top_Y Low_Low:(float)aLow_Low_Y;

-(void)setDefaultDataArray:(NSMutableArray *)dataArray;
//无效方法（设置区间）
-(void)setDefaultRange:(float)aRangeHeight;

//设置几分钟K线
-(void)setKLineTimeLine:(NSInteger)timeLine DataArray:(NSMutableArray *)dataArray;

-(void)setTopBaseLineNum:(int)aTopBaseLineNum BottonBaseLineNum:(int)aBottomBaseLineNum;

-(void)move;

-(void)update;
//移除十字线
-(void)removeCrossView;

-(void)updateMA;

-(void)timeChange;

@end
