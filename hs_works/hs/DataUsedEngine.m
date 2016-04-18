//
//  DataUsedEngine.m
//  hs
//
//  Created by RGZ on 15/10/28.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "DataUsedEngine.h"

@implementation DataUsedEngine

#pragma mark 小数位转换

+(NSString *)conversionFloatNum:(float)aFloat ExpectFloatNum:(int)aFloatNum;{
    NSString  *resultStr = @"";
    if (aFloatNum == 0) {
        resultStr = [NSString stringWithFormat:@"%.0f",aFloat];
    }
    else if (aFloatNum == 1){
        resultStr = [NSString stringWithFormat:@"%.1f",aFloat];
    }
    else if (aFloatNum == 2){
        resultStr = [NSString stringWithFormat:@"%.2f",aFloat];
    }
    return resultStr;
}

+(NSDate *)timeZoneChange:(NSDate *)aOldDate{
    NSTimeZone *zoneCurrent = [NSTimeZone systemTimeZone];
    NSInteger intervalCurrentFront = [zoneCurrent secondsFromGMTForDate: aOldDate];
    NSDate *newDate = [aOldDate  dateByAddingTimeInterval: intervalCurrentFront];
    return newDate;
}

//DataArray:str     fontArray:string      colorArray:redColor whiteColor
+(NSMutableAttributedString *)mutableFontAndColorArrayAddDeleteLine:(NSMutableArray *)aDataArray fontArray:(NSMutableArray *)aFontArray colorArray:(NSMutableArray *)aColorArray
{
    NSMutableAttributedString * mulStr;
    
    if ((aFontArray != nil && aFontArray.count > 0) && (aColorArray != nil && aColorArray.count > 0)) {
        NSString    *allStr = @"";
        for (int i = 0; i < aDataArray.count; i++) {
            allStr = [allStr stringByAppendingString:aDataArray[i]];
        }
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allStr];
        for (int i = 0; i < aDataArray.count; i++) {
            
            int font = [aFontArray[i] intValue];
            
            UIColor* color= nil;
            NSArray *floatArray = [aColorArray[i] componentsSeparatedByString:@"/"];
            color = [UIColor colorWithRed:[floatArray[0] floatValue]/255.0 green:[floatArray[1] floatValue]/255.0 blue:[floatArray[2] floatValue]/255.0 alpha:[floatArray[3] floatValue]];
            
            if(i == 0){
                
                int from = 0;
                
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:font] range:NSMakeRange(from, [aDataArray[i] length])];
                [str addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(from, [aDataArray[i] length])];
                
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(from,[aDataArray[i] length])];
                
                mulStr = [[NSMutableAttributedString alloc] initWithAttributedString:str];
                [mulStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(from, [aDataArray[i] length])];
                
                str = [[NSMutableAttributedString alloc] initWithAttributedString:mulStr];;
            }
            else{
                int from = 0;
                
                for (int j = 0; j <= i-1 ; j++) {
                    from += [aDataArray[j] length];
                }
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:font] range:NSMakeRange(from, [aDataArray[i] length])];
                
                mulStr = [[NSMutableAttributedString alloc] initWithAttributedString:str];
                [mulStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(from, [aDataArray[i] length])];
                
                str = [[NSMutableAttributedString alloc] initWithAttributedString:mulStr];;
            }
        }
    }
    else if (aFontArray != nil && aFontArray.count > 0){
        NSString    *allStr = @"";
        for (int i = 0; i < aDataArray.count; i++) {
            allStr = [allStr stringByAppendingString:aDataArray[i]];
        }
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allStr];
        for (int i = 0; i < aDataArray.count-1; i++) {
            
            int font = [aFontArray[i] intValue];
            
            if(i == 0){
                int from = 0;
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:font] range:NSMakeRange(from, [aDataArray[i] length])];
            }
            else{
                int from = 0;
                for (int j = 0; j <= i-1 ; j++) {
                    from += [aDataArray[j] length];
                }
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:font] range:NSMakeRange(from, [aDataArray[i] length])];
            }
        }
    }
    else if (aColorArray != nil && aColorArray.count > 0){
        NSString    *allStr = @"";
        for (int i = 0; i < aDataArray.count; i++) {
            allStr = [allStr stringByAppendingString:aDataArray[i]];
        }
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allStr];
        for (int i = 0; i < aDataArray.count-1; i++) {
            UIColor* color= nil;
            NSArray *floatArray = [aColorArray[i] componentsSeparatedByString:@"/"];
            color = [UIColor colorWithRed:[floatArray[0] floatValue]/255.0 green:[floatArray[1] floatValue]/255.0 blue:[floatArray[2] floatValue]/255.0 alpha:[floatArray[3] floatValue]];
            
            if(i == 0){
                int from = 0;
                [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(from, [aDataArray[i] length])];
                
                mulStr = [[NSMutableAttributedString alloc] initWithAttributedString:str];
                
                str = [[NSMutableAttributedString alloc] initWithAttributedString:mulStr];;
            }
            else{
                int from = 0;
                for (int j = 0; j <= i-1 ; j++) {
                    from += [aDataArray[j] length];
                }
                [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(from, [aDataArray[i] length])];
                
                mulStr = [[NSMutableAttributedString alloc] initWithAttributedString:str];
                [mulStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(from, [aDataArray[i] length])];
                
                str = [[NSMutableAttributedString alloc] initWithAttributedString:mulStr];;
            }
        }
    }
    return mulStr;
}

