//
//  FoyerReportShowView.m
//  scrollow
//
//  Created by PXJ on 15/9/17.
//  Copyright (c) 2015年 PXJ. All rights reserved.
//

#import "FoyerReportShowView.h"

#define selfWidth self.frame.size.width
#define selfheight self.frame.size.height

@implementation FoyerReportShowView

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
        
        [self initShowView];
        
        
    }
    return self;

}
- (void)initShowView
{

    _nickLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, selfWidth/2, selfheight)];
    _nickLab.textColor = K_COLOR_CUSTEM(135, 135, 135, 1);
    _nickLab.font = [UIFont systemFontOfSize:selfheight/2];
    [self addSubview:_nickLab];
    _profitLab = [[UILabel alloc] initWithFrame:CGRectMake(selfWidth/2, 0, selfWidth/2, selfheight)];
    _profitLab.textColor = K_color_red;
    _profitLab.font = [UIFont systemFontOfSize:selfheight/2];
    [self addSubview:_profitLab];
    
    
}
- (void)setShowViewNickname:(NSString *)nickName profit:(NSString *)profit
{
    _nickLab.text = nickName;
    _profitLab.text = profit;
    CGFloat rect = [Helper calculateTheHightOfText:nickName height:selfheight/2 font:[UIFont systemFontOfSize:selfheight/2]];
    _nickLab.frame = CGRectMake(0, 0, rect+5, selfheight);
    _profitLab.frame = CGRectMake(rect, 0, selfWidth/2, selfheight);
    
    
    
    
}
@end
