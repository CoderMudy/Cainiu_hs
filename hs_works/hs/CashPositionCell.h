//
//  CashPositionCell.h
//  hs
//
//  Created by PXJ on 15/11/25.
//  Copyright © 2015年 luckin. All rights reserved.
//
typedef void(^ConcelBlock)();
#import <UIKit/UIKit.h>

@interface CashPositionCell : UITableViewCell

@property (copy)ConcelBlock concelBlock;
@property (nonatomic,strong)UILabel  * timeLab;
@property (nonatomic,strong)UILabel * styleLab;
@property (nonatomic,strong)UILabel * numLab;
@property (nonatomic,strong)UILabel * priceLab;
@property (nonatomic,strong)UIButton * cancelBtn;

- (void)setCashPositionCell:(id)sender productModel:(FoyerProductModel*)productModel;


@end
