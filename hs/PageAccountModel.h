//
//  PageAccountModel.h
//  hs
//
//  Created by RGZ on 15/6/23.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

/*
 账户
 */

#import <Foundation/Foundation.h>
#import "AccountIndexModel.h"
#import "AccountDetailModel.h"
#import "AccountIntegralModel.h"
#import "AccountRecordModel.h"

@interface PageAccountModel : NSObject<NSCoding>

#pragma mark --账户首页

@property (nonatomic,strong)AccountIndexModel   *accountIndexModel;

#pragma mark --账户明细

@property (nonatomic,strong)AccountDetailModel  *accountDetailModel;

#pragma mark --积分

@property (nonatomic,strong)AccountIntegralModel *accountIntegralModel;

#pragma mark --交易记录

@property (nonatomic,strong)AccountRecordModel  *accountRecordModel;

@end
