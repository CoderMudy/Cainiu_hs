//
//  StopProfitViewController.h
//  hs
//
//  Created by Xse on 15/11/25.
//  Copyright © 2015年 luckin. All rights reserved.
//  ====止盈止损下单

#import <UIKit/UIKit.h>

@interface StopProfitViewController : UIViewController

@property (nonatomic,strong)FoyerProductModel * productModel;//
@property (nonatomic,strong)NSString * num;//最大执行数量；
@property (nonatomic,strong)NSString * buyOrSal;//买卖标记 （B:买入 S:卖出）
@property (nonatomic,strong)NSString * price;//价格
@property (nonatomic,strong)NSString * updownData;//涨幅

@end
