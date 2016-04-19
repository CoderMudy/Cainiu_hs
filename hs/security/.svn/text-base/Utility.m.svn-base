//
//  Utility2.m
//  XSP
//
//  Created by trjmmac on 15/1/5.
//  Copyright (c) 2015年 trj-xsp. All rights reserved.
//

#import "Utility.h"
#import "CommonCrypto/CommonDigest.h"
static NSString *_key = @"12345678";


@implementation Utility

+(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}




//+ (NSString *) md5:(NSString *)str
//
//{
//    
//    const char *cStr = [str UTF8String];
//    
//    unsigned char result[CC_MD5_DIGEST_LENGTH];
//    
//    CC_MD5( cStr, strlen(cStr), result );
//    
//    return [[NSString
//            
//            stringWithFormat: @"XXXXXXXXXXXXXXXX",
//            
//            result[0], result[1],
//            
//            result[2], result[3],
//            
//            result[4], result[5],
//            
//            result[6], result[7],
//            
//            result[8], result[9],
//            
//            result[10], result[11],
//            
//            result[12], result[13],
//            
//            result[14], result[15]
//            
//            ] lowercaseString];
//    
//}


//data转16进制
+ (NSString *)hexStringFromData:(NSData *)myD{
    
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    
    return hexStr;
}
//16进制转data
+ (NSData *) stringToHexData:(NSString *)myStr
{
    int len = (int)([myStr length] / 2);    // Target length
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};
    
    int i;
    for (i=0; i < [myStr length] / 2; i++) {
        byte_chars[0] = [myStr characterAtIndex:i*2];
        byte_chars[1] = [myStr characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    
    NSData *data = [NSData dataWithBytes:buf length:len];
    free( buf );
    return data;
}


//16进制转byte数组
//+(bytes[])toBytes:(NSString *)hexString
//{
//    hexString = @"3e435fab9c34891f"; //16进制字符串
//    int j=0;
//    Byte bytes[128];  ///3ds key的Byte 数组， 128位
//    for(int i=0;i<[hexString length];i++)
//    {
//        int int_ch;  /// 两位16进制数转化后的10进制数
//        
//        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
//        int int_ch1;
//        if(hex_char1 >= '0' && hex_char1 <='9')
//            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
//        else if(hex_char1 >= 'A' && hex_char1 <='F')
//            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
//        else
//            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
//        i++;
//        
//        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
//        int int_ch2;
//        if(hex_char2 >= '0' && hex_char2 <='9')
//            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
//        else if(hex_char1 >= 'A' && hex_char1 <='F')
//            int_ch2 = hex_char2-55; //// A 的Ascll - 65
//        else
//            int_ch2 = hex_char2-87; //// a 的Ascll - 97
//        
//        int_ch = int_ch1+int_ch2;
//        NSLog(@"int_ch=%d",int_ch);
//        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
//        j++;
//    }
//    NSData *newData = [[NSData alloc] initWithBytes:bytes length:128];
//    NSLog(@"newData=%@",newData);
//    return bytes[1];
//}

+ (NSString *) encryptStr:(NSString *) str Key:(NSString *)aKey IV:(NSString *)iv
{
//    {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF}
    
    return [Utility doCipher:str key:aKey context:kCCEncrypt IV:nil];
}
+ (NSString *) decryptStr:(NSString *) str Key:(NSString *)aKey IV:(NSArray *)aIVArray
{
    return [Utility doCipher:str key:aKey context:kCCDecrypt IV:nil];
}
+ (NSString *)doCipher:(NSString *)sTextIn key:(NSString *)sKey
               context:(CCOperation)encryptOrDecrypt IV:(Byte[])aIV {
    NSStringEncoding EnC = NSUTF8StringEncoding;
    
    NSMutableData * dTextIn;
    if (encryptOrDecrypt == kCCDecrypt) {
//        dTextIn = [[sTextIn dataUsingEncoding:EnC] mutableCopy];
        dTextIn = [[Utility stringToHexData:sTextIn] mutableCopy];
    }
    else{
        dTextIn = [[sTextIn dataUsingEncoding: EnC] mutableCopy];
    }
    NSMutableData * dKey = [[sKey dataUsingEncoding:EnC] mutableCopy];
    [dKey setLength:kCCBlockSizeDES];
    uint8_t *bufferPtr1 = NULL;
    size_t bufferPtrSize1 = 0;
    size_t movedBytes1 = 0;
    //uint8_t iv[kCCBlockSizeDES];
    //memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    
    bufferPtrSize1 = ([sTextIn length] + kCCKeySizeDES) & ~(kCCKeySizeDES -1);
    bufferPtr1 = malloc(bufferPtrSize1 * sizeof(uint8_t));
    memset((void *)bufferPtr1, 0x00, bufferPtrSize1);
    CCCrypt(encryptOrDecrypt, // CCOperation op
            kCCAlgorithmDES, // CCAlgorithm alg
            kCCOptionPKCS7Padding, // CCOptions options
            [dKey bytes], // const void *key
            [dKey length], // size_t keyLength
            iv, // const void *iv
            [dTextIn bytes], // const void *dataIn
            [dTextIn length],  // size_t dataInLength
            (void *)bufferPtr1, // void *dataOut
            bufferPtrSize1,     // size_t dataOutAvailable
            &movedBytes1);      // size_t *dataOutMoved
    
    NSString * sResult;
    if (encryptOrDecrypt == kCCDecrypt){
        
        NSData *dResult = [NSData dataWithBytes:bufferPtr1 length:movedBytes1];
        sResult = [[ NSString alloc] initWithData:dResult encoding:EnC];
        dResult = nil;
    }
    else {
        NSData *dResult = [NSData dataWithBytes:bufferPtr1 length:movedBytes1];
        sResult = [Utility hexStringFromData:dResult];
        dResult = nil;
    }
    return sResult;
}


//****************Test*******************
//NSString *encrypt2=[Utility2 encryptStr:@"abcd"];
//NSLog(@"encrypt1:%@",encrypt2);
//NSString *decrypt2=[Utility2 decryptStr:encrypt2];
//NSLog(@"decrypt:%@",decrypt2);

@end
