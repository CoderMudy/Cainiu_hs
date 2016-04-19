//
//  NewsPageCell.m
//  hs
//
//  Created by PXJ on 16/3/16.
//  Copyright © 2016年 luckin. All rights reserved.
//
#define textStyleTextNum 50
#define newsContentFont 14
#define titleFont  17
#define lineSpace 6
#define textLengthSpace @0.2

#import "NewsPageCell.h"
#import <UIImageView+WebCache.h>

@implementation NewsPageCell
{
    News    *news;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier CellHeight:(float)aCellHeight News:(News *)aNews{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _cellHeight     = aCellHeight;
        if (aNews != nil) {
            news = aNews;
            [self loadUI];
        }
    }
    
    return self;
}

-(void)loadUI{

    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel = [[UILabel alloc]init ];
    self.titleLabel.font = FontSize(titleFont);
    [self addSubview:self.titleLabel];
    
    self.contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+5, ScreenWidth - 20*2, 0)];
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:news.bannerUrl]];
    self.contentImageView.clipsToBounds = YES;
    [self addSubview:self.contentImageView];
    
    self.contextLabel = [[UILabel alloc]init ];
    self.contextLabel.font = FontSize(newsContentFont);
    self.contextLabel.textColor = [UIColor grayColor];
    self.contextLabel.numberOfLines = 3;
    [self addSubview:self.contextLabel];
    

    //文字限制3行
    CGFloat sizeHeight = 0;
    NSString * titleText = news.title;
    NSString * conText = news.summary;
    if ([news.picFlag isEqualToString:@"0"])//纯文字
    {
        if (titleText.length >20)
        {
            titleText = [NSString stringWithFormat:@"%@...",[titleText substringToIndex:20]];
        }
        //正文限制
        if(conText.length>textStyleTextNum)
        {
            conText = [NSString stringWithFormat:@"%@...",[conText substringToIndex:textStyleTextNum]];
        }
        sizeHeight = [Helper getSpaceLabelHeight:conText withFont:FontSize(newsContentFont) withLineSpace:lineSpace size:CGSizeMake(ScreenWidth-40, 1000) textlengthSpace:textLengthSpace paragraphSpacing:10];

        self.titleLabel.frame = CGRectMake(20, 10, ScreenWidth - 20*2, 25);
        self.contextLabel.frame =  CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame) , ScreenWidth - 20*2, sizeHeight);
        self.contextLabel.numberOfLines = 3;
        self.contentImageView.frame = CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame), ScreenWidth, 0);
        self.contentImageView.hidden = YES;
        self.contextLabel.hidden = NO;
        
        NSDictionary * dic  = [Helper setTextLineSpaceWithString:conText withFont:FontSize(newsContentFont) withLineSpace:6  withTextlengthSpace:textLengthSpace paragraphSpacing:10];
        self.contextLabel.attributedText = [[NSAttributedString alloc] initWithString:conText attributes:dic];
        
    }else if([news.picFlag isEqualToString:@"1"])//图文详情（小图）
    {
        
        if (titleText.length >15) {
            titleText = [NSString stringWithFormat:@"%@...",[titleText substringToIndex:15]];
        }
        //正文限制
        if(conText.length>25){
            conText = [NSString stringWithFormat:@"%@...",[conText substringToIndex:25]];
        }
        self.contentImageView.frame = CGRectMake(20,10,100*ScreenWidth/375, 80*ScreenWidth/375);
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.contentImageView.frame)+10, 10, ScreenWidth - 20*2 -CGRectGetWidth(self.contentImageView.frame)-10, 25);
        self.contextLabel.frame =  CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) , CGRectGetWidth(self.titleLabel.frame), CGRectGetHeight(self.contentImageView.frame)-CGRectGetHeight(self.titleLabel.frame));
        self.contextLabel.numberOfLines = 2;
        self.contentImageView.hidden = NO;
        self.contextLabel.hidden = NO;
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:news.bannerUrl] placeholderImage:[UIImage imageNamed:@"512"]];
        self.contentImageView.contentMode = UIViewContentModeScaleToFill;
        NSDictionary * dic  = [Helper setTextLineSpaceWithString:conText withFont:FontSize(newsContentFont) withLineSpace:6  withTextlengthSpace:textLengthSpace paragraphSpacing:10];
        self.contextLabel.attributedText = [[NSAttributedString alloc] initWithString:conText attributes:dic];
        
        
    }else if([news.picFlag isEqualToString:@"2"])//纯图片（大图）
    {
        CGFloat contentImgHeight;
        
        if ([DataUsedEngine nullTrim:news.bannerUrl]&&news.bannerUrl.length>0) {
            contentImgHeight = (ScreenWidth-40)*0.56;
            
        }else{
            contentImgHeight = 0;
        }
        
        if (titleText.length >20) {
            titleText = [NSString stringWithFormat:@"%@...",[titleText substringToIndex:20]];
        }
        self.titleLabel.frame = CGRectMake(20, 10, ScreenWidth - 20*2, 25);
        self.contextLabel.frame =  CGRectMake(20, self.contentImageView.frame.origin.y + self.contentImageView.frame.size.height , ScreenWidth - 20*2, 0);
        self.contentImageView.frame = CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame), ScreenWidth-40, contentImgHeight);
        self.contentImageView.hidden = NO;
        self.contextLabel.hidden = YES;
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:news.bannerUrl] placeholderImage:[UIImage imageNamed:@"512"]];
        self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;

        
    }else{
    
        if (titleText.length >20)
        {
            titleText = [NSString stringWithFormat:@"%@...",[titleText substringToIndex:20]];
        }
        //正文限制
        if(conText.length>textStyleTextNum)
        {
            conText = [NSString stringWithFormat:@"%@...",[conText substringToIndex:textStyleTextNum]];
        }
        sizeHeight = [Helper getSpaceLabelHeight:conText withFont:FontSize(newsContentFont) withLineSpace:lineSpace size:CGSizeMake(ScreenWidth-40, 1000) textlengthSpace:textLengthSpace paragraphSpacing:10];
        
        self.titleLabel.frame = CGRectMake(20, 10, ScreenWidth - 20*2, 25);
        self.contextLabel.frame =  CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame) , ScreenWidth - 20*2, sizeHeight);
        self.contextLabel.numberOfLines = 3;
        self.contentImageView.frame = CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame), ScreenWidth, 0);
        self.contentImageView.hidden = YES;
        self.contextLabel.hidden = NO;
        
        NSDictionary * dic  = [Helper setTextLineSpaceWithString:conText withFont:FontSize(newsContentFont) withLineSpace:6  withTextlengthSpace:textLengthSpace paragraphSpacing:10];
        self.contextLabel.attributedText = [[NSAttributedString alloc] initWithString:conText attributes:dic];
        
    }

    self.titleLabel.text = news.title;

    self.signProView  = [[UILabel alloc]initWithFrame:CGRectMake(20, _cellHeight-20, 10, 10)];
    if ([news.top isEqualToString:@"1"]) {
        
        self.signProView.frame = CGRectMake(20, _cellHeight-20, 22, 12);
        self.signProView.text = @"置顶";
    }
    else if([news.hot isEqualToString:@"1"]&&![self isOverdueWithHotEndTime:news.hotEndTime]){
        
        self.signProView.frame = CGRectMake(20, _cellHeight-20, 22, 12);
        self.signProView.text = @"热点";
        
    }else{
        self.signProView.frame = CGRectMake(20, _cellHeight-20, 0, 12);
    }
    [self addSubview:self.signProView];
    
    self.sourceLabel   = [[UILabel alloc]initWithFrame:CGRectMake(self.signProView.frame.origin.x + self.signProView.frame.size.width + 5, self.signProView.frame.origin.y, ScreenWidth/2, self.signProView.frame.size.height)];
    self.sourceLabel.textColor = [UIColor lightGrayColor];
    self.sourceLabel.font = [UIFont systemFontOfSize:11];
    self.sourceLabel.text = news.outSourceName;
    [self addSubview:self.sourceLabel];
    
    self.commentAndReadLabel    = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 20 - ScreenWidth/2, self.sourceLabel.frame.origin.y, ScreenWidth/2, self.sourceLabel.frame.size.height)];
    self.commentAndReadLabel.textColor = [UIColor lightGrayColor];
    self.commentAndReadLabel.font = [UIFont systemFontOfSize:11];
    
    if (news.cmtCount.floatValue ==0 &&news.readCount.floatValue==0) {
        self.commentAndReadLabel.text = @"";
    }else{
        if ([[DataUsedEngine nullTrimString:news.permitComment] isEqualToString:@"1"]) {
            if(news.cmtCount.floatValue ==0)
            {
                self.commentAndReadLabel.text = [NSString stringWithFormat:@"%@阅读",news.readCount];
            }else if(news.readCount.floatValue==0)
            {
                self.commentAndReadLabel.text = [NSString stringWithFormat:@"%@评论",news.cmtCount];
            }else
            {
                self.commentAndReadLabel.text = [NSString stringWithFormat:@"%@评论  %@阅读",news.cmtCount,news.readCount];
            }
        }
        else{
            if(news.readCount.floatValue==0){
                self.commentAndReadLabel.text = @"";
            }else{
                self.commentAndReadLabel.text = [NSString stringWithFormat:@"%@阅读",news.readCount];
            }
        }
    }
    
    self.commentAndReadLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.commentAndReadLabel];
    self.separateLine = [[UILabel alloc] initWithFrame:CGRectMake(0, _cellHeight-0.5, ScreenWidth, 0.5)];
    self.separateLine.backgroundColor = K_color_line;
    [self addSubview:self.separateLine];
}

