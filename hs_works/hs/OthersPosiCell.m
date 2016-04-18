//
//  OtherPositionCell.m
//  hs
//
//  Created by PXJ on 15/5/14.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "OthersPosiCell.h"

@implementation OthersPosiCell

@synthesize storkTitlelab;
@synthesize szDetailLab;
@synthesize priceLab;
@synthesize addLab;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = K_COLOR_CUSTEM(248,248,248,1);
        
        self.storkTitlelab = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 100, 15)];
        self.storkTitlelab.font = [UIFont systemFontOfSize:16.f];
        self.storkTitlelab.textColor = K_COLOR_CUSTEM(55, 54, 53, 1);
        [self addSubview:self.storkTitlelab];
        
        self.szDetailLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 28, 100, 13)];
        self.szDetailLab.font = [UIFont systemFontOfSize:11.F];
        self.szDetailLab.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
        [self addSubview:self.szDetailLab];
        
        
        self.addView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth-105, 9, 85, 30)];
        self.addView.layer.cornerRadius= 3;
        self.addView.layer.masksToBounds = YES;
        [self addSubview:self.addView];

        self.addLab = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, 79, 30)];
        self.addLab.layer.cornerRadius = 3;
        self.addLab.layer.masksToBounds = YES;
        self.addLab.font = [UIFont systemFontOfSize:16.f];
        self.addLab.textAlignment = NSTextAlignmentRight;
        self.addLab.textColor = [UIColor whiteColor];
        [self.addView addSubview:self.addLab];
        
        
        self.priceLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-220,16, 100, 15)];
        self.priceLab.font = [UIFont systemFontOfSize:15.f];
        [self addSubview:self.priceLab];

        UILabel * linelab = [[UILabel alloc] initWithFrame:CGRectMake(0, 48-0.8, ScreenWidth, 0.8)];
        linelab.backgroundColor = K_COLOR_CUSTEM(200, 200, 200, 200);
        [self addSubview:linelab];

    }
    return self;
}
- (void)setDict:(NSDictionary *)dict
{
    
    
}
- (void)layoutSubviews
{
//    [super layoutSubviews];
}
@end
