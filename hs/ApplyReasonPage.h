//
//  ApplyReasonPage.h
//  hs
//
//  Created by PXJ on 15/10/22.
//  Copyright © 2015年 luckin. All rights reserved.
//
typedef void(^BackClickBlock)();

#import "AdviceViewController.h"

@class SpreadApplyPage;

@interface ApplyReasonPage : UIViewController

@property SpreadApplyPage * superVC;
@property (copy)BackClickBlock backBlock;
@end
