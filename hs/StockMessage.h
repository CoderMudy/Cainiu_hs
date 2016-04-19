//
//  StockMessage.h
//  hs
//
//  Created by PXJ on 15/7/6.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HsRealtime.h"
@interface StockMessage : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)HsRealtime * realtime;
@property (nonatomic,strong)UITableView * tableView;

@end
