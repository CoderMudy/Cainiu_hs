//
//  QwTrendViewTouchable.h
//  QuoteWidget
//
//  Created by Gu Jianglai on 14/11/4.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import "QwTrendView.h"
/*!
 *  @brief  分时焦点线回调
 */
@protocol QwTrendViewFocusDelegate <NSObject>
/*!
 *  @brief  获得焦点
 *
 *  @param index 焦点的索引,取消焦点时该值为-1
 */
-(void)focusedOn:(int)index;
@end
/*!
 *  @brief  带有焦点线交互的分时线视图
 */
@interface QwTrendViewTouchable : QwTrendView{
    BOOL _isMultitouch;
    
    NSTimer *_delayTimer;
    
    CGFloat _focusX;
    int _focusIndex;
    BOOL _showFocusline;
}
/*!
 *  @brief  交点线回调对象
 */
@property(nonatomic,assign)id<QwTrendViewFocusDelegate> delegate;

@end
