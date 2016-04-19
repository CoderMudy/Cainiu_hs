//
//  HsQuoteUtils.h
//  QuoteWidget
//
//  Created by lihao on 14-9-29.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HsStock.h"
#import "HsMarket.h"


#define RISE_COLOR    @"#d61100"///涨的颜色
#define FALL_COLOR    @"#2d8133"///跌的颜色
#define STABLE_COLOR  @"#a3a3a3"///平的颜色

#define MAX_VALUE(a, b, c)  ( a > b ? ( a > c ? a : c) : ( b > c ? b : c))
#define MIN_VALUE(a, b, c)  ( a < b ? ( a < c ? a : c) : ( b < c ? b : c))
/*!
 *  @brief  个股类型定义
 */
typedef NS_ENUM(NSUInteger, HsStockCategory) {
    /*!
     *  @brief  未知类型
     */
    NONSTOCK,
    /*!
     *  @brief  沪深A股
     */
    CN_STOCK,
    /*!
     *  @brief  美股
     */
    US_STOCK
};

/*!
 *  @brief  行情工具类，提供行情市场信息，个股分类等
 */
@interface HsQuoteUtils : NSObject
{
    NSMutableDictionary *_marketItems;
    NSMutableDictionary *_marketTypeMap;
    
    NSString            *_filePath;
    NSLock              *_lock;
    BOOL                _hasUpdate;
    
    UIColor            *_riseColor;
    UIColor            *_fallColor;
    UIColor            *_stableColor;
}
/*!
 *  @brief  市场信息
 */
@property (nonatomic, readonly) NSDictionary *marketItems;
/*!
 *  @brief  市场分类信息
 */
@property (nonatomic, readonly) NSDictionary *marketTypeMap;

/*!
 *  @brief  获取工具类单例
 *
 *  @return 工具类单例
 */
+(HsQuoteUtils*)shareInstance;
/*!
 *  @brief  更新市场信息
 *
 *  @param marketInfo 要更新的市场信息
 *
 *  @return YES更新成功，NO更新失败
 */
-(BOOL)updateMaketInfo:(NSDictionary*)marketInfo;
/*!
 *  @brief  将市场信息保存到本地沙盒
 */
-(void)saveMarketInfoToFile;

/*!
 * 根据股票获取行情源的价格倍数
 */
+(int)getPriceScale:(HsStock*)stock;
/*!
 * 根据股票获取行情源的价格倍数
 */
-(int)getPriceScale:(HsStock*)stock;

/*!
 * 根据股票获取价格精度（小数位数）
 */
+(int)getPriceDecimal:(HsStock*)stock;
/*!
 * 根据股票获取价格精度（小数位数）
 */
-(int)getPriceDecimal:(HsStock*)stock;

/*!
 * 根据股票获取股票开闭市时间
 */
+(NSArray*)getOpenCloseTime:(HsStock*)stock;
/*!
 * 根据股票获取股票开闭市时间
 */
-(NSArray*)getOpenCloseTime:(HsStock*)stock;

/*!
 * 获取数组中指定区间的最大值（数组中元素类型必须是NSNumber）
 */
+(NSNumber*)getTopValueInArray:(NSArray*)array From:(int)begin To:(int)end;

/*!
 * 获取数组中指定区间的最小值（数组中元素类型必须是NSNumber）
 */
+(NSNumber*)getBottomValueInArray:(NSArray*)array From:(int)begin To:(int)end;

/*!
 * 根据昨收和现价获取价格字符串显示颜色
 */
+(UIColor *)getColorWithPrevPrice:(double)prevPrice NewPrice:(double)newPrice;
/*!
 * 根据涨跌额获取价格字符串显示颜色
 */
+(UIColor *)getColorWithPriceChange:(double)priceChange;

/*!
 * 获取个股类型（沪深A股、美股、港股....）
 */
+(HsStockCategory)getStockCategory:(HsStock*)stock;
/*!
 * 获取个股类型（沪深A股、美股、港股....）
 */
+(HsStockCategory)getStockCategoryByType:(NSString*)type;

/*!
 * 判断个股是否数指数
 */
+(BOOL)isIndex:(HsStock*)stock;

/*!
 * 判断股票是否从DTK获取
 */
+(BOOL)isDtkStock:(HsStock*)stock;
/*!
 * 判断股票是否从DTK获取
 */
+(BOOL)isDtkStockByType:(NSString*)type;

/*!
 * stock转化成dictionary
 */
+(NSDictionary*)dicFromStock:(HsStock*)stock;
/*!
 * stock转化成dictionary
 */
+(HsStock*)stockFromDic:(NSDictionary*)dic;

/*!
 * 获取涨的颜色
 */
+(UIColor*)riseColor;
/*!
 * 获取跌的颜色
 */
+(UIColor*)fallColor;
/*!
 * 获取平的颜色
 */
+(UIColor*)stableColor;

@end
