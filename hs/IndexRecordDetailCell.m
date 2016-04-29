//
//  IndexRecordDetailCell.m
//  hs
//
//  Created by PXJ on 15/7/28.
//  Copyright (c) 2015年 luckin. All rights reserved.
//
#define RECOREDETAIL_TEXT_COLOR K_color_NavColor

#import "IndexRecordDetailCell.h"

@implementation IndexRecordDetailCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        float width = (ScreenWidth-60)/3;
        _nameLeft = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, width, 20)];
        _valueRight = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLeft.frame), 5, width*2, 20)];
        
        _nameLeft.font = [UIFont systemFontOfSize:10];
        _valueRight.font = [UIFont systemFontOfSize:13];
        
        _nameLeft.textColor = K_color_grayBlack;
        _valueRight.textColor = K_color_NavColor;

        
        [self addSubview:_nameLeft];
        [self addSubview:_valueRight];
        
        
    }return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
