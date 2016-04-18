//
//  ELOrderList.h
//
//  Created by   on 15/7/9
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ELOrderList : NSObject <NSCoding, NSCopying>
@property (nonatomic, assign) double preClosePrice;
@property (nonatomic, assign) double buyPrice;
@property (nonatomic, assign) double newPrice;
@property (nonatomic, strong) NSString *stockCode;
@property (nonatomic, assign) double tradeDayCount;
@property (nonatomic, assign) double orderListIdentifier;
@property (nonatomic, assign) double cashFund;
@property (nonatomic, strong) NSString *stockName;
@property (nonatomic, assign) double factBuyCount;
@property (nonatomic, strong) NSString *buyDate;
@property (nonatomic, assign) double fundType;
@property (nonatomic, strong) NSString *typeCode;
@property (nonatomic, strong) NSString *displayId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
