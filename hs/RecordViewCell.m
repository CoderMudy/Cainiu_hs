//
//  RecordViewCell.m
//  hs
//
//  Created by RGZ on 15/7/13.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "RecordViewCell.h"

@implementation RecordViewCell

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
                
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, (ScreenWidth-60)/3, 48)];
        self.timeLabel.textColor = [UIColor lightGrayColor];
        self.timeLabel.font = [UIFont systemFontOfSize:13];
        self.timeLabel.numberOfLines = 0;
//        self.timeLabel.text = @"2015-04-12 \n07:50:21";
        [self addSubview:self.timeLabel];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30+(ScreenWidth-60)/3, 0, (ScreenWidth-60)/3, 48)];
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel.numberOfLines = 0;
//        self.nameLabel.text = @"高德红外";
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.nameLabel];
        
        self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(30+(ScreenWidth-60)/3*2, 0, (ScreenWidth-60)/3, 48)];
        self.moneyLabel.font = [UIFont systemFontOfSize:15];
        self.moneyLabel.numberOfLines = 0;
//        self.moneyLabel.text = @"+1120.00";
        self.moneyLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.moneyLabel];
    }
    
    return self;
}

@end
