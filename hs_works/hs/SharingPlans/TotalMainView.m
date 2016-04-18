//
//  TotalMainView.m
//  hs
//
//  Created by RGZ on 15/8/19.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "TotalMainView.h"
#import "TotalLineView.h"
#import "TimeSharingModel.h"
#import <QuartzCore/QuartzCore.h>

//横线右侧的长度
#define Line_Horizontal 35
#define label_tag   732

@implementation TotalMainView
{
    int         timeout;
    TotalLineView    *_lineV;
    float       pointY;
    //价位
    float       priceUpper;
    float       priceMiddle;
    float       priceLower;
    
    int         floatNum;//小数位
    
    BOOL        dayOrNight;//白天晚上
    
    int         num;//点数
    NSMutableDictionary     *_timeAndNumDictionary;//时间和点数数组
    NSMutableArray          *_timeArray;
    NSMutableArray          *_numArray;
    int                     baseLineNum;//基线数
    
    NSString                *_timeLine;//所有时间
    NSString                *_activityPrice;//分时图点实时动
}

-(instancetype)initWithFrame:(CGRect)frame PriceArray:(NSMutableArray *)aPriceArray FloatNum:(int)aFloatNum InfoDic:(NSMutableDictionary *)aInfoDic DayOrNight:(BOOL)aDayOrNight BaseLine:(int)aBaseLineNum{
    self = [super initWithFrame:frame];
    if (self) {
        baseLineNum = aBaseLineNum;
        _timeAndNumDictionary = aInfoDic;
        floatNum    = aFloatNum;
        dayOrNight  = aDayOrNight;
        
        [self calculateNumAndTime];//计算点数/分配时间
        
        self.priceArray = [NSMutableArray arrayWithArray:aPriceArray];
        [self loadUI];
    }
    
    return self;
}

-(void)loadUI{
    
    self.backgroundColor = Color_grayDeep;
    
    [self drawLineWithFrame:CGRectMake(5, 10, self.frame.size.width-10, 1)];
    [self rightLabelWithTag:100 CenterPointY:10];
    
    for (int i = 1; i < baseLineNum-1; i++) {
        [self drawLineWithFrame:CGRectMake(5, (self.frame.size.height-20)/(baseLineNum-1)*i+10, self.frame.size.width-10, 1)];
        [self rightLabelWithTag:100+i CenterPointY:(self.frame.size.height-20)/(baseLineNum-1)*i+10];
    }

    [self drawLineWithFrame:CGRectMake(5, self.frame.size.height-10, self.frame.size.width-10, 1)];
    [self rightLabelWithTag:100+baseLineNum-1 CenterPointY:self.frame.size.height-10];
    
    [self loadLineView];
}

-(void)calculateNumAndTime{
    
    NSString *isDayOrNightStr = @"";
    
    if (dayOrNight) {
        isDayOrNightStr = @"day";
    }
    else{
        isDayOrNightStr = @"night";
    }
    
    num = 0;
    _timeArray = [NSMutableArray arrayWithCapacity:0];
    _numArray = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i<[_timeAndNumDictionary[isDayOrNightStr][NUM_INDEXBUY] count]; i++) {
        [_numArray addObject:_timeAndNumDictionary[isDayOrNightStr][NUM_INDEXBUY][i]];
        num += [_timeAndNumDictionary[isDayOrNightStr][NUM_INDEXBUY][i] intValue];   //点数
    }
    
    for (int i = 0; i<[_timeAndNumDictionary[isDayOrNightStr][TIME_INDEXBUY] count]; i++) {
        [_timeArray addObject:_timeAndNumDictionary[isDayOrNightStr][TIME_INDEXBUY][i]];
    }
}

-(void)loadLineView{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    _lineV = [[TotalLineView alloc]initWithFrame:CGRectMake(5, 0, self.frame.size.width-10, self.frame.size.height) LineArray:array NumCount:num DayOrNight:dayOrNight];
    _lineV.backgroundColor = [UIColor clearColor];
    _lineV.userInteractionEnabled = YES;
    [self addSubview:_lineV];
    
    NSMutableArray *pointArray = [NSMutableArray arrayWithObjects:NSStringFromCGPoint(CGPointMake(0, self.frame.size.height/2)), nil];
    
    [_lineV addLine:pointArray];
    
}

