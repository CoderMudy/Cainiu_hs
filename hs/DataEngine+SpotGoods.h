//
//  DataEngine+SpotGoods.h
//  hs
//
//  Created by RGZ on 15/11/30.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "DataEngine.h"

@interface DataEngine(SpotGoods)

#pragma mark 现货模拟登录

+(void)requestSpotgoodsLoginWithUsername:(NSString *)aUsername Password:(NSString *)aPassword;

@end
