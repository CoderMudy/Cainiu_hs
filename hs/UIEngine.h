//
//  UIEngine.h
//  hs
//
//  Created by RGZ on 15/5/18.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alert.h"

typedef void(^AlertBlock)(int);
typedef void(^AuthBlock)(int,NSString *);
typedef void(^OrderBlock)(int);
@interface UIEngine : NSObject
{
}
@property (copy) AlertBlock alertClick;

@property (copy) AuthBlock authClick;

@property (copy) OrderBlock orderClick;

@property (nonatomic,assign) int    progressStyle;
@property (nonatomic,assign) int    authStyle;
@property (nonatomic,strong) Alert  *alert;

AS_SINGLETON(UIEngine)

+(BOOL)checkMoney:(UITextField *)tf;

+(void)showShadowPrompt:(NSString*)aMessage;
+(void)showXianHuoPromptMesg:(NSString*)aMessage;//现货的提示

-(void)showAlertSpecialWithTitle:(NSString  *)aTitle TimeArray:(NSMutableArray *)aArray;

-(void)showAlertWithTitle:(NSString *)aMessage
             ButtonNumber:(int)aNum
         FirstButtonTitle:(NSString *)aFirstTitle
        SecondButtonTitle:(NSString *)aSecondTitle;

-(void)showProgress;

-(void)hideProgress;

-(void)showAuthLoginPWD;

-(void)showOrderAlertWithTitle:(NSString    *)aTitle
                     DataArray:(NSMutableArray  *)aInfoArray
                       isMoney:(BOOL)isMoney
                 DefaultSelect:(int)aIndex
                         Unit:(NSString *)unit;

+(UIViewController *)getCurrentRootViewController;

//行情异常下单
-(void)showAlertWithOrderWithTitle:(NSString *)aTitle Message:(NSString *)aMessage;
//行情异常平仓
-(void)showAlertWithSellingWithTitle:(NSString *)aTitle Message:(NSString *)aMessage Money:(NSString *)aMoney MoneyUnit:(NSString *)aMoneyUnit Integral:(NSString *)aIntegral;
-(void)showAlertWithType:(int)aType ButtonNum:(int)aButtonNum LeftTitle:(NSString *)aLeftTitle RightTitle:(NSString *)aRightTitle;

@end
