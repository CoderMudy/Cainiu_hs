//
//  FInacTableViewCell.m
//  hs
//
//  Created by PXJ on 15/5/5.
//  Copyright (c) 2015年 cainiu. All rights reserved.
//

#import "FInacTableViewCell.h"
#import "HsRealtime.h"
#import "ELOrderList.h"

@implementation FInacTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = K_COLOR_CUSTEM(248, 248, 248, 1);
        
        UILabel  *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 89, ScreenWidth, 1)];
        [lineLabel setBackgroundColor:RGBCOLOR(191, 191, 191)];
        [self addSubview:lineLabel];
        
        self.numLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 80, 15)];
        self.numLab.textColor = [UIColor grayColor];
        self.numLab.text = @"持仓收益";
        self.numLab.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.numLab];
        
        self.positionLab = [[UILabel alloc] initWithFrame:CGRectMake(self.numLab.frame.origin.x, self.numLab.frame.origin.y+self.numLab.frame.size.height, 110, 35)];
        self.positionLab.layer.cornerRadius = 3;
        self.positionLab.layer.masksToBounds = YES;
        self.positionLab.textColor = [UIColor whiteColor];
        self.positionLab.textAlignment = NSTextAlignmentCenter;
        self.positionLab.font = [UIFont systemFontOfSize:28];
        [self addSubview:self.positionLab];
        
        self.nickLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-150, 10, 130, 20)];
        self.nickLab.textColor = K_COLOR_CUSTEM(55, 54, 53, 1);
        self.nickLab.textAlignment = NSTextAlignmentLeft;
        self.nickLab.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.nickLab];
        
        
        
        
        self.nearBuyLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-150, 30, 130, 15)];
        self.nearBuyLab.textAlignment = NSTextAlignmentLeft;
        self.nearBuyLab.textColor = RGBCOLOR(56, 54, 54);
        self.nearBuyLab.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.nearBuyLab];
        
        self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-150, 47, 130, 15)];
        self.timeLab.textAlignment = NSTextAlignmentLeft;
        self.timeLab.textColor = RGBCOLOR(56, 54, 54);
        self.timeLab.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.timeLab];
        
        self.markLab = [[UILabel alloc] initWithFrame: CGRectMake(ScreenWidth-150, self.timeLab.frame.size.height+self.timeLab.frame.origin.y+4, 35, 12)];
        self.markLab.font = [UIFont systemFontOfSize:12];
        self.markLab.text = @"跟买";
        self.markLab.textColor = RGBCOLOR(199,0,17);
        self.markLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.markLab];
        
        
        UIImageView * bonderImageV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-150, self.timeLab.frame.size.height+self.timeLab.frame.origin.y+3, 40, 14)];
        bonderImageV.image = [UIImage imageNamed:@"genmai"];
        [self addSubview:bonderImageV];
        
        
        
        
        
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict
{
    
    //    if (!self.positionLab.text) {
    //        self.positionLab.backgroundColor = RGBCOLOR(199,0,17);
    //
    //        self.positionLab.attributedText = [Helper multiplicityText:@"0.00%" from:(int)@"0.00%".length-3 to:3 font:18];
    //    }
    //
    
    self.nickLab.text =[NSString stringWithFormat:@"%@", dict[@"nickName"]==nil?@"":dict[@"nickName"]];
    
    NSString *tempStr = [NSString stringWithFormat:@"%@  %@",@"最新买入",dict[@"stockName"]==nil?@"":dict[@"stockName"]];
    
    self.nearBuyLab.attributedText = [Helper multiplicityText:tempStr from:0 to:4 color:K_COLOR_CUSTEM(166, 166, 166, 1)];
    
    NSString *  timeStr = [NSString stringWithFormat:@"%@  %@",@"成交时间",dict[@"buyDate"]==nil?@"":dict[@"buyDate"]];
    self.timeLab.attributedText = [Helper multiplicityText:timeStr from:0 to:4 color:K_COLOR_CUSTEM(166, 166, 166, 1)];
    
    [self getStockNewPriceList:dict[@"orderList"]];
    
}
//获取一组股票快照

