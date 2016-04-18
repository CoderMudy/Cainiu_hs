//
//  FInacTableViewCell.h
//  hs
//
//  Created by PXJ on 15/5/5.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSTableViewCell.h"
#import "H5DataCenter.h"
#import "h5DataCenterMgr.h"

@interface FInacTableViewCell :UITableViewCell

@property (nonatomic,strong)UILabel * numLab;
@property (nonatomic,strong)UILabel * positionLab;
@property (nonatomic,strong)UILabel * nickLab;
@property (nonatomic,strong)H5DataCenter * dataCenter;
@property (nonatomic,strong)UILabel * nearBuyLab;
@property (nonatomic,strong)UILabel * timeLab;
@property (nonatomic,strong)UILabel * markLab;
- (void)setDict:(NSDictionary *)dict;

@end
