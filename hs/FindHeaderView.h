//
//  FindHeaderView.h
//  hs
//
//  Created by PXJ on 15/10/10.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

typedef void(^ClickViewBlock)(int);
#import <UIKit/UIKit.h>

@interface FindHeaderView : UIView

@property (nonatomic,strong)ClickViewBlock clickViewBlock;
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UIView * secondView;
@property (nonatomic,strong)UIView * thirdView;


@end
