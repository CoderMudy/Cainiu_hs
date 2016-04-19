//
//  Alert.h
//  hs
//
//  Created by RGZ on 15/12/17.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AlertClick)(UIButton *);

typedef enum{
    AlertCommon = 0,
    AlertError  = 1,//行情异常
    AlertDelegateOrderMore = 2,//委托多单
    AlertDelegateOrderLess = 3,//委托空单
}AlertType;
typedef enum{
    AlertErrorTypeOrder = 10,//下单
    AlertErrorTypeSelling = 11,//平仓
}AlertErrorType;

@interface Alert : UIView

@property (nonatomic,strong)AlertClick alertClick;

-(instancetype)initWithButtonNum:(int)aButtonNum
                      FirstTitle:(NSString *)aFirstTitle
                     SecondTitle:(NSString *)aSecondTitle
                         Message:(NSString *)aMessage
                       AlertType:(AlertType)aAlertTyle
                  AlertErrorType:(AlertErrorType)anAlertErrorType//行情异常所需
               ErrorTitleMessage:(NSString *)aErrorTitleMessage//行情异常标题信息
                    ErrorMessage:(NSString *)aErrorMessage//行情异常信息
                      ErrorMoney:(NSString *)aErrorMoney//行情异常金额
                   ErrorIntegral:(NSString *)aErrorIntegral//行情异常积分
                  ErrorMoneyUnit:(NSString *)aErrorMoneyUnit;//行情异常金额单位（元，美元）

@end
