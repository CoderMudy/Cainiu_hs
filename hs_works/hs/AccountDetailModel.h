//
//  AccountDetailModel.h
//  hs
//
//  Created by RGZ on 15/6/23.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

/*
 账户明细
 */

#import <Foundation/Foundation.h>

@interface AccountDetailModel : NSObject<NSCoding>

#pragma mark --可提现

@property (nonatomic,strong)NSString        *drawMoney;

#pragma mark --冻结

@property (nonatomic,strong)NSString        *freezeMoney;

#pragma mark --收支明细数组

@property (nonatomic,strong)NSMutableArray  *accountDetailArray;

@end
