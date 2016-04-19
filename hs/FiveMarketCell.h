//
//  FiveMarketCell.h
//  hs
//
//  Created by Xse on 15/11/30.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FiveMarketModel;

@interface FiveMarketCell : UITableViewCell

@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) UILabel *priceLab;
@property(nonatomic,strong) UILabel *numLab;

@property(nonatomic,strong) FiveMarketModel *model;

- (void)fillSaleWithData:(FiveMarketModel *)saleModel buyDic:(FiveMarketModel *)buyModel;
//- (void)fillBuyWithData:(NSMutableDictionary *)buyDic;

@end
