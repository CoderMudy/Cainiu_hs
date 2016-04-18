//
//  NewsPageCell.h
//  hs
//
//  Created by PXJ on 16/3/16.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface NewsPageCell : UITableViewCell



//title
@property (nonatomic,strong)UILabel     *titleLabel;
//内容
@property (nonatomic,strong)UILabel     *contextLabel;

//标签
@property (nonatomic,strong)UILabel      *signProView;
//来源
@property (nonatomic,strong)UILabel     *sourceLabel;


//评论和阅读量
@property (nonatomic,strong)UILabel     *commentAndReadLabel;
//图片
@property (nonatomic,strong)UIImageView *contentImageView;

@property (nonatomic,assign)float       cellHeight;
@property (nonatomic,strong)UIView      * separateLine;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier CellHeight:(float)aCellHeight News:(News *)aNews;

-(void)setCellHeight:(float)aCellHeight News:(News *)aNews indexPath:(NSIndexPath *)indexPath;

@end
