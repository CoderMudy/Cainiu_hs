//
//  TiXianListModel.h
//  hs
//
//  Created by Xse on 15/10/20.
//  Copyright © 2015年 luckin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TiXianListModel : NSObject

@property(nonatomic,strong) NSString *tixianMoney;//提现金额
@property(nonatomic,strong) NSString *time;//时间
@property(nonatomic,strong) NSString *tixianCancel;//提现撤回
@property(nonatomic,assign) NSInteger examineStatus;//提现审核状态
@property(nonatomic,strong) NSString *recodeId;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
