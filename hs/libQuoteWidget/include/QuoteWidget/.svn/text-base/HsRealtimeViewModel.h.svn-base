//
//  HsRealtimeViewModel.h
//  QuoteWidget
//
//  Created by lihao on 14-10-15.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import "HsViewModel.h"
#import "HsStockRealtime.h"
/*!
 *  @brief  快照视图模型类
 */
@interface HsRealtimeViewModel : HsViewModel

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
 * 最高价
 */
-(double)getHighPrice;

/*!
 * 最低价
 */
-(double)getLowPrice;

/*!
 * 现价
 */
-(double)getNewPrice;

/*!
 * 昨收
 */
-(double)getPrevClosePrice;

/*!
 * 成交量
 */
-(NSString*)getVolume;

/*!
 * 成交额
 */
-(NSString*)getTotalMoney;

/*!
 * 现手
 */
-(NSString*)getCurrent;

/*!
 * 外盘
 */
-(NSString*)getOutside;

/*!
 * 内盘
 */
-(NSString*)getInside;

/*!
 * 总股数
 */
-(NSString*)getTotalShares;

/*!
 * 市盈率
 */
-(NSString*)getPE;

/*!
 * 每股净资产
 */
-(NSString*)getNetAsset;

/*!
 * 振幅
 */
-(NSString*)getAmplitude;

/*!
 * 换手率
 */
-(NSString*)getTurnoverRate;

/*!
 * 总市值
 */
-(NSString*)getTotalValue;

/*!
 * 流通市值
 */
-(NSString*)getCirculationValue;

/*!
 * 涨家数
 */
-(NSString*)getRiseCount;

/*!
 * 平家数
 */
-(NSString*)getUnchangedCount;

/*!
 * 跌家数
 */
-(NSString*)getFallCount;

/*!
 * 获取盘口队列（买）
 */
-(NSArray*)getBuyPriceList;

/*!
 * 获取盘口队列(卖)
 */
-(NSArray*)getSellPriceList;
/*!
 * 获取领涨队列
 */
-(NSArray*)getRiseLeadingList;

/*!
 * 获取领跌队列
 */
-(NSArray*)getFallLeadingList;

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
