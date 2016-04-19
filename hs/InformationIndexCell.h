//
//  InformationIndexCell.h
//  ;
//
//  Created by RGZ on 15/12/29.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface InformationIndexCell : UITableViewCell

//14:14
@property (nonatomic,strong)UILabel     *timeLabel;
//期货
@property (nonatomic,strong)UILabel     *typeLabel;

//bg
@property (nonatomic,strong)UIView      *bgView;
//title
@property (nonatomic,strong)UILabel     *titleLabel;
//内容
@property (nonatomic,strong)UILabel     *contextLabel;

//三角
@property (nonatomic,strong)UIImageView      *signView;
//铅笔
@property (nonatomic,strong)UIImageView      *signProView;
//期货 白银 非农
@property (nonatomic,strong)UILabel     *proLabel;

//时间线
@property (nonatomic,strong)UIView      *roundView;
@property (nonatomic,strong)UIView      *lineView;
//评论和阅读量
@property (nonatomic,strong)UILabel     *commentAndReadLabel;
//图片
@property (nonatomic,strong)UIImageView *contentImageView;

@property (nonatomic,assign)float       cellHeight;
//最后一条不显示时间线
@property (nonatomic,assign)BOOL        isLastNews;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier CellHeight:(float)aCellHeight ContentHeight:(float)aContentHeight News:(News *)aNews;

-(void)setCellHeight:(float)aCellHeight ContentHeight:(float)aContentHeight News:(News *)aNews isLastNews:(BOOL)isLastNews;
@end
