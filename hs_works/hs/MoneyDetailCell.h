//
//  MoneyDetailCell.h
//  hs
//
//  Created by 杨永刚 on 15/5/24.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "HSTableViewCell.h"

#define SUBCOLOR    RGBACOLOR(80,80,80,0.9)

@interface MoneyDetailCell : HSTableViewCell
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UILabel *todayLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *moneyLabel;

- (void)setDict:(NSDictionary *)dict;
@end
