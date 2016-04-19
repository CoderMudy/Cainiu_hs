//
//  IndexBuyTacticsButton.h
//  hs
//
//  Created by RGZ on 15/10/23.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexBuyTacticsButton : UIView

-(instancetype)initWithFrame:(CGRect)aFrame ProductModel:(FoyerProductModel *)productModel CurrentPrice:(NSString *)currentPrice;

@property (nonatomic,strong)FoyerProductModel   *productModel;

-(void)open;

-(void)close;

//行情动态获取当前价
-(void)changeCurrentPrice:(NSString *)currentPrice;

@end
