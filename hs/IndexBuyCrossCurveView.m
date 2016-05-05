//
//  IndexBuyCrossCurveView.m
//  hs
//
//  Created by RGZ on 15/10/21.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "IndexBuyCrossCurveView.h"

@implementation IndexBuyCrossCurveView
{
    UIView      *_horizontalLineView;
    UIView      *_verticalLineView;
    
    UILabel     *_horizontalLabel;
    UILabel     *_verticalLabel;
    
    CGPoint     currentPoint;
    NSString    *_currentPrice;
    NSString    *_currentTime;
    
    double  defaultUpper;
    double  defaultLower;
    int     numCount;
    
    NSMutableArray  *_crossArray;//分时图 时间、价格数组
    NSMutableArray  *_priceArray;//价格数组
    NSMutableArray  *_pointArray;//坐标数组
    NSString        *_timeLine;
    int             floatNum;
    BOOL            dayOrNight;
    
    NSMutableDictionary     *_timeAndNumDictionary;//时间和点数数组
}
//CurrentPoint:(CGPoint)aPoint NumberOfCount:(int)aCount PriceArray:(NSMutableArray *)aPriceArray
-(instancetype)initWithFrame:(CGRect)aFrame ParamDictionary:(NSMutableDictionary *)aParamDic{
    self = [super initWithFrame:aFrame];
    
    if (self) {
        
        currentPoint = CGPointFromString(aParamDic[@"point"]);
        defaultUpper = [aParamDic[@"upper"] doubleValue];
        defaultLower = [aParamDic[@"lower"] doubleValue];
        numCount     = [aParamDic[@"number_count"] intValue];
        _crossArray  = aParamDic[@"price_array"];
        floatNum     = [aParamDic[@"float_num"] intValue];
        dayOrNight   = [aParamDic[@"day_or_night"] intValue];
        _timeAndNumDictionary = aParamDic[@"timeAndNumDic"];
    }
    
    return self;
}

-(void)loadData{
    
    NSMutableArray *tmpPriceArray = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < _crossArray.count; i++) {
        TimeSharingModel *model = _crossArray[i];
        if (model.time.length > 8) {
            [tmpPriceArray addObject:model.price];
        }
    }
    
    _priceArray = [NSMutableArray arrayWithArray:tmpPriceArray];
}

//获取时间线
-(void)setTimeLine:(NSString *)aTimeLineStr{
    _timeLine = aTimeLineStr;
    
    [self loadMain];
}

-(void)loadMain{
    [self loadData];
    
    [self priceToPointWithPriceArray:[self distributeTimeWithModelArray:_crossArray]];
    
    [self loadCrossCurveView];
}

-(void)loadCrossCurveView{
    
    _currentPrice = @"0.0";
    _currentTime  = @"00:00";
    //找到对应的y坐标
    currentPoint.y = [self findLocationOf_Y];
    
    if (currentPoint.y == 0 || currentPoint.y == -1) {
        return;
    }
    
    _horizontalLineView = [[UIView alloc]initWithFrame:CGRectMake(0, currentPoint.y, self.frame.size.width, 0.5)];
    _horizontalLineView.backgroundColor = [UIColor blackColor];
    
    _verticalLineView = [[UIView alloc]initWithFrame:CGRectMake(currentPoint.x, 10, 0.5, self.frame.size.height-20)];
    _verticalLineView.backgroundColor = [UIColor blackColor];
    
    _horizontalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 33, 10)];
    _horizontalLabel.text = _currentPrice;
    _horizontalLabel.backgroundColor = Color_Gold;
    _horizontalLabel.textAlignment = NSTextAlignmentCenter;
    _horizontalLabel.textColor = [UIColor whiteColor];
    _horizontalLabel.font = [UIFont systemFontOfSize:7];
    
    _verticalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 28, 10)];
    _verticalLabel.text = _currentTime;
    _verticalLabel.backgroundColor = Color_Gold;
    _verticalLabel.textAlignment = NSTextAlignmentCenter;
    _verticalLabel.textColor = [UIColor whiteColor];
    _verticalLabel.font = [UIFont systemFontOfSize:8];
    
    [self addSubview:_horizontalLineView];
    [self addSubview:_verticalLineView];
    [self addSubview:_horizontalLabel];
    [self addSubview:_verticalLabel];
    
    
    if (currentPoint.x > self.bounds.size.width/2) {
        _horizontalLabel.center = CGPointMake(_horizontalLabel.bounds.size.width/2, _horizontalLineView.center.y);
    }
    else{
        _horizontalLabel.center = CGPointMake(_horizontalLineView.frame.size.width - _horizontalLabel.bounds.size.width/2, _horizontalLineView.center.y);
    }
    
    if (currentPoint.y > self.bounds.size.height/2) {
        _verticalLabel.center = CGPointMake(_verticalLineView.center.x, _verticalLabel.bounds.size.height/2);
        
    }
    else{
        _verticalLabel.center = CGPointMake(_verticalLineView.center.x, _verticalLineView.frame.origin.y + _verticalLineView.frame.size.height + _verticalLabel.bounds.size.height/2);
    }
    
    if (_verticalLabel.frame.origin.x < 5) {
        _verticalLabel.frame = CGRectMake(0, _verticalLabel.frame.origin.y, _verticalLabel.frame.size.width, _verticalLabel.frame.size.height);
    }
    
    if ( _verticalLabel.frame.origin.x + _verticalLabel.frame.size.width - 5 > ScreenWidth - 10) {
        _verticalLabel.frame = CGRectMake(ScreenWidth - 5 -_verticalLabel.frame.size.width , _verticalLabel.frame.origin.y, _verticalLabel.frame.size.width, _verticalLabel.frame.size.height);
    }
}

