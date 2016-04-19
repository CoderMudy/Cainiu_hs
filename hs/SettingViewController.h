//
//  SettingViewController.h
//  hs
//
//  Created by RGZ on 15/5/20.
//  Copyright (c) 2015年 luckin. All rights reserved.
//
typedef void(^GoLoginBlock)();
#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)GoLoginBlock gologinBlock;
@property (nonatomic,assign)BOOL isWorker;
@property (nonatomic,assign)int userStyle;//(0普通用户，1可模拟环境，2最高权限用户)
@end
