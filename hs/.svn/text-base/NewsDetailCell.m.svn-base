//
//  NewsDetailCell.m
//  hs
//
//  Created by PXJ on 16/3/24.
//  Copyright © 2016年 luckin. All rights reserved.
//
#define contentFont 17
#define lineSpace 6
#define openBtnTag  19999
#define textLengthSpace @0.2f
#import "NewsDetailCell.h"
#import "NewsReply.h"
#import "EmojiClass.h"
@implementation NewsDetailCell
{
    NSIndexPath * _indexPath;
    NSString * _showImgUrlStr;
    UIButton * showimgBtn;
    BOOL _isOpen;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        if ([reuseIdentifier isEqualToString:@"newsContentCell"] )
        {
            [self initCellUI];

        }else if ([reuseIdentifier isEqualToString:@"newsConmentCell"] )
        {
            [self initCmtCellUI];
        }
        
        
    }
    return self;
}
- (void)initCellUI
{
    _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-40, 0)];
    _contentLab.numberOfLines = 0;
    _contentLab.textColor = K_color_grayBlack;
    _contentLab.font = FontSize(contentFont);
    [self addSubview:_contentLab];
    _contentImgV =  [[UIImageView alloc] initWithFrame:CGRectMake(40, 0, ScreenWidth-40-contentFont*2, 0)];
    [self addSubview:_contentImgV];
    _contentImgV.userInteractionEnabled = YES;
    UITapGestureRecognizer * imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageCick)];
    [self.contentImgV addGestureRecognizer:imgTap];

}
- (void)setContentCellWithContentString:(NSString  *)string;
{
    
    if ([string rangeOfString:@".png"].location !=NSNotFound||[string rangeOfString:@".jpg"].location !=NSNotFound)
    {
        
        
        NSMutableDictionary * contentdImgDic = [CacheEngine getNewsDetailImage];
        UIImage * img ;
        if ([DataUsedEngine nullTrim:[contentdImgDic objectForKey:string]])
        {
            img = [contentdImgDic objectForKey:string];
        }else
        {
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
            img = [UIImage imageWithData:data];
        }
        _showImgUrlStr = string;
        CGSize  imgSize = img.size;
        
        if (imgSize.width==0 || imgSize.height==0)
        {
            _contentImgV.frame = CGRectMake(40, 0, ScreenWidth-40-contentFont*2, 0);
 
        }else
        {
            _contentImgV.frame = CGRectMake(40, 0, ScreenWidth-40-contentFont*2, imgSize.height*(ScreenWidth-80)/imgSize.width);
                    _contentImgV.image = img;

        }
        _contentLab.hidden = YES;
        _contentImgV.hidden = NO;
        
    }else
    {
        _contentLab.hidden = NO;
        _contentImgV.hidden = YES;
  
         NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paraStyle.alignment = NSTextAlignmentLeft;
        paraStyle.lineSpacing = lineSpace;
        paraStyle.paragraphSpacing = 10;
        paraStyle.hyphenationFactor = 1.0;
        paraStyle.firstLineHeadIndent = 0.0;
        paraStyle.paragraphSpacingBefore = 0.0;
        paraStyle.headIndent = 0;
        paraStyle.tailIndent = 0;
        NSDictionary *dic = @{NSFontAttributeName:FontSize(contentFont),
                              NSParagraphStyleAttributeName:paraStyle,
                              NSKernAttributeName:textLengthSpace,
                              NSForegroundColorAttributeName:K_color_black
                              };
        [attrStr addAttributes:dic range:NSMakeRange(0, attrStr.length)];
        CGFloat attrStrHeight = [Helper getSpaceLabelHeight:(NSString *)attrStr.mutableString withFont:FontSize(contentFont) withLineSpace:lineSpace size:CGSizeMake(ScreenWidth-40, 100000) textlengthSpace:textLengthSpace paragraphSpacing:10];
        _contentLab.frame = CGRectMake(20, 0, ScreenWidth-40, attrStrHeight);
        _contentLab.attributedText = attrStr;
    }

}

