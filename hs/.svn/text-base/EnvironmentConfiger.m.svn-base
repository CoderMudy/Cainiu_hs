//
//  EnvironmentConfiger.m
//  hs
//
//  Created by RGZ on 16/2/17.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "EnvironmentConfiger.h"

@implementation EnvironmentConfiger
DEF_SINGLETON(EnvironmentConfiger)

-(void)setCurrentSection{
    if ([[[CMStoreManager sharedInstance] getEnvironment] isEqualToString:self.HTTP_IP_ONLINE]) {
        self.currentSection = 1;
    }
    else if ([[[CMStoreManager sharedInstance] getEnvironment] isEqualToString:self.HTTP_IP_TEST]){
        self.currentSection = 2;
    }
    else if ([[[CMStoreManager sharedInstance] getEnvironment] isEqualToString:self.HTTP_IP_SIMULATE]){
        self.currentSection = 3;
    }
    else {
        self.currentSection = 1;
        [[CMStoreManager sharedInstance] setEnvironment:self.HTTP_IP_ONLINE];
    }
    
    /**
     *  每次调用都把3个环境存入本地缓存
     */
    [CacheEngine setEnvironmentHTTP_IP];
}

@end
