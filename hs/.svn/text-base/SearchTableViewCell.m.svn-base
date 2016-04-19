//
//  SearchTableViewCell.m
//  hs
//
//  Created by PXJ on 15/4/30.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.labNum = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 20)];
        self.labNum.textAlignment = NSTextAlignmentLeft;
        self.labNum.textColor = K_COLOR_CUSTEM(153, 153, 153, 1);
        self.labNum.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.labNum];
        
        self.labName = [[UILabel alloc] initWithFrame:CGRectMake(self.labNum.frame.origin.x+self.labNum.frame.size.width, 10, 100, 20)];
        self.labName.textAlignment = NSTextAlignmentLeft;
        self.labName.textColor = K_COLOR_CUSTEM(25, 28, 26, 1);
        self.labName.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.labName];

        self.optionalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.optionalBtn.frame = CGRectMake(ScreenWidth-70, 8, 50, 24);
        [self.optionalBtn setImage:[UIImage imageNamed:@"Button_17"] forState:UIControlStateNormal];
        self.optionalBtn.layer.cornerRadius = 2;
        self.optionalBtn.layer.masksToBounds = YES;
        [self addSubview:self.optionalBtn];
       
        UILabel * lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, ScreenWidth, 1)];
        lineLab.backgroundColor = K_COLOR_CUSTEM(178, 178, 178, 1);
        [self addSubview:lineLab];
    }
    return self;
}


@end
