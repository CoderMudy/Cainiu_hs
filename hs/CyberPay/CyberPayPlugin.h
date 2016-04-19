//
//  CyberPayPlugin.h
//  CyberPayPlugin
//
//  Created by niushubin on 15-07-01.
//  Copyright (c) 2015年 niushubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *	@brief	支付结果代理
 */
@protocol CyberPayPluginDelegate <NSObject>

/**
 *	@brief	支付结果代理回调函数
 *
 *	@param 	paycode  支付结果返回码
 *
 *  @brief	01 支付成功 ，02 支付失败 ， 03 取消订单
 */

- (void)payResultInfo:(NSString *)paycode;

@end


@interface CyberPayPlugin : NSObject

/**
 *	@brief	支付单例类
 *
 */
+ (id)getInstance;

/**
 *	@brief	支付接口函数
 *
 *	@param 	orderInfo  订单信息  参数格式 {ORDERNO:"订单号",MERID:"商户编号"}
 *
 *  @param  delegate  支付结果代理函数
 */

- (void)enterPaymentController:(NSDictionary  *)dict  withDelegate:(id<CyberPayPluginDelegate>)tempDelegate;

@end