-(void)changeLocation:(CGPoint)aPoint ParamDictionary:(NSMutableDictionary *)aParamDic{
    currentPoint = aPoint;
    currentPoint.y = [self findLocationOf_Y];
    
    defaultUpper = [aParamDic[@"upper"] doubleValue];
    defaultLower = [aParamDic[@"lower"] doubleValue];
    numCount     = [aParamDic[@"number_count"] intValue];
    _crossArray  = aParamDic[@"price_array"];
    floatNum     = [aParamDic[@"float_num"] intValue];
    dayOrNight   = [aParamDic[@"day_or_night"] intValue];
    
    if (currentPoint.y == 0 || currentPoint.y == -1) {
        return;
    }
    
    [self priceToPointWithPriceArray:[self distributeTimeWithModelArray:_crossArray]];
    
    [self loadData];
    
    _horizontalLineView.frame = CGRectMake(0, currentPoint.y, _horizontalLineView.frame.size.width, _horizontalLineView.frame.size.height);
    _verticalLineView.frame = CGRectMake(currentPoint.x, 10, _verticalLineView.frame.size.width, _verticalLineView.frame.size.height);
    
    if (currentPoint.x > self.bounds.size.width/2) {
        _horizontalLabel.center = CGPointMake(_horizontalLabel.bounds.size.width/2, _horizontalLineView.center.y);
    }
    else{
        _horizontalLabel.center = CGPointMake(_horizontalLineView.frame.size.width - _horizontalLabel.bounds.size.width/2, _horizontalLineView.center.y);
    }
    
    if (currentPoint.y > self.bounds.size.height/2) {
        _verticalLabel.center = CGPointMake(_verticalLineView.center.x, _verticalLabel.bounds.size.height/2);
    }
    else{
        _verticalLabel.center = CGPointMake(_verticalLineView.center.x, _verticalLineView.frame.origin.y + _verticalLineView.frame.size.height + _verticalLabel.bounds.size.height/2);
    }
    
    if (_verticalLabel.frame.origin.x < 5) {
        _verticalLabel.frame = CGRectMake(0, _verticalLabel.frame.origin.y, _verticalLabel.frame.size.width, _verticalLabel.frame.size.height);
    }
    
    if ( _verticalLabel.frame.origin.x + _verticalLabel.frame.size.width - 5 > ScreenWidth - 10) {
        _verticalLabel.frame = CGRectMake(ScreenWidth - 5 -_verticalLabel.frame.size.width , _verticalLabel.frame.origin.y, _verticalLabel.frame.size.width, _verticalLabel.frame.size.height);
    }
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

//必须要有价位才可调用计算
-(void)priceToPointWithPriceArray:(NSMutableArray *)aPriceArray{
    
    NSMutableArray *pointArray = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i<aPriceArray.count; i++) {
        
        if ([aPriceArray[i] isEqualToString:@""]) {
            continue;
        }
        
        float priceCurrent = [aPriceArray[i] floatValue];
        
        float y = (self.frame.size.height-20) * (1 - ((priceCurrent - defaultLower)/(defaultUpper - defaultLower))) + 10;
        
        float x = i * ((self.frame.size.width-10*1)/numCount);
        
        CGPoint point = CGPointMake(x, y);
        
        [pointArray addObject:NSStringFromCGPoint(point)];
    }
    _pointArray = [NSMutableArray arrayWithArray:pointArray];
}

