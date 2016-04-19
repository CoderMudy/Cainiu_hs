//
//  NewsDetailCell.h
//  hs
//
//  Created by PXJ on 16/3/24.
//  Copyright © 2016年 luckin. All rights reserved.
//
typedef void(^ShowImageBlock)(NSString * showImgUrlStr);
typedef void(^OpenReplyListBlock)(BOOL isOpen,NSIndexPath * indexPath);
#import <UIKit/UIKit.h>

@class NewsReply;

@interface NewsDetailCell : UITableViewCell

@property (nonatomic,strong)UILabel * contentLab;
@property (nonatomic,strong)UIImageView * contentImgV;
@property (copy) ShowImageBlock showImageBlock;

@property (nonatomic,strong)UIView * firstRowBack;
@property (nonatomic,strong)UIView * cmtBackView;
@property (nonatomic,strong)UILabel * cmtLab;
//@property (nonatomic,strong)UIView * openReplyListV;
@property (nonatomic,strong)UIButton * openOrCloseBtn;
@property (nonatomic,strong)UIImageView * openOrCloseImgV;
@property (nonatomic,strong)OpenReplyListBlock  openReplyListBlock;
- (void)setContentCellWithContentString:(NSString  *)string;
- (void)setConmentCellWithInfo:(NewsReply*)replyModel indexPath:(NSIndexPath *)indexPath allrowNums:(NSInteger)numRows isOpen:(BOOL)isOpen;

@end
