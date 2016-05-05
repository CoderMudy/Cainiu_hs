//
//  IndexBottomSwitchView.m
//  hs
//
//  Created by RGZ on 16/5/5.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "IndexBottomSwitchView.h"

@implementation IndexBottomSwitchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self loadUI];
    }
    
    return self;
}

-(void)loadUI{
    
    UIView  *bgView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 30)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.clipsToBounds = YES;
    bgView.layer.cornerRadius = 4;
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = Color_Gold.CGColor;
    [self addSubview:bgView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, bgView.frame.size.height)];
    lineView.backgroundColor = Color_Gold;
    lineView.center = CGPointMake(bgView.frame.size.width/2, lineView.center.y);
    [bgView addSubview:lineView];
    
    self.financeNewsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.financeNewsButton.frame = CGRectMake(0, 0, (self.frame.size.width-40)/2, bgView.frame.size.height);
    [self.financeNewsButton setTitle:@"金十财经" forState:UIControlStateNormal];
    [self.financeNewsButton setImage:[UIImage imageNamed:@"jinshicaijing_unselect"] forState:UIControlStateNormal];
    [self.financeNewsButton setTitleColor:Color_Gold forState:UIControlStateNormal];
    
    [self.financeNewsButton setImage:[UIImage imageNamed:@"jinshicaijing_select"] forState:UIControlStateSelected];
    [self.financeNewsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.financeNewsButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.financeNewsButton addTarget:self action:@selector(financeNewsClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.financeNewsButton];
    
    self.positionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.positionButton.frame = CGRectMake((self.frame.size.width-40)/2, 0, (self.frame.size.width-40)/2, bgView.frame.size.height);
    [self.positionButton setTitle:@"品种持仓" forState:UIControlStateNormal];
    [self.positionButton setImage:[UIImage imageNamed:@"position_unselect"] forState:UIControlStateNormal];
    [self.positionButton setTitleColor:Color_Gold forState:UIControlStateNormal];
    
    [self.positionButton setImage:[UIImage imageNamed:@"position_select"] forState:UIControlStateSelected];
    [self.positionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.positionButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.positionButton addTarget:self action:@selector(positionClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.positionButton];
    
    [self.financeNewsButton addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    [self.positionButton addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    
}

-(void)financeNewsClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = Color_Gold;
    }
    else{
        sender.backgroundColor = [UIColor clearColor];
    }
    
    self.positionButton.selected = NO;
    self.positionButton.backgroundColor = [UIColor clearColor];
}

-(void)positionClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = Color_Gold;
    }
    else{
        sender.backgroundColor = [UIColor clearColor];
    }
    
    self.financeNewsButton.selected = NO;
    self.financeNewsButton.backgroundColor = [UIColor clearColor];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([object isEqual:self.financeNewsButton]) {
        self.financeNewsBlock(self.financeNewsButton.selected);
    }
    else if ([object isEqual:self.positionButton]){
       self.positionBlock(self.positionButton.selected);
    }
}

-(void)reSetSelected{
    self.positionButton.selected = NO;
    self.positionButton.backgroundColor = [UIColor clearColor];
    
    self.financeNewsButton.selected = NO;
    self.financeNewsButton.backgroundColor = [UIColor clearColor];
}

@end
