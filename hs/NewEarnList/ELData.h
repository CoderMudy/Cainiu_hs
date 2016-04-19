//
//  ELData.h
//
//  Created by   on 15/7/9
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ELData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *uuId;
@property (nonatomic, assign) NSString *headPic;
@property (nonatomic, strong) NSString *stockName;
@property (nonatomic, strong) NSString *buyDate;
@property (nonatomic, assign) NSString *personalSign;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSMutableArray *orderList;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
