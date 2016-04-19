//
//  NewsBaseClass.h
//
//  Created by   on 16/3/29
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NewsBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *cmtReplyList;//评论回复列表
@property (nonatomic, assign) int totalCmt;//总评论数

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
