//
//  PositionMainView.h
//  hs
//
//  Created by PXJ on 15/4/28.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSView.h"
@interface TopPositionView : UIView


@property (nonatomic,strong)UILabel * earnTitleLab;
@property (nonatomic,strong)UILabel * earnLab;
@property (nonatomic,strong)UILabel *  inteEarnTitleLab;
@property (nonatomic,strong)UILabel * inteEarnLab;
@property (nonatomic,strong)UIImageView * backView;
@property (nonatomic,strong)UILabel * markll;

#pragma mark - 持仓未购股票时
@property (nonatomic,strong)UILabel * lineLab;

@property (nonatomic,strong)SSView *shView;
@property (nonatomic,strong)SSView *szView;
@property (nonatomic,strong)SSView *shViewP;
@property (nonatomic,strong)SSView *szViewP;

- (void)loadTopViewOptional:(BOOL)isOptionalPage  dataArray:(NSMutableArray * )dataArray newPriceArray:(NSMutableArray *)newPriceArray curCashProfit:(float)curCashProfit curScoreProfit:(float)curScoreProfit dataDic:(NSDictionary*)dataDic;


@end

