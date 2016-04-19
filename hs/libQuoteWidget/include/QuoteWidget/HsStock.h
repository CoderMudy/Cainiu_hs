//
//  Stock.h
//  HsH5Message
//
//  Created by lihao on 14-9-24.
//  Copyright (c) 2014年 hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 *  @brief  股票信息数据模型
 */
@interface HsStock : NSObject
/*!
 *  @brief  股票代码
 */
@property(nonatomic, retain)NSString *stockCode;
/*!
 *  @brief  股票市场分类代码
 */
@property(nonatomic, retain)NSString *codeType;
/*!
 *  @brief  股票名称
 */
@property(nonatomic, retain)NSString *stockName;
/*!
 *  @brief  昨收价
 */
@property(nonatomic, assign)double    preClosePrice;
/*!
 *  @brief  股票市场代码
 */
@property(nonatomic, readonly) NSString *marketType;

@end
