//
//  ReportView.m
//  ReportTest
//
//  Created by RGZ on 15/7/3.
//  Copyright (c) 2015年 RGZ. All rights reserved.
//

#import "ReportView.h"

@implementation ReportView

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
        
    
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-95, frame.size.height/2-((frame.size.height-3)/2), frame.size.height-3, frame.size.height-3)];
        _imageView.clipsToBounds = YES;
        _imageView.image = [UIImage imageNamed:@"head_01"];
        _imageView.layer.cornerRadius = (frame.size.height-3)/2;
        [self addSubview:_imageView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_imageView.frame.origin.x+_imageView.frame.size.width+5, 0, self.frame.size.width-_imageView.frame.size.width-_imageView.frame.origin.x-5, self.frame.size.height)];
//        self.titleLabel.text = @"***操盘盈利 1000元";
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.titleLabel];
        
        
    }
    
    return self;
    
}

@end
