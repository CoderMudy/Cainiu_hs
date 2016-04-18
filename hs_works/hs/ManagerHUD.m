//
//  ManagerHUD.m
//  hs
//
//  Created by 杨永刚 on 15/5/30.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "ManagerHUD.h"

@interface ManagerHUD ()
{
    MBProgressHUD *_hud;
}

@end

@implementation ManagerHUD

DEF_SINGLETON(ManagerHUD)

+ (void)showHUD:(UIView *)view animated:(BOOL)animated
{
    [[ManagerHUD sharedInstance] showHUDAddedTo:view animated:animated];
}

+ (void)showHUD:(UIView *)view animated:(BOOL)animated andAutoHide:(NSTimeInterval)time
{
    [[ManagerHUD sharedInstance] showHUD:view animated:animated andAutoHide:time];
}

+ (void)hidenHUD
{
    [[ManagerHUD sharedInstance] hidenHUD];
}

+ (void)hidenHUDAfterDelay:(NSTimeInterval)time
{
    [[ManagerHUD sharedInstance] hidenHUDAfterDelay:time];
}

- (void)hidenHUD
{
    [_hud hide:YES];
}

- (void)hidenHUDAfterDelay:(NSTimeInterval)time
{
    [_hud hide:YES afterDelay:time];
}

- (void)showHUD:(UIView *)view animated:(BOOL)animated andAutoHide:(NSTimeInterval)time
{
    _hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    [_hud show:YES];
    
    __block int timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_hud hide:YES];
            });
        }else{
            timeout--;
        }
    });
    dispatch_resume(_timer);

}

- (void)showHUDAddedTo:(UIView *)view animated:(BOOL)animated
{
    _hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    [_hud show:YES];
}

@end
