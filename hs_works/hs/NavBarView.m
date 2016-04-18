//
//  NavBarView.m
//  hs
//
//  Created by PXJ on 15/5/7.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "NavBarView.h"

@implementation NavBarView

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
        
        self.backgroundColor = K_COLOR_CUSTEM(250, 66, 0, 1);
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    return self;
}
@end
