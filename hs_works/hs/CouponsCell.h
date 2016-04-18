//
//  CouponsCell.h
//  hs
//
//  Created by PXJ on 15/11/16.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponsCell : UITableViewCell
@property (nonatomic,strong)UIView  * backView;
@property (nonatomic,strong)UILabel * couponNameLab;
@property (nonatomic,strong)UILabel * ValidDateLab;
@property (nonatomic,strong)UILabel * couponValueLab;
@property (nonatomic,strong)UILabel * remarkLab;
@property (nonatomic,strong)UIImageView * couponStyleImgV;
@property (nonatomic,strong)UIImageView * couponStateImgV;

- (void)setCellDetailWithModel:(id)sender;


@end
