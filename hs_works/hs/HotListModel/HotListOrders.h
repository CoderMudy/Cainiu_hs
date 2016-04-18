//
//  HotListOrders.h
//
//  Created by   on 15/5/7
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HotListOrders : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *stockCompany;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *stockType;
@property (nonatomic, assign) double rankScore;
@property (nonatomic, strong) NSString *marketValue;
@property (nonatomic, strong) NSString *buyCount;
@property (nonatomic, strong) NSString *curScoreAmt;
@property (nonatomic, strong) NSString *stockCode;
@property (nonatomic, strong) NSString *curCashAmt;
@property (nonatomic, strong) NSString *buyPrice;
@property (nonatomic, strong) NSString *buyScore;
@property (nonatomic, strong) NSString *buyType;
@property (nonatomic, strong) NSString *productType;
@property (nonatomic, strong) NSString *stockPlate;
@property (nonatomic, strong) NSString *openPrice;
@property (nonatomic, strong) NSString *quatity;
@property (nonatomic, strong) NSString *orderdetailId;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *curPrice;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *incomeRate;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
