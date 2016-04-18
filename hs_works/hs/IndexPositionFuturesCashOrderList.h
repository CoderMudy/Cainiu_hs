//
//  IndexPositionFuturesCashOrderList.h
//
//  Created by   on 15/7/29
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface IndexPositionFuturesCashOrderList : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double theoryCounterFee;
@property (nonatomic, assign) double lossProfit;
@property (nonatomic, assign) double status;
@property (nonatomic, assign) double couponId;
@property (nonatomic, assign) double tradeType;
@property (nonatomic, assign) double count;
@property (nonatomic, assign) double futuresId;
@property (nonatomic, assign) double cashFund;
@property (nonatomic, strong) NSString *displayId;
@property (nonatomic, strong) NSString *buyDate;
@property (nonatomic, assign) double stopProfit;
@property (nonatomic, assign) double futuresType;
@property (nonatomic, assign) double stopLossPrice;
@property (nonatomic, assign) double buyPrice;
@property (nonatomic, strong) NSString *sysSetSaleDate;
@property (nonatomic, assign) double listIdentifier;
@property (nonatomic, assign) double fundType;
@property (nonatomic, assign) double counterFee;
@property (nonatomic, assign) double stopLoss;
@property (nonatomic, strong) NSString *saleDate;
@property (nonatomic, assign) double salePrice;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, assign) double stopProfitPrice;
@property (nonatomic, strong) NSString *futuresCode;
@property (nonatomic, assign) BOOL isNeedCheck;//是否需要验证

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
