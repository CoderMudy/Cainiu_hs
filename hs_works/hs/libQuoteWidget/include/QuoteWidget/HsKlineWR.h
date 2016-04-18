//
//  HsKlineWR.h
//  QuoteWidget
//
//  Created by lihao on 14-10-11.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>
static int WR1_PARAM = 14;
static int WR2_PARAM = 28;

typedef struct
{
    float		W_R;
    float		W_R2;
} WR_float;//威廉%R指标

@interface HsKlineWR : NSObject
{
    NSMutableArray      *_klineData;
    WR_float            *_wrData;
}

-(id)initWithKlineData:(NSMutableArray*)klineData;
-(void)setKlineData:(NSMutableArray*)klineData;

-(float)getWR1:(int)index;
-(float)getWR2:(int)index;

-(float)getWR1TopValueFrom:(int)begin To:(int)end;
-(float)getWR2TopValueFrom:(int)begin To:(int)end;
-(float)getWR1BottomValueFrom:(int)begin To:(int)end;
-(float)getWR2BottomValueFrom:(int)begin To:(int)end;


@end
