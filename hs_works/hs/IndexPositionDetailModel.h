//
//  IndexPositionDetailModel.h
//  hs
//
//  Created by RGZ on 15/8/6.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexPositionDetailModel : NSObject

//交易类型（0:现金  1:积分）
@property (nonatomic,assign)int         type;


//买入价
@property (nonatomic,strong)NSString    *buyPrice;
//当前价
@property (nonatomic,strong)NSString    *currentPrice;

//交易方向（0:看多 1:看空）
@property (nonatomic,assign)int         tradeWay;

//交易数量（手）
@property (nonatomic,assign)int         tradeNum;
//成交时间
@property (nonatomic,strong)NSString    *tradeTime;
//触发止损
@property (nonatomic,assign)double      tradeTo;
//触发止盈
@property (nonatomic,assign)double      tradeGet;
@end
