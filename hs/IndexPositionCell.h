//
//  IndexPositionCell.h
//  hs
//
//  Created by PXJ on 15/7/28.
//  Copyright (c) 2015年 luckin. All rights reserved.
//
typedef void(^OrderPriceOut)(id);
typedef void(^SaleBlock)(id);

#import <UIKit/UIKit.h>


@class IndexPositionList;
@interface IndexPositionCell : UITableViewCell

@property (nonatomic,strong)OrderPriceOut ourBlock;//达到止盈止损
@property (nonatomic,strong)SaleBlock block;
@property (nonatomic,strong)UILabel * endLossLab;
@property (nonatomic,strong)UILabel * endEarnLab;
@property (nonatomic,strong)UILabel * tradeTypeLab;
@property (nonatomic,strong)UILabel * fundTypeLab;
@property (nonatomic,strong)UILabel * profitLab;
@property (nonatomic,strong)UILabel * priceLab;
@property (nonatomic,strong)UIButton * saleBtn;
@property (nonatomic,strong)UILabel * saleLab;
- (void)setPositionCellWithModel:(IndexPositionList*)model newPrice:(NSString *)newPrice multiPle:(int)multiple decimalplaces:(int)decimalplaces productModel:(FoyerProductModel*)productModel;

@end
