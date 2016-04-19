//
//  TopOtherPositionView.h
//  hs
//
//  Created by PXJ on 15/7/10.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopOtherPositionView : UIView

@property (nonatomic,strong)UIImageView * headerImageView;
@property (nonatomic,strong)UILabel *  inteEarnTitleLab;
@property (nonatomic,strong)UILabel * inteEarnLab;
@property (nonatomic,strong)UIImageView * backView;
@property (nonatomic,strong)UILabel * markll;
@property (nonatomic,strong)UILabel * personalSign;

- (void)setEarn:(NSString*)earn;
- (void)image:(NSString*)url;

@end
