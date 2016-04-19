//
//  SSNavView.m
//  hs
//
//  Created by PXJ on 15/6/11.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "SSNavView.h"

@implementation SSNavView

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
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(ScreenWidth-54, 20, 44, 44);
        [_searchBtn setImage:[UIImage imageNamed:@"search_01"] forState:UIControlStateNormal];
        [self addSubview:_searchBtn];
        
        _titleLab = [[UILabel alloc] init];
        _titleLab.center = CGPointMake(ScreenWidth/2, 42);
        _titleLab.bounds = CGRectMake(0, 0, ScreenWidth-100, 44);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLab];
        
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 20, 44, 44);
        [_backBtn setImage:[UIImage imageNamed:@"return_1"] forState:UIControlStateNormal];
        
        
        _segControl = [[UISegmentedControl alloc] initWithItems:@[@"持仓",@"自选"]];
        _segControl.center = CGPointMake(ScreenWidth/2, 42);
        _segControl.bounds = CGRectMake(0, 0, 120, 20);
        [self addSubview:_segControl];
        _segControl.selectedSegmentIndex = 0;
        _segControl.tintColor = [UIColor whiteColor];
    }
    return self;
}

@end
