//
//  IndexBottomSwitchView.h
//  hs
//
//  Created by RGZ on 16/5/5.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FinanceNewsBlock)(BOOL);
typedef void(^PositionBlock)(BOOL);

@interface IndexBottomSwitchView : UIView

@property (nonatomic,strong)UIButton    *financeNewsButton;

@property (nonatomic,strong)UIButton    *positionButton;

@property (nonatomic,strong)FinanceNewsBlock financeNewsBlock;

@property (nonatomic,strong)PositionBlock   positionBlock;

@end
