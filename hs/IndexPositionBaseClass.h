//
//  IndexPositionBaseClass.h
//
//  Created by   on 15/7/29
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IndexPositionData;

@interface IndexPositionBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double code;
@property (nonatomic, strong) IndexPositionData *data;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *errparam;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
