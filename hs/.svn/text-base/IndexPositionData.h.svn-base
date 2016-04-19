//
//  IndexPositionData.h
//
//  Created by   on 15/7/29
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface IndexPositionData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *futuresCashOrderList;
@property (nonatomic, strong) NSArray *futuresScoreOrderList;
@property (nonatomic, strong) NSArray * list;
@property (nonatomic, strong) NSString * score;
@property (nonatomic, strong) NSString * usedAmt;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
