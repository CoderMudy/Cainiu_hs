//
//  IndexOrderController.h
//  hs
//
//  Created by RGZ on 15/7/28.
//  Copyright (c) 2015年 luckin. All rights reserved.
//  ====期货下单

#import <UIKit/UIKit.h>
#import "IndexBuyModel.h"
#import "TradeConfigerModel.h"
@interface IndexOrderController : UIViewController

typedef void(^IndexOrderBlock)();
typedef void(^AccountMoneyBlock)();
typedef void(^BackBlock)();
typedef void(^CantTradeBlock)();

@property (nonatomic,strong)IndexBuyModel   *indexBuyModel;
//0：看多  1：看空
@property (nonatomic,assign)int             buyState;
//0：沪金 1:期指 2：沪银
@property (nonatomic,assign)int             mainState;
//可售 or 闭市
@property (nonatomic,assign)BOOL            canUse;

@property (nonatomic,strong)FoyerProductModel * productModel;

@property (nonatomic,strong)IndexOrderBlock     block;

@property (nonatomic,strong)AccountMoneyBlock   accountBlock;

@property (nonatomic,strong)BackBlock           backBlock;

@property (nonatomic,strong)CantTradeBlock      cantTradeBlock;

@property(nonatomic,strong)TradeConfigerModel   *tradeModel;

//手数
@property(nonatomic,strong)  NSMutableArray  *numArray;


//下单
/*
 NSDictionary *dic = @{
 @"futuresCode": _indexBuyModel.code,      //代码
 @"count": numArray[selectNum],            //手数
 @"traderId": tradeID,                 //配资ID
 @"tradeType": [NSNumber numberWithInt:self.buyState], //看多看空
 @"userBuyDate": _systemTime,              //购买时间
 @"userBuyPrice": _indexBuyModel.currentPrice, //价格
 @"stopProfit":[tradeModel.maxProfit componentsSeparatedByString:@","][selectGet],//止盈金额
 @"rate":[NSNumber numberWithDouble:[tradeModel.rate doubleValue]],                 //汇率
 };
 */
-(void)orderBegin:(NSDictionary *)aPramDic;

//闪电下单保存数据
//打开
-(void)quickOrderData:(NSString *)isQuikKeepCoupon;
//关闭
-(void)quickOrderClose;
//快速下单说明文字
-(void)quickOrderText;

/*
 闪电下单需要
 */
@property (nonatomic,assign)BOOL                isQuickOrder;
@property (nonatomic,strong)UILabel             *titleLabel;
@property (nonatomic,strong)UISegmentedControl  *seg;//现金支付/积分模拟
@property (nonatomic,strong)UISegmentedControl  *modifySeg;//市价/限价
@property (nonatomic,assign)float               stopAndGetFrontHeight;
@property (nonatomic,assign)float               otherMoneyFrontHeight;

//交易数量(手数选择)
@property (nonatomic,strong)UILabel             *zoreLabel;


//触发止损、触发止盈
@property (nonatomic,strong)UILabel             *oneLabel;
@property (nonatomic,strong)UILabel             *twoLabel;
//买
@property (nonatomic,strong)UIButton            *bottomBtn;
//交易手数 subView tag:777,778,779,780
@property (nonatomic,strong)UIView              *tradeNumView;
@property (nonatomic,assign)int                 selectNum;
@property (nonatomic,assign)BOOL                isOpen;

//====新手引导
@property(nonatomic,strong) UIImageView     *guide_OneImg;
@property(nonatomic,strong) UIImageView     *guide_TwoImg;
@property(nonatomic,strong) UIImageView     *guide_ThreeImg;
@property(nonatomic,strong) UIImageView     *guide_FourImg;
@property(nonatomic,strong) UIView     *guideView;

//====优惠券相关
@property(nonatomic,strong) NSString *isCouPon;
@property(nonatomic,strong) UIButton        *couPonBtn;
@property(nonatomic,strong) UILabel         *couPonLab;
@property(nonatomic,assign) double          sunCoupon ;
@property(nonatomic,strong) NSMutableArray *couPonArray;

@property(nonatomic,strong)NSString        *isOrderQuickCouPon;
@property(nonatomic,strong)NSString        *isAutoBtn;

@property(nonatomic,strong) UIView          *couPonView;
@property(nonatomic,strong) UIView          *chooseBGView;//选择止损、止盈背景

- (void)clickCouPonAction:(UIButton *)sender;
@end
