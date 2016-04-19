//
//  AboutUserCell.m
//  hs
//
//  Created by Xse on 15/10/26.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "AboutUserCell.h"

@implementation AboutUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _iconImg = [[UIImageView alloc]init];
        _iconImg.frame = CGRectMake(20, 12, 23*ScreenWidth/320, 23*ScreenWidth/320);//
        [self.contentView addSubview:_iconImg];
        
        _iconName = [[UILabel alloc]init];
        _iconName.font = [UIFont systemFontOfSize:15];
        _iconName.frame = CGRectMake(CGRectGetMaxX(_iconImg.frame) + 10, CGRectGetMinY(_iconImg.frame) + 3, 100, 21);
        [self.contentView addSubview:_iconName];
        
        
        _downImg = [[UIImageView alloc]init];
        _downImg.image = [UIImage imageNamed:@"button_02"];
        _downImg.frame = CGRectMake(ScreenWidth - 10 - 20,15, 22, 22);
        [self.contentView addSubview:_downImg];
        
        _detailLab = [[UILabel alloc]init];
        _detailLab.textColor = [UIColor lightGrayColor];
        _detailLab.textAlignment = NSTextAlignmentRight;
        _detailLab.font = [UIFont systemFontOfSize:13.0];
        _detailLab.frame = CGRectMake(CGRectGetMaxX(_iconName.frame) + 5, 5, CGRectGetMinX(_downImg.frame) - CGRectGetMaxX(_iconName.frame) - 5, 40);
        [self.contentView addSubview:_detailLab];
        
        _grayLineView = [[UIView alloc]init];
        _grayLineView.frame = CGRectMake(15, 49, ScreenWidth - 15*2, 0.5);
        _grayLineView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_grayLineView];
        
    }
     
    return self;
}

- (void)fillWithData:(NSDictionary *)dic
{
    _iconImg.image = [UIImage imageNamed:dic[@"icon"]];
    _iconName.text = dic[@"name"];
    _detailLab.text = dic[@"detailTitle"];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
