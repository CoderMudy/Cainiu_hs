//
//  ChooseChargeWayController.h
//  hs
//
//  Created by RGZ on 15/7/3.
//  Copyright (c) 2015年 luckin. All rights reserved.
//
typedef NS_ENUM(NSInteger, ActionType) {
    AtcionTypeDrawMoney = 0,
    ActionTypeRechargeMoney,
};

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ChooseChargeWayController :BaseViewController <UITableViewDataSource,UITableViewDelegate>

//1:账户  2：下单 
@property(nonatomic,assign) int infoStatus;

@end
