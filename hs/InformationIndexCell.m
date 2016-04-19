//
//  InformationIndexCell.m
//  hs
//
//  Created by RGZ on 15/12/29.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "InformationIndexCell.h"
#import <UIImageView+WebCache.h>

@implementation InformationIndexCell
{
    float   contentHeight;
    News    *news;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier CellHeight:(float)aCellHeight ContentHeight:(float)aContentHeight News:(News *)aNews{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _cellHeight     = aCellHeight;
        contentHeight   = aContentHeight;
        if (aNews != nil) {
            news = aNews;
            [self loadUI];
        }
    }
    
    return self;
}

-(void)loadUI{
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 18)];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.text = @"00:00";
    [self addSubview:self.timeLabel];
    if (![news.createDate isEqualToString:@""] && news.createDate.length >= 17) {
        self.timeLabel.text = [[news.createDate substringFromIndex:11] substringToIndex:5];
    }
    
    self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height, 28, 15)];
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.font = [UIFont systemFontOfSize:11];
    self.typeLabel.center = CGPointMake(self.timeLabel.center.x, self.typeLabel.center.y+3);
    self.typeLabel.text = news.sectionName;
    self.typeLabel.backgroundColor = Color_subRed;
    self.typeLabel.clipsToBounds = YES;
    self.typeLabel.layer.cornerRadius = 3;
    self.typeLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.typeLabel];
    
    self.roundView = [[UIView alloc]initWithFrame:CGRectMake(0, self.typeLabel.frame.origin.y + self.typeLabel.frame.size.height + 3, 5, 5)];
    self.roundView.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1];
    self.roundView.center = CGPointMake(self.typeLabel.center.x, self.roundView.center.y);
    self.roundView.clipsToBounds = YES;
    self.roundView.layer.cornerRadius = 5.0/2;
    [self addSubview:self.roundView];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.roundView.frame.origin.y + self.roundView.frame.size.height, 1, self.cellHeight - self.roundView.frame.origin.y + self.roundView.frame.size.height + 16)];
    self.lineView.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1];
    self.lineView.center = CGPointMake(self.roundView.center.x, self.lineView.center.y);
    [self addSubview:self.lineView];
    
    if (self.isLastNews) {
        self.roundView.hidden = YES;
        self.lineView.hidden = YES;
    }
    else{
        self.roundView.hidden = NO;
        self.lineView.hidden = NO;
    }
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(57, 0, ScreenWidth - 57 - 15, self.cellHeight)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.clipsToBounds = YES;
    self.bgView.layer.cornerRadius = 2;
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1].CGColor;
    [self addSubview:self.bgView];
    
    self.signView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 13, 9, 16*9/12.0)];
    self.signView.image = [UIImage imageNamed:@"news_sign"];
    [self addSubview:self.signView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.bgView.frame.size.width - 10*2, 25)];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.text = news.title;
    [self.bgView addSubview:self.titleLabel];
    
    self.contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+5, self.bgView.frame.size.width - 10*2, 0)];
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:news.bannerUrl]];
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.contentImageView.clipsToBounds = YES;
    [self.bgView addSubview:self.contentImageView];
    
    self.contextLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.contentImageView.frame.origin.y + self.contentImageView.frame.size.height , self.bgView.frame.size.width - 10*2, contentHeight)];
    self.contextLabel.font = [UIFont systemFontOfSize:13];
    self.contextLabel.textColor = [UIColor grayColor];
    self.contextLabel.numberOfLines = 3;
    self.contextLabel.text = news.summary;
    [self.bgView addSubview:self.contextLabel];
    
    //策略不显示title
    if ([news.section isEqualToString:@"57"]) {
        self.titleLabel.frame = CGRectMake(10, 10, self.bgView.frame.size.width - 10*2, 1);
        self.titleLabel.text = @"";
        self.contentImageView.frame = CGRectMake(10, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+5, self.bgView.frame.size.width - 10*2, 0);
        self.contextLabel.frame = CGRectMake(10, self.contentImageView.frame.origin.y + self.contentImageView.frame.size.height , self.bgView.frame.size.width - 10*2, contentHeight);
        self.contextLabel.textColor = Color_subRed;
    }else{
        self.titleLabel.frame = CGRectMake(10, 10, self.bgView.frame.size.width - 10*2, 25);
        self.contentImageView.frame = CGRectMake(10, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+5, self.bgView.frame.size.width - 10*2, self.contentImageView.frame.size.height);
        self.contextLabel.frame = CGRectMake(10, self.contentImageView.frame.origin.y + self.contentImageView.frame.size.height , self.bgView.frame.size.width - 10*2, contentHeight);
        self.contextLabel.textColor = [UIColor grayColor];
    }
    
    self.signProView  = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.contextLabel.frame.origin.y + self.contextLabel.frame.size.height + 9, 10, 10)];
    self.signProView.image = [UIImage imageNamed:@"news_pen"];
    [self.bgView addSubview:self.signProView];
    
    self.proLabel   = [[UILabel alloc]initWithFrame:CGRectMake(self.signProView.frame.origin.x + self.signProView.frame.size.width + 5, self.signProView.frame.origin.y, self.bgView.frame.size.width/2, self.signProView.frame.size.height)];
    self.proLabel.textColor = [UIColor lightGrayColor];
    self.proLabel.font = [UIFont systemFontOfSize:11];
    self.proLabel.text = news.plateName;
    [self.bgView addSubview:self.proLabel];
    
    self.commentAndReadLabel    = [[UILabel alloc]initWithFrame:CGRectMake(self.bgView.frame.size.width - 10 - self.bgView.frame.size.width/2, self.proLabel.frame.origin.y, self.bgView.frame.size.width/2, self.proLabel.frame.size.height)];
    self.commentAndReadLabel.textColor = [UIColor lightGrayColor];
    self.commentAndReadLabel.font = [UIFont systemFontOfSize:11];
    if ([[DataUsedEngine nullTrimString:news.permitComment] isEqualToString:@"1"]) {
        self.commentAndReadLabel.text = [NSString stringWithFormat:@"评论(%@)     %@阅读",news.cmtCount,news.readCount];
    }
    else{
        self.commentAndReadLabel.text = [NSString stringWithFormat:@"%@阅读",news.readCount];
    }
    self.commentAndReadLabel.textAlignment = NSTextAlignmentRight;
    [self.bgView addSubview:self.commentAndReadLabel];
}