-(float)findLocationOf_Y{
    
    BOOL    isNext = NO;
    
    for (int i = 0; i < _pointArray.count; i++) {
        
        float point_X = CGPointFromString(_pointArray[i]).x;
        NSString *point_XStr = [NSString stringWithFormat:@"%.1f",point_X];
        point_X = [point_XStr floatValue];
    
        if (point_X+((self.frame.size.width-10)/numCount) >= currentPoint.x-5 && point_X <= currentPoint.x-5) {
            if (i > _priceArray.count-1) {
                break;
            }
            _currentPrice = _priceArray[i];
            [self findLocationOfPrice:i];
            
            isNext = YES;
            
            return CGPointFromString(_pointArray[i]).y;
        }
        else if (point_X >= currentPoint.x-5 && point_X- ((self.frame.size.width-10)/numCount) <= currentPoint.x-5) {
            if (i > _priceArray.count-1) {
                break;
            }
            _currentPrice = _priceArray[i];
            [self findLocationOfPrice:i];
            
            isNext = YES;
            
            return CGPointFromString(_pointArray[i]).y;
        }
        else{
            isNext = NO;
        }
        
    }
    NSLog(@"%d",isNext);
    
    //现货不是一分钟一个点，而是5分钟1个点，点到空白时间的时候处理方式
    if (isNext == NO) {
        if (_verticalLabel == nil || _horizontalLabel == nil) {
            CGPoint betweenPoint ;
            
            for (int i = 0; i < _pointArray.count; i++) {
                float point_X = CGPointFromString(_pointArray[i]).x;
                NSString *point_XStr = [NSString stringWithFormat:@"%.1f",point_X];
                point_X = [point_XStr floatValue];
                if (point_X > currentPoint.x-5) {
                    //                currentPoint.x = betweenPoint.x;
                    if (i == 0) {
                        _currentPrice = _priceArray[0];
                        [self findLocationOfPrice:0];
                    }
                    else{
                        if (i-1 > _priceArray.count-1) {
                            break;
                        }
                        _currentPrice = _priceArray[i-1];
                        [self findLocationOfPrice:i-1];
                    }
                    
                    float betweenPointY = 0;
                    betweenPointY = betweenPoint.y;
                    return betweenPointY;
                }
                betweenPoint = CGPointFromString(_pointArray[i]);
            }
        }
    }
    
    return -1;
    
//    if (_pointArray.count > 0) {
//        [self findLastPriceAndTime];
//        currentPoint.x = CGPointFromString(_pointArray[_pointArray.count-1]).x + 5;
//        return CGPointFromString(_pointArray[_pointArray.count-1]).y;
//    }
//    else{
//        return 0;
//    }
}

-(void)findLocationOfPrice:(int)aIndex{
    if (aIndex > _crossArray.count-1) {
        return;
    }
    TimeSharingModel *model = _crossArray[aIndex];
    if ([model.price isEqualToString:_currentPrice]) {
        if (![_currentPrice isEqualToString:@""] && [_currentPrice floatValue] != 0) {
            _horizontalLabel.text = _currentPrice;
        }
        
        if (model.time.length > 8) {
            NSString    *timeStr = [model.time substringFromIndex:8];
            
            if (timeStr.length > 4) {
                timeStr = [timeStr substringToIndex:4];
            }
            NSString *timeMutalbeStr = [NSString stringWithFormat:@"%@:%@",[timeStr substringToIndex:2],[timeStr substringFromIndex:2]];
            _currentTime = timeMutalbeStr;
            _verticalLabel.text = _currentTime;
        }
    }
}

//配置最后一条数据
-(void)findLastPriceAndTime{
    
    TimeSharingModel *model = _crossArray.lastObject;
    if (model.time.length > 8) {
        _currentPrice = _priceArray[_pointArray.count - 1];
        
        NSString    *timeStr = [model.time substringFromIndex:8];
        
        if (timeStr.length > 4) {
            timeStr = [timeStr substringToIndex:4];
        }
        NSString *timeMutalbeStr = [NSString stringWithFormat:@"%@:%@",[timeStr substringToIndex:2],[timeStr substringFromIndex:2]];
        _currentTime = timeMutalbeStr;
        _verticalLabel.text = _currentTime;
    }
    else{
        if (_crossArray.count > 0 ) {
            model = _crossArray[_crossArray.count - 1];
            
            NSString    *timeStr = [model.time substringFromIndex:8];
            
            if (timeStr.length > 4) {
                timeStr = [timeStr substringToIndex:4];
            }
            NSString *timeMutalbeStr = [NSString stringWithFormat:@"%@:%@",[timeStr substringToIndex:2],[timeStr substringFromIndex:2]];
            _currentTime = timeMutalbeStr;
            _verticalLabel.text = _currentTime;
            _currentPrice = _priceArray[_priceArray.count - 2];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
