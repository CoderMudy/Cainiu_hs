//
//  PositionMainView.m
//  hs
//
//  Created by PXJ on 15/4/28.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import "TopPositionView.h"
#define K_HEIGHT self.bounds.size.height
#define K_WIDTH self.bounds.size.width

@implementation TopPositionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.backView .image = [UIImage imageNamed:@"background_05"];
        [self addSubview:self.backView ];
        
        self.earnTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, K_WIDTH, 10)];
        self.earnTitleLab.font = [UIFont systemFontOfSize:10];
        self.earnTitleLab.textColor = K_COLOR_CUSTEM(225, 225, 225, 1);
        [self addSubview:self.earnTitleLab];
        
        self.earnLab = [[UILabel alloc] initWithFrame:CGRectMake(20, self.earnTitleLab.frame.origin.y+self.earnTitleLab.frame.size.height, K_WIDTH, 50)];
        self.earnLab.font = [UIFont systemFontOfSize:40];
        self.earnLab.textColor = [UIColor whiteColor];
        [self addSubview:self.earnLab];
        
        self.inteEarnTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, self.earnLab.frame.origin.y+self.earnLab.frame.size.height+10, K_WIDTH, 10)];
        self.inteEarnTitleLab.font = [UIFont systemFontOfSize:10];
        self.inteEarnTitleLab.textColor = K_COLOR_CUSTEM(225, 225, 225, 1);
        [self addSubview:self.inteEarnTitleLab];
        
        self.inteEarnLab = [[UILabel alloc] initWithFrame:CGRectMake(20, self.inteEarnTitleLab.frame.origin.y+self.inteEarnTitleLab.frame.size.height+5, K_WIDTH, 20)];
        self.inteEarnLab.font = [UIFont systemFontOfSize:20];
        self.inteEarnLab.text = @"0.00";
        self.inteEarnLab.textColor = [UIColor whiteColor];
        [self addSubview:self.inteEarnLab];
        
        _markll = [[UILabel alloc] initWithFrame:CGRectMake(20, self.earnLab.frame.origin.y, 15, 15)];
        _markll.textColor = [UIColor whiteColor];
        _markll.font = [UIFont systemFontOfSize:25.f];
        _markll.text =@"+";
        [self addSubview:_markll];
        
        
        
        
    }
    return self;
}


#pragma mark 刷新持仓头部

