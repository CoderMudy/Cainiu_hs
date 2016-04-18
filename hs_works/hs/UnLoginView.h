//
//  UnLoginView.h
//  Test
//
//  Created by RGZ on 15/7/13.
//  Copyright (c) 2015年 RGZ. All rights reserved.
//
typedef void(^ImgClickBlock)( NSString * _Nullable  , NSString * _Nullable );
typedef void(^ShowBtnHidden)(BOOL);
#import <UIKit/UIKit.h>

@protocol UnLoginViewDelegate;

@interface UnLoginView : UIView<UIScrollViewDelegate>

@property (nonatomic,weak,nullable) id <UnLoginViewDelegate> delegate;
@property (nonatomic,copy)ImgClickBlock __nullable imgClickBlock;
@property (nonatomic,copy)ShowBtnHidden __nullable showBtnHidden;
@property (nonatomic,assign)BOOL isInit;
@property (nonatomic,assign)int adNum;
- (void)unloginViewHidden:(BOOL)hidden;
- (void)ADShowNeedTest:(BOOL)isNeedTest;



@end
@protocol UnLoginViewDelegate <NSObject>

- (void)isNeedShowUnLogView:(BOOL)isNeedShow;//打开广告触发
- (void)closePopView;//关闭广告时触发

@end