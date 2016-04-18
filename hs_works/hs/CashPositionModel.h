//
//  CashPositionModel.h
//  hs
//
//  Created by PXJ on 15/12/2.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CashPositionModel : NSObject

@property (nonatomic,strong)NSString * seriaNo;
@property (nonatomic,strong)NSString * orderType;
@property (nonatomic,strong)NSString * orderStatus;
@property (nonatomic,strong)NSString * buyOrSal;
@property (nonatomic,strong)NSString * wareId;
@property (nonatomic,strong)NSString * price;
@property (nonatomic,strong)NSString * upPrice;
@property (nonatomic,strong)NSString * downPrice;
@property (nonatomic,strong)NSString * num;
@property (nonatomic,strong)NSString * createTime;
@property (nonatomic,strong)NSString * realNum;
- (id)initWithDic:(NSDictionary*)dictionary;



@end
