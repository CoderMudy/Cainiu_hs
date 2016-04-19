//
//  HsKlineBIAS.h
//  QuoteWidget
//
//  Created by lihao on 14-10-11.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct
{
    float BIAS[3];
}BIAS_float;

static int BIAS1_PARAM = 6;
static int BIAS2_PARAM = 12;
static int BIAS3_PARAM = 24;



@interface HsKlineBIAS : NSObject
{
    NSMutableArray      *_klineData;
    BIAS_float          *_biasData;
}

-(id)initWithKlineData:(NSMutableArray*)klineData;
-(void)setKlineData:(NSMutableArray*)klineData;

-(float)getBIAS1:(int)index;
-(float)getBIAS2:(int)index;
-(float)getBIAS3:(int)index;

-(float)getBIASTopValue:(int)type From:(int)begin To:(int)end;
-(float)getBIASBottomValue:(int)type From:(int)begin To:(int)end;

@end
