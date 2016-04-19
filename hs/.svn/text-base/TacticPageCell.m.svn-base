//
//  InformationIndexCell.m
//  hs
//
//  Created by RGZ on 15/12/29.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "TacticPageCell.h"
#import <UIImageView+WebCache.h>

@implementation TacticPageCell
{
    float   contentHeight;
    News    *news;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier CellHeight:(float)aCellHeight ContentHeight:(float)aContentHeight News:(News *)aNews
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _cellHeight     = aCellHeight;
        contentHeight   = aContentHeight;
        if (aNews != nil)
        {
            news = aNews;
            [self loadUI];
        }
    }
    
    return self;
}

-(void)loadUI{
    self.backgroundColor = [UIColor whiteColor];
  
 
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(30, 25, ScreenWidth - 40, _cellHeight -30)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    
    self.separateLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.bgView.frame)+10, CGRectGetMaxY(self.bgView.frame), CGRectGetWidth(self.bgView.frame)-20, 0.5)];
    self.separateLine.backgroundColor = K_color_line;
    [self addSubview:self.separateLine];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.bgView.frame) - 10*2, 25)];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.text = news.title;
    [self.bgView addSubview:self.titleLabel];
    
    self.contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(self.titleLabel.frame)+5, CGRectGetWidth(self.bgView.frame) - 10*2, 0)];
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:news.bannerUrl]];
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.contentImageView.clipsToBounds = YES;
    [self.bgView addSubview:self.contentImageView];
    
    self.contextLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(self.contentImageView.frame) ,CGRectGetWidth(self.bgView.frame) - 10*2, contentHeight)];
    self.contextLabel.font = [UIFont systemFontOfSize:13];
    self.contextLabel.textColor = [UIColor grayColor];
    self.contextLabel.numberOfLines = 3;
    self.contextLabel.text = news.summary;
    [self.bgView addSubview:self.contextLabel];
    self.titleLabel.frame = CGRectMake(10, 10, CGRectGetWidth(self.bgView.frame) - 10*2, 25);
    self.contentImageView.frame = CGRectMake(10,CGRectGetMaxY(self.titleLabel.frame) +5, CGRectGetWidth(self.bgView.frame) - 10*2,CGRectGetHeight(self.contentImageView.frame));
    self.contextLabel.frame = CGRectMake(10,CGRectGetMaxY(self.contentImageView.frame), CGRectGetWidth(self.bgView.frame)- 10*2, contentHeight);
    //策略不显示title
    if ([news.section isEqualToString:@"57"])
    {
        self.contextLabel.textColor = Color_subRed;
    }else{
        self.contextLabel.textColor = [UIColor grayColor];
    }
    self.signProView  = [[UIImageView alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(self.contextLabel.frame)+ 9, 10, 10)];
//    self.signProView.image = [UIImage imageNamed:@"news_pen"];
    [self.bgView addSubview:self.signProView];
    
    self.proLabel   = [[UILabel alloc]init];
    self.proLabel.textColor = [UIColor lightGrayColor];
    self.proLabel.font = [UIFont systemFontOfSize:11];
    [self.bgView addSubview:self.proLabel];
    
    self.commentAndReadLabel    = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bgView.frame) - 10 - CGRectGetWidth(self.bgView.frame)/2,CGRectGetMinY(self.proLabel.frame), CGRectGetWidth(self.bgView.frame)/2,CGRectGetHeight(self.proLabel.frame))];
    self.commentAndReadLabel.textColor = [UIColor lightGrayColor];
    self.commentAndReadLabel.font = [UIFont systemFontOfSize:11];
    
    self.proLabel.frame = CGRectMake(CGRectGetMaxX(self.signProView.frame) + 5, CGRectGetMinY(self.signProView.frame), CGRectGetWidth(self.bgView.frame)/2,CGRectGetHeight(self.signProView.frame));
    self.proLabel.text = news.plateName;
    if (self.proLabel.text.length>0) {
        self.signProView.image = [UIImage imageNamed:@"news_pen"];
    }else{
        self.signProView.image = [UIImage imageNamed:@""];
    }
    
    if (news.cmtCount.floatValue ==0 &&news.readCount.floatValue==0)
    {
        self.commentAndReadLabel.hidden = YES;
    }else{
        self.commentAndReadLabel.hidden = NO;
    }
    
    if (news.cmtCount.floatValue ==0 &&news.readCount.floatValue==0)
    {
        self.commentAndReadLabel.text = @"";
    }else{
        if ([[DataUsedEngine nullTrimString:news.permitComment] isEqualToString:@"1"])
        {
            if(news.cmtCount.floatValue ==0)
            {
                self.commentAndReadLabel.text = [NSString stringWithFormat:@"%@阅读",news.readCount];
            }else if(news.readCount.floatValue==0)
            {
                self.commentAndReadLabel.text = [NSString stringWithFormat:@"评论(%@)",news.cmtCount];
            }else
            {
                self.commentAndReadLabel.text = [NSString stringWithFormat:@"评论(%@)  %@阅读",news.cmtCount,news.readCount];
            }
        }
        else{
            if(news.readCount.floatValue==0)
            {
                self.commentAndReadLabel.text = @"";
            }else
            {
                self.commentAndReadLabel.text = [NSString stringWithFormat:@"%@阅读",news.readCount];
            }
        }
    }
    self.commentAndReadLabel.textAlignment = NSTextAlignmentRight;
    [self.bgView addSubview:self.commentAndReadLabel];
    
    [self initSeparateLine];

}
//初始化策略时间轴分割线
- (void)initSeparateLine
{
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(20,0, 1, _cellHeight)];
    lineView.backgroundColor = K_color_orangeLine;
    lineView.tag = 1999;
    [self addSubview:lineView];
    
    UIView * horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(20, 15, 20, 1)];
    horizontalLine.backgroundColor = K_color_orangeLine;
    [self addSubview:horizontalLine];
    
    self.roundView = [[UIView alloc]init ];
    self.roundView.center = CGPointMake(20, 15);
    self.roundView.bounds = CGRectMake(0, 0, 8, 8);
    self.roundView.backgroundColor = K_color_orangeLine;
    self.roundView.layer.cornerRadius = 4;
    self.roundView.clipsToBounds = YES;
    self.roundView.layer.borderWidth = 1.5;
    self.roundView.layer.borderColor = [K_color_orangeBack CGColor];
    [self addSubview:self.roundView];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(horizontalLine.frame), CGRectGetMinY(horizontalLine.frame)-10, 50, 21)];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.text = @"00:00";
    self.timeLabel.textColor = K_color_orangeLine;
    [self addSubview:self.timeLabel];
    if (![news.createDate isEqualToString:@""] && news.createDate.length >= 17)
    {
        self.timeLabel.text = [[news.createDate substringFromIndex:11] substringToIndex:5];
    }
}

