//
//  RecordCell.h
//  hs
//
//  Created by PXJ on 15/7/28.
//  Copyright (c) 2015年 luckin. All rights reserved.
//
typedef void(^CancelOrderBlock)();
#import <UIKit/UIKit.h>

@interface IndexRecordCell : UITableViewCell


@property (nonatomic,strong)UILabel * saleTypeLab;
@property (nonatomic,strong)UILabel * addLab;
@property (nonatomic,strong)UILabel * riseLab;
@property (nonatomic,strong)UILabel * timeLab;
@property (nonatomic,strong)UILabel * buyTypeLab;

@property (copy)CancelOrderBlock cancelOrderBlock;
@property (nonatomic,strong)UILabel * nameLab;
@property (nonatomic,strong)UILabel * orderTypeLab;
@property (nonatomic,strong)UILabel * priceLab;
@property (nonatomic,strong)UILabel * stopLossLab;
@property (nonatomic,strong)UILabel * stopProfitLab;
@property (nonatomic,strong)UILabel * cancelLab;
@property (nonatomic,strong)UIButton * cancelBtn;



- (void)setCellWithDictionary:(NSDictionary*)dictionary withSystemTime:(NSString*)systemTime productModel:(FoyerProductModel*)productModel;
- (void)setEntrustedCellWithDictionary:(NSDictionary*)dictionary withSystemTime:(NSString*)systemTime productModel:(FoyerProductModel*)productModel cellStyle:(int)cellStyle;

@end
