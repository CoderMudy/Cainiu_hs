//
//  h5DataCenterMgr.m
//  hs
//
//  Created by hzl on 15/5/12.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "h5DataCenterMgr.h"

#include "H5DataCenter.h"
#import "HsSessionManager.h"

#define SESSION_KEY     @"TEST_H5SESSION"
#define H5SERVERIP      @"112.124.211.5"
#define H5SERVERPORT    9999


@interface h5DataCenterMgr() <ISessionReady>
{
     IH5Session *_h5Session;
}
@end

@implementation h5DataCenterMgr

+ (instancetype)sharedInstance
{
    static id sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[h5DataCenterMgr alloc] init];
    });

    return sharedInstance;
}
-(void)createSession
{
    //首先使用工程类创建（获取）指定id的session
    _h5Session = [HsSessionManager createSession:SESSION_KEY];
    
    //指定代理类
    _h5Session.delegate = self;
    HsNetworkAddr *addr = [[HsNetworkAddr alloc] init];
    addr.serverIP   = H5SERVERIP;
    addr.serverPort = H5SERVERPORT;
    //配置session
    IH5SessionSettings *settings = [_h5Session getSessionSettings];
    settings.networkAddr = addr;
    //settings.host = H5SERVERIP;
    //settings.port = H5SERVERPORT;
    //初始化session
    [_h5Session initiate];
    
}
//session状态的回调处理方法
-(void)onReady:(IH5Session *)session Result:(Errors)error
{
    //根据session回调状态进行选择操作
    if (error == SUCCESS) {
        if(!_dataCenter)
        {
            _dataCenter = [[H5DataCenter alloc] init];
             NSLog(@"_dataCenter alloc init");
            
        }
        _dataCenter.h5Session = _h5Session;
        
        NSLog(@"h5 server connect success");
    }
}
-(void)destroySession;
{
    [HsSessionManager destroySession:SESSION_KEY];
    
}
@end


