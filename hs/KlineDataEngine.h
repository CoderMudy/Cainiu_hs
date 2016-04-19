//
//  KlineDataEngine.h
//  hs
//
//  Created by RGZ on 15/11/11.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KlineDataEngine : NSObject

+(void)klineDataFactory:(NSMutableArray *)klineDataArray WithInstrumentID:(NSString *)instrumentID completeBlock:(void(^)())successBolck;

+(NSString *)lastKLineTimeWithInstrumentID:(NSString *)instrumentID;

+(NSMutableArray *)getAllKLineDataWithInstrumentID:(NSString *)instrumentID;

@end
