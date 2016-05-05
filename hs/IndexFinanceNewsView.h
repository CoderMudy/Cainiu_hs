//
//  IndexFinanceNewsView.h
//  hs
//
//  Created by PXJ on 16/5/5.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CloseBlock)();

@interface IndexFinanceNewsView : UIView

@property (copy)CloseBlock close;
@property (nonatomic,strong)UIWebView * webView ;
@end
