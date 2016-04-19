//
//  IndexPositionDetailController.h
//  hs
//
//  Created by RGZ on 15/8/6.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexPositionList.h"
#import "IndexPositionDetailModel.h"

@interface IndexPositionDetailController : UIViewController<UIScrollViewDelegate>


@property (nonatomic,strong)IndexPositionList    *positionList;
//期货名称
@property (nonatomic,strong)NSString    *name;
//期货代码
@property (nonatomic,strong)NSString    *code;
//系统卖价(看空取的价格) 高
@property (nonatomic,strong)NSString    *askPrice;
//系统买价（看多取的价格）低
@property (nonatomic,strong)NSString    *bidPrice;

@property (nonatomic,strong)FoyerProductModel * productModel;

@end
