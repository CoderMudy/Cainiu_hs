//
//  CashPositionView.h
//  hs
//
//  Created by PXJ on 15/11/24.
//  Copyright © 2015年 luckin. All rights reserved.
//
 typedef void(^GoBuyViewBlock)();
typedef void(^FundLoadBlock)(BOOL isPosition,NSString * userFund,NSString *userProfit);

#import <UIKit/UIKit.h>
#import "FoyerProductModel.h"

@class IndexViewController;

@interface CashPositionView : UIView

@property (copy)FundLoadBlock fundLoadBlock;
@property (copy)GoBuyViewBlock goBuyViewBlock;
@property (nonatomic,strong)IndexViewController  * superVC;
@property (nonatomic,strong)FoyerProductModel * productModel;

- (id)initWithFrame:(CGRect)frame model:(FoyerProductModel*)productModel;
- (void)cashPosionViewAppear;
- (void)close;
- (void)keySaleOrder;
@end
