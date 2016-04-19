//
//  StockDetailView.m
//  hs
//
//  Created by PXJ on 15/5/20.
//  Copyright (c) 2015年 luckin. All rights reserved.
//

#import "StockDetailView.h"
#import "OtherPositionBaseClass.h"
#import "ELDataModels.h"
#import "OrderDetailViewController.h"


@implementation StockDetailView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _stockTopView = [[TopStockView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
        [self addSubview:_stockTopView];

        
        _klineView = [[QwKlineLandscapeView  alloc] initWithFrame:CGRectMake(0, _stockTopView.frame.size.height+_stockTopView.frame.origin.y, ScreenWidth, ScreenHeigth-365)];
        _klineView.idxType = IDX_MACD;
        _klineView.boundColor =  [UIColor grayColor];//[UIColor whiteColor ];
        [self addSubview:_klineView];
        
        
        _trendView = [[QwTrendViewTouchable alloc] initWithFrame:CGRectMake(0, _stockTopView.frame.size.height+_stockTopView.frame.origin.y, ScreenWidth,ScreenHeigth-365)];
        
        _trendView.boundColor  = [UIColor grayColor];//[UIColor whiteColor];
        [self addSubview:_trendView];
        
        
        
//操盘额度视图 默认隐藏
        
        _AmtView = [[UIView alloc] initWithFrame:CGRectMake(0, _klineView.frame.size.height+_klineView.frame.origin.y+2, ScreenWidth, 105)];
        _AmtView.alpha = 0;
        _AmtView.hidden = YES;
        float space = 20;
        float length = (ScreenWidth-space*5)/4.0;
        for(int i= 0 ;i<8 ;i++){
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 80000+i;
            [btn setTitleColor:K_COLOR_CUSTEM(110, 110, 110, 1) forState:UIControlStateNormal];
            btn.frame = CGRectMake(space +i%4*(length+space) , 5 + 35*(i/4), length, 30);
            [btn.titleLabel setFont:[UIFont systemFontOfSize:11]];
            [_AmtView addSubview:btn];
            UILabel * deleteLab = [[UILabel alloc] init];
            deleteLab.center = btn.center;
            deleteLab.bounds = CGRectMake(0, 0, length-5, 1);
            deleteLab.tag = 90000+i;
            deleteLab.backgroundColor = K_COLOR_CUSTEM(110, 110, 110, 1);
            [_AmtView addSubview:deleteLab];
            deleteLab.hidden = YES;
        }
        
        UILabel  * lineLab  = [[UILabel alloc] initWithFrame:CGRectMake(20, 85, ScreenWidth-40, 1)];
        lineLab.backgroundColor = K_COLOR_CUSTEM(193, 193, 193, 1);
        
        _alertLab = [[UILabel alloc] initWithFrame:CGRectMake(0,lineLab.frame.origin.y+lineLab.frame.size.height+5,ScreenWidth, 10 )];
        _alertLab.text = @"请选择交易本金";
        _alertLab.textAlignment = NSTextAlignmentCenter;
        _alertLab.font = [UIFont systemFontOfSize:10];
        _alertLab.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
        
        [_AmtView addSubview:lineLab];
        [_AmtView addSubview:_alertLab];
        [self addSubview:_AmtView];
        
        _btnBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-60, ScreenWidth, 60)];
        _btnBackView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_btnBackView];
        
        
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyBtn.frame = CGRectMake(ScreenWidth/2.0+10, 5, (ScreenWidth-60)/2.0, 35);
        [_buyBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        _buyBtn.layer.cornerRadius = 3;
        _buyBtn.layer.masksToBounds = YES;
        [_btnBackView addSubview:_buyBtn];
        
        _amtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_amtBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_amtBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _amtBtn.frame = CGRectMake(20, 5, (ScreenWidth-60)/2.0, 35);
        _amtBtn.layer.cornerRadius = 3;
        _amtBtn.layer.masksToBounds = YES;
        [_btnBackView addSubview:_amtBtn];
    }
    
    
    return self;
}

