//
//  FinancialItem.h
//  HsH5Message
//
//  Created by lihao on 14-9-24.
//  Copyright (c) 2014年 hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 *  @brief  个股财务数据模型
 */
@interface HsFinancialItem : NSObject
/*!
 *  @brief  总股本
 */
@property (nonatomic,retain)NSString *totalShares;//总股数
/*!
 *  @brief  流通股本
 */
@property (nonatomic,retain)NSString *circulationShares;//流通股
/*!
 *  @brief  每股净资产
 */
@property (nonatomic,retain)NSString *netAsset;//每股净资产
/*!
 *  @brief  净资产收益率
 */
@property (nonatomic,retain)NSString *ROE;//净资产收益率
/*!
 *  @brief  市盈率
 */
@property (nonatomic,retain)NSString *PE;//市盈率
/*!
 *  @brief  每股收益
 */
@property (nonatomic,retain)NSString *EPS;//每股收益
/*!
 *  @brief  股东人数
 */
@property (nonatomic,retain)NSString *stockHolders;//股东人数
/*!
 *  @brief  总市值
 */
@property (nonatomic,retain)NSString *totalValue;//总市值
/*!
 *  @brief  流通市值
 */
@property (nonatomic,retain)NSString *circulationValue;//流通市值

@end
