//
//  SaleOrderBaseClass.h
//
//  Created by   on 15/6/1
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SaleOrderBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double userId;
@property (nonatomic, strong) NSString *codeType;
@property (nonatomic, assign) double lossProfit;
@property (nonatomic, strong) NSString *exchangeType;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, assign) double status;
@property (nonatomic, assign) double marketValue;
@property (nonatomic, assign) id hsEntrustNo;
@property (nonatomic, strong) NSString *stockCode;
@property (nonatomic, assign) double cashFund;
@property (nonatomic, assign) double buyPrice;
@property (nonatomic, assign) double buyType;
@property (nonatomic, assign) double lossAmt;
@property (nonatomic, assign) double factCount;
@property (nonatomic, assign) double saleType;
@property (nonatomic, assign) double internalBaseClassIdentifier;
@property (nonatomic, assign) double quantity;
@property (nonatomic, assign) id hsSaleEntrustNo;
@property (nonatomic, assign) double counterFee;
@property (nonatomic, assign) double amt;
@property (nonatomic, assign) id plateType;
@property (nonatomic, assign) double isCountProfit;
@property (nonatomic, assign) double openPrice;
@property (nonatomic, strong) NSString *plateCode;
@property (nonatomic, assign) double salePrice;
@property (nonatomic, assign) id proType;
@property (nonatomic, assign) id stockAcc;
@property (nonatomic, strong) NSString *stockCom;
@property (nonatomic, strong) NSString *finishDate;
@property (nonatomic, strong) NSString *plateName;
@property (nonatomic, assign) double orderId;
@property (nonatomic, strong) NSString *createDate;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
