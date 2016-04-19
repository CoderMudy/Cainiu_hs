//
//  CashKeySalePopView.h
//  hs
//
//  Created by PXJ on 15/12/7.
//  Copyright © 2015年 luckin. All rights reserved.
//
typedef void(^ConfirmBtnClick)(id);
typedef void(^SelectMarkBlock)(BOOL);

#import <UIKit/UIKit.h>
@class CashKeySaleModel;

@interface CashKeySalePopView : UIView

@property (nonatomic,strong)CashKeySaleModel * saleModel;
@property (copy)ConfirmBtnClick confirmClick;
@property (copy)SelectMarkBlock selectMarkBlock;
@property (nonatomic,strong)UIView * shadeView;
@property (nonatomic,strong)UIButton * backConcelBtn;

#pragma mark 闪电平仓弹窗

//委托成功
- (id)initShowSucWithTitleArray:(NSArray*)btnTitleArray;
//闪电平仓提示框
- (id)initShowAlertWithInfo:(CashKeySaleModel*)saleModel setBtnTitleArray:(NSArray*)btnTitleArray productModel:(FoyerProductModel*)productModel;


@end
