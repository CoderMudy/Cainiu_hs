//
//  PersionInfoCell.m
//  hs
//
//  Created by RGZ on 15/6/5.
//  Copyright (c) 2015年 luckin. All rights reserved.
//
#define cellHeight 50
#import "PersionInfoCell.h"

@implementation PersionInfoCell

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
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 75, cellHeight)];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [UIColor blackColor];
        [self addSubview:self.titleLabel];
        
        self.detailLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-40-ScreenWidth/2, 0, ScreenWidth/2, cellHeight)];
        self.detailLab.font = FontSize(14);
        self.detailLab.textAlignment = NSTextAlignmentRight;
        self.detailLab.textColor = K_color_gray;
        [self addSubview:self.detailLab];
        
        
        
        self.gesSwitch = [[UISwitch alloc]init];
        self.gesSwitch.hidden = YES;
        [self addSubview:self.gesSwitch ];
        
        
        self.userImgV = [[UIImageView alloc] init];
        self.userImgV.image = [UIImage imageNamed:@"QR_red"];
        self.userImgV.hidden = YES;
        [self addSubview:self.userImgV];
        
    
    }
    
    
    return self;
}

@end
