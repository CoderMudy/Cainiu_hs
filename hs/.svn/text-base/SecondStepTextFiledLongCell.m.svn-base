//
//  SecondStepTextFiledLongCell.m
//  hs
//
//  Created by RGZ on 15/6/4.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "SecondStepTextFiledLongCell.h"

@implementation SecondStepTextFiledLongCell

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
        UILabel     *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 60, self.frame.size.height)];
        titleLabel.text = @"手机号:";
        [self addSubview:titleLabel];
        
        
        self.mobileTF = [[UITextField alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width+2, 0, ScreenWidth-60-30-2, self.frame.size.height)];
        self.mobileTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.mobileTF.placeholder = @"请输入银行预留手机号";
        self.mobileTF.keyboardType = UIKeyboardTypeNumberPad;
        self.mobileTF.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.mobileTF];
        
    }
    
    return self;
}

@end
