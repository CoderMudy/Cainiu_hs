//
//  HsKlinePSY.h
//  QuoteWidget
//
//  Created by lihao on 14-10-8.
//  Copyright (c) 2014年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>
static int PSY_PARAM_VALUE[] = {12, 6};

@interface HsKlinePSY : NSObject
{
    NSMutableArray *_klineData;
    NSMutableArray *_PSYList;
    NSMutableArray *_PSYMAList;
    
}


-(void)setKlineData:(NSMutableArray*)klineData;

+(void)setParam:(int[])paramValue;

-(id)initWithKlineData:(NSMutableArray*)klineData;

-(int)getSize;
-(float)getPSY:(int)index;
-(float)getPSYMA:(int)index;

-(float)getPSYAndPSYMABottomValueFrom:(int)begin To:(int)end;
-(float)getPSYAndPSYMATopValueFrom:(int)begin To:(int)end;





@end
