//
//  HsKlineASI.h
//  QuoteWidget
//
//  Created by lihao on 14-10-10.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct
{
    float ASI;
    float ASIMA;
}ASI_float;

@interface HsKlineASI : NSObject
{
    NSMutableArray  *_klineData;
    ASI_float       *_asiData;
}

-(void)setKlineData:(NSMutableArray*)klineData;

-(id)initWithKlineData:(NSMutableArray*)klineData;

-(float)getASI:(int)index;
-(float)getASIMA:(int)index;

-(float)getASITopValue;
-(float)getASITopValueFrom:(int)begin To:(int)end;
-(float)getASIBottomValue;
-(float)getASIBottomValueFrom:(int)begin To:(int)end;
-(float)getASIMATopValue;
-(float)getASIMATopValueFrom:(int)begin To:(int)end;
-(float)getASIMABottomValue;
-(float)getASIMABottomValueFrom:(int)begin To:(int)end;

@end
