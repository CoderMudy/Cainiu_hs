//
//  UnloginPositionView.m
//  hs
//
//  Created by PXJ on 15/6/17.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "UnloginPositionView.h"
#import "ReportMainView.h"
#import "FoyerReportView.h"

@implementation UnloginPositionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _titleLab = [[UILabel alloc] init];
        _titleLab.center = CGPointMake(ScreenWidth/2,50);
        _titleLab.bounds = CGRectMake(0, 0, 80, 20);
        _titleLab.text = @"累计赚取";
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = K_COLOR_CUSTEM(153, 153, 153, 1);
        [self addSubview:_titleLab];
        
        _moneyLab = [[UILabel alloc] init];
        _moneyLab.center = CGPointMake(ScreenWidth/2+12, _titleLab.frame.origin.y+_titleLab.frame.size.height+25);
        _moneyLab.textAlignment = NSTextAlignmentCenter;
        _moneyLab.bounds = CGRectMake(0, 0, ScreenWidth, 50);
        _moneyLab.font = [UIFont systemFontOfSize:40];
        _moneyLab.textColor = K_COLOR_CUSTEM(242, 40, 58, 1);
        [self addSubview:_moneyLab];
        
        _redBagView = [[UIImageView alloc] init];
        _redBagView.image = [UIImage imageNamed:@"icon_08"];
        float moneyLabWidth = [Helper calculateTheHightOfText:_moneyLab.text height:40 font:[UIFont systemFontOfSize:40]];
        _redBagView.center = CGPointMake((ScreenWidth-moneyLabWidth)/2+10, _moneyLab.frame.size.height+_moneyLab.frame.origin.y-22);
        _redBagView.bounds = CGRectMake(0, 0, _redBagView.image.size.width, _redBagView.image.size.height);
        [self addSubview:_redBagView];
        
        _goFinacBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _goFinacBtn.center = CGPointMake(ScreenWidth/2,_moneyLab.frame.size.height+_moneyLab.frame.origin.y+10);
        _goFinacBtn.bounds = CGRectMake(0, 0, 100, 20);
        _goFinacBtn.backgroundColor = K_COLOR_CUSTEM(242, 40, 58, 1);
        [_goFinacBtn setTitle:@"来赚钱" forState:UIControlStateNormal];
        [_goFinacBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        _goFinacBtn.layer.cornerRadius = 3;
        _goFinacBtn.layer.masksToBounds = YES;
        [self addSubview:_goFinacBtn];
        
        _rollView  = [[UIView alloc] init];
        _rollView.center = CGPointMake(ScreenWidth/2, _goFinacBtn.frame.size.height+_goFinacBtn.frame.origin.y+70);
        _rollView.bounds= CGRectMake(0, 0, ScreenWidth, 60);
        [self addSubview:_rollView];
    }
    
    return self;
}

- (void)setMoneyLabText:(float)Profit
{
    NSString * profirtStr;
    
    
    if (Profit>=1000000) {
        Profit = Profit/10000.0;
       profirtStr =[DataEngine addSign:[NSString stringWithFormat:@"%.2f",Profit]] ;
        profirtStr = [NSString stringWithFormat:@"%@万元",profirtStr];
    }else{
    
    
    profirtStr =[DataEngine addSign:[NSString stringWithFormat:@"%.2f",Profit]] ;
        profirtStr = [NSString stringWithFormat:@"%@元",profirtStr];
    }
    NSAttributedString * profirStrAttributeStr = [Helper multiplicityText:profirtStr from:(int)(profirtStr.length)-1 to:1 font:12];
    _moneyLab.attributedText = [Helper multableText:profirStrAttributeStr from:0 to:(int)(profirtStr.length) color:K_COLOR_CUSTEM(242, 40, 58, 1)];
    
    float moneyLabWidth = [Helper calculateTheHightOfText:_moneyLab.text height:40 font:[UIFont systemFontOfSize:40]];
    _redBagView.center = CGPointMake((ScreenWidth-moneyLabWidth)/2+10, _moneyLab.frame.size.height+_moneyLab.frame.origin.y-22);
}
- (void)setRollViewDictionary:(NSArray*)array
{
    NSMutableArray * titleArray = [NSMutableArray array];
    NSMutableArray * detailArray = [NSMutableArray array];
    if (array.count>0) {
        for (NSDictionary * dic in array) {
            [titleArray addObject:[NSString stringWithFormat:@"%@操盘盈利",dic[@"nickName"]]];
            
            float profit = [dic[@"profit"] floatValue];
            
            if (profit>100000) {
                
                [detailArray addObject:[NSString stringWithFormat:@"%.2f万元",profit/10000]];

            }else{
                [detailArray addObject:[NSString stringWithFormat:@"%.2f元",profit]];
            }
        }
        NSArray * array = _rollView.subviews;
        for (id sender in array) {
            [sender removeFromSuperview];
        }
    [self reportViewStopReport];
        _reportMainView = nil;
        _reportMainView = [[FoyerReportView alloc]initWithFrame:CGRectMake(ScreenWidth*7/26,0, ScreenWidth, 30) nickArray:titleArray profitArray:detailArray];
        _reportMainView.tag = 5000000;
        [_rollView addSubview:_reportMainView];
//    _reportMainView = [[ReportMainView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 32) Title:titleArray Detail:detailArray];
//    [_rollView addSubview:_reportMainView];
}
}



- (void)reportViewStopReport
{
    [_reportMainView stopReport];
}

- (void)setRollViewWith:(NSString*)earnStr rollDictionary:(NSDictionary *)dictionary
{

    float moneyLabWidth = [Helper calculateTheHightOfText:_moneyLab.text height:50 font:[UIFont systemFontOfSize:50]];
    _redBagView.center = CGPointMake((ScreenWidth-moneyLabWidth)/2-5, _moneyLab.frame.size.height+_moneyLab.frame.origin.y-15);
}

@end
