//
//  IndexQuickOrderController.h
//  hs
//
//  Created by RGZ on 15/9/23.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

typedef void(^QuickOrderOpen)(BOOL);

#import "IndexOrderController.h"

@interface IndexQuickOrderController : IndexOrderController


@property (nonatomic,strong)QuickOrderOpen quickOpen;

@end
