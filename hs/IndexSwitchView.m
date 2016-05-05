//
//  IndexSwitchView.m
//  hs
//
//  Created by RGZ on 16/3/8.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "IndexSwitchView.h"

@implementation IndexSwitchView
{
    UIView      *_activateStockButton;
    UIView      *_leftView;
    UIView      *_rightView;
    UILabel     *_centerMoneyLabel;
    UILabel     *_centerProLabel;
    UIImageView *_rightImageView;
    UILabel     *_rightLabel;
    UIImageView *_leftImageView;
}
#define Color_BG [UIColor colorWithRed:38.0/255.0 green:37.0/255.0 blue:42.0/255.0 alpha:1]
#define Color_SubLine [UIColor colorWithRed:55/255.0 green:54/255.0 blue:59/255.0 alpha:1]
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
//    _activateStockButton = [[UIView alloc]init];
//    _activateStockButton.frame = self.bounds;
//    _activateStockButton.backgroundColor = Color_BG;
//    _activateStockButton.clipsToBounds = YES;
//    _activateStockButton.layer.cornerRadius = 4;
//    _activateStockButton.layer.borderWidth = 1;
//    _activateStockButton.layer.borderColor = Color_SubLine.CGColor;
//    [self addSubview:_activateStockButton];
    
//    [self loadLeft];
    [self loadRight];
    [self loadCenter];
}

-(void)loadLeft{
    _leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _activateStockButton.frame.size.height, _activateStockButton.frame.size.height)];
    _leftView.backgroundColor = Color_BG;
    [_activateStockButton addSubview:_leftView];
    
    UIView  *lineView = [[UIView alloc]initWithFrame:CGRectMake(_leftView.frame.size.width - 1, 5, 1, _leftView.frame.size.height - 10)];
    lineView.backgroundColor = Color_SubLine;
    [_leftView addSubview:lineView];
    
    _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _leftView.frame.size.width/5*3, _leftView.frame.size.width/5*3)];
    _leftImageView.image = [UIImage imageNamed:@"cainiulogo_switch_gold"];
    _leftImageView.center = CGPointMake(_leftView.frame.size.width/2, _leftView.frame.size.height/2);
    [_leftView addSubview:_leftImageView];
}

-(void)loadRight{
    _rightView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width - 20 - self.frame.size.height, 0, self.frame.size.height, self.frame.size.height)];
    _rightView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_rightView];
    
    _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _rightView.frame.size.width/5*2, _rightView.frame.size.width/5*2)];
    _rightImageView.image = [UIImage imageNamed:@"rujinlogo_switch_gold"];
    _rightImageView.center = CGPointMake(_rightView.frame.size.width/2, _rightView.frame.size.height/5*2+10);
    [_rightView addSubview:_rightImageView];
    
    _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _rightImageView.frame.origin.y + _rightImageView.frame.size.height + 2, _rightView.frame.size.width, 10)];
    _rightLabel.text = @"入金";
    _rightLabel.textColor = Color_Gold;
    _rightLabel.font = [UIFont systemFontOfSize:9];
    _rightLabel.textAlignment = NSTextAlignmentCenter;
    [_rightView addSubview:_rightLabel];
    
    UITapGestureRecognizer  *rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightTap)];
    [_rightView addGestureRecognizer:rightTap];
}

-(void)rightTap{
    self.switchRightBlock();
}

#pragma mark Center

-(void)loadCenter{
    
    UIView  *centerView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, self.frame.size.width - 40 - self.frame.size.height, self.frame.size.height)];
//    centerView.backgroundColor = Color_BG;
    [self addSubview:centerView];
    
    _centerProLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, centerView.frame.size.width, 10)];
    _centerProLabel.textColor = [UIColor blackColor];
    _centerProLabel.text = [NSString stringWithFormat:@"可用资金(元)"];
    _centerProLabel.font = [UIFont systemFontOfSize:9];
    [centerView addSubview:_centerProLabel];
    
    _centerMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(_centerProLabel.frame.origin.x, _centerProLabel.frame.origin.y + _centerProLabel.frame.size.height, _centerProLabel.frame.size.width, centerView.frame.size.height - _centerProLabel.frame.origin.y - _centerProLabel.frame.size.height)];
    _centerMoneyLabel.font = [UIFont boldSystemFontOfSize:22];
    _centerMoneyLabel.textColor = Color_Gold;
    _centerMoneyLabel.text = @"0.00";
    [centerView addSubview:_centerMoneyLabel];
    
    UITapGestureRecognizer  *centerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(centerTap)];
    [centerView addGestureRecognizer:centerTap];
    
}

-(void)centerTap{
    self.switchCenterBlock();
}

-(void)setUsedMoney:(NSString *)aMoney{
    _centerMoneyLabel.text = aMoney;
}

-(void)setCenterPro:(NSString   *)aPro{
    _centerProLabel.text = aPro;
}

-(void)setIntegral{
    _leftImageView.image = [UIImage imageNamed:@"jifenlogo_switch_gold"];
    _rightImageView.image = [UIImage imageNamed:@"duihuanlogo_switch_gold"];
    _rightLabel.text = @"兑换";
}

@end
