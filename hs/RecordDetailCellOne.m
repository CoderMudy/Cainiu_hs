//
//  RecordDetailCellOne.m
//  hs
//
//  Created by RGZ on 15/7/14.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "RecordDetailCellOne.h"

@implementation RecordDetailCellOne

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
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        
        //结算盈亏
        UILabel *proLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 22, 120, 15)];
        proLabel.text = @"结算盈亏";
        proLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:proLabel];
        
        self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, proLabel.frame.origin.y+proLabel.frame.size.height+15, ScreenWidth-40, 20)];
        self.moneyLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.moneyLabel];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.moneyLabel.frame.size.height+self.moneyLabel.frame.origin.y+18, ScreenWidth, 5)];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        
        
    }
    
    return self;
}

@end

