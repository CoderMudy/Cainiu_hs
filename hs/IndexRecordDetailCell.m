//
//  IndexRecordDetailCell.m
//  hs
//
//  Created by PXJ on 15/7/28.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "IndexRecordDetailCell.h"

@implementation IndexRecordDetailCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        float width = (ScreenWidth-60)/2;
        _nameLeft = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, width, 20)];
        _valueLeft = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, width, 20)];
        _nameRight = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLeft.frame)+10, 5, width, 20)];
        _valueRight = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLeft.frame), 5, width+10, 20)];
        
        _nameLeft.font = [UIFont systemFontOfSize:10];
        _valueLeft.font = [UIFont systemFontOfSize:13];
        _nameRight.font = [UIFont systemFontOfSize:10];
        _valueRight.font = [UIFont systemFontOfSize:13];
        
        _nameLeft.textColor = K_color_gray;
        _nameRight.textColor = K_color_gray;
        _valueLeft.textColor = [UIColor whiteColor];
        _valueRight.textColor = [UIColor whiteColor];
        
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
