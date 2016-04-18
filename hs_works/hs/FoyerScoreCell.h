//
//  FoyerScoreCell.h
//  hs
//
//  Created by PXJ on 16/1/15.
//  Copyright © 2016年 luckin. All rights reserved.
//
typedef void(^ControlBlock)(UIControl* control);
#import <UIKit/UIKit.h>

@interface FoyerScoreCell : UITableViewCell

@property (nonatomic,strong)ControlBlock controlBlock;
@property (nonatomic,strong)UILabel  * productName;
@property (nonatomic,strong)UILabel  * productPrice;
@property (nonatomic,strong)UIView  * spreateLine;
@property (nonatomic,strong)UIImageView * positionImg;

@property (nonatomic,strong)UILabel  * productName_D;
@property (nonatomic,strong)UILabel  * productPrice_D;
@property (nonatomic,strong)UIView  * spreateLine_D;
@property (nonatomic,strong)UIImageView * positionImg_D;
@property (nonatomic,strong)UIImageView * arrowImg;
@property (nonatomic,strong)UIImageView * arrowImg_D;

- (void)setCellWithProductArray:(NSArray*)ProductArray;

@end