-(void)setTimeLine:(NSString *)aTimeLineStr{
    _timeLine = aTimeLineStr;
}

//规范时间
-(NSMutableArray *)distributeTimeWithModelArray:(NSMutableArray *)aModelArray{
    NSMutableArray *timeLineArray = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *timeTmpArray = [_timeLine componentsSeparatedByString:@";"];
    NSMutableArray *timeArray = [NSMutableArray arrayWithArray:timeTmpArray];
    BOOL    isXHTimeConfiger = NO;
    //现货9：00-6：00
    for (int i = 0; i < timeArray.count ; i++) {
        if ([timeArray[i] isEqualToString:@""]) {
            [timeArray removeObjectAtIndex:i];
            break;
        }
    }
    if (timeArray.count == 2) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSDate *frontDate = [dateFormatter dateFromString:timeArray[0]];
        NSDate *betweenDate = [dateFormatter dateFromString:timeArray[1]];
        
        NSTimeInterval timeInterval  = [frontDate timeIntervalSinceDate:betweenDate];
        if (timeInterval > 0) {
            isXHTimeConfiger = YES;
        }
    }
    //非现货
    if (!isXHTimeConfiger) {
        if(dayOrNight) {
            //无晚盘合约处理
            if (!(_timeAndNumDictionary[@"night"] == nil || _timeAndNumDictionary[@"night"][@"time"] == nil || [_timeAndNumDictionary[@"night"][@"time"] isKindOfClass:[NSNull class]] || [_timeAndNumDictionary[@"night"][@"time"][0] isEqualToString:@""] || [_timeAndNumDictionary[@"night"][@"time"][0] length] < 4)) {
                for (int i = 0; i < timeArray.count - 2; i+=2) {
                    int beginTime = [[timeArray[i] stringByReplacingOccurrencesOfString:@":" withString:@""] intValue];
                    int endTime = [[timeArray[i+1] stringByReplacingOccurrencesOfString:@":" withString:@""] intValue];
                    
                    for (int j = beginTime; j <= endTime; j++) {
                        NSString  *timeStr = [NSString stringWithFormat:@"%d",j];
                        
                        if ([[timeStr substringFromIndex:timeStr.length-2] intValue] >= 60) {
                            continue;
                        }
                        
                        if (timeStr.length < 4) {
                            timeStr = [NSString stringWithFormat:@"0%@",timeStr];
                        }
                        [timeLineArray addObject:timeStr];
                    }
                }
            }
            else{
                for (int i = 0; i < timeArray.count - 1; i+=2) {
                    int beginTime = [[timeArray[i] stringByReplacingOccurrencesOfString:@":" withString:@""] intValue];
                    int endTime = [[timeArray[i+1] stringByReplacingOccurrencesOfString:@":" withString:@""] intValue];
                    
                    for (int j = beginTime; j <= endTime; j++) {
                        NSString  *timeStr = [NSString stringWithFormat:@"%d",j];
                        
                        if ([[timeStr substringFromIndex:timeStr.length-2] intValue] >= 60) {
                            continue;
                        }
                        
                        if (timeStr.length < 4) {
                            timeStr = [NSString stringWithFormat:@"0%@",timeStr];
                        }
                        [timeLineArray addObject:timeStr];
                    }
                }
            }
        }
        else{
            int beginTime = [[timeArray[timeArray.count-2] stringByReplacingOccurrencesOfString:@":" withString:@""] intValue];
            int endTime = [[timeArray[timeArray.count-1] stringByReplacingOccurrencesOfString:@":" withString:@""] intValue];
            
            BOOL timeafter12 = NO;
            
            if (timeArray[timeArray.count-1] != nil && [timeArray[timeArray.count-1] length] > 0) {
                if ([[timeArray[timeArray.count-1] substringToIndex:1] isEqualToString:@"2"]) {
                    timeafter12 = NO;
                }
                else{
                    timeafter12 = YES;
                }
            }
            //如果闭市时间超过12点
            if (timeafter12) {
                for (int j = beginTime; j <= 2359; j++) {
                    NSString  *timeStr = [NSString stringWithFormat:@"%d",j];
                    
                    if (timeStr != nil && timeStr.length >= 2 && [[timeStr substringFromIndex:timeStr.length-2] intValue] >= 60) {
                        continue;
                    }
                    
                    if (timeStr.length < 4) {
                        timeStr = [NSString stringWithFormat:@"0%@",timeStr];
                    }
                    [timeLineArray addObject:timeStr];
                }
                
                for (int j = 0000; j <= endTime; j++) {
                    NSString  *timeStr = [NSString stringWithFormat:@"%d",j];
                    
                    if (timeStr != nil && timeStr.length >= 2 &&[[timeStr substringFromIndex:timeStr.length-2] intValue] >= 60) {
                        continue;
                    }
                    
                    switch (timeStr.length) {
                        case 1:
                            timeStr = [NSString stringWithFormat:@"000%@",timeStr];
                            break;
                        case 2:
                            timeStr = [NSString stringWithFormat:@"00%@",timeStr];
                            break;
                        case 3:
                            timeStr = [NSString stringWithFormat:@"0%@",timeStr];
                            break;
                        case 0:
                            timeStr = [NSString stringWithFormat:@"0000"];
                            break;
                            
                        default:
                            break;
                    }
                    
                    [timeLineArray addObject:timeStr];
                }
            }
            else{
                for (int j = beginTime; j <= endTime; j++) {
                    NSString  *timeStr = [NSString stringWithFormat:@"%d",j];
                    
                    if ([[timeStr substringFromIndex:timeStr.length-2] intValue] >= 60) {
                        continue;
                    }
                    
                    if (timeStr.length < 4) {
                        timeStr = [NSString stringWithFormat:@"0%@",timeStr];
                    }
                    [timeLineArray addObject:timeStr];
                }
            }
        }
    }
    else{//现货
        int beginTime = [[timeArray[timeArray.count-2] stringByReplacingOccurrencesOfString:@":" withString:@""] intValue];
        int endTime = [[timeArray[timeArray.count-1] stringByReplacingOccurrencesOfString:@":" withString:@""] intValue];
        
        BOOL timeafter12 = NO;
        
        if (timeArray[timeArray.count-1] != nil && [timeArray[timeArray.count-1] length] > 0) {
            if ([[timeArray[timeArray.count-1] substringToIndex:1] isEqualToString:@"2"]) {
                timeafter12 = NO;
            }
            else{
                timeafter12 = YES;
            }
        }
        //如果闭市时间超过12点
        if (timeafter12) {
            for (int j = beginTime; j <= 2359; j++) {
                NSString  *timeStr = [NSString stringWithFormat:@"%d",j];
                
                if (timeStr != nil && timeStr.length >= 2 && [[timeStr substringFromIndex:timeStr.length-2] intValue] >= 60) {
                    continue;
                }
                
                if (timeStr.length < 4) {
                    timeStr = [NSString stringWithFormat:@"0%@",timeStr];
                }
                [timeLineArray addObject:timeStr];
            }
            
            for (int j = 0000; j <= endTime; j++) {
                NSString  *timeStr = [NSString stringWithFormat:@"%d",j];
                
                if (timeStr != nil && timeStr.length >= 2 &&[[timeStr substringFromIndex:timeStr.length-2] intValue] >= 60) {
                    continue;
                }
                
                switch (timeStr.length) {
                    case 1:
                        timeStr = [NSString stringWithFormat:@"000%@",timeStr];
                        break;
                    case 2:
                        timeStr = [NSString stringWithFormat:@"00%@",timeStr];
                        break;
                    case 3:
                        timeStr = [NSString stringWithFormat:@"0%@",timeStr];
                        break;
                    case 0:
                        timeStr = [NSString stringWithFormat:@"0000"];
                        break;
                        
                    default:
                        break;
                }
                
                [timeLineArray addObject:timeStr];
            }
        }
        else{
            for (int j = beginTime; j <= endTime; j++) {
                NSString  *timeStr = [NSString stringWithFormat:@"%d",j];
                
                if ([[timeStr substringFromIndex:timeStr.length-2] intValue] >= 60) {
                    continue;
                }
                
                if (timeStr.length < 4) {
                    timeStr = [NSString stringWithFormat:@"0%@",timeStr];
                }
                [timeLineArray addObject:timeStr];
            }
        }
    }



    NSMutableArray  *priceLineArray = [NSMutableArray arrayWithCapacity:0];

    for (int i = 0; i < timeLineArray.count; i++) {
        [priceLineArray addObject:@""];
    }

    for (int i = 0; i < aModelArray.count; i++) {
        TimeSharingModel    *model = aModelArray[i];
        NSString  *timeStr = @"";
        if (model.time.length >= 12) {
            timeStr = [[model.time substringFromIndex:8] substringToIndex:4];
        }
        for (int j = 0; j < timeLineArray.count; j++) {
            if ([timeStr isEqualToString:timeLineArray[j]]) {
                [priceLineArray replaceObjectAtIndex:j withObject:[DataUsedEngine conversionFloatNum:[model.price doubleValue] ExpectFloatNum:floatNum]];
                break;
            }
        }
    }

    return priceLineArray;
}

