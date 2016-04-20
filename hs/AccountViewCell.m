//
//  AccountViewCell.m
//  hs
//
//  Created by RGZ on 16/4/19.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "AccountViewCell.h"

@implementation AccountViewCell

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
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 80, self.bounds.size.height)];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.titleLabel];
        
        self.acctoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 20 - 10, 0, 10/2.0, 18/2.0)];
        self.acctoryImageView.image = [UIImage imageNamed:@"arrow"];
        self.acctoryImageView.center = CGPointMake(self.acctoryImageView.center.x, self.bounds.size.height/2);
        [self addSubview:self.acctoryImageView];
        
        self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.acctoryImageView.frame.origin.x - 75, 0, 80, self.frame.size.height)];
        self.detailLabel.font = [UIFont systemFontOfSize:13];
        self.detailLabel.textColor = Color_lightGray;
        self.detailLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.detailLabel];
    }
    
    return self;
}

@end
