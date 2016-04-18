//
//  IndexAgreementCell.m
//  hs
//
//  Created by RGZ on 15/7/28.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "IndexAgreementCell.h"

@implementation IndexAgreementCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        UIView  *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, ScreenWidth-40, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
        
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, ScreenWidth-40, 45)];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.text = @"《协议一：名称待定》";
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.numberOfLines = 0;
        [self addSubview:self.titleLabel];
        
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-20-80, 25, 80, 25)];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.font = [UIFont systemFontOfSize:11];
        self.timeLabel.textColor = [UIColor grayColor];
        [self addSubview:self.timeLabel];
    }
    
    
    return self;
    
}

@end
