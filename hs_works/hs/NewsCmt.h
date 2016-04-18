//
//  NewsCmt.h
//
//  Created by   on 16/3/29
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NewsCmt : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) int newsId;//文章ID
@property (nonatomic, strong) NSString *content;//评论内容
@property (nonatomic, assign) int userId;//评论用户ID
@property (nonatomic, assign) int cmtIdentifier;//评论ID
@property (nonatomic, strong) NSString *userNick;//评论用户昵称
@property (nonatomic, strong) NSString *userHead;//评论用户头像
@property (nonatomic, strong) NSString *newsName;//文章名称
@property (nonatomic, strong) NSString *createDate;//评论产生时间

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