- (void)loadTopViewOptional:(BOOL)isOptionalPage  dataArray:(NSMutableArray * )dataArray newPriceArray:(NSMutableArray *)newPriceArray curCashProfit:(float)curCashProfit curScoreProfit:(float)curScoreProfit dataDic:(NSDictionary*)dataDic
{
//    int posiState = 5;
    
    CGRect earnRect = self.earnLab.frame;
    
    [self.earnLab removeFromSuperview];
    self.earnLab = nil;
    
    self.earnLab = [[UILabel alloc] initWithFrame:earnRect];
    self.earnLab.font = [UIFont systemFontOfSize:50];
    self.earnLab.textColor = [UIColor whiteColor];
    [self addSubview:self.earnLab];
    
    if (isOptionalPage) {
        
        
        if (dataArray.count>0) {
            self.frame = CGRectMake(0, 0, ScreenWidth, 80);
            
        }else{
            
            self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeigth-113);
        }
        
        
    }else{
        
        NSArray * array =dataArray;
        
        if (array.count>0) {
            self.markll.hidden = NO;
            self.inteEarnTitleLab.hidden = YES;
            
            self.frame = CGRectMake(0, 0, ScreenWidth, 200-64);
            self.backView.frame = self.frame;
            
            if (curCashProfit>0||(curCashProfit==0&&curScoreProfit>0)) {
//                posiState = 6;
                self.markll.text = @"+";
                
            }else if(curCashProfit<0||(curCashProfit==0&&curScoreProfit<0)){
//                posiState = 7;
                
                self.markll.text = @"-";
                
            }else{
//                posiState = 5;

            }
            
            
            self.earnTitleLab.text = @"持仓收益";
            NSString * earnStr;
            if (curCashProfit>100000||curCashProfit<-100000) {
                curCashProfit = curCashProfit/10000.0;
                earnStr = [NSString stringWithFormat:@"%.2f万元",curCashProfit];
                self.markll.text = @"+";
                curCashProfit = curCashProfit*10000;

            }else{
                
                
                earnStr = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",curCashProfit]];
                earnStr = [NSString stringWithFormat:@"%@元",earnStr];
                self.markll.text = @"+";
                
            }
            if (curCashProfit<0) {
                self.markll.text= @"-";
                earnStr = [earnStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
            }
            
            
            NSAttributedString * earnstr = [Helper multiplicityText:earnStr from:(int)earnStr.length-1 to:1 font:14];
            
            self.earnLab.text = @"";
            
            self.earnLab.attributedText = nil;
            
            self.earnLab.attributedText = earnstr;
            
            NSString * inteEarnStr;
            if(curScoreProfit==0)
            {
                inteEarnStr = @"0";
            }else
            {
                
                inteEarnStr = [DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",curScoreProfit]];
                
                
            }
            
            if(curScoreProfit>=0){
                
                inteEarnStr = [NSString stringWithFormat:@"+%@",inteEarnStr];
                
            }
            inteEarnStr = [NSString stringWithFormat:@"%@积分",inteEarnStr];
            NSAttributedString* attributeInteEarn = [Helper multiplicityText:inteEarnStr from:(int)inteEarnStr.length-2 to:2 font:14];
            self.inteEarnLab.attributedText =attributeInteEarn;
            _shView.hidden = YES;
            _szView.hidden = YES;
            _lineLab.hidden = YES;
            
            self.earnTitleLab.frame =CGRectMake(20, 20, ScreenWidth, 10);
            self.earnLab.frame =CGRectMake(35, self.earnTitleLab.frame.origin.y+self.earnTitleLab.frame.size.height+5, ScreenWidth, 40);
            self.markll.frame = CGRectMake(20, self.earnTitleLab.frame.origin.y+self.earnTitleLab.frame.size.height, 20, 20);
            self.inteEarnLab.frame = CGRectMake(20, self.earnLab.frame.origin.y+self.earnLab.frame.size.height+10, ScreenWidth, 20);
            
        }else {
            self.frame = CGRectMake(0, 0, ScreenWidth, 240-64);
            self.backView.frame = self.frame;
            self.backView.image = K_setImage(@"background_header_05");
            
            _shView.hidden = NO;
            _szView.hidden = NO;
            _lineLab.hidden = NO;
            self.inteEarnTitleLab.hidden = NO;
            self.earnTitleLab.text = @"可用现金";
            self.inteEarnTitleLab.text =@"可用积分";
            NSString * earnStr =dataDic[@"usedAmt"];
            NSString * earntext ;
            
            
            int unit = 0;
            
            if ((NSNull*)earnStr != [NSNull null] && earnStr != nil&&earnStr!=NULL )
            {
                
                
                if (earnStr.floatValue >= 10000.0||earnStr.floatValue <= -10000.0 ) {
                    
                    earntext = [NSString stringWithFormat:@"%.2f万元",earnStr.floatValue/10000];
                    unit = 2;
                    
                }else{
                    
                    earntext = [DataEngine addSign:[NSString stringWithFormat:@"%.2f",earnStr.floatValue]];
                    earntext = [NSString stringWithFormat:@"%@元",earntext];
                    unit = 1;
                }
                
                
                
            }else if(!earntext)
            {
                earntext =@"0.00元";
                unit = 1;
                
            }
            
            self.markll.hidden = YES;
            
            NSAttributedString * mulearnstr = [Helper multiplicityText:earntext from:(int)earntext.length-unit to:unit  font:14];
            
            self.earnLab.text = @"";
            
            self.earnLab.attributedText = nil;
            
            self.earnLab.attributedText = mulearnstr;
            if ((NSNull*)dataDic[@"score"] != [NSNull null] && dataDic[@"score"] != nil )
            {
                NSString * earnStr =dataDic[@"score"];
                self.inteEarnLab.text = [DataEngine countNumAndChangeformat:[NSString stringWithFormat:@"%.0f",earnStr.floatValue]];
                
            }else if(!self.inteEarnLab.text)
            {
                self.inteEarnLab.text = @"0";
            }
            self.earnTitleLab.frame =CGRectMake(20, 10, ScreenWidth, 10);
            self.earnLab.frame =CGRectMake(20, self.earnTitleLab.frame.origin.y+self.earnTitleLab.frame.size.height, ScreenWidth, 40);
            self.inteEarnTitleLab.frame =CGRectMake(20, self.earnLab.frame.origin.y+self.earnLab.frame.size.height+10, ScreenWidth, 10);
            self.inteEarnLab.frame = CGRectMake(20, self.inteEarnTitleLab.frame.origin.y+self.inteEarnTitleLab.frame.size.height, ScreenWidth, 20);
        }
    }
    
    
    
    
}


@end
