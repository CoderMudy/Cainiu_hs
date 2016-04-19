//
//  MarketIsStatusAlert.h
//  hs
//
//  Created by Xse on 16/1/6.
//  Copyright © 2016年 luckin. All rights reserved.
//
//======现货交易已经闭市的提示框
#import <UIKit/UIKit.h>

@interface MarketIsStatusAlert : UIView

@property(nonatomic,copy) void (^clickSureAction)();

- (void)initMarketStatus;

@end