- (void)initCmtCellUI
{
    
    
    _firstRowBack = [[UIView alloc] initWithFrame:CGRectMake(55, 0,ScreenWidth-70 , 30)];
    _firstRowBack.hidden = YES;
    [self addSubview:_firstRowBack];
    
    UIImageView * messageTag = [[UIImageView alloc] initWithFrame:CGRectMake(15, 4, 12, 6)];
    messageTag.image = [UIImage imageNamed:@"conmentMessageTag"];
    [_firstRowBack addSubview:messageTag];
    
    UIView * firstBack = [[UIView alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(_firstRowBack.frame), 20)];
    firstBack.backgroundColor= K_color_infoBack;
    [_firstRowBack addSubview:firstBack];
    
    _cmtBackView = [[UIView alloc] initWithFrame:CGRectMake(55, 0, ScreenWidth-70, 0)];
    _cmtBackView.backgroundColor = K_color_infoBack;
    _cmtBackView.userInteractionEnabled = YES;
    [self addSubview:_cmtBackView];
    
    _cmtLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, ScreenWidth-90,CGRectGetHeight(_cmtBackView.frame))];
    _cmtLab.font = FontSize(12);
    _cmtLab.backgroundColor = K_color_infoBack;
    _cmtLab.numberOfLines = 0;
    [_cmtBackView addSubview:_cmtLab];
    

    _openOrCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _openOrCloseBtn.frame = CGRectMake(ScreenWidth-70, -5, 50, 50);
    _openOrCloseBtn.tag = 19999;
    _openOrCloseBtn.hidden = YES;
    [_openOrCloseBtn setTitle:@"展开" forState:UIControlStateNormal];
    [_openOrCloseBtn addTarget:self action:@selector(openOrCloseReplyList) forControlEvents:UIControlEventTouchUpInside];
    [_openOrCloseBtn setTitleColor:K_color_infoBlue forState:UIControlStateNormal];
    [_openOrCloseBtn.titleLabel setFont:FontSize(10)];
    [self addSubview:_openOrCloseBtn];
    
    _openOrCloseImgV = [[UIImageView alloc] init];
    _openOrCloseImgV.hidden = YES;
    _openOrCloseImgV.center = CGPointMake(CGRectGetMaxX(_openOrCloseBtn.frame)-5, _openOrCloseBtn.center.y);
    _openOrCloseImgV.bounds = CGRectMake(0, 0, 6, 3);
    [self addSubview:_openOrCloseImgV];
    
}

- (void)setConmentCellWithInfo:(NewsReply*)replyModel indexPath:(NSIndexPath *)indexPath allrowNums:(NSInteger)numRows isOpen:(BOOL)isOpen;
{
    _indexPath = indexPath;
    _isOpen = isOpen;
    if (numRows>5&&indexPath.row ==0)
    {
        
    }else{
        _openOrCloseBtn.hidden = YES;
        _openOrCloseImgV.hidden = YES;
    }
    NSString * replyContent = [EmojiClass decodeFromPercentEscapeString:replyModel.replyContent];
    NSString * replyUserNick = [DataUsedEngine nullTrimString:replyModel.replyUserNick expectString:@""];
    NSString * upUserNick = [DataUsedEngine nullTrimString:replyModel.upUserNick expectString:@""];
    NSString * cmtText = [NSString stringWithFormat:@"%@ 回复 %@: %@",replyUserNick,upUserNick,replyContent];
    NSMutableAttributedString * atrCmtText = [Helper multiplicityText:cmtText from:0 to:(int)replyUserNick.length color:K_color_infoBlue];
    atrCmtText = [Helper multableText:atrCmtText from:(int)[[NSString stringWithFormat:@"%@ 回复:",replyUserNick] length] to:(int)upUserNick.length+1 color:K_color_infoBlue];
    
    
    NSDictionary * dic  = [Helper setTextLineSpaceWithString:cmtText withFont:FontSize(12) withLineSpace:3  withTextlengthSpace:@0.0 paragraphSpacing:3];
    [atrCmtText addAttributes:dic range:NSMakeRange(0, cmtText.length)];
    CGFloat rowCellHeight = [Helper getSpaceLabelHeight:cmtText withFont:FontSize(12) withLineSpace:3 size:CGSizeMake(ScreenWidth-70, 100000) textlengthSpace:@0.0 paragraphSpacing:3];

    
    if (indexPath.row == 0)
    {
        if (numRows>5){
            _cmtBackView.frame = CGRectMake(55, 30, ScreenWidth-70, rowCellHeight+10);
            _openOrCloseBtn.hidden = NO;
            _openOrCloseImgV.hidden = NO;
            if (isOpen)
            {
                [_openOrCloseBtn setTitle:@"收起" forState:UIControlStateNormal];
                _openOrCloseImgV.image = [UIImage imageNamed:@"conmentCloseArrows"];
            }else
            {
                [_openOrCloseBtn setTitle:@"展开" forState:UIControlStateNormal];
                _openOrCloseImgV.image = [UIImage imageNamed:@"conmentOpenArrows"];
            }
            
        }else{
            _cmtBackView.frame = CGRectMake(55, 10, ScreenWidth-70, rowCellHeight+10);

        }
        _firstRowBack.hidden = NO;
        
    }else{
        _cmtBackView.frame = CGRectMake(55, 0, ScreenWidth-70, rowCellHeight+10);
        _firstRowBack.hidden = YES;
    }
    _cmtLab.frame = CGRectMake(10, 0, ScreenWidth-90, rowCellHeight+9);
    _cmtLab.attributedText = atrCmtText;
    
}
- (void)imageCick
{
    self.showImageBlock(_showImgUrlStr);
}
- (void)openOrCloseReplyList
{
    
    _isOpen = !_isOpen;
    self.openReplyListBlock(_isOpen,_indexPath);
}

@end
