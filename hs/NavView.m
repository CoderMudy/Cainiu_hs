//
//  NavView.m
//  hs
//
//  Created by PXJ on 15/10/28.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "NavView.h"

#define leftClick_Tag 900
#define rightClick_Tag 901



@implementation NavView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame;
{

    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = K_color_NavColor;
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, ScreenWidth-100, 44)];
    self.titleLab.textColor = [UIColor whiteColor];
    self.titleLab.font = [UIFont systemFontOfSize:16];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self  addSubview:self.titleLab];
    
    self.leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 11, 25)];
    self.leftImg.image = [UIImage imageNamed:@"return_1"];
    [self addSubview:self.leftImg];
    
    self.leftControl = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftControl.tag = leftClick_Tag;
    self.leftControl.alpha = 0.5;
    self.leftControl.frame = CGRectMake(0, 20, 54, 44);
    [self addSubview:self.leftControl];
    
    self.rightLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-85, 30, 75, 24)];
    self.rightLab.font = [UIFont systemFontOfSize:13];
    self.rightLab.textAlignment = NSTextAlignmentRight;
    self.rightLab.textColor = [UIColor whiteColor];
    [self addSubview:self.rightLab];
    
    self.rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-85, 30, 75, 24)];
    [self addSubview:self.rightImg];
    
    self.rightControl = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightControl.tag = rightClick_Tag;
    self.rightControl.frame = CGRectMake(ScreenWidth-74, 20, 74, 44);
    [self addSubview:self.rightControl];


    
}
-(void)hiddenleft;
{

    self.leftImg.hidden = YES;

}

- (void)setTitle:(NSString *)title
{
    self.titleLab.text = title;
}
@end
