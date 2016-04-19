//
//  QwTickView.h
//  QuoteWidget
//
//  Created by Gu Jianglai on 14/12/12.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HsTickViewModel.h"
/*!
 *  @brief  成交明细视图
 */
@interface QwTickView : UIView<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tickListView;
    
    HsTickViewModel *_viewModel;
    bool _firstLoad;
}
/*!
 *  @brief  绑定的成交明细视图模型
 */
@property (nonatomic,retain)HsTickViewModel *viewModel;

@end
