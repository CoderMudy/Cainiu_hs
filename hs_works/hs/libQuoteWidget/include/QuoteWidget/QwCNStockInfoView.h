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
 *  @brief  沪深A股快照视图
 */
@interface QwCNStockInfoView : UIView{
    QwLabel *_newPriceLabel;//最新价
    QwLabel *_changeLabel;//涨跌额和涨跌幅
    
    QwLabel *_openPriceLabel;//开盘价
    QwLabel *_preClosePriceLabel;//昨收价
    QwLabel *_totalVolumeLabel;//成交量
    QwLabel *_turnOverLabel;//换手率
    
    UILabel *_HighPriceLabel;//最高价
    UILabel *_LowPriceLabel;//最低价
    UILabel *_totalMoneyLabel;//成交额
    
    UILabel *_insideLabel;//内盘
    UILabel *_outsideLabel;//外盘
    UILabel *_totalValueLabel;//总市值
    
    UILabel *_PELabel;//市盈率
    UILabel *_amplitudeLabel;//增幅
    UILabel *_circulationValueLabel;//流通市值
    
    HsRealtimeViewModel *_viewModel;
}
/*!
 *  @brief  快照视图模型
 */
@property (nonatomic,retain) HsRealtimeViewModel *viewModel;

@end
