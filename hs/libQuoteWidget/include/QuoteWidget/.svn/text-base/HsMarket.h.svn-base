//
//  Market.h
//  HsH5Message
//
//  Created by lihao on 14-9-24.
//  Copyright (c) 2014年 hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 *  @brief  市场信息数据模型
 */
@interface HsMarket : NSObject
/*!
 *  @brief  市场代码
 */
@property(nonatomic, retain)NSString *marketCode;
/*!
 *  @brief  市场名称
 */
@property(nonatomic, retain)NSString *marketName;
/*!
 *  @brief  市场日期
 */
@property(nonatomic, assign)int marketDate;//市场日期
/*!
 *  @brief  交易日期
 */
@property(nonatomic, assign)int tradeDate;//交易日期
/*!
 *  @brief  市场所在市区
 */
@property(nonatomic, retain)NSString *timezone;//市场所在时区
/*!
 *  @brief  夏令时标识
 */
@property(nonatomic, assign)BOOL summerTimeFlag;//夏令时标识
/*!
 *  @brief  市场绑定的分类信息，HsTypeItem类型的数组
 */
@property(nonatomic, retain)NSMutableArray *typeItems;

@end

/*!
 *  @brief  分类信息数据模型
 */
@interface HsTypeItem : NSObject
/*!
 *  @brief  市场代码
 */
@property(nonatomic, retain)NSString *marketCode;//交易所代码
/*!
 *  @brief  分类代码
 */
@property(nonatomic, retain)NSString *marketTypeCode;//分类代码
/*!
 *  @brief  分类名称
 */
@property(nonatomic, retain)NSString *marketTypeName;//分类名称
/*!
 *  @brief  数据源价格缩放倍数
 */
@property(nonatomic, assign)int priceScale;//价格放大倍数
/*!
 *  @brief  价格精度
 */
@property(nonatomic, assign)int priceDecimal;//显示时需要保留的小数位数
/*!
 *  @brief  交易日期
 */
@property(nonatomic, assign)int tradeDate;//交易日期
/*!
 *  @brief  每手股数
 */
@property(nonatomic, assign)int hand;//每手证券数量
/*!
 *  @brief  开闭市时间，HsTradeTime类型的数组
 */
@property(nonatomic, retain)NSMutableArray *tradeTimes;

@end
/*!
 *  @brief  交易时间数据模型
 */
@interface HsTradeTime : NSObject
/*!
 *  @brief  开市时间，HHMM格式
 */
@property(nonatomic, assign)int openTime;
/*!
 *  @brief  闭式时间，HHMM格式
 */
@property(nonatomic, assign)int closeTime;

@end


