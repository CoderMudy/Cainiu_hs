//
//  MyOrderCell.h
//  hs
//
//  Created by PXJ on 15/11/24.
//  Copyright © 2015年 luckin. All rights reserved.
//
typedef void(^MyOrderBlock)();

typedef enum{
    MyOrderCellStyleSuccess,
    MyOrderCellStyleSign,
    MyOrderCellStyleSet,
    MyOrderCellStyleEnd

}MyOrderCellStyle;
#import <UIKit/UIKit.h>

@interface MyCashOrderCell : UITableViewCell

@property (nonatomic,assign)MyOrderCellStyle myOrderCellStyle;
@property (copy)MyOrderBlock myOrderBlock;

@property (nonatomic,strong)UILabel * cancelLab;
@property (nonatomic,strong)UIButton * cancelBtn;
@property (nonatomic,strong)UILabel * timeLab;
@property (nonatomic,strong)UILabel * markOneLab;
@property (nonatomic,strong)UILabel * markTwoLab;
@property (nonatomic,strong)UILabel * detailOne;
@property (nonatomic,strong)UILabel * detailTwo;
@property (nonatomic,strong)UILabel * detailThree;
@property (nonatomic,strong)UILabel * detailFour;


- (void)setCashOrderListCellDetail:(id)sender productModel:(FoyerProductModel*)productModel;

@end
