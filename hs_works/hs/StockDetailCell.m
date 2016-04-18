//
//  StockDetailCell.m
//  hs
//
//  Created by PXJ on 15/7/3.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "StockDetailCell.h"

@implementation StockDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        float width = (ScreenWidth-60)/2;
        _nameLeft = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, width, 20)];
        _valueLeft = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, width, 20)];
        _nameRight = [[UILabel alloc] initWithFrame:CGRectMake(_nameLeft.frame.size.width+_nameLeft.frame.origin.x+10, 5, width, 20)];
        _valueRight = [[UILabel alloc] initWithFrame:CGRectMake(_nameLeft.frame.size.width+_nameLeft.frame.origin.x+10, 5, width, 20)];
        
        _nameLeft.font = [UIFont systemFontOfSize:10];
        _valueLeft.font = [UIFont systemFontOfSize:12];
        _nameRight.font = [UIFont systemFontOfSize:10];
        _valueRight.font = [UIFont systemFontOfSize:12];

        _nameLeft.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
        _nameRight.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
        _valueLeft.textColor = K_COLOR_CUSTEM(55, 54, 53, 1);
        _valueRight.textColor = K_COLOR_CUSTEM(55, 54, 53, 1);
        
        _nameLeft.textAlignment = NSTextAlignmentLeft;
        _valueLeft.textAlignment = NSTextAlignmentRight;
        _nameRight.textAlignment = NSTextAlignmentLeft;
        _valueRight.textAlignment = NSTextAlignmentRight;

        [self addSubview:_nameLeft];
        [self addSubview:_valueLeft];
        [self addSubview:_nameRight];
        [self addSubview:_valueRight];


    }return self;
}
@end
