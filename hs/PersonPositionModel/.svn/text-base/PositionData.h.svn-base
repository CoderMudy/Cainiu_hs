//
//  PositionData.h
//
//  Created by   on 15/7/8
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PositionData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *orderList;
@property (nonatomic, strong) NSString * score;
@property (nonatomic, strong) NSString * usedAmt;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