- (void)setStockDetailViewValueWithSource:(BOOL)isbuy
                                 position:(BOOL)isPositon
                                 isbuyBuy:(BOOL)isbuyBuy
                               isexponent:(BOOL)isexponent
                     stockDetailDataModel:(id)rosource
                                 realtime:(HsRealtime*)realtime
{
    
    
    if (isPositon&&!isbuyBuy) {
        _stockTopView.markll.hidden = NO;
        _stockTopView.btnMarkImageView.image = [UIImage imageNamed:@"button_11"];

        if (isbuy&&!isbuyBuy) {

            PositionOrderList * posiBolist = rosource;
            float earnValue = ( realtime.newPrice - posiBolist.buyPrice)*posiBolist.factBuyCount;

            if (realtime.newPrice ==0) {
                earnValue =( realtime.preClosePrice - posiBolist.buyPrice)*posiBolist.factBuyCount;
            }
            NSString * earnStr = [NSString stringWithFormat:@"%.2f",earnValue];
            
            _stockTopView.stockNameLab.text = realtime.name;
            _stockTopView.stockNameLab.textColor = [UIColor whiteColor];
            _stockTopView.stockNumLab.text =realtime.code;
            _stockTopView.stockNumLab.textColor = K_COLOR_CUSTEM(218, 218, 218, 1);
            
            _stockTopView.nePriceMarkLab.bounds = CGRectMake(0, 0, 70, 10);
            _stockTopView.nePriceMarkLab.textColor = [UIColor whiteColor];
            
            //收益、积分收益
            _stockTopView.nePriceLab.textColor = [UIColor whiteColor];
            _stockTopView.detailLab.textColor = [UIColor whiteColor];

            NSString * str = realtime.priceChange<0?@"":@"+";
            _stockTopView.detailLab.text = [NSString stringWithFormat:@"%.2f  %@%.2f  %@%@", realtime.newPrice,str,realtime.priceChange,str,[NSString stringWithFormat:@"%.2f%%",realtime.priceChangePercent*100]];
             realtime.newPrice = realtime.newPrice *100/100;
            posiBolist.buyPrice = posiBolist.buyPrice*100/100;

            if ( earnValue> 0) {
                _stockTopView.backView.image = [UIImage imageNamed:@"background_06"];
                _stockTopView.nePriceMarkLab.backgroundColor = K_COLOR_CUSTEM(133, 18, 28, 1);
                _stockTopView.lineLab.backgroundColor = K_COLOR_CUSTEM(133, 18, 28, 1);
                _stockTopView.markll.text = @"+";
                

            }else if( earnValue==0){
                _stockTopView.backView.image = [UIImage imageNamed:@"background_05"];
                _stockTopView.nePriceMarkLab.backgroundColor = K_COLOR_CUSTEM(65,64,63,1);
                _stockTopView.lineLab.backgroundColor = K_COLOR_CUSTEM(65,64,63,1);
                _stockTopView.markll.text = @"+";
                
                
            }else{
                _stockTopView.backView.image = [UIImage imageNamed:@"background_07"];
                _stockTopView.nePriceMarkLab.backgroundColor = K_COLOR_CUSTEM(0,107,36, 1);
                _stockTopView.lineLab.backgroundColor = K_COLOR_CUSTEM(0,107,36, 1);
                _stockTopView.markll.text = @"-";
                earnStr = [earnStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
                
            }
            if (posiBolist.fundType==0) {
                _stockTopView.nePriceMarkLab.text = @"持仓收益(元)";
                _stockTopView.nePriceLab.text = earnStr;

            }else{
                _stockTopView.nePriceMarkLab.text = @"持仓收益(积分)";
                _stockTopView.nePriceLab.text = [NSString stringWithFormat:@"%.0f",earnStr.floatValue];

                
            }
            
            

            float width = [Helper calculateTheHightOfText:_stockTopView.nePriceLab.text height:40 font:[UIFont systemFontOfSize:40]];
            
            _stockTopView.nePriceLab.bounds = CGRectMake(0, 0, width, 40);
            CGRect nePriceFrame = _stockTopView.nePriceLab.frame;
            _stockTopView.btnMarkImageView.frame = CGRectMake(nePriceFrame.origin.x+width, nePriceFrame.origin.y+32, 5, 5);
            [_stockTopView.searchBtn setImage:[UIImage imageNamed:@"search_01"] forState:UIControlStateNormal];
            [_stockTopView.backBtn setImage:[UIImage imageNamed:@"return_1"] forState:UIControlStateNormal];
            
            
            
            
        }else if(isPositon&&!isbuyBuy){
           
            
            if (realtime.tradeStatus==7||realtime.tradeStatus ==8||realtime.tradeStatus==21) {
                
                realtime.newPrice = realtime.preClosePrice;
            }else{
            
                if (realtime.newPrice==0||!realtime) {
                    realtime.newPrice = realtime.preClosePrice;
                }
            
            }
            ELOrderList * otherModel = rosource;
            
            float earnValue;
            NSString * earnStr;
            if (otherModel.factBuyCount==0) {
            earnStr = @"0.00%";
            }else{
            earnValue = ( realtime.newPrice - otherModel.buyPrice) *otherModel.factBuyCount;
            earnValue = earnValue/otherModel.cashFund;
            earnStr = [NSString stringWithFormat:@"%.2f%%",earnValue*100.0];
            }
            
            earnStr = [earnStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            _stockTopView.stockNameLab.text = realtime.name;
            _stockTopView.stockNameLab.textColor = [UIColor whiteColor];
            _stockTopView.stockNumLab.text =realtime.code;
            _stockTopView.stockNumLab.textColor = K_COLOR_CUSTEM(218, 218, 218, 1);
            _stockTopView.nePriceMarkLab.text = @"持仓收益率";
            _stockTopView.nePriceMarkLab.bounds = CGRectMake(0, 0, 60, 10);
            _stockTopView.nePriceMarkLab.textColor = [UIColor whiteColor];
            
            //收益、积分收益
            
            _stockTopView.nePriceLab.textColor = [UIColor whiteColor];
            _stockTopView.detailLab.textColor = [UIColor whiteColor];
            NSString * str = realtime.priceChange<0?@"":@"+";

            _stockTopView.detailLab.text = [NSString stringWithFormat:@"%.2f  %@%.2f  %@%@", realtime.newPrice,str,realtime.priceChange,str,[NSString stringWithFormat:@"%.2f%%",realtime.priceChangePercent*100]];
            NSString * reNewPrice = [NSString stringWithFormat:@"%.2f", realtime.newPrice];
             realtime.newPrice = reNewPrice.floatValue;
             realtime.newPrice =  realtime.newPrice *100/100;
            otherModel.buyPrice = otherModel.buyPrice*100/100;
            
            
          
            if (  realtime.newPrice - otherModel.buyPrice> 0) {
                _stockTopView.backView.image = [UIImage imageNamed:@"background_06"];
                _stockTopView.nePriceMarkLab.backgroundColor = K_COLOR_CUSTEM(133, 18, 28, 1);
                _stockTopView.lineLab.backgroundColor = K_COLOR_CUSTEM(133, 18, 28, 1);
                _stockTopView.markll.text = @"+";
                
            }else if( realtime.newPrice == otherModel.buyPrice){
                _stockTopView.backView.image = [UIImage imageNamed:@"background_05"];
                _stockTopView.nePriceMarkLab.backgroundColor = K_COLOR_CUSTEM(65,64,63,1);
                _stockTopView.lineLab.backgroundColor = K_COLOR_CUSTEM(65,64,63,1);
                _stockTopView.markll.text = @"+";
                
                
            }else{
                _stockTopView.backView.image = [UIImage imageNamed:@"background_07"];
                _stockTopView.nePriceMarkLab.backgroundColor = K_COLOR_CUSTEM(0,107,36, 1);
                _stockTopView.lineLab.backgroundColor = K_COLOR_CUSTEM(0,107,36, 1);
                _stockTopView.markll.text = @"-";
                earnStr = [earnStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
                
            }
            _stockTopView.nePriceLab.attributedText = [Helper multiplicityText:earnStr from:(int)earnStr.length-1 to:1 font:25] ;
            
            float width = [Helper calculateTheHightOfText:_stockTopView.nePriceLab.text height:40 font:[UIFont systemFontOfSize:40]];
            _stockTopView.nePriceLab.bounds = CGRectMake(0, 0, width-10, 40);
            
            
            
            
        }
        [_stockTopView.searchBtn setImage:[UIImage imageNamed:@"search_01"] forState:UIControlStateNormal];
        [_stockTopView.backBtn setImage:[UIImage imageNamed:@"return_1"] forState:UIControlStateNormal];
        _stockTopView.updateTimeLab.textColor = K_COLOR_CUSTEM(218, 218, 218, 1);
        
        
        
    }else{
        

        _stockTopView.markll.hidden = YES;
        _stockTopView.backView.image = [UIImage imageNamed:@"background_04"];

        self.stockTopView.stockNameLab.text = realtime.name;
        self.stockTopView.stockNameLab.textColor = [UIColor blackColor];
        self.stockTopView.stockNumLab.text = realtime.code;
        self.stockTopView.stockNumLab.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
        self.stockTopView.nePriceMarkLab.text = @"当前价";
        
        self.stockTopView.nePriceMarkLab.backgroundColor = K_COLOR_CUSTEM(250, 66, 0, 1);
        self.stockTopView.nePriceMarkLab.bounds = CGRectMake(0, 0, 40, 10);
        if (realtime.tradeStatus==7||realtime.tradeStatus ==8||realtime.tradeStatus==21) {
            self.stockTopView.nePriceLab.text = @"停牌";
            self.stockTopView.nePriceLab.font = [UIFont systemFontOfSize:25];
        }else{
            self.stockTopView.nePriceLab.text = [NSString stringWithFormat:@"%0.2f", realtime.newPrice];

        
        }
        
        
        NSString * str = realtime.priceChange<0?@"":@"+";

        self.stockTopView.detailLab.text = [NSString stringWithFormat:@"%@%.2f  %@%.2f%%  %@",str,realtime.priceChange,str,realtime.priceChangePercent*100,@""];
        self.stockTopView.updateTimeLab.textColor = K_COLOR_CUSTEM(110, 110, 110, 1);
        
        
        float width = [Helper calculateTheHightOfText:self.stockTopView.nePriceLab.text height:40 font:[UIFont systemFontOfSize:40]];
        
        _stockTopView.nePriceLab.bounds = CGRectMake(0, 0, width, 40);
        
        if(realtime.priceChange<0) {
            self.stockTopView.nePriceLab.textColor = RGBCOLOR(8, 168, 66);
            self.stockTopView.detailLab.textColor =RGBCOLOR(8, 168, 66);
            self.stockTopView.nePriceMarkLab.backgroundColor =RGBCOLOR(8, 168, 66);
            _stockTopView.lineLab.backgroundColor = RGBCOLOR(8, 168, 66);
            if (isbuyBuy) {
                _stockTopView.btnMarkImageView.image = [UIImage imageNamed:@"button_112"];

            }


        }else if(realtime.priceChange>0){
            self.stockTopView.nePriceLab.textColor = RGBACOLOR(250, 66, 0, 1);
            self.stockTopView.detailLab.textColor = RGBACOLOR(250, 66, 0, 1);
            self.stockTopView.nePriceMarkLab.backgroundColor =RGBACOLOR(250, 66, 0, 1);
            _stockTopView.lineLab.backgroundColor = RGBACOLOR(250, 66, 0, 1);
            if (isbuyBuy) {
                _stockTopView.btnMarkImageView.image = [UIImage imageNamed:@"button_111"];

            }


        }else{
            self.stockTopView.nePriceLab.textColor = RGBACOLOR(110, 110, 110,1);
            self.stockTopView.detailLab.textColor = RGBACOLOR(110, 110, 110,1);
            self.stockTopView.nePriceMarkLab.backgroundColor =RGBACOLOR(110, 110, 110,1);
            _stockTopView.lineLab.backgroundColor = RGBACOLOR(110, 110, 110,1);
            if (isbuyBuy) {
                _stockTopView.btnMarkImageView.image = [UIImage imageNamed:@"button_113"];
                
            }
        
        
        }
        
        [_stockTopView.searchBtn setImage:[UIImage imageNamed:@"search_04"] forState:UIControlStateNormal];
        [_stockTopView.backBtn setImage:[UIImage imageNamed:@"return_4"] forState:UIControlStateNormal];

        
    }
    if (realtime.timestamp) {
        
    
    NSString * strtime = [NSString stringWithFormat:@"%lld",realtime.timestamp];
    NSMutableString * timeStr = [[NSMutableString alloc] initWithString:strtime];
        if (timeStr.length>0) {
            [timeStr deleteCharactersInRange:NSMakeRange((strtime.length-3), 3)];
            
            [timeStr insertString:@":" atIndex:timeStr.length-4];
            [timeStr insertString:@":" atIndex:timeStr.length-2];
            
            //    self.stockTopView.updateTimeLab.text =[NSString stringWithFormat:@"数据更新于 "];
            
            self.stockTopView.updateTimeLab.text =[NSString stringWithFormat:@"数据更新于 %@", timeStr];

        }
        
    _stockTopView.markll.frame =CGRectMake(_stockTopView.nePriceLab.frame.origin.x-15, _stockTopView.nePriceLab.frame.origin.y+5, 15, 15);
    }
}


@end
