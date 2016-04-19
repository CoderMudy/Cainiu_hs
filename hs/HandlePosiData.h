//
//  HandlePosiData.h
//  hs
//
//  Created by PXJ on 16/1/26.
//  Copyright © 2016年 luckin. All rights reserved.
//持仓数据处理model
typedef void(^OrderStatesModifyBlock)(NSInteger,NSInteger);
#import <Foundation/Foundation.h>

@class IndexPositionList;
@class CashPositionDataModel;

@interface HandlePosiData : NSObject

@property (copy)OrderStatesModifyBlock orderStatesModifyBlock;

/**处理期货有持仓时的数据--返回（1）持仓收益（2）收益颜色（3）一键平多／平空（4）正负标示符*/
+(void)handlePosiHeaderDataWithModel:( FoyerProductModel* )productModel posiArray:(NSArray*)posiArray emptyPrice:(NSString*)priceEmpty morePrice:(NSString*)priceMore completion:(void (^)(BOOL isposi,NSString * profitStr,UIColor *textColor,NSInteger keSaleStyle,NSString * sign))completion;


/**
 *　检查订单是否达到止盈
 *  model 持仓订单model
 *  newPrice 最新价
 *  productModel 商品Model
 */
-(void)setPositionOrderWithModel:(IndexPositionList*)model
                        newPrice:(NSString *)newPrice
                    productModel:(FoyerProductModel*)productModel
                             row:(NSInteger)row;


#pragma mark 行情推送刷新
/**
 *　检查订单是否达到止盈
 *  model 持仓订单model
 *  newPrice 最新价
 *  productModel 商品Model
 */
+ (void)loadPushData:(CashPositionDataModel*)model
        productModel:(FoyerProductModel*)productModel
          completion:(void(^)(BOOL isPosition,
                              NSString * profitStr,
                              NSString * rise,
                              NSString * sign,
                              UIColor * profitColor))completion;
@end
