//
//  Utility2.h
//  XSP
//
//  Created by trjmmac on 15/1/5.
//  Copyright (c) 2015年 trj-xsp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
@interface Utility : NSObject
//+(NSString *) md5: (NSString *) inPutText ;
+ (NSString *) md5:(NSString *)str;

+ (NSString *)doCipher:(NSString *)sTextIn key:(NSString *)sKey
               context:(CCOperation)encryptOrDecrypt IV:(Byte[])aIV;
+ (NSString *) encryptStr:(NSString *) str Key:(NSString *)aKey IV:(NSString *)iv;
+ (NSString *) decryptStr:(NSString *) str Key:(NSString *)aKey IV:(NSArray *)aIVArray;

//data转16进制
+ (NSString *)hexStringFromData:(NSData *)myD;

//16进制转data
+ (NSData *) stringToHexData:(NSString *)myStr;
@end
