//
//  HsKlineOBV.h
//  QuoteWidget
//
//  Created by lihao on 14-10-11.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct
{
    float OBV;
}OBV_float;


@interface HsKlineOBV : NSObject
{
    NSMutableArray      *_klineData;
    OBV_float           *_obvData;
}

-(id)initWithKlineData:(NSMutableArray*)klineData;
-(void)setKlineData:(NSMutableArray*)klineData;

-(float)getOBV:(int)index;

-(float)getOBVTopValue;
-(float)getOBVTopValueFrom:(int)begin To:(int)end;
-(float)getOBVBottomValue;
-(float)getOBVBottomValueFrom:(int)begin To:(int)end;

@end
