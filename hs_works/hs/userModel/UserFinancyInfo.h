//
//  UserFinancyInfo.h
//
//  Created by   on 15/5/19
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface UserFinancyInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *redbag;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *profit;
@property (nonatomic, strong) NSString *usedAmt;
@property (nonatomic, strong) id cashFund;
@property (nonatomic, strong) NSString *freezeAmt;
@property (nonatomic, strong) NSString *usedDraw;
@property (nonatomic, strong) id counterFee;
@property (nonatomic, strong) NSString *stockMarketValue;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
