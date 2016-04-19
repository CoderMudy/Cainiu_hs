//
//  SignAgreeCell.m
//  hs
//
//  Created by PXJ on 15/7/13.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "SignAgreeCell.h"

@implementation SignAgreeCell

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
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 2, ScreenWidth, 50)];
        view.backgroundColor = K_COLOR_CUSTEM(248, 248, 248, 1);
        [self addSubview:view];
     
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, ScreenWidth-40, 30)];
        self.titleLabel.font = [UIFont systemFontOfSize:12.F];
        self.titleLabel.textColor =  K_COLOR_CUSTEM(110, 110, 110, 1);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.numberOfLines = 0;

        [view addSubview:self.titleLabel];
        
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-100, 35, 80, 10)];
        self.dateLabel.font = [UIFont systemFontOfSize:10.f];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
        [view addSubview:self.dateLabel];
        
        
        
    }
    return self;
}
- (void)setDict:(NSDictionary *)dict
{
  
    self.titleLabel.text = dict[@"title"];
    self.dateLabel.text = dict[@"date"];
    

    
    
    
}
@end
