//
//  KLineDataModel.h
//  CurveTest
//
//  Created by RGZ on 15/11/10.
//  Copyright © 2015年 cainiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLineDataModel : NSObject

@property (nonatomic,assign)NSInteger   kid;
@property (nonatomic,strong)NSString    *instrumentID;
@property (nonatomic,assign)double      openPrice;
@property (nonatomic,assign)double      closePrice;
@property (nonatomic,assign)double      maxPrice;
@property (nonatomic,assign)double      minPrice;
@property (nonatomic,strong)NSString    *time;
@property (nonatomic,assign)NSInteger   volume;
@property (nonatomic,assign)NSInteger   kLineMinute;

@end
