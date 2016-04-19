//
//  TodayView.m
//  hs
//
//  Created by PXJ on 15/5/7.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "TodayView.h"

@implementation TodayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.numLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.bounds.size.width, 25)];
        self.numLab.font = [UIFont systemFontOfSize:17];
        self.numLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.numLab];
        
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.numLab.frame.origin.y+self.numLab.frame.size.height, self.bounds.size.width, 2)];
        self.progressView.layer.cornerRadius = 1;
        self.progressView.layer.masksToBounds = YES;
        [self addSubview:self.progressView];
        
        self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.progressView.frame.origin.y+self.progressView.frame.size.height+5, self.bounds.size.width, 12)];
        self.nameLab.font = [UIFont systemFontOfSize:10];
        self.nameLab.textAlignment = NSTextAlignmentCenter;
        self.nameLab.textColor = [UIColor grayColor];
        [self addSubview:self.nameLab];
    }
    return self;
}

@end
