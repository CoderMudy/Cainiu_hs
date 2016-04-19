//
//  ReportMainView.m
//  ReportTest
//
//  Created by RGZ on 15/7/15.
//  Copyright (c) 2015年 RGZ. All rights reserved.
//

#import "ReportMainView.h"
#import "ReportView.h"

#define StopTime 2
#define AnimationTime 0.8
#define ReportNotificationName @"REPORT"
#define ViewHeight _view.frame.size.height


@implementation ReportMainView
{
    UIView *_view;
    
    NSMutableArray  *_titleArray;
    NSMutableArray  *_detailArray;
    
    ReportView      *_reportView;
    ReportView      *_reportAgainView;
    
    int  animationFinish;
    int  index;
    
    
    BOOL turn;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(instancetype)initWithFrame:(CGRect)frame Title:(NSMutableArray *)titleArray Detail:(NSMutableArray *)detailArray{
    self = [super initWithFrame:frame];
    
    if (self) {
        _titleArray = [NSMutableArray arrayWithArray:titleArray];
        _detailArray = [NSMutableArray arrayWithArray:detailArray];
        
        _view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _view.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        _view.clipsToBounds = YES;
        [self addSubview:_view];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportAgain) name:ReportNotificationName object:nil];
        
        _reportView = [[ReportView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, frame.size.height)];
        
        _reportView.titleLabel.text = [NSString stringWithFormat:@"%@ %@",_titleArray[0],_detailArray[0]];
        
        float  reportwidth = [Helper calculateTheHightOfText:_reportView.titleLabel.text height:15 font:[UIFont systemFontOfSize:15]];
        _reportView.imageView.frame = CGRectMake(ScreenWidth/2-(frame.size.height-2+reportwidth)/2, 1.5, frame.size.height-3, frame.size.height-3);
        _reportView.titleLabel.frame = CGRectMake(_reportView.imageView.frame.origin.x+_reportView.imageView.frame.size.width+5, 0, self.frame.size.width-_reportView.imageView.frame.size.width-_reportView.imageView.frame.origin.x-5, self.frame.size.height);
        
        
        
        
        NSMutableAttributedString * titleLabel  =[Helper multiplicityText:_reportView.titleLabel.text from:(int)[_titleArray[0] length]+1 to:(int)[_detailArray[0] length] color:[UIColor redColor]];
        
        _reportView.titleLabel.attributedText = [Helper multableText:titleLabel from:0 to:(int)[_titleArray[0] length] color:K_COLOR_CUSTEM(153, 153, 153, 1)];
        
        
        
        

        [_view addSubview:_reportView];
        
        
        
        
        _reportAgainView = [[ReportView alloc]initWithFrame:CGRectMake(0, 0-frame.size.height, frame.size.width, frame.size.height)];
        _reportAgainView.titleLabel.text = [NSString stringWithFormat:@"%@ %@",_titleArray[1],_detailArray[1]];
        
        
        
        
        NSMutableAttributedString * titleAgainLabel  =[Helper multiplicityText:_reportAgainView.titleLabel.text from:(int)[_titleArray[1] length]+1 to:(int)[_detailArray[1] length] color:[UIColor redColor]];
        
        _reportAgainView.titleLabel.attributedText = [Helper multableText:titleAgainLabel from:0 to:(int)[_titleArray[1] length] color:K_COLOR_CUSTEM(153, 153, 153, 1)];
   
        float  reportAgainwidth = [Helper calculateTheHightOfText:_reportAgainView.titleLabel.text height:15 font:[UIFont systemFontOfSize:15]];

        _reportAgainView.imageView.frame = CGRectMake(ScreenWidth/2-(frame.size.height-2+reportAgainwidth)/2, 1.5, frame.size.height-3, frame.size.height-3);
        _reportAgainView.titleLabel.frame = CGRectMake(_reportAgainView.imageView.frame.origin.x+_reportAgainView.imageView.frame.size.width+5, 0, self.frame.size.width-_reportAgainView.imageView.frame.size.width-_reportAgainView.imageView.frame.origin.x-5, self.frame.size.height);
        
        

        
        [_view addSubview:_reportAgainView];
        
        animationFinish = 0;
        index           = 1;
        turn            = NO;
        
        [self startRoll];
    }
    
    return self;
}

-(void)setFont:(UIFont *)aFont{
    _reportView.titleLabel.font = aFont;
    _reportAgainView.titleLabel.font = aFont;
}

-(void)setColor:(UIColor *)aColor{
    _reportView.titleLabel.textColor = aColor;
    _reportAgainView.titleLabel.textColor = aColor;
}

-(NSMutableAttributedString *)multiplicityColorText:(NSString *)aStr from:(int)aFrom to:(int)aTo color:(UIColor *)aColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:aStr];
    
    [str addAttribute:NSForegroundColorAttributeName value:aColor range:NSMakeRange(aFrom,aTo)];
    return str;
}

