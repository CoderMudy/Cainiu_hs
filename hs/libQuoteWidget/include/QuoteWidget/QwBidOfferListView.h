//
//  QwBidOfferListView.h
//  QuoteWidget
//
//  Created by Gu Jianglai on 14/11/18.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HsRealtimeViewModel.h"
/*!
 *  @brief  五档买卖盘口视图
 */
@interface QwBidOfferListView : UIView{
    HsRealtimeViewModel *_realtime;
}
/*!
 *  @brief  绑定的快照视图模型
 */
@property (nonatomic,retain)HsRealtimeViewModel *realtime;

@end
