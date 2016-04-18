//
//  SpreadPageCell.h
//  hs
//
//  Created by PXJ on 15/8/25.
//  Copyright (c) 2015年 luckin. All rights reserved.
//


typedef void(^SpreadCellClickBlock)(id);
#import <UIKit/UIKit.h>

@interface SpreadPageCell : UITableViewCell

@property (nonatomic,strong)SpreadCellClickBlock clickBlock;
@property (nonatomic,strong)UIButton * clickBtn;
@property (nonatomic,strong)UIButton * clickRightBtn;
@property (nonatomic,strong)UIImageView * itemImageV;
@property (nonatomic,strong)UIImageView * itemRightImgeV;
@property (nonatomic,strong)UILabel * titleLab;
@property (nonatomic,strong)UILabel * titleRightLab;
@property (nonatomic,strong)UILabel * detailLab;
@property (nonatomic,strong)UILabel * detailRightLab;
@property (nonatomic,strong)UIView * seperatorLine;


-(void)setSpreadPageCellAtIndexPath:(NSIndexPath *)indexPath;

@end
