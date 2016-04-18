//
//  SSView.h
//  hs
//
//  Created by PXJ on 15/5/16.
//  Copyright (c) 2015年 luckin. All rights reserved.
//
typedef void(^GoDetail)(id);

#import <UIKit/UIKit.h>
#import "QwCNStockInfoView.h"
#import "RealTimeStockModel.h"

@interface SSView : UIView
{
    UILabel * _nameLab;
    UILabel * _numLab;
    UILabel * _changeLab;
    UILabel * _lineLab;
    UIButton * _goDetailBtn;
}

@property (copy)GoDetail goDetail;
- (id)initSSViewWithFrame:(CGRect)rect;

- (void)setSSViewValue:(RealTimeStockModel *)realtime;

- (void)setViewValue:(RealTimeStockModel*)realtime;

@end
