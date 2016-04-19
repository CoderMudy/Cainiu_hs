//
//  EntrustView.h
//  hs
//
//  Created by Xse on 15/12/7.
//  Copyright © 2015年 luckin. All rights reserved.
//  =====委托成功视图

#import <UIKit/UIKit.h>

@interface EntrustView : UIView

@property(nonatomic,copy) void (^clicCheckEntrust)();
@property(nonatomic,copy) void (^clickSureAction)();
- (void)initEntrustView;

@end
