//
//  TiXianDeatialCell.m
//  hs
//
//  Created by Xse on 15/10/20.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "TiXianDeatialCell.h"

@implementation TiXianDeatialCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _nameTextlab = [[UILabel alloc]init];
        _nameTextlab.frame = CGRectMake(15, 12, 100, 21);
        _nameTextlab.font = [UIFont systemFontOfSize:14.0];
        _nameTextlab.textColor = [UIColor blackColor];
        [self.contentView addSubview:_nameTextlab];
        
        _deatailLab = [[UILabel alloc]init];
        _deatailLab.font = [UIFont systemFontOfSize:12.0];
        _deatailLab.textColor = [UIColor blackColor];
        [self.contentView addSubview:_deatailLab];
        _deatailLab.frame = CGRectMake(CGRectGetMaxX(_nameTextlab.frame), CGRectGetMinY(_nameTextlab.frame), ScreenWidth - CGRectGetMaxX(_nameTextlab.frame), 21);
        
        _downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _downBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        _downBtn.frame = CGRectMake(ScreenWidth - 60, 2, 60, 35);
        [_downBtn setTitle:@"免手续费？" forState:UIControlStateNormal];
        [_downBtn setTitleColor:[UIColor colorWithRed:81/255.0 green:139/255.0 blue:189/255.0 alpha:1] forState:UIControlStateNormal];
        _downBtn.hidden = YES;
        [self.contentView addSubview:_downBtn];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
