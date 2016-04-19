//
//  IndexOrderChooseBillModel.h
//  hs
//
//  Created by RGZ on 16/4/11.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexOrderChooseBillModel : NSObject

@property (nonatomic,strong)NSString    *delegateCondition;//委托条件

@property (nonatomic,assign)NSString    *chooseNum;//手数

@property (nonatomic,assign)NSString    *chooseStopMoney;//触发止损金额

@property (nonatomic,assign)NSString    *chooseGetMoney;//触发止盈金额

@end