//DataArray:str     fontArray:string      colorArray:redColor whiteColor
+(NSMutableAttributedString *)mutableFontAndColorArray:(NSMutableArray *)aDataArray fontArray:(NSMutableArray *)aFontArray colorArray:(NSMutableArray *)aColorArray
{
    NSMutableAttributedString * mulStr;
    
    if ((aFontArray != nil && aFontArray.count > 0) && (aColorArray != nil && aColorArray.count > 0)) {
        NSString    *allStr = @"";
        for (int i = 0; i < aDataArray.count; i++) {
            allStr = [allStr stringByAppendingString:aDataArray[i]];
        }
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allStr];
        for (int i = 0; i < aDataArray.count-1; i++) {
            
            int font = [aFontArray[i] intValue];
            
            UIColor* color= nil;
            NSArray *floatArray = [aColorArray[i] componentsSeparatedByString:@"/"];
            color = [UIColor colorWithRed:[floatArray[0] floatValue]/255.0 green:[floatArray[1] floatValue]/255.0 blue:[floatArray[2] floatValue]/255.0 alpha:[floatArray[3] floatValue]];
            
            if(i == 0){
                
                int from = 0;
                
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:font] range:NSMakeRange(from, [aDataArray[i] length])];
                
                mulStr = [[NSMutableAttributedString alloc] initWithAttributedString:str];
                [mulStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(from, [aDataArray[i] length])];
                
                str = [[NSMutableAttributedString alloc] initWithAttributedString:mulStr];;
            }
            else{
                int from = 0;
                
                for (int j = 0; j <= i-1 ; j++) {
                    from += [aDataArray[j] length];
                }
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:font] range:NSMakeRange(from, [aDataArray[i] length])];
                
                mulStr = [[NSMutableAttributedString alloc] initWithAttributedString:str];
                [mulStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(from, [aDataArray[i] length])];
                
                str = [[NSMutableAttributedString alloc] initWithAttributedString:mulStr];;
            }
        }
    }
    else if (aFontArray != nil && aFontArray.count > 0){
        NSString    *allStr = @"";
        for (int i = 0; i < aDataArray.count; i++) {
            allStr = [allStr stringByAppendingString:aDataArray[i]];
        }
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allStr];
        for (int i = 0; i < aDataArray.count-1; i++) {
            
            int font = [aFontArray[i] intValue];
            
            if(i == 0){
                int from = 0;
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:font] range:NSMakeRange(from, [aDataArray[i] length])];
            }
            else{
                int from = 0;
                for (int j = 0; j <= i-1 ; j++) {
                    from += [aDataArray[j] length];
                }
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:font] range:NSMakeRange(from, [aDataArray[i] length])];
            }
        }
    }
    else if (aColorArray != nil && aColorArray.count > 0){
        NSString    *allStr = @"";
        for (int i = 0; i < aDataArray.count; i++) {
            allStr = [allStr stringByAppendingString:aDataArray[i]];
        }
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allStr];
        for (int i = 0; i < aDataArray.count-1; i++) {
            UIColor* color= nil;
            NSArray *floatArray = [aColorArray[i] componentsSeparatedByString:@"/"];
            color = [UIColor colorWithRed:[floatArray[0] floatValue]/255.0 green:[floatArray[1] floatValue]/255.0 blue:[floatArray[2] floatValue]/255.0 alpha:[floatArray[3] floatValue]];
            
            if(i == 0){
                int from = 0;
                [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(from, [aDataArray[i] length])];
                
                mulStr = [[NSMutableAttributedString alloc] initWithAttributedString:str];
                
                str = [[NSMutableAttributedString alloc] initWithAttributedString:mulStr];;
            }
            else{
                int from = 0;
                for (int j = 0; j <= i-1 ; j++) {
                    from += [aDataArray[j] length];
                }
                [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(from, [aDataArray[i] length])];
                
                mulStr = [[NSMutableAttributedString alloc] initWithAttributedString:str];
                [mulStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(from, [aDataArray[i] length])];
                
                str = [[NSMutableAttributedString alloc] initWithAttributedString:mulStr];;
            }
        }
    }
    return mulStr;
}

