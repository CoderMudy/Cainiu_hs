//
//  SecondStepTFAuthCodeCell.m
//  hs
//
//  Created by RGZ on 15/6/4.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "SecondStepTFAuthCodeCell.h"

@implementation SecondStepTFAuthCodeCell

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
        titleLabel.text = @"验证码:";
        [self addSubview:titleLabel];
        
        self.authTF = [[UITextField alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width+2, 0, ScreenWidth-60-30-80-2, self.frame.size.height)];
        self.authTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.authTF.placeholder = @"请输入验证码";
        self.authTF.keyboardType = UIKeyboardTypeNumberPad;
        self.authTF.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.authTF];
        
        self.authBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.authBtn];
    }
    
    return self;
}

@end
