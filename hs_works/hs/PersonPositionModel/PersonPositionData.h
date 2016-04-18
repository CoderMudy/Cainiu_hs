//
//  PersonPositionData.h
//
//  Created by   on 15/5/10
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PersonPositionData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double totalCashProfit;
@property (nonatomic, assign) double totalScoreProfit;
@property (nonatomic, strong) NSArray *posiBoList;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
