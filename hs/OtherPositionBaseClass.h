//
//  OtherPositionBaseClass.h
//
//  Created by   on 15/6/1
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface OtherPositionBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *stockName;
@property (nonatomic, strong) NSString *buyQuatity;
@property (nonatomic, strong) NSString *stockCode;
@property (nonatomic, strong) NSString *buyPrice;
@property (nonatomic, strong) NSString *codeType;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
