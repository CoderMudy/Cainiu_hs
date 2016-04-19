//
//  HsKlineRSI.h
//  QuoteWidget
//
//  Created by lihao on 14-10-8.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>

static int RSI_PARAM_VALUE_DEFAULT[] = {6, 12, 24};
static int* RSI_PARAM_VALUE = RSI_PARAM_VALUE_DEFAULT;

@interface HsKlineRSI : NSObject
{
    NSMutableArray *_klineData;
    NSMutableArray *_rsiDataList;
}

-(void)setKlineData:(NSMutableArray*)klineData;

+(void)setParam:(int*)params;

-(id)initWithKlineData:(NSMutableArray*)klineData;

-(NSMutableArray*)getRSIList:(int)type;
-(float)getRSI:(int)type At:(int)index;
-(float)getRSITopValue:(int)type From:(int)begin To:(int)end;
-(float)getRSIBottomValue:(int)type From:(int)begin To:(int)end;

@end
