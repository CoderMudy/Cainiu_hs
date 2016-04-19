//
//  EmojiClass.h
//  hs
//
//  Created by PXJ on 16/3/29.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmojiClass : NSObject


+ (void)encodeToPercentEscapeString: (NSString *) input changeBlock:(void(^)(NSString * changeString))successBlock;

+ (NSString *)encodeToPercentEscapeString: (NSString *) input;
//解码

+ (NSString *)decodeFromPercentEscapeString: (NSString *) input;

+ (BOOL)stringContainsEmoji:(NSString *)string;

@end
