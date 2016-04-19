//
//  StockDetailView.h
//  hs
//
//  Created by PXJ on 15/5/20.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopStockView.h"
#import "QwTrendView.h"
#import "QwKlineView.h"
#import "StockDetailData.h"
//#import "PersonPositionPosiBoList.h"

#import "QwTrendViewTouchable.h"
#import "QwKlineLandscapeView.h"




@interface StockDetailView : UIView

@property (nonatomic,strong)TopStockView *stockTopView;
@property (nonatomic,strong)UILabel * bottomLab;
@property (nonatomic,strong)UIButton * buyBtn;
@property (nonatomic,strong)UIButton * amtBtn;
@property (nonatomic,strong)UIView * btnBackView;
@property (nonatomic,strong)QwTrendViewTouchable *trendView;
@property (nonatomic,strong)QwKlineLandscapeView *klineView;
@property (nonatomic,strong)UIView * AmtView;
@property (nonatomic,strong)UILabel * alertLab;


- (void)setStockDetailViewValueWithSource:(BOOL)isbuy
                                 position:(BOOL)isPositon
                                 isbuyBuy:(BOOL)isbuyBuy
                               isexponent:(BOOL)isexponent
                     stockDetailDataModel:(id)rosource
                                 realtime:(HsRealtime*)realtime;
@end
