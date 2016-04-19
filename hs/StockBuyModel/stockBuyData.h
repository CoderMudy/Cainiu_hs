//
//  stockBuyData.h
//
//  Created by   on 15/5/7
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface stockBuyData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *buyType;
@property (nonatomic, strong) NSString *quantity;
@property (nonatomic, strong) NSString *stockCode;
@property (nonatomic, assign) double opId;
@property (nonatomic, strong) NSString *plate;
@property (nonatomic, assign) double lossAmt;
@property (nonatomic, strong) NSString *marketType;
@property (nonatomic, strong) NSString *stockCom;
@property (nonatomic, strong) NSString *proType;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
