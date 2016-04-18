//
//  Helper.m
//  hs
//
//  Created by PXJ on 15/4/23.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+ (NSMutableDictionary *)getParams:(NSString *)aParamsStr{
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSArray *carveArray = [aParamsStr componentsSeparatedByString:@"&"];
    for (int i = 0; i < carveArray.count; i++) {
        NSArray *array =[carveArray[i] componentsSeparatedByString:@"="];
        if (array.count >= 2) {
            [paramsDic setObject:array[1] forKey:array[0]];
        }
    }
    return paramsDic;
}




#pragma mark - InterpolatedUIImage=因为生成的二维码是一个CIImage，我们直接转换成UIImage的话大小不好控制，所以使用下面方法返回需要大小的UIImage
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - QRCodeGenerator--首先是二维码的生成，使用CIFilter很简单，直接传入生成二维码的字符串即可
+ (CIImage *)createQRForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}




#pragma mark UIImageView加圆形边框

+(UIImageView*)imageCutView:(UIImageView*)imgV cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth color:(UIColor*)color;
{

    imgV.layer.cornerRadius = cornerRadius;
    imgV.layer.masksToBounds = YES;
    imgV.layer.borderWidth = borderWidth;
    imgV.layer.borderColor = [UIColor whiteColor].CGColor;
    return imgV;
}

