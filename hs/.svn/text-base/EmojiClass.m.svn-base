//
//  EmojiClass.m
//  hs
//
//  Created by PXJ on 16/3/29.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "EmojiClass.h"

@implementation EmojiClass

+ (NSString *)encodeToPercentEscapeString: (NSString *) input

{
    input = [EmojiClass changeEncodeWithString:input];
    return input;
    
}

//解码

+ (NSString *)decodeFromPercentEscapeString: (NSString *) input

{

    input = [EmojiClass replaceUnicode:input];
    return input;
    
    
}

// NSString值为Unicode格式的字符串编码(如\u7E8C)转换成中文
//unicode编码以\u开头
+ (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString * returnS = [NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable format:nil errorDescription:nil];
    return returnS;
}
+ (NSString *)changeEncodeWithString:(NSString*)str
{
    str = str == nil ?@"" : str;
    NSString * tmp  = @"";
    NSString *  sb = @"";
    sb  = [sb substringToIndex:0];
    unichar c;
    int i, j;
    for (i = 0; i < str.length; i++) {
        c = [str characterAtIndex:i];
        sb= [sb stringByAppendingString:@"\\u"];//  .append("\\u");
        j =   (unsigned char)(c>>8) ;//取出高8位
        tmp = [NSString stringWithFormat:@"%X",j];//        tmp = Integer.toHexString(j);
        if (tmp.length == 1){
            sb = [sb stringByAppendingString:@"0"];}
           // sb.append("0");
        sb = [sb stringByAppendingString:tmp];

//        sb.append(tmp);
        j = (c & 0xFF); //取出低8位
        tmp = [NSString stringWithFormat:@"%X",j]; //Integer.toHexString(j);
        if (tmp.length == 1){
            sb = [sb stringByAppendingString:@"0"];}

        //sb.append("0");
        sb = [sb stringByAppendingString:tmp];

//        sb.append(tmp);
        
    }

    return sb;

}


+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff)
         {
             if (substring.length > 1)
             {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f)
                 {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1)
         {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3)
             {
                 returnValue = YES;
             }
             
         } else
         {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff)
             {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07)
             {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935)
             {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299)
             {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)
             {
                 returnValue = YES;
             }
         }
         
     }];
    return returnValue;
}

@end

