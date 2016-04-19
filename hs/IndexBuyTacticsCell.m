//
//  IndexBuyTacticsCell.m
//  hs
//
//  Created by RGZ on 16/1/19.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "IndexBuyTacticsCell.h"

@implementation IndexBuyTacticsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier CellHeight:(float)cellHeight CellWidth:(float)cellWidth{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        int font = 12;
        
        if (ScreenHeigth <= 480) {
            font = 10;
        }
        else if (ScreenHeigth <= 568 && ScreenHeigth > 480){
            font = 10;
        }
        else if (ScreenHeigth <= 667 && ScreenHeigth > 568){
            font = 11;
        }
        else{
            font = 12;
        }
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cellWidth/3+10, cellHeight)];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.text = @"";
        self.nameLabel.font = [UIFont systemFontOfSize:font];
        [self addSubview:self.nameLabel];
        
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(cellWidth/3, 0, cellWidth/3, cellHeight)];
        self.contentLabel.textColor = [UIColor whiteColor];
        self.contentLabel.text = @"";
        self.contentLabel.font = [UIFont systemFontOfSize:font];
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.contentLabel];
        
        self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(cellWidth/3*2-10, 0, cellWidth/3+10, cellHeight)];
        self.detailLabel.textColor = [UIColor whiteColor];
        self.detailLabel.text = @"";
        self.detailLabel.font = [UIFont systemFontOfSize:font];
        self.detailLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.detailLabel];
    }
    
    return self;
}

-(void)changeContent:(NSString *)name Content:(NSString *)num Money:(NSString *)money{
    self.nameLabel.text = name;
    if ([num isEqualToString:@"尚无持仓"]) {
        self.contentLabel.text = [NSString stringWithFormat:@"%@",num];
    }
    else{
        self.contentLabel.text = [NSString stringWithFormat:@"%@手",num];
    }
    
    if ([money isEqualToString:@"-0"] || [money rangeOfString:@"(null)"].location != NSNotFound) {
        money = @"0";
    }
    
    UIColor *color = Color_Green;
    NSString    *moneySign = @"";
    if ([money isEqualToString:@"——"]) {
        color = Color_gray;
        moneySign = @"";
    }
    else if ([money floatValue] >= 0) {
        color = Color_Red;
        moneySign = @"+";
    }
    
    if ([money isEqualToString:@""]) {
        self.detailLabel.text = [NSString stringWithFormat:@""];
    }
    else{
        self.detailLabel.text = [NSString stringWithFormat:@"%@%@",moneySign,money];
        self.detailLabel.textColor = color;
    }
    
    
    
}

@end