-(void)drawLineWithFrame:(CGRect)aRect{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:aRect];
    [self addSubview:imageView];
    
    
    UIGraphicsBeginImageContext(imageView.frame.size);   //开始画线
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    CGFloat lengths[] = {1,10};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1].CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 1);  //画虚线
    CGContextMoveToPoint(line, 0.0, 0.0);    //开始画线
    CGContextAddLineToPoint(line, aRect.size.width, 0.0);
    CGContextStrokePath(line);
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
}

-(void)rightLabelWithTag:(int)aTag CenterPointY:(CGFloat)aCenterY{
    UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-Line_Horizontal-5, 0, Line_Horizontal, 13)];
    rightLabel.center = CGPointMake(rightLabel.center.x, aCenterY-6);
    rightLabel.text = [DataUsedEngine conversionFloatNum:0.0 ExpectFloatNum:floatNum];
    rightLabel.font = [UIFont systemFontOfSize:8];
    rightLabel.tag = aTag;
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.textColor = [UIColor grayColor];
    [self addSubview:rightLabel];
}

-(void)setUpperAndLowerLimitsWithUpper:(float)aUpper Middle:(float)aMiddle Lower:(float)aLower{
    
    int upperTag = 100;
    int lowerTag = 100+baseLineNum-1;
    
    for (int i = 100; i<=lowerTag; i++) {
        UILabel *label = (UILabel *)[self viewWithTag:i];
        
        if (i == upperTag) {
            label.text = [DataUsedEngine conversionFloatNum:aUpper ExpectFloatNum:floatNum];
        }
        else if (i == lowerTag){
            label.text = [DataUsedEngine conversionFloatNum:aLower ExpectFloatNum:floatNum];
        }
        else{
            label.text = [DataUsedEngine conversionFloatNum:((aUpper-aLower)/(baseLineNum-1)*((baseLineNum-1) - (i-100))+aLower) ExpectFloatNum:floatNum];
        }
    }
    
    priceUpper = aUpper;
    priceMiddle = aMiddle;
    priceLower = aLower;
    
    if (self.priceArray.count != 0) {
        [self priceToPointWithPriceArray:self.priceArray];
    }
    
    [_lineV setUpperAndLowerLimitsWithUpper:aUpper Middle:aMiddle Lower:aLower];
}

