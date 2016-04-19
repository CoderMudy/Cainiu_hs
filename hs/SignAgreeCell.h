//
//  SignAgreeCell.h
//  hs
//
//  Created by PXJ on 15/7/13.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignAgreeCell : UITableViewCell

@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UILabel * dateLabel;

- (void)setDict:(NSDictionary *)dict;

@end
