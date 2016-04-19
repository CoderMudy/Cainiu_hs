//
//  PageSSViewModel.h
//  hs
//
//  Created by PXJ on 15/7/1.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HsRealtime.h"

@interface RealTimeStockModel : NSObject
//股票／板块名称
@property (nonatomic,strong)NSString * name;
//股票代码
@property (nonatomic,strong)NSString * code;
//股票板块
@property (nonatomic,strong)NSString * codeType;
//当前价
@property (nonatomic,assign)double price;
//买入价
@property (nonatomic,assign)float  buyPrice;
//卖出价
@property (nonatomic,assign)float  salePrice;
//今开价
@property (nonatomic,assign)float  openPrice;
//最高价
@property (nonatomic,assign)float  hightPrice;
//最低价
@property (nonatomic,assign)float  lowPrice;
//收盘价
@property (nonatomic,assign)float  closePrice;
//昨收价
@property (nonatomic,assign)float  preClosePrice;
//盈亏
@property (nonatomic,assign)float priceChange;
//涨跌幅
@property (nonatomic,assign)float priceChangePerCent;
//交易状态
@property (nonatomic,assign)int tradeStatus;
//买入数量
@property (nonatomic,assign)int  buyCount;
//快照时间
@property (nonatomic,assign)int timestamp;

- (id)realTimeStockModelwithHsrealtime:(HsRealtime*)realtime;

@end
