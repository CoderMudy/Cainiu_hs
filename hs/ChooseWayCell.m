//
//  ChooseWayCell.m
//  hs
//
//  Created by RGZ on 15/7/3.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "ChooseWayCell.h"

@implementation ChooseWayCell

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
        
        _nameLab = [[UILabel alloc]init];
        _nameLab.font = [UIFont systemFontOfSize:18.0];
        _nameLab.textColor = [UIColor blackColor];
        _nameLab.frame = CGRectMake(20, 20, 100, 25);
        _nameLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameLab];
        
        self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_nameLab.frame), CGRectGetMaxY(_nameLab.frame),ScreenWidth - 100 , 21)];
//        self.detailLabel.textAlignment =NSTextAlignmentRight;
        self.detailLabel.font = [UIFont systemFontOfSize:12];
        self.detailLabel.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
        [self.contentView addSubview:self.detailLabel];
        
        self.titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 77*ScreenWidth/320 - 20, CGRectGetMinY(_nameLab.frame) + 8, 77*ScreenWidth/320, 24*ScreenWidth/320)];
        [self.contentView addSubview:self.titleImageView];
        
        _grayView = [[UIView alloc]init];
        _grayView.frame = CGRectMake(0, CGRectGetMaxY(self.detailLabel.frame) + 20, ScreenWidth, 20);
        _grayView.backgroundColor = RGBACOLOR(245, 245, 245, 1);
        [self.contentView addSubview:_grayView];
    }
    
    
    return self;
}

- (void)fillWithWayData:(NSDictionary *)dic
{
    _nameLab.text = dic[@"name"];
    _detailLabel.text = dic[@"detail"];
    _titleImageView.image = [UIImage imageNamed:dic[@"imageName"]];
}

@end
