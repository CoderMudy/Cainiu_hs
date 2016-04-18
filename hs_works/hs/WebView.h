//
//  WebView.h
//  hs
//
//  Created by RGZ on 16/1/8.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface WebView : UIViewController<NJKWebViewProgressDelegate,UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)UIWebView   *webView;

@property (nonatomic,strong)NJKWebViewProgressView *progressView;
@property (nonatomic,strong)NJKWebViewProgress *progressProxy;

@end
