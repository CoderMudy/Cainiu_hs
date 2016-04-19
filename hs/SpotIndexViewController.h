//
//  SpotIndexViewController.h
//  Xianhuo
//
//  Created by Xse on 15/11/23.
//  Copyright © 2015年 杭州市向淑娥. All rights reserved.
//  ======现货下单页面

#import <UIKit/UIKit.h>

@interface SpotIndexViewController : UIViewController

@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *priceLabel;

@property (nonatomic,strong)FoyerProductModel * productModel;
//可售 0  禁买1  闭市2
@property (nonatomic,assign)int                 canBuy;
//0：多 1：空
@property (nonatomic,assign)int                 buyState;

@property(nonatomic,assign) NSInteger           floatNum;//小数位数

@property(nonatomic,strong) NSString            *buyPrice;//看多价

@property(nonatomic,strong) NSString            *salePrice;//看空价

@end
