//
//  IndexAgreementPage.h
//  hs
//
//  Created by PXJ on 15/12/3.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexAgreementPage : UIViewController

@property (nonatomic,strong)NSString * name;
@property (nonatomic,strong)NSString * urlStr;

//0：看多买入    1：看空买入
@property (nonatomic,assign)int     buyState;

//0:沪金 1:期指  2：沪银
@property (nonatomic,assign)int     mainState;

@property (nonatomic,strong)IndexBuyModel   *indexBuyModel;
//可售  闭市
@property (nonatomic,assign)BOOL    canUse;

@property (nonatomic,strong)FoyerProductModel   *productModel;

@end
