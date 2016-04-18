//
//  OrderRecordBaseClass.h
//
//  Created by   on 15/5/20
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface OrderRecordBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *curPrice;
@property (nonatomic, strong) NSString *exchangeType;
@property (nonatomic, strong) NSString * scoreMarketValue;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, assign) double status;
@property (nonatomic, assign) double rankScore;
@property (nonatomic, strong) NSString *marketValue;
@property (nonatomic, strong) NSString * finishDate;
@property (nonatomic, strong) NSString *stockAcc;
@property (nonatomic, strong) NSString *buyCount;
@property (nonatomic, strong) NSString *plateName;
@property (nonatomic, strong) NSString *incomeRate;
@property (nonatomic, strong) NSString *stockCode;
@property (nonatomic, strong) NSString *cashFund;
@property (nonatomic, strong) NSString *buyPrice;
@property (nonatomic, strong) NSString *buyType;
@property (nonatomic, strong) NSString *stockName;
@property (nonatomic, strong) NSString *curCashProfit;
@property (nonatomic, strong) NSString *operateAmt;
@property (nonatomic, strong) NSString *openPrice;
@property (nonatomic, strong) NSString *quantity;
@property (nonatomic, strong) NSString *counterFee;
@property (nonatomic, strong) NSString *plateCode;
@property (nonatomic, strong) NSString *curScoreProfit;
@property (nonatomic, strong) NSString *salePrice;
@property (nonatomic, strong) NSString *orderdetailId;
@property (nonatomic, strong) NSString *lossFund;
@property (nonatomic, strong) NSString *proType;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *stockCodeType;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *userId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