#pragma mark Price
//分时图点实时动处理
-(void)addPrice:(NSString *)aPrice{
    _activityPrice = [DataUsedEngine conversionFloatNum:[aPrice floatValue] ExpectFloatNum:floatNum];
    [self priceToPointWithPriceArray:_priceArray];
}

-(void)setPriceModelArray:(NSMutableArray *)aModelArray{
    //当前价初始化
    _activityPrice = @"";
    _priceArray = [self distributeTimeWithModelArray:aModelArray];//规范时间
    
    [self priceToPointWithPriceArray:_priceArray];
}

//必须要有价位才可调用计算
-(void)priceToPointWithPriceArray:(NSMutableArray *)aPriceArray{
    
    NSMutableArray *pointArray = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableArray  *priceArrayTmp = [NSMutableArray arrayWithArray:aPriceArray];
    //当前价显示
    if (_activityPrice != nil && ![_activityPrice isEqualToString:@""]) {
//        for (int i = (int)priceArrayTmp.count-1; i >= 0; i--) {
//            if (![priceArrayTmp[priceArrayTmp.count-1] isEqualToString:@""]) {
//                break;
//            }
//            else{
//                if (![priceArrayTmp[i] isEqualToString:@""]) {
//                    [priceArrayTmp replaceObjectAtIndex:i withObject:_activityPrice];
//                    break;
//                }
//            }
//        }
        for (NSInteger i = priceArrayTmp.count-1; i >= 0; i--) {
            if (![priceArrayTmp[i] isEqualToString:@""]) {
                if (i+1 < priceArrayTmp.count) {
                    [priceArrayTmp replaceObjectAtIndex:i+1 withObject:_activityPrice];
                }
                break;
            }
        }
    }
    
    for (int i = 0; i<priceArrayTmp.count; i++) {
        
        if ([priceArrayTmp[i] isEqualToString:@""]) {
            continue;
        }
        
        float priceCurrent = [priceArrayTmp[i] floatValue];
        
        float y = (self.frame.size.height-20) * (1 - ((priceCurrent - priceLower)/(priceUpper - priceLower))) + 10;
        
        float x = i * ((_lineV.frame.size.width*1)/num);
        
        CGPoint point = CGPointMake(x, y);
        
        [pointArray addObject:NSStringFromCGPoint(point)];
    }
    
    
    [_lineV addLine:pointArray];
}

