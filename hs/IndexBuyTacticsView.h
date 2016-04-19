//
//  IndexBuyTacticsView.h
//  hs
//
//  Created by RGZ on 15/10/22.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexBuyTacticsModel.h"

@interface IndexBuyTacticsView : UIView<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) void (^IndexBuyTacticsBlock)(void);

-(instancetype)initWithFrame:(CGRect)frame ProdcutModel:(FoyerProductModel *)productModel;

@property (nonatomic,strong)FoyerProductModel   *productModle;

#pragma mark 其他页面关闭操作
-(void)otherClose;

//行情动态获取当前价
-(void)changeCurrentPrice:(NSString *)currentPrice;

-(void)setDefaultCurrentPrice:(NSString *)currentPrice;;

@end
