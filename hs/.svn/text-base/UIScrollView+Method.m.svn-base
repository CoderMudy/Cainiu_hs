//
//  UIScrollVIew+Method.m
//  CurveTest
//
//  Created by RGZ on 15/11/4.
//  Copyright © 2015年 cainiu. All rights reserved.
//

#import "UIScrollVIew+Method.h"

@implementation UIScrollView(Method)

//DataArray:str     fontArray:string      colorArray:redColor whiteColor
-(NSMutableAttributedString *)mutableFontAndColorArray:(NSMutableArray *)aDataArray fontArray:(NSMutableArray *)aFontArray colorArray:(NSMutableArray *)aColorArray
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
