//
//  StockMessageCell.m
//  hs
//
//  Created by PXJ on 15/7/14.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "StockMessageCell.h"

@implementation StockMessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
//        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 2, ScreenWidth, 26)];
//        view.backgroundColor = K_COLOR_CUSTEM(248, 248, 248, 1);
//        [self addSubview:view];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, ScreenWidth/2.0-30, 20)];
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel.textColor =  K_COLOR_CUSTEM(110, 110, 110, 1);
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.nameLabel];
        
        
        self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2.0, 5, ScreenWidth/2.0-30, 20)];
        self.valueLabel.font = [UIFont systemFontOfSize:15];
        self.valueLabel.textAlignment = NSTextAlignmentRight;
        self.valueLabel.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
        [self addSubview:self.valueLabel];
        
        
        
    }
    return self;
}
@end
