//
//  HolidayPopView.h
//  hs
//
//  Created by PXJ on 16/1/14.
//  Copyright © 2016年 luckin. All rights reserved.
//
typedef void(^GoHolidayBlock)();
#import <UIKit/UIKit.h>

@interface HolidayPopView : UIView

@property (nonatomic,strong)GoHolidayBlock goHolidayBlock;
@property (nonatomic,assign)BOOL isShow;
- (void)showHolidayPopView:(BOOL)show;
- (void)unloginViewHidden:(BOOL)hidden;

@end
