//
//  PersonPositionPosiBoList.h
//
//  Created by   on 15/5/10
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PersonPositionPosiBoList : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *stockCodeType;
@property (nonatomic, strong) NSString *incomeRate;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, assign) double rankScore;
@property (nonatomic, assign) double marketValue;
@property (nonatomic, assign) double buyCount;
@property (nonatomic, strong) NSString *stockCode;
@property (nonatomic, assign) double buyPrice;
@property (nonatomic, assign) double buyType;
@property (nonatomic, strong) NSString *stockName;
@property (nonatomic, strong) NSString *curCashProfit;
@property (nonatomic, assign) double operateAmt;
@property (nonatomic, assign) double quantity;
@property (nonatomic, assign) double openPrice;
@property (nonatomic, assign) double counterFee;
@property (nonatomic, strong) NSString *curScoreProfit;
@property (nonatomic, assign) double orderdetailId;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, assign) double curPrice;
@property (nonatomic, strong) NSString *proType;
@property (nonatomic, assign) double lossFund;
@property (nonatomic, assign) double orderId;
@property (nonatomic, assign) double userId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
