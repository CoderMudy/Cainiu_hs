//
//  FoyerReportView.m
//  scrollow
//
//  Created by PXJ on 15/9/17.
//  Copyright (c) 2015年 PXJ. All rights reserved.
//

#import "FoyerReportView.h"
#import "FoyerReportShowView.h"

#define width self.bounds.size.width
#define height self.bounds.size.height

@implementation FoyerReportView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithFrame:(CGRect)frame  nickArray:(NSArray*)nickArray profitArray:(NSArray *)profitArray
{
    self = [super initWithFrame:frame];
    if (self) {
        _nickArray = nickArray;
        _profitArray = profitArray;
        
        [self initView];
        
    }
    
    return self;
    
}
- (void)initView
{
    [self initReportView];
    [self startReport];
}
- (void)initReportView
{
    _reportView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _reportView.layer.masksToBounds = YES;
    [self addSubview:_reportView];
    
    _mainView = [[FoyerReportShowView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _subView = [[FoyerReportShowView alloc] initWithFrame:CGRectMake(0, height, width, height)];
    [_reportView addSubview:_mainView];
    [_reportView addSubview:_subView];
    _reportNum = 0;
    
    [_mainView setShowViewNickname:_nickArray[0] profit:_profitArray[0]];
    if (_nickArray.count>1) {
        _reportNum = 1;
        [_subView setShowViewNickname:_nickArray[1] profit:_profitArray[1]];
    }else{
        _reportNum = 0;
        [_subView setShowViewNickname:_nickArray[0] profit:_profitArray[0]];
    }
}

- (void)startReport
{
    _isReport = YES;
    [self reportTimerStart];
}

- (void)reportTimerStart
{
    if (!_isReport) {
        return;
    }
    if (_mainView.frame.origin.y>=height) {
        _reportNum ++;
        if (_reportNum>=_nickArray.count) {
            _reportNum = 0;
        }
        [_mainView setShowViewNickname:_nickArray[_reportNum] profit:_profitArray[_reportNum]];
        _mainView.frame = CGRectMake(0,-height, width, height);
        [self performSelector:@selector(reportTimerStart) withObject:nil afterDelay:5];
        return;
    }else if (_subView.frame.origin.y>=height) {
        _reportNum ++;
        if (_reportNum>=_nickArray.count) {
            
            _reportNum = 0;
            
        }        [_subView setShowViewNickname:_nickArray[_reportNum] profit:_profitArray[_reportNum]];
        
        
        _subView.frame = CGRectMake(0, -height, width, height);
        [self performSelector:@selector(reportTimerStart) withObject:nil afterDelay:5];
        return;
        
    }else{
        CGPoint firstCenter = _mainView.center;
        CGPoint secondCenter = _subView.center;
        
        
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            _mainView.center = CGPointMake(firstCenter.x, firstCenter.y+height/3);
            _subView.center = CGPointMake(secondCenter.x, secondCenter.y+height/3);
            
        } completion:nil];
        
        [self performSelector:@selector(reportTimerStart) withObject:nil afterDelay:0.2];
        
        
    }
    
 
}
- (void)stopReport
{
    _isReport = NO;
    [self removeFromSuperview];

    
}
@end
