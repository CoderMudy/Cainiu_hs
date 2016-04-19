//
//  HsBlockItem.h
//  QuoteWidget
//
//  Created by lihao on 14-10-22.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 *  @brief  板块数据模型
 */
@interface HsBlockItem : NSObject
/*!
 *  @brief  板块名称
 */
@property (nonatomic, retain) NSString *blockName;
/*!
 *  @brief  板块代码
 */
@property (nonatomic, retain) NSString *blockCode;
/*!
 *  @brief  是否有子版块
 */
@property (nonatomic, assign) BOOL hasSubBlock;
/*!
 *  @brief  板块个股数量
 */
@property (nonatomic, assign) int stockCount;

@end
