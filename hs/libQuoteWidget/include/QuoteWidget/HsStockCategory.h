//
//  HsStockCategory.h
//  QuoteWidget
//
//  Created by lihao on 14-10-8.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HsStockCategory : NSObject

@property(nonatomic, retain) NSString *parentCategoryCode;
@property(nonatomic, retain) NSString *categoryCode;//板块代码
@property(nonatomic, retain) NSString *categoryName;//板块名称

@end
