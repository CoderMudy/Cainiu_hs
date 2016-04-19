//
//  QwUSStockInfoView.h
//  QuoteWidget
//
//  Created by Gu Jianglai on 14-10-16.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HsRealtimeViewModel.h"
@class QwLabel;

/*!
 *  @brief  沪深指数视图
 */
@interface QwCNIndexInfoView : UIView{
    QwLabel *_newPriceLabel;//最新价
    QwLabel *_changeLabel;//涨跌额和涨跌幅
    
    QwLabel *_openPriceLabel;//开盘价
    QwLabel *_preClosePriceLabel;//昨收价
    QwLabel *_totalMoneyLabel;//成交额
    QwLabel *_amplitudeLabel;//振幅

    
    UILabel *_HighPriceLabel;//最高价
    UILabel *_LowPriceLabel;//最低价
    UILabel *_totalVolumeLabel;//成交量

    UILabel *_riseCountLabel;//涨家数
    UILabel *_stableCountLabel;//平家数
    UILabel *_fallCountLabel;//跌家数

    
    HsRealtimeViewModel *_viewModel;
}
/*!
 *  @brief  快照视图模型
 */
@property (nonatomic,retain) HsRealtimeViewModel *viewModel;

@end