#pragma mark 获得随机数)
+(NSString *)randomGet
{
    
    int num = arc4random()%9999;
    return [NSString stringWithFormat:@"%d",num];
}
#pragma mark 转换json字符串
+(NSString *)toJSON:(id)aParam
{
    NSData   *jsonData=[NSJSONSerialization dataWithJSONObject:aParam options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}
#pragma mark 字符串转字典
+(NSDictionary *)dicWithJSonStr:(NSString *)jsonString
{
    NSData * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
     NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    return dic;
    
}

+ (NSString *)judgeStr:(id)str
{
    NSString *str1 = [NSString stringWithFormat:@"%@",str];
    if ([str1 isEqualToString:@"<null>"]) {
        return @"";
    }
    else
    {
        return [Helper isNullString:str1] != 0?@"":str1;
    }
}
+ (BOOL)isNullString:(NSString *)string
{
    if(string == nil){
        return YES;
    }
    
    if ((NSNull *)string == [NSNull null]) {
        return YES;
    }
    
    string = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([string length] == 0){
        return YES;
    }
    return NO;
}
#pragma mark 判断期货单位
+ (NSString*)unitWithCurrency:(NSString*)currency
{

    NSString * unit;
        if ([currency isEqualToString:@"USD"])//美元
        {
            unit = @"美元";
            
        }else if([currency isEqualToString:@"CNY"])//人民币
        {
            unit = @"元";
            
        }else if([currency isEqualToString:@"SGD"])//新加坡币
        {
            unit = @"元";
            
        }else if([currency isEqualToString:@"HKD"])//港元
        {
            unit = @"港元";
            
        }else{
        unit = @"元";
        }
    return unit;
}
#pragma mark 金额加‘，’
//传入整数类型的数值
+(NSString *)countNumChangeformat:(NSString *)num
{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3)
    {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}

#pragma mark 传入小数位为两位的数值  (1) aStr: 传入字符串 （2）num: 小数位数
+(NSString *)addSign:(NSString *)aStr num:(int)num
{
    
    NSString *point;
    NSString *money;
    if (num==0) {
        return [Helper countNumChangeformat:aStr];
    }else{
        point =[aStr substringFromIndex:aStr.length-num-1];
        money =[aStr substringToIndex:aStr.length-num-1];
        return [[Helper countNumChangeformat:money] stringByAppendingString:point];
    }
}


#pragma mark 根据小数位数整理字符串加三位分割符“，”
+(NSString *)rangeFloatString:(NSString*)floatString withDecimalPlaces:(int)decimalPlaces;
{
    NSString * floatStr;
    float value = floatString.doubleValue;
    NSString * str = @"";
    if (value>=100000||value<=-100000) {
        str = @"万";
        floatString = [NSString stringWithFormat:@"%f",floatString.floatValue/10000];
    }
    
    switch (decimalPlaces) {
        case 0:
        {
            floatStr = [NSString stringWithFormat:@"%.0f",floatString.floatValue];
        }
            break;
        case 1:
        {
            floatStr = [NSString stringWithFormat:@"%.1f",floatString.floatValue];
        }
            break;
        case 2:
        {
            floatStr = [NSString stringWithFormat:@"%.2f",floatString.floatValue];
        }
            break;
        case 3:
        {
            floatStr = [NSString stringWithFormat:@"%.3f",floatString.floatValue];
        }
            break;
        case 4:
        {
            floatStr = [NSString stringWithFormat:@"%.4f",floatString.floatValue];
        }
            break;
        case 5:
        {
            floatStr = [NSString stringWithFormat:@"%.5f",floatString.floatValue];
        }
            break;
        default:
            break;
    }
    floatStr = [Helper addSign:floatStr num:decimalPlaces];
    return [floatStr stringByAppendingString:str];
}




#pragma mark 根据小数位数整理字符串 不加三位分割符 过十万不加万单位
+(NSString *)rangeNumString:(NSString*)floatString withDecimalPlaces:(int)decimalPlaces;
{
    NSString * floatStr;
//    float value = floatString.doubleValue;
//    NSString * str = @"";
//    if (value>=100000||value<=-100000) {
//        str = @"万";
//        floatString = [NSString stringWithFormat:@"%f",floatString.floatValue/10000];
//    }
    
    switch (decimalPlaces) {
        case 0:
        {
            floatStr = [NSString stringWithFormat:@"%.0f",floatString.floatValue];
        }
            break;
        case 1:
        {
            floatStr = [NSString stringWithFormat:@"%.1f",floatString.floatValue];
        }
            break;
        case 2:
        {
            floatStr = [NSString stringWithFormat:@"%.2f",floatString.floatValue];
        }
            break;
        case 3:
        {
            floatStr = [NSString stringWithFormat:@"%.3f",floatString.floatValue];
        }
            break;
        case 4:
        {
            floatStr = [NSString stringWithFormat:@"%.4f",floatString.floatValue];
        }
            break;
        case 5:
        {
            floatStr = [NSString stringWithFormat:@"%.5f",floatString.floatValue];
        }
            break;
        default:
            break;
    }
    return floatStr;
}

#pragma mark 转换时间格式，（1）intTime 要转化的格式 （2）intFormat 原格式   （3）要转换的格式  @"yyyy-MM-dd HH:mm:ss"

+(NSString *)timeTransform:(NSString*)intTime intFormat:(NSString*)intFormat  toFormat:(NSString*)toFormat
{

    NSDateFormatter * intF = [[NSDateFormatter alloc]init];
    [intF setDateFormat:intFormat];
    
    NSDateFormatter * toF = [[NSDateFormatter alloc] init];
    [toF setDateFormat:toFormat];
    
    NSDate * timeDate = [intF dateFromString:intTime];
    NSString * toTime = [toF stringFromDate:timeDate];
    
    return toTime;

}

#pragma mark 计算时间

+(NSString *)timeDifferNowdate:(NSDate*)newDate oldTime:(NSString*)oldTime
{
    ;
    NSDateFormatter * dm = [[NSDateFormatter alloc]init];
    //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
    [dm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * oldDate = [dm dateFromString:oldTime];
    long dd = (long)[newDate timeIntervalSince1970] - [oldDate timeIntervalSince1970];
    NSString *timeString=@"";
    if (dd/300<1)
    {
        timeString=[NSString stringWithFormat:@"刚刚"];
    }else
    if (dd/3600<1)
    {
        timeString = [NSString stringWithFormat:@"%ld", dd/60];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }else
    if (dd/3600>=1&&dd/86400<1)
    {
        timeString = [NSString stringWithFormat:@"%ld", dd/3600];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }else
    if (dd/86400>=1)
    {
        
       [dm setDateFormat:@"yyyy-MM-dd"];
        timeString = [dm stringFromDate:oldDate];
    }
    
    
    return timeString;
}
//返回分钟差
+ (NSInteger)countTimeWithNewTime:(NSString *)newTime lastDate:(NSString *)lastTime
{
    NSDateFormatter * forMatter = [[NSDateFormatter alloc]init];
    [forMatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate * newDate = [forMatter dateFromString:newTime];
    NSDate * lastDate = [forMatter dateFromString:lastTime];

    long dd = (long)[newDate timeIntervalSince1970] - [lastDate timeIntervalSince1970];
    return (NSInteger)dd;
}

//返回天数
+ (int)timeSysTime:(NSString *)sysTime createTime:(NSString*)createTime
{

    NSDateFormatter * dm = [[NSDateFormatter alloc]init];
    [dm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDateFormatter * ds = [[NSDateFormatter alloc]init];
    [ds setDateFormat:@"yyyy-MM-dd"];
    NSDate * sysDate = [dm dateFromString:sysTime];
    NSString * sysStr = [ds stringFromDate:sysDate];
    sysStr = [NSString stringWithFormat:@"%@ 00:00:00",sysStr];
    sysDate = [dm dateFromString:sysStr];
    
    NSDate * createDate = [dm dateFromString:createTime];
    NSString * createStr = [ds stringFromDate:createDate];
    createStr = [NSString stringWithFormat:@"%@ 00:00:00",createStr];
    createDate=[dm dateFromString:createStr];
    
     long dd = (long)[sysDate timeIntervalSince1970] - [createDate timeIntervalSince1970];
    if (dd/86400>=1) {
        
    }
    return (int)dd/86400;
}


//返回相差天数
+ (int)timeSysDateStr:(NSString *)sysTime createDateStr:(NSString*)createTime
{
    
    
    NSDateFormatter * dm = [[NSDateFormatter alloc]init];
    [dm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDateFormatter * ds = [[NSDateFormatter alloc]init];
    [ds setDateFormat:@"yyyy-MM-dd"];
    NSDate * sysDate = [ds dateFromString:sysTime];
    NSString * sysStr = [ds stringFromDate:sysDate];
    sysStr = [NSString stringWithFormat:@"%@ 00:00:00",sysStr];
    sysDate = [dm dateFromString:sysStr];
    
    NSDate * createDate = [ds dateFromString:createTime];
    NSString * createStr = [ds stringFromDate:createDate];
    createStr = [NSString stringWithFormat:@"%@ 00:00:00",createStr];
    createDate=[dm dateFromString:createStr];
    
    long dd = (long)[sysDate timeIntervalSince1970] - [createDate timeIntervalSince1970];
    if (dd/86400>=1) {
        
    }
    return (int)dd/86400;
}




+ (NSString*)numberOfDaysFromTodayByTime:(NSDate *)newDate timeStringFormat:(NSString *)oldTime
{
    
    
    //(NSInteger)numberOfDaysFromTodayByTime:(NSString *)time timeStringFormat:(NSString *)format
    NSDateFormatter * dm = [[NSDateFormatter alloc]init];
    //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
    [dm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * oldDate = [dm dateFromString:oldTime];
    long dd = (long)[newDate timeIntervalSince1970] - [oldDate timeIntervalSince1970];
    NSString *timeString=[oldTime componentsSeparatedByString:@" "][0];
    if (dd/86400<1)
    {
        timeString=@"今天";
    }//    NSLog(@"=====%@",timeString);
    return timeString;
}
//给UILabel设置行间距和字间距
+(NSDictionary *)setTextLineSpaceWithString:(NSString*)str withFont:(UIFont*)font withLineSpace:(CGFloat)lineSpace withTextlengthSpace:(NSNumber *)textlengthSpace paragraphSpacing:(CGFloat)paragraphSpacing{

    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpace; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSParagraphStyleAttributeName:paraStyle,
                          NSKernAttributeName:textlengthSpace
                          };
//    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str attributes:dic];
//    label.attributedText = attributeStr;
    return dic;
}



#pragma mark - 根据字符串计算字符串宽度
+ (CGFloat)calculateTheHightOfText:(NSString *)text height:(CGFloat)height font:(UIFont*)font
{
    CGFloat width = 0.0;
    NSDictionary *dicParam = @{NSFontAttributeName:font};
    CGRect rect = CGRectMake(0, 0, 0, 0);
    rect = [text  boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicParam context:nil];
    
    width = rect.size.width;
    
    dicParam = nil;
    return width;
}

#pragma mark -计算UILabel的高度(带有行间距的情况)
+(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withLineSpace:(CGFloat)lineSpace size:(CGSize)textSize textlengthSpace:(NSNumber *)textlengthSpace paragraphSpacing:(CGFloat)paragraphSpacing{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpace;
    paraStyle.paragraphSpacing = paragraphSpacing;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSParagraphStyleAttributeName:paraStyle,
                          NSKernAttributeName:textlengthSpace
                          };
    CGSize size = [str boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

#pragma mark - 根据字符串计算字符串的高度和宽度
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


//属性字符串字号
+(NSMutableAttributedString *)multiplicityText:(NSString *)aStr from:(int)fontFrom to:(int)fontTo font:(float)aFont
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:aStr];
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:aFont] range:NSMakeRange(fontFrom, fontTo)];
    
    return str;
}

//属性字符串字号
+(NSMutableAttributedString *)mulFontText:(NSAttributedString *)mulStr from:(int)fontFrom to:(int)fontTo font:(float)aFont
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:mulStr];
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:aFont] range:NSMakeRange(fontFrom, fontTo)];
    
    return str;
}