- (void )getStockNewPriceList:(NSArray *)dataArray
{
    _dataCenter = [h5DataCenterMgr sharedInstance].dataCenter;
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray * priceArray = [NSMutableArray array];
    
    for (NSDictionary * dic in dataArray) {
        HsStock * stock = [[HsStock alloc] init];
        stock.stockName = dic[@"stockName"]==nil?@"":dic[@"stockName"];
        stock.stockCode = dic[@"stockCode"]==nil?@"":dic[@"stockCode"];
        stock.codeType  = dic[@"typeCode"]==nil?@"":dic[@"typeCode"];
        
        [array addObject:stock];
    }
    
    FInacTableViewCell * finacCELL = self;
    [_dataCenter loadRealtimeList:array withHandleBlock:^(id data) {
        
        if ((NSNull*)data == [NSNull null] || data == nil || data ==NULL)
        {
//            NSLog(@"得到股票最新数据---%@ %@",data ,[data class]);
            
        }
        else
        {
            //        NSLog(@"%@",data);
            if (priceArray.count>0) {
                
                [priceArray removeAllObjects];
            }
            for (HsRealtime * realtime in data) {
                if (realtime.newPrice==0) {
                    realtime.newPrice = realtime.preClosePrice;
                }
                [priceArray addObject:realtime];
            }
            [finacCELL getearn:dataArray withPriceArray:priceArray];
        }
    }];
    
}


- (void)setPercentValue:(float)otherPercent
{
    
    
    NSString * positionText;
    if (otherPercent<0) {
        positionText = [NSString stringWithFormat:@"%.2f%%",otherPercent];
        self.positionLab.backgroundColor = K_COLOR_CUSTEM(8, 186, 66, 1);
        
    }else if(otherPercent == 0){
        positionText = [NSString stringWithFormat:@"+%.2f%%",otherPercent];
        self.positionLab.backgroundColor = K_COLOR_CUSTEM(110, 110, 110, 1);
        
    }else
    {
        positionText = [NSString stringWithFormat:@"+%.2f%%",otherPercent];
        self.positionLab.backgroundColor = RGBCOLOR(199,0,17);
    }
    self.positionLab.attributedText = [Helper multiplicityText:positionText from:(int)positionText.length-3 to:3 font:18];
}
- (void )getearn:(NSArray*)dataArray withPriceArray:(NSArray*)priceArray
{
    float buyValue = 0;
    float curValue = 0;
    float buyLossFund = 0;
    float earnPercent = 0.0;
    for (int i = 0; i<dataArray.count; i++) {
        
        ELOrderList * otherModel = [ELOrderList modelObjectWithDictionary:dataArray[i]];
        
        NSString * curPriceStr;
        
        //          NSString *curPriceStr;
        
        if (priceArray.count>0) {
            for (HsRealtime * realtime in priceArray) {
                
                
                if([realtime.code isEqualToString:otherModel.stockCode]){
                    
                    // 当前价
                    curPriceStr = [NSString stringWithFormat:@"%.2f",realtime.newPrice];
                    //
                    break;
                    
                };
            }
        }
        
        if ([curPriceStr isEqualToString:@"0.00"]) {
            earnPercent = 0.00;
        }else{
            
            curValue = curValue +curPriceStr.doubleValue *otherModel.factBuyCount;
            buyValue = buyValue + otherModel.buyPrice * otherModel.factBuyCount;
            buyLossFund = buyLossFund +otherModel.cashFund;
        }
        
    }
    if (buyLossFund ==0) {
        earnPercent = 0.00;
    }else{
        earnPercent = (curValue-buyValue)*100.0/buyLossFund;
        
        
    }
    
    [self setPercentValue:earnPercent];
    
}

- (NSString *)dateTransform:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [dateFormatter dateFromString:dateStr];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //    [self.timeLab setFrame:CGRectMake(ScreenWidth-self.timeLab.frame.size.width-20, self.timeLab.frame.origin.y, self.timeLab.frame.size.width, self.timeLab.frame.size.height)];
    //    [self.nickLab setFrame:CGRectMake(ScreenWidth-self.nickLab.frame.size.width-20, self.nickLab.frame.origin.y, self.nickLab.frame.size.width, self.nickLab.frame.size.height)];
    //    [self.nearBuyLab setFrame:CGRectMake(ScreenWidth-self.nearBuyLab.frame.size.width-20, self.nearBuyLab.frame.origin.y, self.nearBuyLab.frame.size.width, self.nearBuyLab.frame.size.height)];
}

@end
