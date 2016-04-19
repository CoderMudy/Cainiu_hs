//
//  NewsReply.h
//
//  Created by   on 16/3/29
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NewsReply : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) int newsId;//文章ID
@property (nonatomic, assign) int replyUserId;//回复用户ID
@property (nonatomic, strong) NSString *replyUserHead;//回复用户头像
@property (nonatomic, assign) int replyIdentifier;//回复ID
@property (nonatomic, strong) NSString *replyUserNick;//回复人昵称
@property (nonatomic, strong) NSString *replyContent;//回复内容
@property (nonatomic, strong) NSString *newsName;//文章名称
@property (nonatomic, strong) NSString *upUserNick;//回复上级昵称
@property (nonatomic, strong) NSString *createDate;//回复时间
@property (nonatomic, assign) int cmtId;//文章ID
@property (nonatomic, assign) int replyId;//父级回复，当是直接对评论回复时，该数据为空

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
