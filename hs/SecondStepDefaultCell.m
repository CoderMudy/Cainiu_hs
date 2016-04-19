//
//  SecondStepDefaultCell.m
//  hs
//
//  Created by RGZ on 15/6/4.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "SecondStepDefaultCell.h"

@implementation SecondStepDefaultCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        UILabel     *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth/2, self.frame.size.height)];
        titleLabel.text = @"账户充值（元）:";
        [self addSubview:titleLabel];
        
        self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2-15, self.frame.size.height)];
        self.moneyLabel.textAlignment = NSTextAlignmentRight;
        self.moneyLabel.textColor = CanSelectButBackColor;
        [self addSubview:self.moneyLabel];
    }
    
    return self;
}


@end
