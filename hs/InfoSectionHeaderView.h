//
//  InfoSectionHeaderView.h
//  hs
//
//  Created by PXJ on 16/3/23.
//  Copyright © 2016年 luckin. All rights reserved.
//
typedef void(^ShowImageBlock)(NSString * showImgUrlStr);

typedef void(^SectionHeaderClickBlock)(double cmtId,NSString * cmtUserNick);
#import <UIKit/UIKit.h>


@class NewsCmtReplyList;
@interface InfoSectionHeaderView : UIView

@property (nonatomic,strong)UIView * backView;
@property (nonatomic,strong)UIImageView * headerImgV;
@property (nonatomic,strong)UILabel * userName;
@property (nonatomic,strong)UILabel * timeLab;
@property (nonatomic,strong)UIImageView * cmtRemindImgV;
@property (nonatomic,strong)UILabel * cmtLab;
@property (nonatomic,strong)UILabel * cmtImgV;
@property (nonatomic,strong)UIImageView * contentImgV;
@property (copy) SectionHeaderClickBlock sectionHeaderClickBlock;
@property (copy) ShowImageBlock showImageBlock;

- (instancetype)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setSectionHeaderContent:(NSString*)contentImg;
- (void)setSectionHeaderWithDetailCmtReply:(NewsCmtReplyList *)cmtReplyModel section:(int)section;
@end

