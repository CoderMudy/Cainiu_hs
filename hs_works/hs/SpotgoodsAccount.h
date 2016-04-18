//
//  SpotgoodsAccount.h
//  hs
//
//  Created by RGZ on 15/11/30.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpotgoodsModel.h"

@interface SpotgoodsAccount : NSObject
AS_SINGLETON(SpotgoodsAccount)

@property (nonatomic,strong)SpotgoodsModel  *spotgoodsModel;

-(NSString *)getSpotgoodsToken;

-(NSString *)getHttpToken;

-(BOOL)isNeedLogin;

-(void)clearInfo;

-(NSString  *)getPassword;

-(NSString  *)getUsername;

-(NSString *)getTradeID;

-(BOOL)isNeedRegist;

@end
