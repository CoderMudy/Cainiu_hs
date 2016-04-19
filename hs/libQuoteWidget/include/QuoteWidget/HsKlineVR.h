//
//  HsKlineVR.h
//  QuoteWidget
//
//  Created by lihao on 14-10-10.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>
static int   VR_PARAM = 24;

typedef struct
{
    float VR;
}VR_float;


@interface HsKlineVR : NSObject
{
    NSMutableArray  *_klineData;
    VR_float        *_vrData;
}

-(void)setKlineData:(NSMutableArray*)klineData;

-(id)initWithKlineData:(NSMutableArray*)klineData;

-(float)getVR:(int)index;

-(float)getVRTopValue;
-(float)getVRTopValueFrom:(int)begin To:(int)end;
-(float)getVRBottomValue;
-(float)getVRBottomValueFrom:(int)begin To:(int)end;

@end