+(NSMutableAttributedString *)mutableFontArray:(NSMutableArray *)aDataArray fontArray:(NSMutableArray *)aFontArray{
    
    NSMutableAttributedString *str      = nil;
    NSMutableAttributedString *mulStr   = nil;
    NSString                  *allStr   = @"";
    for (int i = 0; i < aDataArray.count; i++) {
        allStr = [NSString stringWithFormat:@"%@%@",allStr,aDataArray[i]];
    }
    str = [[NSMutableAttributedString alloc]initWithString:allStr];
    
    for (int i = 0; i < aDataArray.count; i++) {
        if (i != 0) {
            str = [[NSMutableAttributedString alloc]initWithAttributedString:mulStr];
        }
        int from = 0;
        int to   = (int)[aDataArray[0] length];
        if (i-1 >= 0) {
            from = 0;
            to   = (int)[aDataArray[i] length];
            for (int j = 0; j < i; j++) {
                from += (int)[aDataArray[j] length];
            }
        }
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:[aFontArray[i] intValue]] range:NSMakeRange(from, to)];
        mulStr = [[NSMutableAttributedString alloc]initWithAttributedString:str];
    }
    return str;
}

+ ( CGSize )getStringRectWithString:( NSString *)aString Font:(int)aFont Width:(float)aWidth Height:(float)aHeight
{
    CGRect rect;
//    NSAttributedString * atrString = [[ NSAttributedString alloc ]  initWithString :aString];
//    NSRange  range =  NSMakeRange ( 0 , atrString. length );
//    NSDictionary * dic = [atrString  attributesAtIndex : 0   effectiveRange :&range];
//    size=[aString boundingRectWithSize:CGSizeMake(aWidth, aHeight)
//                               options:NSStringDrawingUsesLineFragmentOrigin
//                            attributes:dic
//                               context:nil].size;
//    size = [aString sizeWithFont:[UIFont systemFontOfSize:aFont] constrainedToSize:CGSizeMake(aWidth, aHeight) lineBreakMode:UILineBreakModeWordWrap];
    rect = [aString boundingRectWithSize:CGSizeMake(aWidth, aHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:aFont]} context:nil];
    
    CGSize size = rect.size;
    
    return   size;
}

+(UIWindow *)getWindow{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSArray * array = [[UIApplication sharedApplication] windows];
    if (array.count >= 2) {
        window = [array objectAtIndex:1];
    }
    
    return window;
}

+(NSString *)nullTrimString:(id)aID{
    if (aID != nil && ![aID isKindOfClass:[NSNull class]] && ![[NSString stringWithFormat:@"%@",aID] isEqualToString:@"(null)"]) {
        return [NSString stringWithFormat:@"%@",aID];
    }
    else{
        return @"";
    }
}

+(NSString *)nullTrimString:(id)aID expectString:(NSString *)aString{
    if (aID != nil && ![aID isKindOfClass:[NSNull class]] && ![[NSString stringWithFormat:@"%@",aID] isEqualToString:@"(null)"]) {
        return [NSString stringWithFormat:@"%@",aID];
    }
    else{
        return aString;
    }
}

+(BOOL)nullTrim:(id)aID{
    if (aID != nil && ![aID isKindOfClass:[NSNull class]] && ![[NSString stringWithFormat:@"%@",aID] isEqualToString:@"(null)"] && ![[NSString stringWithFormat:@"%@",aID] isEqualToString:@"<null>"]) {
        return YES;
    }
    else{
        return NO;
    }
}

//json字符串装换成json对象
+ (id)toJsonObjectWithJsonString:(NSString *)jsonStr
{
    NSData* data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = nil;
    if (data == nil) {
        return nil;
    }
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions
                                                  error:&error];
    //如果解析过程出错，显示错误
    if (error != nil) {
//        NSString *errCode = [NSString stringWithFormat:@"%ld",(long)error.code];
//        NSString *errMsg = [NSString stringWithFormat:@"解析出错，检查json格式: %@",error.localizedDescription];
//        NSArray *array = [NSArray arrayWithObjects:errCode,errMsg,nil];
        return nil;
    }
    return result;
}

//json对象转换成json字符串
+ (NSString *)toJsonStringWithJsonObject:(id)jsonObject{
    NSData *result = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                     options:kNilOptions
                                                       error:nil];
    return [[NSString alloc] initWithData:result
                                 encoding:NSUTF8StringEncoding];
}

@end
