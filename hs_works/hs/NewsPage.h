//
//  NewsPage.h
//  hs
//
//  Created by PXJ on 16/3/14.
//  Copyright © 2016年 luckin. All rights reserved.
//
typedef void(^PushPageBlock)(id);
#import <UIKit/UIKit.h>

@interface NewsPage : UIView

@property (copy)PushPageBlock pushBlock;

@end
