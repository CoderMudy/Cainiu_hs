//
//  MoneyDetaillViewController.h
//  hs
//
//  Created by 杨永刚 on 15/5/24.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

//typedef NS_ENUM(NSInteger, ActionType) {
//    AtcionTypeDrawMoney = 0,
//    ActionTypeRechargeMoney,
//};
#import "HSBaseViewController.h"

@interface MoneyDetaillViewController : HSBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSString   *usedMoney;

//1:账户  2：下单  3:任务中心
@property (nonatomic,assign) int        intoStatus;

@end
