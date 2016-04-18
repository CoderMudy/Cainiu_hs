//
//  QwUSStockInfoView.h
//  QuoteWidget
//
//  Created by Gu Jianglai on 14-10-16.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HsUSSRealtimeViewModel.h"
@class QwLabel;
/*!
 *  @brief  美股快照视图
 */
@interface QwUSStockInfoView : UIView{
    QwLabel *_newPriceLabel;//最新价
    QwLabel *_changeLabel;//涨跌额和涨跌幅
    
    QwLabel *_openPriceLabel;//开盘价
    QwLabel *_preClosePriceLabel;//昨收价
    QwLabel *_totalVolumeLabel;//交易量
    QwLabel *_marketCapLabel;//市值
    
    UILabel *_HighPriceLabel;
    UILabel *_LowPriceLabel;
    UILabel *_PELabel;
    
    UILabel *_w52HighPriceLabel;
    UILabel *_w52LowPriceLabel;
    UILabel *_EPSPriceLabel;
    
    UILabel *_POPCLabel;
    
    HsUSSRealtimeViewModel *_viewModel;
}
/*!
 *  @brief  美股快照视图模型
 */
@property (nonatomic,retain) HsUSSRealtimeViewModel *viewModel;

@end
