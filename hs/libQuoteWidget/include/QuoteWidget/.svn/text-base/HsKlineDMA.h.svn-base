//
//  HsKlineDMA.h
//  QuoteWidget
//
//  Created by lihao on 14-10-11.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>

static int DMAshortMa_PARAM = 10;
static int DMAlongMa_PARAM = 50;
static int DMAdddMa_PARAM = 10;

typedef struct
{
    float DDD;
    float AMA;
}DMA_float;

@interface HsKlineDMA : NSObject
{
    NSMutableArray      *_klineData;
    DMA_float           *_dmaData;
}


-(id)initWithKlineData:(NSMutableArray*)klineData;
-(void)setKlineData:(NSMutableArray*)klineData;

-(float)getDMA_AMA:(int)index;
-(float)getDMA_DDD:(int)index;

-(float)getAMATopValue;
-(float)getAMATopValueFrom:(int)begin To:(int)end;
-(float)getAMABottomValue;
-(float)getAMABottomValueFrom:(int)begin To:(int)end;
-(float)getDDDTopValue;
-(float)getDDDTopValueFrom:(int)begin To:(int)end;
-(float)getDDDBottomValue;
-(float)getDDDBottomValueFrom:(int)begin To:(int)end;

@end
