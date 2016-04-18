//
//  EnvironmentConfiger.h
//  hs
//
//  Created by RGZ on 16/2/17.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnvironmentConfiger : NSObject
AS_SINGLETON(EnvironmentConfiger)

/**
 *  正式环境IP
 */
@property (nonatomic,strong)NSString    *HTTP_IP_ONLINE;
/**
 *  测试环境IP
 */
@property (nonatomic,strong)NSString    *HTTP_IP_TEST;
/**
 *  模拟环境IP
 */
@property (nonatomic,strong)NSString    *HTTP_IP_SIMULATE;
/**
 *  当前所属区间
 */
@property (nonatomic,assign)int         currentSection;
/**
 *  配置当前所属区间
 */
-(void)setCurrentSection;

/**
 *  友盟在线参数(备用)
 */
@property (nonatomic,strong)NSString    *umHTTP_IP_ONLINE;
@property (nonatomic,strong)NSString    *umHTTP_IP_TEST;
@property (nonatomic,strong)NSString    *umHTTP_IP_SIMULATE;

@end
