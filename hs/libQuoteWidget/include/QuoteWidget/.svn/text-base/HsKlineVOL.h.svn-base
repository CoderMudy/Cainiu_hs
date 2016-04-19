//
//  HsKlineVOL.h
//  QuoteWidget
//
//  Created by lihao on 14-10-11.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>
static int VOLMA1_PARAM = 5;
static int VOLMA2_PARAM = 10;
static int VOLMA3_PARAM = 20;

typedef struct
{
    float MAVOL5;
    float MAVOL10;
    float MAVOL20;
}VOLHS_float;


@interface HsKlineVOL : NSObject
{
    NSMutableArray      *_klineData;
    VOLHS_float         *_volhsData;
}

-(id)initWithKlineData:(NSMutableArray*)klineData;
-(void)setKlineData:(NSMutableArray*)klineData;

-(float)getVOL5:(int)index;
-(float)getVOL10:(int)index;
-(float)getVOL20:(int)index;

-(float)getVOL5TopValueFrom:(int)begin To:(int)end;
-(float)getVOL5BottomValueFrom:(int)begin To:(int)end;
-(float)getVOL10TopValueFrom:(int)begin To:(int)end;
-(float)getVOL10BottomValueFrom:(int)begin To:(int)end;
-(float)getVOL20TopValueFrom:(int)begin To:(int)end;
-(float)getVOL20BottomValueFrom:(int)begin To:(int)end;

@end
