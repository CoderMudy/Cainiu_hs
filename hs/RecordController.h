//
//  RecordController.h
//  hs
//
//  Created by RGZ on 15/7/13.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordController : HSBaseViewController<UITableViewDataSource,UITableViewDelegate>
//是否积分
@property(nonatomic,assign)BOOL isScore;

@end
