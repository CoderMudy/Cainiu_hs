//
//  HsSessionManager.h
//  HsH5Message
//
//  Created by lihao on 14-9-16.
//  Copyright (c) 2014年 hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IH5Session.h"

/*!
 * session管理类（工厂类），负责管理它创建的所有session对象
 */
@interface HsSessionManager : NSObject

/*!
 * @brief 获取或创建指定名称的Session，若已经存在对应name的session，则返回该session，否则创建一个命名为name的新session
 * @param name session的唯一名称
 * @return 被此SessionManager类管理的session对象
 */
+(IH5Session*)createSession:(NSString*)name;

/*!
 * @brief 销毁指定名称的Session
 * @param session的唯一名称
 */
+(void)destroySession:(NSString*)name;


@end
