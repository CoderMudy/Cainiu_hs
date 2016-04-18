//
//  CandleView.h
//  CurveTest
//
//  Created by RGZ on 15/11/4.
//  Copyright © 2015年 cainiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CandleView : UIView

@property (nonatomic,assign)NSInteger candleTag;

@property (nonatomic,assign)float   openPo;
@property (nonatomic,assign)float   voluPo;

-(instancetype)initWithFrame:(CGRect)frame Style:(int)aStyle;

-(void)setOpenPo:(float)aOpenPo ClosePo:(float)aClosePo MaxPo:(float)aMaxPo MinPo:(float)aMinPo VolumePo:(float)aVolumePo EndPo:(float)aEndPo;

-(void)changeOpenPo:(float)aOpenPo ClosePo:(float)aClosePo MaxPo:(float)aMaxPo MinPo:(float)aMinPo VolumePo:(float)aVolumePo EndPo:(float)aEndPo;

-(void)setCandleTag:(NSInteger)candleTag;

-(void)changeStyle:(int)aChangeStyle;

@end
