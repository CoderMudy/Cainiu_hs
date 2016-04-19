//
//  HotListData.h
//
//  Created by   on 15/5/7
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HotListData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *nick;
@property (nonatomic, strong) NSArray *orders;
@property (nonatomic, strong) NSString *benefit;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
