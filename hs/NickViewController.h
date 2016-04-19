//
//  NickViewController.h
//  hs
//
//  Created by RGZ on 15/5/21.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NickBlock)(NSString *);

@interface NickViewController : HSBaseViewController<UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)NickBlock block;

@end