-(void)setCellHeight:(float)aCellHeight ContentHeight:(float)aContentHeight News:(News *)aNews isLastNews:(BOOL)isLastNews{
    
    _cellHeight     = aCellHeight;
    contentHeight   = aContentHeight;
    news            = aNews;
    _isLastNews     = isLastNews;
    
    if (![news.createDate isEqualToString:@""] && news.createDate.length >= 17) {
        self.timeLabel.text = [[news.createDate substringFromIndex:11] substringToIndex:5];
    }
    
    self.typeLabel.text = news.sectionName;
    
    if (self.isLastNews) {
        self.roundView.hidden = YES;
        self.lineView.hidden = YES;
    }
    else{
        self.roundView.hidden = NO;
        self.lineView.hidden = NO;
        self.roundView.frame = CGRectMake(0, self.typeLabel.frame.origin.y + self.typeLabel.frame.size.height + 3, 5, 5);
        self.roundView.center = CGPointMake(self.typeLabel.center.x, self.roundView.center.y);
        
        self.lineView.frame = CGRectMake(0, self.roundView.frame.origin.y + self.roundView.frame.size.height, 1, self.cellHeight - (self.roundView.frame.origin.y + self.roundView.frame.size.height) + 20);
        self.lineView.center = CGPointMake(self.roundView.center.x, self.lineView.center.y);
    }
    
    self.bgView.frame = CGRectMake(57, 0, ScreenWidth - 57 - 15, self.cellHeight);
    self.bgView.clipsToBounds = YES;
    self.bgView.layer.cornerRadius = 2;
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1].CGColor;
    
    self.signView.frame = CGRectMake(50, 13, 9, 16*9/12.0);
    
    self.titleLabel.frame = CGRectMake(10, 10, self.bgView.frame.size.width - 10*2, 25);
    self.titleLabel.text = news.title;
    
    //策略不显示title
    if ([news.section isEqualToString:@"57"]) {
        self.titleLabel.frame = CGRectMake(10, 10, self.bgView.frame.size.width - 10*2, 1);
        self.titleLabel.text = @"";
        self.contextLabel.textColor = Color_subRed;
    }else{
        self.titleLabel.frame = CGRectMake(10, 10, self.bgView.frame.size.width - 10*2, 25);
        self.contextLabel.textColor = [UIColor grayColor];
    }
    
    if (![news.bannerUrl isEqualToString:@""] && news.bannerUrl.length > 4) {
        self.contentImageView.frame = CGRectMake(10, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+5, self.bgView.frame.size.width - 10*2, 120);
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:news.bannerUrl]];
    }
    else{
        self.contentImageView.frame = CGRectMake(10, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height, self.bgView.frame.size.width - 10*2, 0);
    }
    
    self.contextLabel.frame = CGRectMake(10, self.contentImageView.frame.origin.y + self.contentImageView.frame.size.height , self.bgView.frame.size.width - 10*2, contentHeight);
    self.contextLabel.text = news.summary;
    
    self.signProView.frame  = CGRectMake(10, self.contextLabel.frame.origin.y + self.contextLabel.frame.size.height + 9, 10, 10);
    
    self.proLabel.frame = CGRectMake(self.signProView.frame.origin.x + self.signProView.frame.size.width + 5, self.signProView.frame.origin.y, self.bgView.frame.size.width/2, self.signProView.frame.size.height);
    self.proLabel.text = news.plateName;
    
    
    self.commentAndReadLabel.frame = CGRectMake(self.bgView.frame.size.width - 10 - self.bgView.frame.size.width/2, self.proLabel.frame.origin.y, self.bgView.frame.size.width/2, self.proLabel.frame.size.height);
    if ([[DataUsedEngine nullTrimString:news.permitComment] isEqualToString:@"1"]) {
        self.commentAndReadLabel.text = [NSString stringWithFormat:@"评论(%@)     %@阅读",news.cmtCount,news.readCount];
    }
    else{
        self.commentAndReadLabel.text = [NSString stringWithFormat:@"%@阅读",news.readCount];
    }
}

@end
