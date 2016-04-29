//
//  IndexPositionTopView.h
//  hs
//
//  Created by PXJ on 15/7/29.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

typedef void(^AKeySaleBlock)(id);
typedef void(^IndexBuyBlock)();
#import <UIKit/UIKit.h>

@class IndexPositionData,FoyerProductModel;

@interface IndexPositionTopView : UIView

@property (nonatomic,strong)UILabel * titleLab;
@property (nonatomic,strong)UILabel * cashProfitLab;
@property (nonatomic,strong)UILabel * scoreProfitLab;
@property (nonatomic,strong)UILabel * signLab;
@property (nonatomic,strong)UIButton * goBuyBtn;

@property (nonatomic,strong)IndexBuyBlock buyBlock;
@property (nonatomic,strong)AKeySaleBlock aKeySaleBlock;

@property (nonatomic,strong)UIView * lineView;
@property (nonatomic,strong)UILabel * priceMoreLab;//平多价标签
@property (nonatomic,strong)UILabel * priceEmptyLab;//平空价标签
@property (nonatomic,strong)UIButton * saleMoreBtn; //一键平多按钮
@property (nonatomic,strong)UIButton * saleEmptyBtn;//一件平空按钮



- (id)initWithFrame:(CGRect)frame withItemProductModel:(FoyerProductModel*)model;
/**没有持仓刷新*/
- (IndexPositionTopView*)loadUnPosiTopViewWithUserFund:(NSString *)userFund;
/**有持仓刷新*/
- (IndexPositionTopView*)loadPosiTopViewWithProfit:(NSString *)profitStr
                                         textColor:(UIColor *)textColor
                                      keySaleStyle:(NSInteger)keSaleStyle
                                              sign:(NSString*)sign
                                     salePriceMore:(NSString *)salePriceMore
                                         salePrice:(NSString*)salePriceEmpty;

- (IndexPositionTopView *)loadTopView:(IndexPositionData*)posiDataModel withNewPriceEmpty:(NSString*)newPriceEmpty withNewPriceMore:(NSString*)newPriceMore productModel:(FoyerProductModel*)ProductModel posiArray:(NSArray*)posiArray;
@end
