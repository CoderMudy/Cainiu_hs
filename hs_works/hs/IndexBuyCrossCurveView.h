//
//  IndexBuyCrossCurveView.h
//  hs
//
//  Created by RGZ on 15/10/21.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeSharingModel.h"

@interface IndexBuyCrossCurveView : UIView
//当前点位、总点数、价格数组
-(instancetype)initWithFrame:(CGRect)aFrame ParamDictionary:(NSMutableDictionary *)aParamDic;

-(void)changeLocation:(CGPoint)aPoint ParamDictionary:(NSMutableDictionary *)aParamDic;

-(void)setTimeLine:(NSString *)aTimeLineStr;

@end
