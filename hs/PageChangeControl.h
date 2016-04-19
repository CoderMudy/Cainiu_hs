//
//  PageChangeControl.h
//  hs
//
//  Created by PXJ on 16/1/25.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageChangeControl : NSObject

/**跳转客服*/
+ (void)goKeFuWithSource:(UIViewController*)sourcePage;
/**调用分享*/
+ (void)goShareWithTitle:(NSString*)title content:(NSString*)content urlStr:(NSString *)url imagePath:(NSString * )imagePath;
/**调用拨号*/
+ (void)callWithTel:(NSString *)tel;


@end
