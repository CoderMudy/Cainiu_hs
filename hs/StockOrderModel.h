//
//  StockOrderModel.h
//  hs
//
//  Created by RGZ on 15/7/7.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockOrderModel : NSObject

@property (nonatomic,assign)int stockID;

// 0 :现金  1：积分
@property (nonatomic,assign)int stockFundType;

//配资额度
@property (nonatomic,assign)float stockFinancyAllocation;

//倍数
@property (nonatomic,assign)float stockMultiple;

//保证金
@property (nonatomic,assign)float stockCashFund;

//手续费
@property (nonatomic,assign)float stockCounterFee;

//应扣手续费
@property (nonatomic,assign)float stockDeductCounterFee;

//实扣手续费
@property (nonatomic,assign)float stockInterest;

//允许亏损的最大额度
@property (nonatomic,assign)float stockMaxLoss;

//预警通知金额
@property (nonatomic,assign)float stockWarnAmt;

// 0 :不可买  1:可买
@property (nonatomic,assign)int stockStatus;




@end
