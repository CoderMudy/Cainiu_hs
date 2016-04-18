//
//  MoneyDetailCell.m
//  hs
//
//  Created by 杨永刚 on 15/5/24.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "MoneyDetailCell.h"

@implementation MoneyDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = K_COLOR_CUSTEM(225, 225, 225, 0.2);
        
        self.lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        [self.lineLabel setBackgroundColor:RGBCOLOR(191, 191, 191)];
        [self addSubview:self.lineLabel];
                
        self.todayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60/2-15, 150, 15)];
        self.todayLabel.textColor = SUBCOLOR;
        self.todayLabel.textAlignment = NSTextAlignmentLeft;
        self.todayLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:self.todayLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(X(self.todayLabel), Y(self.todayLabel)+HEIGHT(self.todayLabel), WIDTH(self.todayLabel), HEIGHT(self.todayLabel))];
        self.timeLabel.textColor = SUBCOLOR;
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:self.timeLabel];
        
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-120)/2, 20, 120, 20)];
        self.typeLabel.textAlignment = NSTextAlignmentCenter;
        self.typeLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.typeLabel];
        
        self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-120-20, 20, 120, 20)];
        self.moneyLabel.textAlignment = NSTextAlignmentRight;
        self.moneyLabel.textColor = [UIColor redColor];
        self.moneyLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.moneyLabel];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict
{
    self.typeLabel.text = [dict objectForKey:@"intro"];
//    NSLog(@"---%@---",dict[@"createDate"]);
    self.todayLabel.text = [self dateTransformToday:[dict objectForKey:@"createDate"]];
    self.timeLabel.text = [self dateTransformTime:[dict objectForKey:@"createDate"]];
    self.moneyLabel.text = [DataEngine addSign:[dict objectForKey:@"curflowAmt"]];
    if ([[dict objectForKey:@"type"] integerValue] == -1) {
        [self.moneyLabel setTextColor:RGBACOLOR(83, 210, 112, 1)];
        self.moneyLabel.text = [NSString stringWithFormat:@"-%@",self.moneyLabel.text];
    }
    else
    {
        [self.moneyLabel setTextColor:[UIColor redColor]];
        self.moneyLabel.text = [NSString stringWithFormat:@"+%@",self.moneyLabel.text];
    }
}

- (NSString *)dateTransformToday:(NSString *)dateStr
{
    NSString    *result = @"";
    NSString    *nowDateStr        = getUserDefaults(uSystemDate);
    
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dDate                   = [dateFormatter dateFromString:dateStr];
    NSDate *cDate                   = [dateFormatter dateFromString:nowDateStr];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString    *strDate            = [dateFormatter stringFromDate:dDate];
    
    NSString    *currentDate        = [dateFormatter stringFromDate:cDate];
    
    if (nowDateStr.length == 0) {
        currentDate = [dateFormatter stringFromDate:[NSDate date]];
    }
    
    
    //判断今天
    if ([currentDate isEqualToString:strDate]) {
        result = @"今天";
    }
    
    //判断昨天
    else if ([[currentDate substringToIndex:6] isEqualToString:[strDate substringToIndex:6]]){
        float   currentDay = [[currentDate substringFromIndex:currentDate.length-2] floatValue];
        float   strDay = [[strDate substringFromIndex:strDate.length-2] floatValue];
        
        if (currentDay - strDay == 1) {
            result = @"昨天";
        }
        else if (currentDay - strDay >1)
        {
            result = strDate;
        }
    }
    else{
        result = strDate;
    }
    
    
    
    if ([result isEqualToString:strDate]) {
        NSDate *date = [dateFormatter dateFromString:result];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        result = [dateFormatter stringFromDate:date];
    }
    
    return result;
}

- (NSString *)dateTransformTime:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate  *date = [dateFormatter dateFromString:dateStr];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}
@end
