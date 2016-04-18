//
//  HolidayCacheModel.h
//  hs
//
//  Created by PXJ on 16/1/19.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HolidayCacheModel : NSObject

#pragma mark 记录假期场弹窗显示及是否为节假日
@property (nonatomic,strong) NSDictionary * holidayDic;
@property (nonatomic,strong) NSString * holidayGameShow;

@end
