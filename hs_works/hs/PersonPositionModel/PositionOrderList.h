//
//  PositionOrderList.h
//
//  Created by   on 15/7/8
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PositionOrderList : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) int multiple;
@property (nonatomic, assign) double warnAmt;
@property (nonatomic, assign) double maxLossPrice;
@property (nonatomic, assign) double tradeDayCount;
@property (nonatomic, assign) double stockId;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, assign) double status;
@property (nonatomic, assign) double factBuyCount;
@property (nonatomic, assign) double couponId;
@property (nonatomic, assign) NSString *headPic;
@property (nonatomic, assign) double interest;
@property (nonatomic, assign) double factBorrowAmt;
@property (nonatomic, strong) NSString *stockCode;
@property (nonatomic, strong) NSString *displayId;
@property (nonatomic, strong) NSString *buyDate;
@property (nonatomic, assign) double cashFund;
@property (nonatomic, strong) NSString *stockName;
@property (nonatomic, assign) double buyPrice;
@property (nonatomic, assign) double curPrice;
@property (nonatomic, assign) double preClosePrice;
@property (nonatomic, assign) double traderId;
@property (nonatomic, strong) NSString *sysSetSaleDate;
@property (nonatomic, assign) double orderListIdentifier;
@property (nonatomic, assign) double fundType;
@property (nonatomic, assign) double financyAllocation;
@property (nonatomic, assign) double totalInterest;
@property (nonatomic, assign) double counterFee;
@property (nonatomic, assign) double orderPayAmt;
@property (nonatomic, assign) double maxLoss;
@property (nonatomic, strong) NSString *typeCode;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
