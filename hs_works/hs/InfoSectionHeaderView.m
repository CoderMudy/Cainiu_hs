//
//  InfoSectionHeaderView.m
//  hs
//
//  Created by PXJ on 16/3/23.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "InfoSectionHeaderView.h"
#import "UIImageView+WebCache.h"
#import "NewsDataModels.h"
#import "EmojiClass.h"
#define contentFont 14
@implementation InfoSectionHeaderView
{

    CGFloat _sectionHeight;
    NewsCmt * _conmentModel;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier CellHeight:(float)aCellHeight News:(News *)aNews;

- (instancetype)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _sectionHeight = frame.size.height;
            [self initCmtUI];
        
    }
    return self;
}
- (void)initCmtUI
{
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    line.backgroundColor= K_color_line;
    [self addSubview:line];
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth, _sectionHeight-1)];
    [self addSubview:self.backView];
    self.headerImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 36, 36)];
    self.headerImgV.layer.cornerRadius = 18;
    self.headerImgV.layer.masksToBounds = YES;
    self.headerImgV.layer.borderWidth = 1;
    self.headerImgV.layer.borderColor = K_color_infoBack.CGColor;
    self.headerImgV.backgroundColor =  K_color_infoBack;
    [self.backView addSubview:self.headerImgV];
    
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headerImgV.frame)+10, 12, ScreenWidth-80, 15)];
    self.userName.font = FontSize(12);
    self.userName.textColor = K_color_infoBlue;
    [self.backView addSubview:self.userName];
    
    self.cmtRemindImgV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-40, CGRectGetMinY(self.userName.frame), 18, 18)];
    self.cmtRemindImgV.image = [UIImage imageNamed:@"conmentTag"];
    [self.backView addSubview:self.cmtRemindImgV];

    self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headerImgV.frame)+10, CGRectGetMaxY(self.userName.frame), ScreenWidth-80, 15)];
    self.timeLab.textColor = K_color_grayBlack;
    self.timeLab.font = FontSize(12);
    [self.backView addSubview:self.timeLab];

    self.cmtLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headerImgV.frame)+10, CGRectGetMaxY(self.timeLab.frame)+10, ScreenWidth-80, CGRectGetHeight(self.backView.frame) -CGRectGetMaxY(self.timeLab.frame)-10)];
    self.cmtLab.font = FontSize(contentFont);
    self.cmtLab.numberOfLines = 0;
    [self.backView addSubview:self.cmtLab];
    
    
}

- (void)setSectionHeaderWithDetailCmtReply:(NewsCmtReplyList *)cmtReplyModel section:(int)section;
{
    
    self.backgroundColor = [UIColor whiteColor];
    _conmentModel = cmtReplyModel.cmt;
    
    [self.headerImgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[DataUsedEngine nullTrimString:_conmentModel.userHead]]] placeholderImage:[UIImage imageNamed:@"head_01"]];
    self.userName.text =  _conmentModel.userNick;
    self.timeLab.text = _conmentModel.createDate;
    
    NSString * cmtText = [EmojiClass decodeFromPercentEscapeString: _conmentModel.content];
    NSDictionary * dic  = [Helper setTextLineSpaceWithString:cmtText withFont:FontSize(12) withLineSpace:3  withTextlengthSpace:@0.0 paragraphSpacing:3];
    self.cmtLab.attributedText = [[NSAttributedString alloc] initWithString:cmtText attributes:dic];

    if (section==1)
    {
        self.backView.frame = CGRectMake(0, 30, ScreenWidth, _sectionHeight-30);
        
        UIImageView * cmtMark = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 55, 20)];
        cmtMark.image = [UIImage imageNamed:@"conmentMark"];
        [self addSubview:cmtMark];

        UILabel * cmtMarkLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(cmtMark.frame)-15, CGRectGetHeight(cmtMark.frame)*0.8)];
        cmtMarkLab.text = @"评论";
        cmtMarkLab.textColor = [UIColor whiteColor];
        cmtMarkLab.textAlignment = NSTextAlignmentCenter;
        cmtMarkLab.font = FontSize(12);
        [cmtMark addSubview:cmtMarkLab];
    }else
    {
        self.backView.frame = CGRectMake(0, 1, ScreenWidth, _sectionHeight-1);
    }
    self.cmtLab.frame = CGRectMake(CGRectGetMaxX(self.headerImgV.frame)+10, CGRectGetMaxY(self.timeLab.frame)+10, ScreenWidth-80, CGRectGetHeight(self.backView.frame) -CGRectGetMaxY(self.timeLab.frame)-10);

    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerClick)];
    [self.backView addGestureRecognizer:tap];
}
- (void)headerClick
{
    self.sectionHeaderClickBlock(_conmentModel.cmtIdentifier,_conmentModel.userNick);
}

@end
