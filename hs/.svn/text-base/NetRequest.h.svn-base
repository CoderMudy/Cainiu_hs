//
//  NetRequest.h
//  hs
//
//  Created by PXJ on 15/4/24.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^returnBlock)(NSURL *url);

@interface NetRequest : NSObject

+ (void)postRequestWithNSDictionary:(NSDictionary *)dic url:(NSString*)url successBlock:(void(^)(NSDictionary *dictionary))successBlock failureBlock:(void(^)(NSError *error))failureBlock;

/**上传用户头像*/
+(void)postUpdateDataWithDictionary:(NSDictionary*)dic dataDetailDic:(NSDictionary*)detailDic url:(NSString * )url  imageData:(NSData*)data successBlock:(void(^)(NSDictionary *dictionary))successBlock failureBlock:(void(^)(NSError *error))failureBlock;

@end
