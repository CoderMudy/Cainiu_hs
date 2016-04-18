//
//  SpreadApplyPage.h
//  hs
//
//  Created by PXJ on 15/10/22.
//  Copyright © 2015年 luckin. All rights reserved.
//
typedef enum{
    UserSpreadUnableApply,//未达到申请条件
    UserSpreadGetMoney,   //达到申请条件佣金尚未领取
    UserSpreadApply,//可以申请
    UserSpreadChecking,//审核中
    UserSpreadUnAgree,//审核拒绝
    userSpread
}UserSpreadStyle;
#import <UIKit/UIKit.h>

@interface SpreadApplyPage : UIViewController
@property (nonatomic,assign)UserSpreadStyle userSpreadStyle;
@end
