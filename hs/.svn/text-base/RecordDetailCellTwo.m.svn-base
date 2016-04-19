//
//  RecordDetailCellTwo.m
//  hs
//
//  Created by RGZ on 15/7/14.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "RecordDetailCellTwo.h"

@implementation RecordDetailCellTwo

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
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 18)];
        titleLabel.text = @"订单信息";
        titleLabel.font = [UIFont systemFontOfSize:11];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:0.7];
        [self addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.frame.size.height+titleLabel.frame.origin.y, ScreenWidth, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:0.5];
        [self addSubview:lineView];
        
        
        UILabel *recordTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 285, ScreenWidth, 18)];
        recordTitleLabel.text = @"成交记录";
        recordTitleLabel.font = [UIFont systemFontOfSize:11];
        recordTitleLabel.textAlignment = NSTextAlignmentCenter;
        recordTitleLabel.textColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:0.7];
        [self addSubview:recordTitleLabel];
        
        UIView *recordLineView = [[UIView alloc]initWithFrame:CGRectMake(0, recordTitleLabel.frame.size.height+recordTitleLabel.frame.origin.y, ScreenWidth, 1)];
        recordLineView.backgroundColor = [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:0.5];
        [self addSubview:recordLineView];
    }
    
    return self;
}

-(void)setInfoArray:(NSMutableArray *)detailArray{
    
    NSArray *titleArray = @[@"股票名称",@"交易本金",@"比例",@"保证金",@"交易综合费",@"服务费",@"预警金额",@"平仓金额",@"合约到期时间"];
    
    for (int i = 0; i<titleArray.count; i++) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 39+i*25, 105, 25)];
        titleLabel.text = titleArray[i];
        titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:titleLabel];
        
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width, titleLabel.frame.origin.y, ScreenWidth-50-titleLabel.frame.size.width, titleLabel.frame.size.height)];
        detailLabel.text = detailArray[i];
        detailLabel.font = [UIFont systemFontOfSize:13];
        detailLabel.textColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:0.7];
        [self addSubview:detailLabel];
        
        if (i == 1 || i == 3) {
            detailLabel.textColor = [UIColor redColor];
        }
    }
}

-(void)setRecordArray:(NSMutableArray *)detailArray{
    NSArray *titleArray = @[@"买入价",@"买入股数",@"买入时间",@"结算价",@"结算股数",@"结算时间",@"订单单号"];
    
    for (int i = 0; i<titleArray.count; i++) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 285+25+i*25, 105, 25)];
        titleLabel.text = titleArray[i];
        titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:titleLabel];
        
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width, titleLabel.frame.origin.y, ScreenWidth-50-titleLabel.frame.size.width, titleLabel.frame.size.height)];
        detailLabel.text = detailArray[i];
        detailLabel.font = [UIFont systemFontOfSize:13];
        detailLabel.textColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:0.7];
        [self addSubview:detailLabel];
    }
    
}

@end
