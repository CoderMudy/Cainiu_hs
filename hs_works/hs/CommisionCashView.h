//
//  CommisionCashView.h
//  hs
//
//  Created by PXJ on 15/10/27.
//  Copyright © 2015年 luckin. All rights reserved.
//
typedef void(^AlertConfirm)();

#import <UIKit/UIKit.h>

@interface CommisionCashView : UIView

@property (nonatomic,strong)AlertConfirm alertConfirm;

- (id)initWithFrame:(CGRect)frame;

@end
