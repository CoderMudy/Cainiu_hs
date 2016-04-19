//
//  HsH5Session.h
//  HsH5Message
//
//  Created by lihao on 14-9-11.
//  Copyright (c) 2014年 hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "hscomm_message_interface.h"

#define Session_Debug

/*!
 * session状态
 */
typedef enum{
    NEW,//新建
    INITIATING,//正在初始化
    INITIATED,//已初始化
    DESTROY//已销毁
} SessionStatus;

/*!
 * 错误定义
 */
typedef enum SessionErrors
{
    SUCCESS,//初始化成功
    TIMEOUT,//超时
    CONNECTED_FAIL,//连接服务器失败
    NETWORK_UNAVALIABLE,//网络连接不可用
    SERIALIZE_FAIL,//消息序列化失败
    MSG_PARSE_FAIL,//消息解析失败
    MSG_TOO_LONG,//消息超过长度限制
    QUEUE_FULL,//发送队列已满
    FILE_PERMISSION_DENIED,//文件拒绝访问
    NET_PERMISSION_DENIED//网络拒绝访问
}Errors;

/*!
 * H5消息回调处理协议
 */
@protocol INetworkResponse <NSObject>
/*!
 * 服务器返回消息处理函数
 * @param msg 操作成功时，为服务器响应消息，操作失败时为客户端发送失败的消息
 * @param error 服务器成功返回时为SUCCESS，否则为错误信息
 * @param userInfo 附加信息，按发送时原样返回
 */
-(void)handleMessage:(IHsCommMessage*)msg Error:(Errors)error UserInfo:(id)userInfo;

@end

/*!
 * H5服务器推送消息处理协议
 */
@protocol INetworkServerPush <NSObject>
/*!
 * 服务器推送消息处理函数
 * @param msg 服务器推送过来的消息
 */
-(void)pushCallback:(IHsCommMessage*)msg;

@end

/*!
 * 网咯地址类
 */
@interface HsNetworkAddr : NSObject
/*!
 * 服务器名称
 */
@property(nonatomic, retain) NSString *serverName;

/*!
 * 服务器IP地址
 */
@property(nonatomic, retain) NSString *serverIP;

/*!
 * 服务器端口号
 */
@property(nonatomic, assign) NSUInteger serverPort;

@end

/*!
 * 会话属性设置类
 */
@interface IH5SessionSettings : NSObject
{
    int   _heartbeatTime;//心跳发送间隔时间
}

/*!
 * 加载的模板文件的文件名
 */
@property (nonatomic, retain) NSString *templateFileName;
/*!
 * 请求超时的时间（单位：秒）
 */
@property (nonatomic, assign) int timeout;
/*!
 * 心跳包发送间隔（单位：秒）
 */
@property (nonatomic, readonly) int heartbeatTime;
/*!
 * 服务器地址
 */
@property (nonatomic, retain) HsNetworkAddr *networkAddr;
/*!
 * 请求发送队列的大小
 */
@property (nonatomic, assign) int queueSize;
/*!
 * 服务器地址数组（元素类型为HsNetworkAddr）
 */
@property (nonatomic, retain) NSArray *networkAddrList;
/*!
 * 默认服务器（networkAddrList数组中的下标值）
 */
@property (nonatomic, assign) int defaultNetworkAddr;
/*!
 * 开放平台申请到的clientId
 */
@property (nonatomic, retain) NSString *clientId;
/*!
 * 放平台申请到的clientSecret
 */
@property (nonatomic, retain) NSString *clientSecret;
/*!
 * 当前客户端的版本号
 */
@property (nonatomic, retain) NSString *clientVersion;

@end

@class IH5Session;

/*!
 * H5会话状态回调接口
 */
@protocol ISessionReady <NSObject>

/*!
 * @brief session事件回调函数
 * @param session  发送事件的session对象
 * @param error  session触发的错误（成功）事件
 */
-(void)onReady:(IH5Session*)session Result:(Errors)error;

@end



/*!
 * H5会话类，负责与服务器保持通讯，创建、发送以及接收H5消息
 */
@interface IH5Session : NSObject
{
    NSString                *_name;
    
    IH5SessionSettings      *_sessionSettings;
    void*                   _sessionId;
    int                     _sessionIdLen;
    
    SessionStatus           _sessionStatus;
    
    id                      _delegate;
}
/*!
 *  session当前状态
 */
@property (nonatomic, readonly) SessionStatus sessionStatus;
/*!
 * session代理对象
 */
@property (nonatomic, assign) id<ISessionReady> delegate;
/*!
 * 主推消息处理对象
 */
@property (nonatomic, assign) id<INetworkServerPush> pushHandleDelegate;

/*!
 * session名称，作为session管理的唯一标识（被同一个HsSessionManager管理的session，它们的name唯一）
 */
@property (nonatomic, readonly, retain) NSString *name;

/*!
 * @brief 获取当前session的配置信息
 * @return 一个IH5SessionSettings对象，可以通过设置此对象的属性来配置session
 */
- (IH5SessionSettings*)getSessionSettings;

/*!
 * @brief 对session进行初始化
 * @return 返回值为0 说明初始化成功， 失败则返回-1
 */
-(int)initiate;

/*!
 * @brief 创建一条H5消息
 * @param bzid  新消息的业务号
 * @param fid   新消息的功能号
 * @param pType 新消息类型
 * @return 一条新的H5 message
 */
-(IHsCommMessage*)createMessageWithBizID:(int)bzid
                               andFuncId:(int)fid
                          andPackageType:(int)pType;


/*!
 * @brief 向服务器发送一条H5消息
 * @param msg  需要发送给服务器的消息
 * @param delegate  用来处理服务器返回信息的代理对象
 */
- (void)sendMessage: (IHsCommMessage*)msg delegate: (id<INetworkResponse>)delegate;

/*!
 * @brief 向服务器发送一条H5消息
 * @param msg  需要发送给服务器的消息
 * @param delegate  用来处理服务器返回信息的代理对象
 * @param userInfo  用户附加对象，将在触发代理类回调时原样返回
 */
- (void)sendMessage: (IHsCommMessage*)msg delegate: (id<INetworkResponse>)delegate andUserInfo:(id)userInfo;

/*!
 * @brief 向服务器发送一条H5消息
 * @param msg  需要发送给服务器的消息
 * @param delegate  用来处理服务器返回信息的代理对象
 * @param userInfo  用户附加对象，将在触发代理类回调时原样返回
 * @param timeout   消息超时的时间（单位：秒）
 * @param resendTimes  消息重发的次数
 */
- (void)sendMessage: (IHsCommMessage*)msg delegate: (id<INetworkResponse>)delegate andUserInfo:(id)userInfo timeout:(int)timeout resendTimes:(int)resendTimes;

/*!
 * @brief 销毁当前session，同时会取消session中当前所有的请求
 */
-(void)destroy;

/*!
 * @brief 切换服务器
 * @param index 需要切换的服务器在服务器集群数组中的下标
 * @return 切换是否成功(YES--成功，NO--失败)
 */
-(BOOL)switchServer:(NSUInteger)index;


@end