#pragma mark Time

//时间轴
-(void)setDayOrNight:(BOOL)aDayorNight{
    dayOrNight = aDayorNight;
    [self calculateNumAndTime];//计算点数
    
    [_lineV setNumCount:num];
    [self loadTimeLabel];
}


//时间轴
-(void)loadTimeLabel{
    
    for (int i = 0; i < _timeArray.count; i++) {
        UILabel *label = (UILabel *)[self viewWithTag:label_tag + i];
        if (label != nil) {
            [label removeFromSuperview];
        }
    }
    
    NSMutableArray  *pointArray = [NSMutableArray arrayWithCapacity:0];
    
    if (_timeArray.count > 2) {
        [pointArray addObject:NSStringFromCGPoint(CGPointMake(13+5, self.frame.size.height+5))];
        for (int i = 0; i < _numArray.count-1; i++) {
            if (i>0) {
                int otherNumCount = 0;
                for (int j = 0;  j <= i - j + 1 ; j++) {
                    otherNumCount += [_numArray[j] intValue];
                }
                [pointArray addObject:NSStringFromCGPoint(CGPointMake(_lineV.frame.size.width/num*(otherNumCount+3), self.frame.size.height+5))];
            }
            else{
                [pointArray addObject:NSStringFromCGPoint(CGPointMake(_lineV.frame.size.width/num*([_numArray[i] intValue]+3), self.frame.size.height+5))];
            }
        }
        [pointArray addObject:NSStringFromCGPoint(CGPointMake(_lineV.frame.size.width-8, self.frame.size.height+5))];
    }
    else{
        [pointArray addObject:NSStringFromCGPoint(CGPointMake(13+5, self.frame.size.height+5))];
        [pointArray addObject:NSStringFromCGPoint(CGPointMake(_lineV.frame.size.width-8, self.frame.size.height+5))];
    }
    
    for (int i = 0; i<_timeArray.count; i++) {
        UILabel *newLabelOne = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 15)];
        newLabelOne.textColor = Color_Gold;
        newLabelOne.textAlignment = NSTextAlignmentCenter;
        newLabelOne.font = [UIFont systemFontOfSize:9];
        newLabelOne.tag = label_tag + i;
        newLabelOne.text = _timeArray[i];
        CGPoint point = CGPointFromString(pointArray[i]);
        newLabelOne.center = point;
        [self addSubview:newLabelOne];
    }
}

-(void)setLastTimeLineString:(NSString *)aLastTimeLineString{
    NSMutableArray  *pointArray = [NSMutableArray arrayWithCapacity:0];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(_lineV.frame.size.width-8-10, self.frame.size.height+5))];
    
    UILabel *newLabelOne = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 45, 15)];
    newLabelOne.textColor = Color_Gold;
    newLabelOne.textAlignment = NSTextAlignmentCenter;
    newLabelOne.font = [UIFont systemFontOfSize:9];
    newLabelOne.tag = label_tag + 1;
    newLabelOne.text = aLastTimeLineString;
    CGPoint point = CGPointFromString(pointArray[0]);
    newLabelOne.center = point;
    [self addSubview:newLabelOne];
}

@end
