//
//  NewsCmtReplyList.h
//
//  Created by   on 16/3/29
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewsCmt;

@interface NewsCmtReplyList : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NewsCmt *cmt;//评论
@property (nonatomic, strong) NSArray *reply;//当情评论下的回复列表
@property (nonatomic, assign) BOOL isOpen;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
