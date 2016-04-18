//
//  FoyerReportShowView.h
//  scrollow
//
//  Created by PXJ on 15/9/17.
//  Copyright (c) 2015年 PXJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoyerReportShowView : UIView

@property(nonatomic,strong)UILabel * nickLab;
@property (nonatomic,strong)UILabel * profitLab;

- (void)setShowViewNickname:(NSString *)nickName profit:(NSString *)profit;

@end
