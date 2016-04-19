//
//  TopOtherPositionView.m
//  hs
//
//  Created by PXJ on 15/7/10.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "TopOtherPositionView.h"

@implementation TopOtherPositionView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
  
        
        
        self.backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height)];
        self.backView .image = [UIImage imageNamed:@"background_header_05"];
        [self addSubview:self.backView ];
        
        self.headerImageView = [[UIImageView alloc] init];
        self.headerImageView.center = CGPointMake(ScreenWidth/2, 35);
        self.headerImageView.bounds = CGRectMake(0, 0, 40, 40);
        self.headerImageView.layer.cornerRadius = 20;
        self.headerImageView.layer.masksToBounds = YES;
        [self.headerImageView.layer setBorderWidth:0.5]; //边框宽度
        [self.headerImageView.layer setBorderColor:[[UIColor lightGrayColor ]CGColor]]; //边框颜色
        [self.headerImageView setImage:[UIImage imageNamed:@"head_01"]];
        
        [self addSubview:self.headerImageView];
        self.inteEarnTitleLab = [[UILabel alloc] init];
        self.inteEarnTitleLab.bounds = CGRectMake(0, 0, ScreenWidth, 10);
        self.inteEarnTitleLab.center = CGPointMake(ScreenWidth/2, self.headerImageView.center.y+self.headerImageView.bounds.size.height/2+self.inteEarnTitleLab.bounds.size.height/2+10);
        self.inteEarnTitleLab.font = [UIFont systemFontOfSize:10];
        self.inteEarnTitleLab.text = @"持仓收益率";
        self.inteEarnTitleLab.textAlignment = NSTextAlignmentCenter;
        self.inteEarnTitleLab.textColor = K_COLOR_CUSTEM(225, 225, 225, 1);
        [self addSubview:self.inteEarnTitleLab];
        
        self.inteEarnLab = [[UILabel alloc] init];
        self.inteEarnLab.bounds = CGRectMake(0, 0, ScreenWidth, 40);
        self.inteEarnLab.center = CGPointMake(ScreenWidth/2, self.inteEarnTitleLab.center.y+self.inteEarnTitleLab.bounds.size.height/2+self.inteEarnLab.bounds.size.height/2);
        self.inteEarnLab.font = [UIFont systemFontOfSize:40];
        self.inteEarnLab.textColor = [UIColor whiteColor];
        self.inteEarnLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.inteEarnLab];
        
        

        _markll = [[UILabel alloc] initWithFrame:CGRectMake(20, self.inteEarnLab.frame.origin.y, 15, 15)];
        _markll.textColor = [UIColor whiteColor];
        _markll.font = [UIFont systemFontOfSize:25.f];
        [self addSubview:_markll];
        
        
        
    }
    return self;
}

- (void)setEarn:(NSString*)earn
{

    self.inteEarnLab.text = earn;

}
- (void)image:(NSString*)url
{

    

}
@end
