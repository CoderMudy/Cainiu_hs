//
//  HsUSSRealtimeViewModel.h
//  QuoteWidget
//
//  Created by lihao on 14-9-30.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HsViewModel.h"
#import "HsStockRealtime.h"
/*!
 *  @brief  美股快照视图模型类
 */
@interface HsUSSRealtimeViewModel : HsViewModel

/*!
 * 获取个股名称
 */
-(NSString*)getStockName;

/*!
 * 获取个股代码
 */
-(NSString*)getStockCode;

/*!
 * 获取个股类型代码
 */
-(NSString*)getCodeType;

/*!
 * 今开
 */
-(double)getOpenPrice;

/*!
 * 最高
 */
-(double)getHighPrice;

/*!
 * 最低
 */
-(double)getLowPrice;

/*!
 * 最新价
 */
-(double)getNewPrice;

/*!
 * 昨收
 */
-(double)getPreClosePrice;

/*!
 * 成交量
 */
-(NSString*)getTotal;

//-(NSString*)getTotalMoney;
//-(NSString*)getCurrent;
//-(NSString*)getOutside;
//-(NSString*)getInside;
//-(NSString*)getTotalShares;

/*!
 * 总市值
 */
-(NSString*)getTotalValue;

/*!
 * 市盈率
 */
-(NSString*)getPE;

//-(NSString*)getNetAsset;

/*!
 * 每股收益
 */
-(NSString*)getEPS;

/*!
 * 52周最高价
 */
-(NSString*)get52WeekHigh;

/*!
 * 52周最低价
 */
-(NSString*)get52WeekLow;

/*!
 * 盘前盘后价格
 */
-(NSString*)getAfterPrice;

/*!
 * 盘前盘后涨跌额
 */
-(NSString*)getAfterPriceChange;

/*!
 * 盘前盘后涨跌幅
 */
-(NSString*)getAfterPriceChangePercent;

/*!
 * 获取盘口队列（买）
 */
-(NSArray*)getBuyPriceList;

/*!
 * 获取盘口队列(卖)
 */
-(NSArray*)getSellPriceList;

/*!
 * 每手股数
 */
-(int)getHand;

/*!
 * 交易状态
 */
-(int)getTradeStatus;

/*!
 *  @brief  行情时间戳
 *
 *  @return 以证书形式返回的HMMSSsss格式时间戳
 */
-(long long)getTimeStamp;

@end