-(void)setCellHeight:(float)aCellHeight ContentHeight:(float)aContentHeight News:(News *)aNews isLastNews:(BOOL)isLastNews{
    
    _cellHeight     = aCellHeight;
    contentHeight   = aContentHeight;
    news            = aNews;
    UIView * verticalLine = [self viewWithTag:1999];
    verticalLine.frame =  CGRectMake(20,0, 1, _cellHeight);
   
    if (![news.createDate isEqualToString:@""] && news.createDate.length >= 17)
    {
        self.timeLabel.text = [[news.createDate substringFromIndex:11] substringToIndex:5];
    }
    
    self.bgView.frame = CGRectMake(30, 25, ScreenWidth - 40, _cellHeight -30);
    self.separateLine.frame = CGRectMake(CGRectGetMinX(self.bgView.frame)+10, CGRectGetMaxY(self.bgView.frame), CGRectGetWidth(self.bgView.frame)-20, 0.5);
    
    self.titleLabel.frame = CGRectMake(10, 10, CGRectGetWidth(self.bgView.frame) - 10*2, 25);
    self.titleLabel.text = news.title;
    //策略不显示title
    if ([news.section isEqualToString:@"57"])
    {
        self.contextLabel.textColor = Color_subRed;
    }else{
        self.contextLabel.textColor = [UIColor grayColor];
    }
    
    if (![news.bannerUrl isEqualToString:@""] && news.bannerUrl.length > 4)
    {
        self.contentImageView.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame)+5, CGRectGetWidth(self.bgView.frame) - 10*2, 125);
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:news.bannerUrl]];
    }
    else{
        self.contentImageView.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame)+5,CGRectGetWidth(self.bgView.frame) - 10*2, 0);
    }
    self.contextLabel.frame = CGRectMake(10, CGRectGetMaxY(self.contentImageView.frame) , CGRectGetWidth(self.bgView.frame) - 10*2, aContentHeight);
    self.contextLabel.text = news.summary;
    
    self.signProView.frame  = CGRectMake(10, CGRectGetMaxY(self.contextLabel.frame) + 9, 10, 10);
    
    self.proLabel.frame = CGRectMake(CGRectGetMaxX(self.signProView.frame) + 5,CGRectGetMinY(self.signProView.frame), CGRectGetWidth(self.bgView.frame)/2,CGRectGetHeight(self.signProView.frame));
    self.proLabel.text = news.plateName;
    if (self.proLabel.text.length>0) {
        self.signProView.image = [UIImage imageNamed:@"news_pen"];
    }else{
        self.signProView.image = [UIImage imageNamed:@""];
    }

    if (news.cmtCount.floatValue ==0 &&news.readCount.floatValue==0)
    {
        self.commentAndReadLabel.hidden = YES;
    }else{
        self.commentAndReadLabel.hidden = NO;
        self.commentAndReadLabel.frame = CGRectMake(CGRectGetWidth(self.bgView.frame) - 10 - CGRectGetWidth(self.bgView.frame)/2, CGRectGetMinY(self.signProView.frame), CGRectGetWidth(self.bgView.frame)/2, CGRectGetHeight(self.proLabel.frame));
    }
    if (news.cmtCount.floatValue ==0 &&news.readCount.floatValue==0)
    {
        self.commentAndReadLabel.text = @"";
    }else
    {
        if ([[DataUsedEngine nullTrimString:news.permitComment] isEqualToString:@"1"])
        {
            if(news.cmtCount.floatValue ==0)
            {
                self.commentAndReadLabel.text = [NSString stringWithFormat:@"%@阅读",news.readCount];
            }else if(news.readCount.floatValue==0)
            {
                self.commentAndReadLabel.text = [NSString stringWithFormat:@"评论(%@)",news.cmtCount];
            }else
            {
                self.commentAndReadLabel.text = [NSString stringWithFormat:@"评论(%@)  %@阅读",news.cmtCount,news.readCount];
            }
        }
        else{
            if(news.readCount.floatValue==0)
            {
                self.commentAndReadLabel.text = @"";
            }else
            {
                self.commentAndReadLabel.text = [NSString stringWithFormat:@"%@阅读",news.readCount];
            }
        }
    }
}

@end
