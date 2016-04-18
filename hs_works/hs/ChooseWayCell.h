//
//  ChooseWayCell.h
//  hs
//
//  Created by RGZ on 15/7/3.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseWayCell : UITableViewCell

@property(nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong)UILabel     *detailLabel;
@property (nonatomic,strong)UIImageView *titleImageView;
@property(nonatomic,strong) UIView      *grayView;

- (void)fillWithWayData:(NSDictionary *)dic;

@end
