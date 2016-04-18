//
//  TradeRulesView.m
//  hs
//
//  Created by RGZ on 16/1/14.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "TradeRulesView.h"

@implementation TradeRulesView
{
    float timeLabelHeight;
    UIImageView *_imageView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame TimeLabelHeight:(float)aTimeLabelHeight{
    self = [super initWithFrame:frame];
    if (self) {
        timeLabelHeight = aTimeLabelHeight;
        [self loadUI];
    }
    
    return self;
}

-(void)loadUI{
    CGSize labelSize = [DataUsedEngine getStringRectWithString:@"交易规则" Font:12 Width:MAXFLOAT Height:20/667.0*ScreenHeigth];
    float labelWidth = labelSize.width;
    UILabel *tradeRuleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - labelWidth/2, timeLabelHeight, labelWidth, self.frame.size.height - timeLabelHeight)];
    tradeRuleLabel.text = @"交易规则";
    tradeRuleLabel.textColor = Color_Gold;
    tradeRuleLabel.font = [UIFont systemFontOfSize:12];
    tradeRuleLabel.center = CGPointMake(tradeRuleLabel.center.x-10, tradeRuleLabel.center.y);
    [self addSubview:tradeRuleLabel];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(tradeRuleLabel.frame.origin.x + tradeRuleLabel.frame.size.width+5, 0, 12, 12)];
    _imageView.center = CGPointMake(_imageView.center.x, tradeRuleLabel.center.y);
    _imageView.layer.cornerRadius = 12/2.0;
    _imageView.clipsToBounds = YES;
    _imageView.image = [UIImage imageNamed:@"trade_rules_off.jpg"];
    _imageView.animationImages = @[[UIImage imageNamed:@"trade_rules_off.jpg"],
                                  [UIImage imageNamed:@"trade_rules_on.jpg"]
                                  ];
    [_imageView setAnimationDuration:2.2];
    [_imageView setAnimationRepeatCount:0];
    [self addSubview:_imageView];
    
    if ([CacheEngine isShowTradeRules]) {
        [_imageView startAnimating];
    }
}

-(void)stopAnimation{
    [_imageView stopAnimating];
}

@end
