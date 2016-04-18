//
//  ActivityPage.h
//  hs
//
//  Created by PXJ on 15/8/7.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ActivityModel;
@interface ActivityPage : UIViewController

@property (nonatomic,strong)UIWebView * webView;
@property (nonatomic,strong)ActivityModel * activityModel;

@end
