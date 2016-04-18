//
//  FiveMarketModel.m
//  hs
//
//  Created by Xse on 15/12/21.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import "FiveMarketModel.h"

@implementation FiveMarketModel

- (instancetype)initWithBookseaDic:(NSMutableDictionary *)saleDic buyDic:(NSMutableDictionary *)buydic
{
    self = [super init];
    if (self)
    {
        _salePrice      = saleDic[@"salePrice"];
        _saleVolume     = saleDic[@"saleVolume"];
        _saleNum        = saleDic[@"saleNum"];
        
        _buyPrice       = buydic[@"buyPrice"];
        _buyVolume      = buydic[@"buyVolume"];
        _buyNum         = buydic[@"buyNum"];
    }
    return self;
}

@end
