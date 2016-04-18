//
//  HsKlineCCI.h
//  QuoteWidget
//
//  Created by lihao on 14-10-13.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>
static int CCI_PARAM = 14;

typedef struct
{
    float CCI;
}CCI_float;


@interface HsKlineCCI : NSObject
{
    NSMutableArray      *_klineData;
    CCI_float           *_cciData;
}

-(id)initWithKlineData:(NSMutableArray*)klineData;
-(void)setKlineData:(NSMutableArray*)klineData;

-(float)getCCI:(int)index;

-(float)getCCIBottomValue;
-(float)getCCIBottomValueFrom:(int)begin To:(int)end;

-(float)getCCITopValue;
-(float)getCCITopValueFrom:(int)begin To:(int)end;

@end
