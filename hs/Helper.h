//
//  Helper.h
//  hs
//
//  Created by PXJ on 15/4/23.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

+ (NSMutableDictionary *)getParams:(NSString *)aParamsStr;

/**- InterpolatedUIImage=因为生成的二维码是一个CIImage，我们直接转换成UIImage的话大小不好控制，所以使用下面方法返回需要大小的UIImage*/
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;

/**- QRCodeGenerator--首先是二维码的生成，使用CIFilter很简单，直接传入生成二维码的字符串即可*/
+ (CIImage *)createQRForString:(NSString *)qrString;
#pragma mark UIImageView加圆形边框

+(UIImageView*)imageCutView:(UIImageView*)imgV cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth color:(UIColor*)color;
/**获取随机数*/
+(NSString *)randomGet;

//将id 对象转换为JSON字符串
+(NSString *)toJSON:(id)aParam;


#pragma mark 字符串转字典
+(NSDictionary *)dicWithJSonStr:(NSString *)jsonString;

/**
 *  字符串格式化null自动转为@""
 *
 *  @param str 任意类型的变量
 *
 *  @return 返回一个字符串
 */

+ (NSString *)judgeStr:(id)str;

//判断字符串是否是null
+ (BOOL)isNullString:(NSString *)string;

/**判断期货单位*/
+ (NSString*)unitWithCurrency:(NSString*)currency;

/**传入整数字符串，返回加逗号的字符串*/
+(NSString *)countNumChangeformat:(NSString *)num;

/**传入带num位小数的数字字符串，返回字符加逗号的字符串*/
+(NSString *)addSign:(NSString *)aStr num:(int)num;

/** 根据小数位数整理字符串 加三位分割符","*/
+(NSString *)rangeFloatString:(NSString*)floatString withDecimalPlaces:(int)decimalPlaces;
/** 根据小数位数整理字符串 不加三位分割符*/
+(NSString *)rangeNumString:(NSString*)floatString withDecimalPlaces:(int)decimalPlaces;

/**转换时间格式，（1）intTime 要转化的格式 （2）intFormat 原格式   （3）要转换的格式  @"yyyy-MM-dd HH:mm:ss"*/
+(NSString *)timeTransform:(NSString*)intTime intFormat:(NSString*)intFormat  toFormat:(NSString*)toFormat;

/**
    计算分钟差
 */
+ (NSInteger)countTimeWithNewTime:(NSString *)newTime lastDate:(NSString *)lastTime;

/**计算日期差 返回结果为 int 传入时间格式 2015-05－05 10:12:55 返回结果 今天／昨天／2015-05－05
*/
+ (int)timeSysTime:(NSString *)sysTime createTime:(NSString*)createTime;


/**计算日期差 返回结果为 int 传入时间格式 2015-05－05 返回结果 今天／昨天／2015-05－05*/
+ (int)timeSysDateStr:(NSString *)sysTime createDateStr:(NSString*)createTime;

/**计算时间差 返回结果为 几分钟以前*/
+(NSString *)timeDifferNowdate:(NSDate*)newDate oldTime:(NSString*)oldTime;

/**设置字符串的属性并返回属性字符串*/
+(NSMutableAttributedString *)multiplicityText:(NSString *)aStr from:(int)fontFrom to:(int)fontTo font:(float)aFont;
+(NSMutableAttributedString *)mulFontText:(NSAttributedString *)mulStr from:(int)fontFrom to:(int)fontTo font:(float)aFont;

+(NSMutableAttributedString *)multiplicityText:(NSString *)aStr from:(int)colorFrom to:(int)colorTo color:(UIColor *)color;
+(NSMutableAttributedString *)multableText:(NSAttributedString *)mutableStr from:(int)colorFrom to:(int)colorTo color:(UIColor *)color;

+(NSMutableAttributedString *)mutableFontAndColorText:(NSString *)aStr from:(int)fontFrom to:(int)fontTo font:(float)Font from:(int)colorFrom to:(int)colorTo color:(UIColor *)Color;
//给UILabel设置行间距和字间距
+(NSDictionary *)setTextLineSpaceWithString:(NSString*)str withFont:(UIFont*)font withLineSpace:(CGFloat)lineSpace withTextlengthSpace:(NSNumber *)textlengthSpace paragraphSpacing:(CGFloat)paragraphSpacing;

/**根据字符串计算字符串宽度*/

+ (CGFloat)calculateTheHightOfText:(NSString *)text height:(CGFloat)height font:(UIFont*)font;

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

/**-计算UILabel的高度(带有行间距的情况)*/
+(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withLineSpace:(CGFloat)lineSpace size:(CGSize)textSize textlengthSpace:(NSNumber *)textlengthSpace paragraphSpacing:(CGFloat)paragraphSpacing;

+ (NSString *)stringFromDate:(NSDate *)date;
+ (BOOL)checkTel:(NSString *)str;
+ (NSString *)switchErrorMessage:(NSString * )str;

@end
