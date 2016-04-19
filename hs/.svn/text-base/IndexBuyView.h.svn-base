//
//  IndexBuyView.h
//  hs
//
//  Created by RGZ on 15/7/24.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexBuyTacticsButton.h"
#import "DXPopover.h"

typedef void(^IndexBuyBlock)(IndexBuyModel *,int,int,BOOL);

typedef void(^BackGroundHeightBlock)(UIButton *);

@interface IndexBuyView : UIView<UIScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)IndexBuyBlock block;
//(无用属性)
@property (nonatomic,strong)UIScrollView  *superScrollView;

//高亮
@property (nonatomic,strong)BackGroundHeightBlock backGroundHeightBlock;

@property (nonatomic,strong)NSString    *name;
@property (nonatomic,strong)NSString    *code;
@property (nonatomic,strong)NSString    *instrumentCode;
@property (nonatomic,strong)FoyerProductModel * productModel;
@property (nonatomic,assign)int         segSelectIndex;

//切换K线图
@property (nonatomic, strong) UIButton *downBtn;
@property (nonatomic, strong) NSArray *configs;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DXPopover *popover;

-(instancetype)initWithFrame:(CGRect)frame Name:(NSString *)aName Code:(NSString *)aCode ProductModel:(FoyerProductModel *)aProductModel;

-(void)end;

-(void)disConnection;

-(void)segChangeOfIndex:(int)aIndex;

/*
 闪电下单
 */
@property (nonatomic,strong)UIButton        *orderLightningBtn;
//看多
@property (nonatomic,strong)UIButton        *bullishBtn;
//看空
@property (nonatomic,strong)UIButton        *bearishBtn;

@property (nonatomic,strong)UILabel         *bullishBtnLabel;
@property (nonatomic,strong)UILabel         *bearishBtnLabel;

@property (nonatomic,strong)UIImageView     *lightningRedView;

@property (nonatomic,strong)UIImageView     *lightningGreenView;

//页面数据Model
@property (nonatomic,strong)IndexBuyModel   *indexBuyModel;

/*
 实时策略
 */
@property (nonatomic,strong)IndexBuyTacticsButton   *indexBuyTacticsButton;
//金十财经+持仓直播背景
@property (nonatomic,strong)UIView          *bottomBgView;

@end