-(void)startRoll{
   
//    NSLog(@"～～～～～动画～～～～～");
    
   
    
    
    if (_reportView.frame.origin.y == 0-ViewHeight && _reportView.frame.origin.y!=0 && _reportView.frame.origin.y != ViewHeight) {
        [UIView animateWithDuration:AnimationTime delay:StopTime options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _reportView.frame = CGRectMake(0, 0, _reportView.frame.size.width, _reportView.frame.size.height);
            
        } completion:^(BOOL finished) {
            animationFinish +=1;
            [[NSNotificationCenter defaultCenter] postNotificationName:ReportNotificationName object:nil];
        }];
    }
    else if (_reportView.frame.origin.y == 0&& _reportView.frame.origin.y !=ViewHeight){
        [UIView animateWithDuration:AnimationTime delay:StopTime options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _reportView.frame = CGRectMake(0, ViewHeight, _reportView.frame.size.width, _reportView.frame.size.height);
            
        } completion:^(BOOL finished) {
            animationFinish += 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:ReportNotificationName object:nil];
        }];
    }
    else if (_reportView.frame.origin.y == ViewHeight){
        
        _reportView.frame = CGRectMake(0, 0-ViewHeight, _reportView.frame.size.width, _reportView.frame.size.height);
        
        _reportView.titleLabel.attributedText = nil;
        _reportView.titleLabel.text = [NSString stringWithFormat:@"%@ %@",_titleArray[index],_detailArray[index]];
       
        float  reportwidth = [Helper calculateTheHightOfText:_reportView.titleLabel.text height:15 font:[UIFont systemFontOfSize:15]];
        _reportView.imageView.frame = CGRectMake(ScreenWidth/2-(self.frame.size.height-2+reportwidth)/2, 1.5, self.frame.size.height-3, self.frame.size.height-3);
        _reportView.titleLabel.frame = CGRectMake(_reportView.imageView.frame.origin.x+_reportView.imageView.frame.size.width+5, 0, self.frame.size.width-_reportView.imageView.frame.size.width-_reportView.imageView.frame.origin.x-5, self.frame.size.height);
        
        
        
        
        NSMutableAttributedString * titleLabel  =[Helper multiplicityText:_reportView.titleLabel.text from:(int)[_titleArray[index] length]+1 to:(int)[_detailArray[index] length] color:[UIColor redColor]];
        
        _reportView.titleLabel.attributedText = [Helper multableText:titleLabel from:0 to:(int)[_titleArray[index] length] color:K_COLOR_CUSTEM(153, 153, 153, 1)];
        
        
        
        
        [UIView animateWithDuration:AnimationTime delay:StopTime options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _reportView.frame = CGRectMake(0, 0, _reportView.frame.size.width, _reportView.frame.size.height);
            
        } completion:^(BOOL finished) {
            animationFinish += 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:ReportNotificationName object:nil];
        }];
    }
    
    
    if (_reportAgainView.frame.origin.y == 0-ViewHeight && _reportAgainView.frame.origin.y !=0 && _reportAgainView.frame.origin.y !=ViewHeight) {
        [UIView animateWithDuration:AnimationTime delay:StopTime options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _reportAgainView.frame = CGRectMake(0, 0, _reportAgainView.frame.size.width, _reportAgainView.frame.size.height);
            
        } completion:^(BOOL finished) {
            animationFinish += 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:ReportNotificationName object:nil];
        }];
    }
    else if (_reportAgainView.frame.origin.y == 0 && _reportAgainView.frame.origin.y != ViewHeight){
        [UIView animateWithDuration:AnimationTime delay:StopTime options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _reportAgainView.frame = CGRectMake(0, ViewHeight, _reportAgainView.frame.size.width, _reportAgainView.frame.size.height);
            
        } completion:^(BOOL finished) {
            animationFinish += 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:ReportNotificationName object:nil];
        }];
    }
    else if (_reportAgainView.frame.origin.y == ViewHeight){
        
        _reportAgainView.frame = CGRectMake(0, 0-ViewHeight, _reportAgainView.frame.size.width, _reportAgainView.frame.size.height);
        
        _reportAgainView.titleLabel.attributedText = nil;
        _reportAgainView.titleLabel.text = [NSString stringWithFormat:@"%@ %@",_titleArray[index],_detailArray[index]];
        
        
        float  reportAgainwidth = [Helper calculateTheHightOfText:_reportAgainView.titleLabel.text height:15 font:[UIFont systemFontOfSize:15]];
        
        _reportAgainView.imageView.frame = CGRectMake(ScreenWidth/2-(self.frame.size.height-2+reportAgainwidth)/2, 1.5, self.frame.size.height-3, self.frame.size.height-3);
        _reportAgainView.titleLabel.frame = CGRectMake(_reportAgainView.imageView.frame.origin.x+_reportAgainView.imageView.frame.size.width+5, 0, self.frame.size.width-_reportAgainView.imageView.frame.size.width-_reportAgainView.imageView.frame.origin.x-5, self.frame.size.height);
        
        
        
        
        NSMutableAttributedString * titleAgainLabel  =[Helper multiplicityText:_reportAgainView.titleLabel.text  from:(int)[_titleArray[index] length]+1 to:(int)[_detailArray[index] length] color:[UIColor redColor]];
        
        _reportAgainView.titleLabel.attributedText = [Helper multableText:titleAgainLabel from:0 to:(int)[_titleArray[index] length] color:K_COLOR_CUSTEM(153, 153, 153, 1)];
        
        [UIView animateWithDuration:AnimationTime delay:StopTime options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _reportAgainView.frame = CGRectMake(0, 0, _reportAgainView.frame.size.width, _reportAgainView.frame.size.height);
            
        } completion:^(BOOL finished) {
            animationFinish += 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:ReportNotificationName object:nil];
        }];
    }
    
}

-(void)reportAgain{
    
    if (animationFinish == 2) {
        
        
        index++;
        
        if (animationFinish == 1) {
            if (index > _titleArray.count-1) {
                
                index = 0;
                
            }
        }
        
        if (animationFinish == 2) {
            
            static int num = 0;
            num ++;
            
            
            if (index > _titleArray.count-1) {
                
                index = 0;
                
            }
            
            animationFinish = 0;
            
            if(_isReport){
                return;
                
            }else{
                [self startRoll];

            
            }
        }
    }
}
- (void)stop
{
    [self removeFromSuperview];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReportNotificationName object:nil];

}
@end
