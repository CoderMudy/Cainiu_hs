//
//  InfoDetailHeaderView.m
//  hs
//
//  Created by PXJ on 16/3/22.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "InfoDetailHeaderView.h"
#import "News.h"
#define titleFont 20

@implementation InfoDetailHeaderView
{
    News * _news;
    NSString  * _showImgUrlStr;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame news:(News*)news;
{
    self = [super initWithFrame:frame];
    if (self) {
        _news = news;
        [self initUI];
    }
    return self;
}
- (void)initUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    CGSize titleSize = [Helper sizeWithText:_news.title font:FontSize(titleFont) maxSize:CGSizeMake(ScreenWidth-40, 0)];

    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, ScreenWidth-40, titleSize.height)];
    _titleLab.text  = _news.title;
    _titleLab.numberOfLines = 0;
    _titleLab.textColor = [UIColor blackColor];
    _titleLab.font      = [UIFont boldSystemFontOfSize:titleFont];//FontSize(titleFont);
    [self addSubview:_titleLab];
    
    _souceLab = [[UILabel alloc] initWithFrame:CGRectMake( 20, CGRectGetMaxY(_titleLab.frame)+10, ScreenWidth-40, 20)];
    _souceLab.text = [NSString stringWithFormat:@"来源：%@ %@",_news.outSourceName,_news.createDate];
    _souceLab.textColor = K_color_grayBlack;
    _souceLab.font = FontSize(12);
    [self addSubview:_souceLab];
    
    _readNumLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMinY(_souceLab.frame), ScreenWidth-40, 20)];
    _readNumLab.text = [NSString stringWithFormat:@"%@已阅",_news.readCount];
    _readNumLab.textColor = K_color_grayBlack;
    _readNumLab.textAlignment = NSTextAlignmentRight;
    _readNumLab.font = FontSize(12);
    [self addSubview:_readNumLab];
    
    CGFloat imgHeight;
    UIImage * img ;

    if ([DataUsedEngine nullTrim:_news.bannerUrl]&&_news.bannerUrl.length>0) {
        NSMutableDictionary * contentdImgDic = [CacheEngine getNewsDetailImage];
        if ([DataUsedEngine nullTrim:[contentdImgDic objectForKey:_news.bannerUrl]])
        {
            img = [contentdImgDic objectForKey:_news.bannerUrl];
        }else
        {
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_news.bannerUrl]];
            img = [UIImage imageWithData:data];
        }
        CGSize  imgSize = img.size;
        
        
        if (imgSize.height==0||imgSize.width==0) {
            imgHeight = 0;
        }else{
            imgHeight = imgSize.height*(ScreenWidth-40)/imgSize.width +20;
        }
    }else{
        imgHeight = 0;
        
    }
    
    _bannerImageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_readNumLab.frame)+5, ScreenWidth-40, imgHeight)];
    _bannerImageV.clipsToBounds = YES;
    _bannerImageV.image = img;
    _bannerImageV.userInteractionEnabled = YES;
    [self addSubview:_bannerImageV];
    UITapGestureRecognizer * imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageCick)];
    [_bannerImageV addGestureRecognizer:imgTap];

}


- (void)imageCick
{
    self.showImageBlock(_news.bannerUrl);
}
@end
