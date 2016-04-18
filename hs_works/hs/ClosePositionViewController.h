//
//  ClosePositionViewController.h
//  hs
//
//  Created by Xse on 15/11/25.
//  Copyright © 2015年 luckin. All rights reserved.
//  =====平仓页面

#import <UIKit/UIKit.h>

@interface ClosePositionViewController : UIViewController

@property (nonatomic,strong)FoyerProductModel * productModel;//
@property (nonatomic,strong)NSString * num;//数量；
@property (nonatomic,strong)NSString * price;//价格；
@property (nonatomic,strong)NSString * buyOrSal;//买卖标记 （B:买入 S:卖出）
@property (nonatomic,strong)NSString * updownData;//涨幅
@end
