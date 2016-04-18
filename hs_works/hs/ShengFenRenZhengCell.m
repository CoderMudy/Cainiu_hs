//
//  ShengFenRenZhengCell.m
//  hs
//
//  Created by Xse on 15/10/19.
//  Copyright © 2015年 luckin. All rights reserved.
//  ====身份认证cell

#import "ShengFenRenZhengCell.h"

@implementation ShengFenRenZhengCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _nameLab = [[UILabel alloc]init];
        _nameLab.text = @"姓名";
        _nameLab.frame = CGRectMake(20, 10, 100, 21);
        _nameLab.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:_nameLab];
        
        _userNameLab = [[UILabel alloc]init];
        _userNameLab.textAlignment = NSTextAlignmentRight;
        _userNameLab.frame = CGRectMake(CGRectGetMaxX(_nameLab.frame), 10, ScreenWidth - CGRectGetMaxX(_nameLab.frame) - 10 - 10, 21);
        _userNameLab.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:_userNameLab];
        
//        self.contentView.backgroundColor = [UIColor cyanColor];
    }
    
    return self;
}

- (void)fillWithData:(NSDictionary *)dic
{
    _nameLab.text = dic[@"name"];
    _userNameLab.text = dic[@"userName"];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
