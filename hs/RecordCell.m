//
//  RecordCell.m
//  hs
//
//  Created by PXJ on 15/7/28.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "RecordCell.h"

@implementation RecordCell

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.timeLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, (ScreenWidth-40)/5, 48)];
        self.timeLab.textColor = [UIColor lightGrayColor];
        self.timeLab.font = [UIFont systemFontOfSize:10];
        self.timeLab.numberOfLines = 0;
        [self addSubview:self.timeLab];

        
        self.buyBtnBack  = [[UIView alloc] initWithFrame:CGRectMake(self.timeLab.frame.origin.x+self.timeLab.frame.size.width+20, 14, 40, 20)];
        self.buyBtnBack.layer.cornerRadius = 2;
        self.buyBtnBack.layer.masksToBounds = YES;
        [self addSubview:self.buyBtnBack];
        
        self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.buyBtn.frame = CGRectMake(self.timeLab.frame.origin.x+self.timeLab.frame.size.width+20, 2,self.buyBtnBack.frame.size.width, 44);
        self.buyBtn.layer.cornerRadius = 2;
        self.buyBtn.layer.masksToBounds = YES;
        [self.buyBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:self.buyBtn];
        
        self.addLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-(ScreenWidth-40)/5-20, 0, (ScreenWidth-40)/5, 48)];
        self.addLab.font = [UIFont systemFontOfSize:12];
        self.addLab.numberOfLines = 0;
        self.addLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.addLab];

        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 47, ScreenWidth-40, 0.3)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineView];
        
        
    }
    return self;
}
- (void)setCellWithDictionary:(NSDictionary*)dictionary
{
    self.timeLab.text = [NSString stringWithFormat:@"%@\n%@",@"今天",@"11:20:18"];
    [self.buyBtn setTitle:@"看多" forState:UIControlStateNormal];
    [self.buyBtnBack setBackgroundColor:K_COLOR_CUSTEM(250,67, 0, 1)];
    float profit =50;
    if (profit>0) {
        self.addLab.textColor = K_COLOR_CUSTEM(250, 67, 0, 1);
        
    }else{
        self.addLab.textColor = K_COLOR_CUSTEM(8, 186, 66, 1);
    }
    self.addLab.text = [NSString stringWithFormat:@"%.2f元",profit];



}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
