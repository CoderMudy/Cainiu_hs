//
//  HandlePosiData.m
//  hs
//
//  Created by PXJ on 16/1/26.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "HandlePosiData.h"
#import "IndexPositionList.h"
#import "CashPositionDataModel.h"

#define keySale_minNum 2
#define DecimalFloatStr(a,b) [Helper rangeFloatString:a withDecimalPlaces:b]

@interface HandlePosiData ()

@end

@implementation HandlePosiData


#pragma mark /**处理有持仓时的数据*/
+(void)handlePosiHeaderDataWithModel:( FoyerProductModel* )productModel posiArray:(NSArray*)posiArray emptyPrice:(NSString*)priceEmpty morePrice:(NSString*)priceMore completion:(void (^)(BOOL isposi, NSString * profitStr,UIColor *textColor,NSInteger keSaleStyle,NSString * sign))completion;
{
    NSString * profitStr = @"0";
    NSString * sign = @"+";
    UIColor * textColor = [[UIColor alloc] init];
    NSInteger keSaleStyle = 0;
    NSInteger moreOrderNum =  0;
    NSInteger emptyOrderNum = 0;
    float cush = 0;
    BOOL isposi = NO;
    int posiNum =0;


    for (int i=0; i<posiArray.count; i++)
    {
        IndexPositionList * listModel = posiArray[i];

        if(priceEmpty!=0||priceMore!=0)
        {
            int multiple = productModel.multiple.intValue;
            if(listModel.status==3||listModel.status==4||listModel.status==5)
            {
                if (listModel.tradeType==0)
                {//看多
                    cush +=(priceMore.floatValue -listModel.buyPrice.floatValue)*multiple;
                    if (listModel.status==3)
                    {
                        moreOrderNum +=1;
                    }
                }else
                {//看空
                    cush +=(listModel.buyPrice.floatValue -priceEmpty.floatValue)*multiple;
                    if (listModel.status==3)
                    {
                        emptyOrderNum +=1;
                    }
                }
            }
        }//订单状态（-1：支付失败-2：买入失败 0：买入待处理 1：买入处理中 2：买委托成功 3：持仓中 4：卖出处理中 5：卖委托成功 6：卖出成功）
        int modelStatus = listModel.status;
        switch (modelStatus) {
            case -1:case -2:case 0:case 1:case 6:
            {
                posiNum +=0;
            }
                break;
            case 3:case 4:case 5:{
                posiNum +=1;
            }
                
            default:
                break;
        }
    }
    if (posiNum>0) {
        isposi = YES;
    }

    if (emptyOrderNum>=keySale_minNum && moreOrderNum>=keySale_minNum)
    {
        keSaleStyle = 3;
    }else if (emptyOrderNum>=keySale_minNum && moreOrderNum<keySale_minNum)
    {
        keSaleStyle = 2;
    }else if (emptyOrderNum<keySale_minNum && moreOrderNum>=keySale_minNum)
    {
        keSaleStyle = 1;
    }else {
        keSaleStyle = 0;
    }
    int cashD = round(cush);
    NSString * cushStr;
    if (cush>100000||cush<-100000)
    {
        cushStr =[DataEngine addSign:[NSString stringWithFormat:@"%.4f",cashD<0?cashD*(-0.0001):cashD*0.0001]] ;
        cushStr = [cushStr substringToIndex:cushStr.length-2];
        cushStr = [NSString stringWithFormat:@"%@万",cushStr];
    }else
    {
        if ([productModel.loddyType isEqualToString:@"1"]&&[productModel.instrumentID rangeOfString:@"CN"].location!=NSNotFound ) {
            cushStr =[DataEngine addSign:[NSString stringWithFormat:@"%.2f",cashD<0?cush*(-1):cush]] ;
            cushStr = [cushStr substringToIndex:cushStr.length-1];
            
        }else{
            cushStr =[DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%d",cashD<0?cashD*(-1):cashD]] ;

        }
    }
    if (cashD>=0) {
        textColor = K_color_red;
        sign = @"+";
    }else
    {
        textColor = K_color_green;
        sign = @"-";
    }
    profitStr = cushStr;
    completion(isposi,profitStr,textColor,keSaleStyle,sign);
}


/**
 　检查订单是否达到止盈
 */
-(void)setPositionOrderWithModel:(IndexPositionList*)model
                        newPrice:(NSString *)newPrice
                    productModel:(FoyerProductModel*)productModel
                             row:(NSInteger)row
{
    NSString * unit;
    float multiple = productModel.multiple.floatValue;
    if (model.fundType==0) {
        unit = productModel.currencyUnit;
    }else{
        unit = @"积分";
    }
    float profit;
  
    //计算收益
    if (model.tradeType == 0) {
        if(model.status==3||model.status==4||model.status==5){
            if (newPrice.floatValue==0) {
                profit = 0;
            }else{
                profit = (newPrice.doubleValue-model.buyPrice.doubleValue)*multiple;
            }
        }else{
            profit = 0;
        }
    }else{
        if(model.status==3||model.status==4||model.status==5){
            
            if (newPrice.floatValue==0) {
                
                profit = 0;
            }else{
                profit = (model.buyPrice.doubleValue-newPrice.doubleValue)*multiple;
            }
        }else{
            profit = 0;
        }
    }
    
    int profitD =round(profit);


    if (profitD>=model.stopProfit&&profitD>0&&model.status==3) {
        [self searchOrderState:model saleStyle:7 row:row];
    }
    if (profitD<=model.stopLoss*(-1)&&profitD<0&&model.status==3) {
        [self searchOrderState:model saleStyle:8 row:row];
    }
}
- (void)searchOrderState:(IndexPositionList*)orderModel saleStyle:(int)saleStyle row:(NSInteger)row//saleStyle(7:止盈，8:止损)
{
    __block NSInteger saleStyles = saleStyle;
    __block NSInteger orderRow = row;
    NSString * str = [Helper toJSON:[NSArray arrayWithObject:[NSNumber numberWithInt:orderModel.listIdentifier]]];
    NSString * fundType = [NSString stringWithFormat:@"%.0f"
                           ,orderModel.fundType];
    [RequestDataModel requestOrderStateWithfundType:fundType orderId:str SuccessBlock:^(BOOL success, NSArray *dataArray) {
        if (dataArray.count>0) {
            NSDictionary * stateIdDic = dataArray.lastObject;
            int status = [stateIdDic[@"status"] intValue];
            if (status==6) {
                [self modifyCellShowStatus:saleStyles row:orderRow];
            }
        }
    }];
}
- (void)modifyCellShowStatus:(NSInteger)state row:(NSInteger)row
{
    self.orderStatesModifyBlock(state,row);
}

#pragma mark 行情推送刷新
+ (void)loadPushData:(CashPositionDataModel*)model
        productModel:(FoyerProductModel*)productModel
          completion:(void(^)(BOOL isPosition,
                              NSString * profitStr,
                              NSString * rise,
                              NSString * sign,
                              UIColor * profitColor))completion
        ;
{//是否持仓
    BOOL isPosition;
   

    NSString * profitStr = @"0.00";
    NSString * riseStr = @"0.00";
    NSString * sign = @"+";
    UIColor * profitColor = K_color_red;
    if (model.account&&model.account.intValue>0)
    {
        isPosition = YES;

        float profit =0;
        BOOL isProfit=NO;
        //多单
        if ([model.buyOrSal isEqualToString:@"B"]&&model.bidPrice.floatValue!=0)
        {
            if (model.bidPrice.floatValue!=0)
            {
                profit = (model.bidPrice.floatValue-model.price.floatValue)*model.account.intValue;
                isProfit = YES;
            }
        }else
        {//空单
            if (model.askPrice.floatValue !=0&&model.askPrice.floatValue!=0)
            {
                profit = (model.price.floatValue -model.askPrice.floatValue)*model.account.intValue;
                isProfit = YES;
            }
        }

        float marginMoney= model.price.floatValue * model.account.intValue;//
        float rise =0;
        if (marginMoney==0)
        {
            isProfit = NO;
        }else
        {
            rise = profit/marginMoney;
        }
        
        if (isProfit)
        {
            if (profit>=0)
            {
                profitColor = K_color_red;
                NSString * proF = [NSString stringWithFormat:@"%f",profit];
                NSString * riseF = [NSString stringWithFormat:@"%.2f",rise*100];
                NSLog(@"%@,%@",profitStr,proF);
                profitStr = [NSString stringWithFormat:@"%@",DecimalFloatStr(proF,productModel.decimalPlaces.intValue)];
                riseStr = [NSString stringWithFormat:@"+%@%%",riseF];
                sign = @"＋";
            }else
            {
                profitColor = K_color_green;
                NSString * proF = [NSString stringWithFormat:@"%f",profit*(-1)];
                NSString * riseF = [NSString stringWithFormat:@"%.2f",rise*(-100)];
                profitStr = [NSString stringWithFormat:@"%@",DecimalFloatStr(proF,productModel.decimalPlaces.intValue)];
                riseStr = [NSString stringWithFormat:@"-%@%%",riseF];
                sign = @"-";
            }
        }
    }else
    {//没有持仓
        isPosition = NO;
    }
    completion(isPosition,profitStr,riseStr,sign,profitColor);
}

@end

