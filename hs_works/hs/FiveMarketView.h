//
//  FiveMarketView.h
//  hs
//
//  Created by Xse on 15/11/27.
//  Copyright © 2015年 luckin. All rights reserved.
//  =====五档行情页面

#import <UIKit/UIKit.h>

@interface FiveMarketView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    NSTimer *fiveMakreTime;
}
@property(nonatomic,strong) UITableView *saleTableView;
@property(nonatomic,strong) UITableView *buyTableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSString *btnTitle;//按钮文字显示买入还是平仓

@property(nonatomic,strong) NSTimer *fiveMakreTime;

@property(nonatomic,strong) NSString *instrumentType;

//1的时候（上面显示askprice，下面是bidprice）2的时候，卖价bidPrice，买askPrice
@property(nonatomic,strong) NSString *isShowAskOrBid;

@property(nonatomic,assign) NSInteger buyState;

@property(nonatomic,copy) void (^clickBack)();
@property(nonatomic,copy) void (^clickBuy)(NSString *priceStr);


- (void)initTableView;

@end
