//
//  IndexBuyTacticsButton.m
//  hs
//
//  Created by RGZ on 15/10/23.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "IndexBuyTacticsButton.h"
#import "IndexBuyTacticsView.h"
#import "IndexBuyView.h"

@implementation IndexBuyTacticsButton
{
    UILabel     *_titleLabel;
    
    UIImageView *_titleImgView;
    
    UIView      *_redPointView;
    
    UIView      *_coverView;
    
    UIView      *_bgCoverView;
    
    BOOL        isOpen;
    
    NSMutableDictionary     *_infoDictionary;
    
    IndexBuyTacticsView     *_indexBuyTacticsView;
    
    IndexBuyTacticsModel    *_indexBuyTacticsModel;
    
    NSString    *_currentPrice;
}

-(instancetype)initWithFrame:(CGRect)aFrame ProductModel:(FoyerProductModel *)productModel CurrentPrice:(NSString *)currentPrice{
    self = [super initWithFrame:aFrame];
    if (self) {
        _infoDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
        _currentPrice = currentPrice;
        self.productModel = productModel;
        [self loadUI];
    }
    
    return self;
}

#pragma mark UI

-(void)loadUI{
    self.userInteractionEnabled = YES;
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _titleLabel.text = @"持仓直播";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:12];
    _titleLabel.userInteractionEnabled = YES;
    _titleLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_titleLabel];
    
    UITapGestureRecognizer  *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    [_titleLabel addGestureRecognizer:tapGes];
    
    [self createCoverView];
    
    _redPointView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 5)];
    _redPointView.center = CGPointMake(self.frame.size.width/2 + 26.0, self.frame.size.height/2 - 5.0);
    _redPointView.clipsToBounds = YES;
    _redPointView.layer.cornerRadius = 2.5;
    _redPointView.backgroundColor = Color_red;
    [self addSubview:_redPointView];
    _redPointView.hidden = YES;
    
    
    _titleImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 38.0, 0, 12.0, 12.0)];
    _titleImgView.image = [UIImage imageNamed:@"chicangzhibo_off"];
    _titleImgView.center = CGPointMake(_titleImgView.center.x, _titleLabel.center.y);
    [self addSubview:_titleImgView];
}

-(void)createCoverView{
    
    self.userInteractionEnabled = NO;
    if (_coverView == nil) {
        _coverView = [[UIView alloc]initWithFrame:_titleLabel.frame];
        _coverView.backgroundColor = [UIColor clearColor];
        _coverView.userInteractionEnabled = NO;
        [self addSubview:_coverView];
    }
}

-(void)removeCoverView{
    
    self.userInteractionEnabled = YES;
    
    [_coverView removeFromSuperview];
    _coverView = nil;
}

#pragma mark SubUI

-(void)loadSubUI{
    IndexBuyTacticsButton *selfView = self;
    IndexBuyView *selfSuperView = (IndexBuyView *)self.superview.superview;
    _indexBuyTacticsView = [[IndexBuyTacticsView alloc]initWithFrame:CGRectMake(0, selfSuperView.bearishBtn.frame.origin.y, selfSuperView.frame.size.width, selfSuperView.bearishBtn.frame.origin.y) ProdcutModel:self.productModel];
    _indexBuyTacticsView.backgroundColor = Color_grayDeep;
    _indexBuyTacticsView.IndexBuyTacticsBlock = ^(void){
        _indexBuyTacticsView = nil;
        [selfView removeBGCoverView];//移除顶部遮挡层
    };
    [selfSuperView addSubview:_indexBuyTacticsView];
    [selfSuperView bringSubviewToFront:selfSuperView.bottomBgView];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _indexBuyTacticsView.frame = CGRectMake(0, -7, selfSuperView.frame.size.width, selfSuperView.bearishBtn.frame.origin.y);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _indexBuyTacticsView.frame = CGRectMake(0, 0, selfSuperView.frame.size.width, selfSuperView.bearishBtn.frame.origin.y);
        } completion:^(BOOL finished) {
        }];
    }];
}

#pragma mark 点击持仓直播
-(void)click{
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _titleLabel.backgroundColor = [UIColor grayColor];
        _titleLabel.alpha = 0.9;
    } completion:^(BOOL finished) {
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.alpha = 1;
    }];
    
    [self openView];
}

#pragma mark 逻辑操作

-(void)open{
    [self changeUI:YES];
}

-(void)close{
    [self changeUI:NO];
    [self removeBGCoverView];//移除顶部遮挡层
    [_indexBuyTacticsView otherClose];
    [_indexBuyTacticsView removeFromSuperview];
    _indexBuyTacticsView = nil;
}

-(void)changeUI:(BOOL)aChange{
    if (aChange) {
        if (_redPointView.hidden) {
            _redPointView.hidden = NO;
        }
        _titleLabel.textColor = Color_red;
        _titleImgView.image = [UIImage imageNamed:@"chicangzhibo_on"];
        [self removeCoverView];
    }
    else{
        if (!_redPointView.hidden) {
            _redPointView.hidden = YES;
        }
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleImgView.image = [UIImage imageNamed:@"chicangzhibo_off"];
        [self createCoverView];
    }
}

//行情动态获取当前价
-(void)changeCurrentPrice:(NSString *)currentPrice{
    [_indexBuyTacticsView changeCurrentPrice:currentPrice];
}

#pragma mark OpenUI

-(void)openView{
    if (_indexBuyTacticsView == nil) {
        [self loadSubUI];
        [_indexBuyTacticsView setDefaultCurrentPrice:_currentPrice];
        [self loadBGCoverView];
    }
    else{
        [self removeBGCoverView];//移除顶部遮挡层
        [_indexBuyTacticsView otherClose];
        [_indexBuyTacticsView removeFromSuperview];
        _indexBuyTacticsView = nil;
    }
}

-(void)loadBGCoverView{
    if (_bgCoverView != nil) {
        [self removeBGCoverView];
    }
    _bgCoverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.superview.superview.superview.frame.origin.y)];
    _bgCoverView.backgroundColor = [UIColor clearColor];
    [self.superview.superview.superview.superview addSubview:_bgCoverView];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openView)];
    [_bgCoverView addGestureRecognizer:tapGes];
}

-(void)removeBGCoverView{
    [_bgCoverView removeFromSuperview];
    _bgCoverView = nil;
}

#pragma mark ClickTouch

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    _titleLabel.backgroundColor = [UIColor grayColor];
    _titleLabel.alpha = 0.8;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.alpha = 1;
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.alpha = 1;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
