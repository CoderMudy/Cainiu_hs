//
//  PositionTableViewCell.m
//  hs
//
//  Created by PXJ on 15/4/28.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import "PositionTableViewCell.h"
#define K_HEIGHT self.bounds.size.height
#define K_WIDTH self.bounds.size.width
@implementation PositionTableViewCell

@synthesize storkTitlelab;
@synthesize szDetailLab;
@synthesize priceLab;
@synthesize addView;
@synthesize addLab;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:K_COLOR_CUSTEM(248, 248, 248, 1)];
        
        UILabel  *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 48-0.8, ScreenWidth, 0.8)];
        [lineLabel setBackgroundColor:RGBCOLOR(191, 191, 191)];
        [self addSubview:lineLabel];
        
        self.storkTitlelab = [[UILabel alloc] initWithFrame:CGRectMake(20, 9, 100, 15)];
        self.storkTitlelab.textColor = K_COLOR_CUSTEM(55, 54, 53, 1);
        self.storkTitlelab.font = [UIFont systemFontOfSize:16.F];
        [self addSubview:self.storkTitlelab];
        
        self.szDetailLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 26, 100, 13)];
        self.szDetailLab.font = [UIFont systemFontOfSize:12.F];
        [self.szDetailLab setTextColor: K_COLOR_CUSTEM(110, 110, 110, 1)];
        [self addSubview:self.szDetailLab];
        
        
        self.addView = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-109, 8, 89, 28)];
        self.addView.backgroundColor = K_COLOR_CUSTEM(250, 67, 0, 1);
        
        self.addView.layer.cornerRadius = 5;
        self.addView.layer.masksToBounds = YES;
        [self.addView setBackgroundColor:[UIColor redColor]];
        [self addSubview:self.addView];
        
        
        self.sourceMarkLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 15, 28)];
        self.sourceMarkLab.font = [UIFont systemFontOfSize:11];
        self.sourceMarkLab.textAlignment = NSTextAlignmentCenter;
        self.sourceMarkLab.numberOfLines = 2;
        self.sourceMarkLab.text = @"积分";
        self.sourceMarkLab.hidden = YES;
        self.sourceMarkLab.textColor = [UIColor whiteColor];
        [self.addView addSubview: self.sourceMarkLab];
        
        self.addLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.addView.bounds.size.width-19, 28)];
        self.addLab.font = [UIFont systemFontOfSize:15];
        self.addLab.textAlignment = NSTextAlignmentRight;
        self.addLab.textColor = [UIColor whiteColor];
        [self.addView addSubview:self.addLab];
        
        
        self.priceLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-230,12, 110, 20)];
        self.priceLab.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
        self.priceLab.font = [UIFont systemFontOfSize:15.F];
        self.priceLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.priceLab];
        
    }
    return self;
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//}


@end
