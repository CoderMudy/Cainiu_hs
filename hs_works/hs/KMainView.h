//
//  KMainView.h
//  CurveTest
//
//  Created by RGZ on 15/11/10.
//  Copyright © 2015年 cainiu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^KMainBeginBlock)(KLineDataModel *);
typedef void(^KMainEndBlock)();
@interface KMainView : UIView<UIScrollViewDelegate>

/*
 *  K线外层
 *
 */
-(instancetype)initWithFrame:(CGRect)frame FloatNum:(int)aFloatNum WithInstrumentID:(NSString *)aID;

@property (nonatomic,strong)KMainBeginBlock mainBeginBlock;
@property (nonatomic,strong)KMainEndBlock mainEndBlock;

//设置几分钟K线
-(void)klineTimeChange;
//设置默认价格区间高度
-(void)setKLineDefaultHeight:(float)aHeight;

-(void)updateWithMarket:(BOOL)isOpen;
//无效方法（设置区间）
-(void)setDefaultRange:(float)aRangeHeight;

-(void)moveLast:(BOOL)isOpen;

-(void)setLastMove;

-(void)klineShowData:(NSMutableArray *)dataArray;

-(void)loadDefaultView;

-(void)timeChange;

@end
