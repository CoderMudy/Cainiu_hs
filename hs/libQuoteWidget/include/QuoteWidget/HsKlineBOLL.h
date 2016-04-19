//
//  HsKlineBOLL.h
//  QuoteWidget
//
//  Created by lihao on 14-10-10.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>
static int BOLLMA_PARAM = 20;
static int BOLLW_PARAM = 2;

typedef struct
{
    float       MB;
    float       UP;
    float       DN;
}BOLL_float;//布林线

@interface HsKlineBOLL : NSObject
{
    NSMutableArray      *_klineData;
    BOLL_float          *_bollData;
}

-(id)initWithKlineData:(NSMutableArray*)klineData;
-(void)setKlineData:(NSMutableArray*)klineData;


-(float)getBOLLDataUP:(int)index;
-(float)getBOLLDataDN:(int)index;
-(float)getBOLLDataMB:(int)index;

-(float)getMBTopValue;
-(float)getMBTopValueFrom:(int)begin To:(int)end;
-(float)getMBBottomValue;
-(float)getMBBottomValueFrom:(int)begin To:(int)end;
-(float)getUPTopValue;
-(float)getUPTopValueFrom:(int)begin To:(int)end;
-(float)getUPBottomValue;
-(float)getUPBottomValueFrom:(int)begin To:(int)end;
-(float)getDOWNTopValue;
-(float)getDOWNTopValueFrom:(int)begin To:(int)end;
-(float)getDOWNBottomValue;
-(float)getDOWNBottomValueFrom:(int)begin To:(int)end;

@end
