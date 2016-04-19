//
//  FoyrerTableViewCell.h
//  hs
//
//  Created by PXJ on 15/9/11.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FoyerTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel * showLab;
@property (nonatomic,strong)UILabel * productNameL;
@property (nonatomic,strong)UILabel * productAdL;
@property (nonatomic,strong)UIImageView * markImg;
@property (nonatomic,strong)UILabel * priceLab;
@property (nonatomic,strong)UIImageView * hotImg;
@property (nonatomic,strong)UIView * lineView;
@property (nonatomic,assign)BOOL  isPositionNum;
- (void)setFoyertableViewCellWithModel:(id)model;



@end

