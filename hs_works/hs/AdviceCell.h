//
//  AdviceCell.h
//  hs
//
//  Created by Xse on 15/9/24.
//  Copyright © 2015年 luckin. All rights reserved.
//  ======回复记录界面的cell

#import <UIKit/UIKit.h>

@class AdviceModel;
@class AdviceFrameModel;

@interface AdviceCell : UITableViewCell

//问
@property(nonatomic,strong) UILabel *subName;
@property(nonatomic,strong) UILabel *subTime;
@property(nonatomic,strong) UILabel *subContent;

//答
@property(nonatomic,strong) UILabel *answerName;
@property(nonatomic,strong) UILabel *answerTime;
@property(nonatomic,strong) UILabel *answerMesg;

@property(nonatomic,strong) UIView *lineView;

@property(nonatomic,strong) UIView *backView;//给个背景图片（白色）

@property(nonatomic,strong) AdviceModel *model;
@property(nonatomic,strong) AdviceFrameModel *frameModel;

- (void)fillWithData:(AdviceFrameModel *)adviceFrameModel;

@end
