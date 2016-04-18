//
//  RecordDetailController.h
//  hs
//
//  Created by RGZ on 15/7/14.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordDetailController : HSBaseViewController<UITableViewDataSource,UITableViewDelegate>

//是否积分
@property (nonatomic,assign)BOOL    isScore;
//数据字典
@property (nonatomic,strong)NSMutableDictionary *infoDic;

@end