-(void)setCellHeight:(float)aCellHeight News:(News *)aNews indexPath:(NSIndexPath *)indexPath;
{
    _cellHeight     = aCellHeight;
    news            = aNews;
    self.separateLine.frame = CGRectMake(0, _cellHeight-0.5, ScreenWidth, 0.5);
    //文字限制3行
    CGFloat sizeHeight = 0;
    NSString * titleText = news.title;
    NSString * conText = news.summary;
    if ([news.picFlag isEqualToString:@"0"])//纯文字
    {
        if (titleText.length >20)
        {
            titleText = [NSString stringWithFormat:@"%@...",[titleText substringToIndex:20]];
        }
        //正文限制
        if(conText.length>textStyleTextNum)
        {
            conText = [NSString stringWithFormat:@"%@...",[conText substringToIndex:textStyleTextNum]];
        }
        sizeHeight = [Helper getSpaceLabelHeight:conText withFont:FontSize(newsContentFont) withLineSpace:lineSpace size:CGSizeMake(ScreenWidth-40, 1000) textlengthSpace:textLengthSpace paragraphSpacing:10];
        NSDictionary * dic  = [Helper setTextLineSpaceWithString:conText withFont:FontSize(newsContentFont) withLineSpace:6  withTextlengthSpace:textLengthSpace paragraphSpacing:10];
        self.contextLabel.attributedText = [[NSAttributedString alloc] initWithString:conText attributes:dic];

        
        self.titleLabel.frame = CGRectMake(20, 10, ScreenWidth - 20*2, 25);
        self.contextLabel.frame =  CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame) , ScreenWidth - 20*2, sizeHeight);
        self.contextLabel.numberOfLines = 3;
        self.contentImageView.frame = CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame), ScreenWidth-40, 0);
        self.contentImageView.hidden = YES;
        self.contextLabel.hidden = NO;
        

    }else if([news.picFlag isEqualToString:@"1"])//图文详情（小图）
    {
        
        if (titleText.length >15) {
            titleText = [NSString stringWithFormat:@"%@...",[titleText substringToIndex:15]];
        }
        //正文限制
        if(conText.length>25){
            conText = [NSString stringWithFormat:@"%@...",[conText substringToIndex:25]];
        }
        self.contentImageView.frame = CGRectMake(20,10,100*ScreenWidth/375, 80*ScreenWidth/375);
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.contentImageView.frame)+10, 10, ScreenWidth - 20*2 -CGRectGetWidth(self.contentImageView.frame)-10, 25);
        self.contextLabel.frame =  CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) , CGRectGetWidth(self.titleLabel.frame), CGRectGetHeight(self.contentImageView.frame)-CGRectGetHeight(self.titleLabel.frame));
        self.contextLabel.numberOfLines = 2;
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:news.bannerUrl] placeholderImage:[UIImage imageNamed:@"512"]];
        self.contentImageView.hidden = NO;
        self.contentImageView.contentMode = UIViewContentModeScaleToFill;
        self.contextLabel.hidden = NO;
        NSDictionary * dic  = [Helper setTextLineSpaceWithString:conText withFont:FontSize(newsContentFont) withLineSpace:6  withTextlengthSpace:textLengthSpace paragraphSpacing:10];
        self.contextLabel.attributedText = [[NSAttributedString alloc] initWithString:conText attributes:dic];
        
        
    }else if([news.picFlag isEqualToString:@"2"])//纯图片（大图）
    {
        CGFloat contentImgHeight;

        if ([DataUsedEngine nullTrim:news.bannerUrl]&&news.bannerUrl.length>0)
        {
            contentImgHeight = (ScreenWidth-40)*0.56;
            
        }else{
            contentImgHeight = 0;
        }
        
        if (titleText.length >20)
        {
            titleText = [NSString stringWithFormat:@"%@...",[titleText substringToIndex:20]];
        }
        self.titleLabel.frame = CGRectMake(20, 10, ScreenWidth - 20*2, 25);
        self.contextLabel.frame =  CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame), ScreenWidth - 20*2, 0);
        self.contentImageView.frame = CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame), ScreenWidth-40, contentImgHeight);
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:news.bannerUrl]];
        self.contentImageView.hidden = NO;
        self.contextLabel.hidden = YES;
        self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    }else
    {
        if (titleText.length >20)
        {
            titleText = [NSString stringWithFormat:@"%@...",[titleText substringToIndex:20]];
        }
        //正文限制
        if(conText.length>textStyleTextNum)
        {
            conText = [NSString stringWithFormat:@"%@...",[conText substringToIndex:textStyleTextNum]];
        }
        sizeHeight = [Helper getSpaceLabelHeight:conText withFont:FontSize(newsContentFont) withLineSpace:lineSpace size:CGSizeMake(ScreenWidth-40, 1000) textlengthSpace:textLengthSpace paragraphSpacing:10];
        NSDictionary * dic  = [Helper setTextLineSpaceWithString:conText withFont:FontSize(newsContentFont) withLineSpace:6  withTextlengthSpace:textLengthSpace paragraphSpacing:10];
        self.contextLabel.attributedText = [[NSAttributedString alloc] initWithString:conText attributes:dic];
        
        
        self.titleLabel.frame = CGRectMake(20, 10, ScreenWidth - 20*2, 25);
        self.contextLabel.frame =  CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame) , ScreenWidth - 20*2, sizeHeight);
        self.contextLabel.numberOfLines = 3;
        self.contentImageView.frame = CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame), ScreenWidth-40, 0);
        self.contentImageView.hidden = YES;
        self.contextLabel.hidden = NO;
        
    }
    self.titleLabel.text = news.title;
    if ([news.top isEqualToString:@"1"]&&indexPath.row==0)
    {
        self.signProView.frame = CGRectMake(20, _cellHeight-20, 22, 12);
        self.signProView.text = @"置顶";
    }
    else if([news.hot isEqualToString:@"1"]&&![self isOverdueWithHotEndTime:news.hotEndTime])
    {
        self.signProView.frame = CGRectMake(20, _cellHeight-20, 22, 12);
        self.signProView.text = @"热点";
    }else
    {
        self.signProView.frame = CGRectMake(20, _cellHeight-20, 0, 12);
        self.signProView.text = @"";
    }
    
    self.signProView.font = FontSize(8);
    self.signProView.textColor = K_color_red;
    self.signProView.layer.cornerRadius = 2;
    self.signProView.layer.masksToBounds = YES;
    self.signProView.layer.borderWidth = 0.7;
    self.signProView.layer.borderColor = K_color_red.CGColor;
    self.signProView.textAlignment = NSTextAlignmentCenter;
    
    self.sourceLabel.frame = CGRectMake(CGRectGetMaxX(self.signProView.frame) + 5, CGRectGetMinY(self.signProView.frame), ScreenWidth/2, self.signProView.frame.size.height);
    self.sourceLabel.text = news.outSourceName;
    if (news.cmtCount.floatValue ==0 &&news.readCount.floatValue==0)
    {
        self.commentAndReadLabel.hidden = YES;
    }else{
        self.commentAndReadLabel.hidden = NO;
        self.commentAndReadLabel.frame = CGRectMake(ScreenWidth - 20 - ScreenWidth/2, self.sourceLabel.frame.origin.y, ScreenWidth/2, self.sourceLabel.frame.size.height);
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
                self.commentAndReadLabel.text = [NSString stringWithFormat:@"%@评论",news.cmtCount];
            }else
            {
                self.commentAndReadLabel.text = [NSString stringWithFormat:@"%@评论  %@阅读",news.cmtCount,news.readCount];
            }
        }
        else{
            if(news.readCount.floatValue==0){
                self.commentAndReadLabel.text = @"";
            }else{
                self.commentAndReadLabel.text = [NSString stringWithFormat:@"%@阅读",news.readCount];
            }
        }
    }
    if ([news.readStatus isEqualToString:@"1"]) {
        self.titleLabel.textColor  = self.contextLabel.textColor = [UIColor lightGrayColor];
    }else{
        self.titleLabel.textColor = [UIColor blackColor];
        self.contextLabel.textColor = [UIColor grayColor];
    }
}
- (BOOL)isOverdueWithHotEndTime:(NSString *)hotEndTime
{
    NSDateFormatter * dm = [[NSDateFormatter alloc]init];
    //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
    [dm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * oldDate = [dm dateFromString:hotEndTime];
    long dd = (long)[[NSDate date] timeIntervalSince1970] - [oldDate timeIntervalSince1970];
    if (dd>0)
    {
        return YES;
    }else
    {
        return NO;
    }
}
@end
