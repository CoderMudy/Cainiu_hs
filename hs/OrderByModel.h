//
//  OrderByModel.h
//  hs
//
//  Created by PXJ on 15/7/7.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderByModel : NSObject

//买入价格
@property(nonatomic,assign)float price;
//期望买入数量
@property(nonatomic,assign)int buyCount;
//股票交易状态
@property(nonatomic,assign)int status;
//配资额度
@property(nonatomic,strong)NSString * selectAmt;
//股票名称
@property(nonatomic,strong)NSString * stockName;
//股票代码
@property(nonatomic,strong)NSString * stockCode;
//所属板块
@property(nonatomic,strong)NSString * stockCodeType;

@end
