//
//  ELList.h
//
//  Created by   on 15/6/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ELList : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double orderId;
@property (nonatomic, strong) NSString *stockCode;
@property (nonatomic, assign) double listIdentifier;
@property (nonatomic, strong) NSString * sysSaleDate;
@property (nonatomic, assign) double proVariety;
@property (nonatomic, assign) double salePrice;
@property (nonatomic, strong) NSString * userSaleDate;
@property (nonatomic, strong) NSString * userAddDate;
@property (nonatomic, strong) NSString *displayId;
@property (nonatomic, assign) double amt;
@property (nonatomic, assign) double sysSalePrice;
@property (nonatomic, strong) NSString *plateCode;
@property (nonatomic, assign) double factCount;
@property (nonatomic, assign) double counterFee;
@property (nonatomic, assign) double warnAmt;
@property (nonatomic, assign) double openPrice;
@property (nonatomic, assign) double lossProfit;
@property (nonatomic, assign) double factBorrowAmt;
@property (nonatomic, assign) double factSaleCount;
@property (nonatomic, strong) NSString * updateTime;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *proType;
@property (nonatomic, assign) double quantity;
@property (nonatomic, assign) double status;
@property (nonatomic, strong) NSString *codeType;
@property (nonatomic, strong) NSString *stockCom;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, assign) double saleType;
@property (nonatomic, assign) double exitAmt;
@property (nonatomic, assign) double lossAmt;
@property (nonatomic, strong) NSString * plateType;
@property (nonatomic, assign) double buyType;
@property (nonatomic, assign) double buyPrice;
@property (nonatomic, strong) NSString *plateName;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * finishDate;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
