//
//  ManagerHUD.h
//  hs
//
//  Created by 杨永刚 on 15/5/30.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>
#import <UIKit/UIKit.h>

@interface ManagerHUD : NSObject
@property (nonatomic,strong)MBProgressHUD *hud;

AS_SINGLETON(ManagerHUD)
+ (void)showHUD:(UIView *)view animated:(BOOL)animated;
+ (void)showHUD:(UIView *)view animated:(BOOL)animated andAutoHide:(NSTimeInterval)time;
+ (void)hidenHUD;
+ (void)hidenHUDAfterDelay:(NSTimeInterval)time;

@end
