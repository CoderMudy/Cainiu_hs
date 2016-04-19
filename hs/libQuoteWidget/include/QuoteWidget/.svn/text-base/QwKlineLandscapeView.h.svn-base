//
//  QwKlineLandscapeView.h
//  QuoteWidget
//
//  Created by Gu Jianglai on 14/10/27.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import "QwKlineView.h"
/*!
 *  @brief  K线焦点线回调
 */
@protocol QwKlineViewFocusDelegate <NSObject>
/*!
 *  @brief  获得焦点
 *
 *  @param index 焦点的索引,取消焦点时该值为-1
 */
-(void)focusedOn:(int)index;
@end
/*!
 *  @brief  带有焦点线交互的K线视图
 */
@interface QwKlineLandscapeView : QwKlineView{
    BOOL _isMultitouch;
    
    NSTimer *_delayTimer;
}
/*!
 *  @brief  交点线回调对象
 */
@property(nonatomic,assign)id<QwKlineViewFocusDelegate> delegate;

@end