//属性字符串颜色
+(NSMutableAttributedString *)multiplicityText:(NSString *)aStr from:(int)colorFrom to:(int)colorTo color:(UIColor *)color
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:aStr];
    
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(colorFrom,colorTo)];
    
    return str;
}
//属性字符串颜色传入可变字符串；
+(NSMutableAttributedString *)multableText:(NSAttributedString *)mutableStr from:(int)colorFrom to:(int)colorTo color:(UIColor *)color;
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:mutableStr];
    
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(colorFrom,colorTo)];
    return str;
}


+(NSMutableAttributedString *)mutableFontAndColorText:(NSString *)aStr from:(int)fontFrom to:(int)fontTo font:(float)Font from:(int)colorFrom to:(int)colorTo color:(UIColor *)Color
{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:aStr];
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:Font] range:NSMakeRange(fontFrom, fontTo)];
    
    NSMutableAttributedString * mulStr = [[NSMutableAttributedString alloc] initWithAttributedString:str];
    [mulStr addAttribute:NSForegroundColorAttributeName value:Color range:NSMakeRange(colorFrom, colorTo)];
    
    
    
    
    return mulStr;
    
}
//时间转字符串

+ (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    
    return destDateString;
    
}

+ (BOOL)checkTel:(NSString *)str
{
    
    
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9])|(17[7]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (isMatch == NO) {
        return NO;
    }
    return YES;
    
}
+ (NSString *)switchErrorMessage:(NSString * )str
{
    NSString * errorMessage = nil;
    
    
    NSString *errorStr = str;
    NSScanner *scanner = [NSScanner scannerWithString:errorStr];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int number;
    [scanner scanInt:&number];
    
    
    switch (number) {
        case 200:
        {
            errorMessage = @"请求响应成功";
            
        }
            break;
        case 400:
        {
            errorMessage = @"访问被禁止";
            
        }
            break;
        case 401:
        {
            errorMessage = @"登录受限";
            
        }
            break;
        case 404:
        {
            errorMessage = @"资源定位失败";
            
        }
            break;
        case 406:
        {
            errorMessage = @"请求参数有错";
            
        }
            break;
        case 412:
        {
            errorMessage = @"绘画过期";
            
        }
            break;
        case 500:
        {
            errorMessage = @"服务器请求处理失败";
            
        }
            break;
        case 505:
        {
            errorMessage = @"服务器错误";
            
        }
            break;
        case 999:
        {
            errorMessage = @"未知错误";
            
        }
            break;
            
            
        default:
        {
            errorMessage = str;
            
        }
            break;
    }
    
    
    
    
    return errorMessage;
    
    
}

@end
