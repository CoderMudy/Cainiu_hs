//
//  OrderPriceData.h
//
//  Created by   on 15/5/27
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface OrderPriceData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double dataIdentifier;
@property (nonatomic, strong) NSString *scoreFundOption;
@property (nonatomic, assign) double highestFee;
@property (nonatomic, strong) NSString *counterFeeOption;
@property (nonatomic, assign) double opAmt;
@property (nonatomic, strong) NSString *cashFundOption;
@property (nonatomic, assign) double opScore;
@property (nonatomic, assign) double lowestFee;
@property (nonatomic, assign) double type;
@property (nonatomic, assign) double highestScore;
@property (nonatomic, assign) double dayFee;
@property (nonatomic, strong) NSString *counterScoreOption;
@property (nonatomic, assign) double lowestScore;
@property (nonatomic, assign) double dayScore;
@property (nonatomic, strong) NSString *maxLoss;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
