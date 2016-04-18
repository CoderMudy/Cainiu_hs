//
//  FiveMarketModel.h
//  hs
//
//  Created by Xse on 15/12/21.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FiveMarketModel : NSObject

@property(nonatomic,strong) NSString *salePrice;
@property(nonatomic,strong) NSString *saleVolume;
@property(nonatomic,strong) NSString *saleNum;

@property(nonatomic,strong) NSString *buyPrice;
@property(nonatomic,strong) NSString *buyVolume;
@property(nonatomic,strong) NSString *buyNum;

- (instancetype)initWithBookseaDic:(NSMutableDictionary *)saleDic buyDic:(NSMutableDictionary *)buydic;
//- (instancetype)initWithBookseaDic:(NSMutableDictionary *)buyDic;

@end
