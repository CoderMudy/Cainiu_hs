//
//  HsQuoteFormatUtils.h
//  QuoteWidget
//
//  Created by lihao on 14-9-29.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HsStock.h"
#import "HsRealtimeViewModel.h"
/*!
 *  @brief  行情格式化工具类，用于格式化各种行情数据，如价格、交易量等
 */
@interface HsQuoteFormatUtils : NSObject

/*!
 * 将股票价格还原到真实大小
 * @warning px参数的类型是unsigned int，注意符号转换
 * @param   px 行情源得到的价格
 * @param   stock 关联股票
 * @return  返回经过价格倍率缩放后正常的价格
 */
+(double)formatPrice:(unsigned int)px withStock:(HsStock*)stock;


/*!
 * 将价格格式化（根据股票对于的市场类型信息确定需要保留的小数位数）
 * @param   px 经过倍率缩放后正常的价格
 * @param   stock 关联股票
 * @return  返回经过价格精度（小数位数）格式化的价格字符串，px为0.0则返回"--"
 */
+(NSString*)priceToString:(double)px  withStock:(HsStock*)stock;


/*!
 * 将小数格式化成百分比(统一保留两位小数)，即将0.21733格式化成21.73%
 * @param value 要格式化的小数
 * @return 返回格式化以后的百分比
 */
+(NSString*)formatPercent:(double)value;


/*!
 * 获取指定小数位数的浮点数字符串
 * @param points 指定返回结果的小数位数
 * @param value 要格式化的数值
 * @return 返回指定小数位数的数值字符串
 */
+(NSString*)formatDouble:(double)value withPoint:(int)points;

/*!
 * 将量转化为带单位（万、亿）的字符串，大于十万的数值将会转化成单位为万的字符串，大于一亿的数值将会转化成单位为亿的字符串
 * @param bs 放大（缩小）倍数
 * @param amount 需要格式化的数值
 * @return 返回格式化以后的字符串，amount为0则返回"--"
 */
+(NSString*)amountToString:(int64_t)amount withMutiple:(int64_t)bs;

/*!
 * 获取字符串的所表示的数值（用于转化带有万、亿、千亿单位的字符串）
 * @param amountStr 带有单位的数值字符串
 * @return 返回转化后的数值
 */
+(double)amountStrToValue:(NSString*)amountStr;

/*!
 * 股数转化为手数，默认100股为1手，十万以上带有单位万，一亿以上带有单位亿
 * @param amount 需要格式化的股数
 * @return 返回转化为手后的带有单位（万，亿）的字符串，amount为0则返回"--"
 */
+(NSString*)amountToHand:(int64_t)amount;

/*!
 * 股数转化为手数,根据viewmodel获取每手股数,默认100股为1手，十万以上带有单位万，一亿以上带有单位亿
 * @param viewModel 股票对应快照
 * @param amount 需要格式化的股数
 * @return 返回转化为手后的带有单位（万，亿）的字符串，amount为0则返回"--"
 */
+(NSString*)amountToHand:(int64_t)amount withViewModel:(HsRealtimeViewModel*)viewModel;

/*!
 * 将量转化为带单位（万、亿）的字符串(含小数部分)
 * @param dec 需要保留的小数位数
 * @deprecated 没有使用
 */
+(NSString*)numberToStringWithUnit:(NSString*)numberStr withDecimal:(int)dec __deprecated;

/*!
 * 交易状态转化为对应字符串
 * @param tradeStatus 交易状态枚举，定义在HsRealtime.h
 * @return 返回可以被用户理解的交易状态信息，如交易中、停牌等
 */
+(NSString*)formatTradeStatus:(int)tradeStatus;

@end
