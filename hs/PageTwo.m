//
//  PageTwo.m
//  hs
//
//  Created by Xse on 15/10/10.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "PageTwo.h"

@implementation PageTwo

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self loadUI];
    }
    
    return self;
}

- (void)loadUI
{
    UIImageView *pageOneImg = [[UIImageView alloc]init];
    pageOneImg.frame = CGRectMake(ScreenWidth/2 - (223)*0.9*ScreenWidth/320/2, 120*ScreenHeigth/667, 223*0.9*ScreenWidth/320, 224*0.9*ScreenWidth/320);
    pageOneImg.image = [UIImage imageNamed:@"log_page_two"];
    [self addSubview:pageOneImg];
    
    
    UILabel *redLab = [[UILabel alloc]init];
    redLab.text = @"快 ! 快 ! 快 !";
    redLab.font = [UIFont systemFontOfSize:20];
    redLab.textAlignment = NSTextAlignmentCenter;
    redLab.textColor = [UIColor colorWithRed:226/255.0 green:41/255.0 blue:34/255.0 alpha:1];
    CGFloat redLabW = [Helper calculateTheHightOfText:redLab.text height:21 font:[UIFont systemFontOfSize:20] ];
    
    redLab.frame = CGRectMake(ScreenWidth/2 - redLabW/2, CGRectGetMaxY(pageOneImg.frame) + 75*ScreenHeigth/667, redLabW, 21);
    [self addSubview:redLab];
    
    UILabel *textLab = [[UILabel alloc]init];
    textLab.text = @"闪电下单 · 一键清仓";
    textLab.font = [UIFont systemFontOfSize:14.0];
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.textColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1];
    CGFloat textLabW = [Helper calculateTheHightOfText:textLab.text height:21 font:[UIFont systemFontOfSize:14]];
    textLab.frame = CGRectMake(ScreenWidth/2 - textLabW/2, CGRectGetMaxY(redLab.frame) + 5, textLabW, 21);
    [self addSubview:textLab];
    
}

@end
