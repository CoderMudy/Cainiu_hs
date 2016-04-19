//
//  HsTickViewModel.h
//  QuoteWidget
//
//  Created by lihao on 14-10-21.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import "HsViewModel.h"
#import "HsDealDetails.h"
/*!
 *  @brief  成交明细视图模型类
 */
@interface HsTickViewModel : HsViewModel
/*!
 *  @brief  成交明细数据模型
 */
@property (nonatomic, retain) HsDealDetails *dealDetails;
/*!
 *  @brief  获取当前成交明细数量
 */
-(int)dataCount;

@end
