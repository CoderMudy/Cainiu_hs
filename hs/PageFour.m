//
//  PageFour.m
//  hs
//
//  Created by RGZ on 15/6/29.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "PageFour.h"

@implementation PageFour

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self loadButton:&frame];
        
        [self showAnimation:&frame];
        
    }
    
    return self;
}

-(void)loadButton:(CGRect *)aRect{
    self.goMainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goMainBtn.frame = CGRectMake(aRect->size.width/2-546/4.0/320.0*aRect->size.width/2, aRect->size.height/5*4, 546/4.0/320.0*aRect->size.width, 190/4.0/568.0*aRect->size.height);
    [self.goMainBtn setBackgroundImage:[UIImage imageNamed:@"welcome_12"] forState:UIControlStateNormal];
    [self.goMainBtn setTitle:@"立即体验" forState:UIControlStateNormal];
    self.goMainBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self addSubview:self.goMainBtn];
}

-(void)showAnimation:(CGRect *)frame{
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame->size.width/2-365/2.0/320.0*frame->size.width/2, frame->size.height/4.0-12.0/568*frame->size.height, 365/2.0/320.0*frame->size.width, 358/2.0/568.0*frame->size.height)];
    logoImageView.image = [UIImage imageNamed:@"welcome_11"];
    logoImageView.alpha = 0;
    [self addSubview:logoImageView];
    
    [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        logoImageView.alpha = 1;
    } completion:nil];
}

@end
