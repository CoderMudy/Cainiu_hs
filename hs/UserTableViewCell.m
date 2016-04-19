//
//  userTableViewCell.m
//  hs
//
//  Created by PXJ on 15/4/27.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

- (void)awakeFromNib {



}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    
    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundImageView=[[UIImageView alloc]init];
        self.backgroundImageView.userInteractionEnabled=YES;
        [self addSubview:self.backgroundImageView];
        
        self.userHeaderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.userHeaderBtn.layer.cornerRadius = 25;
        self.userHeaderBtn.layer.masksToBounds = YES;
        self.userHeaderBtn.frame = CGRectMake(20, 15, 50, 50);
        [self addSubview:self.userHeaderBtn];
        self.titlelab = [[UILabel alloc] init];
        //    self.titlelab.tag=10010;
        [self addSubview:self.titlelab];
        self.detailLab = [[UILabel alloc] init];
        self.detailLab.tag=10010;
        [self addSubview:self.detailLab];
        self.messageLab = [[UILabel alloc] init];
        [self addSubview:self.messageLab];
        self.lineView=[[UIView alloc]init];
        [self addSubview:self.lineView];
        
        self.redView = [[UIView alloc]init];
        [self addSubview:self.redView];
    }
    
    return self;
}

@end
