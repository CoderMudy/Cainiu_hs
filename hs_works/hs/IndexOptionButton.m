//
//  IndexOptionButton.m
//  hs
//
//  Created by RGZ on 16/3/7.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import "IndexOptionButton.h"

@implementation IndexOptionButton
{
    UIView      *_activateStockButton;
    
    NSMutableArray  *_imgArray;
    NSMutableArray  *_titleArray;
    NSMutableArray  *_statusArray;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self  = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self loadUI];
    }
    
    return self;
}

-(void)loadUI{
    _activateStockButton = [[UIView alloc]init];
    _activateStockButton.frame = self.bounds;
    _activateStockButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:8.0/255.0 blue:27.0/255.0 alpha:1];
    _activateStockButton.clipsToBounds = YES;
    _activateStockButton.layer.cornerRadius = 3;
    [self addSubview:_activateStockButton];
    
    CGSize titleSize = [DataUsedEngine getStringRectWithString:@"激活实盘账户" Font:13 Width:MAXFLOAT Height:15];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, titleSize.width, 15)];
    titleLabel.center = CGPointMake(_activateStockButton.frame.size.width/2, _activateStockButton.frame.size.height/2);
    titleLabel.text = @"激活实盘账户";
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [UIColor whiteColor];
    [_activateStockButton addSubview:titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x + titleLabel.frame.size.width, 0, 5, 5)];
    imageView.center = CGPointMake(imageView.center.x+5, titleLabel.center.y);
    imageView.image = [UIImage imageNamed:@"pull_down"];
    imageView.userInteractionEnabled = YES;
    [_activateStockButton addSubview:imageView];
}

-(void)setCainiuStatus:(int)aCainiuStatus   ScoreStatus:(int)aScoreStatus   NanjsStatus:(int)aNanjsStatus{
    _titleArray     = [NSMutableArray arrayWithCapacity:0];
    _statusArray    = [NSMutableArray arrayWithCapacity:0];
    _imgArray       = [NSMutableArray arrayWithCapacity:0];
    /**
     *  财牛账户
     */
    if (aCainiuStatus >= 1) {
        [_titleArray addObject:[NSString stringWithFormat:@"%@账户",App_appShortName]];
        [_imgArray addObject:@"cainiu_gold"];
        if (aCainiuStatus == 2){
            [_statusArray addObject:@"1"];
        }
        else{
            [_statusArray addObject:@"0"];
        }
    }
    
    /**
     *  积分
     */
    if (aScoreStatus >= 1) {
        if (aScoreStatus == 2){
        }
        else{
        }
    }
    
    /**
     *  南交所
     */
    if (aNanjsStatus >= 1) {
        [_titleArray addObject:@"南方稀贵金属交易所"];
        [_imgArray addObject:@"nan_gold"];
        if (aNanjsStatus == 2){
            [_statusArray addObject:@"1"];
        }
        else{
            [_statusArray addObject:@"0"];
        }
    }
}

-(void)goActivateMoney{
    self.optionBlock(_titleArray,_imgArray,_statusArray);
}

//-----------------------

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _activateStockButton.alpha = 0.5;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     _activateStockButton.alpha = 1;
    [self goActivateMoney];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _activateStockButton.alpha = 1;
}

@end
