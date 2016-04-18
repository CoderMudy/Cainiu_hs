//
//  AccountModel.h
//  hs
//
//  Created by PXJ on 16/2/24.
//  Copyright © 2016年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountModel : NSObject

@property (nonatomic,strong)NSString * code;
@property (nonatomic,strong)NSString * amt;
@property (nonatomic,strong)NSString * floatAmt;
@property (nonatomic,strong)NSString * status;
@property (nonatomic,strong)NSString * type;
@property (nonatomic,strong)NSString * imgUrl;
@property (nonatomic,strong)NSString * url;
@property (nonatomic,strong)NSString * name;

+(id)accountModelWithDictionary:(NSDictionary*)dictionary;

@end
