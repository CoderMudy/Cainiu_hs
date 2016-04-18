//
//  UUID.m
//  Test
//
//  Created by RGZ on 15/9/2.
//  Copyright (c) 2015年 RGZ. All rights reserved.
//

#import "UUID.h"
#import "KeychainItemWrapper.h"


@implementation UUID

+(NSString *)getUUID
{
    
    NSString    *uuidFix = @"apphomes";
    
    if ([[DataEngine bundleSeedID] isEqualToString:@"X3769JEER4"]) {
        uuidFix = @"hs";
    }
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc]
                                         
                                         initWithIdentifier:@"UUID"
                                         
                                         accessGroup:[NSString stringWithFormat:@"%@.com.cainiu.%@",[DataEngine bundleSeedID],uuidFix]];
    
    
    NSString *strUUID = [keychainItem objectForKey:(id)CFBridgingRelease(kSecValueData)];
    
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""])
        
    {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        [keychainItem setObject:strUUID forKey:(id)CFBridgingRelease(kSecValueData)];
        
    }
    return strUUID;
}


@end
